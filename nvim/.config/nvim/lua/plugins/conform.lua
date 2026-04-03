return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      julia = { "runic", lsp_format = "fallback", stop_after_first = true },
      python = { 'autopep8', 'black' },
      rust = { 'rustfmt' },
      javascript = { 'biome', 'prettier', stop_after_first = true },
      javascriptreact = { 'biome', 'prettier', stop_after_first = true },
      typescript = { 'biome', 'prettier', stop_after_first = true },
      typescriptreact = { 'biome', 'prettier', stop_after_first = true },
    },
    format_on_save = {
      lsp_format = 'fallback',
      -- Default 500ms is too short for slow LSP formatters (e.g. julials / JuliaFormatter path).
      timeout_ms = 15000,
    },
  },
}
