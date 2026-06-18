
-- DML: INSERCION DE DATOS DE PRUEBA COMPLETO
-- Estados:
-- 1 = Aprobado
-- 2 = Observado
-- 3 = Rechazado

-- ============================================================================
-- 1. TABLAS MAESTRAS INDEPENDIENTES
-- ============================================================================

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
(103, '2025-05-15'),
(104, '2025-06-01'),
(105, '2025-06-05'),
(106, '2025-06-10'),
(107, '2025-06-15'),
(108, '2025-06-20'),
(109, '2025-06-25');


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
(2, 'Observado'),
(3, 'Rechazado');


INSERT INTO Tipo_Control (ID_TipoControl, Nombre) VALUES
(1, 'Medición de pH'),
(2, 'Porcentaje de Humedad'),
(3, 'Inspección Visual de Sellado'),
(4, 'Prueba de Presencia de Alérgenos');


-- ============================================================================
-- 2. ESPECIALIZACIONES
-- ============================================================================

INSERT INTO Cuantitativo (ID_TipoControl, Unidad_de_Medida) VALUES
(1, 'Escala pH'),
(2, '% Porcentaje');

INSERT INTO Cualitativo (ID_TipoControl) VALUES
(3),
(4);


-- ============================================================================
-- 3. ORDENES DE COMPRA Y MATERIAS PRIMAS
-- ============================================================================

INSERT INTO Orden_Compra (ID_Compra, Fecha, ID_Moneda, ID_Proveedor) VALUES
(501, '2025-04-25', 1, 1),
(502, '2025-05-02', 3, 2),
(503, '2025-05-12', 1, 3),
(504, '2025-05-30', 1, 1),
(505, '2025-06-02', 3, 2),
(506, '2025-06-07', 1, 3),
(507, '2025-06-12', 3, 1),
(508, '2025-06-19', 3, 2),
(509, '2025-06-24', 1, 3);


INSERT INTO Materia_Prima
(ID_Materia, Nombre, Descripcion, ID_Categoria, Precio_Unitario)
VALUES
(1001, 'Leche Entera Pasteurizada',
 'Leche cruda enfriada y tratada térmicamente', 1, 0.45),

(1002, 'Fermento Láctico en Polvo',
 'Cepa pura para la producción de yogurt', 2, 12.50),

(1003, 'Botella PET 1 Litro',
 'Envase plástico transparente con tapa de seguridad', 3, 0.15);


-- ============================================================================
-- 4. DETALLE DE COMPRAS
-- ============================================================================

INSERT INTO Detalle
(ID_Compra, ID_Materia, PesoKG, Cantidad, Total)
VALUES
(501, 1001, 5000.00, 5000, 2250.00),
(502, 1003, 150.00, 1000, 150.00),
(503, 1002, 25.00, 50, 625.00),
(504, 1001, 3000.00, 3000, 1350.00),
(505, 1003, 200.00, 1200, 180.00),
(506, 1002, 40.00, 80, 1000.00),
(507, 1001, 1500.00, 1500, 675.00),
(508, 1003, 300.00, 2000, 300.00),
(509, 1002, 20.00, 20, 250.00);


-- ============================================================================
-- 5. LOTES DE MATERIA PRIMA
-- ============================================================================

INSERT INTO Lote_Materia_Prima
(ID_Lote, Cantidad, Fecha_Vencimiento, ID_Materia, ID_Recepcion, ID_Compra)
VALUES
(9001, 5000, '2025-06-15', 1001, 101, 501),
(9002, 1000, '2026-05-10', 1003, 102, 502),
(9003, 50, '2025-11-15', 1002, 103, 503),
(9004, 3000, '2025-07-15', 1001, 104, 504),
(9005, 1200, '2026-06-01', 1003, 105, 505),
(9006, 80, '2025-12-01', 1002, 106, 506),
(9007, 1500, '2025-08-15', 1001, 107, 507),
(9008, 2000, '2026-06-20', 1003, 108, 508),
(9009, 20, '2025-12-31', 1002, 109, 509);


-- ============================================================================
-- 6. CONTROLES DE CALIDAD
-- ============================================================================

INSERT INTO Control_De_Calidad
(ID_Control, Descripcion, Hora, fecha, Valor_Medido,
 ID_TipoControl, ID_Empleado, ID_Lote, ID_Estado, ID_Rechazo)
VALUES

(301, 'Medición de pH en tanque de recepción dando óptimo 6.6',
 '08:30:00', '2025-05-01', '6.6',
 1, 10, 9001, 1, NULL),

(302, 'Control visual del lote de botellas PET',
 '10:15:00', '2025-05-10', 'Conforme',
 3, 20, 9002, 1, NULL),

(303, 'Control de humedad superó el límite crítico del 5%',
 '14:00:00', '2025-05-15', '7.2%',
 2, 30, 9003, 3, 3),

(304, 'pH ligeramente fuera de rango',
 '09:00:00', '2025-06-01', '6.1',
 1, 10, 9004, 2, NULL),

(305, 'Reinspección: contaminación detectada',
 '15:00:00', '2025-06-02', '5.8',
 1, 20, 9004, 3, 1),

(306, 'Sellado correcto',
 '10:30:00', '2025-06-05', 'Conforme',
 3, 20, 9005, 1, NULL),

(307, 'Humedad fuera del rango',
 '11:45:00', '2025-06-10', '8.1%',
 2, 30, 9006, 3, 3),

(308, 'Posible presencia de alérgeno',
 '08:20:00', '2025-06-15', 'Pendiente',
 4, 10, 9007, 2, NULL),

(309, 'Reinspección aprobada',
 '16:00:00', '2025-06-16', 'Negativo',
 4, 20, 9007, 1, NULL),

(310, 'Botellas con sellado defectuoso',
 '12:00:00', '2025-06-20', 'Defectuoso',
 3, 30, 9008, 3, 2),

(311, 'Lote en cuarentena por resultado dudoso',
 '09:30:00', '2025-06-25', 'Pendiente',
 4, 10, 9009, 2, NULL);


-- ============================================================================
-- 7. RELACIÓN TIENE
-- ============================================================================

INSERT INTO Tiene (ID_Control, ID_Lote) VALUES
(301, 9001),
(302, 9002),
(303, 9003),
(304, 9004),
(305, 9004),
(306, 9005),
(307, 9006),
(308, 9007),
(309, 9007),
(310, 9008),
(311, 9009);


-- ============================================================================
-- 8. PRODUCCION
-- ============================================================================

INSERT INTO Lote_Produccion (ID_Lote_Produccion, Fecha_Elab) VALUES
(8001, '2025-05-02'),
(8002, '2025-05-12'),
(8003, '2025-06-06'),
(8004, '2025-06-18');


INSERT INTO Utiliza (ID_Lote_Produccion, ID_Lote, Cant) VALUES
(8001, 9001, 2500),
(8003, 9005, 600),
(8004, 9007, 750);
