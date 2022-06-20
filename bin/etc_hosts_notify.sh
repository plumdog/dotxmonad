#!/bin/bash

while true; do
    lies="$(grep '^[^#]' /etc/hosts | tr -s ' ' | sed 's/[0-9\.]* //')"
    if [[ ! -z "$lies" ]]; then
        notify-send "Do not trust (they are set in /etc/hosts):" "$lies";
        sleep 30
    else
        sleep 300
    fi
done
