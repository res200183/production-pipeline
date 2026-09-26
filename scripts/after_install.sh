#!/bin/bash

cd /var/www/production-pipeline
dnf install -y python3-pip
python3 -m pip install -r requirements.txt
