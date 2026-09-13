-- Fuzzy directory picker for telescope.nvim.
-- Same style as the kitty Ctrl+F picker: reads the shared directory list from
-- ~/.config/fcd/dirs.conf (single source of truth), lists each configured root
-- plus its immediate subdirectories, displays paths with ~ for readability, and
-- on selection changes Neovim's working directory (:tcd) to the chosen dir.

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

local FCD_CONF = vim.fn.expand("~/.config/fcd/dirs.conf")
local HOME = vim.fn.expand("~")

-- Read the config file: skip blank/comment lines, expand ~, keep existing dirs.
local function read_roots()
	local roots = {}
	local f = io.open(FCD_CONF, "r")
	if not f then
		vim.notify("fcd: cannot open " .. FCD_CONF, vim.log.levels.ERROR)
		return roots
	end
	for line in f:lines() do
		local entry = line:gsub("%s+$", "") -- trim trailing whitespace
		if entry ~= "" and not entry:match("^%s*#") then
			local path = vim.fn.expand(entry)
			if vim.fn.isdirectory(path) == 1 then
				table.insert(roots, path)
			end
		end
	end
	f:close()
	return roots
end

-- Build the candidate list: each root plus its immediate subdirectories.
local function build_dirs()
	local roots = read_roots()
	local seen = {}
	local dirs = {}

	local function add(path)
		-- normalize: strip any trailing slash
		path = path:gsub("/+$", "")
		if path ~= "" and not seen[path] then
			seen[path] = true
			table.insert(dirs, path)
		end
	end

	for _, root in ipairs(roots) do
		add(root)
		-- immediate subdirectories only (one level deep), including hidden
		for name, typ in vim.fs.dir(root) do
			if typ == "directory" then
				add(root .. "/" .. name)
			end
		end
	end
	return dirs
end

-- Shorten a full path to ~ for display.
local function display_path(path)
	if path == HOME then
		return "~"
	elseif path:sub(1, #HOME + 1) == HOME .. "/" then
		return "~" .. path:sub(#HOME + 1)
	end
	return path
end

function M.pick_dir(opts)
	opts = opts or {}
	local dirs = build_dirs()
	if #dirs == 0 then
		vim.notify("fcd: no valid directories found", vim.log.levels.WARN)
		return
	end

	pickers.new(opts, {
		prompt_title = "cd",
		finder = finders.new_table({
			results = dirs,
			entry_maker = function(entry)
				return {
					value = entry,
					display = display_path(entry),
					ordinal = display_path(entry),
				}
			end,
		}),
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr)
			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				if selection then
					require("oil").open(selection.value)
				end
			end)
			return true
		end,
	}):find()
end

return M
