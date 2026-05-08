SELECT
    p.nombre AS proveedor,


    (
        COUNT(CASE
            WHEN lmp.id_rechazado IS NOT NULL
            THEN 1
        END) * 100.0
    ) / COUNT(lmp.id_lote) AS porcentaje_rechazo


FROM proveedor p


JOIN orden_compra oc
ON p.id_proveedor = oc.id_proveedor


JOIN lote_materia_prima lmp
ON oc.id_compra = lmp.id_compra


JOIN recepcion r
ON lmp.id_recepcion = r.id_recepcion


WHERE r.fecha_recepcion
BETWEEN '2025-01-01' AND '2025-12-31'


GROUP BY p.id_proveedor, p.nombre


HAVING (
    COUNT(CASE
        WHEN lmp.id_rechazado IS NOT NULL
        THEN 1
    END) * 100.0
) / COUNT(lmp.id_lote) > 20;
