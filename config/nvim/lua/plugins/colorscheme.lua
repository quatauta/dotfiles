return {
  {
   -- "NLKNguyen/papercolor-theme",
   "arongp/PaperColor",
   lazy = false,
   priority = 1000,
   config = function()
     vim.g.PaperColor_Theme_Options = { theme = { default = { transparent_background = 0, }, }, }
   end,
  },

  { "LazyVim/LazyVim", opts = { colorscheme = "PaperColor" } },
}
