return {
  { -- https://github.com/nvim-treesitter/nvim-treesitter
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = { "BufReadPre", "BufNewFile" },
    main = "nvim-treesitter",
    init = function()
      local ensure_installed = {
        "bash", -- parsers {{{
        "bibtex",
        "c",
        "cmake",
        "cpp",
        "css",
        "cuda",
        "diff",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "go",
        "groovy",
        "html",
        "ini",
        "java",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "markdown_inline",
        "nix",
        "ocaml",
        "python",
        "r",
        "regex",
        "rust",
        "toml",
        "typescript",
        "typst",
        "vim",
        "vimdoc",
        "yaml",
        -- }}}
      }
      local already_installed = require("nvim-treesitter.config").get_installed()
      local to_install = vim.iter(ensure_installed)
          :filter(function(p) return not vim.tbl_contains(already_installed, p) end)
          :totable()
      if #to_install > 0 then
        require("nvim-treesitter").install(to_install)
      end

      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          vim.wo.foldexpr = "v:lua.require'nvim-treesitter'.foldexpr()"
        end,
      })
    end,
    config = function()
      require("nvim-treesitter").setup()
    end,
  },
}
