return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      ensure_installed = {
        "ts_ls",
        "eslint", -- eslint-lsp: ho tro flat config (eslint.config.mjs) san
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "lua_ls",
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
        "gopls",
        "rust_analyzer",
        "jsonls",
      },
      automatic_installation = true,
      -- QUAN TRONG: tat tu dong enable server.
      -- `handlers = {}` la option cua mason-lspconfig v1, da bi XOA o v2
      -- (ban dang dung v2) nen no bi bo qua am tham va moi server da cai
      -- deu bi vim.lsp.enable() tu dong. Option dung o v2 la automatic_enable.
      -- Viec setup server do lspconfig.lua tu lo.
      automatic_enable = false,
    })

    mason_tool_installer.setup({
      ensure_installed = {
        -- TypeScript / JS
        "prettier",
        -- eslint_d da bo: builtin cua no khong con trong none-ls,
        -- ESLint gio chay qua eslint-lsp
        -- Python
        "black",
        "isort",
        "pylint",
        -- Lua
        "stylua",
        -- Go
        "goimports",
        "gofumpt",
        "golangci-lint",
        -- Rust: rustfmt comes with rustup, not Mason
      },
    })
  end,
}
