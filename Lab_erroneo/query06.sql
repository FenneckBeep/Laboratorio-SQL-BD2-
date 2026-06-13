SELECT  tc.nombre AS tipo_control,
        COUNT(cdc.id_control) AS cantidad_controles
FROM tipo_control tc
JOIN control_de_calidad cdc
ON tc.id_tipo_control = cdc.id_tipo_control
WHERE cdc.fecha
BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY tc.id_tipo_control, tc.nombre
ORDER BY cantidad_controles DESC
LIMIT 2;
