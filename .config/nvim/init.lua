vim.api.nvim_set_keymap("n", "<F1>", "<Nop>", { noremap = true, silent = true })
vim.opt.completeopt = { 'menuone', 'noinsert' }
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.tabstop = 3
vim.opt.shiftwidth = 3
vim.opt.modeline = false

vim.opt.signcolumn = "yes"

-- style arguments: rounded, single, double, solid, none
vim.opt.winborder = "rounded"
-- leader key
vim.g.mapleader = " "

-- keybinds: "mode" "button" "action"
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<leader>t', ':tabnew %<CR>')

--hex mode
vim.keymap.set('n', '<leader>H', ':HexToggle<CR>')

-- tree
vim.keymap.set('n', '<leader>d', ':NvimTreeToggle<CR>')

-- spellcheck
vim.keymap.set('n', '<leader>p', ':set spell<CR>')

-- newline thing
vim.keymap.set('n', '<leader>o', 'o<Esc>0"_Dk$')
vim.keymap.set('n', '<leader>O', 'O<Esc>0"_Dj$')

--open browser here
vim.keymap.set('n', '<leader>b', ':Zb<CR>')
--open html version of code here
vim.keymap.set('n', '<leader>B', ':TOhtml<CR>:Zb<CR>:quit<CR>')
-- live preview
vim.keymap.set('n', '<leader>P', ':LivePreview start<CR>')
--typst preview
vim.keymap.set('n', '<leader>T', ':TypstPreview<CR>')

--typst export as pdf
vim.keymap.set('n', '<leader>E', ':LspTinymistExportPdf<CR>')

-- format doc
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>a', vim.diagnostic.open_float)

-- neovide only settings
if vim.g.neovide then
	-- copy and pasting
	local function copy() vim.cmd([[normal! "+y]]) end
	local function paste() vim.api.nvim_paste(vim.fn.getreg("+"), true, -1) end

	vim.keymap.set("v", "<C-C>", copy, { silent = true, desc = "Copy" })
	vim.keymap.set({ "n", "i", "v", "c", "t" }, "<C-S-V>", paste, { silent = true, desc = "Paste" })

	-- zoom
	vim.g.neovide_scale_factor = 1.0

	-- transparency
	vim.g.neovide_opacity = 0.5

	-- fps
	vim.g.neovide_refresh_rate = 60

	-- far scroll animations
	vim.g.neovide_scroll_animation_far_lines = 20

	-- vfx	
	-- vim.g.neovide_cursor_vfx_mode = ""
	vim.g.neovide_cursor_vfx_mode = "pixiedust"
end

-- autosave command
vim.o.autowriteall = true
vim.api.nvim_create_autocmd({ 'InsertLeavePre', 'TextChanged', 'TextChangedP' }, {
	pattern = '*',
	callback = function()
		vim.cmd('silent! write')
	end
})

--setting fontsize for neovide
vim.o.guifont = "JetBrainsMono Nerd Font Mono:h20"

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

-- images auto open
-- vim.api.nvim_create_autocmd("BufReadCmd", {
-- 	pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
-- 	callback = function()
-- 		local filename = vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
-- 		vim.cmd("silent !zen-browser " .. filename .. " &")
-- 		vim.cmd("let tobedeleted = bufnr('%') | b# | exe \"bd! \" . tobedeleted")
-- 	end
-- })


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

-- packages w/nightly package manager
-- java loool
vim.pack.add({
	{
		src = 'https://github.com/JavaHello/spring-boot.nvim',
		version = '218c0c26c14d99feca778e4d13f5ec3e8b1b60f0',
	},
	'https://github.com/MunifTanjim/nui.nvim',
	'https://github.com/mfussenegger/nvim-dap',

	'https://github.com/nvim-java/nvim-java',
})
vim.pack.add({
	{ src = "https://github.com/nyoom-engineering/oxocarbon.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/Myriad-Dreamin/tinymist" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-tree.lua" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/lucaSartore/fastspell.nvim" },
	-- lsp completion
	{ src = "https://github.com/nvim-mini/mini.completion" },
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/nvim-mini/mini.snippets" },
	{ src = "https://github.com/brianhuster/live-preview.nvim" },
	{ src = "https://github.com/ej-shafran/compile-mode.nvim" },
	{ src = "https://github.com/scalameta/nvim-metals" },
	-- { src = "https://github.com/romgrk/barbar.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/mfussenegger/nvim-dap" },

	{ src = "https://github.com/RaafatTurki/hex.nvim" },

	{ src = "https://github.com/ferplnat/truefalse.nvim" },

})
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
-- for executing functions and stuph
local builtin = require('telescope.builtin')



-- plugin keybinds
vim.keymap.set('n', '<leader>R', ':below Recompile<CR>')
vim.keymap.set('n', '<leader>r', ':below Compile<CR>')
vim.keymap.set('n', '<leader>e', ':Oil<CR>')
-- inserting current directory
vim.keymap.set("c", "<M-d>", function()
	return require("oil").get_current_dir()
end, { expr = true })
-- vim.keymap.set('n', '<leader><Tab>', ':Telescope<CR>')
vim.keymap.set('n', '<leader><Tab>', ':Telescope find_files cwd=.<CR>')
-- find files
vim.keymap.set('n', '<leader>s',
	function()
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

vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--query-driver=/usr/bin/arm-none-eabi-gcc",
	},
})
-- fix vim errors
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			}
		}
	}
}
)
vim.lsp.config("pylsp", {
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = {
					maxLineLength = 120,
				},
			},
		},
	},
})

-- enabling languages for lsp
vim.lsp.enable({ "pylsp", "jdtls", "tinymist", "lua_ls", "clangd", "html", "cssls", "tailwindcss", "ts_ls", "jsonls" })

vim.cmd("colorscheme oxocarbon")

-- global transparency
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#525252" })
