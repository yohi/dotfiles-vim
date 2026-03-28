# Makefile include unification design (2026-03-28)

## Overview
Makefile において、一部のインクルードが無条件に行われている点を、他のファイルと同様に「存在時のみインクルード」する形式に統一します。

## Problem Statement
`include _mk/vim.mk` が無条件に実行されており、ファイルが存在しない場合に `make` がエラーとなります。
他の `core.mk` や `help.mk` は `wildcard` を用いた条件付きインクルードが行われており、一貫性がありません。

## Proposed Design
`_mk/vim.mk` のインクルード部分を、以下の形式に変更します。

```makefile
ifneq ($(wildcard _mk/vim.mk),)
include _mk/vim.mk
endif
```

## Success Criteria
- `_mk/vim.mk` が存在しない場合でも、`make` がエラーにならずに実行できること。
- `_mk/vim.mk` が存在する場合、その内容（`setup-vim` ターゲットなど）が正しく読み込まれること。
- プロジェクト内での Makefile の書き方が統一されていること。
