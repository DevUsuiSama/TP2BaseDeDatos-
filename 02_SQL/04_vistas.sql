CREATE VIEW Vista_Resumen_Conductores AS
SELECT c.nombre AS conductor,
       COUNT(v.id_viaje) AS viajes_realizados,
       SUM(v.tarifa) AS ingresos,
       ROUND(AVG(e.calificacion),2) AS promedio_calificacion
FROM Conductores c
LEFT JOIN Viajes v ON c.id_conductor = v.id_conductor AND v.estado='Realizado'
LEFT JOIN Evaluaciones e ON v.id_viaje = e.id_viaje AND e.tipo=TRUE
GROUP BY c.nombre;
