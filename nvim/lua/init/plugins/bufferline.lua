
return {
  "akinsho/bufferline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "kyoz/ezbuf.vim",
  },
  version = "*",
  opts = {
    options = {
      separator_style = "slant",
      show_close_icon = false,
      diagnostics = 'nvim_lsp',
      max_prefix_length = 8,
    },
    highlights = {
      buffer_selected = { bold = true },
      diagnostic_selected = { bold = true },
      info_selected = { bold = true },
      info_diagnostic_selected = { bold = true },
      warning_selected = { bold = true },
      warning_diagnostic_selected = { bold = true },
      error_selected = { bold = true },
      error_diagnostic_selected = { bold = true },
    },
  },
}
