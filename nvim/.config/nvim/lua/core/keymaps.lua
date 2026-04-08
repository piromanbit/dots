vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- Neo-tree
map("n", "<leader>e", ":Neotree left focus<CR>", "Neotree: left focus")
map("n", "<leader>g", ":Neotree float git_status<cr>", "Neotree: git status")

-- Picker
map("n", "<leader>ff", function() require("fzf-lua").files() end, "Find files")
map("n", "<leader>fg", function() require("fzf-lua").live_grep() end, "Live grep")
map("n", "<leader>fb", function() require("fzf-lua").buffers() end, "List buffers")

-- Navigation
map("n", "<c-k>", "<cmd>wincmd k<cr>", "Window up")
map("n", "<c-j>", "<cmd>wincmd j<cr>", "Window down")
map("n", "<c-h>", "<cmd>wincmd h<cr>", "Window left")
map("n", "<c-l>", "<cmd>wincmd l<cr>", "Window right")
map("n", "<leader>/", function() require("mini.comment").toggle_lines() end, "Toggle comment")

-- Splits
map("n", "|", "<cmd>vsplit<cr>", "Vertical split")
--map("n", "\\", "<cmd>split<cr>", "Horizontal split")

-- Other
map("n", "<leader>w", "<cmd>w<cr>", "Save file")
map("n", "<leader>x", "<cmd>bdelete<cr>", "Close buffer")
map("i", "jj", "<Esc>", "Exit insert mode")
map("n", "<leader>h", "<cmd>nohlsearch<cr>", "Clear search highlights")

-- Buffers
map("n", "<Tab>", "<cmd>bnext<cr>", "Next buffer")
map("n", "<s-Tab>", "<cmd>bprevious<cr>", "Previous buffer")

-- LSP
map("n", "<leader>l", vim.diagnostic.open_float, "Line diagnostics")
map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
