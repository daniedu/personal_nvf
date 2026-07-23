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
      setupOpts.completion.completeopt = "menu,menuone,noinsert";
    };

    snippets.luasnip.enable = true;
    git = {
      enable = true;
      gitsigns.enable = true;
    };

    terminal.toggleterm = {
      enable = true;
      lazygit.enable = true;
    };

    autopairs.nvim-autopairs.enable = true;
    comments.comment-nvim.enable = true;

    utility = {
      surround.enable = true;
      motion.flash-nvim.enable = true;
    };

    treesitter.textobjects = {
      enable = true;
      setupOpts = {
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            af = "@function.outer";
            "if" = "@function.inner";
            ac = "@class.outer";
            ic = "@class.inner";
            aa = "@parameter.outer";
            ia = "@parameter.inner";
          };
        };
      };
    };

    binds.whichKey.enable = true;

    keymaps = [
      {
        key = "<leader>xx";
        mode = "n";
        action = "<cmd>Trouble diagnostics toggle<CR>";
        desc = "Toggle trouble diagnostics";
      }
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
        key = "<leader>wh";
        mode = "n";
        action = "<C-w>h";
        desc = "Window left";
      }
      {
        key = "<leader>wj";
        mode = "n";
        action = "<C-w>j";
        desc = "Window down";
      }
      {
        key = "<leader>wk";
        mode = "n";
        action = "<C-w>k";
        desc = "Window up";
      }
      {
        key = "<leader>wl";
        mode = "n";
        action = "<C-w>l";
        desc = "Window right";
      }
      {
        key = "<leader>ww";
        mode = "n";
        action = "<C-w>w";
        desc = "Cycle windows";
      }
      {
        key = "<leader>w=";
        mode = "n";
        action = "<C-w>=";
        desc = "Balance windows";
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
        action = "<cmd>lua require('conform').format({ async = false, lsp_fallback = true })<CR><cmd>w<CR>";
        desc = "Format and save";
      }
      {
        key = "<leader>h";
        mode = "n";
        action = "<cmd>nohlsearch<CR>";
        desc = "Clear search highlights";
      }
      {
        key = "<leader>gt";
        mode = "n";
        action = "<cmd>tabnew<CR>";
        desc = "New tab";
      }
      {
        key = "<C-t>";
        mode = "n";
        action = "<cmd>tabnew<CR>";
        desc = "New tab";
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
      vim-visual-multi = {
        package = pkgs.vimPlugins.vim-visual-multi;
      };
    };

    extraPackages = with pkgs; [
      prettierd phpPackages.php-cs-fixer stylua nixfmt gofumpt rustfmt dart
      qt6.qtdeclarative cppcheck bear gdb tailwindcss-language-server intelephense
    ];

    luaConfigRC = {
      lsp-color = ''
        rawset(vim.lsp.handlers, "textDocument/documentColor", nil)
        pcall(vim.lsp.document_color.enable)
      '';

      neotree-autopen = ''
        vim.api.nvim_create_autocmd("VimEnter", {
          callback = function()
            require("neo-tree.command").execute({ toggle = false, dir = vim.uv.cwd() })
          end,
          nested = true,
        })
      '';

      cmp-ctrlp = ''
        vim.keymap.set("i", "<C-p>", function()
          require("cmp").complete()
        end, { desc = "Trigger nvim-cmp completion" })
      '';
    };
  };
}
