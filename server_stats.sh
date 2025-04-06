#!/bin/bash

# To check server stats

# Basic server info
HOSTNAME=$(hostname)
UPTIME=$(uptime -p)
LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | sed 's/ //g')
MEMORY=$(free -m | awk '/Mem:/ { printf "%sMB / %sMB (%.2f%%)", $3, $2, $3/$2 * 100.0 }')
DISK=$(df -h / | awk 'NR==2{print $3 " used / " $2 " (" $5 ")"}')

# Customize this webhook
WEBHOOK_URL="https://discord.com/api/webhooks/your_webhook_url"

# Construct the JSON payload
JSON=$(cat <<EOF
{
  "username": "Server Monitor",
  "embeds": [{
    "title": "📊 Server Stats for $HOSTNAME",
    "color": 5814783,
    "fields": [
      { "name": "⏱️ Uptime", "value": "$UPTIME", "inline": true },
      { "name": "🔥 Load Average", "value": "$LOAD", "inline": true },
      { "name": "💾 Memory Usage", "value": "$MEMORY", "inline": false },
      { "name": "🗄️ Disk Usage", "value": "$DISK", "inline": false }
    ],
    "timestamp": "$(date -Iseconds)"
  }]
}
EOF
)

# Send to Discord
curl -H "Content-Type: application/json" -X POST -d "$JSON" "$WEBHOOK_URL"
