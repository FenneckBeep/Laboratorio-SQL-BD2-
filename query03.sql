SELECT mp.nombre AS materia_prima,
        COUNT(lmp.id_lote) AS lotes_recibidos,
        COUNT(CASE
            WHEN lmp.estado_lote = 'Aprobado'
            THEN 1
        END) AS lotes_aprobados,
        COUNT(CASE
            WHEN lmp.estado_lote = 'Rechazado'
            THEN 1
        END) AS lotes_rechazados,
        COUNT(CASE
            WHEN lmp.estado_lote = 'Observado'
            THEN 1
        END) AS lotes_observados
FROM materia_prima mp
JOIN lote_materia_prima lmp
ON mp.id_materia = lmp.id_materia
JOIN recepcion r
ON lmp.id_recepcion = r.id_recepcion
WHERE r.fecha_recepcion BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY mp.id_materia, mp.nombre;
