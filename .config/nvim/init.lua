-- vim settingsinitinit.lua
-- note to self : DISABLE THE F1 KEY PLSS
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.tabstop = 3
vim.opt.shiftwidth = 3

-- style arguments: rounded, single, double, solid, none
vim.opt.winborder = "rounded"
-- leader key
vim.g.mapleader = " "

-- keybinds: "mode" "button" "action"
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<leader>t', ':tabnew %<CR>')
-- newline thing

vim.keymap.set('n', '<leader>o', 'o<Esc>k')
vim.keymap.set('n', '<leader>O', 'O<Esc>j')

--open browser here
vim.keymap.set('n', '<leader>b', ':Zb<CR>')
--open html version of code here
vim.keymap.set('n', '<leader>B', ':TOhtml<CR>:Zb<CR>:quit<CR>')

--typst preview
vim.keymap.set('n', '<leader>T', ':TypstPreview<CR>')

--typst export as pdf
vim.keymap.set('n', '<leader>E', ':LspTinymistExportPdf<CR>')

-- format doc
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>a', vim.diagnostic.open_float)
-- neovide copy and pasting
if vim.g.neovide then
	local function copy() vim.cmd([[normal! "+y]]) end
	local function paste() vim.api.nvim_paste(vim.fn.getreg("+"), true, -1) end

	vim.keymap.set("v", "<C-C>", copy, { silent = true, desc = "Copy" })
	vim.keymap.set({ "n", "i", "v", "c", "t" }, "<C-S-V>", paste, { silent = true, desc = "Paste" })
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
vim.g.neovide_scale_factor = 1.0

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

-- images
vim.api.nvim_create_autocmd("BufReadCmd", {
	pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
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
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/lucaSartore/fastspell.nvim" },
	{ src = "https://github.com/nvim-mini/mini.completion" },
	{ src = "https://github.com/brianhuster/live-preview.nvim" },
	{ src = "https://github.com/ej-shafran/compile-mode.nvim" },
	{ src = "https://github.com/scalameta/nvim-metals" },
	-- { src = "https://github.com/romgrk/barbar.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/mfussenegger/nvim-dap" },

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

-- require plugins and stuff
require('java').setup()
-- require "barbar".setup({
-- 	auto_hide = false,
--
-- })
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
-- for executing functions and stuph
local builtin = require('telescope.builtin')



-- plugin keybinds
vim.keymap.set('n', '<leader>r', ':below Recompile<CR>')
vim.keymap.set('n', '<leader>R', ':below Compile<CR>')
vim.keymap.set('n', '<leader>e', ':Oil<CR>')
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

-- enabling languages for lsp
vim.lsp.enable({ "jdtls", "tinymist", "lua_ls", "clangd", "html", "cssls", "tailwindcss", "ts_ls", "jsonls" })
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


vim.cmd("colorscheme oxocarbon")

-- global transparency
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#525252" })

--neovide transparency
vim.g.neovide_opacity = 0.5
