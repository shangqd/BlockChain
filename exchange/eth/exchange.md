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
    
    function In(address other_, bytes32 a_,bytes32 b_,uint32 h_) payable public returns (bool) {
        data[msg.sender] = Data({other:other_,a:a_,b:b_,h:h_,m:msg.value});
        return true;
    }
    
    function Out1(address owner,bytes32 a_,bytes32 b_) constant public returns (bool) {
        if (data[owner].h < block.number && sha256(a_) == data[owner].a && sha256(b_) == data[owner].b) {
            data[owner].other.send(data[msg.sender].m);
            return true;
        } else {
            return false;
        }
    }
    
    function Out2() constant public returns (bool) {
        if (data[msg.sender].h > block.number) {
            msg.sender.send(data[msg.sender].m);
            return true;
        } else {
            return false;
        }
    }
    
    function GetData(address owner) constant public returns (address) {
        return data[owner].other;
    }
}
```
在geth下面执行如下命令
```
var exchangeContract = web3.eth.contract([{"constant":false,"inputs":[{"name":"other_","type":"address"},{"name":"a_","type":"bytes32"},{"name":"b_","type":"bytes32"},{"name":"h_","type":"uint32"}],"name":"In","outputs":[{"name":"","type":"bool"}],"payable":true,"stateMutability":"payable","type":"function"},{"constant":true,"inputs":[{"name":"owner","type":"address"},{"name":"a_","type":"bytes32"},{"name":"b_","type":"bytes32"}],"name":"Out1","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"Out2","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"owner","type":"address"}],"name":"GetData","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"r","type":"bytes32"}],"name":"sha_256","outputs":[{"name":"","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"}]);
var exchange = exchangeContract.new(
   {
     from: web3.eth.accounts[0], 
     data: '0x608060405234801561001057600080fd5b50610829806100206000396000f30060806040526004361061006d576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680630a027cf2146100725780632760b03b146100ec578063652d2f561461016357806391daf91314610192578063cfc589b814610215575b600080fd5b6100d2600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080356000191690602001909291908035600019169060200190929190803563ffffffff169060200190929190505050610262565b604051808215151515815260200191505060405180910390f35b3480156100f857600080fd5b50610149600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080356000191690602001909291908035600019169060200190929190505050610395565b604051808215151515815260200191505060405180910390f35b34801561016f57600080fd5b50610178610643565b604051808215151515815260200191505060405180910390f35b34801561019e57600080fd5b506101d3600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919050505061072c565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b34801561022157600080fd5b506102446004803603810190808035600019169060200190929190505050610797565b60405180826000191660001916815260200191505060405180910390f35b600060a0604051908101604052808673ffffffffffffffffffffffffffffffffffffffff16815260200185600019168152602001846000191681526020018363ffffffff168152602001348152506000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008201518160000160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550602082015181600101906000191690556040820151816002019060001916905560608201518160030160006101000a81548163ffffffff021916908363ffffffff1602179055506080820151816004015590505060019050949350505050565b6000436000808673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060030160009054906101000a900463ffffffff1663ffffffff161080156104a157506000808573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060010154600019166002846040518082600019166000191681526020019150506020604051808303816000865af1158015610475573d6000803e3d6000fd5b5050506040513d602081101561048a57600080fd5b810190808051906020019092919050505060001916145b801561055157506000808573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060020154600019166002836040518082600019166000191681526020019150506020604051808303816000865af1158015610525573d6000803e3d6000fd5b5050506040513d602081101561053a57600080fd5b810190808051906020019092919050505060001916145b15610637576000808573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060000160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166108fc6000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600401549081150290604051600060405180830381858888f19350505050506001905061063c565b600090505b9392505050565b6000436000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060030160009054906101000a900463ffffffff1663ffffffff161115610724573373ffffffffffffffffffffffffffffffffffffffff166108fc6000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600401549081150290604051600060405180830381858888f193505050505060019050610729565b600090505b90565b60008060008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060000160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050919050565b60006002826040518082600019166000191681526020019150506020604051808303816000865af11580156107d0573d6000803e3d6000fd5b5050506040513d60208110156107e557600080fd5b810190808051906020019092919050505090509190505600a165627a7a72305820b927642d1520d30578b86b2da0be637073bd0e225c1968d32981a7f175f1d6f90029', 
     gas: '4700000'
   }, function (e, contract){
    console.log(e, contract);
    if (typeof contract.address !== 'undefined') {
         console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
    }
 })
```
查看交易
```
Contract mined! address: 0xc45f3258d8af624098a159a8c0bc05b2fdaa3c01 transactionHash: 0xd91926ca4d0c9ce38cac36e747473f09de3149f9807f958e6893ef4676dc6853

eth.getTransaction("0x767271e4bc8d515378f111b6f5e14c83e052c8614ebc65370f51e59fca690cc0")
```
### 运行合约
```

personal.newAccount("123456")
personal.newAccount("123456")
personal.unlockAccount(eth.accounts[1],"123456")
personal.unlockAccount(eth.accounts[2],"123456")
eth.sendTransaction({from:eth.accounts[0], to:eth.accounts[1], value:web3.toWei(100, "ether")})
eth.sendTransaction({from:eth.accounts[0], to:eth.accounts[2], value:web3.toWei(100, "ether")})

eth.getBalance(eth.accounts[1])
eth.getBalance(eth.accounts[2])

- 交易生成
exchange.sha_256(0xca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb);
0xae906eae1e9ea57a9fe5fd2e742a0fea420218a453db3b2ccf1e7023863ba9ee
exchange.sha_256(0x3e23e8160039594a33894f6564e1b1348bbd7a0088d42c4acb73eeaed59c009d);
0x994229b7027b73ca67f771431eeff86a4a29f8d527ec10593ae02efec7a94364

exchange.In.sendTransaction(eth.accounts[2],0xae906eae1e9ea57a9fe5fd2e742a0fea420218a453db3b2ccf1e7023863ba9ee,0x994229b7027b73ca67f771431eeff86a4a29f8d527ec10593ae02efec7a94364,100,{from: eth.accounts[1],value: web3.toWei(10, "ether")})

- 交易正常转出
exchange.Out1.sendTransaction(eth.accounts[1],0xca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb,0x3e23e8160039594a33894f6564e1b1348bbd7a0088d42c4acb73eeaed59c009d,{from: eth.accounts[2]})

- 交易失败转出
exchange.Out1.sendTransaction({from: eth.accounts[0]})
- 查看数据
exchange.GetData(eth.accounts[1])
```