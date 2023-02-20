#!/bin/bash
cd library
git clone https://github.com/networktocode/ntc-ansible --recursive
cp -r text_fsm_templates/templates/. ntc-ansible/ntc-templates/templates/
cat text_fsm_templates/index >> ntc-ansible/ntc-templates/templates/index
cd ..

docker build -t netops:1.0.7 --no-cache .
