import textmateModule from 'vscode-textmate';
import onigurumaModule from 'vscode-oniguruma';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const { Registry } = textmateModule;
const { loadWASM, OnigScanner, OnigString } = onigurumaModule;

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

async function testTokenize() {
  const wasmBin = readFileSync(join(__dirname, 'node_modules/vscode-oniguruma/release/onig.wasm')).buffer;
  await loadWASM(wasmBin);

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

  const testLine = 'fn matches(text: String) -> Bool:';
  const result = grammar.tokenizeLine(testLine, null);

  console.log(`\nTokenizing: "${testLine}"\n`);
  result.tokens.forEach(token => {
    const text = testLine.substring(token.startIndex, token.endIndex);
    console.log(`"${text}"`);
    console.log(`  Scopes: ${token.scopes.join(' > ')}`);
    console.log('');
  });
}

testTokenize().catch(console.error);
