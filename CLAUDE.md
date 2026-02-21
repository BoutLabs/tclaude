# tclaude - Project Instructions

## Workflow

- **Always create a new branch** for any new work. Branch names should follow the pattern `<type>/<short-description>` (e.g., `feat/tclaude-kill`, `fix/session-naming`, `docs/usage-examples`).
- **Submit changes via pull requests**. Never push directly to `master`. Keep PRs small and focused — one logical change per PR.
- **Do not combine unrelated changes** in a single PR. If a task involves multiple independent pieces, split them into separate PRs.
- **Track work with GitHub Issues**. Before starting work, check if there's an existing issue. Create one if there isn't. Reference the issue in PR descriptions (e.g., `Closes #5`).
- **Use conventional commits** for all commit messages (e.g., `feat:`, `fix:`, `docs:`, `ci:`, `chore:`).

## Project Structure

```
bin/           # CLI scripts installed to ~/.local/bin/
hooks/         # Claude Code hooks installed to ~/.claude/hooks/
install.sh     # One-step installer
```

## Code Standards

- All scripts are bash (`#!/usr/bin/env bash`) with `set -euo pipefail`.
- Scripts must be executable (`chmod +x`).
- Keep scripts simple and focused — one responsibility per script.
