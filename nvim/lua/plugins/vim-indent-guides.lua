return  {
    'nathanaelkane/vim-indent-guides',
    enabled = false,
    config = function()
        -- Indent guide
        vim.g.indent_guides_start_level = 2
        vim.g.indent_guides_guide_size = 1
    end
}
