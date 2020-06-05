#include <boost/interprocess/managed_mapped_file.hpp>
#include <boost/interprocess/containers/map.hpp>
#include <boost/interprocess/allocators/allocator.hpp>
#include <functional>
#include <exception>
#include <string>

namespace bip = ::boost::interprocess;
using namespace bigbang;

class TxPayment
{
public:
    TxPayment(const uint256 &tx_hash,int64 amount,int lock)
    : m_tx_hash(tx_hash), m_amount(amount), m_lock(lock)
    {}

    uint256 m_tx_hash;
    int64 m_amount;
    int m_lock;
};

class TxStake
{
public:
    TxStake(const uint256 &tx_hash,const CDestination &addr,int64 amount,int height)
    : m_tx_hash(tx_hash), m_addr(addr), m_amount(amount), m_height(height)
    {}
    CDestination m_addr;
    uint256 m_tx_hash;
    int64 m_amount;
    int m_height;
};

typedef bip::allocator<std::pair<const uint256, TxPayment>, bip::managed_mapped_file::segment_manager> TxPaymentAllocator;
typedef bip::map<uint256, TxPayment, std::less<uint256>, TxPaymentAllocator> TxPaymentMap;

typedef bip::allocator<std::pair<const uint256, TxStake>, bip::managed_mapped_file::segment_manager> TxStakeAllocator;
typedef bip::map<uint256, TxStake, std::less<uint256>, TxStakeAllocator> TxStakeMap;

typedef bip::allocator<std::pair<const uint256, int64>, bip::managed_mapped_file::segment_manager> ProfitAllocator;
typedef bip::map<uint256, int64, std::less<uint256>, ProfitAllocator> ProfitMap;

class CashPool
{
private:
    // 违约资金交易的记录，包括添加，删除
    TxPaymentMap *m_payment;
    // 资金池入住记录，包括添加，删除 
    TxStakeMap *m_stake;
    // 个人奖励领域，包括添加（在指定的块高处定时同时添加），删除
    ProfitMap *m_profit;

public:
    CashPool()
    {
        bip::managed_mapped_file segment(bip::open_or_create, "SharedMemory", 1024 * 1024);
        m_payment = segment.find<TxPaymentMap>("TxPaymentMap").first;
        if (m_payment == nullptr)
        {
            const TxPaymentAllocator alloc_inst(segment.get_segment_manager());
            m_payment = segment.construct<TxPaymentMap>("TxPaymentMap") (std::less<uint256>(), alloc_inst);
        }
        m_stake = segment.find<TxStakeMap>("TxStakeMap").first;
        if (m_stake == nullptr)
        {
            const TxStakeAllocator alloc_inst(segment.get_segment_manager());
            m_stake = segment.construct<TxStakeMap>("TxStakeMap") (std::less<uint256>(), alloc_inst);
        }
        m_profit = segment.find<ProfitMap>("ProfitMap").first;
        if (m_profit == nullptr)
        {
            const ProfitAllocator alloc_inst(segment.get_segment_manager());
            m_profit = segment.construct<ProfitMap>("ProfitMap") (std::less<uint256>(), alloc_inst);
        }
    }

    void PaymentAdd(const uint256 &tx_hash,int64 amount,int height)
    {
        m_payment->insert(std::pair<const uint256, TxPayment>(tx_hash, TxPayment(tx_hash,amount,height)));
    }

    void PaymentDel(const uint256 &tx_hash,const uint256 &fork)
    {
        auto iter = m_payment->find(tx_hash);
        if (iter != m_payment->end())
        {
            m_payment->erase(iter);
        }
    }

    void StakeAdd(const uint256 &tx_hash,const CDestination &addr,int64 amount,int height)
    {
        m_stake->insert(std::pair<const uint256, TxStake>(tx_hash, TxStake(tx_hash,addr,amount,height)));
    }

    void StakeDel(const uint256 &tx_hash,const uint256 &fork)
    {
        auto iter = m_stake->find(tx_hash);
        if (iter != m_stake->end())
        {
            m_stake->erase(iter);
        }
    }

    // 定时函数
    void Timing(int h)
    {
        const int n = 10;
        h = h - h % n - n;
        int64 total_stake(0);
        std::map<CDestination, int64> new_profit;
        for (auto ite = m_stake->begin(); ite != m_stake->end(); ++ite)
        {
            if (ite->second.m_height <= h)
            {
                total_stake += ite->second.m_amount;
                if (new_profit.find(ite->second.m_addr) == new_profit.end())
                {
                    new_profit[ite->second.m_addr] = ite->second.m_amount;
                }
                else
                {
                    new_profit[ite->second.m_addr] += ite->second.m_amount;
                }
            }
        }
        if (total_stake == 0)
        {
            return;
        }
        int64 total_payment(0);
        for (auto ite = m_payment->begin(); ite != m_payment->end(); ++ite)
        {
            if (ite->second.m_lock > h && ite->second.m_lock <= h + n)
            {
                total_payment += ite->second.m_amount;
            }
        }
        if (total_payment == 0)
        {
            return;
        }
        for (auto ite = new_profit.begin(); ite != new_profit.end(); ++ite)
        {
            uint256 hash = ite->first.GetTemplateId() + h;
            double f = ite->second / total_stake;
            int64 amount = (int64)(total_payment * f);
            m_profit->insert(std::pair<const uint256, int64>(hash, amount));
        }
    }

    void test()
    {
        // 10个块为周期
        int c = 10;
        int bn = 1;
        CDestination addr1;
        addr1.SetHex("1");
        StakeAdd(1,addr1,bn,100);
        bn++;
        CDestination addr2;
        addr1.SetHex("2");
        StakeAdd(2,addr2,bn,200);
        PaymentAdd(3,bn,60);
        PaymentAdd(4,bn,30);
        bn = 11;
        PaymentAdd(5,bn,30);
        Timing(22);
    }

    // 
    int64 GetProfit(CDestination addr,int h)
    {
        uint256 hash = addr.GetTemplateId() + h;
        auto ite = m_profit->find(hash);
        if (ite == m_profit->end())
        {
            return 0;
        }
        else
        {
            return ite->second;
        }
    }

    //
    void DelProfit(CDestination addr,int h)
    {
        uint256 hash = addr.GetTemplateId() + h;
        auto ite = m_profit->find(hash);
        if (ite != m_profit->end())
        {
            m_profit->erase(ite);
        }
    }
};
