#### 工具
打开以太坊开发工具
https://remix.ethereum.org/

下载ganache-2.4.0-linux-x86_64.AppImage
地址:https://www.trufflesuite.com/ganache
该工具是以太坊的开发模拟节点

#### 基本数据
mkf的创世块:000000005f4ab2c791d41ac03a99b7a42bee4db8b5708b88b5c424402de053d9  
MKF执行者地址:1965p604xzdrffvg90ax9bk0q3xyqn5zz2vc9zpbe3wdswzazj7d144mm  
MKF接受地址：1trg751bnh2wvpy1t48e4hgac9qxfk0w39rqpknxdk42faxc3vdptb5n9   
挂单ID:0x5feceb66ffc86f38d952786c6d696c79c2dbc239dd4e91b46729d73a27fb57e9   
撮合ID:0x6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b   

随机数1：0xb6103658b60234ade25b7389a08514b6803dff9c636dff92ef0edaa0f37e2eef  
随机数1hash：0x6872c4218185f506e8a5dd6dcc3c24a92f42bb61cd8ef4e80e621f703435f741  

随机数2：0x6836ba9b8f40f968888a7376f657f97c53cfa8db02872e0f1daf8376cb80b1e7  
随机数2hash：0xc51a0b037d95fb20cc56339e4a8d16b69e93a1e5b62e8d496a21e07b2513a3df  

加密数：00668949511ac480a77550980cf1fc4ccabcf7cfde81a89854e23b14c297ed05  

#### 实验的业务流程
用户1授权 100000个erc20代币 
用户1挂单 10000,买入1000个MKF
费率 百分之一

执行完成后
用户2撮合者 50代币
用户3执行者 50代币
用户4接受者 9000代币

1 发布erc20合约
2 发布交易所合约
3 授权ERC20合约给交易所合约
4 挂单（挂单金额不能大于授权金额）
5 撮合
6 执行
7 撤单

##### 具体实验结果

1 发布erc20合约
合约地址:0x0162812f8857fF916DBaa96754791f87B3012Fa4 
0xFBFc149cc4dCdfdF4e392A415F2f16e0e24096e0

2 发布exchange合约
合约地址:0x84Ab295BbE3BD7A57A40B798Faf0CAB8C7EC16F7

3 erc20授权给exchange
如果直接买eth不用这个操作
调用erc20方法: erc20.approve({"spender":0x84Ab295BbE3BD7A57A40B798Faf0CAB8C7EC16F7,"value":100000})

4 挂单
exchange.createOrder()
参数如下：
sellToken:0x0162812f8857fF916DBaa96754791f87B3012Fa4    // 要买的erc20地址，如果是值为：0x0000000000000000000000000000000000000000
sellAmount:10000                                        // 注意包含的小数位
buyToken:000000005f4ab2c791d41ac03a99b7a42bee4db8b5708b88b5c424402de053d9 // 买的是MKF,就填写bbc主链的分支
buyAmount: 1000                                             // 换1000个MKF
fee:100                                                     // 万分之100,手续费为百分之一
goBetween:  0xb885C9Ad615943bfe82D94C8522616C07BA9C08C      // 撮合者地址
carryOut:   1965p604xzdrffvg90ax9bk0q3xyqn5zz2vc9zpbe3wdswzazj7d144mm // mkf 上的执行者地址 
blockHeight: 20                                                         // 块高
ownerOtherWalletAddress: 1trg751bnh2wvpy1t48e4hgac9qxfk0w39rqpknxdk42faxc3vdptb5n9 // mkf钱包接受地址
primaryKey:  0x5feceb66ffc86f38d952786c6d696c79c2dbc239dd4e91b46729d73a27fb57e9     // 挂单的主键byte32

// 挂单成功后发现正常执行的log

5 撮合
exchange.goBetween()
参数如下：
orderAddress:0xFBFc149cc4dCdfdF4e392A415F2f16e0e24096e0       
// 挂单者地址

sellToken: 0x0162812f8857fF916DBaa96754791f87B3012Fa4  
// 合约地址

amount: 1000                                                   // 撮合金额
// 撮合金额

buyToken:000000005f4ab2c791d41ac03a99b7a42bee4db8b5708b88b5c424402de053d9 
// mkf 创世块hash

buyAmount:100
// 100MKF

buyAddress:0xE3f5BD4d2871ABC48E689730Ab5f2e76f191892b             
// 接受地址，这个地址来之mkf

carryOutAddress: 0xcE9BA49456752bd515D76664B12aEDBcf6300F41         
// 执行地址，这个地址来之mkf

randIHash:0x6872c4218185f506e8a5dd6dcc3c24a92f42bb61cd8ef4e80e621f703435f741 
// hash1

randJHash:0xc51a0b037d95fb20cc56339e4a8d16b69e93a1e5b62e8d496a21e07b2513a3df 
// hahs2

randKey:00668949511ac480a77550980cf1fc4ccabcf7cfde81a89854e23b14c297ed05 
// 秘密的加密

ordrePrimaryKey:0x5feceb66ffc86f38d952786c6d696c79c2dbc239dd4e91b46729d73a27fb57e9
// 挂单ID

betweenPrimaryKey:0x6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b
// 撮合ID

6 执行 
exchange.carryOut()
参数如下：
randI:0xb6103658b60234ade25b7389a08514b6803dff9c636dff92ef0edaa0f37e2eef
randJ:0x6836ba9b8f40f968888a7376f657f97c53cfa8db02872e0f1daf8376cb80b1e7
orderAddress:0xFBFc149cc4dCdfdF4e392A415F2f16e0e24096e0
betweensAddress:0xb885C9Ad615943bfe82D94C8522616C07BA9C08C
ordrePrimaryKey:0x5feceb66ffc86f38d952786c6d696c79c2dbc239dd4e91b46729d73a27fb57e9
betweenPrimaryKey:0x6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b

查询各账户余额正确

7 撤销挂单 
exchange.retrace()
参数如下：
ordrePrimaryKey:0x5feceb66ffc86f38d952786c6d696c79c2dbc239dd4e91b46729d73a27fb57e9

查询各账户余额正确