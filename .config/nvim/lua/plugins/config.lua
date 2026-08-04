local metals = require("metals")
local metals_config = metals.bare_config()
metals_config.capabilities = vim.lsp.protocol.make_client_capabilities()
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "scala", "sbt" },
	callback = function()
		require("metals").initialize_or_attach(metals_config)
	end,
	group = nvim_metals_group,
})

require("nvim-tree").setup()

require("nvim-autopairs").setup()

-- require plugins and stuff
require('java').setup()

require('truefalse').setup({
	keymap = '<Leader>g'
})

-- treesitter
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- require "barbar".setup({
-- 	auto_hide = false,
-- })
--
-- -- barbar config
-- local map = vim.api.nvim_set_keymap
-- local opts = { noremap = true, silent = true }
--
-- -- Move to previous/next
-- map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
-- map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
--
-- -- Re-order to previous/next
-- map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
-- map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
--
-- -- Goto buffer in position...
-- map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
-- map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
-- map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
-- map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
-- map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
-- map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
-- map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
-- map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
-- map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
-- map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
--
-- -- Pin/unpin buffer
-- map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
--
-- -- Goto pinned/unpinned buffer
-- --                 :BufferGotoPinned
-- --                 :BufferGotoUnpinned
--
-- -- Close buffer
-- map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
--
-- -- Wipeout buffer
-- --                 :BufferWipeout
--
-- -- Close commands
-- --                 :BufferCloseAllButCurrent
-- --                 :BufferCloseAllButPinned
-- --                 :BufferCloseAllButCurrentOrPinned
-- --                 :BufferCloseBuffersLeft
-- --                 :BufferCloseBuffersRight
--
-- -- Magic buffer-picking mode
-- map('n', '<C-p>',   '<Cmd>BufferPick<CR>', opts)
-- map('n', '<C-s-p>', '<Cmd>BufferPickDelete<CR>', opts)
--
-- -- Sort automatically by...
-- map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
-- map('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>', opts)
-- map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
-- map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
-- map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
--
-- -- Other:
-- -- :BarbarEnable - enables barbar (enabled by default)
-- -- :BarbarDisable - very bad command, should never be used
--
vim.g.compile_mode = {
	default_command = "",
}
require('livepreview.config').set()
require "oil".setup({
	-- oil config
	default_file_explorer = true,
	columns = {
		"icon",
		-- "permissions",
		-- "size",
		-- "mtime",
	},

	view_options = {
		-- showing hidden files :3
		show_hidden = true
	},

	prompt_save_on_select_new_entry = true,
})

-- require "fastspell".setup()

-- require "plenary".setup()
require "telescope".setup({
	defaults = {
		path_display = { "smart" },
		color_devicons = true,
		sorting_strategy = "descending",
		layout_config = {
			prompt_position = "bottom",
		},
	},
})

require "mini.completion".setup()
require "typst-preview".setup({

	port = 0,
	host = '127.0.0.1',
	invert_colors = 'never',
	dependencies_bin = {
		['tinymist'] = nil,
		['websocat'] = nil,
	},
	extra_args = nil,


})

-- hex editing
-- defaults
require 'hex'.setup {

	-- cli command used to dump hex data
	dump_cmd = 'xxd -g 1 -u',

	-- cli command used to assemble from hex data
	assemble_cmd = 'xxd -r',

	-- function that runs on BufReadPre to determine if it's binary or not
	is_file_binary_pre_read = function()
		-- logic that determines if a buffer contains binary data or not
		-- must return a bool
	end,

	-- function that runs on BufReadPost to determine if it's binary or not
	is_file_binary_post_read = function()
		-- logic that determines if a buffer contains binary data or not
		-- must return a bool
	end,
}
