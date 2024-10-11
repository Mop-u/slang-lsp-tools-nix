{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        systems.url = "github:nix-systems/x86_64-linux";
        
        flake-utils.url = "github:numtide/flake-utils";
        flake-utils.inputs.systems.follows = "systems";
    };

    outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
        pkgs = nixpkgs.legacyPackages.${system};
        version = "0.2.0";
    in {
        packages.slang-lsp-tools = pkgs.stdenvNoCC.mkDerivation {
            name = "slang-lsp-tools";
            pname = "slang-lsp-tools";
            dontBuild = true;
            dontConfigure = true;

            src = pkgs.fetchurl {
                url = "https://github.com/suzizecat/slang-lsp-tools/releases/download/${version}/slang-lsp.${version}";
                hash = "sha256-K2Upuf5lMvvSBJxmlNFktuZGcUYz0JerCUAIOGXlX0o=";
            };

            nativeBuildInputs = with pkgs; [
                autoPatchelfHook
                libgcc
                glib
            ];
            unpackPhase = ''
                mkdir $out
                mkdir $out/bin
                cp $src $out/bin/slang-lsp
            '';
            installPhase = ''
                chmod +x $out/bin/slang-lsp
            '';
            system = builtins.currentSystem;

            meta = {
                homepage = "https://github.com/suzizecat/slang-lsp-tools";
                description = "Tools based upon slang for language server purpose";
            };
        };
    });
}