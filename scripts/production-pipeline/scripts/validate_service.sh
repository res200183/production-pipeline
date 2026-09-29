#!/bin/bash

echo "Waiting 60 seconds before validation..."
sleep 60

curl -f http://localhost:5000/health
