-- Branch `main` (ban viet lai). Yeu cau: Neovim >= 0.12, tree-sitter-cli >= 0.26.1.
-- Khac branch `master` o ba diem:
--   1. setup() chi nhan `install_dir`, khong co ensure_installed/highlight/indent
--   2. Parser cai bang require("nvim-treesitter").install(), khong phai opts
--   3. Highlight va indent PHAI tu bat trong autocmd FileType
local LANGS = {
  -- Frontend (giai doan 1 roadmap)
  "tsx", "typescript", "javascript", "jsdoc",
  "html", "css", "json", -- branch main khong co parser `jsonc`, dung `json`
  "svelte", "graphql", "prisma",
  -- Backend
  "python", "go", "gomod", "gosum", "gowork",
  "rust", "toml",
  -- Ha tang / khac
  "yaml", "bash", "dockerfile", "gitignore",
  "markdown", "markdown_inline",
  "lua", "luadoc", "vim", "vimdoc", "query",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- branch main khuyen nghi khong lazy load
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- no-op neu parser da co
    require("nvim-treesitter").install(LANGS)

    -- branch main bo parser `jsonc`; dung parser `json` cho filetype jsonc
    -- (tsconfig.json cua TypeScript la jsonc - co comment)
    vim.treesitter.language.register("json", { "jsonc" })

    -- Bat highlight + indent. Khong liet ke filetype thu cong: ten parser khac
    -- ten filetype (parser "tsx" <-> filetype "typescriptreact"), viet tay danh
    -- sach do la nguon loi kinh dien. Dung get_lang() de tu map.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
      callback = function(ev)
        local ft = vim.bo[ev.buf].filetype
        if ft == "" then
          return
        end
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
          return
        end
        -- pcall: filetype nao chua co parser thi bo qua im lang
        if pcall(vim.treesitter.start, ev.buf, lang) then
          -- chu y dau nhay: nhay don ben trong nhay kep
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
