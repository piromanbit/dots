local function setup_gruvbox()
  require('gruvbox-material').setup {
    background = {
      transparent = true,
    },
  }
end

return {
  "f4z3r/gruvbox-material.nvim",
  config = setup_gruvbox
}
