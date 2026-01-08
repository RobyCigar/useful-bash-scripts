#!/bin/bash

# Discord Webhook URL - GANTI DENGAN WEBHOOK ANDA
DISCORD_WEBHOOK="https://discord.com/api/webhooks/YOUR_WEBHOOK_URL"

# Threshold (dalam persen)
CPU_THRESHOLD=90
RAM_THRESHOLD=90

# Fungsi kirim notifikasi ke Discord
send_discord_alert() {
    local title="$1"
    local message="$2"
    local color="$3"
    
    curl -H "Content-Type: application/json" -X POST -d "{
        \"embeds\": [{
            \"title\": \"⚠️ $title\",
            \"description\": \"$message\",
            \"color\": $color,
            \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",
            \"footer\": {
                \"text\": \"Server: $(hostname)\"
            }
        }]
    }" "$DISCORD_WEBHOOK" 2>/dev/null
}

# Cek CPU Usage
check_cpu() {
    CURRENT_TIME=$(date +%s)
    
    # Skip jika masih dalam cooldown
    if [ $((CURRENT_TIME - LAST_CPU_ALERT)) -lt "$ALERT_COOLDOWN" ]; then
        return
    fi
    
    # Ambil CPU usage (rata-rata 1 menit terakhir)
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    CPU_USAGE_INT=${CPU_USAGE%.*}
    
    if [ "$CPU_USAGE_INT" -gt "$CPU_THRESHOLD" ]; then
        MESSAGE="CPU Usage: **${CPU_USAGE}%**\nThreshold: ${CPU_THRESHOLD}%\n\nTop 5 Processes:\n\`\`\`"
        MESSAGE="${MESSAGE}$(ps aux --sort=-%cpu | head -6 | tail -5 | awk '{printf "%-10s %5s%% %s\n", $1, $3, $11}')"
        MESSAGE="${MESSAGE}\`\`\`"
        
        send_discord_alert "High CPU Usage Alert" "$MESSAGE" 15158332
        echo "[$(date)] Alert sent: CPU usage ${CPU_USAGE}%"
        LAST_CPU_ALERT=$CURRENT_TIME
    fi
}

# Cek RAM Usage
check_ram() {
    CURRENT_TIME=$(date +%s)
    
    # Skip jika masih dalam cooldown
    if [ $((CURRENT_TIME - LAST_RAM_ALERT)) -lt "$ALERT_COOLDOWN" ]; then
        return
    fi
    
    # Ambil RAM usage
    RAM_USAGE=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}')
    
    if [ "$RAM_USAGE" -gt "$RAM_THRESHOLD" ]; then
        RAM_INFO=$(free -h | grep Mem | awk '{print "Used: "$3" / Total: "$2}')
        MESSAGE="RAM Usage: **${RAM_USAGE}%**\nThreshold: ${RAM_THRESHOLD}%\n${RAM_INFO}\n\nTop 5 Memory Processes:\n\`\`\`"
        MESSAGE="${MESSAGE}$(ps aux --sort=-%mem | head -6 | tail -5 | awk '{printf "%-10s %5s%% %s\n", $1, $4, $11}')"
        MESSAGE="${MESSAGE}\`\`\`"
        
        send_discord_alert "High RAM Usage Alert" "$MESSAGE" 16744272
        echo "[$(date)] Alert sent: RAM usage ${RAM_USAGE}%"
        LAST_RAM_ALERT=$CURRENT_TIME
    fi
}

# Cooldown untuk prevent spam alert (dalam detik)
ALERT_COOLDOWN=300  # 5 menit
LAST_CPU_ALERT=0
LAST_RAM_ALERT=0

# Main loop
echo "Starting resource monitoring..."
echo "CPU Threshold: ${CPU_THRESHOLD}%"
echo "RAM Threshold: ${RAM_THRESHOLD}%"
echo "Alert Cooldown: ${ALERT_COOLDOWN}s"
echo "Checking every 60 seconds. Press Ctrl+C to stop."

while true; do
    check_cpu
    check_ram
    sleep 60
done
