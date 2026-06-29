include _mk/core.mk
include _mk/help.mk
-include _mk/vim.mk

.PHONY: install setup install-vim setup-vim

install: install-vim ## Vim 関連のインストール
setup: setup-vim ## Vim の設定適用

install-vim:
	@echo "==> Installing dotfiles-vim"

# setup-vim in this Makefile intentionally overrides the placeholder in _mk/vim.mk
setup-vim::
	@echo "==> Setting up dotfiles-vim"
	mkdir -p $(HOME)/.config
	ln -sfn $(CURDIR)/nvim $(HOME)/.config/nvim
