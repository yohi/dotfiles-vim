#!/usr/bin/env bash
set -euo pipefail

options_file="nvim/lua/config/options.lua"
clipboard_file="nvim/lua/config/clipboard.lua"
init_file="nvim/init.lua"

if [[ ! -f "${options_file}" ]]; then
  echo "config/options.lua is missing"
  exit 1
fi

if [[ ! -f "${clipboard_file}" ]]; then
  echo "config/clipboard.lua is missing"
  exit 1
fi

if [[ ! -f "${init_file}" ]]; then
  echo "init.lua is missing"
  exit 1
fi

required_patterns=(
  "(?:vim\\.opt|opt)\\.encoding = \"utf-8\""
  "(?:vim\\.opt|opt)\\.fileencodings ="
  "(?:vim\\.opt|opt)\\.fileformat = \"unix\""
  "(?:vim\\.opt|opt)\\.fileformats ="
  "(?:vim\\.opt|opt)\\.expandtab = true"
  "(?:vim\\.opt|opt)\\.shiftwidth = 4"
  "(?:vim\\.opt|opt)\\.tabstop = 4"
  "(?:vim\\.opt|opt)\\.softtabstop = 4"
  "(?:vim\\.opt|opt)\\.swapfile = false"
  "(?:vim\\.opt|opt)\\.undofile = false"
  "(?:vim\\.opt|opt)\\.autoread = true"
  "(?:vim\\.opt|opt)\\.hidden = true"
  "(?:vim\\.opt|opt)\\.timeout = true"
  "(?:vim\\.opt|opt)\\.timeoutlen = 500"
  "(?:vim\\.opt|opt)\\.number = true"
  "(?:vim\\.opt|opt)\\.cursorline = true"
  "(?:vim\\.opt|opt)\\.list = true"
  "(?:vim\\.opt|opt)\\.listchars ="
  "(?:vim\\.opt|opt)\\.ignorecase = true"
  "(?:vim\\.opt|opt)\\.smartcase = true"
  "(?:vim\\.opt|opt)\\.incsearch = true"
  "(?:vim\\.opt|opt)\\.hlsearch = true"
  "(?:vim\\.opt|opt)\\.wrapscan = false"
  "(?:vim\\.opt|opt)\\.updatetime = 300"
  "(?:vim\\.opt|opt)\\.exrc = false"
  "(?:vim\\.opt|opt)\\.secure = true"
)

for pattern in "${required_patterns[@]}"; do
  if ! rg -P -q "${pattern}" "${options_file}"; then
    echo "Missing required setting: ${pattern}"
    exit 1
  fi
done

if ! rg -P -q "(?:vim\\.opt|opt)\\.clipboard:append\\(\"unnamedplus\"\\)" "${clipboard_file}"; then
  echo "Missing required setting in clipboard.lua: clipboard:append(\"unnamedplus\")"
  exit 1
fi

if ! rg -P -q "require\\(\"config\\.clipboard\"\\)\\.setup\\(\\)" "${init_file}"; then
  echo "Missing required wiring in init.lua: require(\"config.clipboard\").setup()"
  exit 1
fi

if rg -q "TODO" "${options_file}"; then
  echo "TODO markers should not exist in config/options.lua"
  exit 1
fi
