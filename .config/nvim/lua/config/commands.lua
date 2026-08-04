-- autosave command
vim.o.autowriteall = true
vim.api.nvim_create_autocmd({ 'InsertLeavePre', 'TextChanged', 'TextChangedP' }, {
	pattern = '*',
	callback = function()
		vim.cmd('silent! write')
	end
})

-- autopen commands from a random blog
-- Open binary files
-- pdf
vim.api.nvim_create_autocmd("BufReadCmd", {
	pattern = "*.pdf",
	callback = function()
		local filename = vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
		vim.cmd("silent !zen-browser " .. filename .. " &")
		vim.cmd("let tobedeleted = bufnr('%') | b# | exe \"bd! \" . tobedeleted")
	end
})

-- vibecoded:
-- ** THIS COMMMAND HAS BEEN DEPRECATED BY compile-mode.nvim **
vim.api.nvim_create_user_command("Trm", function()
	local file_dir = vim.fn.expand("%:p:h")
	vim.fn.jobstart({ "kitty", "--working-directory", file_dir }, { detach = true })
end, {})

vim.api.nvim_create_user_command("Zb", function()
	local file_dir = vim.fn.expand("%")
	vim.fn.jobstart({ "zen-browser", file_dir }, { detach = true })
end, {})

-- images auto open
-- vim.api.nvim_create_autocmd("BufReadCmd", {
-- 	pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
-- 	callback = function()
-- 		local filename = vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
-- 		vim.cmd("silent !zen-browser " .. filename .. " &")
-- 		vim.cmd("let tobedeleted = bufnr('%') | b# | exe \"bd! \" . tobedeleted")
-- 	end
-- })
