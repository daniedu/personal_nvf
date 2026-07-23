{
  pkgs,
  lib,
  ...
}: {
  config.vim = {
    viAlias = false;
    vimAlias = true;

    globals = {
      mapleader = " ";
    };

    opts = {
      number = true;
      shiftwidth = 2;
      tabstop = 2;
    };

    diagnostics.config = {
      virtual_text = false;
      virtual_lines = false;
      signs = true;
      underline = true;
      update_in_insert = true;
      severity_sort = true;
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
      nix = {
        enable = true;
        format.type = ["nixfmt"];
      };
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
        };
        tailwindcss = {
          cmd = lib.mkForce ["tailwindcss-language-server" "--stdio"];
          filetypes = [
            "html" "css" "javascript" "typescript"
            "javascriptreact" "typescriptreact"
          ];
        };
        intelephense = {
          cmd = ["intelephense" "--stdio"];
          filetypes = ["php"];
        };
        nil.root_markers = lib.mkForce [".git" "flake.nix"];
        typescript-language-server = {
          enable = true;
          cmd = lib.mkForce ["typescript-language-server" "--stdio"];
          filetypes = lib.mkForce ["typescript" "javascript" "typescriptreact" "javascriptreact"];
          root_markers = lib.mkForce [".git" "tsconfig.json" "package.json"];
        };
        ols = {
          enable = true;
          cmd = lib.mkForce [
            "${pkgs.ols}/bin/ols"
            "--odin-root" "${pkgs.odin}/share"
          ];
          filetypes = ["odin"];
          root_markers = lib.mkForce ["ols.json" ".git"];
        };
      };
    };

    visuals = {
      nvim-web-devicons.enable = true;
      indent-blankline.enable = true;
    };

    statusline.lualine = {
      enable = true;
      theme = "auto";
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

    autocomplete.nvim-cmp = {
      enable = true;
      sources = {
        buffer = "[Buffer]";
        path = "[Path]";
      };
      sourcePlugins = [
        "cmp-nvim-lsp" "cmp-buffer" "cmp-path" "cmp-luasnip"
      ];
      mappings = {
        next = "<C-j>";
        previous = "<C-k>";
        scrollDocsUp = "<C-b>";
        scrollDocsDown = "<C-f>";
        complete = "<C-Space>";
        close = "<C-e>";
        confirm = "<CR>";
      };
      setupOpts.completion.completeopt = "menu,menuone,noinsert,noselect";
    };

    snippets.luasnip.enable = true;
    autopairs.nvim-autopairs.enable = true;
    comments.comment-nvim.enable = true;

    keymaps = [
      {
        key = "<leader>e";
        mode = "n";
        action = "<cmd>Neotree toggle<CR>";
        desc = "Toggle file tree";
      }
      {
        key = "<leader>ff";
        mode = "n";
        lua = true;
        action = "function() require('telescope.builtin').find_files() end";
        desc = "Find files";
      }
      {
        key = "<leader>fg";
        mode = "n";
        lua = true;
        action = "function() require('telescope.builtin').live_grep() end";
        desc = "Live grep";
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
        key = "<leader>q";
        mode = "n";
        action = "<cmd>qa<CR>";
        desc = "Quit all";
      }
      {
        mode = ["i" "n"];
        key = "<C-s>";
        action = "<cmd>w<CR>";
        desc = "Save file";
      }
      {
        key = "<leader>h";
        mode = "n";
        action = "<cmd>nohlsearch<CR>";
        desc = "Clear search highlights";
      }
      {
        key = "<leader>li";
        mode = "n";
        action = "<cmd>checkhealth vim.lsp<CR>";
        desc = "LSP health";
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
    ];

    extraPlugins = {
      tiny-inline-diagnostic = {
        package = pkgs.vimPlugins.tiny-inline-diagnostic-nvim;
        setup = ''
          require("tiny-inline-diagnostic").setup({ preset = "modern" })
        '';
      };
    };

    extraPackages = with pkgs; [
      prettierd phpPackages.php-cs-fixer stylua nixfmt gofumpt rustfmt dart
      qt6.qtdeclarative cppcheck bear gdb tailwindcss-language-server intelephense
    ];

    luaConfigRC = {
      cmp-ctrlp = ''
        vim.keymap.set("i", "<C-p>", function()
          require("cmp").complete()
        end, { desc = "Trigger nvim-cmp completion" })
      '';
    };
  };
}
