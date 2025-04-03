
# Examen de Base de Datos - Sistema de Alquiler de Películas

## Enlace a la Base de Datos e Inserciones
Enlace a la base de datos y ejemplos de inserciones necesarias para el sistema de alquiler de películas.

## Requerimientos del Examen

### Consultas SQL
A continuación, se presentan las consultas SQL que deben realizarse en el sistema de alquiler de películas:

1. **Encontrar el cliente que ha realizado la mayor cantidad de alquileres en los últimos 6 meses:**
   ```sql
   SELECT c.id_cliente, c.nombre, c.apellidos, COUNT(a.id_alquiler) AS total_alquileres
   FROM cliente c
   JOIN alquiler a ON c.id_cliente = a.id_cliente
   WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
   GROUP BY c.id_cliente, c.nombre, c.apellidos
   ORDER BY total_alquileres DESC
   LIMIT 1;
   ```

2. **Lista las cinco películas más alquiladas durante el último año:**
   ```sql
   SELECT p.id_pelicula, p.titulo, COUNT(a.id_alquiler) AS total_alquileres
   FROM pelicula p
   JOIN inventario i ON p.id_pelicula = i.id_pelicula
   JOIN alquiler a ON i.id_inventario = a.id_inventario
   WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
   GROUP BY p.id_pelicula, p.titulo
   ORDER BY total_alquileres DESC
   LIMIT 5;
   ```

3. **Obtener el total de ingresos y la cantidad de alquileres realizados por cada categoría de película:**
   ```sql
   SELECT c.id_categoria, c.nombre, 
          COUNT(a.id_alquiler) AS total_alquileres,
          SUM(p.total) AS total_ingresos
   FROM categoria c
   JOIN pelicula_categoria pc ON c.id_categoria = pc.id_categoria
   JOIN pelicula pel ON pc.id_pelicula = pel.id_pelicula
   JOIN inventario i ON pel.id_pelicula = i.id_pelicula
   JOIN alquiler a ON i.id_inventario = a.id_inventario
   JOIN pago p ON a.id_alquiler = p.id_alquiler
   GROUP BY c.id_categoria, c.nombre
   ORDER BY total_ingresos DESC;
   ```

4. **Calcular el número total de clientes que han realizado alquileres por cada idioma disponible en un mes específico:**
   ```sql
   SELECT i.id_idioma, i.nombre, COUNT(DISTINCT a.id_cliente) AS total_clientes
   FROM idioma i
   JOIN pelicula p ON i.id_idioma = p.id_idioma
   JOIN inventario inv ON p.id_pelicula = inv.id_pelicula
   JOIN alquiler a ON inv.id_inventario = a.id_inventario
   WHERE MONTH(a.fecha_alquiler) = 3 AND YEAR(a.fecha_alquiler) = 2025
   GROUP BY i.id_idioma, i.nombre
   ORDER BY total_clientes DESC;
   ```

5. **Encontrar a los clientes que han alquilado todas las películas de una misma categoría:**
   ```sql
   SELECT c.id_cliente, c.nombre, c.apellidos, cat.nombre AS categoria
   FROM cliente c
   JOIN alquiler a ON c.id_cliente = a.id_cliente
   JOIN inventario i ON a.id_inventario = i.id_inventario
   JOIN pelicula p ON i.id_pelicula = p.id_pelicula
   JOIN pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
   JOIN categoria cat ON pc.id_categoria = cat.id_categoria
   GROUP BY c.id_cliente, c.nombre, c.apellidos, cat.id_categoria, cat.nombre
   HAVING COUNT(DISTINCT p.id_pelicula) = (
       SELECT COUNT(DISTINCT p2.id_pelicula)
       FROM pelicula p2
       JOIN pelicula_categoria pc2 ON p2.id_pelicula = pc2.id_pelicula
       WHERE pc2.id_categoria = cat.id_categoria
   );
   ```

6. **Lista las tres ciudades con más clientes activos en el último trimestre:**
   ```sql
   SELECT ci.id_ciudad, ci.nombre, COUNT(DISTINCT c.id_cliente) AS total_clientes_activos
   FROM ciudad ci
   JOIN direccion d ON ci.id_ciudad = d.id_ciudad
   JOIN cliente c ON d.id_direccion = c.id_direccion
   JOIN alquiler a ON c.id_cliente = a.id_cliente
   WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
     AND c.activo = 1
   GROUP BY ci.id_ciudad, ci.nombre
   ORDER BY total_clientes_activos DESC
   LIMIT 3;
   ```

7. **Mostrar las cinco categorías con menos alquileres registrados en el último año:**
   ```sql
   SELECT c.id_categoria, c.nombre, COUNT(a.id_alquiler) AS total_alquileres
   FROM categoria c
   LEFT JOIN pelicula_categoria pc ON c.id_categoria = pc.id_categoria
   LEFT JOIN pelicula p ON pc.id_pelicula = p.id_pelicula
   LEFT JOIN inventario i ON p.id_pelicula = i.id_pelicula
   LEFT JOIN alquiler a ON i.id_inventario = a.id_inventario
       AND a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
   GROUP BY c.id_categoria, c.nombre
   ORDER BY total_alquileres ASC
   LIMIT 5;
   ```

