#!/usr/bin/env bash
# Instala (o desinstala) el comando "desencriptador" en ~/.local/bin
set -euo pipefail

DESTINO="$HOME/.local/bin"
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
