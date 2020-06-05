
https://git.gnunet.org/libmicrohttpd.git

https://sigrok.org/wiki/Libserialport

sudo apt install libbluetooth-dev

git clone https://github.com/eclipse/paho.mqtt.c.git
cd paho.mqtt.c
git checkout v1.3.0
mkdir build && cd build
cmake -DPAHO_WITH_SSL=TRUE .. && make
sudo make install


gatlib
https://github.com/labapart/gattlib

./lws_client --privkey 8102db22dcc095d4d685613ca89a5d938e2de39954b5aa46f975ded23d9c9d69 --fork  d62c1fca5f2aacf9cf5738ed057d9987373508d8984734fa8fac05a6780a7cfd --serverURL tcp://127.0.0.1:11883
