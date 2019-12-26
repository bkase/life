with import <nixpkgs> {};

let
  plugins =
    pkgs.callPackage ./src/vim/plugins.nix {};
  vimrcConfig = {
    vam.knownPlugins = pkgs.vimPlugins // plugins.extraKnownPlugins;
    vam.pluginDictionaries = plugins.plugins;
    customRC = (pkgs.callPackage ./src/vim/vimrc.nix {}).config;
  };
  myVim = pkgs.vim_configurable.customize { name = "vim"; inherit vimrcConfig; };

  common = pkgs.callPackage ./src/common.nix {};
  zsh = pkgs.callPackage ./src/zsh/c.nix {};

  zshPkgs = zsh.environment.systemPackages;
in
stdenv.mkDerivation rec {
  version = "0.1.0";

  name = "life-${version}";

  buildInputs = [
    pkgs.zsh-syntax-highlighting
    pkgs.zsh
    myVim
  ] ++ common.environment.systemPackages ++ zshPkgs;
}
