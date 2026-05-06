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
    id_rechazo INT
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

-- 2. Definición de Primary Keys
ALTER TABLE proveedor ADD PRIMARY KEY (id_proveedor);
ALTER TABLE tipo_categoria ADD PRIMARY KEY (id_categoria);
ALTER TABLE recepcion ADD PRIMARY KEY (id_recepcion);
ALTER TABLE motivo_rechazo ADD PRIMARY KEY (id_rechazado);
ALTER TABLE empleado ADD PRIMARY KEY (id_empleado);
ALTER TABLE estado ADD PRIMARY KEY (id_estado);
ALTER TABLE tipo_control ADD PRIMARY KEY (id_tipo_control);
ALTER TABLE lote_produccion ADD PRIMARY KEY (id_lote_produccion);
ALTER TABLE orden_compra ADD PRIMARY KEY (id_compra);
ALTER TABLE materia_prima ADD PRIMARY KEY (id_materia);
ALTER TABLE detalle ADD PRIMARY KEY (id_compra, id_materia);
ALTER TABLE lote_materia_prima ADD PRIMARY KEY (id_lote);
ALTER TABLE control_de_calidad ADD PRIMARY KEY (id_control);
ALTER TABLE tipo_de_control ADD PRIMARY KEY (id_materia, id_tipo_control);
ALTER TABLE utiliza ADD PRIMARY KEY (id_lote_produccion, id_lote);

-- 3. Definición de Foreign Keys
ALTER TABLE orden_compra ADD FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor);

ALTER TABLE materia_prima ADD FOREIGN KEY (id_categoria) REFERENCES tipo_categoria(id_categoria);

ALTER TABLE detalle ADD FOREIGN KEY (id_compra) REFERENCES orden_compra(id_compra);
ALTER TABLE detalle ADD FOREIGN KEY (id_materia) REFERENCES materia_prima(id_materia);

ALTER TABLE lote_materia_prima ADD FOREIGN KEY (id_materia) REFERENCES materia_prima(id_materia);
ALTER TABLE lote_materia_prima ADD FOREIGN KEY (id_recepcion) REFERENCES recepcion(id_recepcion);
ALTER TABLE lote_materia_prima ADD FOREIGN KEY (id_compra) REFERENCES orden_compra(id_compra);
ALTER TABLE lote_materia_prima ADD FOREIGN KEY (id_rechazo) REFERENCES motivo_rechazo(id_rechazado);

ALTER TABLE control_de_calidad ADD FOREIGN KEY (id_tipo_control) REFERENCES tipo_control(id_tipo_control);
ALTER TABLE control_de_calidad ADD FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado);
ALTER TABLE control_de_calidad ADD FOREIGN KEY (id_lote) REFERENCES lote_materia_prima(id_lote);
ALTER TABLE control_de_calidad ADD FOREIGN KEY (id_estado) REFERENCES estado(id_estado);

ALTER TABLE tipo_de_control ADD FOREIGN KEY (id_materia) REFERENCES materia_prima(id_materia);
ALTER TABLE tipo_de_control ADD FOREIGN KEY (id_tipo_control) REFERENCES tipo_control(id_tipo_control);

ALTER TABLE utiliza ADD FOREIGN KEY (id_lote_produccion) REFERENCES lote_produccion(id_lote_produccion);
ALTER TABLE utiliza ADD FOREIGN KEY (id_lote) REFERENCES lote_materia_prima(id_lote);
