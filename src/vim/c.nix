{ config, pkgs, ... }:

let vimrc =
    pkgs.callPackage ./vimrc.nix {};
in
{
  imports = [
    ./plugins.nix
  ];

  programs.vim.enable = true;
  programs.vim.vimConfig = vimrc.config;
}
