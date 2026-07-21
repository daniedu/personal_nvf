{
  description = "Personal Neovim configuration using nvf";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fff-nvim = {
      url = "github:dmtrKovalenko/fff.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nvf, fff-nvim, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      neovimConfigured = (nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [
          { _module.args = { inherit fff-nvim; }; }
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
