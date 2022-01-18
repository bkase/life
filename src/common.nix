{ config, pkgs, ... }:
let
  fastarcheyosx = pkgs.callPackage ./fastarcheyosx/c.nix { };
  highlight = pkgs.callPackage ./highlight/c.nix { };
  archeyProg = if pkgs.stdenv.isDarwin then fastarcheyosx else pkgs.screenfetch;
in
{
  nixpkgs.config.packageOverrides = pkgs: rec {
    coq = pkgs.coq.override {
      csdp = null;
    };
  };


  environment.systemPackages = with pkgs; [
    cmake
    bsdiff

    archeyProg
    highlight
    watchman

    asciinema
    fzf
    gettext
    git
    ripgrep
    jq
    wget
    coreutils
    go
    fasd
    bat

    nodejs
    pandoc

    rustup

    texlive.combined.scheme-full

    python3
    exa

    cachix

    # haskellPackages.ormolu

    nixpkgs-fmt

    direnv
    lorri
    scmpuff

    dhall
    dhall-json

    buildkite-agent
  ];
}
