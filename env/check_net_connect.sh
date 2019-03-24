#!/bin/bash

for i in 10.0.1.1 10.0.1.2 10.0.1.10 10.0.1.11 10.0.1.12 10.0.1.20 10.0.1.21; do
    ping -w3 -c1 $i 2>&1 > /dev/null
    if [ $? -ne 0 ]; then
        echo "$i is down"
    fi
done
