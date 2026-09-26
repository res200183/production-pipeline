#!/bin/bash

cd /var/www/production-pipeline
nohup python3 app.py > /var/log/production-pipeline.log 2>&1 &
