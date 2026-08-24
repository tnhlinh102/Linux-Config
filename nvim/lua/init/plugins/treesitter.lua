return {
  "nvim-treesitter/nvim-treesitter",
  -- Ghim branch master: config bên dưới dùng API của master.
  -- Branch main la ban viet lai, TSConfig cua no chi nhan install_dir
  -- nen ensure_installed/highlight se bi bo qua am tham.
  branch = "master",
  main = "nvim-treesitter.configs",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    ensure_installed = {
      -- Frontend (giai doan 1)
      "tsx", "typescript", "javascript", "jsdoc",
      "html", "css", "json", "jsonc",
      "svelte", "graphql", "prisma",
      -- Backend / hien tai
      "python", "go", "gomod", "gosum", "gowork",
      "rust", "toml",
      -- Ha tang / khac
      "yaml", "bash", "dockerfile", "gitignore",
      "markdown", "markdown_inline",
      "lua", "luadoc", "vim", "vimdoc", "query",
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        node_decremental = "<BS>",
      },
    },
  },
}
