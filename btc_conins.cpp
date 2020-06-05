bool CCoinsViewCache::GetCoins(const uint256 &txid, CCoins &coins) const {

    std::cout << cacheCoins.begin()->first.ToString() << std::endl;
    std::cout << cacheCoins.size() << std::endl;

    CCoinsMap::const_iterator it = FetchCoins(txid);
    if (it != cacheCoins.end()) {
        coins = it->second.coins;
        return true;
    }
    return false;
}

// blockchain.cpp
UniValue gettxout(const UniValue& params, bool fHelp);
