USE movilidad_urbana;

-- Conductores
INSERT INTO conductores (nombre, licencia) VALUES
('Juan Pérez', 'LIC001'),
('María Gómez', 'LIC002'),
('Carlos Sánchez', 'LIC003'),
('Ana Torres', 'LIC004'),
('Luis Fernández', 'LIC005');

-- Pasajeros
INSERT INTO pasajeros (nombre, email, telefono) VALUES
('Pedro López', 'pedro@mail.com', '111-111'),
('Lucía Díaz', 'lucia@mail.com', '222-222'),
('Martín Ruiz', 'martin@mail.com', '333-333'),
('Sofía Romero', 'sofia@mail.com', '444-444'),
('Diego Castro', 'diego@mail.com', '555-555');

-- Tipos de vehículo
INSERT INTO tiposvehiculo (nombre) VALUES
('Auto'),
('Moto'),
('Camioneta');

-- Vehículos
INSERT INTO vehiculos (id_conductor, patente, modelo, tiposvehiculo_id_tipo) VALUES
(1, 'AAA111', 'Toyota Corolla', 1),
(2, 'BBB222', 'Honda Civic', 1),
(3, 'CCC333', 'Yamaha FZ', 2),
(4, 'DDD444', 'Ford Ranger', 3),
(5, 'EEE555', 'Chevrolet Onix', 1);

-- Estados de viaje
INSERT INTO estadosviaje (nombre) VALUES
('Pendiente'),
('En curso'),
('Finalizado'),
('Cancelado');

-- Estados de pago
INSERT INTO estadospago (nombre) VALUES
('Pendiente'),
('Pagado'),
('Rechazado');

-- Métodos de pago
INSERT INTO metodospago (nombre) VALUES
('Efectivo'),
('Tarjeta'),
('Transferencia');

-- Viajes
INSERT INTO viajes (id_pasajero, id_conductor, origen, destino, fecha, duracion_min, tarifa) VALUES
(1, 1, 'Av. Siempre Viva 123', 'Plaza Central', NOW(), 15, 500.00),
(2, 2, 'Terminal', 'Universidad', NOW(), 25, 800.00),
(3, 3, 'Shopping', 'Hospital', NOW(), 10, 300.00),
(4, 4, 'Aeropuerto', 'Hotel Centro', NOW(), 35, 1200.00),
(5, 5, 'Estación Norte', 'Plaza Sur', NOW(), 20, 600.00);

-- Pagos
INSERT INTO pagos (id_viaje, monto, metodospago_id_metodo) VALUES
(1, 500.00, 1),
(2, 800.00, 2),
(3, 300.00, 1),
(4, 1200.00, 3),
(5, 600.00, 2);

-- Estados de pagos
INSERT INTO pago_estado (id_pago, id_estado) VALUES
(1, 2),
(2, 2),
(3, 2),
(4, 1),
(5, 2);

-- Estados de viajes
INSERT INTO viaje_estado (id_viaje, id_estado) VALUES
(1, 3),
(2, 3),
(3, 3),
(4, 1),
(5, 3);

-- Evaluaciones
INSERT INTO evaluaciones (id_viaje, calificacion, comentario, tipo) VALUES
(1, 5, 'Excelente viaje', 1),
(2, 4, 'Muy buen servicio', 1),
(3, 3, 'Aceptable', 1),
(4, 5, 'Pasajero puntual', 0),
(5, 2, 'Conductor atropello a un peaton mientra se reía', 1);
