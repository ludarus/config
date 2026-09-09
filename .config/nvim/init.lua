-- including modular files

require("config.options")
require("config.keybinds")
require("config.commands")

require("plugins.imports")
-- after plugins.imports: config.lsp reads the lsp/*.lua definitions that
-- nvim-lspconfig puts on the runtimepath
require("config.lsp")
require("plugins.config")
require("plugins.keybinds")

require("config.theme")
require("config.neovide")

-- keyboard layout stuff
require("layout.active")

if layout == "canary" then
	require("layout.canary")()
else
	require("layout.qwerty")()
end

