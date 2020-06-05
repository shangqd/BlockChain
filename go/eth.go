/*
 * 爬虫程序，从以太坊上的富豪榜
 */
package main

import (
	"fmt"
	"log"
	"net/http"
	"github.com/PuerkitoBio/goquery"
	"strings"
	"strconv"
)

func Etherscan() {
  res, err := http.Get("https://etherscan.io/accounts")
  if err != nil {
    log.Fatal(err)
  }
  defer res.Body.Close()
  if res.StatusCode != 200 {
    log.Fatalf("status code error: %d %s", res.StatusCode, res.Status)
  }

  doc, err := goquery.NewDocumentFromReader(res.Body)
  if err != nil {
    log.Fatal(err)
  }

  doc.Find(".table-responsive tr").Each(func(i int, s *goquery.Selection) {
  		if (i > 0){
		    Rank := s.Find("td:nth-child(1)").Text()
		    Address := s.Find("td:nth-child(2)").Text()
		    Address = strings.Replace(Address, " ", "", -1)
		    // 这样截取必须都是汉字
			Address = string([]byte(Address)[:42])
		    Balance := s.Find("td:nth-child(3)").Text()
		    Balance = strings.Replace(Balance, ",", "", -1)
		    Balance = strings.Replace(Balance, " Ether", "", -1)
		    var Balance_f, _ = strconv.ParseFloat(Balance, 32)
		    Percentage := s.Find("td:nth-child(4)").Text()
		    fmt.Printf("Rank:%s,Address:%s,Balance:%f,Percentage:%s \n",Rank,Address,Balance_f,Percentage)
  		}
  })
}

