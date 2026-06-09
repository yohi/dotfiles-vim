return {
    'Yggdroot/indentLine',
    enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        vim.g.indentLine_char = '│'
    end
}
