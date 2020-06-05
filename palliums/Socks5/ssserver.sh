
# 安装翻墙软件
sudo apt-get update
#sudo apt-get upgrade
sudo apt-get install python3-pip
sudo pip3 install setuptools -i https://pypi.tuna.tsinghua.edu.cn/simple
sudo pip3 install shadowsocks -i https://pypi.tuna.tsinghua.edu.cn/simple

ssserver -p 8000 -k 123456 -m aes-256-cfb -d start

ssserver -p 8000 -k password -m aes-256-cfb -d start
ssserver -p 8000 -k password -m aes-256-cfb -d stop

# 编辑配置文件
vim  ./shadowsocks.json 
{
    "server": "0.0.0.0",
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "port_password": {
        "38011": "user38011",
        "38012": "user38012",
        "38013": "user38013"
    },
    "timeout": 300,
    "method": "rc4-md5",
    "fast_open": false
}

ssserver -c shadowsocks.json start
ssserver -c shadowsocks.json -d start
/var/log/shadowsocks.log

#  客户端使用 Shadowsocks.exe 配置服务和端口 就能完成代理通信

sudo apt-get install python-pip
sudo pip install shadowsocks -i https://pypi.tuna.tsinghua.edu.cn/simple

两行代码安装shadowsocks

sudo sslocal -s serverip -p 8000 -b 127.0.0.1 -l 1080 -k password -m aes-256-cfb -d start
sudo sslocal -s serverip -p 8000 -b 127.0.0.1 -l 1080 -k password -m aes-256-cfb -d stop

两行代码启动或关闭shadowsocks client，8000是远程服务端口，1080是本地服务端口，password是密码，aes-256-cfb是加密方式，1080是本地的socks端口。以上命令就可以将远程的shadowsocks服务，代理到本地的1080端口。

apt-get install tsocks
vim /etc/tsocks.conf
server = 127.0.0.1 # SOCKS 服务器的 IP
server_type = 5 # SOCKS 服务版本
server_port = 1080 ＃SOCKS 服务使用的端口

sudo apt  install rinetd
sudo vim /etc/rinetd.conf 

pkill rinetd  ##关闭进程
rinetd -c /etc/rinetd.conf  ##启动转发


