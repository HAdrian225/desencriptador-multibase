# Guía de instalación

## Requisitos

- Linux (probado en Ubuntu) con **bash** 4 o superior.
- Programas: `base64`, `base32`, `xxd`, `bc`, `iconv`, `grep`, `awk`, `sed`, `tr`, `gzip` y `python3`
  (este último para zlib/deflate, XOR y crackeo de hashes). `file` es opcional: si está, describe los resultados binarios.
- **Diccionario `rockyou.txt`** (para crackear hashes con la opción **c**): el instalador lo descarga de
  [SecLists](https://github.com/danielmiessler/SecLists) en `~/wordlists/rockyou.txt` si no lo encuentra
  (necesita `curl` o `wget`; son 53 MB comprimidos y 134 MB descomprimidos). Si ya existe en
  `/usr/share/wordlists/rockyou.txt` (Kali) no se descarga. No va dentro del repositorio porque supera el
  límite de 100 MB de GitHub.
  Casi todos vienen instalados. Si falta alguno:

  ```bash
  sudo apt install coreutils xxd bc gzip python3
  ```

Funciona desde cualquier terminal (kitty, GNOME Terminal, etc.) con zsh o bash.

## 1. Descargar

```bash
git clone https://github.com/HAdrian225/desencriptador-multibase.git desencriptador-multibase
cd desencriptador-multibase
```

## 2. Instalar

```bash
./install.sh
```

El instalador:

1. Verifica que estén todas las dependencias.
2. Copia el programa a `~/.local/bin/desencriptador` (no necesita `sudo`).
3. Descarga `rockyou.txt` en `~/wordlists/` si no lo tenés (`./install.sh --sin-rockyou` lo saltea).
4. Te avisa si `~/.local/bin` no está en tu `PATH`.

Si te avisa lo del `PATH`, agregá esta línea al final de tu `~/.zshrc` (o `~/.bashrc` si usás bash):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## 3. Comprobar

Abrí una terminal nueva (o ejecutá `rehash` en zsh / `hash -r` en bash) y escribí:

```bash
desencriptador
```

Debería pedirte la ruta de un archivo.

## Actualizar

```bash
cd desencriptador-multibase
git pull
./install.sh
```

## Desinstalar

```bash
./install.sh --desinstalar
```

## Sin instalar

También se puede usar directamente desde la carpeta del repositorio:

```bash
./desencriptador "ejemplos/mensaje base64.txt"
```
