return {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = { "VeryLazy" },
    branch = "main",
    dependencies = {
        { "zbirenbaum/copilot.lua" },
        { "nvim-lua/plenary.nvim" },
    },
    opts = {
        model = "claude-sonnet-4", -- モデル名を指定
        debug = true, -- デバッグを有効化
    },
}
