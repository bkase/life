{ config, pkgs, ... }:
let
  pureZshSrc = pkgs.fetchFromGitHub {
    owner = "bkase";
    repo = "pure";
    rev = "e12cadc69a576efcea829f3cc4568c0eb6bcbee8";
    sha256 = "sha256-xC0PEzHnSR9ccC8EWgbGJnmbNsCR6XG3pBgRN5tLwfM=";
  };
  pureZsh = pkgs.stdenvNoCC.mkDerivation rec {
    name = "pure-zsh-${version}";
    version = "2022-12-24";
    phases = [ "unpackPhase" "installPhase" "fixupPhase" ];
    src = pureZshSrc;

    installPhase = ''
      mkdir -p $out/share/zsh/site-functions
      cp pure.zsh $out/share/zsh/site-functions/prompt_pure_setup
      cp async.zsh $out/share/zsh/site-functions/async
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    pureZsh
  ];

  programs.zsh = {
    enable = true;
    # enable completion manually with the once a day hack
    enableCompletion = false;
    enableBashCompletion = false;
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableFzfHistory = true;

    enableSyntaxHighlighting = true;

    promptInit = ''
      # load completion DB and recreate once a day
      source ${./fastCompleteInit.zsh}
      # load bash completion
      autoload -U +X bashcompinit && bashcompinit

      export PURE_PROMPT_SYMBOL="𝝺"

      # enable my pure prompt fork
      fpath+=( "${pureZsh.out}/share/zsh/site-functions" $fpath )

      autoload -U promptinit && promptinit
      prompt pure

      # show archey when prompt loads
      archey
    '';

    interactiveShellInit = "source ${./interactiveInit.zsh}";
  };

  environment.variables = {
    PATH = "/Users/bkase/yabai/bin:/usr/local/opt/ccache/libexec:$PATH:/Users/bkase/.cargo/bin:/Users/bkase/.cabal/bin:/usr/local/opt/ruby/bin:/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/sbin:/opt/local/bin:/usr/local/share/npm/bin:/usr/texbin:/Users/bkase/android-sdk/tools:/Users/bkase/android-sdk/platform-tools:/Users/bkase/android-ndk-r9b:/Users/bkase/google-cloud-sdk/bin:/Users/bkase/bin:/Users/bkase/.local/bin:/Library/TeX/texbin:/Users/bkase/.lmstudio/bin:/Users/bkase/.npm-global/bin";
  };

}
