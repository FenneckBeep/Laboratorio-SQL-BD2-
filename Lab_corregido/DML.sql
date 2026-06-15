-- ============================================================================
-- DML: INSERCIÓN DE DATOS DE PRUEBA (Fechas ajustadas a 2025)
-- ============================================================================

-- 1. Tablas Maestras Independientes
INSERT INTO Proveedor (ID_Proveedor, Nombre, Pais) VALUES
(1, 'Distribuidora Global Lácteos S.A.', 'Argentina'),
(2, 'Empaques del Norte Ltda.', 'Colombia'),
(3, 'Químicos y Sabores del Sur', 'Chile');

INSERT INTO Moneda (ID_Moneda, Nombre_Moneda) VALUES
(1, 'Dólar Estadounidense'),
(2, 'Euro'),
(3, 'Peso Local');

INSERT INTO Tipo_Categoria (ID_Categoria, Nombre) VALUES
(1, 'Materia Prima Láctea'),
(2, 'Aditivos y Conservantes'),
(3, 'Material de Empaque');

INSERT INTO Recepcion (ID_Recepcion, Fecha_Recepcion) VALUES
(101, '2025-05-01'),
(102, '2025-05-10'),
(103, '2025-05-15');

INSERT INTO Motivo_Rechazo (ID_Rechazo, Descripcion_Rechazo, Destino) VALUES
(1, 'Presencia de bacterias por encima del límite permitido', 'Destrucción Sanitaria'),
(2, 'Empaque roto o abollado con exposición al ambiente', 'Devolución al Proveedor'),
(3, 'Densidad o pH fuera del rango especificado', 'Reprocesamiento');

INSERT INTO Empleado (ID_Empleado, Nombre1, Nombre2, Apellido1, Apellido2) VALUES
(10, 'Carlos', 'Alberto', 'Gómez', 'Pérez'),
(20, 'Ana', 'María', 'Rodríguez', 'Silva'),
(30, 'Luis', 'Fernando', 'Martínez', 'Castro');

INSERT INTO Estado (ID_Estado, Nombre_Estado) VALUES
(1, 'Aprobado'),
(2, 'Rechazado'),
(3, 'En Cuarentena / Pendiente');

INSERT INTO Tipo_Control (ID_TipoControl, Nombre) VALUES
(1, 'Medición de pH'),
(2, 'Porcentaje de Humedad'),
(3, 'Inspección Visual de Sellado'),
(4, 'Prueba de Presencia de Alérgenos');


-- 2. Especializaciones de Tipo de Control
INSERT INTO Cuantitativo (ID_TipoControl, Unidad_de_Medida) VALUES
(1, 'Escala pH'),
(2, '% Porcentaje');

INSERT INTO Cualitativo (ID_TipoControl) VALUES
(3),
(4);


-- 3. Tablas con Dependencias de Nivel 1 (Fechas de Compra en 2025)
INSERT INTO Orden_Compra (ID_Compra, Fecha, ID_Moneda, ID_Proveedor) VALUES
(501, '2025-04-25', 1, 1),
(502, '2025-05-02', 3, 2),
(503, '2025-05-12', 1, 3);

INSERT INTO Materia_Prima (ID_Materia, Nombre, Descripcion, ID_Categoria, Precio_Unitario) VALUES
(1001, 'Leche Entera Pasteurizada', 'Leche cruda enfriada y tratada térmicamente', 1, 0.45),
(1002, 'Fermento Láctico en Polvo', 'Cepa pura para la producción de yogurt', 2, 12.50),
(1003, 'Botella PET 1 Litro', 'Envase plástico transparente con tapa de seguridad', 3, 0.15);


-- 4. Tablas con Dependencias de Nivel 2
INSERT INTO Detalle (ID_Compra, ID_Materia, PesoKG, Cantidad, Total) VALUES
(501, 1001, 5000.00, 5000, 2250.00),
(502, 1003, 150.00, 1000, 150.00),
(503, 1002, 25.00, 50, 625.00);

INSERT INTO Lote_Materia_Prima (ID_Lote, Cantidad, Fecha_Vencimiento, ID_Materia, ID_Recepcion, ID_Compra) VALUES
(9001, 5000, '2025-06-15', 1001, 101, 501),
(9002, 1006, '2026-05-10', 1003, 102, 502),
(9003, 50, '2025-11-15', 1002, 103, 503);


-- 5. Control de Calidad y Relación "Tiene"
INSERT INTO Control_De_Calidad (ID_Control, Descripcion, Hora, fecha, Valor_Medido, ID_TipoControl, ID_Empleado, ID_Lote, ID_Estado, ID_Rechazo) VALUES
(301, 'Medición de pH en tanque de recepción dando óptimo 6.6', '08:30:00', '2025-05-01', '6.6', 1, 10, 9001, 1, NULL),
(302, 'Control visual del lote de botellas PET', '10:15:00', '2025-05-10', 'Conforme', 3, 20, 9002, 1, NULL),
(303, 'Control de humedad superó el límite crítico del 5%', '14:00:00', '2025-05-15', '7.2%', 2, 30, 9003, 2, 3);

INSERT INTO Tiene (ID_Control, ID_Lote) VALUES
(301, 9001),
(302, 9002),
(303, 9003);


-- 6. Tablas Finales de Producción
INSERT INTO Lote_Produccion (ID_Lote_Produccion, Fecha_Elab) VALUES
(8001, '2025-05-02'),
(8002, '2025-05-12');

INSERT INTO Utiliza (ID_Lote_Produccion, ID_Lote, Cant) VALUES
(8001, 9001, 2500);
