-- remove f1 button because it's annoying
vim.api.nvim_set_keymap("n", "<F1>", "<Nop>", { noremap = true, silent = true })

-- copy and paste
vim.keymap.set({ "n", "v" }, "<C-c>", '"+y')

-- leader key
vim.g.mapleader = " "

-- keybinds: "mode" "button" "action"
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<leader>t', ':tabnew %<CR>')

-- spellcheck
vim.keymap.set('n', '<leader>p', ':set spell<CR>')

-- newline thing
vim.keymap.set('n', '<leader>o', 'o<Esc>0"_Dk$')
vim.keymap.set('n', '<leader>O', 'O<Esc>0"_Dj$')

--open browser here
vim.keymap.set('n', '<leader>z', ':Zb<CR>')
-- format doc + lsp stuff
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)

vim.keymap.set('n', '<leader>a', vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>c", vim.lsp.buf.code_action, { desc = "Code Action" })

vim.keymap.set('n', '<leader>n', ':enew<CR>')

