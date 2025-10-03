#!/usr/bin/env bash

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
MEM=$(free | awk '/Mem/ {print ($3/$2)*100.0}')
DISK=$(df --output=pcent / | tail -1 | tr -dc '0-9')

if (( $(echo "$CPU > 80" | bc -l) )); then
    echo "[ALERT] CPU usage high: $CPU%" | tee -a /var/log/system_health.log
fi
if (( $(echo "$MEM > 80" | bc -l) )); then
    echo "[ALERT] Memory usage high: $MEM%" | tee -a /var/log/system_health.log
fi
if (( DISK > 80 )); then
    echo "[ALERT] Disk usage high: $DISK%" | tee -a /var/log/system_health.log
fi

echo "Top 5 processes:"
ps aux --sort=-%cpu | head -n 6 | tee -a /var/log/system_health.log
