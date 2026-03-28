# Makefile include unification design (2026-03-28)

## Overview
Makefile において、一部のインクルードが無条件に行われている点を、他のファイルと同様に「存在時のみインクルード」する形式に統一し、同時に変数化によって保守性を向上させます。

## Problem Statement
`include _mk/vim.mk` が無条件に実行されており、ファイルが存在しない場合に `make` がエラーとなります。
他の `core.mk` や `help.mk` は `wildcard` を用いた条件付きインクルードが行われており、一貫性がありません。
また、`_mk/vim.mk` へのパスが複数箇所にハードコードされており、保守性が低下しています。

## Proposed Design

### 1. Makefile の変数リファクタリング
`_mk/vim.mk` へのパスを変数 `VIM_MK` として定義し、既存のすべての箇所をこの変数で置き換えます。

```makefile
VIM_MK := _mk/vim.mk

ifneq ($(wildcard $(VIM_MK)),)
include $(VIM_MK)
endif
```

### 2. 再現スクリプトの改善
`tests/repro_makefile_issue.sh` は `before` または `after` のモード引数を受け取り、それぞれの状態で期待される動作（失敗/成功）を検証するようにします。

## Success Criteria
- `_mk/vim.mk` が存在しない場合でも、`make` がエラーにならずに実行できること。
- `_mk/vim.mk` が存在する場合、その内容が正しく読み込まれること。
- プロジェクト内での Makefile の書き方が統一されていること。
- `_mk/vim.mk` へのパスが変数化されていること。
- markdownlint のルール（H1 → H2 階層構造）に準拠していること。
