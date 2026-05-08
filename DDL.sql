CREATE DATABASE produccion;

-- 1. Creación de tablas (Solo columnas base)
CREATE TABLE proveedor (
    id_proveedor INT,
    nombre VARCHAR(100),
    pais VARCHAR(50)
);

CREATE TABLE tipo_categoria (
    id_categoria INT,
    nombre VARCHAR(100)
);

CREATE TABLE recepcion (
    id_recepcion INT,
    tipo VARCHAR(50),
    fecha_recepcion DATE
);

CREATE TABLE motivo_rechazo (
    id_rechazado INT,
    descripcion TEXT,
    destino VARCHAR(100)
);

CREATE TABLE empleado (
    id_empleado INT,
    nombre_1 VARCHAR(50) NOT NULL,
    nombre_2 VARCHAR(50),
    apellido_1 VARCHAR(50) NOT NULL,
    apellido_2 VARCHAR(50) NOT NULL
);

CREATE TABLE estado (
    id_estado INT,
    nombre_estado VARCHAR(50)
);

CREATE TABLE tipo_control (
    id_tipo_control INT,
    nombre VARCHAR(100)
);

CREATE TABLE lote_produccion (
    id_lote_produccion INT,
    estado_lote VARCHAR(50),
    fecha_elab DATE
);

CREATE TABLE orden_compra (
    id_compra INT,
    fecha DATE,
    metodo_pago VARCHAR(50),
    total DECIMAL(10,2),
    id_proveedor INT
);

CREATE TABLE materia_prima (
    id_materia INT,
    nombre VARCHAR(100),
    descripcion TEXT,
    id_categoria INT
);

CREATE TABLE detalle (
    id_compra INT,
    id_materia INT,
    unidad_de_medida VARCHAR(20),
    cantidad INT,
    precio_unitario DECIMAL(10,2)
);

CREATE TABLE lote_materia_prima (
    id_lote INT,
    cantidad INT,
    pais VARCHAR(50),
    estado_lote VARCHAR(50),
    fecha_vencimiento DATE,
    id_materia INT,
    id_recepcion INT,
    id_compra INT,
    id_rechazado INT
);

CREATE TABLE control_de_calidad (
    id_control INT,
    unidad_de_medida VARCHAR(20),
    observacion TEXT,
    hora TIME,
    fecha DATE,
    aprobado BOOLEAN,
    id_tipo_control INT,
    id_empleado INT,
    id_lote INT,
    id_estado INT
);

CREATE TABLE tipo_de_control (
    id_materia INT,
    id_tipo_control INT,
    valor_numerico DECIMAL(10,2),
    descripcion_adicional TEXT
);

CREATE TABLE utiliza (
    id_lote_produccion INT,
    id_lote INT,
    cantidad INT
);

