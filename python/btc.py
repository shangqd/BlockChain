# -*- coding: UTF-8 -*-
'''
富豪榜
https://btc.com/stats/rich-list
'''
import requests
import json
import time
import os
import pymysql.cursors
import sys
import threading
from decimal import Decimal
import re
import traceback

reload(sys)  
sys.setdefaultencoding('utf8')

sys.path.append(re.sub("btc$","",os.getcwd(),1))

from config import config

class Work(threading.Thread):
    def __init__(self,tag,threads):
        super(Work, self).__init__()
        self.tag = tag
        self.connection = pymysql.connect(host=config.host,user=config.user,password=config.password,db=config.db,cursorclass=pymysql.cursors.DictCursor,charset='utf8')
        self.cursor = self.connection.cursor()
        self.threads = threads
    def ExecSql(self,sql):
        self.cursor.execute(sql)
        self.connection.commit()
    def GetBN(self):
        req = requests.get("https://blockchain.info/latestblock")
        text = json.loads(req.text);
        return text["height"]
    def GetBN_(self):
        self.cursor.execute("SELECT next_block from currency where symbol = 'btc'");
        self.connection.commit()
        result = self.cursor.fetchone()
        return int(result["next_block"])

   
    def TxInsert(self,tx_hash,bn,from_addr,to_addr,token_transfer,ts):
        sql = ("INSERT INTO tx_btc (tx_hash, block_number, from_addr,`to_addr`, token_transfer, tx_time) VALUES ('%s','%s','%s','%s',%s,from_unixtime(%s))" 
            % (tx_hash,bn,from_addr,to_addr,token_transfer,ts))
        self.ExecSql(sql);

    def run(self):
        bn = self.GetBN()
        bn = bn - bn % self.threads + self.tag
        print "%s_%s_%s\n" % (bn,self.tag,self.threads)
        while (True):
            try:
                url = "https://blockchain.info/block-height/%s?format=json" % bn;
                req = requests.get(url)
                if req.text == "Unknown Error Fetching Blocks From Database":
                    print("%s_sleep(100)" % self.tag);
                    time.sleep(100)
                    continue;
                text = json.loads(req.text);            
                if text.has_key("blocks"):
                    for b in text["blocks"]:
                        for tx in b["tx"]:
                            index = 0;
                            if len(tx["inputs"]) > len(tx["out"]):
                                for vin in tx["inputs"]:
                                    from_addr = ""
                                    from_token = 0
                                    if vin.has_key("prev_out"):
                                        from_addr = vin["prev_out"]["addr"];
                                        from_token = Decimal(vin["prev_out"]["value"]) / Decimal(10 ** 8)
                                    sql = ""
                                    if index >= len(tx["out"]):
                                        sql = ("INSERT into tx_btc1(tx_hash,from_addr,from_token,block_number,tx_time)values('%s','%s',%s,%s,from_unixtime(%s))"
                                        % (tx["hash"],from_addr,from_token,bn,tx["time"]))
                                    else:
                                        to_addr = ""
                                        token_transfer = 0
                                        if tx["out"][index].has_key("addr"):
                                            to_addr =  tx["out"][index]["addr"];
                                            token_transfer = Decimal(tx["out"][index]["value"]) / Decimal(10 ** 8);
                                        sql = ("INSERT into tx_btc1(tx_hash,from_addr,from_token,to_addr,token_transfer,block_number,tx_time)values('%s','%s',%s,'%s',%s,%s,from_unixtime(%s))"
                                        %(tx["hash"],from_addr,from_token,to_addr,token_transfer,bn,tx["time"]))
                                    self.ExecSql(sql)
                                    index = index + 1
                            else:
                                for vout in tx["out"]:
                                    to_addr = ""
                                    token_transfer = 0
                                    if vout.has_key("addr"):
                                        to_addr = vout["addr"]
                                        token_transfer = Decimal(vout["value"]) / Decimal(10 ** 8);
                                    sql = ""
                                    if index >= len(tx["inputs"]):
                                        sql = ("INSERT into tx_btc1(tx_hash,to_addr,token_transfer,block_number,tx_time)values('%s','%s',%s,%s,from_unixtime(%s))"
                                            % (tx["hash"],to_addr,token_transfer,bn,tx["time"]))
                                    else:
                                        from_addr = ""
                                        from_token = 0
                                        if tx["inputs"][index].has_key("prev_out"):
                                            from_addr = tx["inputs"][index]["prev_out"]["addr"]
                                            from_token = Decimal(tx["inputs"][index]["prev_out"]["value"]) / Decimal(10 ** 8)
                            
                                        sql = ("INSERT into tx_btc1(tx_hash,from_addr,from_token,to_addr,token_transfer,block_number,tx_time)values('%s','%s',%s,'%s',%s,%s,from_unixtime(%s))"
                                                % (tx["hash"],from_addr,from_token,to_addr,token_transfer,bn,tx["time"]))
                                    self.ExecSql(sql)
                                    index = index + 1
                bn = bn + self.threads;
                sql = ("update currency set next_block = %d where symbol = 'btc'" % bn);
                self.ExecSql(sql);
                print("bn:%d;tag:%d" % (bn,self.tag));
            except Exception as e:
                print 'traceback.format_exc():\n%s' % traceback.format_exc()
                print e

if __name__ == '__main__':
    threads = 1
    t = Work(0,threads)
    t.run()
    sys.exit();
    for i in xrange(threads):
        t = Work(i,threads)
        t.start()