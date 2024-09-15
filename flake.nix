{
  description = "Brandon's darwin system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, rust-overlay }: {
    darwinConfigurations = {
      "Brandons-MacBook-Air" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          (import ./darwin-configuration.nix { inherit rust-overlay; })
        ];
        specialArgs = {
          inherit inputs;
        };
      };
    };
  };
}
