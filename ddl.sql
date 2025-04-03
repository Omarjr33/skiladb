-- Crear tablas
CREATE DATABASE sakilacam;

-- Listar bases de datos
SHOW DATABASES;

-- Seleccionar base de datos
USE sakilacam;

-- Empleado 
CREATE TABLE empleado (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    id_direccion SMALLINT UNSIGNED,
    imagen BLOB,
    email VARCHAR(50),
    id_almacen TINYINT UNSIGNED,
    activo TINYINT(1),
    username VARCHAR(16),
    password VARCHAR(40),
    ultima_actualizacion TIMESTAMP
);

-- Pago
CREATE TABLE pago (
    id_pago SMALLINT UNSIGNED PRIMARY KEY,
    id_cliente SMALLINT UNSIGNED,
    id_empleado TINYINT UNSIGNED,
    id_alquiler INT,
    total DECIMAL(5,2),
    fecha_pago DATETIME,
    ultima_actualizacion TIMESTAMP
);

-- Alquiler
CREATE TABLE alquiler (
    id_alquiler INT PRIMARY KEY,
    fecha_alquiler DATETIME,
    id_inventario MEDIUMINT UNSIGNED,
    id_cliente SMALLINT UNSIGNED,
    fecha_devolucion DATETIME,
    id_empleado TINYINT UNSIGNED,
    ultima_actualizacion TIMESTAMP
);

-- Cliente
CREATE TABLE cliente (
    id_cliente SMALLINT UNSIGNED PRIMARY KEY,
    id_almacen TINYINT UNSIGNED,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    email VARCHAR(50),
    id_direccion SMALLINT UNSIGNED,
    activo TINYINT(1),
    fecha_creacion DATETIME,
    ultima_actualizacion TIMESTAMP
);

-- Almacen
CREATE TABLE almacen (
    id_almacen TINYINT UNSIGNED PRIMARY KEY,
    id_empleado_jefe TINYINT UNSIGNED,
    id_direccion SMALLINT UNSIGNED,
    ultima_actualizacion TIMESTAMP
);

-- Pelicula
CREATE TABLE pelicula (
    id_pelicula SMALLINT UNSIGNED PRIMARY KEY,
    titulo VARCHAR(255),
    descripcion TEXT,
    anyo_lanzamiento YEAR,
    id_idioma TINYINT UNSIGNED,
    id_idioma_original TINYINT UNSIGNED,
    duracion_alquiler TINYINT UNSIGNED,
    rental_rate DECIMAL(4,2),
    duracion SMALLINT UNSIGNED,
    replacement_cost DECIMAL(5,2),
    clasificacion ENUM('G','PG','PG-13','R','NC-17'),
    caracteristicas_especiales SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes'),
    ultima_actualizacion TIMESTAMP
);

-- Inventario
CREATE TABLE inventario (
    id_inventario MEDIUMINT UNSIGNED PRIMARY KEY,
    id_pelicula SMALLINT UNSIGNED,
    id_almacen TINYINT UNSIGNED,
    ultima_actualizacion TIMESTAMP
);

-- Pelicula_Categoria 
CREATE TABLE pelicula_categoria (
    id_pelicula SMALLINT UNSIGNED,
    id_categoria TINYINT UNSIGNED,
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY (id_pelicula, id_categoria)
);

-- Categoria
CREATE TABLE categoria (
    id_categoria TINYINT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(25),
    ultima_actualizacion TIMESTAMP
);

-- Pelicula_Actor
CREATE TABLE pelicula_actor (
    id_actor SMALLINT UNSIGNED,
    id_pelicula SMALLINT UNSIGNED,
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY (id_actor, id_pelicula)
);

-- Actor table
CREATE TABLE actor (
    id_actor SMALLINT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    ultima_actualizacion TIMESTAMP
);

-- Film_Text table
CREATE TABLE film_text (
    film_id SMALLINT,
    title VARCHAR(255),
    description TEXT
);

-- Direccion
CREATE TABLE direccion (
    id_direccion SMALLINT UNSIGNED PRIMARY KEY,
    direccion VARCHAR(50),
    direccion2 VARCHAR(50),
    distrito VARCHAR(20),
    id_ciudad SMALLINT UNSIGNED,
    codigo_postal VARCHAR(10),
    telefono VARCHAR(20),
    ultima_actualizacion TIMESTAMP
);

-- Idioma
CREATE TABLE idioma (
    id_idioma TINYINT UNSIGNED PRIMARY KEY,
    nombre CHAR(20),
    ultima_actualizacion TIMESTAMP
);

-- Ciudad (City) table
CREATE TABLE ciudad (
    id_ciudad SMALLINT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(50),
    id_pais SMALLINT UNSIGNED,
    ultima_actualizacion TIMESTAMP
);

-- Pais (Country) table
CREATE TABLE pais (
    id_pais SMALLINT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(50),
    ultima_actualizacion TIMESTAMP
);

