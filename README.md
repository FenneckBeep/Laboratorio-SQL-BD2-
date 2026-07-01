# Laboratorio 2 - Base de Datos II (2026)
## Sistema de Control de Calidad Integrado (C + ECPG + PostgreSQL)

Este proyecto automatiza por completo el despliegue de la base de datos de producción junto con la precompilación, compilación y ejecución del sistema interactivo en C con SQL embebido (`ECPG`) utilizando **Docker** y **Docker Compose**.

## 📦 Archivos del Proyecto

| Archivo / Carpeta | Descripción |
|-------------------|-------------------------------------------------------|
| `Lab_C/`          | Carpeta de la app (contiene `main.pgc` y el `Dockerfile`) |
| `Lab_corregido/`  | Scripts SQL (`lab02_objetos.sql`, tablas y funciones) |
| `docker-compose.yml` | Orquestador de servicios (Base de Datos + App en C) |

---

## 1. Requisitos Previos
* Tener **Docker** y **Docker Desktop** instalados y en ejecución.
* Una terminal compatible (Git Bash / MINGW64, PowerShell o CMD).

--💡 ¿Qué hace este comando automáticamente?
    1-Levanta el contenedor de PostgreSQL (postgres_produccion) y ejecuta los scripts .sql de la carpeta Lab_corregido.
    2-Construye la imagen de la aplicación basándose en el Dockerfile de Lab_C.
    3-Traduce el archivo main.pgc $\rightarrow$ main.c usando ecpg.
    4-Compila el binario final conectándose a la base de datos por la red interna de Docker.
    5-Despliega el menú directamente en tu consola listo para interactuar.
    
## 2. Cómo Ejecutar el Proyecto ("Clonar y Listo")

Para iniciar la base de datos de forma automática, compilar el código en C internamente y abrir el menú interactivo, abre la terminal en la **raíz del proyecto** (donde se encuentra el archivo `docker-compose.yml`) y ejecuta:

```bash
docker compose run --rm app_calidad

## 3. Opciones del menú

### Opción 1 – Listar lotes para inspección/reinspección
Muestra lotes que:
- Nunca tuvieron un control de calidad, **o**
- Su último control quedó en estado **Observado**

Columnas: ID Lote | Proveedor | Fecha de Recepción (ordenados de más antiguo a más nuevo)

### Opción 2 – Registrar control de calidad
Solicita:
1. ID del lote
2. Fecha y hora del control
3. Tipo de control (se muestra la materia prima del lote automáticamente)
4. Valor observado
5. Integridad del envase (excelente / normal / con daños / inaceptable)
6. Observaciones
7. ID del empleado/funcionario

El **estado se calcula automáticamente** llamando a `fn_calcular_estado_lote()`:
- **Aprobado**: valor dentro del rango definido en `umbral_control`
- **Observado**: valor en zona límite (±10% del margen) → requiere reinspección
- **Rechazado**: valor fuera del rango → pide motivo y destino del lote

### Opción 3 – Reporte de controles por empleado
Dado un rango de fechas, lista todos los empleados que realizaron controles,
con la cantidad de Aprobados, Rechazados y Observados.

### Opción 4 – Salir

---

## 4. Nota sobre la tabla umbral_control

Para que el cálculo automático funcione correctamente, la tabla `umbral_control`
debe tener filas para cada combinación materia prima + tipo de control cuantitativo.

Ejemplo de inserción manual:
```sql
-- Leche Entera (1001) con control pH (1): rango aceptado 6.4 a 6.8
INSERT INTO umbral_control VALUES (1001, 1, 6.4, 6.8) ON CONFLICT DO NOTHING;

-- Fermento Láctico (1002) con Humedad (2): máx 5%
INSERT INTO umbral_control VALUES (1002, 2, 0.0, 5.0) ON CONFLICT DO NOTHING;
```

Para controles cualitativos (Inspección Visual, Prueba de Alérgenos), el programa
interpreta el valor de texto:
- `Conforme`, `Negativo` → **Aprobado**
- `Defectuoso`, `Inaceptable`, `Positivo` → **Rechazado**
- Cualquier otro → **Observado**