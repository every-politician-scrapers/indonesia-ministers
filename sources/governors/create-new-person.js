const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (label,position,start) => {
  mem = {
    value: position,
    qualifiers: { P580: start || '2020-07-27' },
    references: {
      P4656: meta.source,
      P813:  new Date().toISOString().split('T')[0],
      P1810: label,
    }
  }

  claims = {
    P31: { value: 'Q5' }, // human
    P106: { value: 'Q82955' }, // politician
    P39: mem,
  }

  return {
    type: 'item',
    labels: { en: label },
    descriptions: { en: 'politician in Sudan' },
    claims: claims,
  }
}
