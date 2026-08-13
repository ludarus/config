-- remove f1 button because it's annoying
vim.api.nvim_set_keymap("n", "<F1>", "<Nop>", { noremap = true, silent = true })

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
vim.keymap.set('n', '<leader>z', ':Zb<CR>')
--open html version of code here
vim.keymap.set('n', '<leader>Z', ':TOhtml<CR>:Zb<CR>:quit<CR>')
-- live preview
vim.keymap.set('n', '<leader>P', ':LivePreview start<CR>')
--typst preview
vim.keymap.set('n', '<leader>T', ':TypstPreview<CR>')

--typst export as pdf
vim.keymap.set('n', '<leader>E', ':LspTinymistExportPdf<CR>')

-- format doc
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>a', vim.diagnostic.open_float)

vim.keymap.set('n', '<leader>n', ':enew<CR>')

