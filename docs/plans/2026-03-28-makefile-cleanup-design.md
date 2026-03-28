# Makefile Cleanup Design

## Goal
`Makefile` の `setup` ターゲットにおいて、ファイル存在チェックの実装を一貫性のある Makefile レベルの条件分岐（`ifneq` + `wildcard`）に統一し、可読性と保守性を向上させる。

## Design
現在の `setup` ターゲットで使用されているシェルスクリプトによるファイル存在チェック `[ -f $(VIM_MK) ]` を、Makefile のプリプロセッサ命令 `ifneq ($(wildcard $(VIM_MK)),)` に置き換える。

### Before
```makefile
.PHONY: setup
setup: ## セットアップ（依存関係、設定適用）を一括実行します
	@echo "==> Setting up dotfiles-vim"
	@if [ -f $(VIM_MK) ]; then $(MAKE) setup-vim; fi
```

### After
```makefile
.PHONY: setup
setup: ## セットアップ（依存関係、設定適用）を一括実行します
	@echo "==> Setting up dotfiles-vim"
ifneq ($(wildcard $(VIM_MK)),)
	$(MAKE) setup-vim
endif
```

## Testing Strategy
- **Case 1: `_mk/vim.mk` が存在する場合**
    - `make setup` を実行。
    - `==> Setting up dotfiles-vim` と `-> vim setup (placeholder)`（`setup-vim` の内容）が出力されることを確認。
- **Case 2: `_mk/vim.mk` が存在しない場合**
    - `_mk/vim.mk` を一時的にリネーム。
    - `make setup` を実行。
    - `==> Setting up dotfiles-vim` のみが出力され、エラーが発生しないことを確認。
