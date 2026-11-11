import fs from 'node:fs';
import path from 'node:path';
import { execFileSync } from 'node:child_process';

const root = path.resolve('.');
const srcPath = path.join(root, 'icons', 'icon-source.jpg');
const psScript = path.join(root, 'tools', 'generate-icons.ps1');

if (fs.existsSync(srcPath)) {
  if (process.platform === 'win32') {
    try {
      console.log('Regenerating icons from icons/icon-source.jpg via PowerShell...');
      execFileSync('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', psScript], {
        stdio: 'inherit'
      });
      console.log('Icon generation complete.');
      process.exit(0);
    } catch (err) {
      console.error('Failed to run generate-icons.ps1:', err);
      process.exit(1);
    }
  } else {
    console.log('icons/icon-source.jpg exists. On non-Windows platforms, use an image tool or sharp to resize to 192/512 png and favicon.ico.');
    process.exit(0);
  }
} else {
  console.error('Source icon not found at icons/icon-source.jpg');
  process.exit(1);
}
