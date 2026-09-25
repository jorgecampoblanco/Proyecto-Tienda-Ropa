USE PA1_TiendaRopa;
GO

/* ------------------------------------------------------------
   PRUEBA 1: UNIQUE en DNI
   Debe fallar porque el DNI 70812345 ya existe.
   Evidencia esperada: violacion de restriccion UNIQUE.
   ------------------------------------------------------------ */
INSERT INTO Cliente (DNI, Nombre, Correo, Ciudad)
VALUES ('70812345', 'Cliente Duplicado', 'duplicado@gmail.com', 'Lima');
GO


/* ------------------------------------------------------------
   PRUEBA 2: CHECK en Stock
   Debe fallar porque Stock no puede ser menor que 0.
   Evidencia esperada: violacion de CK_Producto_Stock.
   ------------------------------------------------------------ */
INSERT INTO Producto
    (CategoriaID, Nombre, Talla, Color, Precio, Stock)
VALUES
(1, 'Producto Stock Negativo', 'M', 'Azul', 50.00, -1);
GO


/* ------------------------------------------------------------
   PRUEBA 3: CHECK en Precio
   Debe fallar porque Precio debe ser mayor que 0.
   ------------------------------------------------------------ */
INSERT INTO Producto
    (CategoriaID, Nombre, Talla, Color, Precio, Stock)
VALUES
(1, 'Producto Precio Cero', 'M', 'Azul', 0.00, 10);
GO


/* ------------------------------------------------------------
   PRUEBA 4: CHECK en Estado de Venta
   Debe fallar porque el Estado solo admite:
   PENDIENTE, PAGADA o ANULADA.
   ------------------------------------------------------------ */
INSERT INTO Venta (ClienteID, FechaVenta, Estado)
VALUES (1, '2026-08-20', 'CANCELADA');
GO


/* ------------------------------------------------------------
   PRUEBA 5: FOREIGN KEY en Producto
   Debe fallar porque CategoriaID=999 no existe.
   ------------------------------------------------------------ */
INSERT INTO Producto
    (CategoriaID, Nombre, Talla, Color, Precio, Stock)
VALUES
(999, 'Producto Categoria Inexistente', 'M', 'Negro', 40.00, 10);
GO


/* ------------------------------------------------------------
   PRUEBA 6: CHECK en Cantidad
   Debe fallar porque Cantidad debe ser mayor que 0.
   ------------------------------------------------------------ */
INSERT INTO DetalleVenta (VentaID, ProductoID, Cantidad, PrecioUnitario)
VALUES (1, 6, 0, 119.90);
GO