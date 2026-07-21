{ pkgs, ... }:
let
  flake = builtins.getFlake (toString ./.);
  neovim = flake.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  packages = [ neovim ];
}
