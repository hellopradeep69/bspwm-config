return {
  -- Auto Pairs
  -- { "jiangmiao/auto-pairs" },

  -- Colorizer
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
}
