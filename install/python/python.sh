#!/bin/bash

# set baidu repository
pip config set global.index-url https://mirror.baidu.com/pypi/simple
pip config set install.trusted-host https://mirror.baidu.com 
# install python dependencies
pip install -r /app/install/python/requirements.txt
