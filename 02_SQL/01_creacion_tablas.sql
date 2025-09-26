CREATE DATABASE movilidad_urbana;
USE movilidad_urbana;

-- =========================
-- Tabla de pasajeros
-- =========================
CREATE TABLE Pasajeros (
    id_pasajero INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    fecha_registro DATE DEFAULT (CURRENT_DATE)
);

-- =========================
-- Tabla de conductores
-- =========================
CREATE TABLE Conductores (
    id_conductor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    licencia VARCHAR(50) UNIQUE NOT NULL,
    fecha_alta DATE DEFAULT (CURRENT_DATE)
);

-- =========================
-- Catálogo de tipos de vehículo
-- =========================
CREATE TABLE TiposVehiculo (
    id_tipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,   -- Ej: Auto, Moto, Van
    estado BOOLEAN DEFAULT TRUE           -- Activo/Inactivo
);

-- =========================
-- Tabla de vehículos   
-- =========================
CREATE TABLE Vehiculos (
    id_vehiculo INT AUTO_INCREMENT PRIMARY KEY,
    id_conductor INT UNIQUE,
    patente VARCHAR(20) UNIQUE NOT NULL,
    modelo VARCHAR(50),
    FOREIGN KEY (id_conductor) REFERENCES Conductores(id_conductor)
);

-- =========================
-- Tabla intermedia Vehiculo <-> Tipo
-- =========================
CREATE TABLE Vehiculo_Tipo (
    id_vehiculo INT NOT NULL,
    id_tipo INT NOT NULL,
    fecha_asignacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_vehiculo, id_tipo, fecha_asignacion),
    FOREIGN KEY (id_vehiculo) REFERENCES Vehiculos(id_vehiculo),
    FOREIGN KEY (id_tipo) REFERENCES TiposVehiculo(id_tipo)
);

-- =========================
-- Catálogo de estados de viaje
-- =========================
CREATE TABLE EstadosViaje (
    id_estado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,   -- Ej: Realizado, Cancelado, Pendiente
    estado BOOLEAN DEFAULT TRUE           -- Activo/Inactivo
);

-- =========================
-- Tabla de viajes
-- =========================
CREATE TABLE Viajes (
    id_viaje INT AUTO_INCREMENT PRIMARY KEY,
    id_pasajero INT NOT NULL,
    id_conductor INT NOT NULL,
    origen VARCHAR(200) NOT NULL,
    destino VARCHAR(200) NOT NULL,
    fecha DATETIME NOT NULL,
    duracion_min INT CHECK (duracion_min > 0),
    tarifa DECIMAL(10,2) CHECK (tarifa >= 0),
    FOREIGN KEY (id_pasajero) REFERENCES Pasajeros(id_pasajero),
    FOREIGN KEY (id_conductor) REFERENCES Conductores(id_conductor)
);

-- =========================
-- Relación intermedia Viaje <-> Estado
-- =========================
CREATE TABLE Viaje_Estado (
    id_viaje INT NOT NULL,
    id_estado INT NOT NULL,
    fecha_cambio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_viaje, id_estado, fecha_cambio),
    FOREIGN KEY (id_viaje) REFERENCES Viajes(id_viaje),
    FOREIGN KEY (id_estado) REFERENCES EstadosViaje(id_estado)
);

-- =========================
-- Catálogos de pagos
-- =========================
CREATE TABLE MetodosPago (
    id_metodo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,   -- Ej: Efectivo, Tarjeta, QR, Billetera
    estado BOOLEAN DEFAULT TRUE           -- Activo/Inactivo
);

CREATE TABLE EstadosPago (
    id_estado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,   -- Ej: Pendiente, Completado, Fallido
    estado BOOLEAN DEFAULT TRUE           -- Activo/Inactivo
);

-- =========================
-- Tabla principal de pagos
-- =========================
CREATE TABLE Pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_viaje INT UNIQUE,
    monto DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_viaje) REFERENCES Viajes(id_viaje)
);

-- =========================
-- Tablas intermedias de pagos
-- =========================

-- Relación Pago <-> Método
CREATE TABLE Pago_Metodo (
    id_pago INT NOT NULL,
    id_metodo INT NOT NULL,
    PRIMARY KEY (id_pago, id_metodo),
    FOREIGN KEY (id_pago) REFERENCES Pagos(id_pago),
    FOREIGN KEY (id_metodo) REFERENCES MetodosPago(id_metodo)
);

-- Relación Pago <-> Estado (con historial)
CREATE TABLE Pago_Estado (
    id_pago INT NOT NULL,
    id_estado INT NOT NULL,
    fecha_cambio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_pago, id_estado, fecha_cambio),
    FOREIGN KEY (id_pago) REFERENCES Pagos(id_pago),
    FOREIGN KEY (id_estado) REFERENCES EstadosPago(id_estado)
);

-- =========================
-- Tabla de evaluaciones
-- =========================
CREATE TABLE Evaluaciones (
    id_eval INT AUTO_INCREMENT PRIMARY KEY,
    id_viaje INT NOT NULL,
    calificacion TINYINT CHECK (calificacion BETWEEN 1 AND 5),
    comentario VARCHAR(255),
    tipo BOOLEAN NOT NULL COMMENT 'TRUE = Pasajero->Conductor, FALSE = Conductor->Pasajero',
    FOREIGN KEY (id_viaje) REFERENCES Viajes(id_viaje)
);

-- =========================
-- Índices adicionales
-- =========================
CREATE INDEX idx_viajes_fecha ON Viajes(fecha);
CREATE INDEX idx_viajes_conductor ON Viajes(id_conductor);
CREATE INDEX idx_viajes_pasajero ON Viajes(id_pasajero);
