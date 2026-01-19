local function mason_setup()
  require('mason').setup {}
end

return {
  "williamboman/mason.nvim",
  config = mason_setup
}
