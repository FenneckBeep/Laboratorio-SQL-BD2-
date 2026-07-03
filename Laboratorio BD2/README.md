# Laboratorio 2 - Base de Datos II (2026)
## Sistema de Control de Calidad (C + ECPG + PostgreSQL)

Basicamente:
===========================================================================
La idea es Tener la Carpeta Laboratorio BD2 una vez dentro del CMD y pararnos ahí mismo 
con CD aplicamos los siguientes comandos...

Comando:

(Borrar Cache y basura) Pa finalizar todo
docker compose down -v --rmi local


1- docker compose up -d db_postgres

2- docker compose ps

3- docker compose run --rm app_calidad

===========================================================================

Programa en C con SQL embebido (ECPG) que gestiona el control de calidad de
lotes de materia prima: listado de pendientes de inspección, registro de
controles con cálculo automático de estado (Aprobado / Rechazado / Observado)
y reporte de controles por empleado. Todo corre sobre **Docker Compose**, no
hace falta instalar Postgres ni un compilador ECPG a mano.

---

## 📦 Estructura del proyecto

| Archivo / Carpeta | Qué es |
|---|---|
| `docker-compose.yml` | Levanta la base de datos y compila/corre la app en un solo paso |
| `Lab_corregido/` | Scripts SQL que arman la base `lab02` desde cero (tablas, constraints, funciones, datos de prueba, usuarios). Se ejecutan automático, **en orden numérico**, la primera vez que se levanta el contenedor de la base |
| `Lab_C (Rework)/` | Código fuente del programa: `main.pgc` (SQL embebido) y `Dockerfile` que lo compila |

> El `main.c` que puede aparecer en `Lab_C (Rework)/` es un archivo generado
> automáticamente por `ecpg` a partir del `main.pgc` durante el build — no se
> edita a mano, no importa si está desactualizado en el repo.

---

## 1. Requisitos previos

- **Docker Desktop** instalado y **abierto** (el ícono de la ballena tiene que
  estar quieto en la barra de tareas, no "cargando").
- Una terminal (PowerShell, CMD o Git Bash en Windows; terminal normal en
  Mac/Linux).

---

## 2. Cómo correrlo (primera vez o después de bajar cambios nuevos)

Parate con la terminal en la carpeta raíz del proyecto (donde está
`docker-compose.yml`) y ejecutá, en este orden:

```bash
# 1) Levantar la base de datos (crea "lab02" y carga los datos de prueba)
docker compose up -d db_postgres

# 2) Esperar a que diga "healthy" (puede tardar unos segundos la primera vez)
docker compose ps

# 3) Compilar y correr el programa (interactivo, en la misma terminal)
docker compose run --rm app_calidad
```

Vas a ver el menú:
```
============================================================
         SISTEMA DE CONTROL DE CALIDAD - LAB 02
============================================================
  1. Listar lotes para inspeccion / reinspeccion
  2. Registrar control de calidad de un lote
  3. Reporte de controles por empleado
  4. Salir
============================================================
```

### Para cortar todo
```bash
docker compose down
```
Como no usamos un volumen persistente aparte, esto también borra los datos
de esa corrida — la próxima vez que hagas `up`, arranca de nuevo con los
datos de prueba originales del `DML`.

### Si algo quedó "pegado" o rompiste código
Si cambiaste `main.pgc` o algún `.sql`, o si algo se comportó raro y querés
arrancar 100% de cero (sin caché, sin datos viejos):
```bash
docker compose down -v --rmi local
docker compose up -d db_postgres
docker compose run --rm app_calidad
```
Si **solo** cambiaste `main.pgc` (no tocaste SQL), alcanza con recompilar:
```bash
docker compose build app_calidad
docker compose run --rm app_calidad
```

---

## 3. Datos de prueba disponibles (vienen ya cargados)

### Lotes de materia prima (`ID_Lote`)
| ID Lote | Materia Prima | Proveedor |
|---|---|---|
| 9001 | Leche Entera Pasteurizada | Distribuidora Global Lácteos S.A. |
| 9002 | Botella PET 1 Litro | Empaques del Norte Ltda. |
| 9003 | Fermento Láctico en Polvo | Químicos y Sabores del Sur |
| 9004 | Leche Entera Pasteurizada | Distribuidora Global Lácteos S.A. |
| 9007 | Leche Entera Pasteurizada | Distribuidora Global Lácteos S.A. |
| 9009 | Fermento Láctico en Polvo | Químicos y Sabores del Sur |

