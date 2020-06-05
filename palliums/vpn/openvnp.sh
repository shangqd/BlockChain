### Ubuntu 16.04搭建OpenVPN服务器以及客户端的使用
# 参考地址 http://www.manongjc.com/detail/6-eqkmpihxsfrrauu.html

#1、安装前准备
# 安装openssl和lzo，lzo用于压缩通讯数据加快传输速度
sudo apt-get install openssl libssl-dev
sudo apt-get install lzop

#2、安装及配置OpenVPN和easy-rsa
# 安装openvpn和easy-rsa
sudo apt-get install openvpn
sudo apt-get install easy-rsa

# 修改vars文件 
sudo su
cd /usr/share/easy-rsa/ 
vim vars

# 修改注册信息，比如公司地址、公司名称、部门名称等。
export KEY_COUNTRY="CN"
export KEY_PROVINCE="Shandong"
export KEY_CITY="Qingdao"
export KEY_ORG="MyOrganization"
export KEY_EMAIL="me@myhost.mydomain"
export KEY_OU="MyOrganizationalUnit"

# 初始化环境变量
source vars
 
# 清除keys目录下所有与证书相关的文件
# 下面步骤生成的证书和密钥都在/usr/share/easy-rsa/keys目录里
./clean-all
 
# 生成根证书ca.crt和根密钥ca.key（一路按回车即可）
./build-ca
 
# 为服务端生成证书和私钥（一路按回车，直到提示需要输入y/n时，输入y再按回车，一共两次）
./build-key-server server
 
# 每一个登陆的VPN客户端需要有一个证书，每个证书在同一时刻只能供一个客户端连接，下面建立2份
# 为客户端生成证书和私钥（一路按回车，直到提示需要输入y/n时，输入y再按回车，一共两次）
./build-key client1
./build-key client2
 
# 创建迪菲·赫尔曼密钥，会生成dh2048.pem文件（生成过程比较慢，在此期间不要去中断它）
./build-dh
 
# 生成ta.key文件（防DDos攻击、UDP淹没等恶意攻击）
openvpn --genkey --secret keys/ta.key


#3、创建服务器端配置文件

# 在openvpn的配置目录下新建一个keys目录
mkdir /etc/openvpn/keys
 
# 将需要用到的openvpn证书和密钥复制一份到刚创建好的keys目录中
cp /usr/share/easy-rsa/keys/{ca.crt,server.{crt,key},dh2048.pem,ta.key} /etc/openvpn/keys/
 
# 复制一份服务器端配置文件模板server.conf到/etc/openvpn/
gzip -d /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz
cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf /etc/openvpn/

# 查看server.conf里的配置参数
grep '^[^#;]' /etc/openvpn/server.conf

# 编辑server.conf
vim /etc/openvpn/server.conf 

port 1194
# 改成tcp，默认使用udp，如果使用HTTP Proxy，必须使用tcp协议
proto tcp
dev tun # 路由模式，桥接模式用dev tap
# 路径前面加keys，全路径为/etc/openvpn/keys/ca.crt
ca keys/ca.crt
cert keys/server.crt
key keys/server.key  # This file should be kept secret
dh keys/dh2048.pem
# 默认虚拟局域网网段，不要和实际的局域网冲突即可
server 10.8.0.0 255.255.255.0 # 路由模式，桥接模式用server-bridge
ifconfig-pool-persist ipp.txt
# 10.0.0.0/8是我这台VPN服务器所在的内网的网段，读者应该根据自身实际情况进行修改
push "route 10.0.0.0 255.0.0.0"
# 可以让客户端之间相互访问直接通过openvpn程序转发，根据需要设置
client-to-client
# 如果客户端都使用相同的证书和密钥连接VPN，一定要打开这个选项，否则每个证书只允许一个人连接VPN
duplicate-cn
keepalive 10 120
tls-auth keys/ta.key 0 # This file is secret
comp-lzo
persist-key
persist-tun
# OpenVPN的状态日志，默认为/etc/openvpn/openvpn-status.log
status openvpn-status.log
# OpenVPN的运行日志，默认为/etc/openvpn/openvpn.log 
log-append openvpn.log
# 改成verb 5可以多查看一些调试信息
verb 5

#4、配置内核和防火墙，启动服务

# 开启路由转发功能
sed -i '/net.ipv4.ip_forward/s/0/1/' /etc/sysctl.conf
sed -i '/net.ipv4.ip_forward/s/#//' /etc/sysctl.conf
sysctl -p
 
# 配置防火墙，别忘记保存
# iptables -I INPUT -p tcp --dport 1194 -m comment --comment "openvpn" -j ACCEPT (我觉的这一步可以不要)
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j MASQUERADE
mkdir /etc/iptables
iptables-save > /etc/iptables/iptables.conf
# 关闭ufw防火墙，改成iptables，这一步按需要设置，比较ufw在Ubuntu默认关闭的。iptables和ufw任选一个即可。
ufw disable
 
# 启动openvpn并设置为开机启动
systemctl start openvpn@server  
systemctl enable openvpn@server  
# 在systemd单元文件的后面，我们通过指定特定的配置文件名来作为一个实例变量来开启OpenVPN服务，我们的配置文件名称为/etc/openvpn/server.conf，所以我们在systemd单元文件的后面添加@server来开启OpenVPN服务

#5、创建客户端配置文件client.ovpn（用于客户端软件使用）
# 复制一份client.conf模板命名为client.ovpn
cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf /etc/openvpn/client.ovpn  

# 编辑client.ovpn
vim /etc/openvpn/client.ovpn

client
dev tun # 路由模式
# 改为tcp
proto tcp
# OpenVPN服务器的外网IP和端口
remote 203.195.1.2 1194
resolv-retry infinite
nobind
persist-key
persist-tun
ca ca.crt
# client1的证书
cert client1.crt
# client1的密钥
key client1.key
ns-cert-type server
# 去掉前面的注释
tls-auth ta.key 1
comp-lzo
verb 5

#6、配置client
#安装软件，可以和服务器安装的保持一致：
# 安装openssl和lzo，lzo用于压缩通讯数据加快传输速度
sudo apt-get install openssl libssl-dev
sudo apt-get install lzop

# 安装openvpn和easy-rsa
sudo apt-get install openvpn
sudo apt-get install easy-rsa

#在服务器上下载回需要的文件

sz /etc/openvpn/client.ovpn /etc/openvpn/keys/ca.crt /etc/openvpn/keys/client1.crt /etc/openvpn/keys/client1.key /etc/openvpn/keys/ta.key

#将OpenVPN服务器上的client.ovpn、ca.crt、client1.crt、client1.key、ta.key上传到Linux客户端安装目录下的/etc/openvpn文件夹（使用rz命令）

[root@linux64 openvpn]# pwd
/etc/openvpn
[root@linux64 openvpn]# ls
ca.crt client1.crt client1.key client.ovpn conf ta.key

#启动客户端

openvpn --daemon --cd /etc/openvpn --config client.ovpn --log-append /var/log/openvpn.log &

#上面是以守护进程启动的，可以把上面脚本放在/etc/rc.local实现开机启动。或者使用以服务的形式启动，如果想清晰明了，建议放在启动脚本。

