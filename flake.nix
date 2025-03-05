{
  description = "Brandon's darwin system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, rust-overlay }:
    let
      system = "aarch64-darwin";
      hostname = "Brandons-MacBook-Pro";
      
      # Overlays
      overlays = [
        (import rust-overlay)
        (self: super: {
          rustPlatform = super.makeRustPlatform {
            cargo = super.rust-bin.stable.latest.default;
            rustc = super.rust-bin.stable.latest.default;
          };
        })
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
        })
      ];
      
      # Base configuration module
      baseConfig = { config, pkgs, ... }: {
        # Lorri daemon service
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

        # Post-activation scripts
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

        # Environment configuration
        environment = {
          systemPackages = [ config.programs.vim.package ];
          extraOutputsToInstall = [ "man" ];
          variables.LANG = "en_US.UTF-8";
        };

        # System defaults
        system.defaults = {
          NSGlobalDomain = {
            InitialKeyRepeat = 12;
            KeyRepeat = 1;
            "com.apple.swipescrolldirection" = false;
          };
          dock = {
            autohide = true;
            orientation = "left";
            showhidden = true;
            mru-spaces = false;
          };
          finder = {
            AppleShowAllExtensions = true;
            QuitMenuItem = true;
            FXEnableExtensionChangeWarning = false;
          };
        };

        # Keyboard configuration
        system.keyboard = {
          enableKeyMapping = true;
          remapCapsLockToControl = true;
        };

        # Nix daemon and services
        services.nix-daemon.enable = true;

        # Nixpkgs configuration
        nixpkgs = {
          config.allowUnfree = true;
          overlays = overlays;
        };

        # Nix configuration
        nix = {
          settings = {
            max-jobs = 16;
            cores = 16;
            trusted-users = [ "root" "bkase" ];
            substituters = [ 
              "https://cache.nixos.org" 
              "https://storage.googleapis.com/mina-nix-cache" 
            ];
          };
          package = pkgs.nixVersions.latest;
          extraOptions = ''
            extra-platforms = aarch64-darwin x86_64-darwin
            experimental-features = nix-command flakes
          '';
        };

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 3;
      };
    in {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          # Import all module files directly
          ./src/dotconfig/c.nix
          ./src/common.nix
          ./src/zsh/c.nix
          ./src/vim/c.nix
          baseConfig
        ];
        specialArgs = { inherit inputs; };
      };
    };
}
