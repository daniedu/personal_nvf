{ pkgs, ... }:
let
  flake = builtins.getFlake (toString ./.);
  neovim = flake.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  packages = [ neovim ];

  # Demo entries so `:OverseerRun` has something to discover in this repo.
  # Remove them if you don't need them; Overseer discovers tasks/scripts
  # from whatever devenv project you have open.
  tasks."nvf:hello".exec = ''echo "hello from devenv tasks"'';

  scripts.hello.exec = ''echo "hello from devenv scripts"'';
}
