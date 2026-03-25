return {
  "saghen/blink.cmp",
  version = "*",
  event = "InsertEnter",
  opts = {
    keymap = {
      preset = "default",
      ["<C-d>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<Tab>"] = { "select_next", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
    },
    completion = {
      documentation = {
        auto_show = true,
      },
    },
    sources = {
      default = { "lsp", "path", "buffer" },
    },
    fuzzy = {
      implementation = "prefer_rust_with_warning",
    },
  },
}
