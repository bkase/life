{ config, pkgs, ... }:
{
  environment.etc."dotconfig".source = pkgs.writeScriptBin "generate" ''
    #!${pkgs.stdenv.shell}

    mkdir -p ~/.config
    pushd ~/.config > /dev/null

    echo "generating kitty.conf..."
    mkdir -p kitty/
    cat ${./kitty.conf} > kitty/kitty.conf

    echo "generating alacritty.yml..."
    mkdir -p alacritty/
    cat ${./alacritty.yml} > alacritty/alacritty.yml

    echo "generating nix/..."
    mkdir -p nix/
    chmod +wrx nix/
    chown -R bkase nix/

    popd > /dev/null
  '';
}
