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
vim.keymap.set("n", "<Leader>1", "1gt")
vim.keymap.set("n", "<Leader>2", "2gt")
vim.keymap.set("n", "<Leader>3", "3gt")
vim.keymap.set("n", "<Leader>4", "4gt")
vim.keymap.set("n", "<Leader>5", "5gt")
vim.keymap.set("n", "<Leader>6", "6gt")
vim.keymap.set("n", "<Leader>7", "7gt")
vim.keymap.set("n", "<Leader>8", "8gt")
vim.keymap.set("n", "<Leader>9", "9gt")

-- register hacks
vim.keymap.set("x", "<leader>y", [["+y]])
vim.keymap.set("x", "<Leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

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
vim.keymap.set("n", "<Leader>k", "<cmd>Man<CR>")

-- mov
vim.keymap.set("v", "<C-J>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-K>", ":m '<-2<CR>gv=gv")

-- remove trailing spaces
vim.api.nvim_create_user_command("RmTrailing", [[%s/\s\+$//e]], {})

-- step into file directory
vim.api.nvim_create_user_command("Step", function()
  local path = vim.fn.expand("%:p:h")
  vim.fn.chdir(path)
end, {})

-- wrap toggle
vim.keymap.set("n", "<Leader>gw", "<cmd>set wrap!<CR>")

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
