
bigbang listpeer

bigbang getblockcount
bigbang -rpcport=10902 getblockcount
bigbang -rpcport=11902 getblockcount


echo "------------bigbang-------------"
cat .bigbang/bigbang.log | grep "Remove P"
cat .bigbang/bigbang.log.log | grep "Remove P"

echo "------------dpos1---------------"
cat .dpos1/bigbang.log | grep "Remove P"
cat .dpos1/bigbang.log.log | grep "Remove P"

echo "------------dpos2---------------"
cat .dpos2/bigbang.log | grep "Remove P"
cat .dpos2/bigbang.log.log | grep "Remove P"

#echo "------------dpos3---------------"
#cat .dpos3/bigbang.log | grep "Remove P"
#cat .dpos3/bigbang.log.log | grep "Remove P"
#echo "------------dpos4---------------"
#cat .dpos4/bigbang.log | grep "Remove P"
#cat .dpos4/bigbang.log.log | grep "Remove P"
#echo "------------dpos5---------------"
#cat .dpos5/bigbang.log | grep "Remove P"
#cat .dpos5/bigbang.log.log | grep "Remove P"

bigbang gettxpool -f=22b00c5fe28282af339ec6eb85f5b8667ff462b366b37e784f1eed7dbf1cc6ef
bigbang -rpcport=10902 gettxpool -f=22b00c5fe28282af339ec6eb85f5b8667ff462b366b37e784f1eed7dbf1cc6ef
bigbang -rpcport=11902 gettxpool -f=22b00c5fe28282af339ec6eb85f5b8667ff462b366b37e784f1eed7dbf1cc6ef


