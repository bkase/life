{ config, pkgs, ... }:

let
  coq_nvim =
    let
      python = pkgs.python3;
      std2 = python.pkgs.buildPythonPackage {
        name = "std2";
        src = pkgs.fetchFromGitHub {
          owner = "ms-jpq";
          repo = "std2";
          rev = "963cf22346620926c0bd64f628ff4d8141123db5";
          hash = "sha256-drW7eZKE/NmVpkZfiA7nRlgUeqNNDnKA9h1qVADDZ/s=";
        };
        format = "pyproject";
        nativeBuildInputs = [ python.pkgs.setuptools ];
      };
      pynvim_pp = python.pkgs.buildPythonPackage {
        name = "pynvim_pp";
        src = pkgs.fetchFromGitHub {
          owner = "ms-jpq";
          repo = "pynvim_pp";
          rev = "456765f6dc8cef6df39ae3e61c79585258d38517";
          hash = "sha256-edDDzxR60ILFbv1CnYGxW/sJDMeRIFPjmTeiMRdvA3k=";
        };
        format = "pyproject";
        nativeBuildInputs = [ python.pkgs.setuptools ];
        propagatedBuildInputs = [ python.pkgs.msgpack ];
      };
      pyWithDeps = python.withPackages (p: with p; [ pyyaml std2 pynvim_pp ]);
    in
    pkgs.vimPlugins.coq_nvim.overrideAttrs (prev: {
      nativeBuildInputs = (prev.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
      postInstall = prev.postInstall + ''
        mkdir $out/.vars/runtime/bin -p
        # Don't check that python lives inside the venv
        substituteInPlace $out/coq/__main__.py \
          --replace 'assert not _IN_VENV' 'assert True'
        # Don't use xdg dir for python
        #substituteInPlace $out/lua/coq.lua --replace 'main(is_xdg)' 'main(false)'
        # We handle dep installation
        #cp $out/requirements.txt $out/.vars/runtime/requirements.lock
        # This is where it looks for python
        #ln -s ${pkgs.lib.getExe pyWithDeps} $out/.vars/runtime/bin/python3
        # Check that our versions match
        #{ grep ${std2.src.rev} requirements.txt -q &&
        #grep ${pynvim_pp.src.rev} requirements.txt -q; } ||
        #{ echo -e "\e[48;5;9mupdate ur hashes guy\e[0m"; exit 314; }
      '';
    });
  avante-nvim = (pkgs.callPackage ./avante-nvim { }).overrideAttrs {
    dependencies = with pkgs.vimPlugins; [
      dressing-nvim
      nui-nvim
      plenary-nvim
      nvim-web-devicons
      render-markdown
    ];
  };
in
{
  programs.vim.package = pkgs.neovim.override {
    viAlias = true;
    vimAlias = true;
    withPython3 = true;

    configure = {
      customRC = builtins.readFile ./vimrc.vim + "\nlua << EOF\n" + builtins.readFile ./init.lua + "\nEOF";
      packages.darwin = with pkgs.vimPlugins; {
        start = [
          vim-sensible

          polyglot

          # needs 'gruvbox' for lightline, gruvbox-nvim for the rest
          gruvbox
          gruvbox-nvim

          The_NERD_Commenter

          fzf-vim
          fzfWrapper
          fzf-lsp-nvim

          gitsigns-nvim
          neoformat

          vim-illuminate
          vim-search-pulse

          nvim-lspconfig
          nvim-treesitter.withAllGrammars
          coq_nvim
          coq-artifacts
          coq-thirdparty
          lspsaga-nvim
          rust-tools-nvim

          lightline-vim
          lightline-lsp

          nvim-web-devicons
          render-markdown
          avante-nvim
        ];
      };
    };
  };
}
