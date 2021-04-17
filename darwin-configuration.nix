{ config, pkgs, ... }:
let
  barbq =
    let
      src = pkgs.fetchFromGitHub {
        owner = "bkase";
        repo = "barbq";
        rev = "c1467af2b1c52423ee32b84e40b25b1902cf0bf2";
        sha256 = "1jsfcjnpyj9j1vg5341l4zdww7slqp48l8yh7b5mlkgxmhl3k39m";
      };
    in
    (import "${src}/release.nix").barbq;
in
let
  screenshots-folder = "/Users/bkase/screenshots";
in
{
  imports = [
    ./src/yabai/service.nix
    ./src/dotconfig/c.nix
    ./src/common.nix
    ./src/zsh/c.nix
    ./src/vim/c.nix
  ];

  launchd.user.agents.barbq =
    let
      script = pkgs.writeScriptBin "statusbar" ''
        #!${pkgs.stdenv.shell}

        /Users/bkase/yabai/bin/yabai -m rule --add app=Alacritty sticky=on

        /Users/bkase/Applications/Nix\ Apps/Alacritty.app/Contents/MacOS/alacritty -o window.dimensions.columns=180 -o window.dimensions.lines=1 -o window.position.x=0 -o window.position.y=0 -e ${barbq}/bin/barbq
      '';
    in
    {
      path = [ "/Users/bkase/yabai/bin" "${barbq}/bin" config.environment.systemPath ];
      serviceConfig.ProgramArguments = [ "${script}/bin/statusbar" ];
      serviceConfig.RunAtLoad = true;
      serviceConfig.KeepAlive = true;
    };

  launchd.user.agents.lorri = {
    serviceConfig = {
      WorkingDirectory = (builtins.getEnv "HOME");
      EnvironmentVariables = { };
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/var/tmp/lorri.log";
      StandardErrorPath = "/var/tmp/lorri.log";
    };
    script = ''
      source ${config.system.build.setEnvironment}
      exec ${pkgs.lorri}/bin/lorri daemon
    '';
  };

  system.activationScripts.postActivation.text = ''
    # Regenerate ~/.config files
    /etc/dotconfig/bin/generate

    # Ensure screenshots folder exists
    mkdir -p ${screenshots-folder}

    # Regenerate .gitignore
    echo "regenerating global .gitignore..."
    cat ${./src/gitignore} > ~/.gitignore
    git config --global core.excludesfile ~/.gitignore

    # Regenerate ~/.vim files
    echo "regenerating ~/.vim files..."
    mkdir -p ~/.vim
    cat ${./src/vim/coc-settings.json} > ~/.vim/coc-settings.json
  '';

  environment.systemPackages = [
    config.programs.vim.package
    pkgs.kitty
    pkgs.alacritty
    barbq
  ];

  environment.extraOutputsToInstall = [ "man" ];

  system.defaults.NSGlobalDomain.InitialKeyRepeat = 12;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;
  system.defaults.dock.autohide = true;
  system.defaults.dock.orientation = "left";
  system.defaults.dock.showhidden = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.screencapture.location = "${screenshots-folder}";
  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.finder.FXEnableExtensionChangeWarning = false;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  services.skhd.enable = true;

  #programs.nix-index.enable = true;

  services.nix-daemon.enable = true;
  #  nix.package = pkgs.nixUnstable;

  # SKHD
  services.skhd.skhdConfig = builtins.readFile ./src/skhdrc;

  environment.variables.LANG = "en_US.UTF-8";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (
      self: super: {
        my_vim_configurable = super.vim_configurable.override {
          guiSupport = "no";
        };

        darwin-zsh-completions = super.runCommandNoCC "darwin-zsh-completions-0.0.0"
          { preferLocalBuild = true; }
          ''
            mkdir -p $out/share/zsh/site-functions
            cat <<-'EOF' > $out/share/zsh/site-functions/_darwin-rebuild
            #compdef darwin-rebuild
            #autoload
            _nix-common-options
            local -a _1st_arguments
            _1st_arguments=(
              'switch:Build, activate, and update the current generation'\
              'build:Build without activating or updating the current generation'\
              'check:Build and run the activation sanity checks'\
              'changelog:Show most recent entries in the changelog'\
            )
            _arguments \
              '--list-generations[Print a list of all generations in the active profile]'\
              '--rollback[Roll back to the previous configuration]'\
              {--switch-generation,-G}'[Activate specified generation]'\
              '(--profile-name -p)'{--profile-name,-p}'[Profile to use to track current and previous system configurations]:Profile:_nix_profiles'\
              '1:: :->subcmds' && return 0
            case $state in
              subcmds)
                _describe -t commands 'darwin-rebuild subcommands' _1st_arguments
              ;;
            esac
            EOF
          '';

      }
    )
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 3;

  nix.maxJobs = 8;
  nix.buildCores = 8;
}
