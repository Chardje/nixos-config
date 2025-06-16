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

  outputs = { self, nixpkgs, home-manager, stylix, nix-index-database, nur
    , chaotic, nix-alien, ... }@inputs: {
      #System Config
      nixosConfigurations = {
        vladLinux = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            ./modules/audio.nix
            ./modules/progs-and-pkgs.nix
            ./modules/users.nix
            #"${inputs.nixpkgs}/nixos/modules/services/x11/display-managers/gdm.nix"
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            nix-index-database.nixosModules.nix-index
            nur.modules.nixos.default
            chaotic.nixosModules.nyx-cache
            chaotic.nixosModules.nyx-overlay
            chaotic.nixosModules.nyx-registry
          ];
        };
      };
      homeConfigurations = {
        vlad = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux // {
            nix-alien = nix-alien.packages.x86_64-linux.default;
            dracula-icon-theme =
              nixpkgs.legacyPackages.x86_64-linux.dracula-icon-theme;
          };
          modules = [ ./home.nix inputs.stylix.homeModules.stylix ];

          extraSpecialArgs = { inherit inputs; };
        };
      };
      homeManagerModules = { stylix = stylix.homeModules.stylix; };
      #packages.x86_64-linux.home-manager = nixpkgs.legacyPackages.x86_64-linux.home-manager;
      packages.x86_64-linux.sddm-astronaut =
        import ./themes/sddm-astronaut-theme.nix {
          inherit (nixpkgs.legacyPackages.x86_64-linux)
            lib stdenv fetchFromGitHub;
        };
    };
}
