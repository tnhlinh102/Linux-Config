return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  opts = {
    ensure_installed = {
      "json", "javascript", "typescript", "tsx", "yaml",
      "html", "css", "prisma", "markdown", "markdown_inline",
      "svelte", "graphql", "bash", "lua", "vim", "vimdoc",
      "dockerfile", "gitignore", "query",
      "python",
      "go", "gomod", "gosum", "gowork",
      "rust", "toml",
    },
    auto_install = true,
  },
}
