
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
    string greeting;

    function hello(string _greeting) public {
        greeting = _greeting;
    }

    function say() constant public returns (string) {
        return greeting;
    }
}
```

在geth下面执行如下命令
```
var _greeting = "hello world";
var helloContract = web3.eth.contract([{"constant":true,"inputs":[],"name":"say","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_greeting","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"}]);
var hello = helloContract.new(
   _greeting,
   {
     from: web3.eth.accounts[0], 
     data: '0x608060405234801561001057600080fd5b506040516102a83803806102a8833981018060405281019080805182019291905050508060009080519060200190610049929190610050565b50506100f5565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f1061009157805160ff19168380011785556100bf565b828001600101855582156100bf579182015b828111156100be5782518255916020019190600101906100a3565b5b5090506100cc91906100d0565b5090565b6100f291905b808211156100ee5760008160009055506001016100d6565b5090565b90565b6101a4806101046000396000f300608060405260043610610041576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff168063954ab4b214610046575b600080fd5b34801561005257600080fd5b5061005b6100d6565b6040518080602001828103825283818151815260200191508051906020019080838360005b8381101561009b578082015181840152602081019050610080565b50505050905090810190601f1680156100c85780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b606060008054600181600116156101000203166002900480601f01602080910402602001604051908101604052809291908181526020018280546001816001161561010002031660029004801561016e5780601f106101435761010080835404028352916020019161016e565b820191906000526020600020905b81548152906001019060200180831161015157829003601f168201915b50505050509050905600a165627a7a72305820f6aeef47ae8d8218bc70cb896a92eb7c9be3a4a7cd406a2b79226f507db577ff0029', 
     gas: '4700000'
   }, function (e, contract){
    console.log(e, contract);
    if (typeof contract.address !== 'undefined') {
         console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
    }
 })

Contract mined! address: 0x891c4796dba51177bb99f7153a05c9557b5cf320  transactionHash: 0x29796023b10e8a4a80d334920af69f8a0f4e783f85373db6d680267ee0a29011
```
查看交易
```
eth.getTransaction("0x29796023b10e8a4a80d334920af69f8a0f4e783f85373db6d680267ee0a29011")
```

### 运行合约
```
hello.say()
```