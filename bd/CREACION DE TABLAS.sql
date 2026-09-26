USE PA1_TiendaRopa;
go

/* ============================================================
   1. TABLA CLIENTE
   ============================================================ */
CREATE TABLE Cliente (
    ClienteID INT IDENTITY(1,1) NOT NULL,
    DNI VARCHAR(8) NOT NULL,
    Nombre VARCHAR(80) NOT NULL,
    Correo VARCHAR(100) NULL,
    Ciudad VARCHAR(50) NULL,
    FechaRegistro DATE NOT NULL
        CONSTRAINT DF_Cliente_FechaRegistro DEFAULT GETDATE(),

    CONSTRAINT PK_Cliente PRIMARY KEY (ClienteID),
    CONSTRAINT UQ_Cliente_DNI UNIQUE (DNI)
);
GO

/* ============================================================
   2. TABLA CATEGORIA
   ============================================================ */
CREATE TABLE Categoria (
    CategoriaID INT IDENTITY(1,1) NOT NULL,
    Nombre VARCHAR(50) NOT NULL,

    CONSTRAINT PK_Categoria PRIMARY KEY (CategoriaID),
    CONSTRAINT UQ_Categoria_Nombre UNIQUE (Nombre)
);
GO

/* ============================================================
   3. TABLA PRODUCTO
   ============================================================ */
CREATE TABLE Producto (
    ProductoID INT IDENTITY(1,1) NOT NULL,
    CategoriaID INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Talla VARCHAR(10) NULL,
    Color VARCHAR(30) NULL,
    Precio DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL,
    Activo BIT NOT NULL
        CONSTRAINT DF_Producto_Activo DEFAULT 1,

    CONSTRAINT PK_Producto PRIMARY KEY (ProductoID),
    CONSTRAINT FK_Producto_Categoria
        FOREIGN KEY (CategoriaID) REFERENCES Categoria(CategoriaID),
    CONSTRAINT CK_Producto_Precio CHECK (Precio > 0),
    CONSTRAINT CK_Producto_Stock CHECK (Stock >= 0)
);
GO

/* ============================================================
   4. TABLA VENTA
   ============================================================ */
CREATE TABLE Venta (
    VentaID INT IDENTITY(1,1) NOT NULL,
    ClienteID INT NOT NULL,
    FechaVenta DATE NOT NULL
        CONSTRAINT DF_Venta_FechaVenta DEFAULT GETDATE(),
    Estado VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Venta PRIMARY KEY (VentaID),
    CONSTRAINT FK_Venta_Cliente
        FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID),
    CONSTRAINT CK_Venta_Estado
        CHECK (Estado IN ('PENDIENTE', 'PAGADA', 'ANULADA'))
);
GO

/* ============================================================
   5. TABLA DETALLEVENTA
   ============================================================ */
CREATE TABLE DetalleVenta (
    VentaID INT NOT NULL,
    ProductoID INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_DetalleVenta PRIMARY KEY (VentaID, ProductoID),
    CONSTRAINT FK_DetalleVenta_Venta
        FOREIGN KEY (VentaID) REFERENCES Venta(VentaID),
    CONSTRAINT FK_DetalleVenta_Producto
        FOREIGN KEY (ProductoID) REFERENCES Producto(ProductoID),
    CONSTRAINT CK_DetalleVenta_Cantidad CHECK (Cantidad > 0),
    CONSTRAINT CK_DetalleVenta_PrecioUnitario CHECK (PrecioUnitario > 0)
);
GO

