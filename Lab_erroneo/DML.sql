INSERT INTO proveedor (id_proveedor, nombre, pais) VALUES 
(1, 'Truchas del Norte S.A.', 'Canadá'),
(2, 'Especias del Mundo', 'India'),
(3, 'Aceites del Sur', 'España'),
(4, 'Empaques Eco', 'Canadá');

INSERT INTO tipo_categoria (id_categoria, nombre) VALUES 
(1, 'Pescado Fresco'),
(2, 'Condimentos'),
(3, 'Aceites'),
(4, 'Envases');

INSERT INTO recepcion (id_recepcion, tipo, fecha_recepcion) VALUES 
(101, 'Entrada Camión 01', '2026-05-01'),
(102, 'Entrada Camión 02', '2026-05-02'),
(201, 'Descarga Marítima', '2025-02-15'),
(202, 'Transporte Terrestre', '2025-05-20'),
(203, 'Descarga Aérea', '2025-08-10'),
(204, 'Transporte Terrestre', '2025-11-05');

INSERT INTO motivo_rechazo (id_rechazado, descripcion, destino) VALUES 
(1, 'Temperatura fuera de rango', 'Devuelto al proveedor'),
(2, 'Envase roto o abierto', 'Descarte');

INSERT INTO empleado (id_empleado, nombre_1, nombre_2, apellido_1, apellido_2) VALUES 
(50, 'Juan', 'Carlos', 'Pérez', 'García'),
(51, 'Laura', NULL, 'Méndez', 'Sosa'),
(52, 'Carlos', 'Alberto', 'Ruiz', 'Díaz');

INSERT INTO estado (id_estado, nombre_estado) VALUES 
(1, 'Aprobado'),
(2, 'Rechazado'),
(3, 'Observado');

INSERT INTO tipo_control (id_tipo_control, nombre) VALUES 
(1, 'Temperatura'),
(2, 'Humedad'),
(3, 'Textura');

-- =========================================================
-- NIVEL 2: ENTIDADES RELACIONADAS (Dependen del Nivel 1)
-- =========================================================

INSERT INTO orden_compra (id_compra, fecha, metodo_pago, total, id_proveedor) VALUES 
(500, '2026-04-25', 'Transferencia', 1500.00, 1),
(501, '2026-04-26', 'Crédito', 800.00, 3),
(601, '2025-01-20', 'Transferencia', 2500.00, 1),
(602, '2025-05-01', 'Crédito', 1200.00, 3),
(603, '2025-07-15', 'Transferencia', 3000.00, 2),
(604, '2025-10-10', 'Contado', 500.00, 1);

INSERT INTO materia_prima (id_materia, nombre, descripcion, id_categoria) VALUES 
(10, 'Trucha Salmonada', 'Trucha entera limpia', 1),
(11, 'Aceite de Oliva', 'Extra virgen prensado en frío', 3),
(12, 'Frasco de Vidrio 200g', 'Envase primario', 4),
(13, 'Salmón Rosado', 'Filete con piel premium', 1),
(14, 'Pimienta Negra', 'Grano entero para moler', 2),
(15, 'Aceite de Girasol', 'Refinado para fritura', 3),
(16, 'Frasco de Vidrio 500g', 'Envase de vidrio reforzado', 4),
(17, 'Etiquetas Autoadhesivas', 'Papel resistente a humedad', 4),
(18, 'Merluza Hubbsi', 'Tronco de merluza sin espinas', 1),
(19, 'Paprika Ahumada', 'Polvo fino de calidad extra', 2),
(20, 'Caja de Cartón Máster', 'Embalaje para 24 unidades', 4),
(21, 'Tapas de Aluminio', 'Cierre hermético 63mm', 4),
(22, 'Cúrcuma en Polvo', 'Origen India 100% pura', 2);

INSERT INTO lote_produccion (id_lote_produccion, estado_lote, fecha_elab) VALUES 
(9001, 'Aprobado', '2026-05-05'),
(9002, 'En Proceso', '2026-05-06');

INSERT INTO detalle (id_compra, id_materia, unidad_de_medida, cantidad, precio_unitario) VALUES 
(500, 10, 'Kg', 100, 15.00),
(501, 11, 'Litros', 50, 16.00),
(601, 10, 'Kg', 200, 12.50),
(602, 11, 'Litros', 80, 15.00),
(603, 10, 'Kg', 150, 20.00),
(604, 10, 'Kg', 40, 12.50);

