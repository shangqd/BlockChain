#!/usr/bin/python3
# -*- coding: gbk -*-
import sys
#iconv -f UTF-8 -t GBK  utf8.py -o gbk.py
print(sys.getdefaultencoding())

def PrintGBK(s):
    s = s.encode("gbk")
    print(s)
    print(str(s,encoding="utf-8"))

# 'С'��GBK�ֽ����ǺϷ���utf-8�ֽ���������utf-8����̨�»����룬��gbk����̨���������
s = "С"
PrintGBK(s)

# '��'��GBK�ֽ������ǺϷ���utf-8�ֽ���,
# utf-8�ֽ����Ǳ䳤�ģ�Ϊ�˷ָ��ַ�������һ�����������е��ֽ������ܽ���
s = "��"
PrintGBK(s)