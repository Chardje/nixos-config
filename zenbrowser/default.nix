{ lib, stdenvNoCC, fetchurl, makeWrapper }:

stdenvNoCC.mkDerivation rec {
  pname = "zen-browser";
  version = "1.17.4b";

  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.linux-x86_64.tar.xz";
    sha256 = "1ww5wmc769a3i8bp4b40kynyhl4j47xmz0pgb3li8hn51dqal5zp"; # заміни після перевірки
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/opt/${pname}
    tar -xJf $src -C $out/opt/${pname} --strip-components=1
    mkdir -p $out/bin
    makeWrapper $out/opt/${pname}/zen $out/bin/${pname}
  '';

  meta = {
    description = "Privacy-focused browser that blocks trackers and ads.";
    homepage = "https://github.com/zen-browser/desktop";
    license = lib.licenses.mpl20;
    platforms = [ "x86_64-linux" ];
  };
}
