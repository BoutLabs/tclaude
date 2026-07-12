# tclaude

Run [Claude Code](https://docs.anthropic.com/en/docs/claude-code), [Grok](https://x.ai), or [Codex](https://github.com/openai/codex) sessions in tmux, with Telegram notifications for Claude Code and Codex.

Each project gets its own named tmux session per tool, so `tclaude`, `tgrok`, and `tcodex` can all run side by side in the same directory. When the agent needs your attention, you get a Telegram message.

## Install

```bash
git clone https://github.com/BoutLabs/tclaude.git
cd tclaude
./install.sh
```

The installer will:
- Copy `tclaude`, `tgrok`, `tcodex` (each with `-list`, `-kill`, `-all`, `-log` variants), `tclaude-setup`, and `tcodex-setup` to `~/.local/bin/`
- Install the Telegram notification hooks to `~/.claude/hooks/`
- Add the Claude Code hook to your `~/.claude/settings.json`

## Setup Telegram Notifications

Both `tclaude` and `tcodex` can send Telegram notifications, but through different mechanisms since each tool exposes a different hook:

- **Claude Code** fires a [`Notification` hook](https://docs.anthropic.com/en/docs/claude-code/hooks) (JSON on stdin) whenever it needs input. `tclaude-setup` wires this up in `~/.claude/settings.json`.
- **Codex** invokes a global [`notify` command](https://developers.openai.com/codex/config-reference) (JSON as a single argument) when a turn completes. `tcodex-setup` wires this up in `~/.codex/config.toml`.
- **Grok** doesn't currently expose an equivalent hook for "agent needs attention" — only project-scoped, trust-gated hooks for tool/session lifecycle events — so `tgrok` has no notification support yet.

```bash
tclaude-setup   # Claude Code notifications
tcodex-setup    # Codex notifications
```

Each walks you through creating a Telegram bot and configuring notifications (they share the same bot/chat config, so you only need to do this once). You'll need to:

1. Create a bot with [@BotFather](https://t.me/BotFather) on Telegram
2. Enter your bot token
3. Send a message to your bot so it can detect your chat ID

Configuration is stored in `~/.config/tclaude/telegram.env`.

## Usage

### Start a session

```bash
cd ~/Projects/my-app
tclaude   # launches Claude Code
tgrok     # launches Grok
tcodex    # launches Codex
```

This creates a tmux session named after your project (from the git remote's `org-repo`, or the directory name) and launches the tool inside it. If the session already exists, it attaches to it. `tgrok` and `tcodex` suffix the session name with the tool (e.g. `BoutLabs-my-app-grok`) so you can run all three side by side in the same project — this applies even if you pass in a custom name, since otherwise `tgrok my-custom-name` and `tcodex my-custom-name` would both target the same session and attach to whichever one started first instead of starting their own.

You can also specify a custom session name:

```bash
tclaude my-custom-name
```

### List, kill, and broadcast to sessions

```bash
tclaude-list          # list tmux sessions and pick one to attach to
tclaude-kill <name>   # kill a session by name (or run with no args to pick interactively, or --all)
tclaude-all <command> # send a command to every running tmux session
```

`tgrok-list`/`tgrok-kill`/`tgrok-all` and `tcodex-list`/`tcodex-kill`/`tcodex-all` work the same way — `-list`, `-kill`, and `-all` operate on every tmux session regardless of which tool created it.

### View session logs

```bash
tclaude-log               # list available logs grouped by session
tclaude-log <session-name> # tail the latest log for a session
```

Same for `tgrok-log`/`tcodex-log`. Each tool keeps its own log directory (`~/.local/share/tclaude/logs`, `~/.local/share/tgrok/logs`, `~/.local/share/tcodex/logs`), keeping the last 10 logs per session.

### Detach from a session

Press `Ctrl+b` then `d` to detach from a tmux session. The tool keeps running in the background — for `tclaude` and `tcodex`, you'll get a Telegram notification when it needs your input.

## How It Works

- **tclaude** / **tgrok** / **tcodex** create a tmux session named after your current directory (or git remote) and run `claude` / `grok` / `codex` inside it
- **notify-telegram.sh** is a Claude Code [notification hook](https://docs.anthropic.com/en/docs/claude-code/hooks) that sends a Telegram message whenever Claude needs attention (JSON on stdin)
- **notify-telegram-codex.sh** is Codex's global [`notify` command](https://developers.openai.com/codex/config-reference) that does the same for Codex turns (JSON as an argument)
- This means you can detach from a session, work on something else, and get notified when the agent is done or needs input

## Requirements

- [tmux](https://github.com/tmux/tmux)
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code), [Grok](https://x.ai), and/or [Codex](https://github.com/openai/codex) — whichever tools you use
- python3 (for JSON parsing in hooks)
- curl (for Telegram API)

## License

MIT
