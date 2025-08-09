{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #stylix.url = "github:danth/stylix";
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
    catppuccin.url = "github:catppuccin/nix/release-25.05";
  };

  outputs = { self, nixpkgs, home-manager, 
  #stylix,
   nix-index-database, nur
    , chaotic, nix-alien, catppuccin, ... }@inputs: {
      #System Config
      nixosConfigurations = {
        vladLinux = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            ./modules/audio.nix
            ./modules/users.nix
            #stylix.nixosModules.stylix
            nix-index-database.nixosModules.nix-index
            nur.modules.nixos.default
            chaotic.nixosModules.nyx-cache
            chaotic.nixosModules.nyx-overlay
            chaotic.nixosModules.nyx-registry
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs catppuccin; };
              home-manager.users.vlad = {
                imports = [ ./home.nix catppuccin.homeModules.catppuccin ];
              };
            }
          ];
        };
      };
      homeConfigurations = {
        vlad = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux // {
            nix-alien = nix-alien.packages.x86_64-linux.default;
          };
          modules = [
            ./home.nix
            #inputs.stylix.homeModules.stylix
            catppuccin.homeModules.catppuccin
          ];

          extraSpecialArgs = { inherit inputs; };
        };
      };
      #homeManagerModules = { stylix = stylix.homeModules.stylix; };
      #packages.x86_64-linux.sddm-astronaut =
      #  import ./themes/sddm-astronaut-theme.nix {
      #    inherit (nixpkgs.legacyPackages.x86_64-linux)
      #      lib stdenv fetchFromGitHub;
      #  };
    };
}
