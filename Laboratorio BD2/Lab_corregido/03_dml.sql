
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

INSERT INTO Cuantitativo (ID_TipoControl,Unidad_de_Medida,Valor_Min,Valor_Max) VALUES
(1,'Escala pH',6.40,6.80),
(2,'% Humedad',0.00,5.00);

INSERT INTO Integridad_Envase (ID_Integridad, Nombre_Integridad) VALUES
(1,'Excelente'),
(2,'Normal'),
(3,'Con daños'),
(4,'Inaceptable');

INSERT INTO Cualitativo (ID_TipoControl, ID_Integridad) VALUES
(3,1),
(4,2);


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
 '14:00:00', '2025-05-15', '7.2',
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
 '11:45:00', '2025-06-10', '8.1',
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



-- ============================================================================
-- 9. DATOS EXTENDIDOS - CASOS DE PRUEBA ADICIONALES
--    Objetivo: cubrir los bordes de fn_calcular_estado_lote() y ampliar
--    el catalogo de proveedores/materias/tipos de control para no depender
--    siempre de los mismos 3 productos.
-- ============================================================================

-- --- Nuevos maestros ---------------------------------------------------

INSERT INTO Proveedor (ID_Proveedor, Nombre, Pais) VALUES
(4, 'Especias y Condimentos del Caribe S.A.', 'México'),
(5, 'Aceites Puros del Valle', 'España');

INSERT INTO Tipo_Categoria (ID_Categoria, Nombre) VALUES
(4, 'Especias y Condimentos'),
(5, 'Aceites y Grasas');

INSERT INTO Empleado (ID_Empleado, Nombre1, Nombre2, Apellido1, Apellido2) VALUES
(40, 'Sofía', 'Raquel', 'Núñez', 'Paredes'),
(50, 'Diego', 'Andrés', 'Fernández', 'Rojas');

INSERT INTO Motivo_Rechazo (ID_Rechazo, Descripcion_Rechazo, Destino) VALUES
(4, 'Valor medido fuera del rango de tolerancia permitido', 'Devolución al Proveedor'),
(5, 'Resultado cualitativo no conforme con la norma de calidad', 'Destrucción Sanitaria');

INSERT INTO Tipo_Control (ID_TipoControl, Nombre) VALUES
(5, 'Índice de Acidez'),
(6, 'Prueba de Color');

INSERT INTO Cuantitativo (ID_TipoControl, Unidad_de_Medida, Valor_Min, Valor_Max) VALUES
(5, '% Acidez Oleica', 0.10, 0.50);

INSERT INTO Cualitativo (ID_TipoControl, ID_Integridad) VALUES
(6, 4);

-- --- Nuevas materias primas y su compra/recepcion -----------------------

INSERT INTO Materia_Prima
(ID_Materia, Nombre, Descripcion, ID_Categoria, Precio_Unitario)
VALUES
(1004, 'Aceite de Oliva Extra Virgen',
 'Aceite de primera prensada en frío', 5, 8.90),

(1005, 'Pimentón Ahumado en Polvo',
 'Especia molida, tueste ahumado tradicional', 4, 15.20),

(1006, 'Benzoato de Sodio (Conservante)',
 'Conservante grado alimenticio para productos lácteos', 2, 6.30);

INSERT INTO Recepcion (ID_Recepcion, Fecha_Recepcion) VALUES
(110, '2025-06-27'), (111, '2025-06-27'), (112, '2025-06-28'),
(113, '2025-06-28'), (114, '2025-06-29'), (115, '2025-06-29'),
(116, '2025-06-30'), (117, '2025-06-30'), (118, '2025-07-01'),
(119, '2025-07-01'), (120, '2025-07-02'), (121, '2025-07-02'),
(122, '2025-07-03'), (123, '2025-07-03');

INSERT INTO Orden_Compra (ID_Compra, Fecha, ID_Moneda, ID_Proveedor) VALUES
(510, '2025-06-20', 1, 1), (511, '2025-06-20', 1, 1),
(512, '2025-06-21', 1, 1), (513, '2025-06-21', 1, 1),
(514, '2025-06-22', 1, 1), (515, '2025-06-22', 3, 3),
(516, '2025-06-23', 3, 3), (517, '2025-06-24', 2, 5),
(518, '2025-06-24', 2, 5), (519, '2025-06-25', 1, 4),
(520, '2025-06-25', 1, 4), (521, '2025-06-26', 1, 3),
(522, '2025-06-26', 2, 5), (523, '2025-06-27', 1, 4);

INSERT INTO Detalle (ID_Compra, ID_Materia, PesoKG, Cantidad, Total) VALUES
(510, 1001, 4000.00, 4000, 1800.00),
(511, 1001, 4000.00, 4000, 1800.00),
(512, 1001, 4000.00, 4000, 1800.00),
(513, 1001, 4000.00, 4000, 1800.00),
(514, 1001, 4000.00, 4000, 1800.00),
(515, 1002, 30.00, 60, 750.00),
(516, 1002, 30.00, 60, 750.00),
(517, 1004, 500.00, 500, 4450.00),
(518, 1004, 500.00, 500, 4450.00),
(519, 1005, 100.00, 100, 1520.00),
(520, 1005, 100.00, 100, 1520.00),
(521, 1006, 200.00, 200, 1260.00),
(522, 1004, 500.00, 500, 4450.00),
(523, 1005, 100.00, 100, 1520.00);

