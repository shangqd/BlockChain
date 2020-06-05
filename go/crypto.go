package main

import (
	"crypto/md5"
    "crypto/sha1"
    "crypto/sha256"
    "crypto/sha512"
    "fmt"
    "io"
    "os"
)

func crypto_test() {
	teststring := "welcome to beijing"
	Md5Inst := md5.New()
    Md5Inst.Write([]byte(teststring))
    result := Md5Inst.Sum([]byte(""))
    fmt.Printf("%x\n\n", result)
    //SHA1
    Sha1Inst := sha1.New()
    Sha1Inst.Write([]byte(teststring))
    result = Sha1Inst.Sum([]byte(""))
    fmt.Printf("%x\n\n", result)

	sha256Inst := sha256.New()
    sha256Inst.Write([]byte(teststring))
    result = sha256Inst.Sum([]byte(""))
    fmt.Printf("%x\n\n", result)
    
    sha512Inst := sha512.New()
    sha512Inst.Write([]byte(teststring))
    result = sha512Inst.Sum([]byte(""))
    fmt.Printf("%x\n\n", result)
    
    
    // file md5 and sha1
    testfile := "notes.txt"
    infile, err := os.Open(testfile)
    defer infile.Close()
    if err == nil {
        md5h := md5.New()
        io.Copy(md5h, infile)
        fmt.Printf("%x %s\n", md5h.Sum([]byte("")), testfile)
        //sha1
        sha1h := sha1.New()
        io.Copy(sha1h, infile)
        fmt.Printf("%x %s\n", sha1.Sum([]byte("")), testfile)
    } else {
        fmt.Println(err)
        os.Exit(1)
    }
}