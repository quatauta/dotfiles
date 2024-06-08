-- https://github.com/f-person/auto-dark-mode.nvim
--
-- Detect the terminal background periodically every second.
-- Set global option background to light or dark accordingly.
-- Set a specific colorscheme for light or dark background.
return {
  "f-person/auto-dark-mode.nvim",
  opts = {
    update_interval = 1000,
    set_dark_mode = function()
      vim.api.nvim_set_option_value("background", "dark", { scope = "global" })
    end,
    set_light_mode = function()
      vim.api.nvim_set_option_value("background", "light", { scope = "global" })
    end,
  },
}
