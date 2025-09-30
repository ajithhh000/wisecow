 #!/usr/bin/env bash
 # system_health.sh
 # checks cpu, memory, disk and running processes
 LOGFILE=${1:-""}
 THRESH_CPU=80
 THRESH_MEM=80
 THRESH_DISK=80
 log() {
 local msg="$1"
 if [-n "$LOGFILE" ]; then
 echo "$(date--iso-8601=seconds) $msg" >> "$LOGFILE"
 else
 echo "$(date--iso-8601=seconds) $msg"
 fi
 }
 # CPU usage (approx)
 CPU_IDLE=$(top-bn2 | grep "Cpu(s)" | tail-n1 | awk-F'id,' '{print $2}' | awk
 '{print $1}')
 CPU_USAGE=$(awk "BEGIN {print int(100 - $CPU_IDLE)}")
 # Memory usage percent
 MEM_USAGE=$(free | awk '/Mem/ {printf("%d", $3/$2 * 100)}')
 # Disk usage percent on root
 DISK_USAGE=$(df / | tail-1 | awk '{print int($5)}')
 log "CPU: ${CPU_USAGE}% | MEM: ${MEM_USAGE}% | DISK: ${DISK_USAGE}%"
 [ "$CPU_USAGE"-ge "$THRESH_CPU" ] && log "ALERT: CPU usage (${CPU_USAGE}%) >= 
threshold (${THRESH_CPU}%)"
 [ "$MEM_USAGE"-ge "$THRESH_MEM" ] && log "ALERT: Memory usage (${MEM_USAGE}%) 
>= threshold (${THRESH_MEM}%)"
 [ "$DISK_USAGE"-ge "$THRESH_DISK" ] && log "ALERT: Disk usage (${DISK_USAGE}%) 
>= threshold (${THRESH_DISK}%)"
 # optional check for a critical process
 CRITICAL_PROC="sshd"
 if ! pgrep-x "$CRITICAL_PROC" >/dev/null 2>&1; then
 log "ALERT: critical process $CRITICAL_PROC not running"
 fi
