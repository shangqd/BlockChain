### file-max 内核支持的最大文件数（所有进程加到一起支持的最大文件数）
#### 临时
echo 1000000 > /proc/sys/fs/file-max
#### 永久
vim /etc/sysctl.conf    
fs.file_max = 10000000

### nr_open 进程支持的最大文件数
#### 临时
echo 1000000 > /proc/sys/fs/nr_open
#### 永久
vim /etc/sysctl.conf   
fs.nr_open = 100000

### nofile 用户进程支持的最大文件数(分为软[rlim_cur]和硬[rlim_max])
#### 临时
ulimit -n 10000

#### 永久
vim /etc/security/limits.conf   
```
#在最后加入
root soft nofile 65535
root hard nofile 65535
* soft nofile 65535
* hard nofile 65535
```

``` C++
#include <stdio.h>
#include <sys/resource.h>
#include <stdlib.h>
#include <errno.h>

#define handle_error(msg) \
                    do{perror(msg);exit(EXIT_FAILURE);}while(0)

int main(int argc, char** argv)
{
    struct rlimit limit;
    if (getrlimit(RLIMIT_NOFILE,&limit) == -1)
        handle_error("getrlimit");
    printf("getrlimit1 = %d\n",(int)limit.rlim_cur);
    printf("getrlimit2 = %d\n",(int)limit.rlim_max);

    return 0;
}
```

### 总结
file-max(内核限制) >= nr_open（进程限制） >=  nofile(rlim_max)（用户进程限制） >= nofile(rlim_cur)（用户进程限制）>= 进程实际打开文件数

### bbc 程序出现问题后的状态
