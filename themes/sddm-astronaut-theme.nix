{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "sddm-astronaut-theme";
  version =
    "unstable-2024-06-16"; # Можна використовувати дату або версію з репозиторію

  src = fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "bf4d01732084be29cedefe9815731700da865956";
    hash = "sha256-JMCG7oviLqwaymfgxzBkpCiNi18BUzPGvd3AF9BYSeo=";
  };

  # Фаза встановлення: копіюємо файли теми до правильного каталогу
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/sddm/themes/astronaut
    cp -r $src/* $out/share/sddm/themes/astronaut
    runHook postInstall
  '';

  meta = with lib; {
    description = "A beautiful, minimal SDDM theme, inspired by astronaut";
    homepage = "https://github.com/Keyitdev/sddm-astronaut-theme";
    license = licenses.gpl3Only; # Перевірте ліцензію теми
    platforms = platforms.linux;
  };
}
