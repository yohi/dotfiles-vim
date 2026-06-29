-- =====================================================================================
-- clipboard.lua: SSH越しクリップボード統合
-- =====================================================================================
-- SSH環境では xclip/xsel/pbcopy が利用できないため OSC 52 エスケープシーケンスを使用。
-- OSC 52 はターミナルエミュレータ（WezTerm, iTerm2, Alacritty, Kitty など）の
-- クリップボードに直接書き込む。SSH越しのトンネリングも自動で行われる。
-- ローカル実行時はシステムクリップボード（unnamedplus）にフォールバックする。
-- =====================================================================================

local M = {}

-- OSC 52 でテキストをターミナルのクリップボードへ送る
local function osc52_copy(lines, _regtype)
  local text = table.concat(lines, "\n")
  -- base64 エンコード
  local encoded = vim.fn.system("base64 | tr -d '\\n'", text)
  -- OSC 52 シーケンスを送信
  -- \x1b]52;c;<base64>\x07
  local seq = string.format("\x1b]52;c;%s\x07", encoded)
  -- /dev/tty へ直接書き込む（tmux セッション内でも確実に動作する）
  local fd = io.open("/dev/tty", "w")
  if fd then
    fd:write(seq)
    fd:close()
  end
end

-- SSH環境かどうかを判定する
local function is_ssh()
  return vim.env.SSH_CLIENT ~= nil
    or vim.env.SSH_TTY ~= nil
    or vim.env.SSH_CONNECTION ~= nil
end

-- tmux 内で動作しているかどうかを判定する
local function is_tmux()
  return vim.env.TMUX ~= nil
end

-- tmux 経由の OSC 52 コピー（DCS ラッパーが必要）
local function osc52_copy_tmux(lines, _regtype)
  local text = table.concat(lines, "\n")
  local encoded = vim.fn.system("base64 | tr -d '\\n'", text)
  -- tmux は OSC を DCS でラップする必要がある
  local seq = string.format("\x1bPtmux;\x1b\x1b]52;c;%s\x07\x1b\\", encoded)
  local fd = io.open("/dev/tty", "w")
  if fd then
    fd:write(seq)
    fd:close()
  end
end

-- OSC 52 paste（ほぼ全てのターミナルで read は非対応のため空を返す）
local function osc52_paste(_regtype)
  return { "", "v" }
end

function M.setup()
  if is_ssh() then
    -- SSH 環境: OSC 52 カスタムプロバイダを使用
    local copy_fn = is_tmux() and osc52_copy_tmux or osc52_copy

    vim.g.clipboard = {
      name = "OSC52",
      copy = {
        ["+"] = copy_fn,
        ["*"] = copy_fn,
      },
      paste = {
        ["+"] = osc52_paste,
        ["*"] = osc52_paste,
      },
      cache_enabled = false,
    }
    vim.opt.clipboard:append("unnamedplus")
  else
    -- ローカル環境: 通常のシステムクリップボードを使用
    vim.opt.clipboard:append("unnamedplus")
  end
end

return M
