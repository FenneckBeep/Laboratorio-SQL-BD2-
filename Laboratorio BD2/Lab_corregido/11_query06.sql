SELECT
    tc.ID_TipoControl,
    tc.Nombre AS tipo_control,
    COUNT(c.ID_Control) AS cantidad_realizada
FROM Tipo_Control tc
JOIN Control_De_Calidad c
    ON tc.ID_TipoControl = c.ID_TipoControl
WHERE c.Fecha BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY tc.ID_TipoControl, tc.Nombre
ORDER BY cantidad_realizada DESC
LIMIT 2;
