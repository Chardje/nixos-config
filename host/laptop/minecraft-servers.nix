{ inputs,pkgs,lib,... }: # Make sure the flake inputs are in your system's config
let

nix-modrinth-prefetch = inputs.nix-minecraft.packages.${pkgs.system}.nix-modrinth-prefetch;
  # Модпак SOP: Використовуй fetchMrpack з nix-prefetch-mrpack (краще), або fetchzip як тимчасово
 



sopMods = pkgs.linkFarmFromDrvs "optimised-mods" (builtins.attrValues {
  "fabric-api" = pkgs.fetchurl {
    url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/g58ofrov/fabric-api-0.136.1%2B1.21.8.jar";
    sha512 = "eb1a6b5fc9912c68409493f10f43c3b61adda1d789ede9c83b16d0a95a2eb96bd630472866e163960479eb1b4d1196d09ade5aadc9da62624e800640c706c4a9";
  };
  lithium = pkgs.fetchurl {
    url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/pDfTqezk/lithium-fabric-0.18.0+mc1.21.8.jar";
    sha512 = "6c69950760f48ef88f0c5871e61029b59af03ab5ed9b002b6a470d7adfdf26f0b875dcd360b664e897291002530981c20e0b2890fb889f29ecdaa007f885100f";
  };
  ferritecore = pkgs.fetchurl {
    url = "https://cdn.modrinth.com/data/uXXizFIs/versions/CtMpt7Jr/ferritecore-8.0.0-fabric.jar";
    sha512 = "131b82d1d366f0966435bfcb38c362d604d68ecf30c106d31a6261bfc868ca3a82425bb3faebaa2e5ea17d8eed5c92843810eb2df4790f2f8b1e6c1bdc9b7745";
  };
  noisium = pkgs.fetchurl {
    url = "https://cdn.modrinth.com/data/hasdd01q/versions/zWsMzA7t/noisium-fabric-2.7.0%2Bmc1.21.6-8.jar";
    sha512 = "84fd80cfbe3fe5e3997e3d284a2b604845383a482622ad738fc36c839d55ada86311551a1a60f759d82fd009be7c79f27928d183524fd15da77b415ceb24a579";
  };
  vmp = pkgs.fetchurl {
    url = "https://cdn.modrinth.com/data/wnEe9KBa/versions/KvcCuByh/vmp-fabric-mc1.21.8-0.2.0+beta.7.207-all.jar";
    sha512 = "1ae5f0ddf1f037c1cd7cc580168f57394c86f197203ef19ee1232cf327ab82c66d10d5baf431bf2d880fb2127c264e0749dc7c7b79eb1ede8cd1cbd9cc6b5221";
  };
}); 

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
    servers = {
      vanilla = {
        enable = true;
        autoStart=false;
        package = pkgs.fabricServers.fabric-1_21_8; # або інша версія

        jvmOpts = "-Xmx4G -Xms4G -XX:+UseG1GC"; # 4 ГБ RAM, можна змінювати

        serverProperties = {
          motd = "Мій маленький сервер на NixOS!";
          difficulty = "normal";
          gamemode = "survival";
          white-list = false;
          pvp = true;
          max-players = 20;
          server-port = 25566;
        };
      };
  
    speedruner = {
      enable = true;
      autoStart=false;
      # Specify the custom minecraft server package
      package = pkgs.fabricServers.fabric-1_21_8; # Specific fabric loader version
      symlinks = {
        mods = sopMods;  # Автоматично всі мод з пака
      };

      serverProperties = {
        server-port = 25567;
        difficulty = "hard";
        enable-command-block = "false";
        #motd = "Speed";
        online-mode = "true";
        pause-when-empty-seconds = "60";  # Дефолт з 1.21.2, але ти маєш — лишив для впевненості
        #require-resource-pack = "true";
        spawn-protection = "0";
        view-distance = "16";
      };
      jvmOpts = [
        "-Xmx6G"
        "-XX:+UnlockExperimentalVMOptions"
        "-XX:+UseG1GC"
        "-XX:G1NewSizePercent=20"
        "-XX:G1ReservePercent=20"
        "-XX:MaxGCPauseMillis=50"
        "-XX:G1HeapRegionSize=32M"
      ];
    };
   };
  };




}
