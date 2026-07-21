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
          cmd = [
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

        intelephense = {
          cmd = [ "intelephense" "--stdio" ];
          filetypes = [ "php" ];
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
      opts = {
        position = "center";
        hl = "Type";
      };
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
      settings = {
        window.position = "right";
        enable_git_status = true;
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
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
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
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle file tree";
      }
      {
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<CR>";
        options.desc = "Toggle trouble";
      }
      {
        key = "<leader>wv";
        action = "<cmd>vsplit<CR>";
        options.desc = "Vertical split";
      }
      {
        key = "<leader>ws";
        action = "<cmd>split<CR>";
        options.desc = "Horizontal split";
      }
      {
        key = "<leader>wc";
        action = "<cmd>close<CR>";
        options.desc = "Close window";
      }
      {
        key = "<leader>wo";
        action = "<cmd>only<CR>";
        options.desc = "Close others";
      }
      {
        key = "<leader>w=";
        action = "<C-w>=";
        options.desc = "Balance windows";
      }
      {
        key = "<leader>ff";
        lua = true;
        action = "function() require('fff').find_files() end";
        options.desc = "Find files";
      }
      {
        key = "<leader>fg";
        lua = true;
        action = "function() require('fff').live_grep() end";
        options.desc = "Live grep";
      }
      {
        key = "<leader>fz";
        lua = true;
        action = "function() require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } }) end";
        options.desc = "Fuzzy grep";
      }
      {
        key = "<leader>fc";
        lua = true;
        action = "function() require('fff').live_grep({ query = vim.fn.expand('<cword>') }) end";
        options.desc = "Search word";
      }
      {
        key = "<leader>gg";
        action = "<cmd>LazyGit<CR>";
        options.desc = "Toggle lazygit";
      }
      {
        key = "<leader>li";
        action = "<cmd>checkhealth vim.lsp<CR>";
        options.desc = "LSP Health";
      }
      {
        key = "]d";
        lua = true;
        action = "function() vim.diagnostic.goto_next() end";
        options.desc = "Next diagnostic";
      }
      {
        key = "[d";
        lua = true;
        action = "function() vim.diagnostic.goto_prev() end";
        options.desc = "Previous diagnostic";
      }
      {
        key = "<leader>td";
        lua = true;
        action = "function() require('todo-comments').jump_next() end";
        options.desc = "Next TODO";
      }
      {
        mode = "i";
        key = "<C-z>";
        action = "<cmd>undo<CR>";
        options.desc = "Undo";
      }
      {
        mode = "i";
        key = "<C-y>";
        action = "<cmd>redo<CR>";
        options.desc = "Redo";
      }
      {
        key = "<leader>lq";
        action = "<cmd>!qmllint %<CR>";
        options.desc = "Run qmllint";
      }
      {
        mode = [ "i" "n" ];
        key = "<C-s>";
        action = "<cmd>w<CR>";
        options.desc = "Save file";
      }
      {
        key = "<leader>q";
        action = "<cmd>qa<CR>";
        options.desc = "Quit all";
      }
      {
        key = "<leader>Q";
        action = "<cmd>qa!<CR>";
        options.desc = "Force quit all";
      }
      {
        key = "<leader>h";
        action = "<cmd>nohlsearch<CR>";
        options.desc = "Clear search highlights";
      }
      {
        lua = true;
        key = "]b";
        action = "function() vim.cmd.bnext() end";
        options.desc = "Next buffer";
      }
      {
        lua = true;
        key = "[b";
        action = "function() vim.cmd.bprevious() end";
        options.desc = "Previous buffer";
      }
      {
        lua = true;
        key = "<leader>bd";
        action = "function() vim.cmd('bprevious | bdelete #') end";
        options.desc = "Close buffer";
      }
      {
        lua = true;
        key = "<leader>y";
        action = "function() vim.fn.setreg('+', vim.fn.getreg('\"')) end";
        options.desc = "Yank to system clipboard";
      }
      {
        lua = true;
        key = "<leader>p";
        action = "function() vim.cmd('normal! \"+p') end";
        options.desc = "Paste from system clipboard";
      }
      {
        key = "<leader>t";
        action = "<cmd>tabnew<CR>";
        options.desc = "New tab";
      }
      {
        key = "<leader><Tab>";
        action = "<cmd>tabnext<CR>";
        options.desc = "Next tab";
      }
      {
        key = "<leader><S-Tab>";
        action = "<cmd>tabprevious<CR>";
        options.desc = "Previous tab";
      }
      {
        key = "<leader>1";
        action = "<cmd>tabnext 1<CR>";
        options.desc = "Tab 1";
      }
      {
        key = "<leader>2";
        action = "<cmd>tabnext 2<CR>";
        options.desc = "Tab 2";
      }
      {
        key = "<leader>3";
        action = "<cmd>tabnext 3<CR>";
        options.desc = "Tab 3";
      }
      {
        key = "<leader>4";
        action = "<cmd>tabnext 4<CR>";
        options.desc = "Tab 4";
      }
      {
        key = "<leader>5";
        action = "<cmd>tabnext 5<CR>";
        options.desc = "Tab 5";
      }
      {
        key = "<leader>6";
        action = "<cmd>tabnext 6<CR>";
        options.desc = "Tab 6";
      }
      {
        key = "<leader>7";
        action = "<cmd>tabnext 7<CR>";
        options.desc = "Tab 7";
      }
      {
        key = "<leader>8";
        action = "<cmd>tabnext 8<CR>";
        options.desc = "Tab 8";
      }
      {
        key = "<leader>9";
        action = "<cmd>tabnext 9<CR>";
        options.desc = "Tab 9";
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
        package = pkgs.vimPlugins.clangd-extensions-nvim;
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
      nodePackages.tailwindcss-language-server
      intelephense
    ];

    luaConfigPre = ''
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      local tab_mappings = cmp.mapping.preset.insert({
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
      })

      local default_setup = cmp.setup
      cmp.setup = function(opts)
        opts.sorting = opts.sorting or {}
        opts.sorting.comparators = opts.sorting.comparators or {}
        table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
        opts.mapping = vim.tbl_deep_extend("force", tab_mappings, opts.mapping or {})
        default_setup(opts)
      end
    '';

    luaConfigRC = {
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
