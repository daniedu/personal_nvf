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

    lsp = {
      enable = true;
      servers = {
        ols = {
          cmd = lib.mkForce [
            "${pkgs.ols}/bin/ols"
            "--odin-root"
            "${pkgs.odin}/share"
          ];
        };
      };
    };

    autocomplete.nvim-cmp = {
      enable = true;
      sourcePlugins = [
        "cmp-nvim-lsp"
        "cmp-buffer"
        "cmp-path"
      ];
      sources = {
        nvim_lsp = "[LSP]";
        buffer = "[Buffer]";
        path = "[Path]";
      };
    };

    snippets.luasnip.enable = true;
  };
}
