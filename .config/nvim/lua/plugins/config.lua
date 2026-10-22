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

-- Lazy-load nvim-java only when a Java file is opened (saves ~20ms at startup).
local nvim_java_group = vim.api.nvim_create_augroup("nvim-java-lazy", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "java" },
	once = true,
	group = nvim_java_group,
	callback = function()
		require('java').setup()
	end,
})

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

	-- oil blocks the UI on a synchronous workspace/willRenameFiles request for
	-- every attached client that supports it (ts_ls does) on each rename/move/
	-- delete. The default 1000ms means a busy server can freeze nvim for a full
	-- second per file operation.
	lsp_file_methods = {
		timeout_ms = 200,
	},
})

-- require "fastspell".setup()

-- require "plenary".setup()
-- Deferred setups: these plugins are not needed before the first UI frame, so
-- run their .setup() right AFTER startup via vim.schedule(). This moves their
-- cost (telescope ~11ms, typst-preview, hex, live-share) off the critical path
-- that Neovide waits on, so the window appears sooner. Telescope keymaps are
-- already lazy (see plugins/keybinds.lua), so nothing calls these before the
-- scheduled callback runs.
vim.schedule(function()
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

	require "typst-preview".setup({

		port = 0,
		host = '127.0.0.1',
		invert_colors = 'auto',
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

	-- collaborative editing (VS Code Live Share alternative)
	require("live-share").setup({
		username = "joe",
	})
end)

require "mini.completion".setup()

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

-- Pretty in-buffer markdown rendering: colored headings, code blocks, bullets,
-- checkboxes, tables and Obsidian-style callouts. This is what adds the colors.
require("render-markdown").setup({
	-- render in normal/command/terminal mode; the raw markdown of the line the
	-- cursor is on stays visible so you can edit it
	render_modes = { "n", "c", "t" },

	-- colored, icon-prefixed headings each with a tinted full-width background bar
	heading = {
		sign = false,
		icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
		width = "block",
		left_pad = 0,
		right_pad = 2,
	},

	-- fenced code blocks get a background + the language name/icon on the border
	code = {
		sign = false,
		width = "block",
		right_pad = 2,
		language_name = true,
		border = "thin",
	},

	bullet = {
		icons = { "●", "○", "◆", "◇" },
		-- color each nesting level differently (oxocarbon palette)
		highlight = {
			"RenderMarkdownBullet1",
			"RenderMarkdownBullet2",
			"RenderMarkdownBullet3",
			"RenderMarkdownBullet4",
		},
	},

	checkbox = {
		unchecked = { icon = "󰄱 " },
		checked = { icon = "󰱒 " },
	},

	-- > [!NOTE] / [!WARNING] etc. callouts, colored by type
	callout = {},
})

-- Color list markers (bullets + ordered numbers), bold and italic text.
-- render-markdown doesn't style bold/italic itself; those come from the
-- treesitter capture groups @markup.strong / @markup.italic, which oxocarbon
-- leaves colorless. Re-apply on ColorScheme so a theme switch doesn't wipe them.
local function markdown_colors()
	local palette = {
		cyan = "#3DDBD9",
		blue = "#78A9FF",
		purple = "#BE95FF",
		lavender = "#D0BFE6",
		pink = "#FF7EB6",
		amber = "#FFB86C",
		-- brighter, more saturated purple for bold emphasis
		purple_bright = "#C792FF",
		purple_bg = "#2A1E3F",
	}
	-- bullets per nesting level + ordered-list numbers share these groups
	vim.api.nvim_set_hl(0, "RenderMarkdownBullet1", { fg = palette.cyan })
	vim.api.nvim_set_hl(0, "RenderMarkdownBullet2", { fg = palette.blue })
	vim.api.nvim_set_hl(0, "RenderMarkdownBullet3", { fg = palette.purple })
	vim.api.nvim_set_hl(0, "RenderMarkdownBullet4", { fg = palette.lavender })
	-- bold / italic text spans (keep the attribute, add a color)
	-- bold text: vivid purple + bold attribute + a faint purple background so it
	-- reads heavier (there is no "extra bold" attribute; bold=true is the max,
	-- so the background tint is what adds extra visual weight)
	vim.api.nvim_set_hl(0, "@markup.strong", { fg = palette.purple_bright, bold = true, bg = palette.purple_bg })
	vim.api.nvim_set_hl(0, "@markup.italic", { fg = palette.pink, italic = true })
end

markdown_colors()
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("markdown-colors", { clear = true }),
	callback = markdown_colors,
})

