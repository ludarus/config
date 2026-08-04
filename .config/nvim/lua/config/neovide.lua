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
	vim.g.neovide_cursor_vfx_mode = ""
	-- vim.g.neovide_cursor_vfx_mode = "pixiedust"
end

--setting fontsize for neovide
vim.o.guifont = "JetBrainsMono Nerd Font Mono:h20"
