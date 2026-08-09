{
  description = "NixOS configuration";

  nixConfig = {
    download-buffer-size = "134217728";
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixStable.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager25 = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixStable";
    };
    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixStable";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi";
      inputs.nixpkgs.follows = "nixStable"; # або окремо, залежно від сумісності версій
    };
    sops-nix.url = "github:Mic92/sops-nix";
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #fufexan-dotfiles = {
    #  url = "github:fufexan/dotfiles";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    illogical-flake = {
      url = "github:soymou/illogical-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    infrared.url = "github:Chardje/Infrared-nix";  
    infrared.inputs.nixpkgs.follows = "nixpkgs";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-alien.url = "github:thiagokokada/nix-alien";
    catppuccin.url = "github:catppuccin/nix/release-26.05";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprland-contrib.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
        # to have it up-to-date or simply don't specify the nixpkgs input
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    fbc.url = "github:Chardje/firefly-iii-bank-sync/develop";
    bluetti-mqtt.url = "github:Chardje/nix_bluetti_mqtt";
    stm32cubeide.url = "git+https://git.sr.ht/~shelvacu/stm32cubeide-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixStable,
      home-manager,
      home-manager25,
      nix-index-database,
      nur,
      nixos-raspberrypi,
      chaotic,
      nix-alien,
      catppuccin,
      caelestia-shell,
      zen-browser,
      hyprland,
      infrared,
      illogical-flake,
      arion,
      sops-nix,
      bluetti-mqtt,
      stm32cubeide,
      plasma-manager,
      fbc,
      ...
    }@inputs:
    let
      systemX64 = "x86_64-linux";
      systemARM = "aarch64-linux";
      lib = nixpkgs.lib;
      libStable = nixStable.lib;

      pkgs = import nixpkgs {
        system = systemX64;
        overlays = [
          nur.overlays.default
          stm32cubeide.overlays.default

        ];
        config.allowUnfree = true;
      };
      hyprlandpkgs41 = import inputs.hyprland41 {
        system = systemX64;
        overlays = [
          (self: super: {
            hyprland = super.hyprland.overrideAttrs (old: {
              buildInputs = (old.buildInputs or [ ]) ++ [ inputs.epoll-shim.packages.${systemX64}.default ];
            });
          })
        ];

      };

      # Стабільні пакети для ISO
      pkgsStable = import nixStable {
        system = systemX64;
        overlays = [
          nur.overlays.default
        ];
        config.allowUnfree = true;
      };
      pkgsStableArm = import nixStable {
        system = systemARM;
        config.allowUnfree = true;
        config.allowBroken = true;
      };
    in
    {
      packages.${systemX64} = {    
        pixus = self.nixosConfigurations.pixus.config.system.build.isoImage;
      };
      # ---------------------- NixOS Configurations ----------------------
      nixosConfigurations = {
        # --- Ноут серв ---
        laptop = lib.nixosSystem {
          system = systemX64;
          specialArgs = { inherit inputs pkgsStable; };
          modules = [
            ./host/laptop
            ./modules/users.nix
            sops-nix.nixosModules.sops
            infrared.nixosModules.infrared
            # ./modules/users.nix
	        {
	          nix.settings.experimental-features = "nix-command flakes";
        	}
          ];
        };
        # --- Пай серв ---
        nixpi = libStable.nixosSystem {
          system = systemARM;
          specialArgs = {
            inherit pkgsStableArm;
            inherit (inputs) nixos-raspberrypi;
            bluettiModule = bluetti-mqtt.nixosModules.default;
          };
          modules = [
            nixos-raspberrypi.lib.inject-overlays
            nixos-raspberrypi.nixosModules.trusted-nix-caches
            nixos-raspberrypi.nixosModules.raspberry-pi-4.base
            ./host/nixpi
            ./host/nixpi/bootPi4.nix
            sops-nix.nixosModules.sops
            arion.nixosModules.arion
            bluetti-mqtt.nixosModules.default
            fbc.nixosModules.default
          ];
        };
        # --- Пай серв тест VM---
        nixpiVM = libStable.nixosSystem {
          system = systemX64;
          specialArgs = {
            inherit pkgsStable;
            bluettiModule = bluetti-mqtt.nixosModules.default;
          };
          modules = [
            ./host/nixpi
            ./host/nixpi/bootVM.nix
            sops-nix.nixosModules.sops
            arion.nixosModules.arion
            bluetti-mqtt.nixosModules.default
            fbc.nixosModules.default
          ];

        };
        # --- Основна система ---
        vladLinux = lib.nixosSystem {
          system = systemX64;
          specialArgs = { inherit inputs pkgs pkgsStable; };
          modules = [
            ./host/vladLinux/configuration.nix
            ./modules/audio.nix
            ./modules/users.nix
            nix-index-database.nixosModules.nix-index
            chaotic.nixosModules.nyx-cache
            chaotic.nixosModules.nyx-overlay
            chaotic.nixosModules.nyx-registry
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs catppuccin; };
              nix.settings = {
                cores = 4;
                max-jobs = 8;
              };
            }
          ];
        };

        # --- Планшет Pixus taskTab 10.1 3G ---
        pixus = lib.nixosSystem {
          system = systemX64;
          specialArgs = { inherit inputs pkgsStable; };
          modules = [
            "${pkgsStable.path}/nixos/modules/installer/cd-dvd/installation-cd-graphical-base.nix"
            # Твій кастомний конфіг
            ./host/pixus/configuration.nix
            sops-nix.nixosModules.sops
          ];
        };

      };

      devShells = {
        ${systemX64} = {
          # nix develop .#GNS
          GNS = pkgs.mkShell {
            buildInputs = [
              pkgs.gns3-gui
              pkgs.gns3-server
              pkgs.dynamips
              pkgs.qemu
              pkgs.ubridge
            ];
            shellHook = ''
              export UBRIDGE_PATH=/run/wrappers/bin/ubridge
              export GNS3_NO_SET_CAP=1
            '';
          };
        };
      };

      # ---------------------- Home Manager Configs ----------------------
      homeConfigurations = {
        vlad = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs catppuccin;
            "xkeyboard-config" = nixpkgs.legacyPackages.x86_64-linux.xkeyboard_config;
          };
          modules = [ ./homes/hyprland25/home.nix ];
        };
        kde = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs;
            "xkeyboard-config" = nixpkgs.legacyPackages.x86_64-linux.xkeyboard_config;
          };
          modules = [
            inputs.plasma-manager.homeModules.plasma-manager
            ./homes/kde/home.nix
          ];
        };
        end = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            ./homes/end/home.nix
            illogical-flake.homeManagerModules.default
            {
              programs.illogical-impulse.enable = true;
            }
          ];
        };
      };
    };
}
