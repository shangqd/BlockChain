# 本次实验参考如下地址 
# https://dev.mysql.com/doc/refman/5.7/en/mysql-cluster-install-linux-binary.html
# 本次实验使用的软件版本为:mysql-cluster-gpl-7.5.10
# 下载地址为:http://mirrors.sohu.com/mysql/MySQL-Cluster-7.5/

# 本实验需要三台机器
# IP:192.168.171.100部署管理节点 
# IP:192.168.171.101部署数据节点和数据API节点
# IP:192.168.171.102部署数据节点和数据API节点

sudo groupadd mysql
sudo useradd -g mysql -s /bin/false mysql
sudo tar -C /usr/local -xzvf mysql-cluster-gpl-7.5.10-linux-glibc2.12-x86_64.tar.gz 
sudo ln -s /usr/local/mysql-cluster-gpl-7.5.10-linux-glibc2.12-x86_64 /usr/local/mysql

sudo apt-get update
sudo apt-get install openssh-server libaio1
cd /usr/local/mysql
sudo cp bin/mysqld /usr/local/bin/mysqld
sudo cp bin/mysql /usr/local/bin/mysql

sudo cp bin/ndbd /usr/local/bin/ndbd
sudo cp bin/ndbmtd /usr/local/bin/ndbmtd
sudo cp bin/ndb_mgm* /usr/local/bin
sudo cp support-files/mysql.server /etc/init.d/

sudo gedit /etc/init.d/mysql.server
# 找到$lsb_functions修改成如下 或者见文件./mysql.server
'
  #. $lsb_functions
  log_success_msg()
  {
    echo " SUCCESS! $@"
  }
  log_failure_msg()
  {
    echo " ERROR! $@"
  }
'

sudo mysqld --initialize 

# 记录输出的密码，后面登录修改密码的时候使用。本次生成为:MgNLz0hIGd-t

sudo chown -R mysql data

sudo mkdir /var/lib/mysql-cluster

# 修改mysql的配置文件如下，或者见文件./my.cnf
sudo gedit /etc/my.cnf
'
[mysqld]
ndbcluster
ndb-connectstring=192.168.171.100

[mysql_cluster]
ndb-connectstring=192.168.171.100
'

# 服务器端配置
sudo gedit /var/lib/mysql-cluster/config.ini
# 编辑内容如下，或者见文件./config.ini
'
[ndbd default]
NoOfReplicas=2
DataMemory=512M
IndexMemory=18M

[ndb_mgmd]
HostName=192.168.171.100
DataDir=/var/lib/mysql-cluster

[ndbd]
HostName=192.168.171.101
DataDir=/var/lib/mysql-cluster

[ndbd]
HostName=192.168.171.102
DataDir=/var/lib/mysql-cluster

[mysqld]
HostName=192.168.171.101
[mysqld]
HostName=192.168.171.102
[api]
HostName=192.168.171.101
[api]
HostName=192.168.171.102'
# 第一次启动服务节点
sudo ndb_mgmd -f /var/lib/mysql-cluster/config.ini --initial
# 后续启动服务节点
sudo ndb_mgmd -f /var/lib/mysql-cluster/config.ini
# 下面命令查看连接状态
ndb_mgm->show

# 下面的内容为数据节点和数据API部署

# 第一次启动数据节点
sudo ndbd --initial

# 后续启动数据节点
sudo ndbd

# 启动数据节点API
sudo /etc/init.d/mysql.server start

# 登录数据库修改密码
sudo mysql -u root -p
set password for root@localhost = password('1234qwer');

# 创建数据库和表，表的引擎为NDBCLUSTER，否则退化为普通的表
# CREATE TABLE student (age INT) ENGINE=NDBCLUSTER
# 测试两个数据库创建表，删除和修改数据，发现能改正常同步