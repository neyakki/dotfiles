require("core.config")
require("core.lazy")
require("core.hotkeys")
require("core.theme")
require("core.cmd")

vim.filetype.add({
  pattern = { [".*/hyprland%.conf"] = "hyprlang" },
})
