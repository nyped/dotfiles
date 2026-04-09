-- Tests for ts_surfer
-- Run with: nvim --headless -u ~/.config/nvim/init.lua -c "luafile lua/local/ts_surfer/tests/ts_surfer_spec.lua" -c "qa!"

local passed = 0
local failed = 0

local function ok(cond, msg)
  if cond then
    print("PASS: " .. msg)
    passed = passed + 1
  else
    print("FAIL: " .. msg)
    failed = failed + 1
  end
end

local function eq(a, b, msg)
  if a == b then
    print("PASS: " .. msg)
    passed = passed + 1
  else
    print(string.format("FAIL: %s\n  expected: %s\n  got: %s", msg, vim.inspect(b), vim.inspect(a)))
    failed = failed + 1
  end
end

-- Setup a scratch buffer with lua content
local function make_buf(lines, ft)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = ft or "lua"
  -- ensure parser is ready
  vim.treesitter.get_parser(buf, ft or "lua"):parse()
  return buf
end

local surfer = require("local.ts_surfer")

-- ── get_master_node ────────────────────────────────────────────────────────────

do
  local buf = make_buf({
    "local function foo()",
    "  return 1",
    "end",
  })
  vim.api.nvim_set_current_buf(buf)
  vim.api.nvim_win_set_cursor(0, { 2, 9 }) -- on "1"

  local leaf = surfer._get_named_node_at_cursor()
  ok(leaf ~= nil, "get_named_node_at_cursor returns a node")

  local master = surfer._get_master_node(leaf)
  ok(master ~= nil, "get_master_node returns a node")

  -- master should have no grandparent (direct child of root)
  local parent = master:parent()
  ok(parent == nil or parent:parent() == nil, "master node is direct child of root")

  -- master should contain the cursor position
  local sr, _, er, _ = master:range()
  ok(sr <= 1 and er >= 1, "master node spans the cursor line") -- 0-indexed
end

-- ── sibling navigation ─────────────────────────────────────────────────────────

do
  local buf = make_buf({
    "local x = 1",
    "local y = 2",
    "local z = 3",
  })
  vim.api.nvim_set_current_buf(buf)
  vim.api.nvim_win_set_cursor(0, { 1, 6 }) -- on "x"

  local node = surfer._get_named_node_at_cursor()
  ok(node ~= nil, "sibling test: found node at cursor")

  local master = surfer._get_master_node(node)
  local next = master:next_named_sibling()
  ok(next ~= nil, "next named sibling exists")

  local prev = next:prev_named_sibling()
  ok(prev ~= nil, "prev named sibling exists")

  local sr_orig, sc_orig = master:range()
  local sr_prev, sc_prev = prev:range()
  eq(sr_orig, sr_prev, "prev of next is the original node (same row)")
  eq(sc_orig, sc_prev, "prev of next is the original node (same col)")
end

-- ── swap_nodes ────────────────────────────────────────────────────────────────

do
  local buf = make_buf({
    "local a = 1",
    "local b = 2",
  })
  vim.api.nvim_set_current_buf(buf)
  vim.treesitter.get_parser(buf, "lua"):parse()

  vim.api.nvim_win_set_cursor(0, { 1, 6 })
  local node_a = surfer._get_master_node(surfer._get_named_node_at_cursor())
  local node_b = node_a:next_named_sibling()
  ok(node_b ~= nil, "swap test: second statement found")

  surfer._swap_nodes(node_a, node_b)

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  eq(lines[1], "local b = 2", "swap: first line is now b")
  eq(lines[2], "local a = 1", "swap: second line is now a")
end

-- ── parent / child ────────────────────────────────────────────────────────────

do
  local buf = make_buf({
    "local function foo()",
    "  local x = 1",
    "end",
  })
  vim.api.nvim_set_current_buf(buf)
  vim.api.nvim_win_set_cursor(0, { 2, 8 }) -- on "x"

  local node = surfer._get_named_node_at_cursor()
  ok(node ~= nil, "child test: found node")

  local parent = node:parent()
  ok(parent ~= nil, "parent exists")

  -- child of parent should include original node position
  local child = parent:named_child(0)
  ok(child ~= nil, "parent has a named child")

  local sr_n, sc_n = node:range()
  local sr_p, sc_p = parent:range()
  ok(sr_p <= sr_n, "parent starts at or before child")
end

-- ── summary ───────────────────────────────────────────────────────────────────

print(string.format("\n%d passed, %d failed", passed, failed))
if failed > 0 then
  vim.cmd("cq 1")
end
