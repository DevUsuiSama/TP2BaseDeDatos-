INSERT INTO Pasajeros (nombre,email,telefono) VALUES
('Ana López','ana@mail.com','111-222'),
('Carlos Pérez','carlos@mail.com','333-444');

INSERT INTO Conductores (nombre,licencia) VALUES
('Luis Gómez','LIC123'),
('María Díaz','LIC456');

INSERT INTO Vehiculos (id_conductor,patente,modelo,tipo) VALUES
(1,'ABC123','Toyota Corolla','Auto'),
(2,'XYZ789','Honda Civic','Auto');

INSERT INTO Viajes (id_pasajero,id_conductor,origen,destino,fecha,duracion_min,tarifa,estado) VALUES
(1,1,'Plaza Central','Aeropuerto','2025-09-19 10:00:00',35,2500,'Realizado'),
(2,2,'Terminal','Universidad','2025-09-19 11:00:00',20,1500,'Realizado'),
(1,2,'Shopping','Hospital','2025-09-19 12:00:00',15,1200,'Cancelado');

INSERT INTO Pagos (id_viaje,metodo,monto,estado) VALUES
(1,'Tarjeta',2500,'Completado'),
(2,'Efectivo',1500,'Completado');

INSERT INTO Evaluaciones (id_viaje,calificacion,comentario,tipo) VALUES
(1,1,'Es mas seguro ir a pie', TRUE),
(1,4,'Buen pasajero', FALSE),
(2,3,'Conducción aceptable', TRUE);
