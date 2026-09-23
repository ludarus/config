-- plugin keybinds
vim.keymap.set('n', '<leader>R', ':below Recompile<CR>')
vim.keymap.set('n', '<leader>r', ':below Compile<CR>')
vim.keymap.set('n', '<leader>e', ':Oil<CR>')
-- inserting current directory
vim.keymap.set("c", "<M-d>", function()
	return require("oil").get_current_dir()
end, { expr = true })

-- for executing functions and stuph
local builtin = require('telescope.builtin')


-- find files in the current working directory (cwd, incl. tcd set by <leader>d),
-- showing hidden files and ignoring .gitignore (home dir is a gitignore'd dotfiles repo)
vim.keymap.set('n', '<leader><Tab>', function()
	builtin.find_files({
		cwd = vim.fn.getcwd(),
		hidden = true,
		no_ignore = true,
	})
end)

--global grep in cwd, ignoring .gitignore:
vim.keymap.set('n', '<leader>S', function()
	builtin.live_grep({
		cwd = vim.fn.getcwd(),
		additional_args = { '--hidden', '--no-ignore' },
	})
end)

-- telescope:
vim.keymap.set('n', '<leader>j', ':Telescope<CR>')

--hex mode
vim.keymap.set('n', '<leader>H', ':HexToggle<CR>')

-- tree
vim.keymap.set('n', '<leader>D', ':NvimTreeToggle<CR>')

--open html version of code here
vim.keymap.set('n', '<leader>Z', ':TOhtml<CR>:Zb<CR>:quit<CR>')
-- live preview
vim.keymap.set('n', '<leader>P', ':LivePreview start<CR>')
--typst preview
vim.keymap.set('n', '<leader>T', ':TypstPreview<CR>')

--typst export as pdf
vim.keymap.set('n', '<leader>E', ':LspTinymistExportPdf<CR>')

-- fuzzy directory picker (same list as the kitty Ctrl+F picker) -> :tcd
vim.keymap.set('n', '<leader>d', function()
	require('config.fcd').pick_dir()
end, { desc = 'Fuzzy cd to a configured directory' })

-- marks
vim.keymap.set('n', '<leader>m', ':Telescope marks<CR>')

-- buffers
vim.keymap.set('n', '<leader>b', ':Telescope buffers<CR>')

-- find files
vim.keymap.set('n', '<leader>s', function()
	builtin.find_files({
		search_dirs = {
			vim.fn.expand('~/projects/leet'),
			vim.fn.expand('~/projects/py'),
			vim.fn.expand('~/projects/c'),
			vim.fn.expand('~/jault/2026fall'),
			vim.fn.expand('~/jault/journal'),
			vim.fn.expand('~/.config/nvim'),
			vim.fn.expand('~/.config/sway'),
			vim.fn.expand('~/.config/hypr'),
			vim.fn.expand('~/.config/waybar'),
			vim.fn.expand('~/.config/fcd'),
			vim.fn.expand('~/.config/sioyek'),
			vim.fn.expand('~/.config/swaync'),
			vim.fn.expand('~/zmk-config/config'),
			vim.fn.expand('~/scripts'),
		},
		hidden = true,
		no_ignore = true,
	})
end)
