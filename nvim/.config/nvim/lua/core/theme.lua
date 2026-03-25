local M = {}

local default_theme = "gruvbox-material"
local current_theme = default_theme

local function read_theme_state()
  local state_file = vim.fn.stdpath("data") .. "/theme_state"
  local file = io.open(state_file, "r")
  if not file then
    return nil
  end

  local value = file:read("*all")
  file:close()
  if not value then
    return nil
  end

  return vim.trim(value)
end

local function apply_theme(theme_name)
  local ok = pcall(vim.cmd.colorscheme, theme_name)
  if not ok then
    vim.notify("Theme '" .. theme_name .. "' not found. Falling back to " .. default_theme .. ".", vim.log.levels.WARN)
    vim.cmd.colorscheme(default_theme)
    current_theme = default_theme
    return
  end
  current_theme = theme_name
end

function M.reload_if_changed()
  local file_theme = read_theme_state()
  if file_theme and file_theme ~= current_theme then
    apply_theme(file_theme)
  end
end

function M.load()
  apply_theme(read_theme_state() or default_theme)

  vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
    pattern = "*",
    callback = M.reload_if_changed,
  })
end

return M
