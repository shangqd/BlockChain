# 查看回话
screen -ls
# 创建一个回话
screen -S shang
# 恢复一个回话
screen -r 17708
# 删除一个已经不行的回话
screen -X -S 17708 quit
