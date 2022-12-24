{ config, pkgs, ... }:

let
  coq_nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "coq_nvim";
    version = "2022-09-17";
    src = pkgs.fetchFromGitHub {
      owner = "ms-jpq";
      repo = "coq_nvim";
      rev = "5eddd31bf8a98d1b893b0101047d0bb31ed20c49";
      sha256 = "03cwv1mbvvww6p4137z8blap4pbm823yi2qrcg0j4kv39vv432wy";
    };
    meta.homepage = "https://github.com/ms-jpq/coq_nvim/";
  };
in
{
  programs.vim.package = pkgs.neovim.override {
    viAlias = true;
    vimAlias = true;

    configure = {
      customRC = builtins.readFile ./vimrc.vim + "\nlua << EOF\n" + builtins.readFile ./init.lua + "\nEOF";
      packages.darwin = with pkgs.vimPlugins; {
        start = [
          vim-sensible

          polyglot

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
          lspsaga-nvim

          lightline-vim
          lightline-lsp
        ];
      };
    };
  };
}
