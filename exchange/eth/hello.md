
### eth hello
参考地址
https://www.cnblogs.com/fdzang/p/12699377.html

### 启动私链
```
mkdir data
geth --datadir ./data --dev console 2>>output.log
```

- --dev 启用开发者网络（模式），开发者网络会使用POA共识，默认预分配一个开发者账户并且会自动开启挖矿。
- --datadir 后面的参数是区块数据及秘钥存放目录。
- console 进入控制台
- 2>> output.log 表示把控制台日志输出到output.log文件

### 准备账户
查看账户信息
```
eth.accounts
personal.listAccounts
```
查看账户中的余额
```
eth.getBalance(eth.accounts[0])
```
创建账户
```
personal.newAccount("123456")
```
账户转账
```
eth.sendTransaction({from:eth.accounts[0], to:eth.accounts[1], value:web3.toWei(100, "ether")})
```
解锁账户
```
personal.unlockAccount(eth.accounts[1],"123456")
```

### 编写部署智能合约
打开： https://remix.ethereum.org/
```
pragma solidity ^0.4.21;
contract hello {
    function say(string str) constant public returns (bytes32) {
        return sha256(str);
    }
    function height() constant public returns (uint) {
        return  block.number;
    }
}
```

在geth下面执行如下命令
```
var helloContract = web3.eth.contract([{"constant":true,"inputs":[],"name":"height","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"str","type":"string"}],"name":"say","outputs":[{"name":"","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"}]);
var hello = helloContract.new(
   {
     from: web3.eth.accounts[0], 
     data: '0x608060405234801561001057600080fd5b506101e0806100206000396000f30060806040526004361061004c576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680630ef2674314610051578063d5c613011461007c575b600080fd5b34801561005d57600080fd5b50610066610101565b6040518082815260200191505060405180910390f35b34801561008857600080fd5b506100e3600480360381019080803590602001908201803590602001908080601f0160208091040260200160405190810160405280939291908181526020018383808284378201915050505050509192919290505050610109565b60405180826000191660001916815260200191505060405180910390f35b600043905090565b60006002826040518082805190602001908083835b602083101515610143578051825260208201915060208101905060208303925061011e565b6001836020036101000a0380198251168184511680821785525050505050509050019150506020604051808303816000865af1158015610187573d6000803e3d6000fd5b5050506040513d602081101561019c57600080fd5b810190808051906020019092919050505090509190505600a165627a7a72305820d92a2ec5acc7818693345135505dc1e1806f54774693276c3f2295f6b7a73a280029', 
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
hello.say("a")
"0xca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb"
hello.height()
```