{
  description = "Personal Neovim configuration using nvf";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { nixpkgs, nvf, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      neovimConfigured = (nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [
          ./config.nix
        ];
      }).neovim;
    in {
      packages.${system}.default = neovimConfigured;
      devShells.${system}.default = pkgs.mkShell {
        packages = [ neovimConfigured ];
      };
    };
}
