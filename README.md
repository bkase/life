# Life

> A Nix configuration for macOS and Linux

## Running on a fresh macOS machine

1. Install Google Chrome
1. Install [nix](https://nixos.org/nix/)
1. Install [nix-darwin](https://github.com/LnL7/nix-darwin) as instructed
1. Clone this repo into `~/.nixpkgs`
1. Install PragmataPro
1. `darwin-rebuild switch`

## Running on Linux

1. Install [nix](https://nixos.org/nix/)
1. Clone this repo into `~/.nixpkgs`
1. Add to your bashrc:

```shell
nix-shell ~/.nixpkgs/shell.nix
```

