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

-- lsp diagnostics
require("tiny-inline-diagnostic").setup({
	-- Choose a preset style for diagnostic appearance
	-- Available: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
	preset = "classic",

	-- Make diagnostic background transparent
	transparent_bg = false,

	-- Make cursorline background transparent for diagnostics
	transparent_cursorline = true,

	-- Customize highlight groups for colors
	-- Use Neovim highlight group names or hex colors like "#RRGGBB"
	hi = {
		error = "DiagnosticError", -- Highlight for error diagnostics
		warn = "DiagnosticWarn", -- Highlight for warning diagnostics
		info = "DiagnosticInfo", -- Highlight for info diagnostics
		hint = "DiagnosticHint", -- Highlight for hint diagnostics
		arrow = "NonText",     -- Highlight for the arrow pointing to diagnostic
		background = "CursorLine", -- Background highlight for diagnostics
		mixing_color = "Normal", -- Color to blend background with (or "None")
	},

	-- List of filetypes to disable the plugin for
	disabled_ft = {},

	options = {
		-- Display the source of diagnostics (e.g., "lua_ls", "pyright")
		show_source = {
			enabled = false, -- Enable showing source names
			if_many = false, -- Only show source if multiple sources exist for the same diagnostic
		},

		-- Display the diagnostic code of diagnostics (e.g., "F401", "no-dupe-args")
		show_code = true,

		-- Use icons from vim.diagnostic.config instead of preset icons
		use_icons_from_diagnostic = false,

		-- Color the arrow to match the severity of the first diagnostic
		set_arrow_to_diag_color = false,


		-- Throttle update frequency in milliseconds to improve performance
		-- Higher values reduce CPU usage but may feel less responsive
		-- Set to 0 for immediate updates (may cause lag on slow systems)
		throttle = 20,

		-- Minimum number of characters before wrapping long messages
		softwrap = 30,

		-- Control how diagnostic messages are displayed
		-- NOTE: When using display_count = true, you need to enable multiline diagnostics with multilines.enabled = true
		--       If you want them to always be displayed, you can also set multilines.always_show = true.
		add_messages = {
			messages = true,       -- Show full diagnostic messages
			display_count = false, -- Show diagnostic count instead of messages when cursor not on line
			use_max_severity = false, -- When counting, only show the most severe diagnostic
			show_multiple_glyphs = true, -- Show multiple icons for multiple diagnostics of same severity
		},

		-- Settings for multiline diagnostics
		multilines = {
			enabled = false,    -- Enable support for multiline diagnostic messages
			always_show = false, -- Always show messages on all lines of multiline diagnostics
			trim_whitespaces = false, -- Remove leading/trailing whitespace from each line
			tabstop = 4,        -- Number of spaces per tab when expanding tabs
			-- Restrict which severities are shown on non-cursor lines
			-- With always_show = true: listed severities stay visible on every line,
			-- all other severities only appear on the cursor line
			severity = nil, -- e.g. { vim.diagnostic.severity.ERROR }
		},

		-- Show all diagnostics on the current cursor line, not just those under the cursor
		show_all_diags_on_cursorline = false,

		-- Only show diagnostics when the cursor is directly over them, no fallback to line diagnostics
		show_diags_only_under_cursor = false,

		-- Display related diagnostics from LSP relatedInformation
		show_related = {
			enabled = true, -- Enable displaying related diagnostics
			max_count = 3, -- Maximum number of related diagnostics to show per diagnostic
		},

		-- Enable diagnostics display in insert mode
		-- May cause visual artifacts; consider setting throttle to 0 if enabled
		enable_on_insert = false,

		-- Enable diagnostics display in select mode (e.g., during auto-completion)
		enable_on_select = false,

		-- Handle messages that exceed the window width
		overflow = {
			mode = "wrap", -- "wrap": split into lines, "none": no truncation, "oneline": keep single line
			padding = 0, -- Extra characters to trigger wrapping earlier
		},

		-- Break long messages into separate lines
		break_line = {
			enabled = false, -- Enable automatic line breaking
			after = 30, -- Number of characters before inserting a line break
		},

		-- Custom function to format diagnostic messages
		-- Receives diagnostic object, returns formatted string
		-- Example: function(diag) return diag.message .. " [" .. diag.source .. "]" end
		format = nil,

		-- Virtual text display priority
		-- Higher values appear above other plugins (e.g., GitBlame)
		virt_texts = {
			priority = 2048,
		},

		-- Filter diagnostics by severity levels
		-- Remove severities you don't want to display
		severity = {
			vim.diagnostic.severity.ERROR,
			vim.diagnostic.severity.WARN,
			vim.diagnostic.severity.INFO,
			vim.diagnostic.severity.HINT,
		},

		-- Events that trigger attaching diagnostics to buffers
		-- Default is {"LspAttach"}; change only if plugin doesn't work with your LSP setup
		overwrite_events = nil,

		-- Automatically disable diagnostics when opening diagnostic float windows
		override_open_float = false,

		-- Experimental options, subject to misbehave in future NeoVim releases
		experimental = {
			-- Make diagnostics not mirror across windows containing the same buffer
			-- See: https://github.com/rachartier/tiny-inline-diagnostic.nvim/issues/127
			use_window_local_extmarks = false,
		},
	},
})
