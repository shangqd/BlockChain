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

    function In(address other_, bytes32 a_,bytes32 b_,uint32 h_) constant public returns (bool) {
        data[msg.sender] = Data({other:other_,a:a_,b:b_,h:h_,m:msg.value});
        return true;
    }
    
    function Out1(address owner,bytes32 a_,bytes32 b_) constant public returns (bool) {
        if (data[owner].h < block.number && sha256(a_) == data[owner].a && sha256(b_) == data[owner].b) {
            data[owner].other.send(data[msg.sender].m);
            delete data[owner];
            return false;
        } else {
            return true;
        }
    }
    
    function Out2() constant public returns (bool) {
        if (data[msg.sender].h > block.number) {
            msg.sender.send(data[msg.sender].m);
            delete data[msg.sender];
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
var exchangeContract = web3.eth.contract([{"constant":true,"inputs":[{"name":"other_","type":"address"},{"name":"a_","type":"bytes32"},{"name":"b_","type":"bytes32"},{"name":"h_","type":"uint32"}],"name":"In","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"owner","type":"address"},{"name":"a_","type":"bytes32"},{"name":"b_","type":"bytes32"}],"name":"Out1","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"Out2","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"owner","type":"address"}],"name":"GetData","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"}]);
var exchange = exchangeContract.new(
   {
     from: web3.eth.accounts[0], 
     data: '0x608060405234801561001057600080fd5b506108a6806100206000396000f300608060405260043610610062576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680630a027cf2146100675780632760b03b146100ee578063652d2f561461016557806391daf91314610194575b600080fd5b34801561007357600080fd5b506100d4600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080356000191690602001909291908035600019169060200190929190803563ffffffff169060200190929190505050610217565b604051808215151515815260200191505060405180910390f35b3480156100fa57600080fd5b5061014b600480360381019080803573ffffffffffffffffffffffffffffffffffffffff1690602001909291908035600019169060200190929190803560001916906020019092919050505061034a565b604051808215151515815260200191505060405180910390f35b34801561017157600080fd5b5061017a61068f565b604051808215151515815260200191505060405180910390f35b3480156101a057600080fd5b506101d5600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919050505061080f565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b600060a0604051908101604052808673ffffffffffffffffffffffffffffffffffffffff16815260200185600019168152602001846000191681526020018363ffffffff168152602001348152506000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008201518160000160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550602082015181600101906000191690556040820151816002019060001916905560608201518160030160006101000a81548163ffffffff021916908363ffffffff1602179055506080820151816004015590505060019050949350505050565b6000436000808673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060030160009054906101000a900463ffffffff1663ffffffff1610801561045657506000808573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060010154600019166002846040518082600019166000191681526020019150506020604051808303816000865af115801561042a573d6000803e3d6000fd5b5050506040513d602081101561043f57600080fd5b810190808051906020019092919050505060001916145b801561050657506000808573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060020154600019166002836040518082600019166000191681526020019150506020604051808303816000865af11580156104da573d6000803e3d6000fd5b5050506040513d60208110156104ef57600080fd5b810190808051906020019092919050505060001916145b15610683576000808573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060000160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166108fc6000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600401549081150290604051600060405180830381858888f19350505050506000808573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600080820160006101000a81549073ffffffffffffffffffffffffffffffffffffffff0219169055600182016000905560028201600090556003820160006101000a81549063ffffffff02191690556004820160009055505060009050610688565b600190505b9392505050565b6000436000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060030160009054906101000a900463ffffffff1663ffffffff161115610807573373ffffffffffffffffffffffffffffffffffffffff166108fc6000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600401549081150290604051600060405180830381858888f19350505050506000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600080820160006101000a81549073ffffffffffffffffffffffffffffffffffffffff0219169055600182016000905560028201600090556003820160006101000a81549063ffffffff0219169055600482016000905550506001905061080c565b600090505b90565b60008060008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060000160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1690509190505600a165627a7a7230582026f6c90a51d0f4d9d3184b0fe355fe22818318c5eeaad81dd73e5b821fe42b050029', 
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
eth.getTransaction("0x29796023b10e8a4a80d334920af69f8a0f4e783f85373db6d680267ee0a29011")
```
### 运行合约
```
```