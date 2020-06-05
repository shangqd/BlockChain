# -*- coding: UTF-8 -*-
import requests
import json
from bs4 import BeautifulSoup
import os
import sys
import re
import threading
import traceback
import pymysql.cursors
import time
import datetime;

reload(sys)  
sys.setdefaultencoding('utf8')
sys.path.append(re.sub("usdt$","",os.getcwd(),1))
from config import config

class Work(threading.Thread):
    def __init__(self,page):
        super(Work, self).__init__()
        self.connection = pymysql.connect(host=config.host,user=config.user,password=config.password,db=config.db,cursorclass=pymysql.cursors.DictCursor,charset='utf8')
        self.cursor = self.connection.cursor()
        self.page = page

    def ExecSql(self,sql):
        self.cursor.execute(sql)
        self.connection.commit()
    
    def insert_data(self,tx_hash,from_addr,to_addr,token_transfer,blocktime):
        sql = "select count(id) as c from tx_usdt where tx_hash = '%s'" % tx_hash
        self.cursor.execute(sql);
        self.connection.commit()
        result = self.cursor.fetchone()
        if result["c"] == 0:
            sql = ("insert into tx_usdt(tx_hash,from_addr,to_addr,token_transfer,tx_time,block_number)values('%s','%s','%s',%s,FROM_UNIXTIME(%s),0)" 
                    % (tx_hash,from_addr,to_addr,token_transfer,blocktime))
            self.ExecSql(sql)

    def run(self):
        url = "https://api.omniexplorer.info/v1/transaction/general/%s" % self.page
        req = requests.get(url,timeout=5)
        data = json.loads(req.text);
        for tx in data["transactions"]:
            try:
                if tx["propertyname"] == "TetherUS":
                    self.insert_data(tx["txid"],tx["sendingaddress"],tx["referenceaddress"], tx["amount"], tx["blocktime"])
            except Exception as e:
                print 'traceback.format_exc():\n%s' % traceback.format_exc()
                print e
        print 'page : %s \r' % self.page

def get_pages():
    url = "https://api.omniexplorer.info/v1/transaction/general/0";
    req = requests.get(url,timeout=5)
    data = json.loads(req.text);
    return data["pages"]

if __name__ == '__main__':
    pages = get_pages();
    while True:
        try:
            new_pages = get_pages();
            print datetime.datetime.now(), pages,new_pages
            if (pages == new_pages):
                time.sleep(10);
                continue;
            n = new_pages - pages + 2;
            print datetime.datetime.now(),n
            threads = []
            for i in range(1,n):
                t = Work(i)
                threads.append(t);
                t.start()
                time.sleep(5);
            for t in threads:
                t.join();
            pages = new_pages;
        except Exception as e:
                print 'traceback.format_exc():\n%s' % traceback.format_exc()
                print e