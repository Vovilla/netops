#!/bin/bash

cd library
git clone https://github.com/networktocode/ntc-ansible
cd ..
docker build -t netops:latest --no-cache .