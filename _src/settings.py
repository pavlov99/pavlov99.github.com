#!/usr/bin/env python
# coding: utf-8

from os import path as op

ROOT_PATH = op.abspath(op.dirname(op.dirname(__file__)))

AUTHOR = 'Kirill Pavlov'
SITENAME = 'pavlov99.github.io'
SITEURL = 'http://pavlov99.github.io'
REVERSE_ARCHIVE_ORDER = True
OUTPUT_PATH = op.join(ROOT_PATH, 'ui')
print(OUTPUT_PATH)
TIMEZONE = 'Asia/HongKong'
