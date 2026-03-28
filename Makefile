# Orchestrator core configuration
# Note: These are symlinked from ../../common-mk/ when managed by dotfiles-core
VIM_MK := _mk/vim.mk
ifneq ($(wildcard _mk/core.mk),)
include _mk/core.mk
endif
ifneq ($(wildcard _mk/help.mk),)
include _mk/help.mk
endif

.DEFAULT_GOAL := setup

# Component-specific logic

REPO_ROOT ?= $(CURDIR)
ifneq ($(wildcard $(VIM_MK)),)
include $(VIM_MK)
endif

.PHONY: link
link: ## シンボリックリンクを展開し、dotfiles を配置します
	@echo "==> Linking dotfiles-vim"
	mkdir -p $(HOME)/.config
	ln -sfn $(REPO_ROOT)/nvim $(HOME)/.config/nvim

.PHONY: setup
setup: ## セットアップ（依存関係、設定適用）を一括実行します
	@echo "==> Setting up dotfiles-vim"
	@if [ -f $(VIM_MK) ]; then $(MAKE) setup-vim; fi
