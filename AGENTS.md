# Agent Instructions for dotfiles-vim

## COMPONENT LAYOUT CONVENTION

This repository is part of the **dotfiles polyrepo** managed by [dotfiles-core](https://github.com/yohi/dotfiles).

### ⚠️ CRITICAL: SYMBOLIC LINK & STANDALONE USAGE
- **Standalone usage is NOT supported.** This repository depends on the central `common-mk` rules.
- **Symbolic Links:** This repository relies on symbolic links to `common-mk`. **NEVER** suggest or perform a replacement of these symbolic links with physical files/directories. 
- **SSOT:** Always respect the "Single Source of Truth" principle. Shared logic resides in `dotfiles-core`, and components must remain thin wrappers or specific configurations.
- **Architectural Compliance:** All modifications must adhere to the layout defined in the central [ARCHITECTURE.md](https://github.com/yohi/dotfiles/blob/master/docs/ARCHITECTURE.md).

> [!IMPORTANT]
> 共通の基本ルールは [DOTFILES_COMMON_RULES.md](./DOTFILES_COMMON_RULES.md) を参照してください。

# PROJECT KNOWLEDGE BASE

**Repository:** dotfiles-vim
**Role:** Neovim / Vim configuration (LazyVim-based)

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
