# Guía de uso

## Abrir el programa

```bash
desencriptador                         # te pide la ruta del archivo
desencriptador "mensaje base64.txt"    # abre directamente ese archivo
```

Al escribir la ruta podés usar **Tab** para autocompletar, comillas o `~`:

```
Ruta del archivo a desencriptar: mensaje\ base64.txt
Ruta del archivo a desencriptar: "mensaje base64.txt"
Ruta del archivo a desencriptar: ~/Descargas/mensaje base64.txt
```

## El menú

```
===== Archivo: mensaje base64.txt =====
1) Ejecutar
2) Cambiar archivo
3) Salir
Opción:
```

- **1**: descifra la primera capa del archivo y la muestra.
- **2**: cambia a otro archivo sin salir del programa (Enter vacío mantiene el actual).
- **3**: sale.

## Descifrar capa por capa

Después de **Ejecutar** se ve la capa descifrada, cómo se obtuvo y el recorrido hasta ahí:

```
===== Archivo: texto.txt =====
Capa 2: base64 → gzip, bloque dentro del texto
----------------------------------------
Set-StrictMode -Version 2
...
----------------------------------------
Recorrido (2 capa(s) descifrada(s)):
  1. base64 → UTF-16LE
  2. base64 → gzip, bloque dentro del texto

d) Desencriptar de nuevo   x) Aplicar XOR   a) Capa anterior   g) Guardar   v) Volver al menú
Opción [d]:
```

- **d** (o Enter): descifra la capa siguiente a partir de lo que estás viendo.
- **x**: aplica XOR con una clave de un byte que escribís vos (`35` o `0x23`).
- **a**: vuelve a la capa anterior (por ejemplo, si una capa no era la correcta).
- **g**: guarda la capa actual junto al original, con ` desencriptado` agregado al nombre:
  `mensaje.txt` → `mensaje desencriptado.txt`. Si la capa es binaria se guarda como
  `mensaje desencriptado.bin`. Si el archivo ya existe pregunta antes de sobrescribirlo.
- **v**: vuelve al menú principal.

Si no se reconoce otra capa, el programa avisa y te deja guardar o volver:

```
Error: no se reconoció ninguna otra capa codificada. Este parece ser el resultado final.
```

## Cómo detecta cada capa

1. Prueba el **contenido completo** como hexadecimal, Base32, Base64, Base58 y ROT13, en ese orden.
   Si el archivo repite la misma línea muchas veces, la decodifica una sola vez.
2. Si no, busca **bloques codificados dentro del texto** (16 caracteres o más) y los decodifica
   sin repetidos. Así se saca, por ejemplo, el base64 que hay dentro de un script de PowerShell.
   Si hay varios mensajes distintos, los muestra uno por línea.
3. Después de decodificar, deshace solo:
   - **UTF-16LE** (el formato de `powershell -EncodedCommand`),
   - **gzip / zlib** (por su firma) y **deflate** si el texto menciona `DeflateStream`,
   - **XOR** si el texto de la capa indica la clave, como `-bxor 35`.
4. Se prefiere siempre un resultado de **texto legible**. Si no hay ninguno, se acepta un resultado
   **binario** cuando se reconoció algo de lo anterior o cuando el bloque es largo (64 caracteres o más).

Los binarios se muestran así (y la capa siguiente ya no se puede descifrar sola; podés probar **x**):

```
(Resultado binario: 894 bytes — data)

Primeros 256 bytes:
00000000: fc48 83e4 f0e8 c800 0000 4151 4150 5251  .H........AQAPRQ
...
Cadenas legibles (6 o más caracteres):
wininet
...
```

**Base64 desalineado**: si al copiar un bloque se colaron 1 a 3 caracteres de más al principio,
el programa los descarta y lo indica en la descripción de la capa.

**Hexadecimal**: además de `48656c`, acepta `48 65 6c`, `48:65:6c`, `0x48 0x65` y `\x48\x65`.

## Práctica con los ejemplos

La carpeta `ejemplos/` tiene el mensaje **"Este es un texto encriptado"** en cada formato:

| Archivo | Capas |
|---|---|
| `mensaje base64.txt` | 1 (el mismo bloque repetido 1000 veces en una sola línea) |
| `mensaje base32.txt` | 1 |
| `mensaje base58.txt` | 1 |
| `mensaje hex.txt` | 1 |
| `mensaje rot13.txt` | 1 |
| `mensaje varias capas.txt` | 5: base64 → rot13 → base64 → hex → base64 |
| `mensaje sin codificar.txt` | ninguna: se rechaza |

Ejercicio:

1. `cd ejemplos` y ejecutá `desencriptador "mensaje varias capas.txt"`.
2. Elegí **1 (Ejecutar)**: muestra la capa 1, que todavía está codificada.
3. Apretá **d** cuatro veces hasta ver `Este es un texto encriptado`; una quinta vez tiene que avisar que no hay más capas.
4. Con **a** volvé a la capa 3 y mirá el recorrido.
5. Con **g** guardá la capa y revisá `mensaje varias capas desencriptado.txt`.
6. Con **v** y después **2** cambiá a `mensaje sin codificar.txt` y ejecutalo: tiene que rechazarlo.

## Crear tus propios archivos de prueba

```bash
printf 'Hola mundo\n' | base64                   # Base64
printf 'Hola mundo'   | base32                   # Base32
printf 'Hola mundo'   | xxd -p                   # Hexadecimal
printf 'Hola mundo'   | tr 'A-Za-z' 'N-ZA-Mn-za-m'  # ROT13
printf 'Hola mundo'   | gzip | base64 -w0       # gzip + Base64
```

## Limitaciones

- **ROT13**: cualquier texto se puede "descifrar" con ROT13, así que el programa solo acepta el resultado si aparecen más palabras comunes (español/inglés) que en el original, si aparece una flag (`HTB{`, `flag{`, `CTF{`, `THM{`) o si el resultado se puede seguir decodificando.
- **Falsos positivos**: si el texto final es, por casualidad, hex o Base64 válido que da texto legible, **d** lo descifra una vez más; con **a** volvés a la capa anterior.
- **XOR**: solo claves de un byte. Un XOR puede dar caracteres imprimibles y verse como "texto" aunque no lo sea.
- **Base58**: solo se prueba sobre el contenido completo y con 6 caracteres o más.
- **Base64 sin relleno (`=`)**: si varios bloques sin `=` están pegados en la misma línea, no se pueden separar; ponelos uno por línea.
- Los binarios no se siguen decodificando solos (salvo gzip/zlib, que se descomprimen al detectarlos).
