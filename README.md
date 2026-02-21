# tclaude

Run [Claude Code](https://docs.anthropic.com/en/docs/claude-code) sessions in tmux with Telegram notifications.

Each project gets its own named tmux session. When Claude needs your attention, you get a Telegram message.

## Install

```bash
git clone https://github.com/BoutLabs/tclaude.git
cd tclaude
./install.sh
```

The installer will:
- Copy `tclaude`, `tclaude-list`, and `tclaude-setup` to `~/.local/bin/`
- Install the Telegram notification hook to `~/.claude/hooks/`
- Add the hook to your `~/.claude/settings.json`

## Setup Telegram Notifications

```bash
tclaude-setup
```

This walks you through creating a Telegram bot and configuring notifications. You'll need to:

1. Create a bot with [@BotFather](https://t.me/BotFather) on Telegram
2. Enter your bot token
3. Send a message to your bot so it can detect your chat ID

Configuration is stored in `~/.config/tclaude/telegram.env`.

## Usage

### Start a session

```bash
cd ~/Projects/my-app
tclaude
```

This creates a tmux session named `my-app` and launches Claude Code inside it. If the session already exists, it attaches to it.

You can also specify a custom session name:

```bash
tclaude my-custom-name
```

### List sessions

```bash
tclaude-list
```

Shows all tmux sessions with status and creation time, and lets you pick one to attach to.

### Detach from a session

Press `Ctrl+b` then `d` to detach from a tmux session. Claude Code keeps running in the background, and you'll get a Telegram notification when it needs your input.

## How It Works

- **tclaude** creates a tmux session named after your current directory and runs `claude` inside it
- **notify-telegram.sh** is a Claude Code [notification hook](https://docs.anthropic.com/en/docs/claude-code/hooks) that sends a Telegram message whenever Claude needs attention
- This means you can detach from a session, work on something else, and get notified when Claude is done or needs input

## Requirements

- [tmux](https://github.com/tmux/tmux)
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- python3 (for JSON parsing in hooks)
- curl (for Telegram API)

## License

MIT
