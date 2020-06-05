
import requests
import json
import pymysql
import time, datetime


connection = pymysql.connect(host="127.0.0.1", port=3306, user="root", password="123456", db="bigbang-debug")

def ExecSql(sql):
    try:
        cursor = connection.cursor()
        cursor.execute(sql)
        connection.commit()
    except Exception, e:
        print e

def run(url,node_name):
    #url = 'http://127.0.0.1:9902'
    #node_name = 'bigbang'

    data = '{"id":1,"method":"getblockcount","jsonrpc":"2.0","params":{}}'
    response = requests.post(url, data=data)
    result = json.loads(response.text)

    data = '{"id":1,"method":"getblockhash","jsonrpc":"2.0","params":{"height":%d}}' % (result["result"] - 1)

    response = requests.post(url, data=data)
    result = json.loads(response.text)
    block_hash = result["result"][0]

    while True:
        data = '{"id":1,"method":"getblock","jsonrpc":"2.0","params":{"block":"%s"}}' % block_hash 
        response = requests.post(url, data=data)
        result = json.loads(response.text)
    
        timeArray = time.localtime(result["result"]["time"])
        otherStyleTime = time.strftime("%Y-%m-%d %H:%M:%S", timeArray)

        sql = "INSERT into block(node,hash,height,dt,type)VALUES('%s','%s',%d,'%s','%s')" % (node_name,result["result"]["prev"], result["result"]["height"],otherStyleTime,result["result"]["type"])
        ExecSql(sql)
        

        for tx in result["result"]["tx"]:
            data = '{"id":13,"method":"gettransaction","jsonrpc":"2.0","params":{"txid":"%s","serialized":false}}' % tx     
            tx_res = requests.post(url, data=data)
            tx_obj = json.loads(tx_res.text)
            anchor = tx_obj["result"]["transaction"]["anchor"]
            type_ = tx_obj["result"]["transaction"]["type"]
            to = tx_obj["result"]["transaction"]["sendto"]
        
            timeArray = time.localtime(result["result"]["time"])
            otherStyleTime = time.strftime("%Y-%m-%d %H:%M:%S", timeArray)
            sql = "insert into tx(`name`,tx_hash,block_hash,anchor,type,`to`,dt)values('%s','%s','%s','%s','%s','%s','%s')" % (node_name, tx,block_hash,anchor,type_,to,otherStyleTime)
            ExecSql(sql)
    
        print result["result"]["height"]
        block_hash = result["result"]["prev"]
        if result["result"]["height"] == 1:
            break

run('http://127.0.0.1:9902','bigbang')

run('http://127.0.0.1:10902','dpos1')
run('http://127.0.0.1:11902','dpos2')
run('http://127.0.0.1:12902','dpos3')
run('http://127.0.0.1:13902','dpos4')
run('http://127.0.0.1:14902','dpos5')
