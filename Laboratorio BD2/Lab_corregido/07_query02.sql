SELECT
    p.ID_Proveedor,
    p.Nombre AS proveedor,
    m.Nombre_Moneda,
    SUM(d.Total) AS total_comprado
FROM Proveedor p
JOIN Orden_Compra oc
    ON p.ID_Proveedor = oc.ID_Proveedor
JOIN Moneda m
    ON oc.ID_Moneda = m.ID_Moneda
JOIN Detalle d
    ON oc.ID_Compra = d.ID_Compra
WHERE oc.Fecha BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY p.ID_Proveedor, p.Nombre, m.Nombre_Moneda
ORDER BY p.ID_Proveedor;
