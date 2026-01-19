local function setup_conform()
  require('conform').setup {
    formatters_by_ft = {
      python = { 'autopep8', 'black' },
      rust = { 'rustfmt', lsp_format = 'fallback' },
    },
  }
end

return {
  "stevearc/conform.nvim",
  config = setup_conform
}
