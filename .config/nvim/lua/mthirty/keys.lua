local map = vim.keymap.set

-- Same chords as the Cursor Vim extension.
map("i", "fj", "<Esc>")
map("i", "<C-h>", "<Left>")
map("i", "<C-j>", "<Down>")
map("i", "<C-k>", "<Up>")
map("i", "<C-l>", "<Right>")

map("n", "H", "<cmd>bprevious<CR>")
map("n", "L", "<cmd>bnext<CR>")

map("n", "<leader>w", "<cmd>write<CR>")
map("n", "<leader>q", "<cmd>quit<CR>")
map("n", "<leader>x", "<cmd>write<CR><cmd>quit<CR>")
map("n", "<leader>v", "<cmd>vsplit<CR>")
map("n", "<leader>s", "<cmd>split<CR>")
map("n", "<leader>h", "<cmd>nohlsearch<CR>")

map("n", "J", ":m .+1<CR>==", { silent = true })
map("n", "K", ":m .-2<CR>==", { silent = true })
map("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
map("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

local function jump_diagnostic(count)
  if vim.diagnostic.jump then
    vim.diagnostic.jump({ count = count, float = true })
  else
    if count < 0 then
      vim.diagnostic.goto_prev({ float = true })
    else
      vim.diagnostic.goto_next({ float = true })
    end
  end
end

map("n", "[d", function()
  jump_diagnostic(-1)
end)
map("n", "]d", function()
  jump_diagnostic(1)
end)

map("n", "<leader>t", function()
  local swaps = {
    ["true"] = "false",
    ["false"] = "true",
    ["True"] = "False",
    ["False"] = "True",
    ["0"] = "1",
    ["1"] = "0",
  }
  local word = vim.fn.expand("<cword>")
  local next_word = swaps[word]
  if not next_word then
    return
  end
  vim.cmd("normal! ciw" .. next_word)
  vim.cmd("stopinsert")
end)

local function format_buffer()
  local name = vim.api.nvim_buf_get_name(0)
  local ft = vim.bo.filetype
  if ft == "python" and vim.fn.executable("ruff") == 1 then
    local view = vim.fn.winsaveview()
    vim.cmd("%!ruff format --stdin-filename " .. vim.fn.shellescape(name ~= "" and name or "stdin.py") .. " -")
    vim.fn.winrestview(view)
    return
  end
  local prettier = vim.fn.findfile("node_modules/.bin/prettier", ".;")
  if prettier ~= "" and vim.tbl_contains({
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "json",
    "jsonc",
    "css",
    "html",
    "markdown",
  }, ft) then
    local view = vim.fn.winsaveview()
    vim.cmd("%!" .. vim.fn.shellescape(prettier) .. " --stdin-filepath " .. vim.fn.shellescape(name))
    vim.fn.winrestview(view)
    return
  end
  vim.lsp.buf.format({ async = false })
end

map("n", "<leader>p", format_buffer)
map("n", "<leader>ca", vim.lsp.buf.code_action)
