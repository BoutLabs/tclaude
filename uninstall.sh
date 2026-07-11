#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$HOME/.local/bin"
HOOKS_DIR="$HOME/.claude/hooks"
SETTINGS_FILE="$HOME/.claude/settings.json"
CONFIG_DIR="$HOME/.config/tclaude"

echo "=== tclaude uninstaller ==="
echo ""

echo "Removing scripts from $BIN_DIR..."
for tool in tclaude tgrok tcodex; do
    for role in "" -list -kill -all -log; do
        script="${tool}${role}"
        if [[ -f "$BIN_DIR/$script" ]]; then
            rm "$BIN_DIR/$script"
            echo "  Removed: $script"
        fi
    done
done
for setup in tclaude-setup tcodex-setup; do
    if [[ -f "$BIN_DIR/$setup" ]]; then
        rm "$BIN_DIR/$setup"
        echo "  Removed: $setup"
    fi
done

echo "Removing notification hooks from $HOOKS_DIR..."
for hook in notify-telegram.sh notify-telegram-codex.sh; do
    if [[ -f "$HOOKS_DIR/$hook" ]]; then
        rm "$HOOKS_DIR/$hook"
        echo "  Removed: $hook"
    else
        echo "  $hook not found, skipping."
    fi
done

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

CODEX_CONFIG="$HOME/.codex/config.toml"
if [[ -f "$CODEX_CONFIG" ]] && command -v python3 &>/dev/null; then
    echo "Removing notify hook from $CODEX_CONFIG..."
    python3 -c "
import os, re

path = '$CODEX_CONFIG'
hook_path = os.path.expanduser('~/.claude/hooks/notify-telegram-codex.sh')

with open(path) as f:
    text = f.read()

new_text = re.sub(r'(?m)^notify\s*=\s*\[\"' + re.escape(hook_path) + r'\"\]\n\n?', '', text)

if new_text != text:
    with open(path, 'w') as f:
        f.write(new_text)
    print('  Removed notify hook from config.toml')
else:
    print('  notify hook not found in config.toml, skipping')
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
