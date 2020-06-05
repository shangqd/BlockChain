ssh shangqd@47.106.208.207

OVPN_DATA="/home/shangqd/ovpn-data"
# 下面的全局变量换成你的服务器的外网ip
IP="47.106.208.207"
mkdir ${OVPN_DATA}

# 第二步
sudo docker run -v ${OVPN_DATA}:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u tcp://${IP}

# 第三步
sudo docker run -v ${OVPN_DATA}:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki

# ---------------------------------------------------------
#Enter PEM pass phrase: 输入123456（你是看不见的）
#Verifying - Enter PEM pass phrase: 输入123456（你是看不见的）
#Common Name (eg: your user, host, or server name) [Easy-RSA CA]:回车一下
#Enter pass phrase for /etc/openvpn/pki/private/ca.key:输入123456
# ---------------------------------------------------------

# 第五步
sudo docker run -v ${OVPN_DATA}:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full shang nopass

# ---------------------------------------------------------
#Enter pass phrase for /etc/openvpn/pki/private/ca.key:输入123456
# ---------------------------------------------------------

# 第六步
sudo docker run -v ${OVPN_DATA}:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient shang > ${OVPN_DATA}/shang.ovpn
# 第七步
sudo docker run --name openvpn -v ${OVPN_DATA}:/etc/openvpn -d -p 1194:1194 --privileged kylemanna/openvpn

scp  shangqd@47.106.208.207:~/ovpn-data/shang.ovpn ~/shang.ovpn


# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 如果  ${OVPN_DATA} 已经生成 就不用那么麻烦了  直接  执行下面的步骤就可以使用了
sudo docker pull kylemanna/openvpn
sudo docker run --name openvpn -v ${OVPN_DATA}:/etc/openvpn -d -p 1194:1194 --privileged kylemanna/openvpn


# ssh shangqd@52.27.228.84
# =======================
sudo docker pull kylemanna/openvpn:2.4

mkdir -p ~/openvpn

sudo docker run -v ~/openvpn:/etc/openvpn --rm kylemanna/openvpn:2.4 ovpn_genconfig -u udp://52.27.228.84

sudo docker run -v ~/openvpn:/etc/openvpn --rm -it kylemanna/openvpn:2.4 ovpn_initpki
sudo docker run -v ~/openvpn:/etc/openvpn --rm -it kylemanna/openvpn:2.4 easyrsa build-client-full shang nopass

mkdir -p ~/openvpn/conf
sudo docker run -v ~/openvpn:/etc/openvpn --rm kylemanna/openvpn:2.4 ovpn_getclient shang > ~/openvpn/conf/shang.ovpn

sudo docker run --name openvpn -v ~/openvpn:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn:2.4

sudo sysctl -w net.ipv4.conf.default.accept_source_route=1  
sudo sysctl -w net.ipv4.conf.all.rp_filter=0    
sudo sysctl -w net.ipv4.ip_forward=1

scp  shangqd@52.27.228.84:~/openvpn/conf/shang.ovpn ~/shang.ovpn

sudo docker exec -it openvpn /bin/bash