{
  description = "Nix flake for log4shell-tools";
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        defaultPackage =
          with pkgs; buildGoModule {
            pname = "log4shell-tools";
            version = "0.0.0";
            src = ./.;

            vendorSha256 = "sha256-eaS8wseZVYKSx60zP7Z0R3j2IzkfFQU7JhfMDEND+IA=";

            subPackages = [ "./cmd/log4shell-tools-server" ];
          };
        nixosConfigurations.devContainer = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./container.nix
          ];
        };
        devShell = with pkgs; mkShell {
          buildInputs = [
            go
            maven
            openjdk8
          ];
        };
      }
    );
}
