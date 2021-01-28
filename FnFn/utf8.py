#!/usr/bin/python3
# -*- coding: utf-8 -*-
import sys
#iconv -f UTF-8 -t GBK  utf8.py -o gbk.py
print(sys.getdefaultencoding())

def PrintGBK(s):
    s = s.encode("gbk")
    print(s)
    print(str(s,encoding="utf-8"))

# '小'的GBK字节流是合法的utf-8字节流，但在utf-8控制台下会乱码，在gbk控制台下输出正常
s = "小"
PrintGBK(s)

# '中'的GBK字节流不是合法的utf-8字节流,
# utf-8字节流是变长的，为了分割字符编码有一定规则不是所有的字节流都能解析
s = "中"
PrintGBK(s)