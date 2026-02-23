-- lua/plugins/nvim-lint.lua
return {
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
      local lint = require("lint")
      
      lint.linters_by_ft = {
        python = { "flake8", "dmypy" },
        ["*"] = { "cspell" },  -- すべてのファイルタイプでcspellを有効化
      }
      
      -- オプション設定の例（必要に応じてカスタマイズ）
      -- lint.linters.flake8.args = { "--max-line-length=100" }
      -- lint.linters.cspell.args = { "--config", "~/.cspell.json" }

      -- 自動実行の設定
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })

    end,
  },
}
