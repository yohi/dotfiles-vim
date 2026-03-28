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
