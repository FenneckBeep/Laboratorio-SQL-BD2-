SELECT
    mp.ID_Materia,
    mp.Nombre,
    COUNT(DISTINCT l.ID_Lote) AS cantidad_lotes_rechazados
FROM Materia_Prima mp
JOIN Lote_Materia_Prima l
    ON mp.ID_Materia = l.ID_Materia
JOIN Control_De_Calidad c
    ON l.ID_Lote = c.ID_Lote
WHERE c.ID_Estado = 3
  AND c.Fecha BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY mp.ID_Materia, mp.Nombre
ORDER BY cantidad_lotes_rechazados DESC
LIMIT 3;
