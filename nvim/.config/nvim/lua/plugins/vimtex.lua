local function init_vimtex()
    vim.g.vimtex_view_method = "zathura"
    -- Enable filetype detection, plugins, and indentation
    vim.cmd('filetype plugin indent on')
    -- Enable syntax highlighting
    vim.cmd('syntax enable')
end


return {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = init_vimtex
}
