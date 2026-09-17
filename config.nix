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
  inherit (lib.nvim.dag) entryAfter entryBefore;

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
      php = {
        enable = true;
        lsp.servers = ["intelephense"];
      };
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
          cmd = lib.mkForce [
            "intelephense"
            "--stdio"
          ];
          filetypes = lib.mkForce [ "php" ];
          # monorepo: Laravel lives in web/ — expose vendor and stubs
          settings = {
            "intelephense.environment.phpVersion" = "8.2.0";
            "intelephense.environment.includePaths" = [ "web/vendor" ];
            "intelephense.files.maxSize" = 5000000;
            "intelephense.stubs" = [
              "apache"
              "bcmath"
              "bz2"
              "calendar"
              "com_dotnet"
              "Core"
              "ctype"
              "curl"
              "date"
              "dom"
              "exif"
              "fileinfo"
              "filter"
              "fpm"
              "ftp"
              "gd"
              "gettext"
              "gmp"
              "hash"
              "iconv"
              "imap"
              "interbase"
              "intl"
              "json"
              "ldap"
              "libxml"
              "mbstring"
              "meta"
              "mysqli"
              "oci8"
              "odbc"
              "openssl"
              "pcntl"
              "pcre"
              "PDO"
              "pdo_ibm"
              "pdo_mysql"
              "pdo_pgsql"
              "pdo_sqlite"
              "pgsql"
              "Phar"
              "posix"
              "pspell"
              "random"
              "readline"
              "Reflection"
              "session"
              "shmop"
              "SimpleXML"
              "soap"
              "sockets"
              "sodium"
              "SPL"
              "sqlite3"
              "standard"
              "superglobal"
              "sysvmsg"
              "sysvsem"
              "sysvshm"
              "tidy"
              "tokenizer"
              "xml"
              "xmlreader"
              "xmlrpc"
              "xmlwriter"
              "Zend OPcache"
              "zip"
              "zlib"
              "laravel"
              "carbon"
            ];
          };
        };
        phpactor = {
          enable = false;
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

    telescope = {
      enable = true;
      setupOpts.defaults.path_display = ["smart"];
      extensions = [
        {
          name = "fzf";
          packages = [pkgs.vimPlugins.telescope-fzf-native-nvim];
          setup = {
            fzf = {
              fuzzy = true;
            };
          };
        }
        {
          name = "ui-select";
          packages = [pkgs.vimPlugins.telescope-ui-select-nvim];
        }
      ];
    };

    navigation.harpoon = {
      enable = true;
      # NOTE: defaults for file1/file2 (<C-j>/<C-k>) clash with nvim-cmp
      # navigation, so files are on <leader>1-4 instead.
      mappings = {
        markFile = "<leader>a";
        listMarks = "<C-e>";
        file1 = "<leader>1";
        file2 = "<leader>2";
        file3 = "<leader>3";
        file4 = "<leader>4";
      };
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
      # NOTE: <leader>ff/fg/fb/fh/ft/fr are provided by the telescope
      # module itself, no manual keymaps needed.
      # NOTE: nvf's lsp module puts these on <leader>l... (e.g. <leader>lgd);
      # these are the classic vim-style aliases.
      {
        key = "gd";
        mode = "n";
        action = "<cmd>Telescope lsp_definitions<CR>";
        desc = "Go to definition";
      }
      {
        key = "gD";
        mode = "n";
        lua = true;
        action = "function() vim.lsp.buf.declaration() end";
        desc = "Go to declaration";
      }
      {
        key = "gi";
        mode = "n";
        action = "<cmd>Telescope lsp_implementations<CR>";
        desc = "Go to implementation";
      }
      {
        key = "gr";
        mode = "n";
        action = "<cmd>Telescope lsp_references<CR>";
        desc = "List references";
      }
      {
        key = "<leader>oo";
        mode = "n";
        lua = true;
        action = ''
          function()
            -- Telescope is lazy-loaded, but OverseerRun picks via
            -- vim.ui.select, which only becomes a Telescope picker after
            -- the ui-select extension loads. Force-load first so this
            -- always opens as a Telescope picker.
            pcall(function() require("lz.n").trigger_load("telescope") end)
            vim.cmd("OverseerRun")
          end
        '';
        desc = "Overseer: run devenv task/script (Telescope)";
      }
      {
        key = "<leader>ot";
        mode = "n";
        action = "<cmd>OverseerToggle<CR>";
        desc = "Overseer: toggle task list";
      }
      {
        key = "<leader>oa";
        mode = "n";
        lua = true;
        action = ''
          function()
            -- Same lazy-load reason as <leader>oo: task actions also pick
            -- via vim.ui.select.
            pcall(function() require("lz.n").trigger_load("telescope") end)
            vim.cmd("OverseerTaskAction")
          end
        '';
        desc = "Overseer: task actions";
      }
      {
        key = "<leader>oc";
        mode = "n";
        action = "<cmd>OverseerClear<CR>";
        desc = "Overseer: clear finished tasks";
      }
      {
        key = "<leader>ol";
        mode = "n";
        lua = true;
        action = ''
          function()
            -- Jump to the devenv process-only log (auto-opened on start);
            -- falls back to opening it in a new tab.
            local found = nil
            for _, b in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_valid(b) and vim.bo[b].filetype == "DevenvProcessLog" then
                found = b
              end
            end
            if not found then
              vim.notify("No devenv process log open", vim.log.levels.WARN)
              return
            end
            for _, w in ipairs(vim.fn.win_findbuf(found)) do
              if vim.api.nvim_win_is_valid(w) then
                vim.api.nvim_set_current_win(w)
                return
              end
            end
            vim.cmd.tabnew()
            vim.api.nvim_win_set_buf(0, found)
          end
        '';
        desc = "Overseer: open devenv process log";
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
      overseer = {
        package = pkgs.vimPlugins.overseer-nvim;
        after = ["telescope"];
        setup = ''
          require("overseer").setup({
            task_list = {
              direction = "left";
              max_width = { 60, 0.25 };
              min_width = 30;
            },
            -- devenv-only: disable task providers for other ecosystems so
            -- :OverseerRun only offers devenv tasks/scripts (+ our provider).
            disable_template_modules = {
              "overseer.template.cargo",
              "overseer.template.composer",
              "overseer.template.deno",
              "overseer.template.dotnet",
              "overseer.template.go",
              "overseer.template.gradle",
              "overseer.template.just",
              "overseer.template.make",
              "overseer.template.mix",
              "overseer.template.npm",
              "overseer.template.rake",
              "overseer.template.vscode",
            },
          })

          -- Provider exposing devenv tasks (`devenv tasks run <name>`) and
          -- devenv scripts (`devenv shell <name>`) as Overseer templates.
          -- Only active in directories containing devenv.nix/devenv.yaml.
          -- If nothing shows up, run :OverseerDevenvDebug in the project.
          -- NOTE: all runtime builders pass `--no-tui` (+ DEVENV_TUI=false).
          -- Overseer runs jobs under a pty, so without this devenv enables
          -- its interactive tree/spinner UI: redraw escape sequences leave
          -- blank gaps in scrollback, logs stay collapsed, and arrow keys go
          -- to devenv instead of Vim navigation. `--show-output` on
          -- `tasks run` additionally streams per-task logs so long builds
          -- don't look stuck on a spinner with no output.
          -- NOTE: do NOT add `--nix-option log-format raw` here: devenv 2.x
          -- rejects it (`Failed to set nix option: log-format = raw`,
          -- backend panics). Long-lived processes (`devenv up`) use a plain
          -- output buffer instead (see strategy below), which is immune to
          -- \r/cursor-escape redraw flicker from nix and compiler progress.
          -- Custom component: process-only log view. `devenv up` always
          -- prints its load phases (evaluate/configure/enterShell) before the
          -- process itself logs anything; this mirrors ONLY the process's own
          -- lines into a scratch buffer and auto-opens it in a new tab, so
          -- the devenv UI bloat stays in the full-output buffer.
          -- Registered via package.preload so this single-file config can
          -- provide an `overseer.component.*` module without extra files.
          do
            -- EDIT THIS LIST if devenv chatter leaks into the log tab.
            -- Anchored Lua patterns matched against each (ANSI-stripped) line:
            local CHATTER_PATTERNS = {
              "^%s*$", -- blank filler
              "^{%s*$", -- stray braces from devenv summaries
              "^}%s*$",
              "^{%s*}%s*$", -- "{}" summary lines
              "^%s*✓", -- devenv status lines ("✓ Loading tasks")
              "^%s*✗", -- failure markers
              "^%s*✖",
              "^%s*%d+ of %d+", -- "3 of 3 tasks  │  1 process"
              "^%s*%d+ %a+ed%s*$", -- "1 Succeeded"
              "^%s*Loading tasks",
              "^%s*Evaluating",
              "^%s*Configuring shell",
              "^%s*Running tasks",
              "^%s*Running processes",
              "^%s*Succeeded",
              "^%s*Failed",
              "^%s*Skipped",
              "^%s*Running%s+%S+%s*$", -- "Running           nvf:hello"
              "^%s*%d+%.?%d*%s*m?s%s*$", -- bare timings ("16ms", "35.4s")
              "^%s*%d+%s*m%s*%d+%s*s%s*$", -- bare timings ("15m 3s")
              "in %d+%.?%d*%s*m?s%s*$", -- timing suffixes ("... in 39.9ms")
            }
            -- Plain substrings matched anywhere in the line:
            local CHATTER_SUBSTR = {
              -- devenv refs ("devenv:enterShell", "devenv.config...").
              -- Deliberately NOT bare "devenv": process lines like
              -- "[myproc] built from devenv tasks" must survive.
              "devenv:", "devenv.",
              "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏", -- spinner frames
            }
            local function is_chatter(line)
              for _, pat in ipairs(CHATTER_PATTERNS) do
                if line:match(pat) then return true end
              end
              for _, sub in ipairs(CHATTER_SUBSTR) do
                if line:find(sub, 1, true) then return true end
              end
              return false
            end
            package.preload["overseer.component.devenv_process_log"] = function()
              return {
                desc = "Mirror only the process's own log lines to a separate tab",
                constructor = function()
                  return {
                    on_init = function(self, task)
                      local bufnr = vim.api.nvim_create_buf(false, true)
                      vim.bo[bufnr].filetype = "DevenvProcessLog"
                      vim.bo[bufnr].bufhidden = "hide"
                      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
                        "== process log: " .. (task.name or "?") .. " ==",
                        "",
                      })
                      self.log_bufnr = bufnr
                      self.log_opened = false
                    end,
                    on_reset = function(self)
                      self.log_opened = false
                      local bufnr = self.log_bufnr
                      if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
                        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
                      end
                    end,
                    on_output_lines = function(self, task, lines)
                      local bufnr = self.log_bufnr
                      if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then return end
                      local keep = {}
                      for _, line in ipairs(lines) do
                        if not is_chatter(line) then table.insert(keep, line) end
                      end
                      if #keep == 0 then return end
                      local before = vim.api.nvim_buf_line_count(bufnr)
                      vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, keep)
                      if not self.log_opened then
                        self.log_opened = true
                        local curwin = vim.api.nvim_get_current_win()
                        vim.schedule(function()
                          if not vim.api.nvim_buf_is_valid(bufnr) then return end
                          for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
                            if vim.api.nvim_win_is_valid(winid) then return end
                          end
                          vim.cmd.tabnew()
                          vim.api.nvim_win_set_buf(0, bufnr)
                          if vim.api.nvim_win_is_valid(curwin) then
                            vim.api.nvim_set_current_win(curwin)
                          end
                        end)
                      else
                        -- Follow the tail only while the viewer is at the end,
                        -- so scrolled-up reading is never yanked away.
                        for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
                          if vim.api.nvim_win_is_valid(winid) then
                            local ok, cursor = pcall(vim.api.nvim_win_get_cursor, winid)
                            if ok and cursor[1] >= before then
                              local n = vim.api.nvim_buf_line_count(bufnr)
                              pcall(vim.api.nvim_win_set_cursor, winid, { n, 0 })
                            end
                          end
                        end
                      end
                    end,
                    on_complete = function(self, task, status)
                      local bufnr = self.log_bufnr
                      if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
                        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false,
                          { "", "[process " .. tostring(status):lower() .. "]" })
                      end
                    end,
                    on_dispose = function(self)
                      local bufnr = self.log_bufnr
                      self.log_bufnr = nil
                      if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
                        vim.api.nvim_buf_delete(bufnr, { force = true })
                      end
                    end,
                  }
                end,
              }
            end
          end
          do
            local function run_devenv(dir, args)
              local cmd = { "devenv" }
              for _, a in ipairs(args) do table.insert(cmd, a) end
              local ok, res = pcall(function()
                return vim.system(cmd, { cwd = dir, text = true, timeout = 30000 }):wait()
              end)
              if not ok then return nil end
              return res
            end

            -- Collect names from decoded JSON whatever shape it has: a map
            -- (keys), a list (string items), or a list of {name=...} tables.
            -- `devenv eval <attr>` wraps the result as { ["<attr>"] = ... },
            -- so descend through a single tasks/scripts wrapper key.
            local wrapper_keys = { tasks = true, scripts = true }
            local function json_names(stdout)
              local ok, data = pcall(vim.json.decode, stdout or "")
              if not ok or type(data) ~= "table" then return {} end
              local count = 0
              for _ in pairs(data) do count = count + 1 end
              if count == 1 then
                local k, v = next(data)
                if wrapper_keys[k] and type(v) == "table" then data = v end
              end
              local names = {}
              for k, v in pairs(data) do
                if type(k) == "string" and k ~= "" then
                  table.insert(names, k)
                elseif type(v) == "string" and v ~= "" then
                  table.insert(names, v)
                elseif type(v) == "table" and type(v.name) == "string" and v.name ~= "" then
                  table.insert(names, v.name)
                end
              end
              table.sort(names)
              return names
            end

            local skip_lines = {
              available = true, tasks = true, task = true, list = true,
              no = true, error = true, warning = true, failed = true,
            }

            -- Fallback for old devenv versions: parse the human-readable
            -- `devenv tasks list` output conservatively.
            local function parse_tasks_text(stdout)
              local names = {}
              for line in string.gmatch(stdout or "", "[^\n]+") do
                local trimmed = line:match("^%s*(.-)%s*$")
                if trimmed ~= "" then
                  local tok = trimmed:match("^([%w_][%w%-%._:]*)")
                  local first = tok and tok:lower()
                  if tok and not skip_lines[first]
                    and (tok:find(":", 1, true) or trimmed == tok)
                  then
                    table.insert(names, tok)
                  end
                end
              end
              table.sort(names)
              return names
            end

            -- Run every discovery probe, remember per-probe diagnostics.
            -- Returns tasks, scripts, dbg.
            local function discover(dir)
              local dbg = {}
              local function probe(label, args, parse)
                local res = run_devenv(dir, args)
                local entry = { label = label, code = res and res.code or "spawn-failed", names = {} }
                if res and res.code == 0 then
                  entry.names = parse(res.stdout or "")
                else
                  entry.err = res and (res.stderr or "") or ""
                end
                table.insert(dbg, entry)
                return entry.names
              end
              local tasks = probe("eval tasks", { "eval", "tasks" }, json_names)
              if #tasks == 0 then
                tasks = probe("tasks list --json", { "tasks", "list", "--json" }, json_names)
              end
              if #tasks == 0 then
                tasks = probe("tasks list", { "tasks", "list" }, parse_tasks_text)
              end
              local scripts = probe("eval scripts", { "eval", "scripts" }, json_names)
              return tasks, scripts, dbg
            end

            vim.api.nvim_create_user_command("OverseerDevenvDebug", function()
              local dir = vim.fn.getcwd()
              vim.notify("Probing devenv in " .. dir .. " ...", vim.log.levels.INFO)
              local tasks, scripts, dbg = discover(dir)
              local exe = vim.fn.exepath("devenv")
              local lines = {
                "dir: " .. dir,
                "devenv: " .. (exe ~= "" and exe or "(not on PATH)"),
                "devenv.nix readable: " .. vim.fn.filereadable(dir .. "/devenv.nix"),
                "devenv.yaml readable: " .. vim.fn.filereadable(dir .. "/devenv.yaml"),
                string.format("tasks (%d): %s", #tasks, table.concat(tasks, ", ")),
                string.format("scripts (%d): %s", #scripts, table.concat(scripts, ", ")),
              }
              for _, e in ipairs(dbg) do
                local err = (e.err or ""):gsub("\27%[[%d;]*m", ""):gsub("%s+", " "):sub(1, 300)
                table.insert(lines, string.format(
                  "[%s] exit=%s names=%d%s",
                  e.label, tostring(e.code), #e.names,
                  err ~= "" and (" err: " .. err) or ""
                ))
              end
              vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
            end, { desc = "Debug devenv task/script discovery for Overseer" })

            require("overseer").register_template({
              name = "devenv",
              priority = 100,
              generator = function(opts)
                local dir = (opts and opts.dir) or vim.fn.getcwd()
                if vim.fn.filereadable(dir .. "/devenv.nix") == 0
                  and vim.fn.filereadable(dir .. "/devenv.yaml") == 0
                then
                  return {}
                end
                local tasks, scripts = discover(dir)
                local seen, ret = {}, {}
                local function add(display, builder)
                  if not seen[display] then
                    seen[display] = true
                    table.insert(ret, { name = display, builder = builder })
                  end
                end
                for _, t in ipairs(tasks) do
                  local name = t
                  -- Processes are auto-exposed as tasks named
                  -- `devenv:processes:<name>`, but `devenv tasks run` tears
                  -- processes down as soon as the graph finishes (game killed
                  -- before its window appears). Route them through `devenv up`
                  -- instead, which supervises them until stopped.
                  local proc = name:match("^devenv:processes:(.+)$")
                  if proc then
                    local pname = proc
                    add("devenv process: " .. pname, function()
                      return {
                        cmd = { "devenv", "--no-tui", "up", pname },
                        env = { DEVENV_TUI = "false" },
                        cwd = dir,
                        name = "devenv process " .. pname,
                        components = { "devenv_process_log", "default" },
                        -- Plain (non-terminal) output buffer for processes:
                        -- `devenv up` supervises long-running builds whose
                        -- children (nix `bar` progress, compiler spinners)
                        -- redraw lines via \r/cursor escapes. In a terminal
                        -- buffer that means constant flicker; in a plain
                        -- buffer Overseer strips ANSI + trailing \r per line
                        -- and only tails while your cursor is at the end, so
                        -- devenv's load phase prints, then process logs
                        -- stream as stable, searchable lines. Tradeoff: no
                        -- ANSI colors and no interactive stdin. If a process
                        -- ever needs keyboard input, drop this line to fall
                        -- back to the default terminal strategy.
                        strategy = { "jobstart", use_terminal = false },
                      }
                    end)
                  else
                    add("devenv task: " .. name, function()
                      return {
                        cmd = { "devenv", "--no-tui", "tasks", "run", "--show-output", name },
                        env = { DEVENV_TUI = "false" },
                        cwd = dir,
                        name = "devenv task " .. name,
                      }
                    end)
                  end
                end
                for _, s in ipairs(scripts) do
                  local name = s
                  add("devenv script: " .. name, function()
                    return {
                      cmd = { "devenv", "--no-tui", "shell", name },
                      env = { DEVENV_TUI = "false" },
                      cwd = dir,
                      name = "devenv script " .. name,
                    }
                  end)
                end
                return ret
              end,
            })
          end

          -- :OverseerRun picks via vim.ui.select, which the telescope
          -- ui-select extension above renders as a Telescope picker.
          -- Opportunistic: enable the overseer Telescope extension if the
          -- installed overseer version ships one (harmless no-op otherwise).
          pcall(require("telescope").load_extension, "overseer")

          -- Overseer output tabs are terminal-mode buffers: keys (incl.
          -- arrows) go to the job, not Vim. devenv --no-tui needs no
          -- interactive Esc, so buffer-locally let <Esc> drop to Normal
          -- mode where j/k, gg/G, /-search and scrolling work.
          -- (<C-\><C-n> keeps working everywhere, incl. lazygit.)
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "OverseerOutput",
            desc = "Esc exits terminal mode in Overseer output",
            callback = function(args)
              vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = args.buf, desc = "Overseer: enter Normal mode" })
            end,
          })
        '';
      };
    };

    extraPackages = with pkgs; [
      devenv
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
      base16-no-telescope = entryBefore ["theme"] ''
        -- Opt out of base16-colorscheme's Telescope highlights so Telescope
        -- keeps its stock look. Must run before the theme setup below.
        pcall(function()
          require("base16-colorscheme").with_config({ telescope = false })
        end)
      '';

      clipboard-hybrid = entryAfter ["basic"] ''
        -- Hybrid clipboard: auto-detects Linux (Wayland/X11) / WSL / tmux / SSH
        -- Priority: 1) win32yank.exe on WSL, 2) native wl-copy/xclip when available (even inside tmux, not SSH) -> yy global, 3) OSC52 fallback
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
        elseif (has_wl_copy or has_xclip or has_xsel) and not in_ssh then
          -- Native clipboard available and not over SSH: use it even inside tmux
          -- wl-copy/xclip make yy global across nvim instances (no OSC52 needed)
          pcall(function() vim.opt.clipboard = "unnamedplus" end)
        elseif in_ssh or not (has_wl_copy or has_xclip or has_xsel) then
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
          -- Fallback: ensure unnamedplus (covers any remaining native case)
          pcall(function() vim.opt.clipboard = "unnamedplus" end)
        end
      '';

      cmp-ctrlp = ''
        vim.keymap.set("i", "<C-p>", function()
          require("cmp").complete()
        end, { desc = "Trigger nvim-cmp completion" })
      '';

      telescope-soften = entryAfter ["pluginConfigs"] ''
        -- Tone down Telescope's match highlighting: keep the match color so
        -- you can still see *what* matched, but drop the bold that makes
        -- results look heavy against the paled base16 theme. Re-applied on
        -- ColorScheme so theme reloads don't bring the bold back.
        local function soften_telescope_hl()
          for _, group in ipairs({ "TelescopeMatching", "TelescopeSelectionCaret" }) do
            local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
            if ok and type(hl) == "table" and next(hl) ~= nil then
              hl.bold = false
              pcall(vim.api.nvim_set_hl, 0, group, hl)
            end
          end
        end
        vim.api.nvim_create_autocmd("ColorScheme", {
          callback = soften_telescope_hl,
          desc = "Keep Telescope match highlight non-bold",
        })
        vim.schedule(soften_telescope_hl)
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
