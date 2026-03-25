vim.diagnostic.enable()

local sign_text = {
  [vim.diagnostic.severity.ERROR] = " ",
  [vim.diagnostic.severity.WARN] = " ",
  [vim.diagnostic.severity.INFO] = " ",
  [vim.diagnostic.severity.HINT] = "󰌵",
}

vim.diagnostic.config({
  signs = {
    text = sign_text,
  },
  underline = true,
  virtual_text = {
    spacing = 2,
    source = "if_many",
    prefix = "●",
  },
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
})

