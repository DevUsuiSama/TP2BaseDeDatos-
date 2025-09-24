-- 1. Listar viajes realizados con datos de pasajero y conductor
SELECT v.id_viaje, p.nombre AS pasajero, c.nombre AS conductor, v.tarifa
FROM Viajes v
JOIN Pasajeros p ON v.id_pasajero = p.id_pasajero
JOIN Conductores c ON v.id_conductor = c.id_conductor
WHERE v.estado = 'Realizado';

-- 2. Total facturado por cada conductor
SELECT c.nombre, SUM(v.tarifa) AS total_facturado
FROM Viajes v
JOIN Conductores c ON v.id_conductor = c.id_conductor
WHERE v.estado = 'Realizado'
GROUP BY c.nombre;

-- 3. Promedio de calificación de cada conductor
SELECT c.nombre, AVG(e.calificacion) AS promedio
FROM Conductores c
JOIN Viajes v ON c.id_conductor = v.id_conductor
JOIN Evaluaciones e ON v.id_viaje = e.id_viaje
WHERE e.tipo = TRUE
GROUP BY c.nombre;

-- 4. Viajes cancelados por pasajero
SELECT p.nombre, COUNT(*) AS cancelados
FROM Viajes v
JOIN Pasajeros p ON v.id_pasajero = p.id_pasajero
WHERE v.estado = 'Cancelado'
GROUP BY p.nombre;

-- 5. Top 3 pasajeros con mayor gasto
SELECT p.nombre, SUM(v.tarifa) AS gasto_total
FROM Viajes v
JOIN Pasajeros p ON v.id_pasajero = p.id_pasajero
WHERE v.estado='Realizado'
GROUP BY p.nombre
ORDER BY gasto_total DESC
LIMIT 3;

-- 6. Conductores con más de 1 viaje en un día
SELECT c.nombre, DATE(v.fecha) AS dia, COUNT(*) AS cantidad
FROM Viajes v
JOIN Conductores c ON v.id_conductor = c.id_conductor
GROUP BY c.nombre, DATE(v.fecha)
HAVING COUNT(*) > 1;

-- 7. Subconsulta: pasajeros que nunca cancelaron un viaje
SELECT nombre
FROM Pasajeros
WHERE id_pasajero NOT IN (
    SELECT id_pasajero FROM Viajes WHERE estado='Cancelado'
);

-- 8. Método de pago más usado
SELECT metodo, COUNT(*) AS cantidad
FROM Pagos
GROUP BY metodo
ORDER BY cantidad DESC
LIMIT 1;

-- 9. Ranking de conductores por calificación promedio
SELECT c.nombre, ROUND(AVG(e.calificacion),2) AS promedio
FROM Conductores c
JOIN Viajes v ON c.id_conductor = v.id_conductor
JOIN Evaluaciones e ON v.id_viaje = e.id_viaje
WHERE e.tipo=TRUE
GROUP BY c.nombre
ORDER BY promedio DESC;

-- 10. Ingresos por día
SELECT DATE(fecha) AS dia, SUM(tarifa) AS ingresos
FROM Viajes
WHERE estado='Realizado'
GROUP BY DATE(fecha);
