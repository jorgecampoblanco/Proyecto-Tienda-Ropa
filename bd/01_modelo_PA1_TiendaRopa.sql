/* =====================================================================
   PA1 - Sistema de ventas e inventario para una Tienda de Ropa
   PARTE 1 (Andy) - Modelo definitivo: tablas, campos, PK/FK y relaciones
   Base de datos : PA1_TiendaRopa
   Motor         : SQL Server
   Nota          : Solo estructura (sin datos). Los INSERT los hace Lucero.
   Relaciones    : Categoria 1:N Producto | Cliente 1:N Venta
                   Venta 1:N DetalleVenta | Producto 1:N DetalleVenta
   ===================================================================== */

-- 1. Crear la base (solo si no existe)
IF DB_ID('PA1_TiendaRopa') IS NULL
    CREATE DATABASE PA1_TiendaRopa;
GO

-- Propietario 'sa' para que el diagrama funcione al restaurar en otra PC
ALTER AUTHORIZATION ON DATABASE::PA1_TiendaRopa TO sa;
GO

USE PA1_TiendaRopa;
GO

-- 2. Borrar tablas si existen (orden inverso por dependencias FK)
IF OBJECT_ID('dbo.DetalleVenta','U') IS NOT NULL DROP TABLE dbo.DetalleVenta;
IF OBJECT_ID('dbo.Venta','U')        IS NOT NULL DROP TABLE dbo.Venta;
IF OBJECT_ID('dbo.Producto','U')     IS NOT NULL DROP TABLE dbo.Producto;
IF OBJECT_ID('dbo.Categoria','U')    IS NOT NULL DROP TABLE dbo.Categoria;
IF OBJECT_ID('dbo.Cliente','U')      IS NOT NULL DROP TABLE dbo.Cliente;
GO

-- 3. Tablas maestras ---------------------------------------------------

-- Cliente: personas que compran en la tienda
CREATE TABLE dbo.Cliente (
    ClienteID      INT IDENTITY(1,1) NOT NULL,
    DNI            VARCHAR(8)   NOT NULL,
    Nombre         VARCHAR(80)  NOT NULL,
    Correo         VARCHAR(100) NULL,
    Ciudad         VARCHAR(50)  NULL,
    FechaRegistro  DATE         NULL CONSTRAINT DF_Cliente_FechaRegistro DEFAULT (GETDATE()),
    CONSTRAINT PK_Cliente     PRIMARY KEY (ClienteID),
    CONSTRAINT UQ_Cliente_DNI UNIQUE (DNI)
);
GO

-- Categoria: agrupa los productos (Polos, Jeans, Casacas, etc.)
CREATE TABLE dbo.Categoria (
    CategoriaID  INT IDENTITY(1,1) NOT NULL,
    Nombre       VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Categoria        PRIMARY KEY (CategoriaID),
    CONSTRAINT UQ_Categoria_Nombre UNIQUE (Nombre)
);
GO

-- Producto: prendas en inventario (1 Categoria -> N Productos)
CREATE TABLE dbo.Producto (
    ProductoID   INT IDENTITY(1,1) NOT NULL,
    CategoriaID  INT            NOT NULL,
    Nombre       VARCHAR(100)   NOT NULL,
    Talla        VARCHAR(10)    NULL,
    Color        VARCHAR(30)    NULL,
    Precio       DECIMAL(10,2)  NOT NULL,
    Stock        INT            NOT NULL,
    Activo       BIT            NOT NULL CONSTRAINT DF_Producto_Activo DEFAULT (1),
    CONSTRAINT PK_Producto           PRIMARY KEY (ProductoID),
    CONSTRAINT FK_Producto_Categoria FOREIGN KEY (CategoriaID) REFERENCES dbo.Categoria (CategoriaID),
    CONSTRAINT CK_Producto_Precio    CHECK (Precio > 0),
    CONSTRAINT CK_Producto_Stock     CHECK (Stock >= 0)
);
GO

-- 4. Tablas transaccionales -------------------------------------------

-- Venta: cabecera de la venta (1 Cliente -> N Ventas)
CREATE TABLE dbo.Venta (
    VentaID     INT IDENTITY(1,1) NOT NULL,
    ClienteID   INT          NOT NULL,
    FechaVenta  DATE         NOT NULL CONSTRAINT DF_Venta_FechaVenta DEFAULT (GETDATE()),
    Estado      VARCHAR(20)  NOT NULL,
    CONSTRAINT PK_Venta         PRIMARY KEY (VentaID),
    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (ClienteID) REFERENCES dbo.Cliente (ClienteID),
    CONSTRAINT CK_Venta_Estado  CHECK (Estado IN ('PENDIENTE','PAGADA','ANULADA'))
);
GO

-- DetalleVenta: productos de cada venta (tabla puente Venta <-> Producto)
CREATE TABLE dbo.DetalleVenta (
    VentaID         INT            NOT NULL,
    ProductoID      INT            NOT NULL,
    Cantidad        INT            NOT NULL,
    PrecioUnitario  DECIMAL(10,2)  NOT NULL,
    CONSTRAINT PK_DetalleVenta               PRIMARY KEY (VentaID, ProductoID),
    CONSTRAINT FK_DetalleVenta_Venta         FOREIGN KEY (VentaID)    REFERENCES dbo.Venta (VentaID),
    CONSTRAINT FK_DetalleVenta_Producto      FOREIGN KEY (ProductoID) REFERENCES dbo.Producto (ProductoID),
    CONSTRAINT CK_DetalleVenta_Cantidad      CHECK (Cantidad > 0),
    CONSTRAINT CK_DetalleVenta_PrecioUnitario CHECK (PrecioUnitario > 0)
);
GO

-- 5. Verificación rápida: tablas, columnas y llaves creadas
SELECT t.name AS Tabla, c.name AS Campo, ty.name AS Tipo,
       c.max_length AS Longitud, c.is_nullable AS AceptaNulos
FROM sys.tables t
JOIN sys.columns c ON c.object_id = t.object_id
JOIN sys.types  ty ON ty.user_type_id = c.user_type_id
ORDER BY t.name, c.column_id;

SELECT fk.name AS Relacion,
       OBJECT_NAME(fk.referenced_object_id) AS Tabla_Padre_1,
       OBJECT_NAME(fk.parent_object_id)     AS Tabla_Hija_N
FROM sys.foreign_keys fk
ORDER BY Tabla_Padre_1;
GO
