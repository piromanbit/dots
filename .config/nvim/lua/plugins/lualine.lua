local function parrot_status()
  local status_info = require("parrot.config").get_status_info()
  local status = ""
  if status_info.is_chat then
    status = status_info.prov.chat.name
  else
    status = status_info.prov.command.name
  end
  return string.format("%s(%s)", status, status_info.model)
end

local function setup_lualine()
  require('lualine').setup {
    options = {
      theme = 'gruvbox-material'
    },
    sections = {
      lualine_a = { parrot_status }
    }
  }
end

return {
  "nvim-lualine/lualine.nvim",
  config = setup_lualine
}
