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
local servers = { "pylsp", "jdtls", "tinymist", "lua_ls", "clangd", "html", "cssls", "tailwindcss", "ts_ls", "jsonls",
	"bashls" }

-- Neovim's fallback file-watching backend (vim._watch.watchdirs, used when
-- inotifywait is missing) recursively walks the whole workspace *on the main
-- thread* when a server registers workspace/didChangeWatchedFiles. With $HOME as
-- a workspace that measured ~7.5s of frozen UI per registration.
-- Install inotify-tools (provides inotifywait) to get the cheap backend back and
-- this opt-out disappears on its own.
if vim.fn.executable("inotifywait") == 0 then
	vim.lsp.config("*", {
		capabilities = {
			workspace = {
				didChangeWatchedFiles = { dynamicRegistration = false },
			},
		},
	})
end

-- Never let a server take $HOME as its workspace root. There is a ~/.git
-- (dotfiles repo), so ".git" as a last-resort root marker resolves to $HOME for
-- every file that is not inside a nested project, and the server then crawls
-- ~148k directories / 1.2M files (~/.cache, ~/.local, browser profiles, ...).
local home = vim.fs.normalize(assert(vim.uv.os_homedir()))

local function reject_home_root(name)
	local base = vim.lsp.config[name]
	if not base then
		return
	end
	local orig, markers, required = base.root_dir, base.root_markers, base.workspace_required

	vim.lsp.config(name, {
		root_dir = function(bufnr, on_dir)
			local function decide(dir)
				if dir and vim.fs.normalize(dir) == home then
					-- fall back to the file's own directory, or refuse to start
					-- the server at all if it insists on a real workspace
					local fname = vim.api.nvim_buf_get_name(bufnr)
					dir = (not required) and fname ~= "" and vim.fs.dirname(fname) or nil
					if dir and vim.fs.normalize(dir) == home then
						dir = nil -- file sits directly in $HOME: run single-file
					end
				end
				on_dir(dir)
			end

			if type(orig) == "function" then
				orig(bufnr, decide)
			elseif type(orig) == "string" then
				decide(orig)
			elseif markers then
				decide(vim.fs.root(bufnr, markers))
			else
				decide(nil)
			end
		end,
	})
end

for _, name in ipairs(servers) do
	reject_home_root(name)
end

vim.lsp.enable(servers)
