# personal_nvf

Standalone Neovim configuration built with [nvf](https://github.com/NotAShelf/nvf).
Replaces the old [nixvim](https://github.com/nix-community/nixvim) config from `personal_nixos`.

## Usage

```bash
# from anywhere:
nix run github:daniedu/personal_nvf

# locally:
nix run /home/work/Projects/nixosconfig/personal_nvf

# dev shell:
nix develop
# or:
devenv shell
```

## Configuration

| Category | What's included |
|---|---|
| **Theme** | Catppuccin Mocha |
| **Languages** | bash, clang (C/C++), cmake, css, dart, go, html, json, lua, markdown, nix, odin, php, qml, rust, toml, tsx, typescript, yaml |
| **LSP** | clangd (with custom flags), tailwindcss, intelephense, plus all language-module defaults |
| **File tree** | neo-tree (right side, auto-opens on start) |
| **Statusline** | lualine |
| **Dashboard** | alpha with ASCII art |
| **Completion** | nvim-cmp + luasnip (Tab/S-Tab integration, clangd score sorting) |
| **Editing** | autopairs, comment.nvim, illuminate, indent-blankline, flash |
| **Git** | gitsigns, lazygit via toggleterm |
| **Diagnostics** | trouble.nvim, todo-comments, tiny-inline-diagnostic |
| **Finder** | fff.nvim (`<leader>ff`, `<leader>fg`, etc.) |
| **Which-key** | enabled for keybind discovery |
| **Formatting** | per-language via conform-nvim (prettierd, clang-format, gofumpt, rustfmt, nixpkgs-fmt, stylua, php-cs-fixer, dart format, trim whitespace on save) |
| **Extras** | flash.nvim, clangd-extensions (AST icons), solid non-transparent background |
