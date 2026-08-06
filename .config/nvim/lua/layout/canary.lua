return function()
	local opts = { noremap = true, silent = true }

	-- switching arrow keys
	vim.keymap.set("n", "m", "h", opts) -- left
	vim.keymap.set("n", "n", "j", opts) -- down
	vim.keymap.set("n", "e", "k", opts) -- up
	vim.keymap.set("n", "i", "l", opts) -- right
end
