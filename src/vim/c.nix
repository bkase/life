{ config, pkgs, ... }:

let vimrc =
    pkgs.callPackage ./vimrc.nix {};
in
let plugins =
  pkgs.callPackage ./plugins.nix {};
in
{
  programs.vim.package = pkgs.my_vim_configurable.customize {
    name = "vim";
    vimrcConfig.customRC = vimrc.config;
    vimrcConfig.vam.knownPlugins = pkgs.vimPlugins // plugins.extraKnownPlugins;
    vimrcConfig.vam.pluginDictionaries = plugins.plugins;
  };
}