-- Add foreign key constraints
ALTER TABLE empleado
    ADD CONSTRAINT fk_empleado_direccion FOREIGN KEY (id_direccion) REFERENCES direccion (id_direccion),
    ADD CONSTRAINT fk_empleado_almacen FOREIGN KEY (id_almacen) REFERENCES sakiacampus.almacen (id_almacen);

ALTER TABLE pago
    ADD CONSTRAINT fk_pago_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente),
    ADD CONSTRAINT fk_pago_empleado FOREIGN KEY (id_empleado) REFERENCES empleado (id_empleado),
    ADD CONSTRAINT fk_pago_alquiler FOREIGN KEY (id_alquiler) REFERENCES alquiler (id_alquiler);

ALTER TABLE alquiler
    ADD CONSTRAINT fk_alquiler_inventario FOREIGN KEY (id_inventario) REFERENCES inventario (id_inventario),
    ADD CONSTRAINT fk_alquiler_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente),
    ADD CONSTRAINT fk_alquiler_empleado FOREIGN KEY (id_empleado) REFERENCES empleado (id_empleado);

ALTER TABLE cliente
    ADD CONSTRAINT fk_cliente_almacen FOREIGN KEY (id_almacen) REFERENCES almacen (id_almacen),
    ADD CONSTRAINT fk_cliente_direccion FOREIGN KEY (id_direccion) REFERENCES direccion (id_direccion);

ALTER TABLE almacen
    ADD CONSTRAINT fk_almacen_empleado FOREIGN KEY (id_empleado_jefe) REFERENCES empleado (id_empleado),
    ADD CONSTRAINT fk_almacen_direccion FOREIGN KEY (id_direccion) REFERENCES direccion (id_direccion);

ALTER TABLE pelicula
    ADD CONSTRAINT fk_pelicula_idioma FOREIGN KEY (id_idioma) REFERENCES idioma (id_idioma),
    ADD CONSTRAINT fk_pelicula_idioma_original FOREIGN KEY (id_idioma_original) REFERENCES idioma (id_idioma);

ALTER TABLE inventario
    ADD CONSTRAINT fk_inventario_pelicula FOREIGN KEY (id_pelicula) REFERENCES pelicula (id_pelicula),
    ADD CONSTRAINT fk_inventario_almacen FOREIGN KEY (id_almacen) REFERENCES almacen (id_almacen);

ALTER TABLE pelicula_categoria
    ADD CONSTRAINT fk_pelicula_categoria_pelicula FOREIGN KEY (id_pelicula) REFERENCES pelicula (id_pelicula),
    ADD CONSTRAINT fk_pelicula_categoria_categoria FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria);

ALTER TABLE pelicula_actor
    ADD CONSTRAINT fk_pelicula_actor_actor FOREIGN KEY (id_actor) REFERENCES actor (id_actor),
    ADD CONSTRAINT fk_pelicula_actor_pelicula FOREIGN KEY (id_pelicula) REFERENCES pelicula (id_pelicula);

ALTER TABLE film_text
    ADD CONSTRAINT fk_film_text_pelicula FOREIGN KEY (film_id) REFERENCES pelicula (id_pelicula);

ALTER TABLE direccion
    ADD CONSTRAINT fk_direccion_ciudad FOREIGN KEY (id_ciudad) REFERENCES ciudad (id_ciudad);

ALTER TABLE ciudad
    ADD CONSTRAINT fk_ciudad_pais FOREIGN KEY (id_pais) REFERENCES pais (id_pais);



-----------------------------------------------------------------------------------------------------------------

-- Tabla para el contador de alquileres por empleado
CREATE TABLE empleado_estadisticas (
    id_empleado INT PRIMARY KEY,
    total_alquileres INT DEFAULT 0,
    ultima_actualizacion TIMESTAMP
);

-- Tabla de auditoría para cambios en clientes
CREATE TABLE auditoria_cliente (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente SMALLINT UNSIGNED,
    campo_modificado VARCHAR(50),
    valor_antiguo VARCHAR(255),
    valor_nuevo VARCHAR(255),
    usuario VARCHAR(50),
    fecha_cambio TIMESTAMP
);

-- Tabla para el historial de costos de alquiler
CREATE TABLE historial_costo_pelicula (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_pelicula SMALLINT UNSIGNED,
    rental_rate_antiguo DECIMAL(4,2),
    rental_rate_nuevo DECIMAL(4,2),
    usuario VARCHAR(50),
    fecha_cambio TIMESTAMP
);

-- Tabla para notificaciones de eliminación de alquileres
CREATE TABLE notificacion_eliminacion (
    id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_alquiler INT,
    id_cliente SMALLINT UNSIGNED,
    id_empleado TINYINT UNSIGNED,
    fecha_alquiler DATETIME,
    fecha_eliminacion TIMESTAMP,
    usuario VARCHAR(50)
);

-- Tabla para saldos pendientes de clientes
CREATE TABLE saldo_cliente (
    id_cliente SMALLINT UNSIGNED PRIMARY KEY,
    saldo_pendiente DECIMAL(10,2) DEFAULT 0.00,
    ultima_actualizacion TIMESTAMP
);