-- --- Lotes: uno por cada caso limite que queremos poder probar ----------

INSERT INTO Lote_Materia_Prima
(ID_Lote, Cantidad, Fecha_Vencimiento, ID_Materia, ID_Recepcion, ID_Compra)
VALUES
(9010, 4000, '2025-07-27', 1001, 110, 510),  -- pH exacto en el minimo (6.40)
(9011, 4000, '2025-07-27', 1001, 111, 511),  -- pH exacto en el maximo (6.80)
(9012, 4000, '2025-07-28', 1001, 112, 512),  -- pH apenas por debajo (Observado)
(9013, 4000, '2025-07-28', 1001, 113, 513),  -- pH apenas por encima (Observado)
(9014, 4000, '2025-07-29', 1001, 114, 514),  -- pH muy fuera de rango (Rechazado)
(9015, 60,   '2025-12-29', 1002, 115, 515),  -- Humedad exacta en el minimo (0.00)
(9016, 60,   '2025-12-30', 1002, 116, 516),  -- Humedad exacta en el maximo (5.00)
(9017, 500,  '2026-06-24', 1004, 117, 517),  -- Acidez exacta en el minimo (0.10)
(9018, 500,  '2026-06-24', 1004, 118, 518),  -- Acidez muy fuera de rango (Rechazado)
(9019, 100,  '2026-06-25', 1005, 119, 519),  -- Cualitativo: palabra "Aprobado" (Aprobado)
(9020, 100,  '2026-06-25', 1005, 120, 520),  -- Cualitativo: palabra "Positivo" (Rechazado, ojo que no es lo que parece)
(9021, 200,  '2026-06-26', 1006, 121, 521),  -- Cualitativo: palabra no reconocida (Observado)
(9022, 500,  '2026-06-26', 1004, 122, 522),  -- Nunca controlado (pendiente en Opcion 1)
(9023, 100,  '2026-06-27', 1005, 123, 523);  -- Nunca controlado (pendiente en Opcion 1)

-- --- Controles de calidad para los casos de arriba ----------------------

INSERT INTO Control_De_Calidad
(ID_Control, Descripcion, Hora, fecha, Valor_Medido,
 ID_TipoControl, ID_Empleado, ID_Lote, ID_Estado, ID_Rechazo)
VALUES

(312, 'pH exacto en el limite inferior del rango permitido',
 '08:00:00', '2025-06-28', '6.40',
 1, 10, 9010, 1, NULL),

(313, 'pH exacto en el limite superior del rango permitido',
 '08:15:00', '2025-06-28', '6.80',
 1, 20, 9011, 1, NULL),

(314, 'pH levemente por debajo del minimo, dentro del margen de tolerancia',
 '08:30:00', '2025-06-29', '6.37',
 1, 30, 9012, 2, NULL),

(315, 'pH levemente por encima del maximo, dentro del margen de tolerancia',
 '08:45:00', '2025-06-29', '6.83',
 1, 40, 9013, 2, NULL),

(316, 'pH muy por debajo del rango, fuera de todo margen aceptable',
 '09:00:00', '2025-06-30', '6.20',
 1, 50, 9014, 3, 4),

(317, 'Humedad exacta en el limite inferior (producto muy seco pero aceptable)',
 '09:15:00', '2025-06-30', '0.00',
 2, 10, 9015, 1, NULL),

(318, 'Humedad exacta en el limite superior permitido',
 '09:30:00', '2025-07-01', '5.00',
 2, 20, 9016, 1, NULL),

(319, 'Acidez exacta en el limite inferior del rango',
 '09:45:00', '2025-07-01', '0.10',
 5, 30, 9017, 1, NULL),

(320, 'Acidez muy por encima del rango tolerado',
 '10:00:00', '2025-07-02', '0.90',
 5, 40, 9018, 3, 4),

(321, 'Color evaluado como conforme a la norma interna',
 '10:15:00', '2025-07-02', 'Aprobado',
 6, 50, 9019, 1, NULL),

(322, 'Color con tono no esperado, se marca resultado positivo a defecto',
 '10:30:00', '2025-07-03', 'Positivo',
 6, 10, 9020, 3, 5),

(323, 'Resultado dudoso, no encuadra en ninguna categoria predefinida',
 '10:45:00', '2025-07-03', 'Dudoso',
 3, 20, 9021, 2, NULL);


-- ============================================================================
-- 10. RELACIÓN TIENE (extendido)
-- ============================================================================

INSERT INTO Tiene (ID_Control, ID_Lote) VALUES
(312, 9010), (313, 9011), (314, 9012), (315, 9013), (316, 9014),
(317, 9015), (318, 9016), (319, 9017), (320, 9018),
(321, 9019), (322, 9020), (323, 9021);


-- ============================================================================
-- 11. PRODUCCION (extendido) - trazabilidad con los nuevos lotes Aprobados
-- ============================================================================

INSERT INTO Lote_Produccion (ID_Lote_Produccion, Fecha_Elab) VALUES
(8005, '2025-07-05'),
(8006, '2025-07-10');

INSERT INTO Utiliza (ID_Lote_Produccion, ID_Lote, Cant) VALUES
(8005, 9010, 1000),
(8005, 9015, 15),
(8006, 9011, 1200),
(8006, 9017, 50),
(8006, 9019, 5);
