# Makefile include unification Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** `Makefile` における `_mk/vim.mk` の参照を変数化し、保守性を向上させるとともに、ドキュメントの構造を修正します。

**Architecture:** 
1. `Makefile` に `VIM_MK` 変数を導入し、重複するパス定義を一元化します。
2. 再現・検証スクリプトをモード引数（`before`/`after`）対応に改善し、操作ミスを防ぎます。
3. 計画書のヘッダーレベルを H1 → H2 の順序に修正します。

**Tech Stack:** GNU Make, Bash, Markdown

---

## Task 1: 計画書のヘッダーレベル修正

**Files:**
- Modify: `docs/plans/2026-03-28-makefile-include-unification.md`

**Step 1: Fix headings**

Change `### Task N` to `## Task N` to follow H1 → H2 hierarchy.

**Step 2: Commit**

```bash
git add docs/plans/2026-03-28-makefile-include-unification.md
git commit -m "docs: fix markdown heading levels in implementation plan"
```

## Task 2: 再現・検証スクリプトの作成（モード引数対応）

**Files:**
- Create: `tests/repro_makefile_issue.sh`

**Step 1: Write the improved reproduction script**

```bash
#!/bin/bash
set -e

MODE=$1
if [ -z "$MODE" ]; then
    echo "Usage: $0 [before|after]"
    exit 1
fi

TEST_DIR="tmp_test_make"
mkdir -p "$TEST_DIR/_mk"
cp Makefile "$TEST_DIR/"

echo "Testing Makefile without _mk/vim.mk in mode: $MODE"
cd "$TEST_DIR"

if [ "$MODE" == "before" ]; then
    # before モード: 修正前（include 直書き）の場合は失敗することを期待する
    # ※現状の Makefile は既に修正されている可能性があるため、このテストは
    #   一時的にコードを戻して検証するか、現状のパス確認として利用する。
    if make -n > /dev/null 2>&1; then
        echo "PASS: Makefile works (already unified or using wildcard)"
    else
        echo "FAIL: Makefile fails as expected (needs unification)"
    fi
elif [ "$MODE" == "after" ]; then
    # after モード: 修正後（wildcard + 変数）の場合は必ず成功することを期待する
    if make -n > /dev/null 2>&1; then
        echo "SUCCESS: Makefile passes without _mk/vim.mk"
    else
        echo "FAILURE: Makefile fails even after fix"
        exit 1
    fi
fi

cd ..
rm -rf "$TEST_DIR"
```

**Step 2: Run test in 'before' mode to check current state**

Run: `bash tests/repro_makefile_issue.sh before`
Expected: `PASS` (If already using wildcard) or `FAIL` (If not). 

**Step 3: Commit the test script**

```bash
git add tests/repro_makefile_issue.sh
git commit -m "test: add improved reproduction script with mode argument"
```

## Task 3: Makefile の変数リファクタリング

**Files:**
- Modify: `Makefile`

**Step 1: Define VIM_MK and replace hardcoded paths**

```makefile
<<<<
ifneq ($(wildcard _mk/vim.mk),)
include _mk/vim.mk
endif
...
	@if [ -f _mk/vim.mk ]; then $(MAKE) setup-vim; fi
====
VIM_MK := _mk/vim.mk

ifneq ($(wildcard $(VIM_MK)),)
include $(VIM_MK)
endif
...
	@if [ -f $(VIM_MK) ]; then $(MAKE) setup-vim; fi
>>>>
```

**Step 2: Run the reproduction script in 'after' mode**

Run: `bash tests/repro_makefile_issue.sh after`
Expected: `SUCCESS: Makefile passes without _mk/vim.mk`

**Step 3: Verify with vim.mk present**

Run:
```bash
mkdir -p tmp_test_make/_mk
echo 'setup-vim:; @echo "vim.mk setup executed"' > tmp_test_make/_mk/vim.mk
cd tmp_test_make && make setup
```
Expected: `==> Setting up dotfiles-vim` 続く `vim.mk setup executed`

**Step 4: Commit**

```bash
git add Makefile
git commit -m "refactor: use VIM_MK variable in Makefile"
```

## Task 4: クリーンアップ

**Files:**
- Remove: `tests/repro_makefile_issue.sh`

**Step 1: Remove reproduction script**

Run: `rm tests/repro_makefile_issue.sh`

**Step 2: Commit**

```bash
git commit -m "cleanup: remove reproduction script"
```
