include _mk/core.mk
include _mk/help.mk

REPO_ROOT ?= $(CURDIR)
.DEFAULT_GOAL := setup
include _mk/vim.mk

.PHONY: link
link:
	@echo "==> Linking dotfiles-vim"
	mkdir -p $(HOME)/.config
	ln -sfn $(REPO_ROOT)/nvim $(HOME)/.config/nvim

.PHONY: setup
setup:
	@echo "==> Setting up dotfiles-vim"
	$(MAKE) setup-vim
