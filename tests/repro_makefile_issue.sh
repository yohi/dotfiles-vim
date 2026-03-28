#!/usr/bin/env bash
set -euo pipefail

# This test script verifies that the Makefile correctly handles the missing _mk/vim.mk file.
# It also ensures the setup target works as expected in both cases.

TEST_DIR="tmp_test_make"
trap 'rm -rf "$TEST_DIR"' EXIT

mkdir -p "$TEST_DIR/_mk"
cp Makefile "$TEST_DIR/"

# Case 1: _mk/vim.mk is missing
echo -n "Testing Makefile without _mk/vim.mk... "
(
    cd "$TEST_DIR"
    # Dry run should pass
    if ! make -n > /dev/null 2>&1; then
        echo "FAILED (Dry run failed without vim.mk)"
        exit 1
    fi
    # setup target should work
    if ! make setup | grep -q "==> Setting up dotfiles-vim"; then
        echo "FAILED (setup target output incorrect without vim.mk)"
        exit 1
    fi
    echo "PASSED"
)

# Case 2: _mk/vim.mk is present
echo -n "Testing Makefile WITH _mk/vim.mk... "
(
    cd "$TEST_DIR"
    # Create dummy vim.mk
    cat > _mk/vim.mk <<EOF
.PHONY: setup-vim
setup-vim:
	@echo "  -> (test) vim setup called"
EOF

    # Dry run should pass
    if ! make -n > /dev/null 2>&1; then
        echo "FAILED (Dry run failed WITH vim.mk)"
        exit 1
    fi
    # setup target should call setup-vim
    if ! make setup | grep -q "(test) vim setup called"; then
        echo "FAILED (setup target did not call setup-vim)"
        exit 1
    fi
    echo "PASSED"
)
