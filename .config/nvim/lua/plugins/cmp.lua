local function setup_cmp()
  local cmp = require('cmp')

  cmp.setup({
    window = {},
    mapping = cmp.mapping.preset.insert({
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'}),
      ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'}),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'buffer' },
      { name = 'parrot' },
    })
  })
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  vim.lsp.config('*', { capabilities = capabilities })
end

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
  },
  config = setup_cmp
}
