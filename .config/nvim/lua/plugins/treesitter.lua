local function setup_treesitter()
  require('nvim-treesitter').setup({
    ensure_installed = { "jinja", "yaml", "json" }
  })
end

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  config = setup_treesitter
}
