#!/usr/bin/env bash
# install.sh - Install tclaude scripts and notification hook
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
HOOKS_DIR="$HOME/.claude/hooks"
SETTINGS_FILE="$HOME/.claude/settings.json"

echo "=== tclaude installer ==="
echo ""

# 1. Install bin scripts
echo "Installing scripts to $BIN_DIR..."
mkdir -p "$BIN_DIR"
for script in tclaude tclaude-list tclaude-setup tclaude-kill tclaude-all; do
    cp "$SCRIPT_DIR/bin/$script" "$BIN_DIR/$script"
    chmod +x "$BIN_DIR/$script"
done
echo "  Installed: tclaude, tclaude-list, tclaude-setup, tclaude-kill, tclaude-all"

# 2. Install notification hook
echo "Installing notification hook to $HOOKS_DIR..."
mkdir -p "$HOOKS_DIR"
cp "$SCRIPT_DIR/hooks/notify-telegram.sh" "$HOOKS_DIR/notify-telegram.sh"
chmod +x "$HOOKS_DIR/notify-telegram.sh"
echo "  Installed: notify-telegram.sh"

# 3. Configure Claude Code settings
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
    # Merge hook into existing settings, preserving existing hooks
    if command -v python3 &>/dev/null; then
        python3 -c "
import json, sys

with open('$SETTINGS_FILE', 'r') as f:
    settings = json.load(f)

hooks = settings.setdefault('hooks', {})
notification = hooks.setdefault('Notification', [])

# Check if hook already exists
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

# 4. Check PATH
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

# 5. Done
echo ""
echo "Installation complete!"
echo ""
echo "Next step: Run 'tclaude-setup' to configure Telegram notifications."
