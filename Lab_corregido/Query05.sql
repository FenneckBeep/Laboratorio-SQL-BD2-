WITH ultimo_control AS (
    SELECT DISTINCT ON (c.ID_Lote)
        c.ID_Lote,
        c.ID_Estado
    FROM Control_De_Calidad c
    ORDER BY c.ID_Lote, c.Fecha DESC, c.Hora DESC
)

SELECT
    p.ID_Proveedor,
    p.Nombre AS proveedor,
    COUNT(DISTINCT l.ID_Lote) AS lotes_recibidos,

    COUNT(DISTINCT CASE
        WHEN uc.ID_Estado = 3 THEN l.ID_Lote
    END) AS lotes_rechazados,

    (
        COUNT(DISTINCT CASE
            WHEN uc.ID_Estado = 3 THEN l.ID_Lote
        END) * 100.0
        / NULLIF(COUNT(DISTINCT l.ID_Lote), 0)
    ) AS porcentaje_rechazo

FROM Proveedor p
JOIN Orden_Compra oc
    ON p.ID_Proveedor = oc.ID_Proveedor
JOIN Lote_Materia_Prima l
    ON oc.ID_Compra = l.ID_Compra
JOIN Recepcion r
    ON l.ID_Recepcion = r.ID_Recepcion
LEFT JOIN ultimo_control uc
    ON l.ID_Lote = uc.ID_Lote

WHERE r.Fecha_Recepcion BETWEEN '2025-01-01' AND '2025-12-31'

GROUP BY p.ID_Proveedor, p.Nombre

HAVING (
    COUNT(DISTINCT CASE
        WHEN uc.ID_Estado = 3 THEN l.ID_Lote
    END) * 100.0
    / NULLIF(COUNT(DISTINCT l.ID_Lote), 0)
) > 30

ORDER BY porcentaje_rechazo DESC;
