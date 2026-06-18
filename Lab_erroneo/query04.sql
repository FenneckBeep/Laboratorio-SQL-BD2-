SELECT
    l.ID_Lote,
    p.Nombre AS proveedor,
    mp.Nombre AS materia_prima,
    r.Fecha_Recepcion,

    (
        SELECT e.Nombre_Estado
        FROM Control_De_Calidad c2
        JOIN Estado e ON c2.ID_Estado = e.ID_Estado
        WHERE c2.ID_Lote = l.ID_Lote
        ORDER BY c2.ID_Control DESC
        LIMIT 1
    ) AS estado_final,

    tc.Nombre AS tipo_control,
    c.Valor_Medido,
    lp.ID_Lote_Produccion

FROM Lote_Materia_Prima l
JOIN Materia_Prima mp ON l.ID_Materia = mp.ID_Materia
JOIN Orden_Compra oc ON l.ID_Compra = oc.ID_Compra
JOIN Proveedor p ON oc.ID_Proveedor = p.ID_Proveedor
JOIN Recepcion r ON l.ID_Recepcion = r.ID_Recepcion
LEFT JOIN Control_De_Calidad c ON l.ID_Lote = c.ID_Lote
LEFT JOIN Tipo_Control tc ON c.ID_TipoControl = tc.ID_TipoControl
LEFT JOIN Utiliza u ON l.ID_Lote = u.ID_Lote
LEFT JOIN Lote_Produccion lp ON u.ID_Lote_Produccion = lp.ID_Lote_Produccion
WHERE l.ID_Lote = 9007;
