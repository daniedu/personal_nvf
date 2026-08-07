{
  pkgs,
  lib,
  ...
}:
let
  activeTheme = import ./assets/themes/astronaut_earth_space_art_2.nix;
  # How much to desaturate the palette (0.0 = untouched, 1.0 = fully gray)
  desatStrength = 0.5;
  withHash = hex: "#${hex}";
  # Pull the dag helper from nvf's library structure
  inherit (lib.nvim.dag) entryAfter;

  # Desaturate a #hex color by desatStrength while keeping its lightness.
  desaturatedHex = hex:
    let
      absL = x: if x < 0.0 then -x else x;
      # hex string -> { r g b } in 0..1
      hexToInt = hex:
        let
          digitValue = d:
            let
              ord = lib.strings.charToInt d;
            in
            if ord >= 48 && ord <= 57 then ord - 48
            else if ord >= 65 && ord <= 70 then ord - 55
            else if ord >= 97 && ord <= 102 then ord - 87
            else throw "invalid hex digit '${d}'";
        in builtins.foldl' (acc: d: acc * 16 + digitValue d) 0 (lib.stringToCharacters hex);
      toChannel = v: hexToInt v / 255.0;
      rgb = {
        r = toChannel (lib.substring 0 2 hex);
        g = toChannel (lib.substring 2 2 hex);
        b = toChannel (lib.substring 4 2 hex);
      };

      # RGB -> HSL
      max = lib.max rgb.r (lib.max rgb.g rgb.b);
      min = lib.min rgb.r (lib.min rgb.g rgb.b);
      d = max - min;
      l = (max + min) / 2.0;
      s = if d == 0.0 then 0.0 else d / (1.0 - absL (2.0 * l - 1.0));
      h = if d == 0.0 then 0.0
        else 60.0 * (
            if max == rgb.r then (rgb.g - rgb.b) / d + (if rgb.g < rgb.b then 6.0 else 0.0)
            else if max == rgb.g then (rgb.b - rgb.r) / d + 2.0
            else (rgb.r - rgb.g) / d + 4.0
          );

      # reduce saturation, keep hue + lightness
      ss = s * (1.0 - desatStrength);
      c = (1.0 - absL (2.0 * l - 1.0)) * ss;
      h' = h / 60.0;
      k = if h' < 1.0 then 0.0
        else if h' < 2.0 then 1.0
        else if h' < 3.0 then 2.0
        else if h' < 4.0 then 3.0
        else if h' < 5.0 then 4.0
        else 5.0;
      t = h' - k;
      isEven = k == 0.0 || k == 2.0 || k == 4.0;
      x = if isEven then c * t else c * (1.0 - t);
      prim =
        if k == 0.0 then { r = c; g = x; b = 0.0; }
        else if k == 1.0 then { r = x; g = c; b = 0.0; }
        else if k == 2.0 then { r = 0.0; g = c; b = x; }
        else if k == 3.0 then { r = 0.0; g = x; b = c; }
        else if k == 4.0 then { r = x; g = 0.0; b = c; }
        else { r = c; g = 0.0; b = x; };
      m = l - c / 2.0;
      chan = v: builtins.floor ((v + m) * 255.0 + 0.5);
      pad = v: let
        v_ = lib.toHexString v;
      in if lib.strings.stringLength v_ == 1 then "0${v_}" else v_;
    in withHash
      (pad (chan prim.r) + pad (chan prim.g) + pad (chan prim.b));
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
      transparent = false;
      name = "base16";
      base16-colors = {
        base00 = desaturatedHex activeTheme.base00;
        base01 = desaturatedHex activeTheme.base01;
        base02 = desaturatedHex activeTheme.base02;
        base03 = desaturatedHex activeTheme.base03;
        base04 = desaturatedHex activeTheme.base04;
        base05 = desaturatedHex activeTheme.base05;
        base06 = desaturatedHex activeTheme.base06;
        base07 = desaturatedHex activeTheme.base07;
        base08 = desaturatedHex activeTheme.base08;
        base09 = desaturatedHex activeTheme.base09;
        base0A = desaturatedHex activeTheme.base0A;
        base0B = desaturatedHex activeTheme.base0B;
        base0C = desaturatedHex activeTheme.base0C;
        base0D = desaturatedHex activeTheme.base0D;
        base0E = desaturatedHex activeTheme.base0E;
        base0F = desaturatedHex activeTheme.base0F;
      };
    };

    luaConfigRC.kittyToggle = entryAfter [ "theme" ] ''
      -- Automatically set Kitty background opaque on enter, and transparent on leave
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.fn.system("kitten @ set-background-opacity 1.0 &")
        end,
      })

      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          -- Change 0.85 to whatever your usual transparent opacity level is
          vim.fn.system("kitten @ set-background-opacity 0.85 &")
        end,
      })
    '';

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
        format.type = [ "nixfmt" ];
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
          cmd = lib.mkForce [
            "tailwindcss-language-server"
            "--stdio"
          ];
          filetypes = [
            "html"
            "css"
            "javascript"
            "typescript"
            "javascriptreact"
            "typescriptreact"
          ];
        };
        intelephense = {
          cmd = [
            "intelephense"
            "--stdio"
          ];
          filetypes = [ "php" ];
        };
        nil.root_markers = lib.mkForce [
          ".git"
          "flake.nix"
        ];
        typescript-language-server = {
          enable = true;
          cmd = lib.mkForce [
            "typescript-language-server"
            "--stdio"
          ];
          filetypes = lib.mkForce [
            "typescript"
            "javascript"
            "typescriptreact"
            "javascriptreact"
          ];
          root_markers = lib.mkForce [
            ".git"
            "tsconfig.json"
            "package.json"
          ];
        };
        ols = {
          enable = true;
          cmd = lib.mkForce [
            "${pkgs.ols}/bin/ols"
            "--odin-root"
            "${pkgs.odin}/share"
          ];
          filetypes = [ "odin" ];
          root_markers = lib.mkForce [
            "ols.json"
            ".git"
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
        "cmp-nvim-lsp"
        "cmp-buffer"
        "cmp-path"
        "cmp-luasnip"
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
    };

    autopairs.nvim-autopairs.enable = true;
    comments.comment-nvim.enable = true;

    utility = {
      surround.enable = true;
      motion.flash-nvim.enable = true;
    };

    fzf-lua = {
      enable = true;
      profile = "max-perf";
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
        action = "function() require('fzf-lua').files() end";
        desc = "Find files";
      }
      {
        key = "<leader>fg";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').live_grep() end";
        desc = "Live grep";
      }
      {
        key = "<leader>fb";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').buffers() end";
        desc = "Find buffers";
      }
      {
        key = "<leader>fh";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').help_tags() end";
        desc = "Help tags";
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
        mode = [
          "i"
          "n"
        ];
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
      {
        key = "<leader>gg";
        mode = "n";
        lua = true;
        action = ''
          function()
            local Terminal = require("toggleterm.terminal")
            local lazygit = Terminal.Terminal:new({
              cmd = "lazygit",
              direction = "float",
              hidden = true,
            })
            lazygit:toggle()
          end
        '';
        desc = "Toggle lazygit";
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
      prettierd
      phpPackages.php-cs-fixer
      stylua
      nixfmt
      gofumpt
      rustfmt
      dart
      qt6.qtdeclarative
      cppcheck
      bear
      gdb
      tailwindcss-language-server
      intelephense
    ];

    luaConfigPre = ''
      rawset(vim.lsp.handlers, "textDocument/documentColor", nil)
      pcall(vim.lsp.document_color.enable)

      vim.schedule(function()
        local ok, ui = pcall(require, "flutter-tools.ui")
        if ok then
          local orig = ui.notify
          ui.notify = function(msg, level, opts)
            if type(msg) == "string" and msg:find("lsp.color", 1, true) then return end
            return orig(msg, level, opts)
          end
        end
      end)
    '';

    luaConfigRC = {
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
