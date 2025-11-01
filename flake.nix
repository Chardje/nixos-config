{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #stylix.url = "github:danth/stylix";
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
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-alien.url = "github:thiagokokada/nix-alien";
    catppuccin.url = "github:catppuccin/nix/release-25.05";
    
    zenbrowser.url = "path:./zenbrowser";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-index-database,
      nur,
      chaotic,
      nix-alien,
      catppuccin,
      caelestia-shell,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nur.overlay ];
        config.allowUnfree = true;
      };
    in
    {
      #System Config
      nixosConfigurations = {
        vladLinux = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs pkgs; };
          modules = [
            ./configuration.nix
            ./modules/audio.nix
            ./modules/users.nix
            nix-index-database.nixosModules.nix-index
            #nur.modules.nixos.default
            chaotic.nixosModules.nyx-cache
            chaotic.nixosModules.nyx-overlay
            chaotic.nixosModules.nyx-registry
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs catppuccin; };
            }
          ];
        };
      };
      homeConfigurations = {
        vlad = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs;
            "xkeyboard-config" = nixpkgs.legacyPackages.x86_64-linux.xkeyboard_config;
          };
          modules = [
            ./home.nix
          ];
        };
      };

    };
}
