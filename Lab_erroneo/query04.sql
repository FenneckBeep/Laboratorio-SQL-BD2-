SELECT  lmp.id_lote,
        p.nombre AS proveedor,
        mp.nombre AS materia_prima,
        r.fecha_recepcion,
        lmp.estado_lote,
        tc.nombre AS tipo_control,
        cdc.observacion,
        lp.id_lote_produccion
FROM lote_materia_prima lmp
JOIN materia_prima mp
ON lmp.id_materia = mp.id_materia
JOIN orden_compra oc
ON lmp.id_compra = oc.id_compra
JOIN proveedor p
ON oc.id_proveedor = p.id_proveedor
JOIN recepcion r
ON lmp.id_recepcion = r.id_recepcion
LEFT JOIN control_de_calidad cdc
ON lmp.id_lote = cdc.id_lote
LEFT JOIN tipo_control tc
ON cdc.id_tipo_control = tc.id_tipo_control
LEFT JOIN utiliza u
ON lmp.id_lote = u.id_lote
LEFT JOIN lote_produccion lp
ON u.id_lote_produccion = lp.id_lote_produccion
WHERE lmp.id_lote = 1;
