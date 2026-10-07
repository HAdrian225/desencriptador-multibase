#!/usr/bin/env bash
# Instala (o desinstala) el comando "desencriptador" en ~/.local/bin
set -euo pipefail

DESTINO="$HOME/.local/bin"
# Diccionario rockyou.txt para crackear hashes (opción "c"); se descarga de SecLists si no está
ROCKYOU="$HOME/wordlists/rockyou.txt"
ROCKYOU_URL="https://github.com/danielmiessler/SecLists/raw/master/Passwords/Leaked-Databases/rockyou.txt.tar.gz"
ORIGEN="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/desencriptador"

# Desinstalar
if [ "${1:-}" = "--desinstalar" ]; then
    rm -f "$DESTINO/desencriptador"
    echo "desencriptador desinstalado."
    exit 0
fi

# Verificar dependencias
faltan=()
for cmd in base64 base32 xxd bc iconv grep awk tr sed gzip python3; do
    command -v "$cmd" > /dev/null 2>&1 || faltan+=("$cmd")
done
if [ "${#faltan[@]}" -gt 0 ]; then
    echo "Error: faltan estos programas: ${faltan[*]}" >&2
    echo "En Debian/Ubuntu: sudo apt install coreutils xxd bc gzip python3" >&2
    exit 1
fi

# Copiar el programa
mkdir -p "$DESTINO"
install -m 755 "$ORIGEN" "$DESTINO/desencriptador"
echo "Instalado en: $DESTINO/desencriptador"

# Descargar rockyou.txt si no hay ningún diccionario (--sin-rockyou lo saltea)
if [ "${1:-}" = "--sin-rockyou" ]; then
    :
elif [ -f /usr/share/wordlists/rockyou.txt ] || [ -f "$ROCKYOU" ]; then
    echo "Diccionario rockyou.txt: ya está."
else
    echo "Descargando rockyou.txt (53 MB comprimido, 134 MB descomprimido) en $ROCKYOU..."
    tmp_dl="$(mktemp -d)"
    if { command -v curl > /dev/null 2>&1 && curl -fL --progress-bar -o "$tmp_dl/rockyou.tar.gz" "$ROCKYOU_URL"; } \
        || { command -v wget > /dev/null 2>&1 && wget -q --show-progress -O "$tmp_dl/rockyou.tar.gz" "$ROCKYOU_URL"; }; then
        mkdir -p "$(dirname -- "$ROCKYOU")"
        tar -xzf "$tmp_dl/rockyou.tar.gz" -C "$(dirname -- "$ROCKYOU")" rockyou.txt && chmod 644 "$ROCKYOU" \
            && echo "Diccionario instalado en: $ROCKYOU"
    else
        echo "Aviso: no se pudo descargar rockyou.txt (hace falta curl o wget e internet)." >&2
        echo "El programa funciona igual; para crackear hashes indicá otro diccionario." >&2
    fi
    rm -rf "$tmp_dl"
fi

# Avisar si ~/.local/bin no está en el PATH
case ":$PATH:" in
    *":$DESTINO:"*)
        echo "Listo. Abrí una terminal nueva (o ejecutá 'hash -r' / 'rehash') y escribí: desencriptador" ;;
    *)
        echo
        echo "Atención: $DESTINO no está en tu PATH. Agregá esta línea a tu ~/.zshrc o ~/.bashrc:"
        echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
        echo "y abrí una terminal nueva." ;;
esac
