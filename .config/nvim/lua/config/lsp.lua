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
vim.lsp.enable({ "pylsp", "jdtls", "tinymist", "lua_ls", "clangd", "html", "cssls", "tailwindcss", "ts_ls", "jsonls",
	"bashls" })
