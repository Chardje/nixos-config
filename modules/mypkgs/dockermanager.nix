# /etc/nixos/mypkgs/dockermanager.nix
{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "cockpit-dockermanager";
  version = "1.0.7";

  src = pkgs.fetchurl {
    url = "https://github.com/chrisjbawden/cockpit-docker-manager/raw/refs/heads/main/dockermanager.tar";
    sha256 = "16r7gqlg6l37wrg0fdy37y3p6yr8iqlajrzv45v35piypa6xh5z2"; # заміни після перевірки
  };

  unpackPhase = "true"; # ми самі розпакуємо

  installPhase = ''
    mkdir -p $out/share/cockpit/dockermanager
    tar -xf $src -C $out/share/cockpit/dockermanager
  '';

  meta = with pkgs.lib; {
    description = "Docker Manager plugin for Cockpit web UI";
    homepage = "https://github.com/chrisjbawden/cockpit-docker-manager";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
