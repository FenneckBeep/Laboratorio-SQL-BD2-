-- ============================================================================
-- Vista Materialzada (Con Natural Joins) 
-- ============================================================================
CREATE MATERIALIZED VIEW informe_2025 AS
SELECT  p.nombre AS proveedor,
        COUNT(l.id_lote) AS total_lotes_recibidos,
        COUNT(c.id_control) AS lotes_aprobados,
        COUNT(c.id_rechazo) AS lotes_rechazados,
        COALESCE((COUNT(c.id_rechazo) * 100.0) / NULLIF(COUNT(c.id_lote), 0), 0) AS porcentaje_rechazo
FROM proveedor p
NATURAL JOIN orden_compra oc
NATURAL JOIN lote_materia_prima l
NATURAL JOIN recepcion r
LEFT JOIN control_de_calidad c ON l.id_lote = c.id_lote AND c.id_estado = 1
LEFT JOIN motivo_rechazo m ON c.id_rechazo = m.id_rechazo
WHERE r.fecha_recepcion >= '2025-01-01' AND r.fecha_recepcion <= '2025-12-31'
GROUP BY p.id_proveedor, p.nombre;


-- ============================================================================
-- Vista Materialzada (Con Joins) 
-- ============================================================================

CREATE MATERIALIZED VIEW informe_2025_2 AS
SELECT  
    p.Nombre AS proveedor,
    COUNT(DISTINCT l.ID_Lote) AS total_lotes_recibidos,
    
    -- Si ID_Estado = 1: (3-1)*(2-1) / 2 = 2/2 = 1. Si es 2 o 3, da 0.
    COALESCE(SUM((3 - c.ID_Estado) * (2 - c.ID_Estado) / 2), 0) AS lotes_aprobados,
    
    -- Si ID_Estado = 3: (3-1)*(3-2) / 2 = 2/2 = 1. Si es 1 o 2, da 0.
    COALESCE(SUM((c.ID_Estado - 1) * (c.ID_Estado - 2) / 2), 0) AS lotes_rechazados,
    
    -- Porcentaje de rechazo con la misma fórmula aritmética
    COALESCE(
        (COALESCE(SUM((c.ID_Estado - 1) * (c.ID_Estado - 2) / 2), 0) * 100.0) 
        / NULLIF(COUNT(DISTINCT l.ID_Lote), 0), 
        0
    ) AS porcentaje_rechazo

FROM 
    Proveedor p, 
    Orden_Compra oc, 
    Lote_Materia_Prima l, 
    Recepcion r, 
    Control_De_Calidad c
WHERE 
    -- Vinculación de tablas en el FROM antiguo
    p.ID_Proveedor = oc.ID_Proveedor
    AND oc.ID_Compra = l.ID_Compra
    AND l.ID_Recepcion = r.ID_Recepcion
    AND l.ID_Lote = c.ID_Lote
    
    -- Filtro por año
    AND r.Fecha_Recepcion >= '2025-01-01' 
    AND r.Fecha_Recepcion <= '2025-12-31'
GROUP BY 
    p.ID_Proveedor, p.Nombre;
-----------------
CREATE MATERIALIZED VIEW informe_2025 AS
SELECT  
    p.Nombre AS proveedor,
    COUNT(DISTINCT l.ID_Lote) AS total_lotes_recibidos,
    
    COUNT(DISTINCT CASE WHEN c.ID_Estado = 1 THEN l.ID_Lote END) AS lotes_aprobados,
    COUNT(DISTINCT CASE WHEN c.ID_Estado = 3 THEN l.ID_Lote END) AS lotes_rechazados,
    
    COALESCE(
        (COUNT(DISTINCT CASE WHEN c.ID_Estado = 3 THEN l.ID_Lote END) * 100.0) 
        / NULLIF(COUNT(DISTINCT l.ID_Lote), 0), 
        0
    ) AS porcentaje_rechazo

FROM Proveedor p
INNER JOIN Orden_Compra oc ON p.ID_Proveedor = oc.ID_Proveedor
INNER JOIN Lote_Materia_Prima l ON oc.ID_Compra = l.ID_Compra
INNER JOIN Recepcion r ON l.ID_Recepcion = r.ID_Recepcion
LEFT JOIN Control_De_Calidad c ON l.ID_Lote = c.ID_Lote

WHERE r.Fecha_Recepcion >= '2025-01-01' 
  AND r.Fecha_Recepcion <= '2025-12-31'
GROUP BY p.ID_Proveedor, p.Nombre;
