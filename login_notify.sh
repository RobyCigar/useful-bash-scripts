#!/bin/bash

# to check someone who logged in
USER=$(whoami)
IP=$(who am i | awk '{print $5}' | tr -d '()')
HOSTNAME=$(hostname)
LOGIN_TIME=$(date "+%Y-%m-%d %H:%M:%S")

WEBHOOK_URL="https://discord.com/api/webhooks/your_webhook_url"

JSON=$(cat <<EOF
{
  "username": "Login Monitor",
  "embeds": [{
    "title": "🔐 New Login Detected",
    "color": 16753920,
    "fields": [
      { "name": "👤 User", "value": "$USER", "inline": true },
      { "name": "🕒 Time", "value": "$LOGIN_TIME", "inline": true },
      { "name": "🌐 IP Address", "value": "$IP", "inline": true },
      { "name": "💻 Hostname", "value": "$HOSTNAME", "inline": true }
    ],
    "timestamp": "$(date -Iseconds)"
  }]
}
EOF
)

curl -H "Content-Type: application/json" -X POST -d "$JSON" "$WEBHOOK_URL" >/dev/null 2>&1 &
