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
        foldtext = "v:lua.my_fold_text()";
      };
      extraConfigLua = ''
        function _G.my_fold_text()
          local a = vim.fn.getline(vim.v.foldstart)
          local b = vim.fn.getline(vim.v.foldend):gsub("^%s*(.-)%s*$", "%1")
          return a .. " ... " .. b
        end
      '';

      # Only show LSP messages for current line
      diagnostics = {
        virtual_lines.only_current_line = true;
        virtual_text = false;
      };

      globals.mapleader = " ";

      keymaps =
        let
          mkKeymap = mode: key: action: {
            inherit mode;
            inherit key;
            inherit action;
          };
          mkNormalMap = mkKeymap "n";
        in
        [
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

      autoCmd =
        let
          mkFunction =
            body:
            helpers.mkRaw ''
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
        in
        [
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

          # Writing mode
          {
            event = "FileType";
            pattern = [
              "markdown"
              "text"
            ];
            callback = mkFunction ''
              vim.opt_local.textwidth = 80
              vim.opt_local.spell = true
            '';
          }
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
          basedpyright = {
            enable = true;
            settings.python.pythonPath = helpers.mkRaw "vim.fn.exepath(\"python\")";
          };
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
        keymaps.diagnostic."gl" = "open_float";
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
          "<Down>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<Up>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          # Need this to confirm auto import
          "<CR>" = "cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace, select = true})";
        };
        filetype = {
          # Writing mode
          markdown.sources = [ { name = "path"; } ];
          text.sources = [ { name = "path"; } ];
        };
      };

      # Editor Plugins
      plugins.web-devicons.enable = true;
      plugins.neo-tree.enable = true;
      plugins.telescope = {
        enable = true;
        keymaps = {
          "<C-p>" = {
            action = "git_files";
          };
          "<leader>ps" = {
            action = "live_grep";
          };
        };
        settings.mappings.i."<Esc>" = helpers.mkRaw "require('telescope.actions').close";
      };
      plugins.gitsigns.enable = true;
      plugins.gitsigns.settings.linehl = true;
      plugins.lualine.enable = true;
      plugins.oil.enable = true;
      plugins.copilot-vim.enable = true;
      plugins.zen-mode = {
        enable = true;
        settings.window = {
          backdrop = 0.8;
          width = 100;
          height = 0.8;
          options = {
            signcolumn = "no";
            number = false;
            relativenumber = false;
            cursorline = false;
            cursorcolumn = false;
          };
        };
        settings.plugins = {
          options = {
            enabled = true;
            ruler = false;
            showcmd = false;
            laststatus = 0;
          };
          tmux.enabled = true;
          gitsigns.enabled = true;
        };
      };

      plugins.fugitive.enable = true;
      plugins.nvim-surround.enable = true;
      plugins.repeat.enable = true;
      extraPlugins =
        (with pkgs.vimPlugins; [
          vim-rhubarb
          vim-terraform
          vim-hcl
          vim-just
          vim-elixir
          vim-svelte
          vim-fish
        ])
        ++ (with pkgs.vimUtils; [
          (buildVimPlugin {
            name = "vim-qfedit";
            src = pkgs.fetchFromGitHub {
              owner = "itchyny";
              repo = "vim-qfedit";
              rev = "9840120de9e9d6866541f2bcf048ba26a9b16806";
              hash = "sha256-4ifqqrx293+jPCnxA+nqOj7Whr2FkM+iuQ8ycxs55X0=";
            };
          })
          (buildVimPlugin {
            name = "deadcolumn.nvim";
            src = pkgs.fetchFromGitHub {
              owner = "Bekaboo";
              repo = "deadcolumn.nvim";
              rev = "897c905aef1a268ce4cc507d5cce048ed808fa7a";
              hash = "sha256-cb4Cufldhk0Fv6mlOw1kcd0A85xu+i2U393G64iPkfc=";
            };
          })
          (buildVimPlugin {
            name = "pgsql.vim";
            src = pkgs.fetchFromGitHub {
              owner = "lifepillar";
              repo = "pgsql.vim";
              rev = "736c9899163a7f4e212c1675d8a1fe42570a027a";
              hash = "sha256-XMv3cU73X5TtAfCHexlIWWcMcHoiJcGMCsw1ZuWV6Xw=";
            };
          })
        ]);
      # Use pgsql hilighting for all sql files
      globals.sql_type_default = "pgsql";
    };
  };
}
