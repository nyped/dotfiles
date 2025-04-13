-- terminals stuff
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = { "term://*" },
  command = "startinsert",
})
vim.api.nvim_create_autocmd("TermEnter", {
  pattern = { "*" },
  callback = function()
    vim.opt.spell = false
    vim.opt.cursorcolumn = false
    vim.opt.cursorline = false
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})
vim.api.nvim_create_autocmd("TermLeave", {
  pattern = { "*" },
  callback = function()
    vim.opt.spell = true
    vim.opt.cursorcolumn = true
    vim.opt.cursorline = true
    vim.opt.number = true
    vim.opt.relativenumber = true
  end,
})

-- theme update function
local update_bg = function()
  local user = vim.env.USER
  if not user then
    return
  end

  local theme = vim.fn.system({ "cat", "/home/" .. user .. "/.theme" })

  if theme ~= nil then
    theme = theme:gsub("\n", "")
  else
    theme = "dark"
  end

  vim.opt.background = theme
end

-- update theme on SIGUSR1
vim.api.nvim_create_autocmd("Signal", {
  pattern = { "SIGUSR1" },
  callback = update_bg,
  nested = true,
})

-- init theme
update_bg()
