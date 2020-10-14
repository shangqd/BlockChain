打开以太坊开发工具
https://remix.ethereum.org/

在这个网站下下载ganache-2.4.0-linux-x86_64.AppImage
这个工具是以太坊的开发模拟节点
https://www.trufflesuite.com/ganache

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

用户1授权 100000
用户1挂单 10000,买入1000个对链的币
费率 100

用户2撮合者 50
用户3执行者 50
用户3接受者 9000

1 发布erc20合约
2 发布交易所合约
3 授权ERC20合约给交易所合约
4 挂单（挂单金额不能大于授权金额）
5 撮合
6 执行

1 发布erc20合约
合约地址:0x3efe4e4C9Ea4B2C986026e2e8C5C61Ccd6005530
2 发布exchange合约
合约地址:0x37bC637Dd90Ee45Ecd27E29CDCf93cCdfcC9Cbcc

3 erc20授权给exchange
如果直接买eth不用这个操作
调用erc20方法: erc20.approve({"spender":0x37bC637Dd90Ee45Ecd27E29CDCf93cCdfcC9Cbcc,"value":100000})

4 挂单
exchange.createOrder()
参数如下：
sellToken:0x3efe4e4C9Ea4B2C986026e2e8C5C61Ccd6005530    // 要买的erc20地址，如果是值为：0x0000000000000000000000000000000000000000
sellAmount:10000                                        // 注意包含的小数位
buyToken:000000005f4ab2c791d41ac03a99b7a42bee4db8b5708b88b5c424402de053d9 // 买的是MKF,就填写bbc主链的分支
buyAmount: 1000                                             // 换1000个MKF
fee:100                                                     // 万分之100,手续费为百分之一
goBetween:  0x3Aa8f2760Df559240054cE647119Ab8A69ae8d36      // 撮合者地址
carryOut:   1965p604xzdrffvg90ax9bk0q3xyqn5zz2vc9zpbe3wdswzazj7d144mm // mkf 上的执行者地址 
blockHeight: 20                                                         // 块高
ownerOtherWalletAddress: 1trg751bnh2wvpy1t48e4hgac9qxfk0w39rqpknxdk42faxc3vdptb5n9 // 钱包接受地址
primaryKey:  0x5feceb66ffc86f38d952786c6d696c79c2dbc239dd4e91b46729d73a27fb57e9     // 挂单的主键byte32

// 挂单成功后发现正常执行的log
5 查找挂单
exchange.getOrderTradePair()
参数如下：
_user:0xF1127e2cC49E046351e353Ae338A6aAd1eBD7417
_primaryKey:0x5feceb66ffc86f38d952786c6d696c79c2dbc239dd4e91b46729d73a27fb57e9

返回如下:
    0:
    address: sellToken 0x3efe4e4C9Ea4B2C986026e2e8C5C61Ccd6005530
    1:
    uint256: sellAmount 10000
    2:
    string: buyToken 000000005f4ab2c791d41ac03a99b7a42bee4db8b5708b88b5c424402de053d9
    3:
    uint256: buyAmount 1000
6 撮合
exchange.goBetween()
参数如下：
orderAddress:0xF1127e2cC49E046351e353Ae338A6aAd1eBD7417        // 挂单者地址
sellToken: 0x3efe4e4C9Ea4B2C986026e2e8C5C61Ccd6005530          // 合约地址
amount: 1000                                                   // 撮合金额
buyToken:000000005f4ab2c791d41ac03a99b7a42bee4db8b5708b88b5c424402de053d9 //
buyAmount:100
buyAddress:0x6A1C6D562986e77D76c2526DD1929DD000a86A66               // 接受地址，这个地址来之mkf
carryOutAddress: 0x3C1bC0525155745fC2cDA88E105cD6bf2d14B070          // 执行地址，这个地址来之mkf
randIHash:0x6872c4218185f506e8a5dd6dcc3c24a92f42bb61cd8ef4e80e621f703435f741  //hash1
randJHash:0xc51a0b037d95fb20cc56339e4a8d16b69e93a1e5b62e8d496a21e07b2513a3df  //hahs2
randKey:00668949511ac480a77550980cf1fc4ccabcf7cfde81a89854e23b14c297ed05       //秘密的加密
ordrePrimaryKey:0x5feceb66ffc86f38d952786c6d696c79c2dbc239dd4e91b46729d73a27fb57e9
betweenPrimaryKey:0x6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b

7 查找撮合
