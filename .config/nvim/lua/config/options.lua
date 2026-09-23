-- Disable unused language providers to cut startup time.
-- Python LSP does NOT use these providers, so LSP on .py files is unaffected.
-- The Python3 provider was only being pulled in eagerly by the system
-- /usr/share/vim/vimfiles/plugin/black.vim; disabling it removes that cost.
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Prevent the system-installed black.vim from auto-sourcing at startup.
vim.g.loaded_black = 1

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
