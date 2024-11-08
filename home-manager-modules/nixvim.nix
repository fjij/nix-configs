{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfgName = "nixvim";
  cfg = config.fjij.${cfgName};
  helpers = config.lib.nixvim;
in
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  options.fjij.${cfgName}.enable = lib.mkEnableOption cfgName;

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;

      colorschemes.catppuccin.enable = true;

      opts = {
        # Line Numbers
        number = true;
        relativenumber = true;

        # Columns
        colorcolumn = "81";
        wrap = false;

        # Tabs
        tabstop = 2;
        softtabstop = 2;
        shiftwidth = 2;
        autoindent = true;
        expandtab = true;

        # Disable Modelines
        modelines = 0;
        modeline = false;

        # Disable hidden
        hidden = false;

        # Disable mouse
        mouse = "";

        # Backups
        swapfile = false;
        backup = false;
        # undodir = os.getenv("HOME") .. "/.vim/undodir";
        undofile = true;

        # Sign column
        signcolumn = "yes:1";

        # Search
        incsearch = true;
        ignorecase = true;
        smartcase = true;

        # Block cursor
        guicursor = "";

        # Misc
        termguicolors = true;

        # Tabline - https://neovim.io/doc/user/options.html#'showtabline'
        showtabline = 1;

        # Splits
        splitright = true;
        splitbelow = true;

        # Folding
        # https://neovim.io/doc/user/fold.html
        foldlevelstart = 99; # start with all folds open
        foldmethod = "expr";
        foldexpr = "v:lua.vim.treesitter.foldexpr()";
      };

      globals.mapleader = " ";

      keymaps = let
        mkKeymap = mode: key: action: {
          inherit mode;
          inherit key;
          inherit action;
        };
        mkNormalMap = mkKeymap "n";
      in [
        # Windows
        (mkNormalMap "<leader>h" ":wincmd h<CR>")
        (mkNormalMap "<leader>j" ":wincmd j<CR>")
        (mkNormalMap "<leader>k" ":wincmd k<CR>")
        (mkNormalMap "<leader>l" ":wincmd l<CR>")
        (mkNormalMap "<leader>q" ":q<CR>")

        # Tabpages
        (mkNormalMap "<leader><S-tab>" ":tabprevious<CR>")
        (mkNormalMap "<leader><tab>" ":tabnext<CR>")
        (mkNormalMap "<leader>t" ":tabnew<CR>")

        # Misc
        (mkNormalMap "Q" "gq")

        # Plugins
        (mkNormalMap "<leader>pv" ":Neotree<CR>")
      ];


    autoCmd = let
      mkFunction = body: helpers.mkRaw ''
        function()
          ${body}
        end
      '';
      useSpaces = ft: n: {
        event = "FileType";
        pattern = [ ft ];
        callback = mkFunction ''
          vim.opt.tabstop = ${toString n}
          vim.opt.softtabstop = ${toString n}
          vim.opt.shiftwidth = ${toString n}
        '';
      };
      useTabs = ft: n: {
        event = "FileType";
        pattern = [ ft ];
        callback = mkFunction ''
          vim.opt.autoindent = true
          vim.opt.expandtab = false
          vim.opt.tabstop = ${toString n}
          vim.opt.shiftwidth = ${toString n}
        '';
      };
      in [
        (useSpaces "python" 4)
        (useSpaces "c" 4)
        (useSpaces "cpp" 4)
        (useSpaces "rust" 4)
        (useSpaces "sql" 4)
        (useSpaces "solidity" 4)
        (useSpaces "fish" 4)
        (useSpaces "bash" 4)
        (useSpaces "just" 4)
        (useSpaces "javascript" 2)
        (useSpaces "typescript" 2)
        (useSpaces "markdown" 2)
        (useSpaces "lua" 2)
        (useSpaces "json" 2)
        (useSpaces "yaml" 2)
        (useTabs "go" 4)
        (useTabs "make" 4)
      ];

      # Treesitter
      plugins.treesitter.enable = true;

      # LSP
      # https://nix-community.github.io/nixvim/plugins/lsp/index.html
      plugins.lsp = {
        enable = true;
        servers = {
          ts_ls.enable = true;
          lua_ls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          nixd.enable = true;
          basedpyright.enable = true;
        };
        keymaps.lspBuf = {
          "K" = "hover";
          "gd" = "definition";
          "gD" = "declaration";
          "gi" = "implementation";
          "go" = "type_definition";
          "gr" = "references";
          "gs" = "signature_help";
          "<F2>" = "rename";
          "<F3>" = "format";
          "<F4>" = "code_action";
        };
      };

      # Completions
      # https://nix-community.github.io/nixvim/plugins/cmp/settings/index.html
      plugins.cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        settings.mapping = {
          # "<CR>" = "cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace, select = true})";
          "<Down>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<Up>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        };
      };

      # Editor Plugins
      plugins.web-devicons.enable = true;
      plugins.neo-tree.enable = true;
      plugins.telescope = {
        enable = true;
        keymaps = {
          "<C-p>" = { action = "git_files"; };
          "<leader>ps" = { action = "live_grep"; };
        };
        settings.mappings.i."<Esc>" = helpers.mkRaw "require('telescope.actions').close";
      };
      plugins.gitsigns.enable = true;
      plugins.gitsigns.settings.linehl = true;
      plugins.lualine.enable = true;
      plugins.oil.enable = true;
      plugins.copilot-vim.enable = true;

      # Core Plugins
      plugins.fugitive.enable = true;
      extraPlugins = [
        pkgs.vimPlugins.vim-rhubarb
          (pkgs.vimUtils.buildVimPlugin {
           name = "vim-qfedit";
           src = pkgs.fetchFromGitHub {
             owner = "itchyny";
             repo = "vim-qfedit";
             rev = "9840120de9e9d6866541f2bcf048ba26a9b16806";
             hash = "sha256-4ifqqrx293+jPCnxA+nqOj7Whr2FkM+iuQ8ycxs55X0=";
           };
         })
      ];
      plugins.nvim-surround.enable = true;
      plugins.repeat.enable = true;
    };
  };
}
