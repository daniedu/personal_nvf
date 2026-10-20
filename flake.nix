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

      # =============================================================================
      # PICO-8 tooling – not in nixpkgs, so built from source here.
      # =============================================================================

      # Tree-sitter grammar for the PICO-8 Lua dialect (.p8 cartridges).
      # https://github.com/paradoxskin/tree-sitter-pico8
      #
      # Ships its own queries/ directory, so the highlights come with it.
      tree-sitter-pico8 = pkgs.neovimUtils.grammarToPlugin (
        pkgs.tree-sitter.buildGrammar {
          language = "pico8";
          version = "0.0.1";
          src = pkgs.fetchFromGitHub {
            owner = "paradoxskin";
            repo = "tree-sitter-pico8";
            rev = "master";
            hash = "sha256-7loTfCAQ7nbaEgHujIG1yguVetYd+cAq+tp7hAIOfmg=";
          };
        }
      );

      # PICO-8 language server: completion, hover, diagnostics, #include support.
      # https://github.com/japhib/pico8-ls
      #
      # The server is a TypeScript project under server/ with its own
      # package-lock.json. `npm ci` needs the network, so the dependency
      # tarballs are fetched into the store by fetchNpmDeps (npmDepsHash) and
      # the build itself runs offline.
      pico8-ls = pkgs.buildNpmPackage {
        pname = "pico8-ls";
        version = "0.7.0";

        src = pkgs.fetchFromGitHub {
          owner = "japhib";
          repo = "pico8-ls";
          rev = "master";
          hash = "sha256-qCI00Ivp3mS9M0mk4MMTlj77UHsihBTa0+TTqO8OaLA=";
        };

        # The server lives in server/ and has its own package.json/lock.
        # fetchFromGitHub unpacks to "source/", and the server lives in
        # source/server/ – the lockfile has to be found from there.
        sourceRoot = "source/server";
        npmDepsHash = "sha256-sauXR/uK5BtAA2rMLFamH4kNHjeSUGRHBhPBuxUS0Is=";

        # `tsc -p ./` → out/server.js (see server/tsconfig.json).
        npmBuildScript = "compile";

        # The test files are not needed to run the server, and they fail to
        # typecheck without the mocha typings (which npm drops from a
        # production install). Rewrite the tsconfig without them.
        postPatch = ''
          cat > tsconfig.json <<'EOF'
          {
            "compilerOptions": {
              "target": "es2019",
              "module": "commonjs",
              "moduleResolution": "node",
              "outDir": "./out",
              "removeComments": false,
              "allowSyntheticDefaultImports": true,
              "esModuleInterop": true,
              "forceConsistentCasingInFileNames": true,
              "strict": true,
              "noImplicitAny": true,
              "skipLibCheck": true,
              "sourceMap": true
            },
            "include": ["./src/**/*"],
            "exclude": ["src/**/test/**"]
          }
          EOF
        '';

        # The language server is started as `pico8-ls --stdio`.
        installPhase = ''
          runHook preInstall

          mkdir -p $out/lib
          cp -r out $out/lib/

          makeWrapper ${pkgs.nodejs}/bin/node $out/bin/pico8-ls \
            --add-flags "$out/lib/out/server.js --stdio"

          runHook postInstall
        '';

        # node_modules has to travel with the server: it is not bundled.
        postFixup = ''
          cp -r node_modules $out/lib/
        '';

        meta = {
          description = "PICO-8 language server (LSP) for the PICO-8 dialect of Lua";
          homepage = "https://github.com/japhib/pico8-ls";
          license = pkgs.lib.licenses.mit;
          platforms = pkgs.lib.platforms.unix;
        };
      };

      neovimConfigured = (nvf.lib.neovimConfiguration {
        inherit pkgs;
        # Hand the PICO-8 tooling to config.nix, so it can wire up the
        # treesitter grammar and the language server.
        extraSpecialArgs = {
          inherit tree-sitter-pico8 pico8-ls;
        };
        modules = [
          ./config.nix
        ];
      }).neovim;
    in {
      packages.${system} = {
        default = neovimConfigured;
        inherit tree-sitter-pico8 pico8-ls;
      };
      devShells.${system}.default = pkgs.mkShell {
        packages = [ neovimConfigured ];
      };
    };
}
