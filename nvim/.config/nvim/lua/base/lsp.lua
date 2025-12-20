-- no logs, enable it when you are debugging
vim.lsp.set_log_level("OFF")

-- Virtual text on the current line
vim.diagnostic.config({
  virtual_lines = {
    current_line = true,
  },
})

-- Table of all the lsp to setup {{{
-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp
local servers = { --
  "lua_ls",
  "clangd",
  "pyright",
  "nil_ls",
  "ruff",
  "bashls",
  "rust_analyzer",
  "gopls",
}

vim.lsp.enable(servers)
-- }}}

-- https://neovim.io/doc/user/lsp.html#lsp-attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp", {}),
  callback = function(args)
    local c = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local b = args.buf

    -- Auto format
    if
        not c:supports_method("textDocument/willSaveWaitUntil")
        and c:supports_method("textDocument/formatting")
        and vim.env._NVIM_NO_AUTOFORMAT == nil
    then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
        buffer = b,
        callback = function()
          vim.lsp.buf.format({
            bufnr = b,
            id = c.id,
            timeout_ms = 1000,
          })
        end,
      })
    end

    -- Inlay hint
    if c:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.bufnr })

      vim.keymap.set("n", "<Leader>th", function()
        local status = vim.lsp.inlay_hint.is_enabled()
        vim.lsp.inlay_hint.enable(not status)
      end, { buffer = b, desc = "lsp toggle inlay hint" })
    end

    -- Keybinds {{{
    -- Symbols
    vim.keymap.set("n", "<Leader>vws", function()
      vim.ui.input(
        { prompt = "Symbol to find: " },
        vim.lsp.buf.workspace_symbol
      )
    end, { buffer = b, remap = false, desc = "lsp view workspace symbol" })

    vim.keymap.set("n", "<Leader>vrr", function()
      vim.lsp.buf.references()
    end, { buffer = b, remap = false, desc = "lsp view references" })

    vim.keymap.set("n", "<Leader>vd", function()
      vim.diagnostic.open_float()
    end, { buffer = b, remap = false, desc = "lsp view diagnostic (float)" })

    vim.keymap.set("n", "<Leader>vrn", function()
      vim.lsp.buf.rename()
    end, { buffer = b, remap = false, desc = "lsp rename references" })

    -- Diagnostic
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, { buffer = b, remap = false, desc = "lsp go next diagnostic" })

    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, { buffer = b, remap = false, desc = "lsp go prev diagnostic" })

    -- Actions
    vim.keymap.set("n", "<Leader>vca", function()
      vim.lsp.buf.code_action()
    end, { buffer = b, remap = false, desc = "lsp view code action" })

    -- Calls
    vim.keymap.set("n", "<Leader>vic", function()
      vim.lsp.buf.incoming_calls()
    end, { buffer = b, remap = false, desc = "lsp view incoming calls" })

    vim.keymap.set("n", "<Leader>voc", function()
      vim.lsp.buf.outgoing_calls()
    end, { buffer = b, remap = false, desc = "lsp view outgoing calls" })

    -- Definition
    vim.keymap.set("n", "gD", function()
      vim.lsp.buf.declaration({ reuse_win = true })
    end, { buffer = b, remap = false, desc = "lsp go declaration" })

    vim.keymap.set("n", "gd", function()
      vim.lsp.buf.definition({ reuse_win = true })
    end, { buffer = b, remap = false, desc = "lsp go definition" })

    vim.keymap.set("n", "gi", function()
      vim.lsp.buf.implementation({ reuse_win = true })
    end, { buffer = b, remap = false, desc = "lsp go implementation" })
    -- }}}
  end,
})
