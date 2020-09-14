### eth hello
参考地址
https://www.cnblogs.com/fdzang/p/12699377.html

以太坊智能合约参考文档
https://solidity.readthedocs.io/en/v0.7.1/units-and-global-variables.html
### 启动私链
```
mkdir data
geth --datadir ./data --dev console 2>>output.log
```
### 编写部署智能合约
打开： https://remix.ethereum.org/
```
pragma solidity ^0.4.21;
contract exchange {
    struct Data {
        address other;
        bytes32 a;
        bytes32 b;
        uint32 h;
        uint256 m;
    }
    
    mapping(address => Data) data;
    function exchange() public {
    }

    function sha_256(bytes32 r) constant public returns (bytes32) {
        return sha256(r);
    }
    
    function In(address other_, bytes32 a_,bytes32 b_,uint32 h_) payable public returns (bytes32) {
        data[msg.sender] = Data({other:other_,a:a_,b:b_,h:h_,m:msg.value});
        return data[msg.sender].a;
    }
    
    function Out1(address owner,bytes32 a_,bytes32 b_) constant public returns (bool) {
        if (block.number < data[owner].h && sha256(a_) == data[owner].a && sha256(b_) == data[owner].b ) {
            data[owner].other.send(data[owner].m);
            return true;
        } else {
            return false;
        }
    }
    
    function Out2(address owner) constant public returns (bool) {
         if (data[msg.sender].h < block.number) {
            msg.sender.send(data[msg.sender].m);
            return true;
        } else {
            return false;
        }
    }
    
    function GetData(address owner) constant public returns (bytes32) {
        return data[owner].a;
    }
}
```
在geth下面执行如下命令
```
var exchangeContract = web3.eth.contract([{"constant":false,"inputs":[{"name":"other_","type":"address"},{"name":"a_","type":"bytes32"},{"name":"b_","type":"bytes32"},{"name":"h_","type":"uint32"}],"name":"In","outputs":[{"name":"","type":"bytes32"}],"payable":true,"stateMutability":"payable","type":"function"},{"constant":true,"inputs":[{"name":"owner","type":"address"},{"name":"a_","type":"bytes32"},{"name":"b_","type":"bytes32"}],"name":"Out1","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"owner","type":"address"}],"name":"Out2","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"owner","type":"address"}],"name":"GetData","outputs":[{"name":"","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"r","type":"bytes32"}],"name":"sha_256","outputs":[{"name":"","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"}]);
var exchange = exchangeContract.new(
   {
     from: web3.eth.accounts[0], 
     data: '0x608060405234801561001057600080fd5b50610857806100206000396000f30060806040526004361061006d576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680630a027cf2146100725780632760b03b146100f0578063798e01421461016757806391daf913146101c2578063cfc589b814610221575b600080fd5b6100d2600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080356000191690602001909291908035600019169060200190929190803563ffffffff16906020019092919050505061026e565b60405180826000191660001916815260200191505060405180910390f35b3480156100fc57600080fd5b5061014d600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803560001916906020019092919080356000191690602001909291905050506103e1565b604051808215151515815260200191505060405180910390f35b34801561017357600080fd5b506101a8600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919050505061068f565b604051808215151515815260200191505060405180910390f35b3480156101ce57600080fd5b50610203600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919050505061077a565b60405180826000191660001916815260200191505060405180910390f35b34801561022d57600080fd5b5061025060048036038101908080356000191690602001909291905050506107c5565b60405180826000191660001916815260200191505060405180910390f35b600060a0604051908101604052808673ffffffffffffffffffffffffffffffffffffffff16815260200185600019168152602001846000191681526020018363ffffffff168152602001348152506000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008201518160000160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550602082015181600101906000191690556040820151816002019060001916905560608201518160030160006101000a81548163ffffffff021916908363ffffffff160217905550608082015181600401559050506000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600101549050949350505050565b60008060008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060030160009054906101000a900463ffffffff1663ffffffff16431080156104ed57506000808573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060010154600019166002846040518082600019166000191681526020019150506020604051808303816000865af11580156104c1573d6000803e3d6000fd5b5050506040513d60208110156104d657600080fd5b810190808051906020019092919050505060001916145b801561059d57506000808573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060020154600019166002836040518082600019166000191681526020019150506020604051808303816000865af1158015610571573d6000803e3d6000fd5b5050506040513d602081101561058657600080fd5b810190808051906020019092919050505060001916145b15610683576000808573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060000160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166108fc6000808773ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600401549081150290604051600060405180830381858888f193505050505060019050610688565b600090505b9392505050565b6000436000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060030160009054906101000a900463ffffffff1663ffffffff161015610770573373ffffffffffffffffffffffffffffffffffffffff166108fc6000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600401549081150290604051600060405180830381858888f193505050505060019050610775565b600090505b919050565b60008060008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600101549050919050565b60006002826040518082600019166000191681526020019150506020604051808303816000865af11580156107fe573d6000803e3d6000fd5b5050506040513d602081101561081357600080fd5b810190808051906020019092919050505090509190505600a165627a7a72305820519b9da19e62587ebf6a9ffea6ddc33e2b47fcd20927554b365559b8619fad8a0029', 
     gas: '4700000'
   }, function (e, contract){
    console.log(e, contract);
    if (typeof contract.address !== 'undefined') {
         console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
    }
 });
```
查看交易
```
Contract mined! address: 0x44c3790255a2ba0de5b983f3d8e62d0a01b4e001 transactionHash: 0xa66914e66060ea84909d731fc5f6ea306a4b53cc692340adb393e45026b4513c

eth.getTransaction("0xa66914e66060ea84909d731fc5f6ea306a4b53cc692340adb393e45026b4513c")
```
### 运行合约
```
personal.newAccount("123456");
personal.newAccount("123456");
personal.unlockAccount(eth.accounts[1],"123456");
personal.unlockAccount(eth.accounts[2],"123456");
eth.sendTransaction({from:eth.accounts[0], to:eth.accounts[1], value:web3.toWei(100, "ether")});
eth.sendTransaction({from:eth.accounts[0], to:eth.accounts[2], value:web3.toWei(100, "ether")});

eth.getBalance(eth.accounts[1])
eth.getBalance("0x44c3790255a2ba0de5b983f3d8e62d0a01b4e001")

- 交易生成
exchange.sha_256("0xca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb");
0xbf5d3affb73efd2ec6c36ad3112dd933efed63c4e1cbffcfa88e2759c144f2d8
exchange.sha_256("0x3e23e8160039594a33894f6564e1b1348bbd7a0088d42c4acb73eeaed59c009d");
0x39361160903c6695c6804b7157c7bd10013e9ba89b1f954243bc8e3990b08db9

exchange.In.sendTransaction(eth.accounts[2],"0xbf5d3affb73efd2ec6c36ad3112dd933efed63c4e1cbffcfa88e2759c144f2d8","0x39361160903c6695c6804b7157c7bd10013e9ba89b1f954243bc8e3990b08db9",100,{from: eth.accounts[1],value: web3.toWei(10, "ether")})  

- 交易正常转出
exchange.Out1.sendTransaction(eth.accounts[1],"0xca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb","0x3e23e8160039594a33894f6564e1b1348bbd7a0088d42c4acb73eeaed59c009d",{from: eth.accounts[1]})

- 交易失败转出
exchange.Out1.sendTransaction({from: eth.accounts[0]})
- 查看数据
exchange.GetData(eth.accounts[1])
```