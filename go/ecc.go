/*
 * 这个文章把曲线算法说的比较详细
 *http://blog.51cto.com/11821908/2057726
 */
package main

import (
    "crypto/ecdsa"
    "crypto/elliptic"
    "crypto/rand"
    "fmt"
)

func test_ecc(){
    prk, _:= ecdsa.GenerateKey(elliptic.P224(), rand.Reader)
    puk := prk.PublicKey
    // 需要两个私钥，因此需要一个随机因子生成另外一个密钥
	r, s, _:= ecdsa.Sign(rand.Reader, prk, []byte("尚庆东"))
	result := ecdsa.Verify(&puk,[]byte("尚庆东"), r, s)
    fmt.Println(result)
}
