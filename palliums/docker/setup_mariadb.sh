ssh shangqd@47.106.208.207
# 2019Yhd8R6
ssh-copy-id shangqd@47.106.208.207
# 
#成都 腾讯云 148.70.43.108
#美国俄勒冈 亚马逊云 52.27.228.84
#深圳 阿里云 47.106.208.207

# 使用同样的配置文件mysql_server.cnf
# 148.70.43.108 执行如下命令
ssh shangqd@148.70.43.108
mkdir mysql.conf.d
exit
scp ~//code/explorer/docker/mysql_server.cnf  shangqd@148.70.43.108:~/mysql.conf.d/mysql_server.cnf
ssh shangqd@148.70.43.108
# 清理以前数据
sudo rm -rf /mnt/data
sudo mkdir -p /mnt/data
# 使用mariadb:10.3.13版本(官方推荐稳定版本)，这个是启动节点
sudo docker run \
  --name mariadb-0 \
  -d \
  -v /home/shangqd/mysql.conf.d:/etc/mysql/conf.d \
  -v /mnt/data:/var/lib/mysql \
  -e MYSQL_INITDB_SKIP_TZINFO=yes \
  -e MYSQL_ROOT_PASSWORD=1234qwer \
  -p 3306:3306 \
  -p 4567:4567/udp \
  -p 4567-4568:4567-4568 \
  -p 4444:4444 \
  mariadb:10.3.13 \
  --wsrep-new-cluster \
  --wsrep_node_address=148.70.43.108

# 执行命令查看数据
sudo docker exec -it mariadb-0 /bin/bash
# 停止服务
sudo docker stop mariadb-0
# 启动服务
sudo docker start mariadb-0
# 删除容器
sudo docker rm mariadb-0
# 查看日志
sudo docker logs -f mariadb-0

# 52.27.228.84 执行如下命令

ssh shangqd@52.27.228.84
mkdir mysql.conf.d
sudo rm -rf /mnt/data
sudo mkdir -p /mnt/data

scp ~/code/explorer/docker/mysql_server.cnf  shangqd@52.27.228.84:~/mysql.conf.d/mysql_server.cnf

sudo docker run \
  --name mariadb-1 \
  -d \
  -v /home/shangqd/mysql.conf.d:/etc/mysql/conf.d \
  -v /mnt/data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=1234qwer \
  -p 3306:3306 \
  -p 4567:4567/udp \
  -p 4567-4568:4567-4568 \
  -p 4444:4444 \
  mariadb:10.3.13 \
  --wsrep_node_address=52.27.228.84

sudo docker exec -it mariadb-1 /bin/bash
sudo docker logs -f mariadb-1 
sudo docker stop mariadb-1
sudo docker rm mariadb-1

# 47.106.208.207 执行如下命令
ssh shangqd@47.106.208.207
sudo docker stop mariadb-2
sudo docker rm mariadb-2

mkdir mysql.conf.d
sudo rm -rf /mnt/data
sudo mkdir -p /mnt/data

scp ~/code/explorer/docker/mysql_server.cnf  shangqd@47.106.208.207:~/mysql.conf.d/mysql_server.cnf

sudo docker run \
  --name mariadb-2 \
  -d \
  -v /home/shangqd/mysql.conf.d:/etc/mysql/conf.d \
  -v /mnt/data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=1234qwer \
  -p 3306:3306 \
  -p 4567:4567/udp \
  -p 4567-4568:4567-4568 \
  -p 4444:4444 \
  mariadb:10.3.13 \
  --wsrep_node_address=47.106.208.207

sudo docker exec -it mariadb-2 /bin/bash
sudo docker start mariadb-2
sudo docker logs -f mariadb-2

# 调试命令
# 删除容器
sudo docker stop $(sudo docker ps -a -q)
sudo docker rm $(sudo docker ps -a -q)
# 进入系统调式
sudo docker exec -it mariadb-0 /bin/bash
# 查看日志
sudo docker logs -f mariadb-2
# 查看当前还有多少连接
select variable_value from information_schema.global_status where variable_name="wsrep_cluster_size";

# 重启一个节点后，不能正常连接，可以使用如下命令
mysql -uroot -h 127.0.0.1 -p 