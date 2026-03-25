local servers = {
  "ansiblels",
  "clangd",
  "gopls",
  "jinja_lsp",
  "jsonls",
  "lua_ls",
  "marksman",
  "nil_ls",
  "prismals",
  "pylsp",
  "rust_analyzer",
  "ts_ls",
}

local server_overrides = {
  rust_analyzer = {
    filetypes = { "rust" },
  },
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
  },
}

local function setup_lsp()
  local capabilities = require("blink.cmp").get_lsp_capabilities()
  vim.lsp.config("*", { capabilities = capabilities })

  for _, server in ipairs(servers) do
    local cfg = vim.tbl_deep_extend("force", { capabilities = capabilities }, server_overrides[server] or {})
    vim.lsp.config(server, cfg)
    vim.lsp.enable(server)
  end

  local group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(ev)
      vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

      local opts = { buffer = ev.buf, silent = true }
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "LSP declaration" }))
      vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP hover" }))
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "LSP implementation" }))
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "LSP signature help" }))
      vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP rename" }))
      vim.keymap.set({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "LSP code action" }))
      vim.keymap.set("n", "<Leader>lf", function() vim.lsp.buf.format({ async = true }) end, vim.tbl_extend("force", opts, { desc = "LSP format" }))
    end,
  })

  local ok_mlsp, mason_lspconfig = pcall(require, "mason-lspconfig")
  if ok_mlsp then
    mason_lspconfig.setup({
      ensure_installed = servers,
      automatic_installation = true,
    })
  end
end

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = setup_lsp,
}
