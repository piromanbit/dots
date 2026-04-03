-- Match shell XDG Julia layout (see fish config): LSP spawns `julia` without
-- login env, so set depot here too or LanguageServer.jl loads from ~/.julia.
local function ensure_julia_xdg_depot()
  local xdg_data = vim.env.XDG_DATA_HOME or vim.fn.expand("~/.local/share")
  local julia_depot = vim.fs.normalize(xdg_data .. "/julia")
  vim.env.JULIAUP_DEPOT_PATH = julia_depot

  local existing = vim.env.JULIA_DEPOT_PATH or ""
  if existing == "" then
    vim.env.JULIA_DEPOT_PATH = julia_depot
    return
  end
  local first = vim.split(existing, ":", { plain = true })[1]
  if first and vim.fs.normalize(first) == julia_depot then
    return
  end
  vim.env.JULIA_DEPOT_PATH = julia_depot .. ":" .. existing
end

ensure_julia_xdg_depot()

vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.termguicolors = false
vim.o.clipboard = "unnamedplus"
