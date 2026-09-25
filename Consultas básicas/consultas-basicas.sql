USE PA1_TiendaRopa;
GO



--Buscar los productos cuyo nombre contenga la palabra 'Polo' LIKE - Producto
select
    ProductoID, 
    Nombre, 
    Talla, 
    Color, 
    Precio, 
    Stock
from Producto
where Nombre LIKE '%Polo%';
go

--Mostrar los productos cuyo precio se encuentre dentro de un rango  ejemplo: entre 40 y 120 , BETWEEN - Producto

select
    ProductoID, 
    Nombre, 
    Precio, 
    Stock
from Producto
where Precio BETWEEN 30.00 AND 120.00;
go

select * from Producto;
go

--Mostrar las ventas con estado PAGADA o PENDIENTE
select 
    VentaID, 
    ClienteID, 
    FechaVenta, 
    Estado
from Venta
where Estado IN ('PAGADA', 'PENDIENTE');
go


--Usar UPPER para convertir la información a mayúsculas, CONCAT para unir texto y LEN para contar la longitud del nombre, Funcion cadena
select 
    ProductoID,
    upper(concat(Nombre, ' - TALLA: ', Talla, ' - COLOR: ', Color)) AS DescripcionFormateada,
    LEN(Nombre) AS LongitudNombre
from Producto;
go


--aplicar funciones de redondeo (ROUND, CEILING, FLOOR) al precio de los productos
select 
    ProductoID,
    Nombre,
    Precio,
    ROUND(Precio, 1) AS PrecioRedondeado,
    ceiling(Precio) AS PrecioRedondeoArriba,
    FLOOR(Precio) AS PrecioRedondeoAbajo
from Producto;
go


--se usa DATEPART para extraer año y mes ,y DATEDIFF para calcular los días transcurridos desde la fecha de venta
select 
    VentaID,
    FechaVenta,
    DATEPART(YEAR, FechaVenta) AS AnioVenta,
    DATEPART(MONTH, FechaVenta) AS MesVenta,
    DATEDIFF(DAY, FechaVenta, GETDATE()) AS DiasTranscurridos
from Venta;
go


--calcular el total de productos, precio promedio, precio máximo, precio mínimo y el stock total disponible
select
    COUNT(*) AS TotalProductos,
    AVG(Precio) AS PrecioPromedio,
    MAX(Precio) AS PrecioMaximo,
    MIN(Precio) AS PrecioMinimo,
    SUM(Stock) AS StockTotal
from Producto;
go

--Agrupar por categoría y filtrar con HAVING para mostrar únicamente las categorías que tengan más de 2 productos
select
    CategoriaID,
    COUNT(ProductoID) AS CantidadProductos,
    round(AVG(Precio),2) AS PrecioPromedioCategoria
from Producto
group by CategoriaID
having COUNT(ProductoID) > 2;
go

