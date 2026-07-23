{
  pkgs,
  lib,
  ...
}: {
  config.vim = {
    viAlias = false;
    vimAlias = true;

    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;
      odin.enable = true;
    };

    lsp.enable = true;

    autocomplete.nvim-cmp = {
      enable = true;
      sourcePlugins = [
        "cmp-nvim-lsp"
        "cmp-buffer"
        "cmp-path"
      ];
    };

    snippets.luasnip.enable = true;
  };
}
