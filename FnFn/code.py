#!/usr/bin/python3
# -*- coding: UTF-8 -*-

from binascii import hexlify, unhexlify

def PrintCode(s):
    print("字符:",s)
    print("uni:",s.encode('unicode-escape'))
    print("utf-16. prefix:",hexlify(s.encode('utf-16')[:2]),", content:",hexlify(s.encode('utf-16')[2:]))
    print("utf-8:",hexlify(s.encode('utf-8')))
    print("GB18030:",hexlify(s.encode('GB18030')))
    print("utf-32. prefix:",hexlify(s.encode('utf-32')[:4]),", content:",hexlify(s.encode('utf-32')[4:]))

def TestCode():
    a = 'a'
    PrintCode(a)
    print('-' * 10 + 'ascii字符' + '-' * 10)
    print('')
    a = '中'
    PrintCode(a)
    print('-' * 10 + '基准面' + '-' * 10)
    print('')
    a = '𠀋'
    PrintCode(a)
    print('-' * 10 + '扩展面' + '-' * 10)
TestCode()

# 'ܒ' '\u0712' 这个字符无论文件头部设置成gbk,还是utf-8,程序都能正常读取文件，但是会产生不同的输出
# 因为这个字的utf-8编码可以解释成合法gbk编码，标准汉字没有一个可以解释成功，
# 因此文件的编码编码标准一定要和文件头部设置的规则相同，防止出现隐藏的错误
s = 'ܒ' 
print(s)
''' 
字符: a
uni: b'a'
utf-16. prefix: b'fffe' , content: b'6100'
utf-8: b'61'
GB18030: b'61'
utf-32. prefix: b'fffe0000' , content: b'61000000'
----------ascii字符----------

字符: 中
uni: b'\\u4e2d'
utf-16. prefix: b'fffe' , content: b'2d4e'
utf-8: b'e4b8ad'
GB18030: b'd6d0'
utf-32. prefix: b'fffe0000' , content: b'2d4e0000'
----------基准面----------

字符: 𠀋
uni: b'\\U0002000b'
utf-16. prefix: b'fffe' , content: b'40d80bdc'
utf-8: b'f0a0808b'
GB18030: b'95328337'
utf-32. prefix: b'fffe0000' , content: b'0b000200'
----------扩展面----------
'''