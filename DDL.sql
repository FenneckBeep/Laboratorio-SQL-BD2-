CREATE DATABASE produccion;

-- 1. Tablas Maestras (Sin dependencias)
CREATE TABLE proveedor (
    id_proveedor INT PRIMARY KEY,
    nombre VARCHAR(100),
    pais VARCHAR(50)
);

CREATE TABLE tipo_categoria (
    id_categoria INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE recepcion (
    id_recepcion INT PRIMARY KEY,
    tipo VARCHAR(50),
    fecha_recepcion DATE
);

CREATE TABLE motivo_rechazo (
    id_rechazado INT PRIMARY KEY,
    descripcion TEXT,
    destino VARCHAR(100)
);

CREATE TABLE empleado (
    id_empleado INT PRIMARY KEY,
    nombre_1 VARCHAR(50) NOT NULL,
    nombre_2 VARCHAR(50),
    apellido_1 VARCHAR(50) NOT NULL,
    apellido_2 VARCHAR(50) NOT NULL
);

CREATE TABLE estado (
    id_estado INT PRIMARY KEY,
    nombre_estado VARCHAR(50)
);

CREATE TABLE tipo_control (
    id_tipo_control INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE lote_produccion (
    id_lote_produccion INT PRIMARY KEY,
    estado_lote VARCHAR(50),
    fecha_elab DATE
);

-- 2. Tablas con dependencias de primer nivel
CREATE TABLE orden_compra (
    id_compra INT PRIMARY KEY,
    fecha DATE,
    metodo_pago VARCHAR(50),
    total DECIMAL(10,2),
    id_proveedor INT,
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor)
);

CREATE TABLE materia_prima (
    id_materia INT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT,
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES tipo_categoria(id_categoria)
);

-- 3. Tablas con múltiples dependencias (Relaciones y Lotes)
CREATE TABLE detalle (
    id_compra INT,
    id_materia INT,
    unidad_de_medida VARCHAR(20),
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    PRIMARY KEY (id_compra, id_materia),
    FOREIGN KEY (id_compra) REFERENCES orden_compra(id_compra),
    FOREIGN KEY (id_materia) REFERENCES materia_prima(id_materia)
);

CREATE TABLE lote_materia_prima (
    id_lote INT PRIMARY KEY,
    cantidad INT,
    pais VARCHAR(50),
    estado_lote VARCHAR(50),
    fecha_vencimiento DATE,
    id_materia INT,
    id_recepcion INT,
    id_compra INT,
    id_rechazo INT,
    FOREIGN KEY (id_materia) REFERENCES materia_prima(id_materia),
    FOREIGN KEY (id_recepcion) REFERENCES recepcion(id_recepcion),
    FOREIGN KEY (id_compra) REFERENCES orden_compra(id_compra),
    FOREIGN KEY (id_rechazo) REFERENCES motivo_rechazo(id_rechazado)
);

CREATE TABLE control_de_calidad (
    id_control INT PRIMARY KEY,
    unidad_de_medida VARCHAR(20),
    observacion TEXT,
    hora TIME,
    fecha DATE,
    aprobado BOOLEAN,
    id_tipo_control INT,
    id_empleado INT,
    id_lote INT,
    id_estado INT,
    FOREIGN KEY (id_tipo_control) REFERENCES tipo_control(id_tipo_control),
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
    FOREIGN KEY (id_lote) REFERENCES lote_materia_prima(id_lote),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);

CREATE TABLE tipo_de_control (
    id_materia INT,
    id_tipo_control INT,
    valor_numerico DECIMAL(10,2),
    descripcion_adicional TEXT,
    PRIMARY KEY (id_materia, id_tipo_control),
    FOREIGN KEY (id_materia) REFERENCES materia_prima(id_materia),
    FOREIGN KEY (id_tipo_control) REFERENCES tipo_control(id_tipo_control)
);

CREATE TABLE utiliza (
    id_lote_produccion INT,
    id_lote INT,
    cantidad INT,
    PRIMARY KEY (id_lote_produccion, id_lote),
    FOREIGN KEY (id_lote_produccion) REFERENCES lote_produccion(id_lote_produccion),
    FOREIGN KEY (id_lote) REFERENCES lote_materia_prima(id_lote)
);
