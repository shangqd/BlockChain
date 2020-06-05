// npm install keythereum
var keyth = require('keythereum');
var keyobj = keyth.importFromFile('0xaf7229806ccfdf1b63458904a3752827de5869ff','/home/shang/geth/data');
var privateKey = keyth.recover('123456',keyobj);
console.log(privateKey.toString('hex'));
