return {
  "nvimtools/none-ls.nvim", -- configure formatters & linters
  -- Truoc day: lazy = true ma khong co event/ft/cmd nao va khong file nao
  -- require("null-ls") -> plugin KHONG BAO GIO duoc load, toan bo config nay chet.
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "jay-babu/mason-null-ls.nvim",
  },
  config = function()
    local mason_null_ls = require("mason-null-ls")

    local null_ls = require("null-ls")

    local null_ls_utils = require("null-ls.utils")

    mason_null_ls.setup({
      ensure_installed = {
        "prettier",
        "stylua",
        "black",
        "isort",
        "pylint",
        "goimports",
        "gofumpt",
        "golangci_lint",
        -- rustfmt comes with rustup, not Mason
      },
    })

    -- for conciseness
    local formatting = null_ls.builtins.formatting -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters

    -- to setup format on save
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    -- configure null_ls
    null_ls.setup({
      -- add package.json as identifier for root (for typescript monorepos)
      root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
      -- setup formatters & linters
      sources = {
        -- TypeScript / JS
        formatting.prettier.with({ extra_filetypes = { "svelte" } }),
        -- ESLint da BO khoi day: builtin `diagnostics.eslint_d` khong con ton tai
        -- trong none-ls (da tach sang repo none-ls-extras). Goi .with() tren nil
        -- lam ca null_ls.setup() chet -> mat luon prettier.
        -- ESLint gio do eslint-lsp lo (xem lspconfig.lua) - ho tro flat config san.
        -- Lua
        formatting.stylua,
        -- Python
        formatting.isort,
        formatting.black,
        diagnostics.pylint,
        -- Go
        formatting.goimports,
        formatting.gofumpt,
        diagnostics.golangci_lint,
        -- Rust
        formatting.rustfmt,
      },
      -- configure format on save
      on_attach = function(current_client, bufnr)
        -- dang colon: supports_method la method cua Client tu Neovim 0.11
        if current_client:supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                filter = function(client)
                  --  only use null-ls for formatting instead of lsp server
                  return client.name == "null-ls"
                end,
                bufnr = bufnr,
              })
            end,
          })
        end
      end,
    })
  end,
}
