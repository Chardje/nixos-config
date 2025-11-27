{ inputs,pkgs,lib,... }: # Make sure the flake inputs are in your system's config
let

nix-modrinth-prefetch = inputs.nix-minecraft.packages.${pkgs.system}.nix-modrinth-prefetch;
  # Модпак SOP: Використовуй fetchMrpack з nix-prefetch-mrpack (краще), або fetchzip як тимчасово
  
  sopMods =  pkgs.linkFarmFromDrvs "optimised-mods" (builtins.attrValues {
      # ←←← ТУТ УСІ 16 модів з правильними SHA512 ←←←

      fabric-api = pkgs.fetchurl {
        url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/CF23l2iP/fabric-api-0.133.4+1.21.8.jar";
        sha512 = "e3cc9f8f60d655c916b2d31ca2a77fc15187e443e3bb8a5977dcff7a704401e8a39d633e12a649207a5923e540b6474e90f08c95655d07ae1c790d5c8aff41a5";
      };

      vmp = pkgs.fetchurl {
        url = "https://cdn.modrinth.com/data/wnEe9KBa/versions/KvcCuByh/vmp-fabric-mc1.21.8-0.2.0+beta.7.207-all.jar";
        sha512 = "1ae5f0ddf1f037c1cd7cc580168f57394c86f197203ef19ee1232cf327ab82c66d10d5baf431bf2d880fb2127c264e0749dc7c7b79eb1ede8cd1cbd9cc6b5221";
      };

      noisium = pkgs.fetchurl {
        url = "https://cdn.modrinth.com/data/KuNKN7d2/versions/V9mMIy0f/noisium-fabric-2.7.0+mc1.21.6.jar";
        sha512 = "80cc286f3a51b2d12304ef6a44f84c11d67cedec1a02fbaf59e2e816d9b5f0abd17cc6b5a0ca5880935e9dadfea3b951b790ee1e54300c009bc419c1c7451785";
      };

      immediatelyfast = pkgs.fetchurl {
        url = "https://cdn.modrinth.com/data/5ZwdcRci/versions/XxwOC2sk/ImmediatelyFast-Fabric-1.12.1+1.21.8.jar";
        sha512 = "5277ba33c2f8255c65946a9e785a046d1c211aa974e679d881b9a259a50f42fc5f77a92d620a377d5992c66fa1ca581bb2fd902d1f93cdced4318fc2b10e45a8";
      };

      lithium = pkgs.fetchurl {
        url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/pDfTqezk/lithium-fabric-0.18.0+mc1.21.8.jar";
        sha512 = "6c69950760f48ef88f0c5871e61029b59af03ab5ed9b002b6a470d7adfdf26f0b875dcd360b664e897291002530981c20e0b2890fb889f29ecdaa007f885100f";
      };

      entityculling = pkgs.fetchurl {
        url = "https://cdn.modrinth.com/data/NNAgCjsB/versions/Qu62cqxc/entityculling-fabric-1.8.2-mc1.19.4.jar";
        sha512 = "a3a7dafae7defddae985f03ad7cf5c5b511352ceb8467c4d87245180375a1db2ebbec5ae709de687f64a6a157ea7669eda7c0be8e64b12dc71f38cf0b6a6eb49";
      };

      badoptimizations = pkgs.fetchurl {
        url = "https://cdn.modrinth.com/data/g96Z4WVZ/versions/RPOjbIwJ/BadOptimizations-2.3.0-1.20.1.jar";
        sha512 = "288638bd5e4d9163205006ddc06eb6d962abcf9c49b602eeef3389e56184deee7844037a7cd41f770d6088a063756380afe1a6c456668356dd56b238834c3c49";
      };

      cloth-config = pkgs.fetchurl {
        url = "https://cdn.modrinth.com/data/9s6osm5g/versions/cz0b1j8R/cloth-config-19.0.147-fabric.jar";
        sha512 = "924b7e9bf6da670b936c3eaf3a2ba7904a05eff4fd712acf8ee62e587770c05a225109d3c0bdf015992e870945d2086aa00e738f90b3b109e364b0105c08875a";
      };

      no-chat-reports = pkgs.fetchurl {
        url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/LhwpK0O6/NoChatReports-FABRIC-1.21.7-v2.14.0.jar";
        sha512 = "6e93c822e606ad12cb650801be1b3f39fcd2fef64a9bb905f357eb01a28451afddb3a6cadb39c112463519df0a07b9ff374d39223e9bf189aee7e7182077a7ae";
      };

      scalablelux = pkgs.fetchurl {
        url = "https://cdn.modrinth.com/data/Ps1zyz6x/versions/Bi5i8Ema/ScalableLux-0.1.5.1+fabric.abdeefa-all.jar";
        sha512 = "421e1691e8d9506def48910bb15c99413eaf69b1c4fe5b729f513f4c2e1cd25ddb8155397e9c9ebab353ce72850a7ca62619c85fdd06d39bc87cfa7520af0281";
      };

      ferritecore = pkgs.fetchurl {
        url = "https://cdn.modrinth.com/data/uXXizFIs/versions/CtMpt7Jr/ferritecore-8.0.0-fabric.jar";
        sha512 = "131b82d1d366f0966435bfcb38c362d604d68ecf30c106d31a6261bfc868ca3a82425bb3faebaa2e5ea17d8eed5c92843810eb2df4790f2f8b1e6c1bdc9b7745";
      };

      sodium = pkgs.fetchurl {
        url = "https://cdn.modrinth.com/data/AANobbMI/versions/ND4ROcMQ/sodium-fabric-0.6.13+mc1.21.6.jar";
        sha512 = "ee97e3df07a6f734bc8a0f77c1f1de7f47bed09cf682f048ceb12675c51b70ba727b11fcacbb7b10cc9f79b283dd71a39751312b5c70568aa3ac9471407174db";
      };

      threadtweak = pkgs.fetchurl {
        url = "https://cdn.modrinth.com/data/vSEH1ERy/versions/IvtlnXcT/threadtweak-fabric-0.1.7+mc1.21.5.jar";
        sha512 = "aec7e39b478d47dc96ba12291fd048ed9253c39d27a0c25b8565b3cef08eb5117b4f6bf2453c3377d2de739de8ba0501c77b291b6f0fc82559f0f30514a9125a";
      };

      moreculling = pkgs.fetchurl {
        url = "https://cdn.modrinth.com/data/51shyZVL/versions/xxS7FR4H/moreculling-neoforge-1.21.6-1.4.0-beta.1.jar";
        sha512 = "c61255847b0a353bb80aa3a731e87f9087cd8f71c4d7f1864ded16634dc174daf0d45a3a104e9de6b5c0ba5035a930649429f887ae1a7d41e8bd1c04a3ab6417";
      };

      c2me = pkgs.fetchurl {
        url = "https://cdn.modrinth.com/data/VSNURh3q/versions/7lwPGYpL/c2me-fabric-mc1.21.8-0.3.5+alpha.0.8.jar";
        sha512 = "d02ce60e3816326657e40a4cff8e1fdaea1911d8b429e82b23cde997f61c78ed0f68f32f7f57a58069cda624b688cabb863cba17a3d251eed32d6b17dabf70fc";
      };

      # Якщо ще хочеш ModernFix (дуже рекомендую для швидкого старту)
      # modernfix = pkgs.fetchurl {
      #   url = "https://cdn.modrinth.com/data/ArcqTote/versions/5.20.4-beta.51+mc1.21.7/modernfix-fabric-5.20.4-beta.51+mc1.21.7.jar";
      #   sha512 = "тут твій хеш, якщо захочеш додати";
      # };
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
      serverProperties = {
      difficulty = "hard";
      enable-command-block = "false";
      motd = "Speed";
      online-mode = "false";
      pause-when-empty-seconds = "60";  # Дефолт з 1.21.2, але ти маєш — лишив для впевненості
      require-resource-pack = "true";
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
}
