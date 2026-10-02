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
1) Base64
2) Base32
3) Base58
4) Hexadecimal (base16)
5) ROT13
6) Automático (detecta varias capas)
7) Cambiar archivo
8) Salir
Opción:
```

- **1 a 5**: decodifica el archivo con ese formato (y después sigue con las capas que haya debajo).
- **6**: detecta solo el formato de cada capa. Útil cuando no sabés cómo está codificado.
- **7**: cambia a otro archivo sin salir del programa (Enter vacío mantiene el actual).
- **8**: sale.

Después de cada resultado se limpia la pantalla, se muestra la salida y el programa espera **Enter** para volver al menú.

## Qué hace al elegir un formato

1. Busca en el archivo los bloques con el formato elegido (aunque estén pegados en una sola línea).
2. **Elimina los repetidos** antes de decodificar, para no gastar recursos.
3. Decodifica cada bloque único y descarta lo que no da texto legible.
4. Muestra los mensajes separados por una línea en blanco.
5. Los guarda en un archivo nuevo junto al original, con ` desencriptado` agregado al nombre:

   `mensaje base64.txt` → `mensaje base64 desencriptado.txt`

## Varias capas y contador

Si el resultado sigue estando codificado, el programa lo vuelve a descifrar hasta llegar a texto plano
(máximo 20 capas). En cada capa prueba hexadecimal, Base32, Base64 y ROT13, en ese orden.
Base58 solo se usa como primera capa con la opción 3, porque da demasiados falsos positivos.

Cada mensaje muestra cuántas veces se descifró y en qué orden, y al final aparece un contador total:

```
[Mensaje 1] descifrado 5 vez/veces: base64 → rot13 → base64 → hex → base64
Este es un texto encriptado

=== Contador: 5 descifrado(s) en total ===
  base64: 3
  hex: 1
  rot13: 1
-> 1 mensaje(s) únicos guardados en: mensaje varias capas desencriptado.txt
```

El contador se muestra en pantalla; el archivo `desencriptado` guarda solo el texto.

**Base64 desalineado**: si al copiar un bloque se colaron 1 a 3 caracteres de más al principio,
el programa los descarta y avisa:

```
Aviso: se descartaron 2 caracter(es) iniciales no alineados: 'ut'
```

**Hexadecimal**: además de `48656c`, acepta `48 65 6c`, `48:65:6c`, `0x48 0x65` y `\x48\x65`.

Si no encuentra nada del formato elegido:

```
Error: no se encontró nada en base32 en 'mensaje base64.txt'. Petición rechazada.
```

No se crea ningún archivo y volvés al menú para probar otro formato.

## Práctica con los ejemplos

La carpeta `ejemplos/` tiene el mensaje **"Este es un texto encriptado"** en cada formato:

| Archivo | Opción correcta |
|---|---|
| `mensaje base64.txt` | 1 (el mismo bloque repetido 1000 veces en una sola línea) |
| `mensaje base32.txt` | 2 |
| `mensaje base58.txt` | 3 |
| `mensaje hex.txt` | 4 |
| `mensaje rot13.txt` | 5 |
| `mensaje varias capas.txt` | 1 o 6 (base64 → rot13 → base64 → hex → base64) |
| `mensaje sin codificar.txt` | ninguna: todas lo rechazan |

Ejercicio:

1. `cd ejemplos` y ejecutá `desencriptador "mensaje base64.txt"`.
2. Elegí **2 (Base32)**: tiene que rechazarlo.
3. Elegí **1 (Base64)**: tiene que mostrar `Este es un texto encriptado` una sola vez, aunque el archivo lo tenga 1000 veces.
4. Con **7** cambiá a `mensaje rot13.txt` y elegí **5**.
5. Con **7** cambiá a `mensaje varias capas.txt` y elegí **6**: tiene que mostrar las 5 capas y el contador.
6. Revisá los archivos `* desencriptado.txt` que se crearon.

## Crear tus propios archivos de prueba

```bash
printf 'Hola mundo\n' | base64                   # Base64
printf 'Hola mundo'   | base32                   # Base32
printf 'Hola mundo'   | xxd -p                   # Hexadecimal
printf 'Hola mundo'   | tr 'A-Za-z' 'N-ZA-Mn-za-m'  # ROT13
```

## Limitaciones

- **ROT13**: cualquier texto se puede "descifrar" con ROT13, así que el programa solo acepta el resultado si aparecen más palabras comunes (español/inglés) que en el original, si aparece una flag (`HTB{`, `flag{`, `CTF{`, `THM{`) o si el resultado se puede seguir decodificando. Mensajes muy cortos o en otros idiomas pueden ser rechazados.
- **Varias capas**: si el texto final es, por casualidad, hex o Base64 válido que da texto legible, se descifra una capa de más.
- **Base58**: los bloques deben tener al menos 6 caracteres.
- **Base64 sin relleno (`=`)**: si varios bloques sin `=` están pegados en la misma línea, no se pueden separar; ponelos uno por línea.
- Si decodificás el mismo archivo dos veces, el archivo `desencriptado` se sobrescribe.
