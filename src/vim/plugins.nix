{ config, pkgs, ... }:

{
  extraKnownPlugins = ({
    lightline-ale = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "lightline-ale-2018-06-12";
      src = pkgs.fetchgit {
        url = "git://github.com/maximbaz/lightline-ale";
        rev = "dd59077f9537b344f7ae80f713c1e4856ec1520c";
        sha256 = "1f9v6nsksy36s5i27nfx6vmyfyjk27p2w2g6x25cw56b0r3sgxmx";
      };
    };

    vim-pony = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "vim-pony-2018-07-27";
      src = pkgs.fetchgit {
        url = "git://github.com/jakwings/vim-pony";
        rev = "b26f01a869000b73b80dceabd725d91bfe175b75";
        sha256 = "0if8g94m3xmpda80byfxs649w2is9ah1k8v3028nblan73zlc8x8";
      };
    };

    vimbufsync = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "vimbufsync-2017-05-08";
      src = pkgs.fetchgit {
        url = "git://github.com/let-def/vimbufsync";
        rev = "650f9aefecd1aa00dfe4ceb60a623096951ec3dc";
        sha256 = "1wx9687hw833b6m5xhw8ig3ik9k9ccxrc628cfx41ay48vzyfbip";
      };
    };

    coquille = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "coquille-2017-12-09";
      src = pkgs.fetchgit {
        url = "git://github.com/the-lambda-church/coquille";
        rev = "df2460066686367b7949fe024c43ffd9d672f469";
        sha256 = "0kbbj660xk7xc5warhbz3k2gn5db1q9s9y5fs68dzjjmmz8670z1";
      };
    };

    vim-reason-plus = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "vim-reason-plus-2018-08-22";
      src = pkgs.fetchgit {
        url = "git://github.com/reasonml-editor/vim-reason-plus";
        rev = "e4460795d80329ec20e9ddc7b535f1cd2731acc8";
        sha256 = "07351b58afid3jwxmw9xmplpkxjy4hpbkfkw0lqapndn4a8xjnm0";
      };
    };

    vim-jsx = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "vim-jsx-2018-09-07";
      src = pkgs.fetchgit {
        url = "git://github.com/mxw/vim-jsx";
        rev = "ffc0bfd9da15d0fce02d117b843f718160f7ad27";
        sha256 = "0ff4w5n0cvh25mkhiq0ppn0w0lzc6sds1zwvd5ljf0cljlkm3bbg";
      };
      dependencies = [];
    };

    vim-flow = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "vim-flow-2016-10-16";
      src = pkgs.fetchgit {
        url = "git://github.com/flowtype/vim-flow";
        rev = "3bd879dd7060f13a78e9238669c2e1731e098607";
        sha256 = "002nl02187b2lxaya0myd0scn586z9r7yjklz6gawrrpx17vi49f";
      };
      dependencies = [];
    };

    colorizer = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "colorizer-1.4.1";
      src = pkgs.fetchgit {
        url = "git://github.com/lilydjwg/colorizer";
        rev = "749934c53af7b86da8b13a192c3ba5a1f71f6637";
        sha256 = "0bdv1snsx4ssd94zs3hiymrx2ql36spahcpjb1yc6js5vdki5kz9";
      };
    };

    vim-illuminate = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "vim-illuminate-2018-12-25";
      src = pkgs.fetchgit {
        url = "git://github.com/RRethy/vim-illuminate";
        rev = "7ca9b415f02545278d623c0de535226e80a79e38";
        sha256 = "051lnsx9d5cmqrv50qn2s9an3b16dq7i67ck5c15a4jrrclmpkqi";
      };
    };

    vim-search-pulse = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "vim-search-pulse-2017-01-05";
      src = pkgs.fetchgit {
        url = "git://github.com/inside/vim-search-pulse";
        rev = "9f8f473e3813bd76ecb66e8d6182d96bda39b6df";
        sha256 = "1xr90a8wvjfkgw1yrh0zcvpvp9ma6z0wqkl8v8pabf20vckgy2q0";
      };
    };

    neoformat = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "neoformat-2019-02-01";
      src = pkgs.fetchgit {
        url = "git://github.com/sbdchd/neoformat";
        rev = "e57ec7889bfb4371c5a4241183204d0bd1f8aea8";
        sha256 = "0ynln0wn0kg5s6n3v31bijwkr0cghv5jzlkawaj4ihxnx44lf839";
      };
    };

    vim-conflicted = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "conflicted-2018-07-19";
      src = pkgs.fetchgit {
        url = "git://github.com/christoomey/vim-conflicted";
        rev = "451347a72d96e521d6a7c88452eadbc06a71488b";
        sha256 = "10j5bvx7yg2v5pyxnk12fzzvqk0vy7h1vzp61cmxyp1m63m8vd57";
      };
    };
  });
  plugins = [ { names = [
     # "coquille"
     "vimbufsync"
     "ale"

     "vim-addon-nix"
     "youcompleteme"
     "lightline-vim"
     "surround"
     "Solarized"
     "The_NERD_Commenter"
     "fzf-vim"
     "fzfWrapper"

     "gitgutter"
     "fugitive"

     "lightline-ale"
     "vimproc"

     "neoformat"
     "vim-conflicted"
     "vim-easymotion"

     "vim-reason-plus"

     "colorizer"
     "rainbow"
     "vim-illuminate"
     "vim-search-pulse"

     "vim-wakatime"
    ]; }
     # "vim-elixir"
    { names = [
     "vim-flow"
     "vim-javascript"
     "vim-jsx"
    ]; ft_regex = "^\.jsx\$|^\.js\$"; }

    { names = [ "emmet-vim" ]; ft_regex = "^\.html\$"; }

    { names = [
     "psc-ide-vim"
     "purescript-vim"
    ]; ft_regex = "^\.purs\$"; }

    { names = [ "vim-jinja" ]; ft_regex = "^\.jinja\$"; }
    { names = [ "vim-reason-plus" ]; filename_regex = "\.re\$"; }
    { names = [ "vim-coffee-script" ]; ft_regex = "^\.coffee\$"; }
    { names = [ "vim-markdown" ]; ft_regex = "^\.md\$|^\.markdown\$"; }
    { names = [ "idris-vim" ]; ft_regex = "^\.idr\$"; }
    { names = [ "vim-pony" ]; ft_regex = "^\.pony\$"; }
    { names = [ "dhall-vim" ]; ft_regex = "^\.dhall\$"; }
    { names = [ "vim-nix" ]; ft_regex = "^\.nix\$"; }
  ];
}
