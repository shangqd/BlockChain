// npm install web3
var Web3 = require('web3');
var keyth = require('keythereum');

if (typeof web3 !== 'undefined') {
  web3 = new Web3(web3.currentProvider);
} else {
  web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}

var abi = [{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"dog","type":"address"}],"name":"selectDog","outputs":[{"name":"user","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"dog","type":"address"}],"name":"createDog","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"user","type":"address"},{"name":"dog","type":"address"}],"name":"transferDog","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[{"name":"initialSupply","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_user","type":"address"},{"indexed":true,"name":"_dog","type":"address"}],"name":"CreateDog","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":true,"name":"_dog","type":"address"}],"name":"TransferDog","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":true,"name":"_spender","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Approval","type":"event"}];


function init(){
	initialSupply = 10000000000;
	Contract = web3.eth.contract(abi);

	hello = Contract.new(
   	initialSupply,
   	{
     		from: web3.eth.accounts[0], 
     		data: '0x60806040526040805190810160405280600b81526020017f456e637279707420646f67000000000000000000000000000000000000000000815250600190805190602001906200005192919062000158565b506012600260006101000a81548160ff021916908360ff1602179055506040805190810160405280600381526020017f444f47000000000000000000000000000000000000000000000000000000000081525060039080519060200190620000bb92919062000158565b50348015620000c957600080fd5b50604051602080620012ec83398101806040528101908080519060200190929190505050600260009054906101000a900460ff1660ff16600a0a8102600081905550600054600460003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055505062000207565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f106200019b57805160ff1916838001178555620001cc565b82800160010185558215620001cc579182015b82811115620001cb578251825591602001919060010190620001ae565b5b509050620001db9190620001df565b5090565b6200020491905b8082111562000200576000816000905550600101620001e6565b5090565b90565b6110d580620002176000396000f3006080604052600436106100ba576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806306fdde03146100bf578063095ea7b31461014f57806318160ddd146101b457806323b872dd146101df578063313ce567146102645780634a34dcc0146102955780636d0e4c081461031857806370a082311461037357806395d89b41146103ca578063a9059cbb1461045a578063dd62ed3e146104bf578063eea4895614610536575b600080fd5b3480156100cb57600080fd5b506100d46105b1565b6040518080602001828103825283818151815260200191508051906020019080838360005b838110156101145780820151818401526020810190506100f9565b50505050905090810190601f1680156101415780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34801561015b57600080fd5b5061019a600480360381019080803573ffffffffffffffffffffffffffffffffffffffff1690602001909291908035906020019092919050505061064f565b604051808215151515815260200191505060405180910390f35b3480156101c057600080fd5b506101c9610741565b6040518082815260200191505060405180910390f35b3480156101eb57600080fd5b5061024a600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080359060200190929190505050610747565b604051808215151515815260200191505060405180910390f35b34801561027057600080fd5b506102796109b3565b604051808260ff1660ff16815260200191505060405180910390f35b3480156102a157600080fd5b506102d6600480360381019080803573ffffffffffffffffffffffffffffffffffffffff1690602001909291905050506109c6565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b34801561032457600080fd5b50610359600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050610a2f565b604051808215151515815260200191505060405180910390f35b34801561037f57600080fd5b506103b4600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050610b99565b6040518082815260200191505060405180910390f35b3480156103d657600080fd5b506103df610be2565b6040518080602001828103825283818151815260200191508051906020019080838360005b8381101561041f578082015181840152602081019050610404565b50505050905090810190601f16801561044c5780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34801561046657600080fd5b506104a5600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080359060200190929190505050610c80565b604051808215151515815260200191505060405180910390f35b3480156104cb57600080fd5b50610520600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050610e8a565b6040518082815260200191505060405180910390f35b34801561054257600080fd5b50610597600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050610f11565b604051808215151515815260200191505060405180910390f35b60018054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156106475780601f1061061c57610100808354040283529160200191610647565b820191906000526020600020905b81548152906001019060200180831161062a57829003601f168201915b505050505081565b600081600560003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055508273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925846040518082815260200191505060405180910390a36001905092915050565b60005481565b600081600460008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205410158015610814575081600560008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205410155b151561081f57600080fd5b81600460008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254019250508190555081600460008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254039250508190555081600560008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600082825403925050819055508273ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef846040518082815260200191505060405180910390a3600190509392505050565b600260009054906101000a900460ff1681565b6000600660008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050919050565b600080600660008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff161415610b8f5733600660008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508173ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff167f2f8f3c75b9f880f768dd36c50537d80d721be76707b63b3da96625e947e6abf360405160405180910390a360019050610b94565b600090505b919050565b6000600460008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020549050919050565b60038054600181600116156101000203166002900480601f016020809104026020016040519081016040528092919081815260200182805460018160011615610100020316600290048015610c785780601f10610c4d57610100808354040283529160200191610c78565b820191906000526020600020905b815481529060010190602001808311610c5b57829003601f168201915b505050505081565b600081600460003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205410158015610d505750600460008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205482600460008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205401115b1515610d5b57600080fd5b60008373ffffffffffffffffffffffffffffffffffffffff1614151515610d8157600080fd5b81600460003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254039250508190555081600460008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600082825401925050819055508273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef846040518082815260200191505060405180910390a36001905092915050565b6000600560008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054905092915050565b60003373ffffffffffffffffffffffffffffffffffffffff16600660008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16141561109e5782600660008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508173ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff167ff69e1048607b6d539a819e49f1bc4765840b8735a7871ae5211ab8044ce1ee3b60405160405180910390a4600190506110a3565b600090505b929150505600a165627a7a72305820a576ee234b1c08d217c7156def06ac2bee4dcb441b55fbf78fc894b86384ffc30029',
gas: '47000000'
   	}, function (e, contract){
    	console.log(e, contract);
    	if (typeof contract.address !== 'undefined') {
		console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
    	}});
}

