const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (id, label, cabinet, startdate, enddate) => {
  qualifier = { }
  if(startdate) qualifier['P580']  = startdate
  if(enddate)   qualifier['P582']  = enddate
  if(cabinet)   qualifier['P5054'] = cabinet

  return {
    id,
    claims: {
      P39: {
        value: meta.position,
        qualifiers: qualifier,
        references: {
          P4656: meta.source,
          P813: new Date().toISOString().split('T')[0],
          P1810: label,
        }
      }
    }
  }
}