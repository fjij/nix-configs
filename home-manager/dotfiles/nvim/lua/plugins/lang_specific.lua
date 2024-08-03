return {
  {
    "hashivim/vim-terraform",
    ft = "terraform",
  },
  {
    "dag/vim-fish",
    ft = "fish",
  },
  {
    "lifepillar/pgsql.vim",
    ft = "sql",
    config = function()
      vim.g.sql_type_default = "pgsql"
    end,
  },
  {
    "evanleck/vim-svelte",
    ft = "svelte",
  },
  {
    "jvirtanen/vim-hcl",
    ft = "hcl",
  },
  {
    "NoahTheDuke/vim-just",
    ft = "just",
  },
}
