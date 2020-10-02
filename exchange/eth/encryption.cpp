#include <iostream>
#include <sodium.h>

void bbc_hex2bin(const char *src, unsigned char *dst)
{
    unsigned char bins[32] = {0};
    sodium_hex2bin(bins, 32, src, 64, nullptr, nullptr, nullptr);
    for (int i = 0; i < 32; i++)
    {
        dst[i] = bins[31 - i];
    }
}

void Test()
{
    const char *pub = "da915f7d9e1b1f6ed99fd816ff977a7d1f17cc95ba0209eef770fb9d00638b49";
    const char *pri = "9df809804369829983150491d1086b99f6493356f91ccc080e661a76a976a4ee";
    unsigned char ed25519_pub[32];
    unsigned char ed25519_pri[32];
    bbc_hex2bin(pub, ed25519_pub);
    bbc_hex2bin(pri, ed25519_pri);
    unsigned char nonce[32];
    randombytes_buf(nonce, 32);

    unsigned char pk[crypto_box_PUBLICKEYBYTES];
    unsigned char sk[crypto_box_SECRETKEYBYTES];
    if (crypto_sign_ed25519_pk_to_curve25519(pk, ed25519_pub) != 0)
    {
        std::cout << "crypto_sign_ed25519_pk_to_curve25519 err" << std::endl;
        return;
    }
    if (crypto_sign_ed25519_sk_to_curve25519(sk, ed25519_pri) != 0)
    {
        std::cout << "crypto_sign_ed25519_sk_to_curve25519 err" << std::endl;
        return;
    }

    unsigned char ciphertext[80];
    if (crypto_box_seal(ciphertext, nonce, 32, pk) != 0)
    {
        std::cout << "crypto_box_seal err" << std::endl;
        return;
    }

    unsigned char decrypted[32];
    if (crypto_box_seal_open(decrypted, ciphertext, 80, pk, sk) != 0)
    {
        std::cout << "crypto_box_seal_open err" << std::endl;
        return;
    }

    if (sodium_memcmp(decrypted, nonce, 32) != 0)
    {
        std::cout << "Err" << std::endl;
        return;
    }
    std::cout << "OK" << std::endl;
}