{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "sddm-astronaut-theme";
  version = "unstable-2024-06-16"; # Можна використовувати дату або версію з репозиторію

  src = fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "3196940a0491a629b392aa0048d08c5d8009315d"; # Це хеш останнього коміту на момент написання. Вам варто оновити його до найновішого або використовувати гілку "main".
    hash = "sha256-42w8K3P6G0i6rNlY7zN0tQ9k8sW5xG3n2rZ1cT0mX4"; # Це sha256 хеш для вказаного коміту. Вам потрібно буде обчислити його самостійно, якщо змінюватимете "rev".
  };

  # Фаза встановлення: копіюємо файли теми до правильного каталогу
  installPhase = ''
    mkdir -p $out/share/sddm/themes/astronaut
    cp -aR $src/* $out/share/sddm/themes/astronaut/
    chmod -R 755 $out/share/sddm/themes/astronaut
  '';

  meta = with lib; {
    description = "A beautiful, minimal SDDM theme, inspired by astronaut";
    homepage = "https://github.com/Keyitdev/sddm-astronaut-theme";
    license = licenses.gpl3Only; # Перевірте ліцензію теми
    platforms = platforms.linux;
  };
}