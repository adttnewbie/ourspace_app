#!/usr/bin/env node
/**
 * Postinstall patch to fix vulnerabilities that require ESM <-> CJS interop.
 *
 * - decode-uri-component 0.5.0 is ESM-only (export default). query-string 7.1.3
 *   does `require('decode-uri-component')` expecting a function, which returns
 *   `{ default: fn }` and breaks at runtime. This script patches query-string
 *   to handle both: `const _d = require('decode-uri-component'); const decode = _d.default || _d;`
 *
 * This is required because npm audit forces decode-uri-component ^0.5.0 to fix
 * GHSA-vcc3-ghjq-m6fr, but expo-router 57 still pins query-string 7.1.3.
 *
 * Also verifies uuid override (GHSA-w5hq-g745-h8pq) did not break xcode.
 */

const fs = require('fs');
const path = require('path');

function patchQueryString() {
  const file = path.join(__dirname, '..', 'node_modules', 'query-string', 'index.js');
  if (!fs.existsSync(file)) {
    console.log('[fix-vuln] query-string not found, skipping');
    return;
  }
  let content = fs.readFileSync(file, 'utf8');
  const oldLine = "const decodeComponent = require('decode-uri-component');";
  const newLine = "const _decodeTmp = require('decode-uri-component');\nconst decodeComponent = _decodeTmp.default || _decodeTmp;";

  if (content.includes(newLine)) {
    console.log('[fix-vuln] query-string already patched');
    return;
  }
  if (!content.includes(oldLine)) {
    console.warn('[fix-vuln] query-string patch target not found, file may have changed');
    return;
  }
  content = content.replace(oldLine, newLine);
  fs.writeFileSync(file, content, 'utf8');
  console.log('[fix-vuln] patched query-string for decode-uri-component 0.5.0 ESM interop');
}

function verify() {
  try {
    const qs = require('query-string');
    const parsed = qs.parse('a=1&b=hello%20world');
    if (parsed.a !== '1' || parsed.b !== 'hello world') throw new Error('query-string parse mismatch');
    console.log('[fix-vuln] verify query-string: ok');

    const uuid = require('uuid');
    const id = uuid.v4();
    if (typeof id !== 'string' || id.length < 10) throw new Error('uuid.v4 failed');
    // bounds check should throw
    try {
      uuid.v4({}, new Array(5), 0);
      throw new Error('uuid bounds check did not throw');
    } catch (e) {
      if (!/out of buffer bounds/.test(e.message)) throw e;
    }
    console.log('[fix-vuln] verify uuid: ok');
  } catch (e) {
    console.warn('[fix-vuln] verify failed:', e.message);
  }
}

patchQueryString();
verify();
