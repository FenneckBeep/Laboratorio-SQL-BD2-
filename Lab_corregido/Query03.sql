SELECT
    mp.Nombre AS materia_prima,
    COUNT(DISTINCT l.ID_Lote) AS lotes_recibidos,

    COUNT(DISTINCT CASE WHEN c.ID_Estado = 1 THEN l.ID_Lote END) AS lotes_aprobados,
    COUNT(DISTINCT CASE WHEN c.ID_Estado = 2 THEN l.ID_Lote END) AS lotes_observados,
    COUNT(DISTINCT CASE WHEN c.ID_Estado = 3 THEN l.ID_Lote END) AS lotes_rechazados

FROM Materia_Prima mp
JOIN Lote_Materia_Prima l
    ON mp.ID_Materia = l.ID_Materia
JOIN Recepcion r
    ON l.ID_Recepcion = r.ID_Recepcion
JOIN Control_De_Calidad c
    ON l.ID_Lote = c.ID_Lote

WHERE r.Fecha_Recepcion BETWEEN '2025-01-01' AND '2025-12-31'
AND c.ID_Control = (
    SELECT MAX(c2.ID_Control)
    FROM Control_De_Calidad c2
    WHERE c2.ID_Lote = l.ID_Lote
)

GROUP BY mp.ID_Materia, mp.Nombre;
