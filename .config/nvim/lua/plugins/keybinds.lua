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

-- find files
vim.keymap.set('n', '<leader>s',
	function()
		-- TODO update this:
		builtin.find_files({
			search_dirs = {
				'~/G12',
				'~/projects',
				'~/Downloads',
				'~/.config/nvim',
				'~/.config/sway',
				'~/.config/neovide',
				'~/.config/kitty',
				'~/scripts',
				'~/.zshrc',
				'/mnt/win/Users/burge/Documents/Personal-Projects/',
			}
		})
	end)
