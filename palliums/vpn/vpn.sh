# 参考地址
# https://blog.csdn.net/u012843189/article/details/77422505

sudo rm /var/lib/dpkg/lock
sudo rm /var/cache/apt/archives/lock
sudo apt-get update
# 安装vpn 和证书工具
sudo apt-get install openvpn easy-rsa

# 使用证书工具创建证书文件夹
make-cadir ~/openvpn-ca

cd ~/openvpn-ca
# 编辑证书的变量
gedit vars

# 使变量生效
source vars

# 清理环境，并初始化文件
./clean-all

# 生成自签名的数字证书
./build-ca
# 使用根证书生成服务器证书
./build-key-server server
./build-dh
openvpn --genkey --secret keys/ta.key

# 使用根证书生成客户端证书
./build-key client1
./build-key client2

cd keys
# 把生成的服务器端证书 复制到配置文件夹中
sudo cp ca.crt ca.key server.crt server.key ta.key dh2048.pem /etc/openvpn

# 在默认配置上修改相关属性
sudo cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz /etc/openvpn/
cd /etc/openvpn/
sudo gzip -d server.conf.gz

sudo gedit /etc/openvpn/server.conf
# 编辑好的文件见 server.conf


# 开启网络转发
sudo gedit /etc/sysctl.conf
net.ipv4.ip_forward=1
sudo sysctl -p


# 调整防火墙（UFW）规则来伪装客户端的连接
ip route | grep default

sudo gedit /etc/ufw/before.rules
# 添加如下规则
'
# START OPENVPN RULES
# NAT table rules
*nat
:POSTROUTING ACCEPT [0:0]
# Allow traffic from OpenVPN client to eth0(changeto the interface you discovered!)
-A POSTROUTING -s 10.8.0.0/8 -o eth0 -jMASQUERADE
COMMIT
# END OPENVPN RULES
'

sudo gedit /etc/default/ufw
# 防火墙规则启用代理转发
'
DEFAULT_FORWARD_POLICY="ACCEPT"
'
# 防火墙启动端口
sudo ufw allow 1193/udp
# 防火墙启动openvpn
sudo ufw allow openvpn

# 启用防火墙，作为服务器启用防火墙才能更安全
#sudo ufw disable
sudo ufw enable

# 使配置文件生效，使用server.cnf配置文件重启openvpn
sudo systemctl start openvpn@server

# 查看服务工作状态
sudo systemctl status openvpn@server
# 查看 OpenVPN tun0接口是否可用
ip addr show tun0

# 设置开机启动项
sudo systemctl enable openvpn@server



# 还在同一台电脑上管理客户端文件
mkdir -p ~/client-configs/files
chmod 700 ~/client-configs/files
cd ~/client-configs/
cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf  ~/client-configs/base.conf
gedit base.conf
# 编辑客户端配置文件，详见base.conf

gedit make_config.sh

#!/bin/bash
# First argument: Client identifier
KEY_DIR=~/openvpn-ca/keys
OUTPUT_DIR=~/client-configs/files
BASE_CONFIG=~/client-configs/base.conf
cat ${BASE_CONFIG} \
    <(echo -e '<ca>') \
    ${KEY_DIR}/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    ${KEY_DIR}/${1}.crt \
    <(echo -e '</cert>\n<key>') \
    ${KEY_DIR}/${1}.key \
    <(echo -e '</key>\n<tls-auth>') \
    ${KEY_DIR}/ta.key \
    <(echo -e '</tls-auth>') \
    > ${OUTPUT_DIR}/${1}.conf
# 详见make_config.sh

chmod 700 ~/client-configs/make_config.sh

# 生成client1的配置文件
./make_config.sh client1
# 在files 文件下就能看到配置文件，里面包含数字证书



# 在客户端机器上的操作
sudo apt-get install openvpn
# 把上面生成的文件拷贝到配置处
sudo cp client1.conf /etc/openvpn/
# 使用配置文件重启openvpn
sudo systemctl start openvpn@client1
# 设置为开机启动项
sudo systemctl enable openvpn@client1
