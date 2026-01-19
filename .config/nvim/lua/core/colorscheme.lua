local M = {}

local current_theme_cache = "gruvbox-material"

function M.check_theme_change()
	local state_file = vim.fn.stdpath("data") .. "/theme_state"
	local file = io.open(state_file, "r")
	if not file then return end
	local file_theme = file:read("*all")
	file:close()

	if file_theme and file_theme ~= current_theme_cache then
		current_theme_cache = file_theme
		vim.cmd.colorscheme(current_theme_cache)
	end
end

function M.load()
	local state_file = vim.fn.stdpath("data") .. "/theme_state"
	local file = io.open(state_file, "r")

	if file then
		current_theme_cache = file:read("*all")
		file:close()
	end

	local status, _ = pcall(vim.cmd.colorscheme, current_theme_cache)
	if not status then
		vim.notify("Ересь! Тема " .. current_theme_cache .. " не найдена. Возврат к деволту.",
			vim.log.levels.ERROR)
		vim.cmd.colorscheme("gruvbox-material")
	end
	vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
		pattern = "*",
		callback = M.check_theme_change,
	})
end

return M
