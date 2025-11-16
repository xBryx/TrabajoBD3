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
