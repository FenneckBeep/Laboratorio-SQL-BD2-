CREATE MATERIALIZED VIEW informe_2025 AS
SELECT
    p.Nombre AS proveedor,
    COUNT(DISTINCT l.ID_Lote) AS total_lotes_recibidos,
    COUNT(
        DISTINCT CASE
            WHEN c.ID_Estado = 1 THEN l.ID_Lote
        END
    ) AS lotes_aprobados,
    COUNT(
        DISTINCT CASE
            WHEN c.ID_Estado = 3 THEN l.ID_Lote
        END
    ) AS lotes_rechazados,
    COALESCE(
        (
            COUNT(
                DISTINCT CASE
                    WHEN c.ID_Estado = 3 THEN l.ID_Lote
                END
            ) * 100.0
        ) / NULLIF(COUNT(DISTINCT l.ID_Lote), 0),
        0
    ) AS porcentaje_rechazo
FROM
    Proveedor p
    INNER JOIN Orden_Compra oc ON p.ID_Proveedor = oc.ID_Proveedor
    INNER JOIN Lote_Materia_Prima l ON oc.ID_Compra = l.ID_Compra
    INNER JOIN Recepcion r ON l.ID_Recepcion = r.ID_Recepcion
    LEFT JOIN Control_De_Calidad c ON l.ID_Lote = c.ID_Lote
WHERE
    r.Fecha_Recepcion >= '2025-01-01'
    AND r.Fecha_Recepcion <= '2025-12-31'
GROUP BY
    p.ID_Proveedor,
    p.Nombre;