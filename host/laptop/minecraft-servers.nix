{ inputs, ... }: # Make sure the flake inputs are in your system's config
let


  # Модпак SOP: Використовуй fetchMrpack з nix-prefetch-mrpack (краще), або fetchzip як тимчасово
  sopMrpack = inputs.nix-minecraft.packages.${pkgs.system}.fetchMrpack rec {  # Якщо доступно в flake
    pname = "simply-optimized";
    version = "1.21.8-1.0.2";
    url = "https://cdn.modrinth.com/data/BYfVnHa7/versions/DE1gxbAW/Simply%20Optimized-1.21.8-1.0.2.mrpack";
    sha256 = "sha256-РЕАЛЬНИЙ_HASH_З_nix-prefetch-mrpack";  # Запусти інструмент!
    manifestHash = "sha256-РЕАЛЬНИЙ_MANIFEST_HASH";  # З інструменту
  };
  # Або fallback без розпакування (якщо інструмент не спрацює — mods не автоматично):
  # sopMrpack = pkgs.fetchurl {
  #   url = "https://cdn.modrinth.com/data/BYfVnHa7/versions/DE1gxbAW/Simply%20Optimized-1.21.8-1.0.2.mrpack";
  #   sha256 = "sha256-РЕАЛЬНИЙ_HASH_З_nix-prefetch-url_БЕЗ_--unpack";  # Обчисли: nix-prefetch-url URL
  # };

  # Автоматичні mods з mrpack (якщо fetchMrpack):
  sopMods = sopMrpack.mods;  # Готовий linkFarmFromDrvs з усіма .jar

  # Датапак: Твій hash готовий!
  compassTracker = pkgs.fetchurl {
    url = "https://cdn.modrinth.com/data/GvG2CaJa/versions/A6emm30W/Compass-Tracker.zip";
    sha256 = "sha256-19mcxvhjy7mzdpjw48qckzw7w4vgfizbkl4li8wm3sz7qiw80lss";
  };

in
{

  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
  
  services.minecraft-servers={
  enable = true;
    eula = true;
    openFirewall = true;
    servers.speedruner = {
      enable = true;
      autoStart=false;
      # Specify the custom minecraft server package
      package = pkgs.fabricServers.fabric-1_21_8; # Specific fabric loader version
      symlinks = {
        mods = sopMods;  # Автоматично всі мод з пака
      };

      files = {
        "world/datapacks/Compass-Tracker.zip" = compassTracker;  # Готовий!
      };
    };

  };
}
