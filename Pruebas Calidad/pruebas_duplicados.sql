SELECT id_cliente, COUNT(*) FROM clientes GROUP BY id_cliente HAVING COUNT(*) > 1;
SELECT id_producto, COUNT(*) FROM productos GROUP BY id_producto HAVING COUNT(*) > 1;

-----------------------------

