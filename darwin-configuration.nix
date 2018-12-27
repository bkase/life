{ config, pkgs, ... }:

{
  imports = [
    ./src/common.nix
    ./src/zsh/c.nix
    ./src/vim/c.nix
  ];

  environment.systemPackages = [ config.services.chunkwm.package ];

  environment.extraOutputsToInstall = [ "man" ];

  system.defaults.NSGlobalDomain.InitialKeyRepeat = 12;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.dock.autohide = true;
  system.defaults.dock.orientation = "left";
  system.defaults.dock.showhidden = true;
  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.finder.FXEnableExtensionChangeWarning = false;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  services.chunkwm.enable = true;
  services.skhd.enable = true;

  #programs.nix-index.enable = true;

  services.nix-daemon.enable = true;
#  nix.package = pkgs.nixUnstable;

  # ChunkWM (TODO)
  services.chunkwm.package = pkgs.chunkwm;
  services.chunkwm.hotload = false;
  services.chunkwm.extraConfig = builtins.readFile ./src/chunkwmrc;
#  services.chunkwm.plugins.dir = "${lib.getOutput "out" pkgs.chunkwm}/lib/chunkwm/plugins";
#  services.chunkwm.plugins.list = [ "ffm" "tiling" ];
#  services.chunkwm.plugins."tiling".config = ''
#    chunkc set global_desktop_mode   bsp
#  '';

  # SKHD
  services.skhd.skhdConfig = builtins.readFile ./src/skhdrc;

  environment.variables.LANG = "en_US.UTF-8";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (self: super: {
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

      # Fake package, not in nixpkgs.
      chunkwm = super.runCommandNoCC "chunkwm-0.0.0" {} ''
        mkdir $out
      '';
    })
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 3;

  nix.maxJobs = 8;
  nix.buildCores = 8;
}
