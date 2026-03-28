# Agent Instructions for dotfiles-vim

> [!IMPORTANT]
> 共通の基本ルールは [DOTFILES_COMMON_RULES.md](./DOTFILES_COMMON_RULES.md) を参照してください。

# PROJECT KNOWLEDGE BASE

**Repository:** dotfiles-vim
**Role:** Neovim / Vim configuration (LazyVim-based)



## COMPONENT LAYOUT CONVENTION

This repository is part of the **dotfiles polyrepo** orchestrated by [dotfiles-core](https://github.com/yohi/dotfiles-core).
All changes MUST comply with the central layout rules. Please refer to the central [ARCHITECTURE.md](https://raw.githubusercontent.com/yohi/dotfiles-core/refs/heads/master/docs/ARCHITECTURE.md) for the full, authoritative rules and constraints.

## STRUCTURE

```text
dotfiles-vim/
├── nvim/                       # [Link Target] Neovim configuration → ~/.config/nvim
│   ├── init.lua                # Entry point
│   ├── lua/                    # Lua configuration modules
│   └── ...
├── Makefile                    # Setup entry point
├── README.md                   # Component overview
└── LICENSE                     # MIT license
```

## THIS COMPONENT — SPECIAL NOTES

- `nvim/` is linked to `~/.config/nvim` via `ln -sfn` in the Makefile (`make link`).
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
