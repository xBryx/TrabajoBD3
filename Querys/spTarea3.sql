USE Tarea3
GO

CREATE PROCEDURE dbo.SP_ListarPropiedades
(
	@CodigoResultado INT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	SET @CodigoResultado = 1;
		BEGIN TRY
			SELECT pr.NumeroFinca,
				   pt.Nombre ,
				   pt.ValorDocumentoIdentidad,
				   pr.FechaRegistro
			FROM dbo.PropietarioPropiedad AS pxp --- es propietarioproiedad pxp
			INNER JOIN dbo.Propiedad AS pr       ---y propiedad pr entonces por id pr igual a pxp id
				ON pr.id = pxp.IdPropiedad
			INNER JOIN dbo.Propietario AS pt     --- ademas de su propietario p es igual id a idpropietario 
				ON pt.Id = pxp.Idpropiertario

			ORDER BY pr.NumeroFinca, pt.Nombre; ---ordenelo por numerofinca o nombre si son iguales

		END TRY
		BEGIN CATCH
			PRINT 'Error al ejecutar store procedure Listar' 
			PRINT ERROR_MESSAGE();
			RETURN -1; ---FALLO
		END CATCH
END;

GO

 CREATE PROCEDURE dbo.ListarPagos(
	@NumeroFinca NVARCHAR(64) ,
	@CodigoResultado INT OUTPUT
	
 )
 AS
BEGIN
	SET NOCOUNT ON;
	SET @CodigoResultado = 1;
	DECLARE @IdFinca INT;

	BEGIN TRY
		SELECT @IdFinca = pr.id   --idfinca va a ser id de la tabla propiedad
		FROM dbo.Propiedad AS pr
		WHERE NumeroFinca=@NumeroFinca; --Buscamos id por numero de finca

		SELECT tmp.Nombre AS TipoMedioPago,
				pg.NumeroReferencia AS NumeroReferencia

		FROM dbo.Pagos AS pg
		INNER JOIN dbo.TipoMedioPago AS tmp
			ON tmp.Id = pg.IdTipoMedioPago
		INNER JOIN dbo.Propiedad AS pr
            ON pr.Id = pg.IdPropiedad
		WHERE pg.IdPropiedad = @idFinca  ---si es igual se filtra y sale sino pues no
		

		ORDER BY pg.NumeroReferencia; --ordenar por numero de referencia
	END TRY
	BEGIN CATCH
		SET @CodigoResultado=-1;
		RETURN @CodigoResultado;
	END CATCH
END;
GO
CREATE PROCEDURE dbo.InsertarPropietario
(
	@Nombre NVARCHAR(128),
	@ValorIdentidad NVARCHAR(20),
	@Email NVARCHAR(20),
	@Telefono NVARCHAR(20),
	@CodigoResultado INT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	SET @CodigoResultado=1;

	BEGIN TRY
		BEGIN TRAN
			INSERT INTO dbo.Propietario(
							Nombre,
							ValorDocumentoIdentidad,
							Email,
							Telefono)
			VALUES(
					@Nombre,
					@ValorIdentidad,
					@Email,
					@Telefono
					)
		COMMIT;

	END TRY

	BEGIN CATCH
		 IF @@TRANCOUNT > 0
            ROLLBACK;   

        SET @CodigoResultado = -1;  
        RETURN;
	END CATCH
END

GO 

CREATE PROCEDURE dbo.SP_InsertarPropiedades
(
	@NumeroFinca NVARCHAR(20),
	@Valor MONEY,
	@Saldo INT,
	@Fecha DATE,
	@TipoUso INT,
	@Zona INT,
	@Medidor NVARCHAR(20)
)
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @CodigoResultado INT;
	SET @CodigoResultado=1;
	BEGIN TRY

		IF EXISTS(
			SELECT 1
			FROM dbo.Propiedad AS p
			WHERE p.NumeroFinca = @NumeroFinca
			)
		BEGIN
			SET @CodigoResultado=-1;
			RETURN
		END

		IF NOT EXISTS(
				SELECT 1
				FROM dbo.TipoUso AS tp
				WHERE tp.IdTipoUso=@TipoUso
				)
		BEGIN
			SET @CodigoResultado=-1;
			RETURN
		END

		IF NOT EXISTS(
				SELECT 1
				FROM dbo.TipoLocalizacion AS tl
				WHERE tl.IdTipoLocalizacion=@Zona
				)
		BEGIN
			SET @CodigoResultado=-1;
			RETURN
		END

		BEGIN TRAN
			INSERT INTO dbo.Propiedad(
										NumeroFinca,
										ValorFiscal,
										SaldoM3,
										FechaRegistro,
										TipoUsoId,
										TipoLocalizacionId,
										NumeroMedidor)
			VALUES(
					@NumeroFinca,
					@Valor,
					@Saldo,
					@Fecha,
					@TipoUso,
					@Zona,
					@Medidor
					)
		COMMIT;
										
	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT > 0
            ROLLBACK;

        SET @CodigoResultado = -1;
        RETURN;
	END CATCH
END
					
GO

CREATE PROCEDURE dbo.SP_Asociar
(
	@valorDocumento NVARCHAR(20),
	@numeroFinca NVARCHAR(20),
	@tipoAsociacion INT
)
AS
BEGIN
	SET NOCOUNT ON 
	DECLARE @CodigoResultado INT;
	SET @CodigoResultado=1;
	DECLARE @Inicio DATE;
	SET @INICIO= GETDATE();
	DECLARE @FIN DATE;
	SET @FIN=NULL;
	DECLARE @PrId int;
	DECLARE @PId int;
	BEGIN TRY
		IF NOT EXISTS(
			SELECT 1
			FROM dbo.Propietario AS pr
			WHERE pr.ValorDocumentoIdentidad = @valorDocumento
			)
		BEGIN
			SET @CodigoResultado=-1;
			RETURN
		END
		IF NOT EXISTS(
			SELECT 1
			FROM dbo.Propiedad AS p
			WHERE p.NumeroFinca = @NumeroFinca
			)
		BEGIN
			SET @CodigoResultado=-1;
			RETURN
		END

		IF NOT EXISTS(
				SELECT 1
				FROM dbo.TipoAsociacion AS ta
				WHERE ta.Id=@tipoAsociacion
				)
		BEGIN
			SET @CodigoResultado=-1;
			RETURN
		END

		SELECT @PrId=Id
		FROM dbo.Propietario AS pr
		WHERE pr.ValorDocumentoIdentidad=@valorDocumento

		SELECT @PId=id
		FROM dbo.Propiedad AS p
		WHERE p.NumeroFinca = @NumeroFinca

		BEGIN TRAN
			INSERT INTO dbo.PropietarioPropiedad
												(
												Idpropiertario,
												IdPropiedad,
												IdTipoAsociacion,
												FechaInicio,
												FechaFin
												)
			VALUES
				(
				@PrId,
				@PId,
				@tipoAsociacion,
				@INICIO,
				@FIN
				)
		COMMIT;
	END TRY

	BEGIN CATCH

		IF @@TRANCOUNT > 0
            ROLLBACK;

        SET @CodigoResultado = -1;
        RETURN;
	END CATCH
END


GO
CREATE PROCEDURE dbo.sp_Login
	  @inUsername NVARCHAR(64)
	, @inPassword NVARCHAR(20)
	
AS
BEGIN TRY
	--Variables de salida
	DECLARE @outDescripcion NVARCHAR(128);
	DECLARE @idUsuario INT;

	IF NOT EXISTS( --Validar que el usuario existe (id error = 12)
	SELECT 1 
	FROM dbo.Usuario u
	WHERE u.Nombre = @inUsername
	)
	BEGIN 
		
		SET @outDescripcion = 'Usuario no existe';		
		SELECT @outDescripcion AS Descripcion;
		RETURN -1;
	END;

	SELECT @idUsuario = u.id 
	FROM dbo.Usuario u
	WHERE u.Nombre = @inUsername;

	IF NOT EXISTS ( --Validar que la contraseña correcta (id error = 13)
	SELECT 1
	FROM dbo.Usuario u
	WHERE u.Nombre = @inUsername
	AND u.Contraseña = @inPassword
	)
	BEGIN;

		SET @outDescripcion = 'Contraseña incorrecta';
		SELECT @outDescripcion AS Descripcion;
		RETURN -1;
	END;	
	RETURN 0;
END TRY

BEGIN CATCH
	PRINT 'Error al ejecutar store procedure Login'
	PRINT ERROR_MESSAGE();
END CATCH;


GO
CREATE PROCEDURE dbo.sp_Busqueda_ValorIdentidad_Propiedad
	@inValorIdentidad NVARCHAR(20)
	, @outmsj NVARCHAR(100) OUTPUT
AS  
BEGIN 
	SET @outmsj = '';
	BEGIN TRY
	
	IF NOT EXISTS (SELECT 1 --Validar que el propietario existe
		FROM dbo.Propietario p
		WHERE p.valorDocumentoIdentidad = @inValorIdentidad)
		BEGIN;
			SET @outmsj = 'No existe propietario con esa identificación';
			RETURN -1;
		END;
	
	SELECT pr.NumeroFinca AS numPropiedad
		 , p.nombre       AS nombrePropietario	 
	FROM dbo.PropietarioPropiedad pp
	INNER JOIN dbo.Propietario p ON p.id  = pp.Idpropiertario
	INNER JOIN dbo.Propiedad pr  ON pr.id = pp.IdPropiedad	
	WHERE (  p.valorDocumentoIdentidad = @inValorIdentidad
		    AND    pp.IdTipoAsociacion = 1 --Asociado
		  )
	ORDER BY numPropiedad;
	SET @outmsj = '';
	RETURN 0;

	END TRY
	BEGIN CATCH;
		SET @outmsj = ERROR_MESSAGE();
		RETURN -1;
	END CATCH;
END;



GO
CREATE PROCEDURE dbo.sp_Busqueda_NumPropiedad_Propiedad
	@inNumPropiedad NVARCHAR(20)
	, @outmsj NVARCHAR(100) OUTPUT
AS  
BEGIN 
	SET @outmsj = '';
	BEGIN TRY
	
	IF NOT EXISTS 
		(
		SELECT 1 --Validar que el propietario existe
		FROM dbo.Propiedad p
		WHERE p.NumeroFinca = @inNumPropiedad
		)
		BEGIN;
			SET @outmsj = 'No existe propiedad con ese número';
			RETURN -1;
		END;
	
	SELECT pr.NumeroFinca AS numPropiedad
		 , p.nombre AS nombrePropietario	 
	FROM dbo.PropietarioPropiedad pp
	INNER JOIN dbo.Propietario p ON p.id  = pp.Idpropiertario
	INNER JOIN dbo.Propiedad pr  ON pr.id = pp.IdPropiedad	
	WHERE (  pr.NumeroFinca= @inNumPropiedad
		    AND pp.IdTipoAsociacion = 1
		  )
	ORDER BY numPropiedad;
	SET @outmsj = '';
	RETURN 0;

	END TRY
	BEGIN CATCH;
		SET @outmsj = ERROR_MESSAGE();
		RETURN -1;
	END CATCH;

END;

go

ALTER PROCEDURE dbo.InsertarPXCC
(
      @inNumeroFinca      NVARCHAR(20)
    , @inIdCC             INT
    , @inIdTipoAsociacion INT
    , @outResultCode      INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @outResultCode = 1;  -- éxito por defecto

    BEGIN TRY
        
        DECLARE @IdPropiedad INT;

        SELECT @IdPropiedad = p.Id
        FROM dbo.Propiedad AS p
        WHERE p.NumeroFinca = @inNumeroFinca;

        IF (@IdPropiedad IS NULL)
        BEGIN
            SET @outResultCode = -2;  -- propiedad no existe
            RETURN;
        END

        BEGIN TRAN

            INSERT INTO dbo.PXCC
            (
                  IdPropiedad
                , IdCC
                , IdTipoAsociacion
            )
            VALUES
            (
                  @IdPropiedad
                , @inIdCC
                , @inIdTipoAsociacion
            );

        COMMIT;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;

        SET @outResultCode = -1; -- error general
        RETURN;
    END CATCH;
END
GO

--Datos de prueba
INSERT INTO dbo.TipoUsuario(Id, Nombre)
	VALUES (1, 'Admin')

INSERT INTO dbo.Usuario( IdTipoUsuario, Nombre, Contraseña)
	VALUES( 1, 'Administrador', 'SoyAdmin')

INSERT INTO dbo.Propietario(Nombre, ValorDocumentoIdentidad, Email, Telefono)
	VALUES('Valeria Solano', '10000001', 'p01@ejemplo.org', '8001-0001')

INSERT INTO dbo.TipoLocalizacion(IdTipoLocalizacion, Nombre)
	VALUES (1, 'Residencial')

INSERT INTO dbo.TipoUso(IdTipoUso, Nombre)
	VALUES(1, 'Habitación')

INSERT INTO dbo.Propiedad(NumeroFinca, ValorFiscal, FechaRegistro, TipoUsoId, TipoLocalizacionId, NumeroMedidor, metrosCuadrados)
	VALUES('F-0001', 21500000, '2025-06-02', 1, 1, 'M-1001',135)

INSERT INTO dbo.TipoAsociacion(Id, Nombre)
	VALUES(1, 'Asociar')

INSERT INTO dbo.PropietarioPropiedad(Idpropiertario, IdPropiedad, IdTipoAsociacion, FechaInicio)
	VALUES(1, 1, 1, '2025-06-02')

INSERT INTO dbo.TipoMedioPago (Id, Nombre)
  VALUES( 1, 'Efectivo')

---Necesario para insertar PXCC
INSERT INTO dbo.TipoMovimientoLecturaMedidor (Id, Nombre)
VALUES
(1, 'Lectura'),
(2, 'Ajuste Crédito'),
(3, 'Ajuste Débito');

INSERT INTO dbo.TipoUso (IdTipoUso, Nombre)
VALUES

(2, 'Comercial'),
(3, 'Industrial'),
(4, 'Lote Baldío'),
(5, 'Agrícola');

INSERT INTO dbo.TipoLocalizacion (IdTipoLocalizacion, Nombre)
VALUES
(2, 'Agrícola'),
(3, 'Bosque'),
(4, 'Industrial'),
(5, 'Comercial');

INSERT INTO dbo.TipoAsociacion (Id, Nombre)
VALUES
(2, 'Desasociar');

INSERT INTO dbo.TipoMedioPago (Id, Nombre)
VALUES
(2, 'Tarjeta');

INSERT INTO dbo.PeriodoMontoCC (Id, Nombre, QMeses, Dias)
VALUES
(1, 'Mensual', 1, NULL),
(2, 'Trimestral', 3, NULL),
(3, 'Semestral', 6, NULL),
(4, 'Anual', 12, NULL),
(5, 'Único', 1, NULL),
(6, 'Interés Diario', 1, 30);  

INSERT INTO dbo.TipoMontoCC (Id, Nombre)
VALUES
(1, 'Monto Fijo'),
(2, 'Monto Variable'),
(3, 'Porcentaje');

INSERT INTO dbo.CC
(
      Id
    , Nombre
    , IdTipoMontoCC
    , IdPeriodoMontoCC
    , ValorMinimo
    , ValorMinimoM3
    , ValorFijoM3Adicional
    , ValorPorcentual
    , ValorFijo
    , ValorM2Minimo
    , ValorTramosM2
)
VALUES
(1, 'ConsumoAgua', 
    2, 1, 
    500, 30, 100, 
    NULL, NULL, NULL, NULL),

(2, 'PatenteComercial', 
    1, 3, 
    NULL, NULL, NULL, 
    NULL, 150000, NULL, NULL),

(3, 'ImpuestoPropiedad', 
    3, 4, 
    NULL, NULL, NULL, 
    0.01, NULL, NULL, NULL),

(4, 'RecoleccionBasura', 
    1, 1, 
    150, NULL, NULL, 
    NULL, 300, 400, 75),

(5, 'MantenimientoParques', 
    1, 1, 
    NULL, NULL, NULL, 
    NULL, 2000, NULL, NULL),

(6, 'ReconexionAgua', 
    1, 5, 
    NULL, NULL, NULL, 
    NULL, 30000, NULL, NULL),

(7, 'InteresesMoratorios', 
    3, 6, 
    NULL, NULL, NULL, 
    0.04, NULL, NULL, NULL);

DECLARE @Codigo INT;

EXEC dbo.InsertarPXCC
      @inNumeroFinca = 'F-0001',
      @inIdCC = 3,
      @inIdTipoAsociacion = 1,
      @outResultCode = @Codigo OUTPUT;

SELECT @Codigo AS Resultado;

