
#!/bin/bash

cd /var/www/production-pipeline

sleep 120

nohup python3 app.py > /var/log/production-pipeline.log 2>&1 &
