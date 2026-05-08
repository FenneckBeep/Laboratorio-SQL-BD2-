SELECT
    p.nombre AS proveedor,
    oc.metodo_pago,
    SUM(d.cantidad * d.precio_unitario) AS total_comprado


FROM proveedor p


JOIN orden_compra oc
ON p.id_proveedor = oc.id_proveedor


JOIN detalle d
ON oc.id_compra = d.id_compra


WHERE oc.fecha BETWEEN '2025-01-01' AND '2025-12-31'


GROUP BY p.id_proveedor, p.nombre, oc.metodo_pago;
