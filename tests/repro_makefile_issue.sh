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
