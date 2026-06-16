--La idea es ordenarlo por fecha descendente. Si misma fecha, por hora descendente, se queda con el primero

WITH ultimo_control AS (
    SELECT DISTINCT ON (c.ID_Lote)
        c.ID_Lote,
        c.ID_Estado,
        c.Fecha,
        c.Hora
    FROM Control_De_Calidad c
    ORDER BY c.ID_Lote, c.Fecha DESC, c.Hora DESC
)

SELECT
    mp.ID_Materia,
    mp.Nombre,
    COUNT(DISTINCT l.ID_Lote) AS lotes_recibidos,

    COUNT(DISTINCT CASE
        WHEN uc.ID_Estado = 1 THEN l.ID_Lote
    END) AS lotes_aprobados,

    COUNT(DISTINCT CASE
        WHEN uc.ID_Estado = 2 THEN l.ID_Lote
    END) AS lotes_observados,

    COUNT(DISTINCT CASE
        WHEN uc.ID_Estado = 3 THEN l.ID_Lote
    END) AS lotes_rechazados

FROM Materia_Prima mp
JOIN Lote_Materia_Prima l
    ON mp.ID_Materia = l.ID_Materia
LEFT JOIN ultimo_control uc
    ON l.ID_Lote = uc.ID_Lote
JOIN Recepcion r
    ON l.ID_Recepcion = r.ID_Recepcion
WHERE r.Fecha_Recepcion BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY mp.ID_Materia, mp.Nombre
ORDER BY mp.ID_Materia;
