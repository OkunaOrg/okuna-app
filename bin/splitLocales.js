const path = require('path');
const fs = require('fs');

const I18N_PATH = path.join(__dirname, '..', 'assets', 'i18n');

const contents = fs.readFileSync(path.join(I18N_PATH, 'intl_messages.arb'), { encoding: 'utf8' });
const json = JSON.parse(contents);

const translationStrings = {};
const mainKeys = [];

Object.keys(json).forEach(key => {
  const mainKey = key.split('__')[0];
  const translationKey = key.split('__').splice(1).join('__');

  if (!translationStrings[mainKey]) {
    translationStrings[mainKey] = {};
  }

  translationStrings[mainKey][translationKey] = json[key];

  if (!mainKey.startsWith('@') && !mainKeys.includes(mainKey)) {
    mainKeys.push(mainKey);
  }
});

mainKeys.forEach(mainKey => {
  const output = {};
  const current = translationStrings[mainKey];

  Object.keys(current).forEach(key => {
    output[key] = current[key];
    output[`@${key}`] = translationStrings[`@${mainKey}`][key];
  });

  const str = JSON.stringify(output, null, 2);
  fs.writeFileSync(path.join(I18N_PATH, 'en', `${mainKey}.arb`), str, { encoding: 'utf8' });

  console.log(`Generated ${mainKey}.arb!`);
});

console.log('Done!');
