#npm install web3
#npm install ethereumjs-accounts
#npm install keythereum

#sudo add-apt-repository -y ppa:ethereum/ethereum
#sudo apt-get update
#sudo apt-get install solc
#solc -o . --bin --abi dog.sol
#sudo apt-get install ethereum
#npm config set registry https://registry.npm.taobao.org
#npm install web3
#npm install ethereumjs-accounts
#npm install keythereum


geth --datadir ./data init genesis.json
geth --rpc --rpcapi "personal,eth,web3" --rpcaddr 0.0.0.0 --datadir ./data --networkid 15 2>> out.txt console

# 创建账户
personal.newAccount("123456")

personal.unlockAccount(eth.accounts[1],'123456',0)
personal.unlockAccount('0x642413da90cfa5eaf15138933a26a5dc836c8a4a','123456',0)


miner.start()


eth.getBalance(eth.accounts[1])


miner.stop()
