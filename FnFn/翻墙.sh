#安装privoxy，并让他指向sslocal
/etc/privoxy/config 最后一行添加如下
forward-socks5 / 127.0.0.1:1080 .
#sudo sslocal -s la2-ss.gmdns.net -p 45114 -b 127.0.0.1 -l 1080 -k 7d135ce8 -d start
#proxy="http://127.0.0.1:8118"
#export http_proxy=$proxy
#export https_proxy=$proxy
#export no_proxy="localhost, 127.0.0.1, ::1"
#curl -4sSkL https://myip.ipip.net