INSERT INTO lote_materia_prima (id_lote, cantidad, pais, estado_lote, fecha_vencimiento, id_materia, id_recepcion, id_compra, id_rechazado) VALUES 
(3001, 200, 'Canadá', 'Aprobado', '2025-04-15', 10, 201, 601, NULL),
(3002, 80, 'España', 'Observado', '2026-05-20', 11, 202, 602, NULL),
(3003, 150, 'India', 'Rechazado', '2025-09-10', 10, 203, 603, 1),
(3004, 40, 'Canadá', 'Aprobado', '2026-01-05', 10, 204, 604, NULL),
(2001, 100, 'Canadá', 'Aprobado', '2026-06-01', 10, 101, 500, NULL),
(2002, 50, 'España', 'Rechazado', '2025-01-01', 11, 102, 501, 1),
(4001, 120, 'Canadá', 'Aprobado', '2026-12-31', 10, 101, 500, NULL),
(4002, 30, 'España', 'Aprobado', '2027-01-15', 11, 102, 501, NULL),
(4003, 200, 'Canadá', 'Rechazado', '2025-03-01', 12, 101, 500, 2),
(4004, 55, 'India', 'Observado', '2026-08-20', 10, 203, 603, NULL),
(4005, 90, 'España', 'Aprobado', '2026-11-11', 11, 202, 602, NULL),
(4006, 15, 'Canadá', 'Aprobado', '2026-04-10', 10, 204, 604, NULL),
(4007, 300, 'Canadá', 'Rechazado', '2024-12-20', 12, 201, 601, 2),
(4008, 75, 'España', 'Aprobado', '2027-02-28', 11, 102, 501, NULL),
(4009, 60, 'Canadá', 'Aprobado', '2026-07-07', 10, 101, 601, NULL),
(4010, 25, 'India', 'Rechazado', '2025-05-05', 10, 203, 603, 1),
(5001, 120, 'Canadá', 'Aprobado', '2026-10-15', 13, 101, 500, NULL),
(5002, 30, 'India', 'Aprobado', '2027-05-20', 14, 203, 603, NULL),
(5003, 200, 'España', 'Aprobado', '2026-12-01', 15, 202, 602, NULL),
(5004, 500, 'Canadá', 'Observado', '2027-01-10', 16, 101, 500, NULL),
(5005, 1000, 'Canadá', 'Aprobado', '2028-01-01', 17, 101, 500, NULL),
(5006, 85, 'Canadá', 'Rechazado', '2025-06-15', 18, 201, 601, 1),
(5007, 45, 'India', 'Aprobado', '2026-09-30', 19, 203, 603, NULL),
(5008, 150, 'Canadá', 'Aprobado', '2027-03-22', 20, 101, 500, NULL),
(5009, 3000, 'Canadá', 'Rechazado', '2026-02-15', 21, 201, 601, 2),
(5010, 60, 'India', 'Aprobado', '2027-08-11', 22, 203, 603, NULL);

INSERT INTO control_de_calidad (id_control, unidad_de_medida, observacion, hora, fecha, aprobado, id_tipo_control, id_empleado, id_lote, id_estado) VALUES 
(1, '°C', 'Dentro de rango', '08:00:00', '2026-05-01', TRUE, 1, 50, 2001, 1),
(2, '°C', 'Llegó a 15°C', '10:00:00', '2026-05-02', FALSE, 1, 51, 2002, 2),
(10, '°C', 'Correcto', '09:00:00', '2025-02-15', TRUE, 1, 50, 3001, 1),
(11, 'Acidez', 'Dudoso', '14:30:00', '2025-05-21', FALSE, 1, 51, 3002, 3),
(12, 'Olor', 'Fuerte olor amoniaco', '11:00:00', '2025-08-11', FALSE, 3, 50, 3003, 2),
(13, '°C', 'Correcto', '08:45:00', '2025-11-05', TRUE, 1, 51, 3004, 1);

INSERT INTO tipo_de_control (id_materia, id_tipo_control, valor_numerico, descripcion_adicional) VALUES 
(10, 3, NULL, 'Control de firmeza de carne');

INSERT INTO utiliza (id_lote_produccion, id_lote, cantidad) VALUES 
(9001, 2001, 40),
(9002, 2001, 30),
(9001, 3001, 50);