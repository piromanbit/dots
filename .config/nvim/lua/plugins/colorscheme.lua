local function setup_catppuccin()
  require('catppuccin').setup {
    flavour = "macchiato",
    transparent_background = true
  }
end

local function setup_gruvbox()
  require('gruvbox-material').setup {
    background = {
      transparent = true,
    },
  }
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    config = setup_catppuccin
  },
  {
    "f4z3r/gruvbox-material.nvim",
    lazy = false,
    config = setup_gruvbox
  }
}
