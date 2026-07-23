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
  };
}
