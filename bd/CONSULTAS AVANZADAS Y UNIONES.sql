
-- PA1_TiendaRopa - Consultas avanzadas y uniones
-- INNER JOIN | LEFT/RIGHT JOIN | CASE | UNION

USE PA1_TiendaRopa;
GO

-- 1) INNER JOIN

-- 1.1 Detalle de ventas con nombre del cliente y del producto
SELECT
    v.VentaID,
    c.Nombre        AS Cliente,
    p.Nombre        AS Producto,
    dv.Cantidad,
    dv.PrecioUnitario,
    (dv.Cantidad * dv.PrecioUnitario) AS Subtotal
FROM Venta v
INNER JOIN Cliente c       ON v.ClienteID = c.ClienteID
INNER JOIN DetalleVenta dv ON v.VentaID   = dv.VentaID
INNER JOIN Producto p      ON dv.ProductoID = p.ProductoID
ORDER BY v.VentaID;
GO

-- 1.2 Productos con el nombre de su categoría
SELECT
    p.ProductoID,
    p.Nombre     AS Producto,
    cat.Nombre   AS Categoria,
    p.Precio,
    p.Stock
FROM Producto p
INNER JOIN Categoria cat ON p.CategoriaID = cat.CategoriaID
ORDER BY cat.Nombre, p.Nombre;
GO

-- 1.3 Total vendido por cliente (solo clientes que SÍ tienen ventas)
SELECT
    c.ClienteID,
    c.Nombre AS Cliente,
    SUM(dv.Cantidad * dv.PrecioUnitario) AS TotalComprado
FROM Cliente c
INNER JOIN Venta v        ON c.ClienteID = v.ClienteID
INNER JOIN DetalleVenta dv ON v.VentaID  = dv.VentaID
GROUP BY c.ClienteID, c.Nombre
ORDER BY TotalComprado DESC;
GO

-- 2) LEFT JOIN / RIGHT JOIN

-- 2.1 LEFT JOIN: TODOS los clientes, tengan o no ventas
--     (Irene Salazar debería aparecer con NULL / 0 ventas)
SELECT
    c.ClienteID,
    c.Nombre AS Cliente,
    v.VentaID,
    v.FechaVenta,
    v.Estado
FROM Cliente c
LEFT JOIN Venta v ON c.ClienteID = v.ClienteID
ORDER BY c.ClienteID;
GO

-- 2.2 LEFT JOIN + agregación: cantidad de ventas por cliente,
--     incluyendo clientes con 0 ventas
SELECT
    c.ClienteID,
    c.Nombre AS Cliente,
    COUNT(v.VentaID) AS CantidadVentas
FROM Cliente c
LEFT JOIN Venta v ON c.ClienteID = v.ClienteID
GROUP BY c.ClienteID, c.Nombre
ORDER BY CantidadVentas ASC;
GO

-- 2.3 RIGHT JOIN (equivalente invertido del ejemplo 2.1):
--     TODAS las ventas y su cliente (si un cliente no existe, sale NULL)
SELECT
    c.Nombre AS Cliente,
    v.VentaID,
    v.FechaVenta,
    v.Estado
FROM Cliente c
RIGHT JOIN Venta v ON c.ClienteID = v.ClienteID
ORDER BY v.VentaID;
GO

-- 3) CASE (condicionales)

-- 3.1 Clasificar el estado de la venta con una etiqueta legible
SELECT
    v.VentaID,
    c.Nombre AS Cliente,
    v.FechaVenta,
    v.Estado,
    CASE v.Estado
        WHEN 'PAGADA'    THEN 'Venta confirmada'
        WHEN 'PENDIENTE' THEN 'Esperando pago'
        WHEN 'ANULADA'   THEN 'Venta cancelada'
        ELSE 'Estado desconocido'
    END AS DescripcionEstado
FROM Venta v
INNER JOIN Cliente c ON v.ClienteID = c.ClienteID
ORDER BY v.VentaID;
GO

-- 3.2 Clasificar el nivel de stock (útil para alertas de inventario)
SELECT
    p.ProductoID,
    p.Nombre AS Producto,
    p.Stock,
    CASE
        WHEN p.Stock = 0          THEN 'Sin stock'
        WHEN p.Stock <= 10        THEN 'Stock bajo'
        ELSE 'Stock alto'
    END AS NivelStock
FROM Producto p
ORDER BY p.Stock ASC;
GO


-- 4) UNION (combinación de resultados)

-- 4.1 Lista combinada: clientes de Lima y clientes de Cusco
--     (dos SELECT distintos combinados en un solo resultado)
SELECT Nombre, Ciudad
FROM Cliente
WHERE Ciudad = 'Lima'

UNION

SELECT Nombre, Ciudad
FROM Cliente
WHERE Ciudad = 'Cusco'

ORDER BY Ciudad, Nombre;
GO

-- 4.2 UNION ALL: "eventos" de negocio en una sola lista
--     combina ventas pagadas y productos con stock bajo
--     (dos consultas distintas, mismo número de columnas)
SELECT
    'Venta pagada' AS TipoEvento,
    CONVERT(VARCHAR(50), v.VentaID) AS Referencia,
    CONVERT(VARCHAR(20), v.FechaVenta, 103) AS Fecha
FROM Venta v
WHERE v.Estado = 'PAGADA'

UNION ALL

SELECT
    'Stock bajo' AS TipoEvento,
    p.Nombre     AS Referencia,
    CONVERT(VARCHAR(20), GETDATE(), 103) AS Fecha
FROM Producto p
WHERE p.Stock <= 10

ORDER BY TipoEvento;
GO

