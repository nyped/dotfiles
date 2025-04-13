-- leader
vim.g.mapleader = " "

-- escape in terminal mode
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

-- Quick move in terminal mode
vim.keymap.set("t", "<C-w>w", [[<C-\><C-n><C-w>w]])

-- don't paste in normal mode
vim.keymap.set("n", "<MiddleMouse>", "<Nop>")

-- bad habits
vim.keymap.set("n", "<BS>", "g<Tab>")

-- add lines
vim.keymap.set("n", "O", "O<Esc>")
vim.keymap.set("n", "o", "o<Esc>")

-- switching tabs with <Tab> while keeping <C-I>
vim.keymap.set("n", "<C-I>", "<C-I>")
vim.keymap.set("n", "<S-Tab>", "gT")
vim.keymap.set("n", "<Tab>", "gt")

-- switch windows
for i = 1, 9 do
  local t = tostring(i)
  vim.keymap.set("n", "<Leader>" .. t, t .. "gt", { desc = "Focus tab #" .. t })
end
vim.keymap.set("n", "<Leader>0", "<cmd>tabl<CR>", { desc = "Focus last tab" })

-- register hacks
vim.keymap.set("x", "<leader>y", [["+y]], { desc = "Copy to clipboard" })
vim.keymap.set("x", "<Leader>p", [["_dP]], { desc = "Paste from clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], {
  desc = "delete (keep register)",
})

-- to work faster
vim.api.nvim_create_user_command("E", "edit", {})
vim.api.nvim_create_user_command("Nt", "tabnew", {})
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("Qa", "qa", {})
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("Wqa", "wqa", {})

-- man
vim.keymap.set("n", "<Leader>k", "<cmd>Man<CR>", { desc = "Open manual" })

-- mov
vim.keymap.set("v", "<C-J>", ":m '>+1<CR>gv=gv", { desc = "Move sel. down" })
vim.keymap.set("v", "<C-K>", ":m '<-2<CR>gv=gv", { desc = "Move sel. up" })

-- remove trailing spaces
vim.api.nvim_create_user_command("RmTrailing", [[%s/\s\+$//e]], {})

-- step into file directory
vim.api.nvim_create_user_command("Step", function()
  local path = vim.fn.expand("%:p:h")
  vim.fn.chdir(path)
end, {})

-- wrap toggle
vim.keymap.set("n", "<Leader>gw", "<cmd>set wrap!<CR>", { desc = "Wrap text" })

-- template {{{
vim.api.nvim_create_user_command("Tpl", function(opts)
  local empty_buf = vim.fn.line("$") == 1
    and vim.api.nvim_get_current_line():len() == 0
  local prefix = ""

  if opts.range ~= 0 then
    prefix = [['<.'>]]
  elseif opts.bang or empty_buf then
    prefix = "%"
  end

  vim.cmd(prefix .. "!tpl " .. tostring(opts.args))
end, {
  bang = true,
  desc = "Tpl: template creator",
  nargs = 1,
  range = true,
  complete = function(cmd)
    local ret = {}
    local tmp_ft =
      vim.split(vim.fn.system({ "tpl", "--list" }), "\n", { trimempty = true })

    for _, value in ipairs(tmp_ft) do
      if string.find(value, cmd) then
        table.insert(ret, value)
      end
    end

    return ret
  end,
})
-- }}}
