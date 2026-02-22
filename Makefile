REPO_ROOT ?= $(CURDIR)
.DEFAULT_GOAL := setup
include _mk/vim.mk

.PHONY: setup
setup: setup-vim
	@echo "==> Setting up dotfiles-vim"
