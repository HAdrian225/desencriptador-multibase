# Desencriptador multibase: descifra capa por capa Base64, Base32, Base58, Hex, ROT13, gzip y XOR desde la terminal

Herramienta de terminal en Bash para **decodificar archivos de texto paso a paso**.
Se instala como el comando `desencriptador`.

Al ejecutarlo muestra la primera capa descifrada; si el resultado sigue codificado (o tiene otro
mensaje codificado adentro), con una tecla se descifra la capa siguiente, y así hasta que decidas
parar o no quede nada reconocible. El formato de cada capa se detecta solo.

Reconoce:

| Tipo | Qué hace |
|---|---|
| Base64, Base32, Base58, hexadecimal, ROT13 | decodifica el contenido completo |
| Bloques dentro de un texto | busca, por ejemplo, el base64 que hay dentro de un script de PowerShell |
| UTF-16LE | convierte a texto (por ejemplo `powershell -EncodedCommand`) |
| gzip, zlib, deflate | descomprime (`GzipStream`, `DeflateStream`) |
| XOR de un byte | automático si el texto indica la clave (`-bxor 35`), o manual con la clave que elijas |

Los resultados binarios (por ejemplo shellcode) se muestran como volcado hexadecimal con sus cadenas
legibles y se pueden guardar como `.bin`. **El programa nunca ejecuta lo que decodifica.**

## Inicio rápido

```bash
git clone https://github.com/HAdrian225/desencriptador-multibase.git desencriptador-multibase
cd desencriptador-multibase
./install.sh
desencriptador "ejemplos/mensaje varias capas.txt"
```

## Guías

- [Guía de instalación](INSTALACION.md)
- [Guía de uso](USO.md)

## Estructura

```
desencriptador     # el programa
install.sh         # instalador / desinstalador
ejemplos/          # archivos de prueba con "Este es un texto encriptado"
INSTALACION.md
USO.md
```
