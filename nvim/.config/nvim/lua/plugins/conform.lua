return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      python = { 'autopep8', 'black' },
      rust = { 'rustfmt' },
      javascript = { 'biome', 'prettier', stop_after_first = true },
      javascriptreact = { 'biome', 'prettier', stop_after_first = true },
      typescript = { 'biome', 'prettier', stop_after_first = true },
      typescriptreact = { 'biome', 'prettier', stop_after_first = true },
    },
    format_on_save = {
      lsp_format = 'fallback',
      timeout_ms = 500,
    },
  },
}
