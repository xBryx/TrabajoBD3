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

