{ config, pkgs, ... }:
let
  fastarcheyosx = pkgs.callPackage ./fastarcheyosx/c.nix { };
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
    fd

    nodejs
    pandoc

    rustup

    texlive.combined.scheme-full

    python3
    eza
    vivid

    cachix

    nixpkgs-fmt

    direnv
    lorri
    scmpuff

    dhall
    dhall-json

    buildkite-agent

    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages."@tailwindcss/language-server"

    git-lfs

    hysteria
  ];
}
