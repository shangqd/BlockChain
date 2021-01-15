#!/usr/bin/python
# -*- coding: UTF-8 -*-

'''
from TokenDistribution import TokenDistribution

td = TokenDistribution()

def getm(v2):
    if v2 > 129600:
        m = 1153 * 43200 + 1043 * 43200  + 933 * 43200 + 823 * (v2 - 129600)
    elif v2 > 86400:
        m = 1153 * 43200 + 1043 * 43200  + 933 * (v2 - 86400)
    elif v2 > 43200:
        m = 1153 * 43200 + 1043 * (v2 - 43200)
    else:
        m = 1153 * v2
    return m

err = 0
for i in range(129800):
    v1 = getm(i)
    v2 = td.GetTotal(i)
    if v1 != v2:
        err = err + 1
        print "err"
print "err=%d" % err
'''

from binascii import hexlify, unhexlify

def PrintCode(s):
    print(s)
    print("uni:",a.encode('unicode-escape'))
    print("utf-16:",hexlify(a.encode('utf-16')[2:]))
    print("utf-8:",a.encode('utf-8'))
    print("GB18030:",a.encode('GB18030'))
    print("utf-32:",hexlify(a.encode('utf-32')[4:]))

a = 'a'
PrintCode(a)
print("-----------------------")
a = '中'
PrintCode(a)
print("-----------------------")
a = '𠀋'
#\ud869\udfdd
PrintCode(a)
print("-----------------------")

a
uni: b'a'
utf-16: b'6100'
utf-8: b'a'
GB18030: b'a'
utf-32: b'61000000'
-----------------------
中
uni: b'\\u4e2d'
utf-16: b'2d4e'
utf-8: b'\xe4\xb8\xad'
GB18030: b'\xd6\xd0'
utf-32: b'2d4e0000'
-----------------------
𠀋
uni: b'\\U0002000b'
utf-16: b'40d80bdc'
utf-8: b'\xf0\xa0\x80\x8b'
GB18030: b'\x952\x837'
utf-32: b'0b000200'
