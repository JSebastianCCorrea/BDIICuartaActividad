
-- EXTRACCIÓN DE DATOS HACIA STAGING

-- Clientes
INSERT INTO staging.dbo.clientes_staging (id_cliente, nombre, apellido, telefono, email, ciudad)
SELECT id_cliente, 
       PARSENAME(REPLACE(nombre_contacto, ' ', '.'), 2) AS nombre, 
       PARSENAME(REPLACE(nombre_contacto, ' ', '.'), 1) AS apellido, 
       telefono, 
       email, 
       ciudad
FROM jardineria.dbo.cliente;

-- Productos
INSERT INTO staging.dbo.productos_staging (id_producto, nombre_producto, descripcion, precio, stock)
SELECT id_producto, nombre, descripcion, precio_venta, cantidad_en_stock
FROM jardineria.dbo.producto;

-- Pedidos
INSERT INTO staging.dbo.pedidos_staging (id_pedido, id_cliente, fecha_pedido, total)
SELECT id_pedido, codigo_cliente, fecha_pedido, NULL
FROM jardineria.dbo.pedido;

-- Detalles de pedidos
INSERT INTO staging.dbo.detalles_pedidos (id_pedido, id_producto, cantidad, subtotal)
SELECT id_pedido, codigo_producto, cantidad, cantidad * precio_unidad
FROM jardineria.dbo.detalle_pedido;
