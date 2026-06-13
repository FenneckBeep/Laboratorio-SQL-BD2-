CREATE MATERIALIZED VIEW informe_2025 AS
SELECT  p.nombre AS proveedor,
        COUNT(l.id_lote) AS total_lotes_recibidos,
        COUNT(c.id_control) AS lotes_aprobados,
        COUNT(m.id_rechazado) AS lotes_rechazados,
        (COUNT(m.id_rechazado) * 100.0) / NULLIF(COUNT(l.id_lote), 0) AS porcentaje_rechazo
FROM proveedor p
NATURAL JOIN orden_compra oc
NATURAL JOIN lote_materia_prima l
NATURAL JOIN recepcion r
LEFT JOIN control_de_calidad c ON l.id_lote = c.id_lote AND c.aprobado = TRUE
LEFT JOIN motivo_rechazo m ON l.id_rechazado = m.id_rechazado
WHERE r.fecha_recepcion >= '2025-01-01' AND r.fecha_recepcion <= '2025-12-31'
GROUP BY p.id_proveedor, p.nombre;


posibles cambios
CREATE MATERIALIZED VIEW informe_2025 AS
SELECT  p.nombre AS proveedor,
        COUNT(l.id_lote) AS total_lotes_recibidos,
        COUNT(DISTINCT CASE WHEN c.aprobado = TRUE THEN l.id_lote END) AS lotes_aprobados,
        COUNT(DISTINCT l.id_rechazado) AS lotes_rechazados,
        (COUNT(DISTINCT l.id_rechazado) * 100.0) / NULLIF(COUNT(l.id_lote), 0) AS porcentaje_rechazo
FROM proveedor p
INNER JOIN orden_compra oc ON p.id_proveedor = oc.id_proveedor
INNER JOIN lote_materia_prima l ON oc.id_compra = l.id_compra
INNER JOIN recepcion r ON l.id_recepcion = r.id_recepcion
LEFT JOIN control_de_calidad c ON l.id_lote = c.id_lote
WHERE r.fecha_recepcion BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY p.nombre;

