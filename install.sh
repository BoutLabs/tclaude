#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
HOOKS_DIR="$HOME/.claude/hooks"
SETTINGS_FILE="$HOME/.claude/settings.json"

echo "=== tclaude installer ==="
echo ""

echo "Installing scripts to $BIN_DIR..."
mkdir -p "$BIN_DIR"
for tool in tclaude tgrok tcodex; do
    for role in "" -list -kill -all -log; do
        script="${tool}${role}"
        cp "$SCRIPT_DIR/bin/$script" "$BIN_DIR/$script"
        chmod +x "$BIN_DIR/$script"
    done
done
for setup in tclaude-setup tcodex-setup; do
    cp "$SCRIPT_DIR/bin/$setup" "$BIN_DIR/$setup"
    chmod +x "$BIN_DIR/$setup"
done
echo "  Installed: tclaude, tgrok, tcodex (each with -list, -kill, -all, -log), tclaude-setup, tcodex-setup"

echo "Installing notification hooks to $HOOKS_DIR..."
mkdir -p "$HOOKS_DIR"
cp "$SCRIPT_DIR/hooks/notify-telegram.sh" "$HOOKS_DIR/notify-telegram.sh"
chmod +x "$HOOKS_DIR/notify-telegram.sh"
cp "$SCRIPT_DIR/hooks/notify-telegram-codex.sh" "$HOOKS_DIR/notify-telegram-codex.sh"
chmod +x "$HOOKS_DIR/notify-telegram-codex.sh"
echo "  Installed: notify-telegram.sh, notify-telegram-codex.sh"

echo "Configuring Claude Code settings..."

HOOK_ENTRY='{
  "hooks": {
    "Notification": [
      {
        "type": "command",
        "command": "~/.claude/hooks/notify-telegram.sh"
      }
    ]
  }
}'

if [[ -f "$SETTINGS_FILE" ]]; then
    if command -v python3 &>/dev/null; then
        python3 -c "
import json, sys

with open('$SETTINGS_FILE', 'r') as f:
    settings = json.load(f)

hooks = settings.setdefault('hooks', {})
notification = hooks.setdefault('Notification', [])

hook_cmd = '~/.claude/hooks/notify-telegram.sh'
exists = any(h.get('command') == hook_cmd for h in notification)

if not exists:
    notification.append({'type': 'command', 'command': hook_cmd})
    with open('$SETTINGS_FILE', 'w') as f:
        json.dump(settings, f, indent=2)
        f.write('\n')
    print('  Added Notification hook to settings.json')
else:
    print('  Notification hook already configured')
"
    else
        echo "  Warning: python3 not found, skipping settings.json configuration"
        echo "  Manually add the Notification hook to $SETTINGS_FILE"
    fi
else
    mkdir -p "$(dirname "$SETTINGS_FILE")"
    echo "$HOOK_ENTRY" > "$SETTINGS_FILE"
    echo "  Created settings.json with Notification hook"
fi

# Install zsh completions
COMP_DIR="$HOME/.local/share/zsh/site-functions"
echo "Installing zsh completions to $COMP_DIR..."
mkdir -p "$COMP_DIR"
for comp in "$SCRIPT_DIR"/completions/_*; do
    cp "$comp" "$COMP_DIR/$(basename "$comp")"
done
echo "  Installed: _tclaude, _tclaude-kill, _tclaude-log"

# 5. Check PATH
echo ""
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo "WARNING: $BIN_DIR is not in your PATH"
    echo "Add this to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
    echo ""
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
else
    echo "$BIN_DIR is in your PATH"
fi

# 6. Done
echo ""
echo "Installation complete!"
echo ""
echo "Next step: Run 'tclaude-setup' to configure Telegram notifications."
