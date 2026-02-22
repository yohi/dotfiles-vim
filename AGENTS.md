# PROJECT KNOWLEDGE BASE

**Repository:** dotfiles-vim
**Role:** Neovim / Vim configuration (LazyVim-based)

## STRUCTURE

```text
dotfiles-vim/
├── Makefile                    # Setup entry point
├── README.md                   # Component overview
└── LICENSE                     # MIT license
```

> This is currently a minimal component. Neovim config files (e.g., `init.lua`, `lua/`) will be added as Stow targets.

## COMPONENT LAYOUT CONVENTION

This repository is part of the **dotfiles polyrepo** orchestrated by `dotfiles-core`.
All changes MUST comply with the central layout rules. Please refer to [`dotfiles-core/docs/ARCHITECTURE.md`](../../docs/ARCHITECTURE.md) for the full, authoritative rules and constraints.

## THIS COMPONENT — SPECIAL NOTES

- Neovim config will be Stow-linked to `~/.config/nvim/` (via directory structure).
- LazyVim plugin specs should follow LazyVim conventions.

## CODE STYLE

- **Documentation / README**: Japanese (日本語)
- **AGENTS.md**: English
- **Commit Messages**: Japanese, Conventional Commits (e.g., `feat: 新機能追加`, `fix: バグ修正`)
- **Shell**: `set -euo pipefail`, dynamic path resolution, idempotent operations

## FORBIDDEN OPERATIONS

Per `opencode.jsonc` (when present), these operations are blocked for agent execution:

- `rm` (destructive file operations)
- `ssh` (remote access)
- `sudo` (privilege escalation)
