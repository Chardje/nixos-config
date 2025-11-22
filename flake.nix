{
  description = "NixOS configuration";

  nixConfig = {
    download-buffer-size = "134217728";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix25.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager25 = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nix25";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-alien.url = "github:thiagokokada/nix-alien";
    catppuccin.url = "github:catppuccin/nix/release-25.05";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib.url = "github:hyprwm/contrib";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
        # to have it up-to-date or simply don't specify the nixpkgs input
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix25,
      home-manager,
      home-manager25,
      nix-index-database,
      nur,
      chaotic,
      nix-alien,
      catppuccin,
      caelestia-shell,
      zen-browser,
      hyprland,
      illogical-flake,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          nur.overlays.default
        ];
        config.allowUnfree = true;
      };
      hyprlandpkgs41 = import inputs.hyprland41 {
        inherit system;
        overlays = [
          (self: super: {
            hyprland = super.hyprland.overrideAttrs (old: {
              buildInputs = (old.buildInputs or [ ]) ++ [ inputs.epoll-shim.packages.${system}.default ];
            });
          })
        ];

      };

      # Стабільні пакети для ISO
      pkgs25 = import nix25 {
        inherit system;
        overlays = [
          nur.overlays.default
        ];
        config.allowUnfree = true;
      };
    in
    {
      packages.${system} = {
        pixus = self.nixosConfigurations.pixus.config.system.build.isoImage;
      };
      # ---------------------- NixOS Configurations ----------------------
      nixosConfigurations = {
        laptop = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs25; };
          modules = [
            ./host/laptop
            ./modules/users.nix
          ];
        };
        # --- Основна система ---
        vladLinux = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs pkgs25; };
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
          inherit system;
          specialArgs = { inherit inputs pkgs25; };
          modules = [
            "${pkgs25.path}/nixos/modules/installer/cd-dvd/installation-cd-graphical-base.nix"
            # Твій кастомний конфіг
            ./host/pixus/configuration.nix
          ];
        };

      };

      # ---------------------- Home Manager Configs ----------------------
      homeConfigurations = {
        vlad = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs;
            "xkeyboard-config" = nixpkgs.legacyPackages.x86_64-linux.xkeyboard_config;
          };
          modules = [ ./homes/hyprland25/home.nix ];
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
