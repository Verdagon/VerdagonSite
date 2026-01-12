import { readFileSync, writeFileSync } from 'fs';

const filePath = process.argv[2];
if (!filePath) {
  console.error('Usage: node cleanup-duplicates.js <file.vmd>');
  process.exit(1);
}

const content = readFileSync(filePath, 'utf8');
const lines = content.split('\n');

// Find all </ignore> lines
const ignoreEndLines = [];
for (let i = 0; i < lines.length; i++) {
  if (lines[i].trim() === '</ignore>') {
    ignoreEndLines.push(i);
  }
}

console.log(`Found ${ignoreEndLines.length} </ignore> tags`);

// For each </ignore>, keep only the FIRST <pre> block after it and remove any others
const linesToRemove = new Set();

for (const ignoreEndLine of ignoreEndLines) {
  let firstPreFound = false;
  let inPreBlock = false;
  let preStartLine = -1;

  // Scan lines after </ignore>
  for (let i = ignoreEndLine + 1; i < lines.length; i++) {
    const line = lines[i].trim();

    // Stop if we hit another </ignore> or <ignore>
    if (line === '</ignore>' || line === '<ignore>') {
      break;
    }

    // Check for <pre> start
    if (line.startsWith('<pre')) {
      if (!firstPreFound) {
        // This is the first one, keep it
        firstPreFound = true;
        inPreBlock = true;
        preStartLine = i;
        console.log(`  Keeping <pre> block at line ${i + 1}`);
      } else {
        // This is a duplicate, mark for removal
        inPreBlock = true;
        preStartLine = i;
        console.log(`  Removing duplicate <pre> block starting at line ${i + 1}`);
      }
    }

    // Check for </pre> end
    if (line.includes('</code></pre>')) {
      if (inPreBlock && preStartLine !== -1 && firstPreFound && preStartLine !== (ignoreEndLine + 1) && preStartLine !== (ignoreEndLine + 2) && preStartLine !== (ignoreEndLine + 3)) {
        // This is a duplicate block, mark all lines for removal
        for (let j = preStartLine; j <= i; j++) {
          linesToRemove.add(j);
        }
      }
      inPreBlock = false;
      preStartLine = -1;
    }
  }
}

// Remove marked lines
const newLines = lines.filter((_, index) => !linesToRemove.has(index));

console.log(`Removed ${linesToRemove.size} duplicate lines`);

writeFileSync(filePath, newLines.join('\n'), 'utf8');
console.log(`✓ Cleaned up ${filePath}`);
