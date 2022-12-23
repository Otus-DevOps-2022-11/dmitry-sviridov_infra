#!/bin/bash

sudo apt-get install -y git
sudo systemctl start mongod
sudo systemctl enable mongod

git clone -b monolith https://github.com/express42/reddit.git && cd reddit && bundle install && puma -d
