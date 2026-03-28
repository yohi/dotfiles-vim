#!/usr/bin/env bash
set -euo pipefail

TEST_DIR="tmp_test_make"
trap 'rm -rf "$TEST_DIR"' EXIT

mkdir -p "$TEST_DIR/_mk"
cp Makefile "$TEST_DIR/"

echo -n "Testing Makefile without _mk/vim.mk... "
# cd into TEST_DIR and run make
# Using subshell to keep current directory
(
    cd "$TEST_DIR"
    if make -n > /dev/null 2>&1; then
        echo "FAILED (Unexpected PASS)"
        exit 1
    else
        echo "PASSED (Confirmed FAIL as expected)"
    fi
)
