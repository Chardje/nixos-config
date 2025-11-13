{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix25.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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

    hyprland-contrib.url = "github:hyprwm/contrib";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-alien.url = "github:thiagokokada/nix-alien";
    catppuccin.url = "github:catppuccin/nix/release-25.05";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix25,
      home-manager,
      nix-index-database,
      nur,
      chaotic,
      nix-alien,
      catppuccin,
      caelestia-shell,
      zen-browser,
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
      # Стабільні пакети для ISO
      pkgs25 = import nix25 {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages.${system} = {
        pixus = self.nixosConfigurations.pixus.config.system.build.isoImage;
      };
      # ---------------------- NixOS Configurations ----------------------
      nixosConfigurations = {

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
      };
    };
}
