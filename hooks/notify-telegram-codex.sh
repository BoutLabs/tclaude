#!/usr/bin/env bash
# notify-telegram-codex.sh - Send Telegram notification when a Codex CLI turn completes
# Configured via the `notify` key in ~/.codex/config.toml (installed by tcodex-setup)
#
# Unlike Claude Code hooks (JSON on stdin), Codex invokes its notify program with
# the payload as a single JSON argument. See:
# https://developers.openai.com/codex/config-reference

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

PAYLOAD="${1:-}"

TYPE=$(echo "$PAYLOAD" | python3 -c "import sys,json; print(json.load(sys.stdin).get('type',''))" 2>/dev/null || echo "")

# Codex currently only emits agent-turn-complete; ignore anything else so a future
# notification type doesn't page with an empty message.
if [[ "$TYPE" != "agent-turn-complete" ]]; then
    exit 0
fi

MESSAGE=$(echo "$PAYLOAD" | python3 -c "
import sys, json
d = json.load(sys.stdin)
msg = d.get('last-assistant-message') or 'Codex needs attention'
print(msg[:300] + ('…' if len(msg) > 300 else ''))
" 2>/dev/null || echo "Codex needs attention")

# Codex's cwd at notify time is the project directory tcodex launched it from. Mirror
# bin/tclaude's session-name derivation (git remote org/repo, dot-to-dash, "-codex"
# suffix) so this matches the actual tmux session name — keep these two in sync.
if git rev-parse --is-inside-work-tree &>/dev/null; then
    remote_url=$(git remote get-url origin 2>/dev/null || true)
    if [[ -n "$remote_url" ]]; then
        org_repo=$(echo "$remote_url" | sed -E 's#\.git$##; s#.*[:/]([^/]+/[^/]+)$#\1#')
        SESSION_NAME="${org_repo//\//-}"
    else
        SESSION_NAME="$(basename "$PWD")"
    fi
else
    SESSION_NAME="$(basename "$PWD")"
fi
SESSION_NAME="${SESSION_NAME//./-}-codex"

# Sent as plain text (no parse_mode): MESSAGE is raw, arbitrary agent output that may
# contain unbalanced Markdown metacharacters, which Telegram's Markdown parser rejects
# outright — since this call is backgrounded and fire-and-forget, a rejected request
# would otherwise fail silently with no notification at all.
TEXT="🤖 Codex
📁 ${SESSION_NAME}
💬 ${MESSAGE}"

# Send via Telegram Bot API (fire and forget)
curl -s -X POST \
    "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -d chat_id="$TELEGRAM_CHAT_ID" \
    -d text="$TEXT" \
    -d disable_notification=false \
    >/dev/null 2>&1 &

exit 0
