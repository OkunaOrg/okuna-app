const path = require('path');
const fs = require('fs');

const I18N_PATH = path.join(__dirname, '..', 'assets', 'i18n');

const unify = (lang, files) => {
  const obj = {};

  files.forEach(file => {
    const contents = fs.readFileSync(path.join(I18N_PATH, lang, file), { encoding: 'utf8' });
    const json = JSON.parse(contents);

    const mainKey = path.basename(file).split('.')[0];

    Object.keys(json).forEach(key => {
      const newKey = key.startsWith('@')
        ? `@${mainKey}__${key.replace('@', '')}`
        : `${mainKey}__${key}`;
      obj[newKey] = json[key];
    });
  })

  return obj;
};

const langs = fs.readdirSync(I18N_PATH);

langs.forEach(lang => {
  if (!fs.statSync(path.join(I18N_PATH, lang)).isDirectory()) {
    return;
  }

  const files = fs.readdirSync(path.join(I18N_PATH, lang));
  const langObj = unify(lang, files);
  const output = JSON.stringify(langObj, null, 2);

  fs.writeFileSync(path.join(I18N_PATH, `intl_${lang}.arb`), output, { encoding: 'utf8' });

  console.log(`Built locale ${lang}.`);
});

console.log('Done!');
