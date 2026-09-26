USE PA1_TiendaRopa;
GO

/* ============================================================
   CLIENTES: 9 registros
   El ClienteID 9 quedara sin ventas.
   ============================================================ */
INSERT INTO Cliente (DNI, Nombre, Correo, Ciudad, FechaRegistro)
VALUES
('70812345', 'Ana Torres',        'ana.torres@gmail.com',        'Lima',      '2026-04-01'),
('71234567', 'Brenda Quispe',    'brenda.quispe@gmail.com',    'Cusco',     '2026-04-03'),
('73456789', 'Carlos Mendoza',   'carlos.mendoza@gmail.com',   'Arequipa',  '2026-04-06'),
('75678901', 'Daniel Rojas',     'daniel.rojas@gmail.com',     'Lima',      '2026-04-10'),
('77890123', 'Elena Flores',     'elena.flores@gmail.com',     'Trujillo',  '2026-04-15'),
('78901234', 'Fabiana Silva',    'fabiana.silva@gmail.com',    'Piura',     '2026-04-18'),
('70123456', 'Gabriel Castro',   'gabriel.castro@gmail.com',   'Lima',      '2026-04-22'),
('72345678', 'Hugo Vargas',      'hugo.vargas@gmail.com',      'Cusco',     '2026-04-25'),
('74567890', 'Irene Salazar',    'irene.salazar@gmail.com',    'Lima',      '2026-04-28');
GO

/* ============================================================
   CATEGORIAS: 5 registros
   ============================================================ */
INSERT INTO Categoria (Nombre)
VALUES
('Polos'),
('Pantalones'),
('Casacas'),
('Vestidos'),
('Accesorios');
GO

/* ============================================================
   PRODUCTOS: 14 registros
   La categoria Polos tiene mas de 2 productos.
   ============================================================ */
INSERT INTO Producto
    (CategoriaID, Nombre, Talla, Color, Precio, Stock, Activo)
VALUES
(1, 'Polo Basico Algodon',       'M',  'Blanco', 39.90, 30, 1),
(1, 'Polo Cuello V',             'L',  'Negro',  45.90, 25, 1),
(1, 'Polo Oversize',              'XL', 'Beige',  59.90, 18, 1),
(2, 'Jean Clasico',              '32', 'Azul',   89.90, 20, 1),
(2, 'Pantalon Cargo',            '34', 'Verde',  99.90, 15, 1),
(2, 'Pantalon Formal',           'M',  'Negro', 119.90, 10, 1),
(3, 'Casaca Denim',              'M',  'Azul',  149.90, 12, 1),
(3, 'Casaca Impermeable',        'L',  'Rojo',  179.90,  8, 1),
(3, 'Casaca Acolchada',          'XL', 'Negro', 199.90,  6, 1),
(4, 'Vestido Casual',            'M',  'Rosa',  129.90,  9, 1),
(4, 'Vestido Elegante',          'S',  'Negro', 159.90,  7, 1),
(5, 'Gorra Clasica',             'U',  'Negro',  29.90, 40, 1),
(5, 'Bufanda Tejida',            'U', 'Gris',  35.90, 22, 1),
(5, 'Cinturon Clasico',           'U', 'Negro', 49.90,  0, 1);
GO

/* ============================================================
   VENTAS: 12 registros con fechas y estados distintos
   Se dejan ventas para varios clientes; Irene (ClienteID=9)
   no tiene ventas.
   ============================================================ */
INSERT INTO Venta (ClienteID, FechaVenta, Estado)
VALUES
(1, '2026-05-02', 'PAGADA'),
(2, '2026-05-07', 'PENDIENTE'),
(3, '2026-05-14', 'PAGADA'),
(4, '2026-05-21', 'ANULADA'),
(5, '2026-06-03', 'PAGADA'),
(6, '2026-06-11', 'PENDIENTE'),
(7, '2026-06-20', 'PAGADA'),
(8, '2026-07-02', 'PAGADA'),
(1, '2026-07-10', 'PENDIENTE'),
(3, '2026-07-18', 'PAGADA'),
(5, '2026-08-01', 'ANULADA'),
(7, '2026-08-12', 'PAGADA');
GO

/* ============================================================
   DETALLEVENTA: 24 registros
   ============================================================ */
INSERT INTO DetalleVenta (VentaID, ProductoID, Cantidad, PrecioUnitario)
VALUES
(1,  1, 2,  39.90),
(1,  4, 1,  89.90),

(2,  2, 1,  45.90),
(2, 12, 2,  29.90),

(3,  7, 1, 149.90),
(3, 10, 1, 129.90),

(4,  5, 1,  99.90),
(4, 14, 2,  35.90),

(5,  3, 2,  59.90),
(5, 11, 1, 159.90),

(6,  6, 1, 119.90),
(6, 13, 1,  89.90),

(7,  8, 1, 179.90),
(7,  9, 1, 199.90),

(8,  1, 1,  39.90),
(8,  5, 1,  99.90),

(9,  4, 2,  89.90),
(9, 12, 1,  29.90),

(10, 3, 1,  59.90),
(10, 7, 1, 149.90),

(11, 10, 1, 129.90),
(11, 14, 1,  35.90),

(12, 11, 1, 159.90),
(12, 13, 1,  89.90);
GO



/* ============================================================
   CONSULTAS RAPIDAS DE VERIFICACION
   ============================================================ */
SELECT * FROM Cliente;
SELECT * FROM Categoria;
SELECT * FROM Producto;
SELECT * FROM Venta;
SELECT * FROM DetalleVenta;
GO

SELECT
    c.ClienteID,
    c.Nombre,
    COUNT(v.VentaID) AS CantidadVentas
FROM Cliente c
LEFT JOIN Venta v ON c.ClienteID = v.ClienteID
GROUP BY c.ClienteID, c.Nombre
ORDER BY c.ClienteID;
GO
