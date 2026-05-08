SELECT
    mp.nombre AS materia_prima,
    COUNT(lmp.id_lote) AS cantidad_rechazos


FROM materia_prima mp


JOIN lote_materia_prima lmp
ON mp.id_materia = lmp.id_materia


JOIN recepcion r
ON lmp.id_recepcion = r.id_recepcion


WHERE lmp.id_rechazado IS NOT NULL
AND r.fecha_recepcion BETWEEN '2025-01-01' AND '2025-12-31'
