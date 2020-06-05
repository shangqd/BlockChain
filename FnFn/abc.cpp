
BbErr CBlockChain::AddNewBlock(const CBlock& block, CBlockChainUpdate& update)
{
    //static boost::recursive_mutex mtxAddBlock;
    //boost::unique_lock<boost::recursive_mutex> lock(mtxAddBlock);
