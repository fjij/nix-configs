return {
  "Bekaboo/deadcolumn.nvim",
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup()
      vim.cmd("colorscheme kanagawa")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<C-p>", ":Telescope find_files<cr>", desc = "Find files" },
      { "<leader>ps", ":Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>b", ":Telescope buffers<cr>", desc = "Live grep" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = require("telescope.actions").close,
              ["<CR>"] = function()
                -- treesitter fold fix
                -- https://github.com/nvim-telescope/telescope.nvim/issues/559#issuecomment-1195895807
                vim.cmd([[:stopinsert]])
                vim.cmd([[call feedkeys("\<CR>")]])
              end,
            },
          },
        },
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = { { "<leader>pv", "<cmd>Neotree<cr>", desc = "Neotree" } },
  },
  {
    "pocco81/true-zen.nvim",
    opts = {
      modes = {
        ataraxis = {
          minimum_writing_area = {
            width = 88,
          },
        },
      },
      integrations = {
        tmux = true,
        lualine = true,
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      linehl = true,
    },
  },
}