8. **Calcular el promedio de días que un cliente tarda en devolver las películas alquiladas.**
9. **Encontrar los cinco empleados que gestionaron más alquileres en la categoría de Acción.**
10. **Generar un informe de los clientes con alquileres más recurrentes.**
11. **Calcular el costo promedio de alquiler por idioma de las películas.**
12. **Lista las cinco películas con mayor duración alquiladas en el último año.**
13. **Mostrar los clientes que más alquilaron películas de Comedia.**
14. **Encontrar la cantidad total de días alquilados por cada cliente en el último mes.**
15. **Mostrar el número de alquileres diarios en cada almacén durante el último trimestre.**
16. **Calcular los ingresos totales generados por cada almacén en el último semestre.**
17. **Encontrar el cliente que ha realizado el alquiler más caro en el último año.**
18. **Lista las cinco categorías con más ingresos generados durante los últimos tres meses.**
19. **Obtener la cantidad de películas alquiladas por cada idioma en el último mes.**
20. **Lista los clientes que no han realizado ningún alquiler en el último año.**

### Funciones SQL
Desarrolla las siguientes funciones:

1. **TotalIngresosCliente(ClienteID, Año):** Calcula los ingresos generados por un cliente en un año específico.
   ```sql
   DELIMITER //
   CREATE FUNCTION TotalIngresosCliente(ClienteID SMALLINT UNSIGNED, Anyo INT) 
   RETURNS DECIMAL(10,2)
   DETERMINISTIC
   BEGIN
       DECLARE total_ingresos DECIMAL(10,2);
       SELECT IFNULL(SUM(p.total), 0) INTO total_ingresos
       FROM pago p
       JOIN alquiler a ON p.id_alquiler = a.id_alquiler
       WHERE p.id_cliente = ClienteID
       AND YEAR(p.fecha_pago) = Anyo;
       RETURN total_ingresos;
   END //
   DELIMITER ;
   ```

2. **PromedioDuracionAlquiler(PeliculaID):** Retorna la duración promedio de alquiler de una película específica.
   ```sql
   DELIMITER //
   CREATE FUNCTION PromedioDuracionAlquiler(PeliculaID SMALLINT UNSIGNED) 
   RETURNS DECIMAL(10,2)
   DETERMINISTIC
   BEGIN
       DECLARE promedio_dias DECIMAL(10,2);
       SELECT AVG(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler)) INTO promedio_dias
       FROM alquiler a
       JOIN inventario i ON a.id_inventario = i.id_inventario
       WHERE i.id_pelicula = PeliculaID
       AND a.fecha_devolucion IS NOT NULL;
       RETURN IFNULL(promedio_dias, 0);
   END //
   DELIMITER ;
   ```

3. **IngresosPorCategoria(CategoriaID):** Calcula los ingresos totales generados por una categoría específica de películas.
4. **DescuentoFrecuenciaCliente(ClienteID):** Calcula un descuento basado en la frecuencia de alquiler del cliente.

### Triggers
Implementa los siguientes triggers:

1. **ActualizarTotalAlquileresEmpleado:** Al registrar un alquiler, actualiza el total de alquileres gestionados por el empleado correspondiente.
   ```sql
   DELIMITER //
   CREATE TRIGGER ActualizarTotalAlquileresEmpleado
   AFTER INSERT ON alquiler
   FOR EACH ROW
   BEGIN
       INSERT INTO empleado_estadisticas (id_empleado, total_alquileres, ultima_actualizacion)
       VALUES (NEW.id_empleado, 1, NOW())
       ON DUPLICATE KEY UPDATE
           total_alquileres = total_alquileres + 1,
           ultima_actualizacion = NOW();
   END //
   DELIMITER ;
   ```

2. **AuditarActualizacionCliente:** Cada vez que se modifica un cliente, registra el cambio en una tabla de auditoría.
   ```sql
   DELIMITER //
   CREATE TRIGGER AuditarActualizacionCliente
   BEFORE UPDATE ON cliente
   FOR EACH ROW
   BEGIN
       -- Auditar cambios en nombre
       IF OLD.nombre <> NEW.nombre THEN
           INSERT INTO auditoria_cliente (id_cliente, campo_modificado, valor_antiguo, valor_nuevo, usuario, fecha_cambio)
           VALUES (OLD.id_cliente, 'nombre', OLD.nombre, NEW.nombre, USER(), NOW());
       END IF;
       -- Auditar cambios en apellidos
       IF OLD.apellidos <> NEW.apellidos THEN
           INSERT INTO auditoria_cliente (id_cliente, campo_modificado, valor_antiguo, valor_nuevo, usuario, fecha_cambio)
           VALUES (OLD.id_cliente, 'apellidos', OLD.apellidos, NEW.apellidos, USER(), NOW());
       END IF;
       -- Auditar cambios en email
       IF OLD.email <> NEW.email THEN
           INSERT INTO auditoria_cliente (id_cliente, campo_modificado, valor_antiguo, valor_nuevo, usuario, fecha_cambio)
           VALUES (OLD.id_cliente, 'email', OLD.email, NEW.email, USER(), NOW());
       END IF;
       -- Auditar cambios en estado activo
       IF OLD.activo <> NEW.activo THEN
           INSERT INTO auditoria_cliente (id_cliente, campo_modificado, valor_antiguo, valor_nuevo, usuario, fecha_cambio)
           VALUES (OLD.id_cliente, 'activo', OLD.activo, NEW.activo, USER(), NOW());
       END IF;
   END //
   DELIMITER ;
   ```

3. **RegistrarHistorialDeCosto:** Guarda el historial de cambios en los costos de alquiler de las películas.
4. **NotificarEliminacionAlquiler:** Registra una notificación cuando se elimina un registro de alquiler.
5. **RestringirAlquilerConSaldoPendiente:** Evita que un cliente con saldo pendiente pueda realizar nuevos alquileres.

---

