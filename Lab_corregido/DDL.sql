-- ==========================================
-- 1. CREACIÓN DE TABLAS (Sin PK ni FK complejas)
-- ==========================================

CREATE TABLE Proveedor (
    ID_Proveedor INT NOT NULL,
    Nombre VARCHAR(100),
    Pais VARCHAR(50)
);

CREATE TABLE Moneda (
    ID_Moneda INT NOT NULL,
    Nombre_Moneda VARCHAR(50)
);

CREATE TABLE Orden_Compra (
    ID_Compra INT NOT NULL,
    Fecha DATE,
    ID_Moneda INT,
    ID_Proveedor INT
);

CREATE TABLE Tipo_Categoria (
    ID_Categoria INT NOT NULL,
    Nombre VARCHAR(50)
);

CREATE TABLE Materia_Prima (
    ID_Materia INT NOT NULL,
    Nombre VARCHAR(100),
    Descripcion TEXT,
    ID_Categoria INT,
    Precio_Unitario DECIMAL(10,2)
);

CREATE TABLE Detalle (
    ID_Compra INT NOT NULL,
    ID_Materia INT NOT NULL,
    PesoKG DECIMAL(10,2),
    Cantidad INT,
    Total DECIMAL(10,2)
);

CREATE TABLE Recepcion (
    ID_Recepcion INT NOT NULL,
    Fecha_Recepcion DATE
);

CREATE TABLE Lote_MateriaPrima (
    ID_Lote INT NOT NULL,
    Cantidad INT,
    Fecha_Vencimiento DATE,
    ID_Materia INT,
    ID_Recepcion INT,
    ID_Compra INT
);

CREATE TABLE Motivo_Rechazo (
    ID_Rechazo INT NOT NULL,
    Descripcion_Rechazo TEXT,
    Destino VARCHAR(100)
);

CREATE TABLE Empleado (
    ID_Empleado INT NOT NULL,
    Nombre1 VARCHAR(50),
    Nombre2 VARCHAR(50),
    Apellido1 VARCHAR(50),
    Apellido2 VARCHAR(50)
);

CREATE TABLE Estado (
    ID_Estado INT NOT NULL,
    Nombre_Estado VARCHAR(50)
);

CREATE TABLE Tipo_Control (
    ID_TipoControl INT NOT NULL,
    Nombre VARCHAR(50)
);

CREATE TABLE Cuantitativo (
    ID_TipoControl INT NOT NULL,
    Unidad_de_Medida VARCHAR(20)
);

CREATE TABLE Cualitativo (
    ID_TipoControl INT NOT NULL
);

CREATE TABLE Control_De_Calidad (
    ID_Control INT NOT NULL,
    Descripcion TEXT,
    Hora TIME,
    fecha DATE,
    Valor_Medido VARCHAR(50),
    ID_TipoControl INT,
    ID_Empleado INT,
    ID_Lote INT,
    ID_Estado INT,
    ID_Rechazo INT
);

CREATE TABLE Lote_Produccion (
    ID_Lote_Produccion INT NOT NULL,
    Estado_Lote VARCHAR(50),
    Fecha_Elab DATE
);

CREATE TABLE Utiliza (
    ID_Lote_Produccion INT NOT NULL,
    ID_Lote INT NOT NULL,
    Cant INT
);

CREATE TABLE Tiene (
    ID_Control INT NOT NULL,
    ID_Lote INT NOT NULL
);

