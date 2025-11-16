USE Tarea3

GO

CREATE TABLE TipoUso 
(
    IdTipoUso INT PRIMARY KEY,
    Nombre NVARCHAR(100)
);

CREATE TABLE TipoLocalizacion (
    IdTipoLocalizacion INT PRIMARY KEY,
    Nombre NVARCHAR(100)
);
CREATE TABLE TipoAsociacion(
	Id INT NOT NULL PRIMARY KEY,
	Nombre NVARCHAR(64) NOT NULL
);
CREATE TABLE TipoUsuario(
	Id INT NOT NULL PRIMARY KEY,
	Nombre NVARCHAR(32) NOT NULL
	);
CREATE TABLE TipoMedioPago (
    Id INT PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL
);
CREATE TABLE TipoMontoCC(
	id INT PRIMARY KEY,
	Nombre NVARCHAR(32)
);

CREATE TABLE PeriodoMontoCC(
	id INT PRIMARY KEY,
	Nombre NVARCHAR(32),
	QMeses INT NOT NULL,
	Dias INT NULL DEFAULT 0
);
CREATE TABLE TipoMovimientoLecturaMedidor(
	id INT PRIMARY KEY,
	Nombre NVARCHAR(32)
);

CREATE TABLE Propiedad (
	id INT IDENTITY(1,1) primary key ,
    NumeroFinca        NVARCHAR(20),
    ValorFiscal        DECIMAL(18,2) NOT NULL,
    SaldoM3            INT NOT NULL DEFAULT 0,
    FechaRegistro      DATE NOT NULL,
    TipoUsoId          INT NOT NULL ,
    TipoLocalizacionId INT NOT NULL,

	 CONSTRAINT FK_PTipoUso
        FOREIGN KEY (TipoUsoId) 
        REFERENCES TipoUso(IdTipoUso),

    CONSTRAINT FK_PTipoLocalizacion
        FOREIGN KEY (TipoLocalizacionId)
        REFERENCES TipoLocalizacion(IdTipoLocalizacion)
);
CREATE TABLE Propietario(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	Nombre NVARCHAR(128) NOT NULL,
	ValorDocumentoIdentidad NVARCHAR(20) NOT NULL,
	Email NVARCHAR(20) NOT NULL,
	Telefono NVARCHAR(20) NOT NULL,
);
CREATE TABLE PropietarioPropiedad (
    Id INT IDENTITY PRIMARY KEY,
    Idpropiertario int NOT NULL,
    IdPropiedad int NOT NULL,
    IdTipoAsociacion INT NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NULL,

	CONSTRAINT FK_PXP_Propietario
        FOREIGN KEY (Idpropiertario)
        REFERENCES Propietario(Id),

    CONSTRAINT FK_PXP_Propiedad
        FOREIGN KEY (IdPropiedad)
        REFERENCES Propiedad(id),

    CONSTRAINT FK_PXP_TipoAsociacion
        FOREIGN KEY (IdTipoAsociacion)
        REFERENCES TipoAsociacion(Id)
);
CREATE TABLE Comprobante(
	id INT IDENTITY(1,1) PRIMARY KEY,
	Fecha DATE NOT NULL,
	Codigo NVARCHAR(20)
	);

CREATE TABLE CC(
	id INT PRIMARY KEY NOT NULL,
	Nombre NVARCHAR(128) NOT NULL,
	IdTipoMontoCC INT NOT NULL,
	IdPeriodoMontoCC INT NOT NULL,
	ValorMinimo  DECIMAL(18,2),
	ValorMinimoM3  DECIMAL(18,2) ,
	ValorFijoM3Adicional  DECIMAL(18,2),
	ValorPorcentual DECIMAL(18,2),
	ValorFijo  DECIMAL(18,2) ,
	ValorM2Minimo  DECIMAL(18,2) ,
	ValorTramosM2  DECIMAL(18,2),
	
	CONSTRAINT FK_tipoMonto
		FOREIGN KEY (IdTipoMontoCC)
		REFERENCES TipoMontoCC(Id),

	CONSTRAINT FK_tipoPeriodo
		FOREIGN KEY (IdPeriodoMontoCC)
		REFERENCES PeriodoMontoCC(Id)
);


CREATE TABLE Facturas(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	IdPropiedad INT NOT NULL,
	FechaFactura DATE,
	FechaLimite  DATE,
	FechaCortaAgua DATE,
	ToTPagarOringinal Money,
	ToTPagarFinal Money,
	Estatus int,

	CONSTRAINT FK_PXFACTURAS
        FOREIGN KEY (IdPropiedad)
        REFERENCES Propiedad(Id),
	
);

CREATE TABLE Usuario(
	Id INT IDENTITY(1,1) PRIMARY KEY ,
	IdTipoUsuario INT NOT NULL,
	Nombre NVARCHAR(64) NOT NULL,
	Contraseña NVARCHAR(20) NOT NULL,

	CONSTRAINT FK_TipoUsuario 
		FOREIGN KEY (IdTipoUsuario)
		REFERENCES TipoUsuario(Id)
		);

