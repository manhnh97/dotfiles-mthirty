local ok = pcall(vim.cmd.packadd, "fzf-lua")
if not ok then
  vim.keymap.set("n", "<leader>f", function()
    vim.notify("fzf-lua is not installed. Re-run install.sh", vim.log.levels.WARN)
  end)
  return
end

local fzf = require("fzf-lua")
fzf.setup({ "fzf-native" })

vim.keymap.set("n", "<leader>f", fzf.files)
vim.keymap.set("n", "<leader>b", fzf.buffers)
vim.keymap.set("n", "<leader>/", fzf.live_grep)
