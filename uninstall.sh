set -euo pipefail

BIN_DIR="$HOME/.local/bin"
HOOKS_DIR="$HOME/.claude/hooks"
SETTINGS_FILE="$HOME/.claude/settings.json"
CONFIG_DIR="$HOME/.config/tclaude"

echo "=== tclaude uninstaller ==="
echo ""

echo "Removing scripts from $BIN_DIR..."
for script in tclaude tclaude-list tclaude-setup tclaude-kill tclaude-all tclaude-log; do
    if [[ -f "$BIN_DIR/$script" ]]; then
        rm "$BIN_DIR/$script"
        echo "  Removed: $script"
    fi
done

echo "Removing notification hook from $HOOKS_DIR..."
if [[ -f "$HOOKS_DIR/notify-telegram.sh" ]]; then
    rm "$HOOKS_DIR/notify-telegram.sh"
    echo "  Removed: notify-telegram.sh"
else
    echo "  Not found, skipping."
fi

if [[ -f "$SETTINGS_FILE" ]] && command -v python3 &>/dev/null; then
    echo "Removing Notification hook from settings.json..."
    python3 -c "
import json

with open('$SETTINGS_FILE', 'r') as f:
    settings = json.load(f)

hooks = settings.get('hooks', {})
notification = hooks.get('Notification', [])

hook_cmd = '~/.claude/hooks/notify-telegram.sh'
notification = [h for h in notification if h.get('command') != hook_cmd]

if notification:
    hooks['Notification'] = notification
else:
    hooks.pop('Notification', None)

if not hooks:
    settings.pop('hooks', None)

with open('$SETTINGS_FILE', 'w') as f:
    json.dump(settings, f, indent=2)
    f.write('\n')

print('  Removed Notification hook from settings.json')
"
fi

# Remove zsh completions
COMP_DIR="$HOME/.local/share/zsh/site-functions"
echo "Removing zsh completions from $COMP_DIR..."
for comp in _tclaude _tclaude-kill _tclaude-log; do
    if [[ -f "$COMP_DIR/$comp" ]]; then
        rm "$COMP_DIR/$comp"
        echo "  Removed: $comp"
    fi
done

if [[ -d "$CONFIG_DIR" ]]; then
    echo ""
    read -rp "Remove Telegram config at $CONFIG_DIR? [y/N] " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm -rf "$CONFIG_DIR"
        echo "  Removed: $CONFIG_DIR"
    else
        echo "  Kept: $CONFIG_DIR"
    fi
fi

echo ""
echo "Uninstall complete!"
