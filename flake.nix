{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";    
    stylix.url = "github:danth/stylix";
    nix-index-database = {
        url = "github:nix-community/nix-index-database";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-alien.url = "github:thiagokokada/nix-alien";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    nix-index-database,
    nur,
    chaotic,
    nix-alien,
    ...
  } @ inputs: {
    #System Config
    nixosConfigurations = {
      vladLinux = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./configuration.nix
          ./modules/audio.nix 
          ./modules/progs-and-pkgs.nix
          ./modules/users.nix 
          ./modules/style.nix
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          nix-index-database.nixosModules.nix-index
          nur.modules.nixos.default
          chaotic.nixosModules.nyx-cache
          chaotic.nixosModules.nyx-overlay
          chaotic.nixosModules.nyx-registry
        ];
      };
      homeManagerModules = {
        stylix = stylix.homeModules.stylix;
      };
    };
    
  };
}