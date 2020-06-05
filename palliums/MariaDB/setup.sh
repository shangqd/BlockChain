# 本次实验参考如下地址 
# https://blog.csdn.net/chinagissoft/article/details/46964421
# os 16.04.1-Ubuntu
# mysql  Ver 15.1 Distrib 10.0.38-MariaDB, for debian-linux-gnu (x86_64) using readline 5.2

# 本实验需要三台机器
# IP:192.168.171.101部署node1
# IP:192.168.171.102部署node2
# IP:192.168.171.103部署node3

# 
sudo rm /var/lib/dpkg/lock
sudo rm /var/cache/apt/archives/lock

#
sudo apt-get update
sudo apt-get install software-properties-common python-software-properties

# 添加安装mariadb安装源
sudo add-apt-repository 'deb http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.0/ubuntu trusty main'
# 导入mariadb安装源的公钥
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db

# 更新安装包
sudo apt-get update
# 安装mariadb
sudo apt-get install rsync mariadb-galera-server openssh-server
sudo apt-get remove mariadb-galera-server
# node1 的配置文件内容为galera1.cnf
# node2 的配置文件内容为galera2.cnf
# node3 的配置文件内容为galera3.cnf
sudo vim /etc/mysql/conf.d/galera.cnf

# 先停止默认的启动项
sudo service mysql stop
# node1 启动的时候使用 增加--wsrep-new-cluster
sudo service mysql start --wsrep-new-cluster
# node2 或者node3 启动使用如下命令
sudo service mysql start

# 登录数据库完成后，使用如下命令查看集群数量
select variable_value from information_schema.global_status where variable_name="wsrep_cluster_size";

# 新建数据库和表，并给表中添加数据。
# 发现各节点数据能同步，表示配置成功。

# docker 部署，在docker 内部执行上面的命令 
sudo docker run -i -t -p 3306:3306 -p 4567:4567 ubuntu:16.04 /bin/bash
vim /etc/mysql/my.conf
# 启动网络服务
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '1234qwer' WITH GRANT OPTION;
FLUSH PRIVILEGES;