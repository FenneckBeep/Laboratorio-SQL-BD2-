
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




