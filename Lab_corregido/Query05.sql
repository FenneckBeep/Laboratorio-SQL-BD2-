SELECT
    p.ID_Proveedor,
    p.Nombre AS proveedor,

    (
        COUNT(
            DISTINCT CASE
                WHEN c.ID_Estado = 3 THEN l.ID_Lote
            END
        ) * 100.0
        /
        COUNT(DISTINCT l.ID_Lote)
    ) AS porcentaje_rechazo

FROM Proveedor p

JOIN Orden_Compra oc
    ON p.ID_Proveedor = oc.ID_Proveedor

JOIN Lote_Materia_Prima l
    ON oc.ID_Compra = l.ID_Compra

JOIN Recepcion r
    ON l.ID_Recepcion = r.ID_Recepcion

LEFT JOIN Control_De_Calidad c
    ON l.ID_Lote = c.ID_Lote

WHERE r.Fecha_Recepcion
BETWEEN '2025-01-01' AND '2025-12-31'

AND c.ID_Control = (
    SELECT MAX(c2.ID_Control)
    FROM Control_De_Calidad c2
    WHERE c2.ID_Lote = l.ID_Lote
)

GROUP BY p.ID_Proveedor, p.Nombre

HAVING (
    COUNT(
        DISTINCT CASE
            WHEN c.ID_Estado = 3 THEN l.ID_Lote
        END
    ) * 100.0
    /
    COUNT(DISTINCT l.ID_Lote)
) > 20;
