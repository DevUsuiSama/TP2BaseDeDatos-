USE movilidad_urbana;

-- Vista de viajes con detalle completo
CREATE OR REPLACE VIEW vw_viajes_detalle AS
SELECT v.id_viaje, p.nombre AS pasajero, c.nombre AS conductor,
       v.origen, v.destino, v.fecha, v.tarifa,
       ev.nombre AS estado_viaje
FROM viajes v
JOIN pasajeros p ON v.id_pasajero = p.id_pasajero
JOIN conductores c ON v.id_conductor = c.id_conductor
JOIN viaje_estado ve ON v.id_viaje = ve.id_viaje
JOIN estadosviaje ev ON ve.id_estado = ev.id_estado;

-- Vista de pagos con estado
CREATE OR REPLACE VIEW vw_pagos_detalle AS
SELECT pa.id_pago, v.id_viaje, pa.monto, m.nombre AS metodo,
       ep.nombre AS estado_pago
FROM pagos pa
JOIN metodospago m ON pa.metodospago_id_metodo = m.id_metodo
JOIN pago_estado pe ON pa.id_pago = pe.id_pago
JOIN estadospago ep ON pe.id_estado = ep.id_estado
LEFT JOIN viajes v ON pa.id_viaje = v.id_viaje;

-- Vista de evaluaciones de conductores
CREATE OR REPLACE VIEW vw_evaluaciones_conductores AS
SELECT c.nombre AS conductor, AVG(e.calificacion) AS promedio_calificacion, COUNT(*) AS total_evaluaciones
FROM evaluaciones e
JOIN viajes v ON e.id_viaje = v.id_viaje
JOIN conductores c ON v.id_conductor = c.id_conductor
WHERE e.tipo = 1
GROUP BY c.nombre;

-- consulta de prueba

SELECT * from vw_viajes_detalle;
