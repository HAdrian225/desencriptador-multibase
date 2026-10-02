# Desencriptador multibase: limpia y decodifica Base64, Base32, Base58, Hex y ROT13 desde la terminal

Herramienta de terminal en Bash para **limpiar y decodificar** archivos de texto.
Se instala como el comando `desencriptador`.
Elimina los mensajes repetidos, decodifica solo los únicos y guarda el resultado en un archivo nuevo.
Si un mensaje está codificado varias veces (por ejemplo base64 → hex → rot13), sigue descifrando todas las capas y cuenta cuántas veces tuvo que hacerlo.

Formatos soportados:

| Opción | Formato |
|---|---|
| 1 | Base64 |
| 2 | Base32 |
| 3 | Base58 (alfabeto Bitcoin) |
| 4 | Hexadecimal (base16) |
| 5 | ROT13 |
| 6 | Automático: detecta el formato y descifra varias capas |

Si el archivo no contiene nada parecido al formato elegido, el programa muestra un error, no crea nada y vuelve al menú.

## Inicio rápido

```bash
git clone https://github.com/HAdrian225/desencriptador-multibase.git desencriptador-multibase
cd desencriptador-multibase
./install.sh
desencriptador "ejemplos/mensaje base64.txt"
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
