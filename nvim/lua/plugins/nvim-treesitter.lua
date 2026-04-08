return {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    enabled = true,
    config = function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = { "json", "jsonc", "lua", "vim" },
            highlight = {
                enable = true,
                -- 非常に重要な点: Tree-sitter を使う場合、
                -- 標準の Vim syntax を JSON で無効化して重複エラーを防ぎます
                disable = { "json" },
            },
            indent = { enable = true },
        })
    end,
}
