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
fs.nr_open = 100000


### nofile 用户进程支持的最大文件数(分为软[当前只]和硬[最大值])，也是编程标准获得的值
#### 临时
ulimit -n

#### 永久
/etc/security/limits.conf

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
file-max > nr_open >  nofile(hard) > nofile(soft) > 进程文件数