CREATE TABLE PXCC(
	Id INT IDENTITY(1,1) PRIMARY KEY ,
	IdPropiedad INT NOT NULL,
	IdCC INT NOT NULL,
	IdTipoAsociacion INT NOT NULL,

	 CONSTRAINT FK_PXCC_Propiedad
        FOREIGN KEY (IdPropiedad)
        REFERENCES Propiedad(id),

    CONSTRAINT FK_PXCC_TipoAsociacion
        FOREIGN KEY (IdTipoAsociacion)
        REFERENCES TipoAsociacion(Id),

	CONSTRAINT FK_PXCC_TipoCC
        FOREIGN KEY (IdCC)
        REFERENCES CC(Id)

	);

CREATE TABLE Pagos(
	Id INT IDENTITY(1,1) Primary key,
	IdPropiedad INT NOT NULL,
	IdTipoMedioPago INT NOT NULL,
	NumeroReferencia NVARCHAR NOT NULL,

	CONSTRAINT FK_PAGOS_Propiedad
        FOREIGN KEY (IdPropiedad)
        REFERENCES Propiedad(id),

	CONSTRAINT FK_PAGOS_MEDIOPAGO
		FOREIGN KEY (IdTipoMedioPago)
		REFERENCES TipoMedioPago(Id)

);

CREATE TABLE LecturasMedidor(
	Id INT IDENTITY(1,1) PRIMARY KEY ,
	IdPropiedad INT NOT NULL,
	IdTipoMovimiento INT NOT NULL,
	Valor DECIMAL(18,2) ,

	CONSTRAINT FK_LMEDIDOR_Propiedad
        FOREIGN KEY (IdPropiedad)
        REFERENCES Propiedad(id),

	CONSTRAINT FK_LMEDIDOR_TipoMov
		FOREIGN KEY (IdTipoMovimiento)
		REFERENCES TipoMovimientoLecturaMedidor(Id)
);

	Fecha DATE NOT NULL,
	Codigo NVARCHAR(20)
	);

CREATE TABLE CC(
	id INT PRIMARY KEY NOT NULL,
	Nombre NVARCHAR(128) NOT NULL,
	IdTipoMontoCC INT NOT NULL,
	IdPeriodoMontoCC INT NOT NULL,
	ValorMinimo  DECIMAL(18,2),
	ValorMinimoM3  DECIMAL(18,2) ,
	ValorFijoM3Adicional  DECIMAL(18,2),
	ValorPorcentual DECIMAL(18,2),
	ValorFijo  DECIMAL(18,2) ,
	ValorM2Minimo  DECIMAL(18,2) ,
	ValorTramosM2  DECIMAL(18,2),
	
	CONSTRAINT FK_tipoMonto
		FOREIGN KEY (IdTipoMontoCC)
		REFERENCES TipoMontoCC(Id),

	CONSTRAINT FK_tipoPeriodo
		FOREIGN KEY (IdPeriodoMontoCC)
		REFERENCES PeriodoMontoCC(Id)
);


CREATE TABLE Facturas(
	Id INT PRIMARY KEY,
	IdPropiedad INT NOT NULL,
	FechaFactura DATE,
	FechaLimite  DATE,
	FechaCortaAgua DATE,
	ToTPagarOringinal Money,
	ToTPagarFinal Money,
	Estatus int,

	CONSTRAINT FK_PXFACTURAS
        FOREIGN KEY (IdPropiedad)
        REFERENCES Propiedad(Id),
	
);

CREATE TABLE Usuario(
	Id INT PRIMARY KEY NOT NULL,
	IdTipoUsuario INT NOT NULL,
	Nombre NVARCHAR(64) NOT NULL,
	Contraseña NVARCHAR(20) NOT NULL,

	CONSTRAINT FK_TipoUsuario 
		FOREIGN KEY (IdTipoUsuario)
		REFERENCES TipoUsuario(Id)
		);

CREATE TABLE PXCC(
	Id INT PRIMARY KEY NOT NULL,
	IdPropiedad INT NOT NULL,
	IdCC INT NOT NULL,
	IdTipoAsociacion INT NOT NULL,

	 CONSTRAINT FK_PXCC_Propiedad
        FOREIGN KEY (IdPropiedad)
        REFERENCES Propiedad(id),

    CONSTRAINT FK_PXCC_TipoAsociacion
        FOREIGN KEY (IdTipoAsociacion)
        REFERENCES TipoAsociacion(Id),

	CONSTRAINT FK_PXCC_TipoCC
        FOREIGN KEY (IdCC)
        REFERENCES CC(Id)

	);

CREATE TABLE Pagos(
	Id INT NOT NULL,
	IdPropiedad INT NOT NULL,
	IdTipoMedioPago INT NOT NULL,
	NumeroReferencia NVARCHAR NOT NULL,

	CONSTRAINT FK_PAGOS_Propiedad
        FOREIGN KEY (IdPropiedad)
        REFERENCES Propiedad(id),

	CONSTRAINT FK_PAGOS_MEDIOPAGO
		FOREIGN KEY (IdTipoMedioPago)
		REFERENCES TipoMedioPago(Id)

);

CREATE TABLE LecturasMedidor(
	Id INT PRIMARY KEY NOT NULL,
	IdPropiedad INT NOT NULL,
	IdTipoMovimiento INT NOT NULL,
	Valor DECIMAL(18,2) ,

	CONSTRAINT FK_LMEDIDOR_Propiedad
        FOREIGN KEY (IdPropiedad)
        REFERENCES Propiedad(id),

	CONSTRAINT FK_LMEDIDOR_TipoMov
		FOREIGN KEY (IdTipoMovimiento)
		REFERENCES TipoMovimientoLecturaMedidor(Id)
);

