{ config, pkgs, ... }:

let
  fastarcheyosx = pkgs.callPackage ./fastarcheyosx/c.nix {};
  scmpuff = pkgs.callPackage ./scmpuff/c.nix {};
  highlight = pkgs.callPackage ./highlight/c.nix {};
  bat = pkgs.callPackage ./bat/c.nix {};
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
    scmpuff
    highlight
    watchman

    ocaml
    opam
    ocamlPackages.merlin
    ocamlPackages.camlp4

    # Doesn't build on macOS right now
    # coq

    asciinema
    fzf
    gettext
    git
    ripgrep
    jq
    arcanist
    wget
    coreutils
    go
    fasd
    bat

    nox
    nodejs
    pandoc
    ponyc

    texlive.combined.scheme-full
  ];
}
