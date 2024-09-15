{ rust-overlay, ... }:
{ config, pkgs, ... }:
{
  imports = [
    ./src/dotconfig/c.nix
    ./src/yabai/service.nix
    ./src/common.nix
    ./src/zsh/c.nix
    ./src/vim/c.nix
  ];

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

    # Regenerate .gitignore
    echo "regenerating global .gitignore..."
    cat ${./src/gitignore} > ~/.gitignore
    git config --global core.excludesfile ~/.gitignore

    # Regenerate ~/.vim files
    echo "regenerating ~/.vim files..."
    mkdir -p ~/.vim
    cat ${./src/vim/coc-settings.json} > ~/.vim/coc-settings.json

    echo "regenerating ~/.direnvrc..."
    echo "source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc" > ~/.direnvrc
  '';

  environment.systemPackages = [
    config.programs.vim.package
  ];

  environment.extraOutputsToInstall = [ "man" ];

  system.defaults.NSGlobalDomain.InitialKeyRepeat = 12;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;
  system.defaults.dock.autohide = true;
  system.defaults.dock.orientation = "left";
  system.defaults.dock.showhidden = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.finder.FXEnableExtensionChangeWarning = false;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  services.skhd.enable = true;

  services.nix-daemon.enable = true;

  # SKHD
  services.skhd.skhdConfig = builtins.readFile ./src/skhdrc;

  environment.variables.LANG = "en_US.UTF-8";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (import rust-overlay)
    (self: super: {
      rustPlatform = super.makeRustPlatform {
        cargo = super.rust-bin.stable.latest.default;
        rustc = super.rust-bin.stable.latest.default;
      };
    })
    (
      self: super: {
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

  nix.settings.max-jobs = 16;
  nix.settings.cores = 16;

  nix.settings.trusted-users = [ "root" "bkase" ];
  nix.settings.substituters = [ "https://cache.nixos.org" "https://storage.googleapis.com/mina-nix-cache" ];
  nix.package = pkgs.nixVersions.latest;
  nix.extraOptions = ''
    extra-platforms = aarch64-darwin x86_64-darwin
    experimental-features = nix-command flakes
  '';
}
