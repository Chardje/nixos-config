{
  lib,
  inputs,
  config,
  pkgs,
  catppuccinLib,
  ...
}:
let

in
{
  imports = [
    #./hyprland.nix
    inputs.catppuccin.homeModules.catppuccin
    inputs.caelestia-shell.homeManagerModules.default
    ../modules/mainconfig.nix
  ];

  catppuccin.enable = true;
  catppuccin.flavor = "frappe";
  catppuccin.accent = "sapphire";

  programs.vscode = {
    profiles.default.extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      christian-kohler.npm-intellisense
      github.copilot
      github.copilot-chat
      jnoortheen.nix-ide
      ms-azuretools.vscode-docker
      ms-dotnettools.csdevkit
      ms-dotnettools.csharp
      ms-dotnettools.vscode-dotnet-runtime
      ms-python.debugpy
      ms-python.python
      ms-python.vscode-pylance
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh-edit
      ms-vsliveshare.vsliveshare
    ];
  };
  services.easyeffects.enable = true;
  services.gammastep = {
    enable = false;
    settings = {
      general = {
        adjustment-method = "randr";
        brightness-day = "1.0";
        brightness-night = "0.9";
      };
      manual = {
        lat = "48.4647";
        lon = "35.0462";
      };
      temperature = {
        day = 5500;
        night = 3700;
      };
    };
  };

  dconf = {
    settings = {
      "org/cinnamon/desktop/applications/terminal" = {
        exec = "foot";
      };
      "org/nemo/desktop" = {
        show-desktop-icons = true;
      };
    };
  };

  home.packages = with pkgs; [
    inputs.nix-alien.packages.${stdenv.hostPlatform.system}.nix-alien
    #papirus-icon-theme
    noto-fonts
    noto-fonts-color-emoji
    liberation_ttf
    source-han-sans
    source-han-serif
    font-awesome
    pkgs.ranger
      pkgs.sway-contrib.grimshot
      pkgs.pavucontrol
      pkgs.pulsemixer
      pkgs.mpvpaper

    #inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
  ];

  fonts.fontconfig.enable = true;

  home.sessionVariables =
    builtins.trace "Waybar style file: ${config.xdg.configHome}/waybar/style.css"
      {
        XDG_DATA_DIRS = "${pkgs.papirus-icon-theme}/share/icons:${pkgs.glib}/share/icons";
      };

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;

  };
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
    };
  };
 
  
  programs = {
    home-manager.enable = true;

    wofi = {
      enable = false;
      settings = {
        show = "drun";
        allow_images = true; # Display application icons
        term = "${pkgs.foot}/bin/foot"; # Terminal to run commands (adjust as needed)
        width = 600;
        height = 400;
        allow_markup = true;
        exec_search = true;
        insensitive = true;
        sort_order = "alphabrtical";
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;

      # 1. Список плагінів (аналог lazy.setup у твоєму init.lua)
      plugins = with pkgs.vimPlugins; [
        # LSP & Completion
        nvim-lspconfig
        mason-nvim
        mason-lspconfig-nvim
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        luasnip
        cmp_luasnip

        # Treesitter & Formatting/Linting
        (nvim-treesitter.withPlugins (p: [
          p.python
          p.rust
          p.lua
          p.markdown
        ]))
        conform-nvim
        nvim-lint

        # UI & Navigation
        telescope-nvim
        telescope-fzf-native-nvim
        catppuccin-nvim
        lualine-nvim

        # DAP
        nvim-dap
        nvim-dap-ui
        plenary-nvim
      ];

      # 2. Додаткові системні пакети (форматери та лінтери)
      # Nix дозволяє встановити їх прямо в оточення Neovim
      extraPackages = with pkgs; [
        # Python
        pyright
        black
        isort
        pylint
        python311Packages.flake8
        # Rust
        rust-analyzer
        rustfmt
        clippy
      ];

      # 3. Твоя Lua конфігурація
      # Ми використовуємо extraLuaConfig, щоб "склеїти" всі твої файли
      initLua = ''
        -- Колірна схема
        vim.cmd.colorscheme("catppuccin-mocha")

        -----------------------------------------------------------
        -- Вміст cmp.lua
        -----------------------------------------------------------
        ${builtins.readFile ./nvim/cmp.lua}

        -----------------------------------------------------------
        -- Вміст conform.lua
        -----------------------------------------------------------
        ${builtins.readFile ./nvim/conform.lua}

        -----------------------------------------------------------
        -- Вміст lint.lua
        -----------------------------------------------------------
        ${builtins.readFile ./nvim/lint.lua}

        -----------------------------------------------------------
        -- Вміст lsp.lua
        -----------------------------------------------------------
        ${builtins.readFile ./nvim/lsp.lua}
      '';
    };

    # Приклад використання стилю для foot (шлях, а не readFile)
    foot = {
      enable = true;
      settings = {
        main = {
          font = "monospace:size=13";
          dpi-aware = "yes";
          pad = "10x10";
          bold-text-in-bright = "yes";
        };
      };
    };
    
    plasma = {
    enable = true;

    #
    # Some high-level settings:
    #
    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      cursor.theme = "Bibata-Modern-Ice";
      iconTheme = "Papirus-Dark";
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";
    };

    hotkeys.commands."launch-konsole" = {
      name = "Launch Konsole";
      key = "Meta+Alt+K";
      command = "konsole";
    };

    panels = [
      # Windows-like panel at the bottom
      {
        location = "bottom";
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
      # Global menu at the top
      {
        location = "top";
        height = 26;
        widgets = [ "org.kde.plasma.appmenu" ];
      }
    ];

    #
    # Some mid-level settings:
    #
    shortcuts = {
      ksmserver = {
        "Lock Session" = [
          "Screensaver"
          "Meta+Ctrl+Alt+L"
        ];
      };

      kwin = {
        "Expose" = "Meta+,";
        "Switch Window Down" = "Meta+J";
        "Switch Window Left" = "Meta+H";
        "Switch Window Right" = "Meta+L";
        "Switch Window Up" = "Meta+K";
      };
    };

    #
    # Some low-level settings:
    #
    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
      "kwinrc"."org.kde.kdecoration2"."ButtonsOnLeft" = "SF";
      "kwinrc"."Desktops"."Number" = {
        value = 8;
        # Forces kde to not change this value (even through the settings app).
        immutable = true;
      };
    };
  };
  };

}
