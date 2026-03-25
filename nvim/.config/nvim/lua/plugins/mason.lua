return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  cmd = { "Mason", "MasonInstall", "MasonUpdate" },
  opts = {},
  config = function(_, opts)
    local local_bin = vim.fn.expand("~/.local/bin")
    if not vim.startswith(vim.env.PATH or "", local_bin) then
      vim.env.PATH = local_bin .. ":" .. (vim.env.PATH or "")
    end

    require("mason").setup(opts)
  end,
}
