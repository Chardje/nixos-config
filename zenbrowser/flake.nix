{
  description = "Zen Browser package";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    packages.${system}.default = pkgs.stdenvNoCC.mkDerivation {
      pname = "zen-browser";
      version = "1.17.4b";
      src = pkgs.fetchurl {
        url = "https://github.com/zen-browser/desktop/releases/download/1.17.4b/zen.linux-x86_64.tar.xz";
        sha256 = "1ww5wmc769a3i8bp4b40kynyhl4j47xmz0pgb3li8hn51dqal5zp";
      };

      nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.makeWrapper pkgs.zstd ];
      dontUnpack = true;

      installPhase = ''
        mkdir -p $out/opt/zen
        tar -xJf $src -C $out/opt/zen --strip-components=1
        mkdir -p $out/bin
        ln -s $out/opt/zen/zen $out/bin/zen-browser
      '';

      meta = with pkgs.lib; {
        description = "Privacy-focused browser based on Firefox";
        homepage = "https://zen-browser.app";
        license = licenses.mpl20;
        platforms = platforms.linux;
      };
    };
  };
}
