{ pkgs, lib, fff-nvim, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  config.vim = {
    viAlias = false;
    vimAlias = true;

    globals = {
      mapleader = " ";
    };

    opts = {
      number = true;
    };

    diagnostics = {
      config = {
        virtual_text = false;
        virtual_lines = false;
        signs = true;
        underline = true;
        update_in_insert = true;
        severity_sort = true;
      };
    };

    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
      transparent = false;
    };

    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      bash.enable = true;
      clang.enable = true;
      cmake.enable = true;
      css.enable = true;
      dart.enable = true;
      go.enable = true;
      html.enable = true;
      json.enable = true;
      lua.enable = true;
      markdown.enable = true;
      nix.enable = true;
      odin.enable = true;
      php.enable = true;
      qml.enable = true;
      rust.enable = true;
      toml.enable = true;
      tsx.enable = true;
      typescript.enable = true;
      yaml.enable = true;
    };

    lsp = {
      enable = true;
      formatOnSave = true;
      trouble.enable = true;

      servers = {
        clangd = {
          cmd = lib.mkForce [
            "clangd"
            "--background-index"
            "--clang-tidy"
            "--header-insertion=iwyu"
            "--completion-style=detailed"
            "--function-arg-placeholders"
            "--fallback-style=llvm"
          ];
          root_markers = [
            ".clangd" ".clang-tidy" ".clang-format"
            "compile_commands.json" "compile_flags.txt"
            "configure.ac" "Makefile" ".git"
          ];
          filetypes = [ "c" "cpp" "objc" "objcpp" "cuda" ];
        };

        tailwindcss = {
          cmd = [ "tailwindcss-language-server" "--stdio" ];
          filetypes = [
            "html" "css" "javascript" "typescript"
            "javascriptreact" "typescriptreact"
          ];
        };

      };
    };

    visuals = {
      nvim-web-devicons.enable = true;
      indent-blankline.enable = true;
    };

    statusline.lualine = {
      enable = true;
      theme = "catppuccin";
    };

    dashboard.alpha = {
      enable = true;
      theme = null;
      layout = [
        {
          type = "padding";
          val = 2;
        }
        {
          type = "text";
          val = [
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣤⣤⣤⣤⣄⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⠶⣻⠝⠋⠠⠔⠛⠁⡀⠀⠈⢉⡙⠓⠶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠞⢋⣴⡮⠓⠋⠀⠀⢄⠀⠀⠉⠢⣄⠀⠈⠁⠀⡀⠙⢶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠞⢁⣔⠟⠁⠀⠀⠀⠀⠀⠈⡆⠀⠀⠀⠈⢦⡀⠀⠀⠘⢯⢢⠙⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡼⠃⠀⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠸⠀⠀⠀⠀⠀⢳⣦⡀⠀⠀⢯⠀⠈⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠆⡄⢠⢧⠀⣸⠀⠀⠀⠀⠀⠀⠀⢰⠀⣄⠀⠀⠀⠀⢳⡈⢶⡦⣿⣷⣿⢉⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣯⣿⣁⡟⠈⠣⡇⠀⠀⢸⠀⠀⠀⠀⢸⡄⠘⡄⠀⠀⠀⠈⢿⢾⣿⣾⢾⠙⠻⣾⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⡿⣮⠇⢙⠷⢄⣸⡗⡆⠀⢘⠀⠀⠀⠀⢸⠧⠀⢣⠀⠀⠀⡀⡸⣿⣿⠘⡎⢆⠈⢳⣽⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠀⠀⢠⡟⢻⢷⣄⠀⠀⠀⠀⠀⠀⣾⣳⡿⡸⢀⣿⠀⠀⢸⠙⠁⠀⠼⠀⠀⠀⠀⢸⣇⠠⡼⡤⠴⢋⣽⣱⢿⣧⠀⢳⠈⢧⠀⢻⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠀⢀⡿⣠⡣⠃⣿⠃⠀⠀⠀⠀⣸⣳⣿⠇⣇⢸⣿⢸⣠⠼⠀⠀⠀⡇⠀⡀⠉⠒⣾⢾⣆⢟⣳⡶⠓⠶⠿⢼⣿⣇⠈⡇⠘⢆⠈⢿⡘⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠀⠈⢷⣍⣤⡶⣿⡄⠀⠀⠀⢠⣿⠃⣿⠀⡏⢸⣿⣿⠀⢸⠀⠀⢠⡗⢀⠇⠀⢠⡟⠀⠻⣾⣿⠀⠀⠀⠀⡏⣿⣿⡀⢹⡀⠈⢦⠈⢷⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢁⣤⣄⠁⠀⠀⠀⣼⡏⢰⣟⠀⣇⠘⣿⣿⣾⣾⣆⢀⣾⠃⣼⢠⣶⣿⣭⣷⣶⣾⣿⣤⠀⠀⠀⡇⡯⣍⣧⠀⣷⠄⠈⢳⡀⢻⡁⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠺⣿⡿⠀⠀⠀⠀⡿⢀⣾⣧⠀⡗⡄⢿⣿⡙⣽⣿⣟⠛⠚⠛⠙⠉⢹⣿⣿⣦⠀⢸⡿⠀⠀⠀⢰⡯⣌⢻⡀⢸⢠⢰⡄⠹⡷⣿⣦⣤⠤⣶⡇⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⣇⣾⣿⢸⢠⣧⢧⠘⣿⡇⠸⣿⢿⡆⠀⠀⠀⠀⠘⣯⠇⣿⠂⣸⢰⠀⠀⢀⣸⡧⣊⣼⡇⢸⣼⣸⣷⢣⢻⣄⠉⠙⠛⠉⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣳⣤⣴⣿⣏⣿⣾⢸⣿⡘⣧⣘⢿⣀⡙⣞⠁⠀⠀⠀⠀⢀⡬⢀⣉⢠⣧⡏⠀⠀⡎⣿⣿⣿⣿⠃⣸⡏⣿⣿⡎⢿⡘⡆⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⣠⣼⣿⣿⣿⣼⣿⣧⢿⣿⣿⣯⡻⠟⠀⠀⠀⠀⠀⠐⢯⠣⡽⢟⣽⠀⠀⢘⡇⣿⣿⣿⡟⣴⣿⣷⣿⣿⣧⣿⣷⡽⠀⠀⠀⠀⠀⠀⠀"
            "⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣼⣹⣿⣇⣸⣿⣿⣿⣻⣚⣿⡿⣿⣿⣦⣤⣀⡉⠃⠀⢀⣀⣤⡶⠛⡏⠀⢀⣼⢸⣿⣿⣿⣿⣿⣿⣿⢋⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀"
            "⣿⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠒⠒⠒⢭⢻⣽⣿⣿⣿⣿⣿⣿⢿⠿⣿⡏⠀⡼⠁⣀⣾⣿⣿⣿⣿⡿⣿⣿⣟⡻⣿⣿⡿⠣⠟⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠸⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢧⢿⣯⡽⠿⠛⠋⣵⢟⣋⣿⣶⣞⣤⣾⣿⣿⡟⢉⡿⢋⠻⢯⡉⢻⡟⢿⡅⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⢻⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡞⣿⣆⡀⠀⡼⡏⠉⠚⠭⢉⣠⠬⠛⠛⢁⡴⣫⠖⠁⠀⠀⣩⠟⠁⣸⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠈⢷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣽⣿⣿⣾⠳⡙⣦⡤⠜⠊⠁⠀⣀⡴⠯⠾⠗⠒⠒⠛⠛⠛⠛⠛⠓⠿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠘⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢷⣻⣿⣿⠔⢪⠓⠬⢍⠉⣩⣽⢻⣤⣶⣦⠀⠀⠀⢀⣀⣤⣴⣾⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠹⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣾⡏⢦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣯⣿⣿⠀⠀⣇⠀⣠⠎⠁⢹⡎⡟⡏⣷⣶⠿⠛⡟⠛⠛⣫⠟⠉⢿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⢻⡄⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣷⠈⢷⡤⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣾⣷⡀⣀⣀⣷⡅⠀⠀⠈⣷⢳⡇⣿⠀⠀⣸⠁⢠⡾⣟⣛⣻⣟⡿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⢷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢯⢻⣏⡵⠿⠿⢤⣄⠀⢀⣿⢸⣹⣿⣀⣴⣿⣴⣿⣛⠋⠉⠉⡉⠛⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠘⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡎⣿⣥⣶⠖⢉⣿⡿⣿⣿⡿⣿⣟⠿⠿⣿⣿⣿⡯⠻⣿⣿⣿⣷⡽⣿⡗⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠸⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡘⣿⣩⠶⣛⣋⡽⠿⣷⢬⣙⣻⣿⣿⣿⣯⣛⠳⣤⣬⡻⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀"
            "⠀⣿⣛⣻⣿⡿⠿⠟⠗⠶⠶⠶⠶⠤⠤⢤⠤⡤⢤⣤⣤⣤⣤⣄⣀⣀⣀⣀⣀⣀⣀⣀⣣⢹⣷⣶⣿⣿⣦⣴⣟⣛⣯⣤⣿⣿⣿⣿⣿⣷⣌⣿⣿⣿⣿⣿⣿⣿⣤⣤⣤⣤⣤⣤⣄"
            "⠀⠉⠙⠛⠛⠛⠛⠛⠻⠿⠿⠿⠷⠶⠶⢶⣶⣶⣶⣶⣤⣤⣤⣤⣤⣥⣬⣭⣭⣉⣩⣍⣙⣏⣉⣏⣽⣶⣶⣶⣤⣤⣬⣤⣤⣾⣿⠶⠾⠿⠿⠿⠿⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠃"
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⠛⠛⠛⠛⠛⠛⠋⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
          ];
        }
      ];
    };

    filetree.neo-tree = {
      enable = true;
      setupOpts = {
        window.position = "right";
        enable_git_status = true;
        filtered_items = {
          visible = true;
          hide_dotfiles = false;
          hide_gitignore = true;
        };
      };
    };

    autocomplete = {
      enableSharedCmpSources = true;
      nvim-cmp = {
        enable = true;
        mappings = {
          next = "<C-j>";
          previous = "<C-k>";
          scrollDocsUp = "<C-b>";
          scrollDocsDown = "<C-f>";
          complete = "<C-Space>";
          close = "<C-e>";
          confirm = "<CR>";
        };
      };
    };

    snippets.luasnip.enable = true;

    binds.whichKey.enable = true;

    autopairs.nvim-autopairs.enable = true;

    comments.comment-nvim.enable = true;

    ui.illuminate.enable = true;

    notes.todo-comments.enable = true;

    git = {
      enable = true;
      gitsigns.enable = true;
    };

    terminal.toggleterm = {
      enable = true;
      lazygit.enable = true;
    };

    spellcheck.enable = false;

    keymaps = [
      {
        key = "<leader>e";
          mode = "n";
        action = "<cmd>Neotree toggle<CR>";
        desc = "Toggle file tree";
      }
      {
        key = "<leader>xx";
          mode = "n";
        action = "<cmd>Trouble diagnostics toggle<CR>";
        desc = "Toggle trouble";
      }
      {
        key = "<leader>wv";
          mode = "n";
        action = "<cmd>vsplit<CR>";
        desc = "Vertical split";
      }
      {
        key = "<leader>ws";
          mode = "n";
        action = "<cmd>split<CR>";
        desc = "Horizontal split";
      }
      {
        key = "<leader>wc";
          mode = "n";
        action = "<cmd>close<CR>";
        desc = "Close window";
      }
      {
        key = "<leader>wo";
          mode = "n";
        action = "<cmd>only<CR>";
        desc = "Close others";
      }
      {
        key = "<leader>w=";
          mode = "n";
        action = "<C-w>=";
        desc = "Balance windows";
      }
      {
        key = "<leader>ff";
          mode = "n";
        lua = true;
        action = "function() require('fff').find_files() end";
        desc = "Find files";
      }
      {
        key = "<leader>fg";
          mode = "n";
        lua = true;
        action = "function() require('fff').live_grep() end";
        desc = "Live grep";
      }
      {
        key = "<leader>fz";
          mode = "n";
        lua = true;
        action = "function() require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } }) end";
        desc = "Fuzzy grep";
      }
      {
        key = "<leader>fc";
          mode = "n";
        lua = true;
        action = "function() require('fff').live_grep({ query = vim.fn.expand('<cword>') }) end";
        desc = "Search word";
      }
      {
        key = "<leader>gg";
          mode = "n";
        action = "<cmd>LazyGit<CR>";
        desc = "Toggle lazygit";
      }
      {
        key = "<leader>li";
          mode = "n";
        action = "<cmd>checkhealth vim.lsp<CR>";
        desc = "LSP Health";
      }
      {
        key = "]d";
          mode = "n";
        lua = true;
        action = "function() vim.diagnostic.goto_next() end";
        desc = "Next diagnostic";
      }
      {
        key = "[d";
          mode = "n";
        lua = true;
        action = "function() vim.diagnostic.goto_prev() end";
        desc = "Previous diagnostic";
      }
      {
        key = "<leader>td";
          mode = "n";
        lua = true;
        action = "function() require('todo-comments').jump_next() end";
        desc = "Next TODO";
      }
      {
        mode = "i";
        key = "<C-z>";
        action = "<cmd>undo<CR>";
        desc = "Undo";
      }
      {
        mode = "i";
        key = "<C-y>";
        action = "<cmd>redo<CR>";
        desc = "Redo";
      }
      {
        key = "<leader>lq";
          mode = "n";
        action = "<cmd>!qmllint %<CR>";
        desc = "Run qmllint";
      }
      {
        mode = [ "i" "n" ];
        key = "<C-s>";
        action = "<cmd>w<CR>";
        desc = "Save file";
      }
      {
        key = "<leader>q";
          mode = "n";
        action = "<cmd>qa<CR>";
        desc = "Quit all";
      }
      {
        key = "<leader>Q";
          mode = "n";
        action = "<cmd>qa!<CR>";
        desc = "Force quit all";
      }
      {
        key = "<leader>h";
          mode = "n";
        action = "<cmd>nohlsearch<CR>";
        desc = "Clear search highlights";
      }
      {
        lua = true;
        key = "]b";
          mode = "n";
        action = "function() vim.cmd.bnext() end";
        desc = "Next buffer";
      }
      {
        lua = true;
        key = "[b";
          mode = "n";
        action = "function() vim.cmd.bprevious() end";
        desc = "Previous buffer";
      }
      {
        lua = true;
        key = "<leader>bd";
          mode = "n";
        action = "function() vim.cmd('bprevious | bdelete #') end";
        desc = "Close buffer";
      }
      {
        lua = true;
        key = "<leader>y";
          mode = "n";
        action = "function() vim.fn.setreg('+', vim.fn.getreg('\"')) end";
        desc = "Yank to system clipboard";
      }
      {
        lua = true;
        key = "<leader>p";
          mode = "n";
        action = "function() vim.cmd('normal! \"+p') end";
        desc = "Paste from system clipboard";
      }
      {
        key = "<leader>t";
          mode = "n";
        action = "<cmd>tabnew<CR>";
        desc = "New tab";
      }
      {
        key = "<leader><Tab>";
          mode = "n";
        action = "<cmd>tabnext<CR>";
        desc = "Next tab";
      }
      {
        key = "<leader><S-Tab>";
          mode = "n";
        action = "<cmd>tabprevious<CR>";
        desc = "Previous tab";
      }
      {
        key = "<leader>1";
          mode = "n";
        action = "<cmd>tabnext 1<CR>";
        desc = "Tab 1";
      }
      {
        key = "<leader>2";
          mode = "n";
        action = "<cmd>tabnext 2<CR>";
        desc = "Tab 2";
      }
      {
        key = "<leader>3";
          mode = "n";
        action = "<cmd>tabnext 3<CR>";
        desc = "Tab 3";
      }
      {
        key = "<leader>4";
          mode = "n";
        action = "<cmd>tabnext 4<CR>";
        desc = "Tab 4";
      }
      {
        key = "<leader>5";
          mode = "n";
        action = "<cmd>tabnext 5<CR>";
        desc = "Tab 5";
      }
      {
        key = "<leader>6";
          mode = "n";
        action = "<cmd>tabnext 6<CR>";
        desc = "Tab 6";
      }
      {
        key = "<leader>7";
          mode = "n";
        action = "<cmd>tabnext 7<CR>";
        desc = "Tab 7";
      }
      {
        key = "<leader>8";
          mode = "n";
        action = "<cmd>tabnext 8<CR>";
        desc = "Tab 8";
      }
      {
        key = "<leader>9";
          mode = "n";
        action = "<cmd>tabnext 9<CR>";
        desc = "Tab 9";
      }
    ];

    extraPlugins = {
      flash = {
        package = pkgs.vimPlugins.flash-nvim;
        setup = ''
          require("flash").setup()
        '';
      };

      clangd-extensions = {
        package = pkgs.vimPlugins.clangd_extensions-nvim;
        setup = ''
          require("clangd_extensions").setup({
            enable_offset_encoding_workaround = true,
            ast = {
              role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = "",
              },
            },
          })
        '';
      };

      tiny-inline-diagnostic = {
        package = pkgs.vimPlugins.tiny-inline-diagnostic-nvim;
        setup = ''
          require("tiny-inline-diagnostic").setup({
            preset = "modern",
          })
        '';
      };

      fff = {
        package = fff-nvim.packages.${pkgs.stdenv.hostPlatform.system}.fff-nvim;
        setup = ''
          require("fff").setup({
            layout = {
              height = 0.8,
              width = 0.8,
              prompt_position = "bottom",
            },
            preview = { enabled = true },
            grep = { modes = { "plain", "regex", "fuzzy" } },
            frecency = { enabled = true },
          })
        '';
      };
    };

    extraPackages = with pkgs; [
      prettierd
      phpPackages.php-cs-fixer
      stylua
      nixpkgs-fmt
      gofumpt
      rustfmt
      dart
      qt6.qtdeclarative
      cppcheck
      bear
      gdb
      tailwindcss-language-server
    ];

    luaConfigPre = '''';

    luaConfigRC = {
      cmp-config = ''
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup({
          mapping = cmp.mapping.preset.insert({
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
              else fallback() end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then luasnip.jump(-1)
              else fallback() end
            end, { "i", "s" }),
          }),
        })

        local clangd_cmp = require("clangd_extensions.cmp_scores")
        local comparators = cmp.get_config().sorting.comparators
        table.insert(comparators, 1, clangd_cmp)
        cmp.setup({ sorting = { comparators = comparators } })
      '';

      solid-background = ''
        vim.api.nvim_set_hl(0, "Normal", { bg = "#1e1e2e" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#181825" })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = "#1e1e2e" })
      '';

      neotree-autopen = ''
        vim.api.nvim_create_autocmd("VimEnter", {
          callback = function()
            require("neo-tree.command").execute({ toggle = false, dir = vim.uv.cwd() })
          end,
          nested = true,
        })
      '';

      trim-whitespace = ''
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = { "*" },
          callback = function()
            local save_cursor = vim.fn.getpos(".")
            vim.cmd([[%s/\s\+$//e]])
            vim.fn.setpos(".", save_cursor)
          end,
        })
      '';
    };
  };
}
