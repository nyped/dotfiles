local M = {}

local current_node = nil

local function get_named_node_at_cursor(buf)
  local node = vim.treesitter.get_node({ bufnr = buf })
  while node and not node:named() do
    node = node:parent()
  end
  return node
end

local function get_master_node(node)
  local parent = node:parent()
  if not parent or not parent:parent() then
    return node
  end
  return get_master_node(parent)
end

local function select_node(node)
  if not node then return end
  local sr, sc, er, ec = node:range()
  -- tree-sitter end is exclusive; adjust to vim's inclusive end
  if ec == 0 then
    er = er - 1
    local line = vim.api.nvim_buf_get_lines(0, er, er + 1, true)[1] or ""
    ec = #line - 1
  else
    ec = ec - 1
  end
  ec = math.max(ec, 0)

  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "x", false)
  vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
  vim.api.nvim_feedkeys("v", "x", false)
  vim.api.nvim_win_set_cursor(0, { er + 1, ec })
end

function M.select_master_node()
  local node = get_named_node_at_cursor()
  if not node then return end
  current_node = get_master_node(node)
  select_node(current_node)
end

function M.select_current_node()
  local node = get_named_node_at_cursor()
  if not node then return end
  current_node = node
  select_node(current_node)
end

function M.select_next_sibling()
  if not current_node then return end
  local next = current_node:next_named_sibling()
  if next then
    current_node = next
    select_node(current_node)
  end
end

function M.select_prev_sibling()
  if not current_node then return end
  local prev = current_node:prev_named_sibling()
  if prev then
    current_node = prev
    select_node(current_node)
  end
end

function M.select_parent()
  if not current_node then return end
  local parent = current_node:parent()
  -- don't select the root (unnamed document node)
  if parent and parent:parent() then
    current_node = parent
    select_node(current_node)
  end
end

function M.select_child()
  if not current_node then return end
  local child = current_node:named_child(0)
  if child then
    current_node = child
    select_node(current_node)
  end
end

local function swap_nodes(a, b)
  local buf = vim.api.nvim_get_current_buf()
  local sr_a, sc_a, er_a, ec_a = a:range()
  local sr_b, sc_b, er_b, ec_b = b:range()

  -- ensure a is before b
  if sr_a > sr_b or (sr_a == sr_b and sc_a > sc_b) then
    a, b = b, a
    sr_a, sc_a, er_a, ec_a = a:range()
    sr_b, sc_b, er_b, ec_b = b:range()
  end

  local text_a = vim.api.nvim_buf_get_text(buf, sr_a, sc_a, er_a, ec_a, {})
  local text_b = vim.api.nvim_buf_get_text(buf, sr_b, sc_b, er_b, ec_b, {})

  -- replace later node first to keep positions valid
  vim.api.nvim_buf_set_text(buf, sr_b, sc_b, er_b, ec_b, text_a)
  vim.api.nvim_buf_set_text(buf, sr_a, sc_a, er_a, ec_a, text_b)
end

local function swap_and_reselect(sibling)
  local target_type = current_node:type()
  local sib_sr, sib_sc = sibling:range()
  swap_nodes(current_node, sibling)
  vim.schedule(function()
    -- current_node's text landed at sibling's old start; find the node there
    -- with the same type, walking up from the leaf
    local node = vim.treesitter.get_node({ pos = { sib_sr, sib_sc } })
    while node and not node:named() do
      node = node:parent()
    end
    while node and node:type() ~= target_type and node:parent() and node:parent():parent() do
      node = node:parent()
    end
    current_node = node
    select_node(current_node)
  end)
end

function M.swap_next()
  if not current_node then return end
  local next = current_node:next_named_sibling()
  if not next then return end
  swap_and_reselect(next)
end

function M.swap_prev()
  if not current_node then return end
  local prev = current_node:prev_named_sibling()
  if not prev then return end
  swap_and_reselect(prev)
end

function M.setup()
  vim.keymap.set("n", "vx", M.select_master_node,  { noremap = true, silent = true, desc = "TSsurf select master node" })
  vim.keymap.set("n", "vn", M.select_current_node, { noremap = true, silent = true, desc = "TSsurf select current node" })
  vim.keymap.set("x", "J",    M.select_next_sibling, { noremap = true, silent = true, desc = "TSsurf next sibling" })
  vim.keymap.set("x", "K",    M.select_prev_sibling, { noremap = true, silent = true, desc = "TSsurf prev sibling" })
  vim.keymap.set("x", "H",    M.select_parent,       { noremap = true, silent = true, desc = "TSsurf parent node" })
  vim.keymap.set("x", "L",    M.select_child,        { noremap = true, silent = true, desc = "TSsurf child node" })
  vim.keymap.set("x", "<A-j>", M.swap_next,          { noremap = true, silent = true, desc = "TSsurf swap next" })
  vim.keymap.set("x", "<A-k>", M.swap_prev,          { noremap = true, silent = true, desc = "TSsurf swap prev" })
end

-- exposed for testing
M._get_named_node_at_cursor = get_named_node_at_cursor
M._get_master_node = get_master_node
M._swap_nodes = swap_nodes

return M
