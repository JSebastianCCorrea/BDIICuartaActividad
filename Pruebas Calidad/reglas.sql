SELECT dp.* FROM detalle_pedido dp
JOIN producto p ON dp.id_producto = p.id_producto
WHERE dp.subtotal <> dp.cantidad * p.precio_venta;