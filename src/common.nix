{ config, pkgs, ... }:

let
  fastarcheyosx = pkgs.callPackage ./fastarcheyosx/c.nix {};
  scmpuff = pkgs.callPackage ./scmpuff/c.nix {};
  highlight = pkgs.callPackage ./highlight/c.nix {};
  bat = pkgs.callPackage ./bat/c.nix {};
  archeyProg = if pkgs.stdenv.isDarwin then fastarcheyosx else pkgs.screenfetch;
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  my-python-packages = python-packages: with python-packages; [
    requests
    jinja2
    boto
    yapf
    # other python packages you want
  ];
  python-with-my-packages = pkgs.python3.withPackages my-python-packages;
  # ormolu is a haskell pretty printer
  ormolu-source = pkgs.fetchFromGitHub {
    owner = "tweag";
    repo = "ormolu";
    rev = "de279d80122b287374d4ed87c7b630db1f157642"; # update as necessary
    sha256 = "0qrxfk62ww6b60ha9sqcgl4nb2n5fhf66a65wszjngwkybwlzmrv"; # as well
  };
  ormolu = import ormolu-source { pkgs = pkgs; };
  haskellPackages = pkgs.haskell.packages.ghc865.override {
    overrides = ormolu.ormoluOverlay;
  };
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

    awscli

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

    rustup

    texlive.combined.scheme-full

    python-with-my-packages
    jrnl
    exa

    cachix
    terraform

    haskellPackages.ormolu
    (all-hies.bios.selection { selector = p: { inherit (p) ghc865; }; })
  ];
}
