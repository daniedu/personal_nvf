{
  pkgs,
  lib,
  ...
}:
let
  activeTheme = import ./assets/themes/astronaut_earth_space_art_2.nix;
  # How much to pale the accent colors (0.0 = untouched, 1.0 = fully white)
  paleStrength = 0.7;
  # How much to pale the UI/gray colors (line numbers, cursorline, neo-tree, text)
  uiPaleStrength = 0.3;
  withHash = hex: "#${hex}";
  # Pull the dag helper from nvf's library structure
  inherit (lib.nvim.dag) entryAfter;

  # Make a #hex color whiter by blending each channel toward white.
  paleHex = strength: hex:
    let
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
      chanToHex = v:
        let
          new = builtins.floor (hexToInt v * (1.0 - strength) + 255.0 * strength + 0.5);
          v_ = lib.toHexString new;
        in if lib.strings.stringLength v_ == 1 then "0${v_}" else v_;
    in withHash
      (chanToHex (lib.substring 0 2 hex) + chanToHex (lib.substring 2 2 hex) + chanToHex (lib.substring 4 2 hex));
in
{
  config.vim = {
    viAlias = false;
    vimAlias = true;

    globals = {
      mapleader = " ";
    };

    clipboard = {
      enable = true;
      registers = "unnamedplus";
      providers = {
        wl-copy.enable = true;
        xclip.enable = true;
      };
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
        base00 = withHash activeTheme.base00;
        base01 = paleHex uiPaleStrength activeTheme.base01;
        base02 = paleHex uiPaleStrength activeTheme.base02;
        base03 = paleHex uiPaleStrength activeTheme.base03;
        base04 = paleHex uiPaleStrength activeTheme.base04;
        base05 = paleHex uiPaleStrength activeTheme.base05;
        base06 = paleHex uiPaleStrength activeTheme.base06;
        base07 = paleHex uiPaleStrength activeTheme.base07;
        base08 = paleHex paleStrength activeTheme.base08;
        base09 = paleHex paleStrength activeTheme.base09;
        base0A = paleHex paleStrength activeTheme.base0A;
        base0B = paleHex paleStrength activeTheme.base0B;
        base0C = paleHex paleStrength activeTheme.base0C;
        base0D = paleHex paleStrength activeTheme.base0D;
        base0E = paleHex paleStrength activeTheme.base0E;
        base0F = paleHex paleStrength activeTheme.base0F;
      };
    };

    # luaConfigRC.kittyToggle = entryAfter [ "theme" ] ''
    #   -- Automatically set Kitty background opaque on enter, and transparent on leave
    #   vim.api.nvim_create_autocmd("VimEnter", {
    #     callback = function()
    #       vim.fn.system("kitten @ set-background-opacity 1.0 &")
    #     end,
    #   })
    #
    #   vim.api.nvim_create_autocmd("VimLeavePre", {
    #     callback = function()
    #       -- Change 0.85 to whatever your usual transparent opacity level is
    #       vim.fn.system("kitten @ set-background-opacity 0.85 &")
    #     end,
    #   })
    # '';

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

      images.image-nvim = {
        enable = true;
        setupOpts.backend = "kitty";
      };
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
        key = "<C-b>";
        mode = "n";
        action = "<cmd>Neotree toggle<CR>";
        desc = "Toggle file tree (Ctrl-b)";
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
      clipboard-hybrid = entryAfter ["basic"] ''
        -- Hybrid clipboard: auto-detects Linux (Wayland/X11) / WSL / tmux / SSH
        -- Priority: 1) win32yank.exe on WSL, 2) native wl-copy/xclip when available outside tmux/SSH, 3) OSC52 fallback (tmux-aware)
        pcall(function() vim.opt.clipboard = "unnamedplus" end)

        local function is_wsl()
          if vim.fn.has("wsl") == 1 then return true end
          if os.getenv("WSL_DISTRO_NAME") ~= nil then return true end
          if os.getenv("WSL_INTEROP") ~= nil then return true end
          if vim.fn.filereadable("/proc/sys/fs/binfmt_misc/WSLInterop") == 1 then return true end
          local f = io.open("/proc/version", "r")
          if f then
            local c = f:read("*a"); f:close()
            if c and (c:lower():find("microsoft") or c:lower():find("wsl")) then return true end
          end
          return false
        end

        local in_tmux = os.getenv("TMUX") ~= nil
        local in_ssh = os.getenv("SSH_TTY") ~= nil or os.getenv("SSH_CONNECTION") ~= nil
        local has_win32yank = vim.fn.executable("win32yank.exe") == 1
        local has_wl_copy = vim.fn.executable("wl-copy") == 1
        local has_wl_paste = vim.fn.executable("wl-paste") == 1
        local has_xclip = vim.fn.executable("xclip") == 1
        local has_xsel = vim.fn.executable("xsel") == 1
        local wsl = is_wsl()

        if wsl and has_win32yank then
          vim.g.clipboard = {
            name = "win32yank-wsl",
            copy = {
              ["+"] = "win32yank.exe -i --crlf",
              ["*"] = "win32yank.exe -i --crlf",
            },
            paste = {
              ["+"] = "win32yank.exe -o --lf",
              ["*"] = "win32yank.exe -o --lf",
            },
            cache_enabled = 0,
          }
        elseif in_tmux or in_ssh or not (has_wl_copy or has_xclip or has_xsel) then
          -- OSC52 fallback, tmux-aware (writes directly to client_tty when inside tmux)
          local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")
          if ok and osc52 then
            local function osc52_copy(reg)
              return function(lines, regtype)
                -- Try tmux client_tty passthrough first for reliability inside tmux
                if in_tmux then
                  local ok_tty, tty = pcall(function()
                    return vim.fn.system('tmux display -p "#{client_tty}" 2>/dev/null'):gsub("%s+", "")
                  end)
                  if ok_tty and tty and tty ~= "" then
                    local text = table.concat(lines, "\n")
                    local b64
                    local ok_b64, enc = pcall(vim.base64.encode, text)
                    if ok_b64 then
                      b64 = enc
                    else
                      b64 = vim.fn.system("base64 -w0", text):gsub("%s+", "")
                    end
                    local esc = string.format("\027]52;c;%s\027\\", b64)
                    local f = io.open(tty, "wb")
                    if f then
                      f:write(esc)
                      f:close()
                      return
                    end
                  end
                end
                -- Fallback to built-in OSC52 (writes to stdout, requires tmux allow-passthrough)
                return osc52.copy(reg)(lines, regtype)
              end
            end

            local function make_paste(reg)
              return function()
                if has_win32yank then
                  return { vim.fn.systemlist("win32yank.exe -o --lf 2>/dev/null"), vim.fn.getregtype(reg) }
                elseif has_wl_paste then
                  return { vim.fn.systemlist("wl-paste --no-newline 2>/dev/null", { "" }, 1), vim.fn.getregtype(reg) }
                elseif has_xclip then
                  return { vim.fn.systemlist("xclip -o -selection clipboard 2>/dev/null", { "" }, 1), vim.fn.getregtype(reg) }
                elseif has_xsel then
                  return { vim.fn.systemlist("xsel -o -b 2>/dev/null", { "" }, 1), vim.fn.getregtype(reg) }
                else
                  -- Last resort: avoid OSC52 query (often blocked); use current unnamed register
                  -- User can paste from host via terminal's bracketed paste (Ctrl-Shift-V)
                  -- To enable OSC52 paste query, uncomment: return osc52.paste(reg)()
                  return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
                end
              end
            end

            vim.g.clipboard = {
              name = "OSC52-tmux-hybrid",
              copy = { ["+"] = osc52_copy("+"), ["*"] = osc52_copy("*") },
              paste = { ["+"] = make_paste("+"), ["*"] = make_paste("*") },
              cache_enabled = 0,
            }
          else
            -- Fallback string shorthand if lua module not available (older nvim)
            vim.g.clipboard = "osc52"
          end
        else
          -- Native Linux with wl-copy/xclip available and not in tmux/ssh: use provider as-is
          pcall(function() vim.opt.clipboard = "unnamedplus" end)
        end
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

      cmp-tmux-fix = entryAfter ["pluginConfigs"] ''
        -- Extra cmp mappings that bypass tmux C-h/j/k/l interception
        -- Provides <C-n>/<C-p>/<Tab>/<S-Tab>/<Down>/<Up> as alternatives to <C-j>/<C-k>
        -- and re-asserts <C-j>/<C-k> after is_vim fix; mappings are lazy so they work before cmp loads
        vim.schedule(function()
          local function has_words_before()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
          end

          local function cmp_next(fallback)
            local ok, cmp = pcall(require, "cmp")
            if ok and cmp.visible() then
              return cmp.select_next_item()
            end
            local luasnip_ok, luasnip = pcall(require, "luasnip")
            if luasnip_ok and luasnip.locally_jumpable(1) then
              return luasnip.jump(1)
            end
            if has_words_before() then
              if ok then return cmp.complete() end
            end
            if fallback then return fallback() end
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
          end

          local function cmp_prev(fallback)
            local ok, cmp = pcall(require, "cmp")
            if ok and cmp.visible() then
              return cmp.select_prev_item()
            end
            local luasnip_ok, luasnip = pcall(require, "luasnip")
            if luasnip_ok and luasnip.locally_jumpable(-1) then
              return luasnip.jump(-1)
            end
            if fallback then return fallback() end
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true), "n", true)
          end

          -- Re-assert C-j/C-k (ensures they work even if tmux mis-detects)
          vim.keymap.set("i", "<C-j>", cmp_next, { desc = "cmp next (C-j)" })
          vim.keymap.set("i", "<C-k>", cmp_prev, { desc = "cmp prev (C-k)" })
          -- Alternatives that tmux never intercepts
          vim.keymap.set("i", "<C-n>", cmp_next, { desc = "cmp next (C-n alt)" })
          -- C-p: keep original trigger when not navigating
          vim.keymap.set("i", "<C-p>", function(fallback)
            local ok, cmp = pcall(require, "cmp")
            local luasnip_ok, luasnip = pcall(require, "luasnip")
            if (ok and cmp.visible()) or (luasnip_ok and luasnip.locally_jumpable(-1)) then
              return cmp_prev(fallback)
            end
            if ok then return cmp.complete() end
            if fallback then return fallback() end
          end, { desc = "cmp prev / trigger" })
          vim.keymap.set("i", "<Tab>", cmp_next, { desc = "cmp next (Tab)" })
          vim.keymap.set("i", "<S-Tab>", cmp_prev, { desc = "cmp prev (S-Tab)" })
          vim.keymap.set("i", "<Down>", function(fallback)
            local ok, cmp = pcall(require, "cmp")
            if ok and cmp.visible() then return cmp.select_next_item() end
            if fallback then return fallback() end
          end, { desc = "cmp next (Down)" })
          vim.keymap.set("i", "<Up>", function(fallback)
            local ok, cmp = pcall(require, "cmp")
            if ok and cmp.visible() then return cmp.select_prev_item() end
            if fallback then return fallback() end
          end, { desc = "cmp prev (Up)" })
        end)
      '';
    };
  };
}
