SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema movilidad_urbana
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `movilidad_urbana` ;
CREATE SCHEMA IF NOT EXISTS `movilidad_urbana` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `movilidad_urbana` ;

-- -----------------------------------------------------
-- Table conductores
-- -----------------------------------------------------
DROP TABLE IF EXISTS `conductores` ;
CREATE TABLE `conductores` (
  `id_conductor` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `licencia` VARCHAR(50) NOT NULL,
  `fecha_alta` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_conductor`),
  CONSTRAINT chk_nombre_conductor CHECK (CHAR_LENGTH(`nombre`) > 0),
  CONSTRAINT chk_licencia CHECK (CHAR_LENGTH(`licencia`) > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `licencia` ON `conductores` (`licencia`);

-- -----------------------------------------------------
-- Table estadospago
-- -----------------------------------------------------
DROP TABLE IF EXISTS `estadospago` ;
CREATE TABLE `estadospago` (
  `id_estado` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `estado` TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (`id_estado`),
  CONSTRAINT chk_nombre_estadospago CHECK (CHAR_LENGTH(`nombre`) > 0),
  CONSTRAINT chk_estado_pago CHECK (`estado` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `nombre` ON `estadospago` (`nombre`);

-- -----------------------------------------------------
-- Table estadosviaje
-- -----------------------------------------------------
DROP TABLE IF EXISTS `estadosviaje` ;
CREATE TABLE `estadosviaje` (
  `id_estado` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `estado` TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (`id_estado`),
  CONSTRAINT chk_nombre_estadosviaje CHECK (CHAR_LENGTH(`nombre`) > 0),
  CONSTRAINT chk_estado_viaje CHECK (`estado` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `nombre` ON `estadosviaje` (`nombre`);

-- -----------------------------------------------------
-- Table pasajeros
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pasajeros` ;
CREATE TABLE `pasajeros` (
  `id_pasajero` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pasajero`),
  CONSTRAINT chk_nombre_pasajero CHECK (CHAR_LENGTH(`nombre`) > 0),
  CONSTRAINT chk_email CHECK (`email` LIKE '%@%.%')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `email` ON `pasajeros` (`email`);

-- -----------------------------------------------------
-- Table viajes
-- -----------------------------------------------------
DROP TABLE IF EXISTS `viajes` ;
CREATE TABLE `viajes` (
  `id_viaje` INT NOT NULL AUTO_INCREMENT,
  `id_pasajero` INT NOT NULL,
  `id_conductor` INT NOT NULL,
  `origen` VARCHAR(200) NOT NULL,
  `destino` VARCHAR(200) NOT NULL,
  `fecha` DATETIME NOT NULL,
  `duracion_min` INT NULL DEFAULT NULL,
  `tarifa` DECIMAL(10,2) NULL DEFAULT NULL,
  PRIMARY KEY (`id_viaje`),
  CONSTRAINT `viajes_ibfk_1` FOREIGN KEY (`id_pasajero`) REFERENCES `pasajeros` (`id_pasajero`),
  CONSTRAINT `viajes_ibfk_2` FOREIGN KEY (`id_conductor`) REFERENCES `conductores` (`id_conductor`),
  CONSTRAINT chk_origen CHECK (CHAR_LENGTH(`origen`) > 0),
  CONSTRAINT chk_destino CHECK (CHAR_LENGTH(`destino`) > 0),
  CONSTRAINT chk_tarifa CHECK (`tarifa` IS NULL OR `tarifa` >= 0),
  CONSTRAINT chk_duracion CHECK (`duracion_min` IS NULL OR `duracion_min` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX `idx_viajes_fecha` ON `viajes` (`fecha`);
CREATE INDEX `idx_viajes_conductor` ON `viajes` (`id_conductor`);
CREATE INDEX `idx_viajes_pasajero` ON `viajes` (`id_pasajero`);

-- -----------------------------------------------------
-- Table evaluaciones
-- -----------------------------------------------------
DROP TABLE IF EXISTS `evaluaciones` ;
CREATE TABLE `evaluaciones` (
  `id_eval` INT NOT NULL AUTO_INCREMENT,
  `id_viaje` INT NOT NULL,
  `calificacion` TINYINT NULL DEFAULT NULL,
  `comentario` VARCHAR(255) NULL DEFAULT NULL,
  `tipo` TINYINT(1) NOT NULL COMMENT '1 = Pasajero->Conductor, 0 = Conductor->Pasajero',
  PRIMARY KEY (`id_eval`),
  CONSTRAINT `evaluaciones_ibfk_1` FOREIGN KEY (`id_viaje`) REFERENCES `viajes` (`id_viaje`),
  CONSTRAINT chk_calificacion CHECK (`calificacion` IS NULL OR (`calificacion` BETWEEN 1 AND 5)),
  CONSTRAINT chk_tipo_eval CHECK (`tipo` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX `id_viaje` ON `evaluaciones` (`id_viaje`);

-- -----------------------------------------------------
-- Table metodospago
-- -----------------------------------------------------
DROP TABLE IF EXISTS `metodospago` ;
CREATE TABLE `metodospago` (
  `id_metodo` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `estado` TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (`id_metodo`),
  CONSTRAINT chk_nombre_metodospago CHECK (CHAR_LENGTH(`nombre`) > 0),
  CONSTRAINT chk_estado_metodo CHECK (`estado` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `nombre` ON `metodospago` (`nombre`);

-- -----------------------------------------------------
-- Table pagos
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pagos` ;
CREATE TABLE `pagos` (
  `id_pago` INT NOT NULL AUTO_INCREMENT,
  `id_viaje` INT NULL DEFAULT NULL,
  `monto` DECIMAL(10,2) NOT NULL,
  `metodospago_id_metodo` INT NOT NULL,
  PRIMARY KEY (`id_pago`, `metodospago_id_metodo`),
  CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`id_viaje`) REFERENCES `viajes` (`id_viaje`),
  CONSTRAINT `fk_pagos_metodospago1` FOREIGN KEY (`metodospago_id_metodo`) REFERENCES `metodospago` (`id_metodo`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT chk_monto CHECK (`monto` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `id_viaje` ON `pagos` (`id_viaje`);
CREATE INDEX `fk_pagos_metodospago1_idx` ON `pagos` (`metodospago_id_metodo`);

-- -----------------------------------------------------
-- Table pago_estado
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pago_estado` ;
CREATE TABLE `pago_estado` (
  `id_pago` INT NOT NULL,
  `id_estado` INT NOT NULL,
  `fecha_cambio` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pago`, `id_estado`, `fecha_cambio`),
  CONSTRAINT `pago_estado_ibfk_1` FOREIGN KEY (`id_pago`) REFERENCES `pagos` (`id_pago`),
  CONSTRAINT `pago_estado_ibfk_2` FOREIGN KEY (`id_estado`) REFERENCES `estadospago` (`id_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX `id_estado` ON `pago_estado` (`id_estado`);

-- -----------------------------------------------------
-- Table tiposvehiculo
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tiposvehiculo` ;
CREATE TABLE `tiposvehiculo` (
  `id_tipo` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `estado` TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (`id_tipo`),
  CONSTRAINT chk_nombre_tipovehiculo CHECK (CHAR_LENGTH(`nombre`) > 0),
  CONSTRAINT chk_estado_tipo CHECK (`estado` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `nombre` ON `tiposvehiculo` (`nombre`);

-- -----------------------------------------------------
-- Table vehiculos
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vehiculos` ;
CREATE TABLE `vehiculos` (
  `id_vehiculo` INT NOT NULL AUTO_INCREMENT,
  `id_conductor` INT NULL DEFAULT NULL,
  `patente` VARCHAR(20) NOT NULL,
  `modelo` VARCHAR(50) NULL DEFAULT NULL,
  `tiposvehiculo_id_tipo` INT NOT NULL,
  PRIMARY KEY (`id_vehiculo`, `tiposvehiculo_id_tipo`),
  CONSTRAINT `vehiculos_ibfk_1` FOREIGN KEY (`id_conductor`) REFERENCES `conductores` (`id_conductor`),
  CONSTRAINT `fk_vehiculos_tiposvehiculo1` FOREIGN KEY (`tiposvehiculo_id_tipo`) REFERENCES `tiposvehiculo` (`id_tipo`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT chk_patente CHECK (CHAR_LENGTH(`patente`) > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `patente` ON `vehiculos` (`patente`);
CREATE UNIQUE INDEX `id_conductor` ON `vehiculos` (`id_conductor`);
CREATE INDEX `fk_vehiculos_tiposvehiculo1_idx` ON `vehiculos` (`tiposvehiculo_id_tipo`);

-- -----------------------------------------------------
-- Table viaje_estado
-- -----------------------------------------------------
DROP TABLE IF EXISTS `viaje_estado` ;
CREATE TABLE `viaje_estado` (
  `id_viaje` INT NOT NULL,
  `id_estado` INT NOT NULL,
  `fecha_cambio` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_viaje`, `id_estado`, `fecha_cambio`),
  CONSTRAINT `viaje_estado_ibfk_1` FOREIGN KEY (`id_viaje`) REFERENCES `viajes` (`id_viaje`),
  CONSTRAINT `viaje_estado_ibfk_2` FOREIGN KEY (`id_estado`) REFERENCES `estadosviaje` (`id_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX `id_estado` ON `viaje_estado` (`id_estado`);

-- -----------------------------------------------------
-- Restore modes
-- -----------------------------------------------------
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;