CREATE DATABASE produccion;

-- 1. Tablas Maestras (Sin dependencias)
CREATE TABLE Proveedor (
    ID_Proveedor INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Pais VARCHAR(50)
);

CREATE TABLE Tipo_Categoria (
    ID_Categoria INT PRIMARY KEY,
    Nombre VARCHAR(100)
);

CREATE TABLE Recepcion (
    ID_Recepcion INT PRIMARY KEY,
    Tipo VARCHAR(50),
    Fecha_Recepcion DATE
);

CREATE TABLE Motivo_Rechazo (
    ID_Rechazado INT PRIMARY KEY,
    Descripcion TEXT,
    Destino VARCHAR(100)
);

CREATE TABLE Empleado (
    ID_Empleado INT PRIMARY KEY,
    Nombre1 VARCHAR(50) NOT NULL,
    Nombre2 VARCHAR(50),
    Apellido1 VARCHAR(50) NOT NULL,
    Apellido2 VARCHAR(50) NOT NULL
);

CREATE TABLE Estado (
    ID_Estado INT PRIMARY KEY,
    Nombre_Estado VARCHAR(50)
);

CREATE TABLE Tipo_Control (
    ID_TipoControl INT PRIMARY KEY,
    Nombre VARCHAR(100)
);

CREATE TABLE Lote_Produccion (
    ID_Lote_Produccion INT PRIMARY KEY,
    Estado_Lote VARCHAR(50),
    Fecha_Elab DATE
);

-- 2. Tablas con dependencias de primer nivel
CREATE TABLE Orden_Compra (
    ID_Compra INT PRIMARY KEY,
    Fecha DATE,
    Metodo_Pago VARCHAR(50),
    Total DECIMAL(10,2),
    ID_Proveedor INT,
    FOREIGN KEY (ID_Proveedor) REFERENCES Proveedor(ID_Proveedor)
);

CREATE TABLE Materia_Prima (
    ID_Materia INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Descripcion TEXT,
    ID_Categoria INT,
    FOREIGN KEY (ID_Categoria) REFERENCES Tipo_Categoria(ID_Categoria)
);

-- 3. Tablas con múltiples dependencias (Relaciones y Lotes)
CREATE TABLE Detalle (
    ID_Compra INT,
    ID_Materia INT,
    Unidad_de_medida VARCHAR(20),
    Cantidad INT,
    Precio_Unitario DECIMAL(10,2),
    PRIMARY KEY (ID_Compra, ID_Materia),
    FOREIGN KEY (ID_Compra) REFERENCES Orden_Compra(ID_Compra),
    FOREIGN KEY (ID_Materia) REFERENCES Materia_Prima(ID_Materia)
);

CREATE TABLE Lote_MateriaPrima (
    ID_Lote INT PRIMARY KEY,
    Cantidad INT,
    Pais VARCHAR(50),
    Estado_Lote VARCHAR(50),
    Fecha_Vencimiento DATE,
    ID_Materia INT,
    ID_Recepcion INT,
    ID_Compra INT,
    ID_Rechazo INT,
    FOREIGN KEY (ID_Materia) REFERENCES Materia_Prima(ID_Materia),
    FOREIGN KEY (ID_Recepcion) REFERENCES Recepcion(ID_Recepcion),
    FOREIGN KEY (ID_Compra) REFERENCES Orden_Compra(ID_Compra),
    FOREIGN KEY (ID_Rechazo) REFERENCES Motivo_Rechazo(ID_Rechazado)
);

CREATE TABLE Control_De_Calidad (
    ID_control INT PRIMARY KEY,
    Unidad_de_Medida VARCHAR(20),
    Observacion TEXT,
    Hora TIME,
    fecha DATE,
    Aprobado BOOLEAN,
    ID_TipoControl INT,
    ID_Empleado INT,
    ID_Lote INT,
    ID_Estado INT,
    FOREIGN KEY (ID_TipoControl) REFERENCES Tipo_Control(ID_TipoControl),
    FOREIGN KEY (ID_Empleado) REFERENCES Empleado(ID_Empleado),
    FOREIGN KEY (ID_Lote) REFERENCES Lote_MateriaPrima(ID_Lote),
    FOREIGN KEY (ID_Estado) REFERENCES Estado(ID_Estado)
);

CREATE TABLE Tipo_de_Control (
    ID_Materia INT,
    ID_tipo_control INT,
    Valor_Numerico DECIMAL(10,2),
    Descripcion_Adicional TEXT, -- Reemplazo de 'Desc' y '?'
    PRIMARY KEY (ID_Materia, ID_tipo_control),
    FOREIGN KEY (ID_Materia) REFERENCES Materia_Prima(ID_Materia),
    FOREIGN KEY (ID_tipo_control) REFERENCES Tipo_Control(ID_TipoControl)
);

CREATE TABLE Utiliza (
    ID_Lote_Produccion INT,
    ID_Lote INT,
    cantidad INT,
    PRIMARY KEY (ID_Lote_Produccion, ID_Lote),
    FOREIGN KEY (ID_Lote_Produccion) REFERENCES Lote_Produccion(ID_Lote_Produccion),
    FOREIGN KEY (ID_Lote) REFERENCES Lote_MateriaPrima(ID_Lote)
);
