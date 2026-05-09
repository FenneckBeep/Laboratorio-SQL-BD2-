CREATE TABLE proveedor (
    id_proveedor INT,
    nombre VARCHAR(100) NOT NULL,
    pais VARCHAR(50) NOT NULL
);

CREATE TABLE tipo_categoria (
    id_categoria INT,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE recepcion (
    id_recepcion INT,
    tipo VARCHAR(50),
    fecha_recepcion DATE NOT NULL
);

CREATE TABLE motivo_rechazo (
    id_rechazado INT,
    descripcion TEXT NOT NULL,
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
    nombre_estado VARCHAR(50) NOT NULL
);

CREATE TABLE tipo_control (
    id_tipo_control INT,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE lote_produccion (
    id_lote_produccion INT,
    estado_lote VARCHAR(50),
    fecha_elab DATE NOT NULL
);

CREATE TABLE orden_compra (
    id_compra INT,
    fecha DATE NOT NULL,
    metodo_pago VARCHAR(50) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    id_proveedor INT NOT NULL
);

CREATE TABLE materia_prima (
    id_materia INT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    id_categoria INT NOT NULL
);

CREATE TABLE detalle (
    id_compra INT,
    id_materia INT,
    unidad_de_medida VARCHAR(20) NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL
);

CREATE TABLE lote_materia_prima (
    id_lote INT,
    cantidad INT NOT NULL,
    pais VARCHAR(50) NOT NULL,
    estado_lote VARCHAR(50),
    fecha_vencimiento DATE,
    id_materia INT NOT NULL,
    id_recepcion INT NOT NULL,
    id_compra INT NOT NULL,
    id_rechazado INT
);

CREATE TABLE control_de_calidad (
    id_control INT,
    unidad_de_medida VARCHAR(20),
    observacion TEXT,
    hora TIME NOT NULL,
    fecha DATE NOT NULL,
    aprobado BOOLEAN NOT NULL,
    id_tipo_control INT NOT NULL,
    id_empleado INT NOT NULL,
    id_lote INT NOT NULL,
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
    cantidad INT NOT NULL
);