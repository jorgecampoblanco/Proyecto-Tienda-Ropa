USE PA1_TiendaRopa;
GO

-- Productos con precio mayor al promedio
SELECT ProductoID, Nombre, Precio
FROM Producto
WHERE Precio > (
    SELECT AVG(Precio)
    FROM Producto
);
GO

-- Clientes que tienen al menos una venta
SELECT ClienteID, Nombre
FROM Cliente c
WHERE EXISTS (
    SELECT 1
    FROM Venta v
    WHERE v.ClienteID = c.ClienteID
);
GO

-- Alternativa con INNER JOIN
SELECT DISTINCT
    c.ClienteID,
    c.Nombre
FROM Cliente c
INNER JOIN Venta v
    ON c.ClienteID = v.ClienteID;
GO