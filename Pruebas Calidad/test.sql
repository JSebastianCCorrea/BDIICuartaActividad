-- CLIENTES
INSERT INTO clientes_staging (id_cliente, nombre, apellido, telefono, email, ciudad)
SELECT c.id_cliente, 
       SUBSTRING_INDEX(c.nombre, ' ', 1) AS nombre,
       SUBSTRING_INDEX(c.nombre, ' ', -1) AS apellido,
       c.telefono,
       c.email,
       'Desconocido' AS ciudad
FROM jardineria.dbo.cliente c;

-- PRODUCTOS
INSERT INTO productos_staging (id_producto, nombre_producto, descripcion, precio, stock)
SELECT p.id_producto, p.nombre, p.descripcion, p.precio_venta, p.cantidad_en_stock
FROM jardineria.dbo.producto p;

-- PEDIDOS
INSERT INTO pedidos_staging (id_pedido, id_cliente, fecha_pedido, total)
SELECT p.id_pedido, p.id_cliente, p.fecha_pedido, 0.00
FROM jardineria.dbo.pedido p;

--------------------------------
SELECT COUNT(*) FROM clientes_staging WHERE nombre IS NULL OR apellido IS NULL;
SELECT COUNT(*) FROM productos_staging WHERE nombre_producto IS NULL;

----------------------------------

SELECT id_cliente, COUNT(*) FROM clientes_staging GROUP BY id_cliente HAVING COUNT(*) > 1;

------------------------------------

UPDATE clientes_staging
SET nombre = UPPER(TRIM(nombre)), apellido = UPPER(TRIM(apellido));

--------------------------------------
UPDATE pedidos_staging ps
SET total = (
    SELECT SUM(dp.subtotal)
    FROM detalles_pedidos dp
    WHERE dp.id_pedido = ps.id_pedido
);
-------------------------------------
-- Supongamos que el data mart final tiene tablas `dim_cliente`, `dim_producto`, `fact_pedidos`

-- Carga de clientes
INSERT INTO dim_cliente (id_cliente, nombre, apellido, email)
SELECT id_cliente, nombre, apellido, email
FROM clientes_staging;

-- Carga de productos
INSERT INTO dim_producto (id_producto, nombre_producto, precio)
SELECT id_producto, nombre_producto, precio
FROM productos_staging;

-- Carga de hechos
INSERT INTO fact_pedidos (id_pedido, id_cliente, fecha, total)
SELECT id_pedido, id_cliente, fecha_pedido, total
FROM pedidos_staging;

-----------------------------------------

-- Verificación de registros insertados
SELECT COUNT(*) FROM fact_pedidos;
SELECT COUNT(*) FROM dim_cliente;
SELECT COUNT(*) FROM dim_producto;

