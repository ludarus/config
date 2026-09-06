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


-- vim.keymap.set('n', '<leader><Tab>', ':Telescope<CR>')
vim.keymap.set('n', '<leader><Tab>', ':Telescope find_files cwd=.<CR>')

--global grep:
vim.keymap.set('n', '<leader>S', ':Telescope live_grep<CR>')

-- telescope:
vim.keymap.set('n', '<leader>j', ':Telescope<CR>')

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
			vim.fn.expand('~/.config/waybar'),
			vim.fn.expand('~/zmk-config/config'),
			vim.fn.expand('~/scripts'),
		},
		hidden = true,
		no_ignore = true,
	})
end)
