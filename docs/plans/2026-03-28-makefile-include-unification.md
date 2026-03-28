# Makefile include unification Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** `Makefile` における `include _mk/vim.mk` を条件付きインクルードに変更し、他のインクルード形式と統一します。

**Architecture:** `wildcard` 関数を使用してファイルの存在を確認し、存在する場合のみインクルードする形式を採用します。

**Tech Stack:** GNU Make

---

### Task 1: 現状の動作確認（テスト）

**Files:**
- Create: `tests/repro_makefile_issue.sh`

**Step 1: Write the reproduction script**

```bash
#!/bin/bash
set -e

# テスト用のディレクトリを作成
TEST_DIR="tmp_test_make"
mkdir -p "$TEST_DIR/_mk"
cp Makefile "$TEST_DIR/"
# vim.mk をあえて作成しない

echo "Testing Makefile without _mk/vim.mk..."
cd "$TEST_DIR"
# 現在の Makefile では vim.mk がないためエラーになるはず（include はデフォルトでエラー）
if make -n > /dev/null 2>&1; then
    echo "Unexpected PASS: Makefile should fail without _mk/vim.mk"
    exit 1
else
    echo "Confirmed FAIL: Makefile fails as expected without _mk/vim.mk"
fi

cd ..
rm -rf "$TEST_DIR"
```

**Step 2: Run test to verify it fails**

Run: `bash tests/repro_makefile_issue.sh`
Expected: `Confirmed FAIL: Makefile fails as expected without _mk/vim.mk` (または make のエラーメッセージ)

**Step 3: Commit the test script**

```bash
git add tests/repro_makefile_issue.sh
git commit -m "test: add reproduction script for Makefile include issue"
```

### Task 2: Makefile の修正

**Files:**
- Modify: `Makefile`

**Step 1: Implement the minimal code to make the test pass**

```makefile
<<<<
include _mk/vim.mk
====
ifneq ($(wildcard _mk/vim.mk),)
include _mk/vim.mk
endif
>>>>
```

**Step 2: Run the reproduction script to verify it passes**

Run: `bash tests/repro_makefile_issue.sh`
Expected: `Testing Makefile without _mk/vim.mk...` の後にエラーが出ず終了すること（スクリプト内の `Unexpected PASS` 判定を、修正に合わせて「パスすべき」ものとして調整が必要）

**Step 3: 最終検証**

`_mk/vim.mk` が存在する場合に正しく動作することも確認します。

Run:
```bash
# テスト用ディレクトリで vim.mk を作成して実行
mkdir -p tmp_test_make/_mk
echo 'test-target:; @echo "vim.mk loaded"' > tmp_test_make/_mk/vim.mk
cd tmp_test_make && make test-target
```
Expected: `vim.mk loaded`

**Step 4: Commit**

```bash
git add Makefile
git commit -m "fix: unify Makefile include style using wildcard"
```

### Task 3: クリーンアップ

**Files:**
- Remove: `tests/repro_makefile_issue.sh`

**Step 1: Remove reproduction script**

Run: `rm tests/repro_makefile_issue.sh`

**Step 2: Commit**

```bash
git commit -m "cleanup: remove reproduction script"
```