-- <C-b> in markdown: bold the word under the cursor (normal mode) or the
-- selection (visual mode). Toggles: if the target is already wrapped in **,
-- the markers are removed instead.
local function md_bold_word()
	local line = vim.api.nvim_get_current_line()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	-- find the word boundaries under the cursor (0-indexed byte columns)
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local s, e = nil, nil
	-- scan outward from the cursor over word characters
	local function is_word(c)
		return c:match("[%w_]") ~= nil
	end
	local i = col + 1 -- 1-indexed into the string
	if i > #line or not is_word(line:sub(i, i)) then
		-- cursor on whitespace/punct: nudge to the previous word char if any
		while i > 1 and not is_word(line:sub(i, i)) do
			i = i - 1
		end
	end
	if i < 1 or not is_word(line:sub(i, i)) then
		return
	end
	s = i
	while s > 1 and is_word(line:sub(s - 1, s - 1)) do
		s = s - 1
	end
	e = i
	while e < #line and is_word(line:sub(e + 1, e + 1)) do
		e = e + 1
	end
	local word = line:sub(s, e)
	local before = line:sub(1, s - 1)
	local after = line:sub(e + 1)
	-- toggle: strip surrounding ** if already bold
	if before:sub(-2) == "**" and after:sub(1, 2) == "**" then
		local new = before:sub(1, -3) .. word .. after:sub(3)
		vim.api.nvim_set_current_line(new)
		vim.api.nvim_win_set_cursor(0, { row, s - 3 })
	else
		local new = before .. "**" .. word .. "**" .. after
		vim.api.nvim_set_current_line(new)
		vim.api.nvim_win_set_cursor(0, { row, s + 1 })
	end
end

local function md_bold_selection()
	-- toggle bold on the current visual selection
	local srow, scol = unpack(vim.api.nvim_buf_get_mark(0, "<"))
	local erow, ecol = unpack(vim.api.nvim_buf_get_mark(0, ">"))
	if srow ~= erow then
		-- multi-line: only handle single-line selections for simplicity
		vim.notify("Bold toggle supports single-line selections", vim.log.levels.WARN)
		return
	end
	local line = vim.api.nvim_get_current_line()
	ecol = math.min(ecol + 1, #line) -- '> mark is inclusive
	local sel = line:sub(scol + 1, ecol)
	local before = line:sub(1, scol)
	local after = line:sub(ecol + 1)

	if sel:sub(1, 2) == "**" and sel:sub(-2) == "**" and #sel >= 4 then
		-- case A: the selection itself includes the ** markers -> strip them
		local inner = sel:sub(3, -3)
		vim.api.nvim_set_current_line(before .. inner .. after)
	elseif before:sub(-2) == "**" and after:sub(1, 2) == "**" then
		-- case B: ** sit just outside the selection -> remove the outer markers
		vim.api.nvim_set_current_line(before:sub(1, -3) .. sel .. after:sub(3))
	else
		-- not bold yet -> wrap it
		vim.api.nvim_set_current_line(before .. "**" .. sel .. "**" .. after)
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown" },
	group = vim.api.nvim_create_augroup("markdown-bold-keymap", { clear = true }),
	callback = function(args)
		vim.keymap.set("n", "<C-b>", md_bold_word, {
			buffer = args.buf,
			desc = "Bold word under cursor (toggle)",
		})
		vim.keymap.set("v", "<C-b>", function()
			-- leave visual mode so the '< '> marks are set, then wrap
			vim.cmd("normal! \27")
			md_bold_selection()
		end, {
			buffer = args.buf,
			desc = "Bold selection",
		})
	end,
})
