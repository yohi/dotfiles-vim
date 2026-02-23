#!/usr/bin/env bash
# Test script for Phase 2: Lua Configuration Foundation
# Note: Updated after Phase 8 completion - init.vim references are no longer expected
set -euo pipefail

echo "=== Phase 2: Lua Configuration Foundation Tests ==="

# Test 2.1: init.lua exists
echo -n "Test 2.1: init.lua exists... "
if [[ ! -f nvim/init.lua ]]; then
  echo "FAILED: init.lua is missing"
  exit 1
fi
echo "PASSED"

# Test 2.2: config directory exists
echo -n "Test 2.2: nvim/lua/config directory exists... "
if [[ ! -d nvim/lua/config ]]; then
  echo "FAILED: nvim/lua/config is missing"
  exit 1
fi
echo "PASSED"

# Test 2.3: utils directory exists
echo -n "Test 2.3: nvim/lua/utils directory exists... "
if [[ ! -d nvim/lua/utils ]]; then
  echo "FAILED: nvim/lua/utils is missing"
  exit 1
fi
echo "PASSED"

# Test 2.4: init.lua sets mapleader (leader key must be set before plugins)
echo -n "Test 2.4: init.lua sets mapleader... "
if ! rg -q "mapleader" nvim/init.lua; then
  echo "FAILED: init.lua does not set mapleader"
  exit 1
fi
echo "PASSED"

# Test 2.5: init.lua loads config modules
echo -n "Test 2.5: init.lua requires config modules... "
if ! rg -q 'require.*config\.options' nvim/init.lua; then
  echo "FAILED: init.lua does not require config.options"
  exit 1
fi
echo "PASSED"

# Test 2.6: init.lua loads lazy_bootstrap (plugin manager)
echo -n "Test 2.6: init.lua requires lazy_bootstrap... "
if ! rg -q 'require.*lazy_bootstrap' nvim/init.lua; then
  echo "FAILED: init.lua does not require lazy_bootstrap"
  exit 1
fi
echo "PASSED"

echo ""
echo "=== All Phase 2 tests PASSED ==="
