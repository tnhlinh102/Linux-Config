-- Tu dong dong the JSX/HTML. Truoc day khai bao lam dependency dang string tran
-- cua nvim-treesitter nen lazy load nhung khong ai goi setup() -> khong hoat dong.
return {
  "windwp/nvim-ts-autotag",
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
}
