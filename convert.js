const fs = require('fs');
const glob = require('glob');
const Iconv = require('iconv').Iconv;



const convertReadMe = () => {
  const path = 'Res/ReadMe.txt';
  const buf = fs.readFileSync(path, { encoding: null });
  const conv = Iconv('windows-1251', 'utf8');
  const str = conv.convert(buf).toString();
  fs.writeFileSync(path, str, { encoding: 'utf8' });
  console.log('Res/ReadMe.txt - done');
}
convertReadMe();

glob('**/*.html', {}, (err, files) => { //
  files.forEach((path) => {
    const buf = fs.readFileSync(path, { encoding: null });
    const conv = Iconv('windows-1251', 'utf8');
    let str = conv.convert(buf).toString();
    str = str.replace('CHARSET=windows-1251', 'CHARSET=utf-8', 'gim');
    fs.writeFileSync(path, str, { encoding: 'utf8' });
  });
  console.log('**/*.html - done');
});

glob('**/*.dat', {}, (err, files) => {
  files.forEach((path) => {
    const buf = fs.readFileSync(path, { encoding: null });
    const conv = Iconv('windows-1251', 'utf8');
    let str = conv.convert(buf).toString();
    str = str.replace('CHARSET=windows-1251', 'CHARSET=utf-8', 'gim');
    fs.writeFileSync(path, str, { encoding: 'utf8' });
  });
  console.log('**/*.dat - done');
});
