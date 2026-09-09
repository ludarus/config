-- autosave command
vim.o.autowriteall = true

-- Only autosave real, named, writable file buffers: skips oil:// buffers
-- (buftype = "acwrite", where a write means "apply these filesystem changes"),
-- terminals, quickfix, help, etc.
-- TextChangedP is excluded on purpose: it fires on every keystroke while the
-- completion popup is open, so it meant a full write + LSP didSave per character.
local function autosave(buf)
	if
		vim.bo[buf].buftype ~= ''
		or not vim.bo[buf].modifiable
		or vim.bo[buf].readonly
		or not vim.bo[buf].modified
		or vim.api.nvim_buf_get_name(buf) == ''
	then
		return
	end
	vim.api.nvim_buf_call(buf, function()
		vim.cmd('silent! lockmarks write')
	end)
end

vim.api.nvim_create_autocmd({ 'InsertLeavePre', 'TextChanged' }, {
	group = vim.api.nvim_create_augroup('autosave', { clear = true }),
	pattern = '*',
	callback = function(ev)
		autosave(ev.buf)
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
