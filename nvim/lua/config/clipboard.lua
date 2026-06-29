-- =====================================================================================
-- clipboard.lua: SSH越しクリップボード統合
-- =====================================================================================
-- Neovim 0.10 以降の組み込み OSC 52 プロバイダを使用。
-- 外部コマンド (base64) や tmux 判別などのラッパーを自前で実装する必要がなく、
-- 堅牢かつポータブルに動作します。
-- ローカル実行時はシステムクリップボード（unnamedplus）にフォールバックします。
-- =====================================================================================

local M = {}

-- SSH環境かどうかを判定する
local function is_ssh()
  return vim.env.SSH_CLIENT ~= nil
    or vim.env.SSH_TTY ~= nil
    or vim.env.SSH_CONNECTION ~= nil
end

function M.setup()
  if is_ssh() then
    -- SSH 環境: Neovim 0.10+ 組み込みの OSC 52 プロバイダを使用
    local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")
    if ok then
      vim.g.clipboard = {
        name = "OSC52",
        copy = {
          ["+"] = osc52.copy("+"),
          ["*"] = osc52.copy("*"),
        },
        paste = {
          ["+"] = osc52.paste("+"),
          ["*"] = osc52.paste("*"),
        },
        cache_enabled = false,
      }
    else
      vim.notify(
        "OSC 52 プロバイダが利用できません（Neovim 0.10+ が必要）: " .. tostring(osc52),
        vim.log.levels.WARN
      )
    end
  end

  -- クリップボードをレジスタに同期（OSC52 設定の成否に関わらず常に適用）
  vim.opt.clipboard:append("unnamedplus")
end

return M
