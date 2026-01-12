import textmateModule from 'vscode-textmate';
import onigurumaModule from 'vscode-oniguruma';
import { readFileSync, writeFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const { Registry } = textmateModule;
const { loadWASM, OnigScanner, OnigString } = onigurumaModule;

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Simplified color scheme based on GitHub Dark
const colorMap = {
  'source.mojo': '#c9d1d9',
  'storage.type': '#ff7b72',
  'storage.modifier': '#ff7b72',
  'keyword': '#ff7b72',
  'keyword.control': '#ff7b72',
  'entity.name.function': '#d2a8ff',
  'entity.name.type': '#ffa657',
  'variable': '#79c0ff',
  'variable.parameter': '#ffa657',
  'string': '#a5d6ff',
  'string.quoted': '#a5d6ff',
  'comment': '#8b949e',
  'comment.line': '#8b949e',
  'punctuation.definition.comment': '#8b949e',
  'constant.numeric': '#79c0ff',
  'constant.language': '#79c0ff',
  'support.function': '#d2a8ff',
  'support.type': '#ffa657',
  'meta.function-call': '#d2a8ff',
  'punctuation': '#c9d1d9',
};

function getColor(scopes) {
  // Try to find the most specific scope that has a color
  for (let i = scopes.length - 1; i >= 0; i--) {
    const scope = scopes[i];
    if (colorMap[scope]) {
      return colorMap[scope];
    }
    // Try partial matches
    for (const [key, value] of Object.entries(colorMap)) {
      if (scope.startsWith(key)) {
        return value;
      }
    }
  }
  return '#c9d1d9'; // default color
}

function escapeHtml(text) {
  return text
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;')
    .replace(/\[/g, '&#91;')
    .replace(/_/g, '&#95;');
}

function highlightMojoCode(code, grammar) {
  const lines = code.split('\n');
  let ruleStack = null;
  let htmlLines = [];

  for (const line of lines) {
    // Handle empty lines specially
    if (line.trim() === '') {
      htmlLines.push('<span></span>');
      continue;
    }

    const result = grammar.tokenizeLine(line, ruleStack);
    ruleStack = result.ruleStack;

    let htmlLine = '';
    let lastEnd = 0;

    for (const token of result.tokens) {
      const text = line.substring(lastEnd, token.endIndex);
      const color = getColor(token.scopes);
      htmlLine += `<span style="color: ${color}">${escapeHtml(text)}</span>`;
      lastEnd = token.endIndex;
    }

    htmlLines.push(htmlLine);
  }

  return htmlLines.join('\n');
}

function findMojoBlocks(content) {
  const blocks = [];
  const lines = content.split('\n');
  let i = 0;

  while (i < lines.length) {
    // Look for <ignore> line
    if (lines[i].trim() === '<ignore>') {
      const ignoreStartLine = i;
      i++;

      // Next line should be ```mojo
      if (i < lines.length && lines[i].trim() === '```mojo') {
        const codeStartLine = i + 1;
        i++;

        // Find the closing ```
        let codeEndLine = -1;
        while (i < lines.length) {
          if (lines[i].trim() === '```') {
            codeEndLine = i - 1;
            i++;
            break;
          }
          i++;
        }

        if (codeEndLine === -1) {
          throw new Error(`Found \`\`\`mojo at line ${codeStartLine} but no closing \`\`\``);
        }

        // Next line should be </ignore>
        if (i >= lines.length || lines[i].trim() !== '</ignore>') {
          throw new Error(`Found closing \`\`\` at line ${codeEndLine + 2} but no </ignore> after it. This is required!`);
        }

        const ignoreEndLine = i;

        // Extract the code
        const code = lines.slice(codeStartLine, codeEndLine + 1).join('\n');

        blocks.push({
          ignoreStartLine,
          ignoreEndLine,
          codeStartLine,
          codeEndLine,
          code
        });
      }
    }
    i++;
  }

  return blocks;
}

function replaceOrInsertHighlightedBlock(lines, block, highlightedHtml) {
  const afterIgnoreLine = block.ignoreEndLine + 1;

  // Check if there are blank lines after </ignore>
  let searchStartLine = afterIgnoreLine;
  while (searchStartLine < lines.length && lines[searchStartLine].trim() === '') {
    searchStartLine++;
  }

  // Check if there's already a <pre> block (with or without styling)
  if (searchStartLine < lines.length && lines[searchStartLine].trim().startsWith('<pre')) {
    // Find the end of the existing block
    let preEndLine = searchStartLine;
    while (preEndLine < lines.length) {
      if (lines[preEndLine].includes('</code></pre>')) {
        break;
      }
      preEndLine++;
    }

    // Replace the existing block
    const newBlock = `<pre style="background-color: black; padding: 16px; font-size: 80%; overflow-x: auto;"><code class="nohighlight">${highlightedHtml}</code></pre>`;
    lines.splice(searchStartLine, preEndLine - searchStartLine + 1, newBlock);

    return preEndLine - searchStartLine + 1; // Return how many lines were replaced
  } else {
    // Insert a new block after </ignore> with blank lines
    const newBlock = [
      '',
      '',
      `<pre style="background-color: black; padding: 16px; font-size: 80%; overflow-x: auto;"><code class="nohighlight">${highlightedHtml}</code></pre>`
    ];
    lines.splice(afterIgnoreLine, 0, ...newBlock);

    return -newBlock.length; // Return negative to indicate lines were inserted
  }
}

async function processVmdFile(filePath) {
  console.log(`Processing ${filePath}...`);

  // Initialize Oniguruma
  console.log('Initializing Oniguruma...');
  const wasmBin = readFileSync(join(__dirname, 'node_modules/vscode-oniguruma/release/onig.wasm')).buffer;
  await loadWASM(wasmBin);

  // Load Mojo grammar
  console.log('Loading Mojo grammar...');
  const grammarJson = JSON.parse(readFileSync(join(__dirname, 'mojo.syntax.json'), 'utf8'));

  const registry = new Registry({
    onigLib: Promise.resolve({
      createOnigScanner(patterns) { return new OnigScanner(patterns); },
      createOnigString(str) { return new OnigString(str); }
    }),
    loadGrammar: async (scopeName) => {
      if (scopeName === 'source.mojo') {
        return grammarJson;
      }
      return null;
    }
  });

  const grammar = await registry.loadGrammar('source.mojo');
  if (!grammar) {
    throw new Error('Failed to load grammar');
  }

  // Read the .vmd file
  const content = readFileSync(filePath, 'utf8');
  const lines = content.split('\n');

  // Find all Mojo blocks
  console.log('Finding Mojo code blocks...');
  const blocks = findMojoBlocks(content);
  console.log(`Found ${blocks.length} block(s) to process`);

  if (blocks.length === 0) {
    console.log('No blocks found. Nothing to do.');
    return;
  }

  // Process blocks in reverse order so line numbers don't shift
  for (let i = blocks.length - 1; i >= 0; i--) {
    const block = blocks[i];
    console.log(`Processing block ${i + 1}/${blocks.length} (lines ${block.codeStartLine + 1}-${block.codeEndLine + 1})...`);

    // Highlight the code
    const highlightedHtml = highlightMojoCode(block.code, grammar);

    // Replace or insert the highlighted block
    const linesChanged = replaceOrInsertHighlightedBlock(lines, block, highlightedHtml);
    if (linesChanged > 0) {
      console.log(`  Replaced existing highlighted block (${linesChanged} lines)`);
    } else {
      console.log(`  Inserted new highlighted block (${-linesChanged} lines)`);
    }
  }

  // Write back to file
  const newContent = lines.join('\n');
  writeFileSync(filePath, newContent, 'utf8');
  console.log(`✓ Updated ${filePath}`);
}

// Main execution
const args = process.argv.slice(2);
if (args.length === 0) {
  console.error('Error: No file specified');
  console.error('Usage: node highlight.js <file.vmd>');
  process.exit(1);
}

const filePath = args[0];
processVmdFile(filePath).catch(error => {
  console.error('Error:', error.message);
  process.exit(1);
});
