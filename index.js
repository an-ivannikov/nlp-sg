const fs = require('fs');
const glob = require('glob');
const TurndownService = require('turndown');

const turndownService = new TurndownService();



glob('**/*.html', {}, (err, files) => { //
  files.forEach((path) => {
    const html = fs.readFileSync(path, { encoding: 'utf8' });
    const markdown = turndownService.turndown(html);
    fs.appendFileSync('test.md', markdown, { encoding: 'utf8' });
  });
  console.log('**/*.html - done');
});