var con_addr = '0xb1a0e55d38553b4663a6a7efe3147416f257f657';
var dog1 = '0x908c4c8129523bc5fd0061bac6003cef95535100';
var dog2 = '0x908c4c8129523bc5fd0061bac6003cef95535200';

con = web3.eth.contract(abi).at(con_addr);

function create_dog(user, dog){
	var ret = con.createDog.sendTransaction(dog,{from: user});
	console.log(ret);
}

function select_dog(dog){
	user = con.selectDog(dog)
	for (i = 0; i < web3.eth.accounts.length; i++){
		if (web3.eth.accounts[i] == user){
			console.log(i+":" + dog);
		}
	}
}

function transfer_dog(from_addr, to_addr, dog){
	ret = con.transferDog.sendTransaction(to_addr,dog,{from: from_addr});
	console.log("from_addr:" + from_addr);
	console.log("to_addr:" + to_addr);
	console.log("dog:" + dog);
	//ret = '0x66d16b9bbae279c9366b3f01b74dc66b0e729c46c5f83a76f7d38ef9f9e624f4'
	//ret = web3.eth.getTransactionReceipt(ret);
	//console.log(ret);
}

function send_money(from_addr, to_addr){	
	var t = web3.eth.sendTransaction({
	  from:from_addr,
	  to:to_addr,
	  value:18000000000111123456
 	}); 

	console.log(web3.eth.getTransaction(t));
}

function new_account() {
	//npm install keythereum
	var pass = '123456'
	var addr = web3.personal.newAccount(pass)
	web3.personal.unlockAccount(addr,pass,0);
	console.log(addr);

	var keyth = require('keythereum');
	var keyobj = keyth.importFromFile(addr,'/home/shang/geth/data');
	var privateKey = keyth.recover('123456',keyobj);
	console.log(privateKey.toString('hex'));
}

// solc -o . --bin --abi dog.sol
//init();
//create_dog(web3.eth.accounts[0],dog1);
//select_dog(dog1);
transfer_dog(web3.eth.accounts[0],web3.eth.accounts[1],dog1);
//send_money(web3.eth.accounts[0],web3.eth.accounts[2]);
//new_account();
//ret = web3.eth.getBalance(web3.eth.accounts[0])
//console.log(web3.eth.accounts.length)
//select_dog(dog1)

