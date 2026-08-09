{ pkgs ? import <nixpkgs> { } }:

let
  pathsrc = /etc/nixos/mypkgs/pppwndir/pppwn.zip; # вкажи свій фактичний шлях (.zip або .tar.gz)
in
pkgs.stdenv.mkDerivation {
  pname = "pppwn";
  version = "1.0.0";

  src = pathsrc;

  nativeBuildInputs = [ pkgs.unzip pkgs.gzip ];

  buildPhase = "true";

  # розпаковуємо у тимчасову директорію, не покладаємось на $sourceRoot
  unpackPhase = ''
    mkdir -p "$TMPDIR/unpack"
    # якщо zip — розпаковуємо в TMP
    if unzip -l ${pathsrc} >/dev/null 2>&1; then
      unzip -q ${pathsrc} -d "$TMPDIR/unpack"
    else
      if tar -tf ${pathsrc} >/dev/null 2>&1; then
        tar -xf ${pathsrc} -C "$TMPDIR/unpack"
      else
        # файл без архіва — просто скопіюємо
        cp ${pathsrc} "$TMPDIR/unpack/pppwn-src"
      fi
    fi
  '';

  installPhase = ''
    set -e
    mkdir -p $out/bin
    workdir="$TMPDIR/unpack"

    # знайдемо candidate: спочатку шукаємо файл з ім'ям pppwn, потім перший tar/gz, потім будь-який файл
    candidate=$(find "$workdir" -type f -name 'pppwn' -print -quit || true)

    if [ -z "$candidate" ]; then
      candidate=$(find "$workdir" -type f -name '*.tar.gz' -print -quit || true)
    fi

    if [ -z "$candidate" ]; then
      candidate=$(find "$workdir" -type f -print -quit || true)
    fi

    if [ -z "$candidate" ]; then
      # як fallback — якщо src був не архівом, використовуємо його
      candidate=${pathsrc}
    fi

    echo "Using candidate: $candidate"

    # Якщо candidate — tar.gz (або gzip stream), розпакуємо і знайдемо pppwn всередині
    if file --brief --mime-type "$candidate" | grep -q gzip; then
      tmpdir2="$(mktemp -d)"
      # розпакуємо можливий tar.gz
      if tar -tf "$candidate" >/dev/null 2>&1; then
        tar -xf "$candidate" -C "$tmpdir2"
        found=$(find "$tmpdir2" -type f -name 'pppwn' -print -quit || true)
        if [ -n "$found" ]; then
          cp "$found" $out/bin/pppwn
        else
          # якщо всередині немає pppwn — взяти перший файл
          first=$(find "$tmpdir2" -type f | head -n1)
          cp "$first" $out/bin/pppwn
        fi
      else
        # можливо це просто gzipped executable
        gunzip -c "$candidate" > $out/bin/pppwn || cp "$candidate" $out/bin/pppwn
      fi
      rm -rf "$tmpdir2"
    else
      # якщо candidate — просто файл (можливо вже виконуваний), скопіюємо
      cp "$candidate" $out/bin/pppwn
    fi

    chmod +x $out/bin/pppwn
  '';

  meta = {
    description = "PPPwn prebuilt binary packaged for NixOS (auto-unpack)";
    license = pkgs.lib.licenses.mit;
    platforms = [ "aarch64-linux" ];
  };
}
