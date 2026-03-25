return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "jinja", "yaml", "json" },
    highlight = { enable = true },
    indent = { enable = true },
  },
  config = function(_, opts)
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if ok then
      configs.setup(opts)
      return
    end
    require("nvim-treesitter").setup(opts)
  end,
}
