CREATE DATABASE movilidad_urbana;
USE movilidad_urbana;

-- Tabla de pasajeros
CREATE TABLE Pasajeros (
    id_pasajero INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    fecha_registro DATE DEFAULT (CURRENT_DATE)
);

-- Tabla de conductores
CREATE TABLE Conductores (
    id_conductor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    licencia VARCHAR(50) UNIQUE NOT NULL,
    fecha_alta DATE DEFAULT (CURRENT_DATE)
);

-- Tabla de vehículos
CREATE TABLE Vehiculos (
    id_vehiculo INT AUTO_INCREMENT PRIMARY KEY,
    id_conductor INT UNIQUE,
    patente VARCHAR(20) UNIQUE NOT NULL,
    modelo VARCHAR(50),
    tipo ENUM('Auto','Moto','Van') NOT NULL,
    FOREIGN KEY (id_conductor) REFERENCES Conductores(id_conductor)
);

-- Tabla de viajes
CREATE TABLE Viajes (
    id_viaje INT AUTO_INCREMENT PRIMARY KEY,
    id_pasajero INT NOT NULL,
    id_conductor INT NOT NULL,
    origen VARCHAR(200) NOT NULL,
    destino VARCHAR(200) NOT NULL,
    fecha DATETIME NOT NULL,
    duracion_min INT CHECK (duracion_min > 0),
    tarifa DECIMAL(10,2) CHECK (tarifa >= 0),
    estado ENUM('Realizado','Cancelado') DEFAULT 'Realizado',
    FOREIGN KEY (id_pasajero) REFERENCES Pasajeros(id_pasajero),
    FOREIGN KEY (id_conductor) REFERENCES Conductores(id_conductor)
);

-- Tabla de pagos
CREATE TABLE Pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_viaje INT UNIQUE,
    metodo ENUM('Efectivo','Tarjeta','QR','Billetera') NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    estado ENUM('Pendiente','Completado','Fallido') DEFAULT 'Completado',
    FOREIGN KEY (id_viaje) REFERENCES Viajes(id_viaje)
);

-- Tabla de evaluaciones
CREATE TABLE Evaluaciones (
    id_eval INT AUTO_INCREMENT PRIMARY KEY,
    id_viaje INT NOT NULL,
    calificacion TINYINT CHECK (calificacion BETWEEN 1 AND 5),
    comentario VARCHAR(255),
    tipo BOOLEAN NOT NULL COMMENT 'TRUE = Pasajero->Conductor, FALSE = Conductor->Pasajero',
    FOREIGN KEY (id_viaje) REFERENCES Viajes(id_viaje)
);

-- Índices adicionales
CREATE INDEX idx_viajes_fecha ON Viajes(fecha);
CREATE INDEX idx_viajes_conductor ON Viajes(id_conductor);
CREATE INDEX idx_viajes_pasajero ON Viajes(id_pasajero);
