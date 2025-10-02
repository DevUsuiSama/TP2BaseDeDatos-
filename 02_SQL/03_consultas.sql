USE movilidad_urbana;

-- =====================================================
-- CONSULTAS GENERALES
-- =====================================================

-- 1. Listar todos los viajes con pasajero, conductor y estado actual
SELECT v.id_viaje, p.nombre AS pasajero, c.nombre AS conductor, ev.nombre AS estado
FROM viajes v
JOIN pasajeros p ON v.id_pasajero = p.id_pasajero
JOIN conductores c ON v.id_conductor = c.id_conductor
JOIN viaje_estado ve ON v.id_viaje = ve.id_viaje
JOIN estadosviaje ev ON ve.id_estado = ev.id_estado;

-- 2. Total recaudado por cada conductor
SELECT c.nombre, SUM(v.tarifa) AS total_recaudado
FROM viajes v
JOIN conductores c ON v.id_conductor = c.id_conductor
GROUP BY c.nombre;

-- 3. Promedio de calificación de cada conductor
SELECT c.nombre, AVG(e.calificacion) AS promedio_calificacion
FROM evaluaciones e
JOIN viajes v ON e.id_viaje = v.id_viaje
JOIN conductores c ON v.id_conductor = c.id_conductor
WHERE e.tipo = 1
GROUP BY c.nombre;

-- 4. Viajes pagados con tarjeta
SELECT v.id_viaje, p.nombre AS pasajero, pa.monto
FROM pagos pa
JOIN viajes v ON pa.id_viaje = v.id_viaje
JOIN pasajeros p ON v.id_pasajero = p.id_pasajero
JOIN metodospago m ON pa.metodospago_id_metodo = m.id_metodo
WHERE m.nombre = 'Tarjeta';

-- 5. Pasajeros con más viajes
SELECT p.nombre, COUNT(v.id_viaje) AS cantidad_viajes
FROM viajes v
JOIN pasajeros p ON v.id_pasajero = p.id_pasajero
GROUP BY p.nombre
ORDER BY cantidad_viajes DESC;

-- 6. Conductores con más evaluaciones negativas
SELECT c.nombre, COUNT(*) AS evaluaciones_negativas
FROM evaluaciones e
JOIN viajes v ON e.id_viaje = v.id_viaje
JOIN conductores c ON v.id_conductor = c.id_conductor
WHERE e.calificacion <= 2
GROUP BY c.nombre
ORDER BY evaluaciones_negativas DESC;

-- 7. Recaudación mensual
SELECT DATE_FORMAT(v.fecha, '%Y-%m') AS mes, SUM(v.tarifa) AS total_mes
FROM viajes v
GROUP BY mes
ORDER BY mes;

-- 8. Ranking de pasajeros por gasto total
SELECT p.nombre, SUM(pa.monto) AS gasto_total
FROM pagos pa
JOIN viajes v ON pa.id_viaje = v.id_viaje
JOIN pasajeros p ON v.id_pasajero = p.id_pasajero
GROUP BY p.nombre
ORDER BY gasto_total DESC;

-- 9. Tiempo promedio de viaje por conductor
SELECT c.nombre, AVG(v.duracion_min) AS promedio_duracion
FROM viajes v
JOIN conductores c ON v.id_conductor = c.id_conductor
GROUP BY c.nombre;

-- 10. Viajes cancelados
SELECT v.id_viaje, p.nombre AS pasajero, c.nombre AS conductor
FROM viajes v
JOIN viaje_estado ve ON v.id_viaje = ve.id_viaje
JOIN estadosviaje ev ON ve.id_estado = ev.id_estado
JOIN pasajeros p ON v.id_pasajero = p.id_pasajero
JOIN conductores c ON v.id_conductor = c.id_conductor
WHERE ev.nombre = 'Cancelado';

-- =====================================================
-- CONSULTAS PARA PROBAR CHECKS
-- =====================================================

-- 11. Intento de insertar un viaje con tarifa negativa (debe fallar por CHECK chk_tarifa)
-- INSERT INTO viajes (id_pasajero, id_conductor, origen, destino, fecha, duracion_min, tarifa)
-- VALUES (1, 1, 'Origen inválido', 'Destino inválido', NOW(), 10, -100.00);

-- 12. Intento de insertar una evaluación con calificación fuera de rango (debe fallar por CHECK chk_calificacion)
-- INSERT INTO evaluaciones (id_viaje, calificacion, comentario, tipo)
-- VALUES (1, 10, 'Valor inválido', 1);

-- 13. Intento de insertar un pasajero con email inválido (debe fallar por CHECK chk_email)
-- INSERT INTO pasajeros (nombre, email, telefono)
-- VALUES ('Test', 'correo_invalido', '000-000');

-- 14. Intento de insertar un método de pago con estado inválido (debe fallar por CHECK chk_estado_metodo)
-- INSERT INTO metodospago (nombre, estado) VALUES ('Criptomoneda', 5);

-- =====================================================
-- CONSULTAS PARA VISUALIZAR EVALUACIONES
-- =====================================================

-- 15. Todas las evaluaciones con detalle de pasajero y conductor
SELECT e.id_eval, v.id_viaje, p.nombre AS pasajero, c.nombre AS conductor,
       e.calificacion, e.comentario,
       CASE e.tipo WHEN 1 THEN 'Pasajero → Conductor' ELSE 'Conductor → Pasajero' END AS tipo_evaluacion
FROM evaluaciones e
JOIN viajes v ON e.id_viaje = v.id_viaje
JOIN pasajeros p ON v.id_pasajero = p.id_pasajero
JOIN conductores c ON v.id_conductor = c.id_conductor;

-- 16. Promedio de calificación por pasajero (cuando el conductor evalúa al pasajero)
SELECT p.nombre, AVG(e.calificacion) AS promedio_calificacion
FROM evaluaciones e
JOIN viajes v ON e.id_viaje = v.id_viaje
JOIN pasajeros p ON v.id_pasajero = p.id_pasajero
WHERE e.tipo = 0
GROUP BY p.nombre;

-- 17. Evaluaciones con comentarios (solo mostrar las que tienen texto)
SELECT e.id_eval, v.id_viaje, e.calificacion, e.comentario
FROM evaluaciones e
JOIN viajes v ON e.id_viaje = v.id_viaje
WHERE e.comentario IS NOT NULL AND e.comentario <> '';