(el programa te muestra la materia prima y el proveedor automáticamente al
elegir un lote, no hace falta memorizar la tabla)

### Empleados (`ID_Empleado`)
| ID | Nombre |
|---|---|
| 10 | Carlos Gómez |
| 20 | Ana Rodríguez |
| 30 | Luis Martínez |

### Tipos de control (`ID_TipoControl`)
| ID | Nombre | Tipo | Rango de referencia |
|---|---|---|---|
| 1 | Medición de pH | Cuantitativo | 6.40 – 6.80 |
| 2 | Porcentaje de Humedad | Cuantitativo | 0.00 – 5.00 |
| 3 | Inspección Visual de Sellado | Cualitativo | — |
| 4 | Prueba de Presencia de Alérgenos | Cualitativo | — |

(el programa también te lista estas opciones antes de pedirte que elijas)

---

## 4. Ejemplo guiado: probar los 3 estados posibles

Usá el lote **9001** con el tipo de control **1** (pH) para probar los tres
casos con un solo lote (el sistema no deja re-controlar un lote que ya quedó
Rechazado, así que probá el orden: Aprobado y Observado primero, Rechazado
al final).

**Caso Aprobado** (dentro de 6.40–6.80):
```
ID del Lote a inspeccionar: 9001
Fecha del control (YYYY-MM-DD): 2025-07-01
Hora del control (HH:MM:SS): 09:00:00
ID Tipo de Control: 1
Valor observado (numero medido): 6.6
Seleccione integridad del envase (numero): 1
ID del Empleado/Funcionario: 10
```
→ Estado calculado: **APROBADO**

**Caso Observado** (fuera de rango, pero dentro del 10% de margen, ej. 6.83):
```
Valor observado (numero medido): 6.83
```
→ Estado calculado: **OBSERVADO** (y vas a verlo reaparecer en la Opción 1,
porque requiere reinspección)

**Caso Rechazado** (bien fuera de rango, ej. 8.5):
```
Valor observado (numero medido): 8.5
```
→ Estado calculado: **RECHAZADO** — el programa va a pedirte motivo y
destino (Devuelto al proveedor / Descartado). Una vez rechazado, ese lote
ya no admite más controles.

### Control cualitativo de ejemplo (lote 9009, tipo 4)
```
ID del Lote a inspeccionar: 9009
ID Tipo de Control: 4
Valor observado: elegís del menú -> 1) Conforme  (aprueba)
                                     5) Defectuoso (rechaza)
                                     9) Otro       (deja Observado)
```

---

## 5. Cómo se calcula el estado (para entender qué está pasando)

Toda la lógica vive en la función `fn_calcular_estado_lote()` dentro de
`Lab_corregido/02_constraints.sql` — el programa en C solo le pasa el lote,
el tipo de control y el valor, y la base devuelve el estado:

- **Cuantitativo**: dentro del rango `[Valor_Min, Valor_Max]` → Aprobado.
  Fuera del rango pero dentro de un margen del 10% → Observado. Más lejos
  → Rechazado.
- **Cualitativo**: `Conforme / Negativo / Aprobado / OK` → Aprobado.
  `Defectuoso / Inaceptable / Positivo / Rechazado` → Rechazado.
  Cualquier otro valor → Observado.

---

## 6. Problemas comunes

| Síntoma | Causa probable | Solución |
|---|---|---|
| `docker compose ps` no dice `healthy` nunca | Docker Desktop no está abierto | Abrí Docker Desktop y esperá a que cargue |
| `No hay lotes pendientes` recién arrancado | La base quedó a medio inicializar de un intento anterior | `docker compose down -v --rmi local` y volver a levantar |
| `current transaction is aborted...` | Ya arreglado — si aparece, es un bug nuevo, avisar al grupo |
| Cambié `main.pgc` y no se ve el cambio | Falta recompilar | `docker compose build app_calidad` antes de correr |
