return {
  { -- https://github.com/VonHeikemen/lsp-zero.nvim
    "VonHeikemen/lsp-zero.nvim",
    event = { "BufReadPre", "BufNewFile" },
    branch = "v3.x",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" }, -- Required
      { "williamboman/mason.nvim" }, -- Optional
      { "williamboman/mason-lspconfig.nvim" }, -- Optional
      -- Autocompletion
      {
        "hrsh7th/nvim-cmp",
        -- commit = "b356f2c", -- FIXME: typst
        pin = true,
      }, -- Required
      { "hrsh7th/cmp-nvim-lsp" }, -- Required
      { "L3MON4D3/LuaSnip" }, -- Required
      { "ray-x/lsp_signature.nvim" }, -- Required
    },
    config = function()
      -- lsp {{{
      -- no logs, enable it when you are debugging
      vim.lsp.set_log_level("OFF")

      local lsp_zero = require("lsp-zero").preset({})

      -- setting our keybindings
      lsp_zero.on_attach(function(_, b)
        -- Signature
        require("lsp_signature").on_attach({ hint_enable = false }, b)

        -- see :help lsp-zero-keybindings
        vim.keymap.set("n", "gD", function()
          vim.lsp.buf.declaration({ reuse_win = true })
        end, { buffer = b, remap = false, desc = "lsp go declaration" })

        vim.keymap.set("n", "gi", function()
          vim.lsp.buf.implementation({ reuse_win = true })
        end, {
          buffer = b,
          remap = false,
          desc = "lsp go implementation",
        })

        vim.keymap.set("n", "gd", function()
          vim.lsp.buf.definition({ reuse_win = true })
        end, { buffer = b, remap = false, desc = "lsp go definition" })

        -- vim.keymap.set("n", "<Leader>bf", function()
        -- 	vim.lsp.buf.format()
        -- end, { buffer = b, remap = false, desc = "lsp buffer format" })

        vim.keymap.set("n", "K", function()
          vim.lsp.buf.hover()
        end, { buffer = b, remap = false, desc = "lsp buffer hover" })

        vim.keymap.set("n", "<Leader>vws", function()
          vim.ui.input(
            { prompt = "Symbol to find: " },
            vim.lsp.buf.workspace_symbol
          )
        end, {
          buffer = b,
          remap = false,
          desc = "lsp view workspace symbol",
        })

        vim.keymap.set("n", "<Leader>vd", function()
          vim.diagnostic.open_float()
        end, {
          buffer = b,
          remap = false,
          desc = "lsp view diagnostic (float)",
        })

        vim.keymap.set("n", "]d", function()
          vim.diagnostic.goto_next()
        end, {
          buffer = b,
          remap = false,
          desc = "lsp go next diagnostic",
        })

        vim.keymap.set("n", "[d", function()
          vim.diagnostic.goto_prev()
        end, {
          buffer = b,
          remap = false,
          desc = "lsp go prev diagnostic",
        })

        vim.keymap.set("n", "<Leader>vca", function()
          vim.lsp.buf.code_action()
        end, { buffer = b, remap = false, desc = "lsp view code action" })

        vim.keymap.set("n", "<Leader>vrr", function()
          vim.lsp.buf.references()
        end, { buffer = b, remap = false, desc = "lsp view references" })

        vim.keymap.set("n", "<Leader>vrn", function()
          vim.lsp.buf.rename()
        end, {
          buffer = b,
          remap = false,
          desc = "lsp rename references",
        })

        vim.keymap.set("i", "<C-h>", function()
          vim.lsp.buf.signature_help()
        end, { buffer = b, remap = false, desc = "lsp signature help" })
      end)

      -- When you don't have mason.nvim installed
      -- You'll need to list the servers installed in your system
      -- see :lspconfig-all
      lsp_zero.setup_servers({
        "bashls",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "ts_ls",
        "gopls",
      })

      -- clangd
      local clang_caps = lsp_zero.get_capabilities()
      clang_caps.offsetEncoding = { "utf-16" }
      require("lspconfig").clangd.setup({
        capabilities = clang_caps,
      })

      -- Mason stuff
      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = {
          "golangci_lint_ls",
          "jdtls",
          "tinymist",
        },
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require("lspconfig").lua_ls.setup(lua_opts)
          end,
          tinymist = function()
            require("lspconfig").tinymist.setup({
              root_dir = vim.fn.getcwd(),
              offset_encoding = "utf-16",
              settings = {
                exportPdf = "onSave",
                outputPath = "$root/$dir/$name",
              },
            })
          end,
        },
      })

      lsp_zero.setup()
      -- }}}

      -- cmp {{{
      lsp_zero.extend_cmp()

      local cmp = require("cmp")
      local cmp_action = require("lsp-zero").cmp_action()

      cmp.setup({
        -- completion = { autocomplete = false },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-f>"] = cmp_action.luasnip_jump_forward(),
          ["<C-b>"] = cmp_action.luasnip_jump_backward(),
          ["<A-f>"] = cmp_action.luasnip_jump_forward(),
          ["<A-b>"] = cmp_action.luasnip_jump_backward(),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
      })
      -- }}}
    end,
  },
  { -- https://github.com/folke/neodev.nvim
    "folke/neodev.nvim",
    opts = {},
  },
  { -- https://github.com/barreiroleo/ltex_extra.nvim
    "barreiroleo/ltex_extra.nvim",
    enabled = true,
    ft = { "markdown" },
    dependencies = { "VonHeikemen/lsp-zero.nvim" },
    config = function()
      local lsp_zero = require("lsp-zero").preset({})

      require("ltex_extra").setup({
        load_langs = { "fr", "en-US" },
        log_level = "none",
        path = vim.fn.stdpath("config") .. "/spell/",
        server_opts = {
          on_attach = lsp_zero.on_attach,
          filetypes = { "markdown" },
        },
      })
    end,
  },
  { -- https://github.com/rmagatti/goto-preview
    "rmagatti/goto-preview",
    config = true,
    keys = {
      {
        "gpd",
        function()
          require("goto-preview").goto_preview_definition()
        end,
        desc = "Go preview definition lsp",
      },
      {
        "gpD",
        function()
          require("goto-preview").goto_preview_declaration()
        end,
        desc = "Go preview declaration lsp",
      },
      {
        "gpi",
        function()
          require("goto-preview").goto_preview_implementation()
        end,
        desc = "Go preview implementation lsp",
      },
      {
        "gpr",
        function()
          require("goto-preview").goto_preview_references()
        end,
        desc = "Go preview references lsp",
      },
    },
  },
}
