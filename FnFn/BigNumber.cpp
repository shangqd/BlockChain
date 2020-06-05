#include <stdio.h>  
#include <openssl/bn.h>  
#include <openssl/rand.h>  
#include <openssl/err.h>  
 
class BigNumber
{
public:
    BigNumber()
    {
        _bn = BN_new();
    }

    BigNumber(const BigNumber& bn)
    {
        _bn = BN_dup(bn._bn);
    }

    BigNumber(uint32 val)
    {
        _bn = BN_new();
        BN_set_word(_bn, val);
    }

    ~BigNumber()
    {
        BN_free(_bn);
    }
 
    void SetDword(uint32 val)
    {
        BN_set_word(_bn, val);
    }

    void SetQword(uint64 val)
    {
        BN_add_word(_bn, (uint32)(val >> 32));
        BN_lshift(_bn, _bn, 32);
        BN_add_word(_bn, (uint32)(val & 0xFFFFFFFF));
    }

   

    void SetBinary(const uint8* bytes, int len)
    {
        uint8 t[1000];
        for (int i = 0; i < len; ++i)
            t[i] = bytes[len - 1 - i];
        BN_bin2bn(t, len, _bn);
    }

    void SetHexStr(const char* str)
    {
        BN_hex2bn(&_bn, str);
    }
 
    void SetRand(int numbits)
    {
        BN_rand(_bn, numbits, 0, 1);
    }
 
    BigNumber operator=(const BigNumber& bn)
    {
        BN_copy(_bn, bn._bn);
        return *this;
    }
 
    BigNumber operator+=(const BigNumber& bn)
    {
        BN_add(_bn, _bn, bn._bn);
        return *this;
    }

    BigNumber operator+(const BigNumber& bn)
    {
        BigNumber t(*this);
        return t += bn;
    }

    BigNumber operator-=(const BigNumber& bn)
    {
        BN_sub(_bn, _bn, bn._bn);
        return *this;
    }

    BigNumber operator-(const BigNumber& bn)
    {
        BigNumber t(*this);
        return t -= bn;
    }

    BigNumber operator*=(const BigNumber& bn)
    {
        BN_CTX* ctx = BN_CTX_new();
        BN_mul(_bn, _bn, bn._bn, ctx);
        BN_CTX_free(ctx);
        return *this;
    }

    BigNumber operator*(const BigNumber& bn)
    {
        BigNumber t(*this);
        return t *= bn;
    }

    BigNumber operator/=(const BigNumber& bn)
    {
        BN_CTX* ctx = BN_CTX_new();
        BN_div(_bn, NULL, _bn, bn._bn, ctx);
        BN_CTX_free(ctx);
        return *this;
    }

    BigNumber operator/(const BigNumber& bn)
    {
        BigNumber t(*this);
        return t /= bn;
    }

    BigNumber operator%=(const BigNumber& bn)
    {
        BN_CTX* bnctx;
        bnctx = BN_CTX_new();
        BN_mod(_bn, _bn, bn._bn, bnctx);
        BN_CTX_free(bnctx);
        return *this;
    }

    BigNumber operator%(const BigNumber& bn)
    {
        BigNumber t(*this);
        return t %= bn;
    }
 
    bool isZero() const
    {
        return BN_is_zero(_bn) != 0;
    }
 
    BigNumber ModExp(const BigNumber& bn1, const BigNumber& bn2)
    {
        BigNumber ret;
        BN_CTX* bnctx;
        bnctx = BN_CTX_new();
        BN_mod_exp(ret._bn, _bn, bn1._bn, bn2._bn, bnctx);
        BN_CTX_free(bnctx);
        return ret;
    }

    BigNumber Exp(const BigNumber& bn)
    {
        BigNumber ret;
        BN_CTX* bnctx;
 
        bnctx = BN_CTX_new();
        BN_exp(ret._bn, _bn, bn._bn, bnctx);
        BN_CTX_free(bnctx);
 
        return ret;
    }
 
    int GetNumBytes(void)
    {
        return BN_num_bytes(_bn);
    }

 
    uint64 AsDword()
    {
        return BN_get_word(_bn);
    }

    uint8* AsByteArray(int minSize = 0, bool reverse = true)
    {
        int length = (minSize >= GetNumBytes()) ? minSize : GetNumBytes();
        uint8 *_array = new uint8[length];
        if (length > GetNumBytes())
            memset((void*)_array, 0, length);
 
        BN_bn2bin(_bn, (unsigned char*)_array);
 
        if (reverse)
            std::reverse(_array, _array + length);
        return _array;
    }
 
    const char* AsHexStr()
    {
        return BN_bn2hex(_bn);
    }
 
    const char* AsDecStr()
    {
        return BN_bn2dec(_bn);
   
    }
 
    void SetQword(uint64 valh,uint64 vall)
    {
        BN_add_word(_bn, (uint32)(valh >> 32));
        BN_lshift(_bn, _bn, 32);
        BN_add_word(_bn, (uint32)(valh & 0xFFFFFFFF));
        BN_lshift(_bn, _bn, 32);
        BN_add_word(_bn, (uint32)(vall >> 32));
        BN_lshift(_bn, _bn, 32);
        BN_add_word(_bn, (uint32)(vall & 0xFFFFFFFF));
    }

    void GetQword(uint64 &valh,uint64 &vall)
    {
        BigNumber bn;
        bn.SetQword(UINT64_MAX);
        bn = bn + 1;
        vall = (*this % bn).AsDword();
        valh = (*this / bn).AsDword();
    }

private:
    BIGNUM *_bn;
};

void BigNumberTest()
{
    uint64 ui1h = UINT64_MAX;
    uint64 ui1l = UINT64_MAX;
    BigNumber bn1;
    bn1.SetQword(ui1h,ui1l);
    assert(bn1.AsDword() == UINT64_MAX);
    BigNumber bn2(2);
    BigNumber bn3 = bn1 + bn2;
    std::cout << bn3.AsDword() << std::endl;
    std::cout << UINT64_MAX << std::endl;
    std::cout << bn1.AsHexStr() << std::endl;
    std::cout << bn3.AsHexStr() << std::endl;
}
