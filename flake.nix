{
  description = "Manage your Railway projects from your GNOME desktop";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = nixpkgs.legacyPackages.${system};
        skyhook = import ./. { inherit nixpkgs pkgs; };
      in
      rec {
        packages = flake-utils.lib.flattenTree {
          inherit skyhook;
          default = skyhook;
        };
        devShells = flake-utils.lib.flattenTree {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              packages.default
              gcc
              pkg-config
              meson
              ninja
              gtk4
              libadwaita
              vala
              vala-language-server
              json-glib
              libsoup_3
              desktop-file-utils
            ];
          };
        };
      }
    );
 }