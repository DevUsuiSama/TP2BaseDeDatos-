USE movilidad_urbana;

-- Índice compuesto en (fecha, id_conductor) para optimizar consultas frecuentes
-- que filtran viajes por rango de fechas y conductor específico.
-- Mejora el rendimiento en reportes operativos (ej. viajes diarios por conductor),
-- reduce tiempos de respuesta en auditorías y facilita generación de estadísticas.
CREATE INDEX idx_viajes_fecha_conductor ON viajes (fecha, id_conductor);
