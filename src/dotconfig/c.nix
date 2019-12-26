{ config, pkgs, ... }:
{
  environment.etc."dotconfig".source = pkgs.writeScriptBin "generate" ''
    #!${pkgs.stdenv.shell}

    pushd ~/.config > /dev/null

    echo "generating kitty.conf..."
    mkdir -p kitty/
    cat ${./kitty.conf} > kitty/kitty.conf

    echo "generating alacritty.yml..."
    mkdir -p alacritty/
    cat ${./alacritty.yml} > alacritty/alacritty.yml

    popd > /dev/null
  '';
}
