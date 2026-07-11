#!/usr/bin/env bash
# notify-telegram.sh - Send Telegram notification when Claude needs attention
# Called by Claude Code's Notification hook
#
# Setup:
#   1. Create a bot with @BotFather on Telegram, get the bot token
#   2. Message your bot, then get your chat_id from:
#      curl https://api.telegram.org/bot<TOKEN>/getUpdates
#   3. Create ~/.config/tclaude/telegram.env with:
#      TELEGRAM_BOT_TOKEN=your_bot_token
#      TELEGRAM_CHAT_ID=your_chat_id

set -euo pipefail

CONFIG_FILE="$HOME/.config/tclaude/telegram.env"

if [[ ! -f "$CONFIG_FILE" ]]; then
    exit 0  # Silently skip if not configured
fi

# shellcheck disable=SC1090
source "$CONFIG_FILE"

if [[ -z "${TELEGRAM_BOT_TOKEN:-}" || -z "${TELEGRAM_CHAT_ID:-}" ]]; then
    exit 0
fi

# Read hook input from stdin
INPUT=$(cat)

MESSAGE=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('message','Claude needs attention'))" 2>/dev/null || echo "Claude needs attention")
TITLE=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('title','Claude Code'))" 2>/dev/null || echo "Claude Code")
CWD=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('cwd',''))" 2>/dev/null || echo "")
SESSION_NAME=$(basename "${CWD:-unknown}")

TEXT="🤖 *${TITLE}*
📁 \`${SESSION_NAME}\`
💬 ${MESSAGE}"

# Send via Telegram Bot API (fire and forget)
curl -s -X POST \
    "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -d chat_id="$TELEGRAM_CHAT_ID" \
    -d text="$TEXT" \
    -d parse_mode="Markdown" \
    -d disable_notification=false \
    >/dev/null 2>&1 &

exit 0
