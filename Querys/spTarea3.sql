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

ALTER PROCEDURE dbo.SP_Asociar
(
	@FechaOperacion DATE,
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
	SET @INICIO= @FechaOperacion;
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

	IF NOT EXISTS
		( --Validar que el usuario existe (id error = 12)
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

	IF NOT EXISTS
		( 
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
	
	IF NOT EXISTS 
		(
		SELECT 1 --Validar que el propietario existe
		FROM dbo.Propietario p
		WHERE p.valorDocumentoIdentidad = @inValorIdentidad
		)
		BEGIN;
			SET @outmsj = 'No existe propietario con esa identificación';
			RETURN -1;
		END;
	
	SELECT pr.NumeroFinca AS numPropiedad
		 , p.nombre       AS nombrePropietario	 
	FROM dbo.PropietarioPropiedad pp
	INNER JOIN dbo.Propietario p ON p.id  = pp.Idpropiertario
	INNER JOIN dbo.Propiedad pr  ON pr.id = pp.IdPropiedad	
	WHERE (  
			p.valorDocumentoIdentidad = @inValorIdentidad
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
		SELECT 1 --Validar que la propiedad existe
		FROM dbo.Propiedad p
		WHERE p.NumeroFinca = @inNumPropiedad
		)
		BEGIN;
			SET @outmsj = 'No existe propiedad con ese n�mero';
			RETURN -1;
		END;
	
	SELECT pr.NumeroFinca AS numPropiedad
		 , p.nombre AS nombrePropietario	 
	FROM dbo.PropietarioPropiedad pp
	INNER JOIN dbo.Propietario p ON p.id  = pp.Idpropiertario
	INNER JOIN dbo.Propiedad pr  ON pr.id = pp.IdPropiedad	
	WHERE (  
			pr.NumeroFinca= @inNumPropiedad
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


GO 
CREATE PROCEDURE dbo.sp_Generar_Detalles --Genera los detalles de una factura
	@inIdFactura INT
	,  @outConcepto NVARCHAR(MAX) OUTPUT 
AS 
DECLARE   @lo INT = 1
		, @hi INT = 0 
		, @concepto NVARCHAR(200) = '';
		
BEGIN 
	BEGIN TRY
		SET @outConcepto = '';
		DECLARE @CCFactura TABLE (
									Sec  INT IDENTITY(1,1)
									, Detalle NVARCHAR(MAX)
									, Monto MONEY
								 );
		INSERT INTO @CCFactura (
								 Detalle
								 , Monto
							    )
		SELECT    fl.Detalle
				, fl.Monto
		FROM dbo.FacturaLinea fl
		WHERE fl.IdFactura = @inIdFactura;

		SELECT @hi = MAX(cf.Sec)
		FROM @CCFactura cf;

		WHILE (@lo <= @hi)
			BEGIN

				SELECT @concepto = cf.Detalle + ' ' + CAST(cf.Monto AS NVARCHAR(50))
				FROM @CCFactura cf
				WHERE  cf.Sec = @lo;

				SET @outConcepto = @outConcepto + @concepto + CHAR(10); --Agregar concepto y salto de linea
				SET @lo = @lo+1;
			END; --end del while

		RETURN 0
	END TRY
	BEGIN CATCH
	 PRINT 'Error al ejecutar store procedure generar facturas'
	PRINT ERROR_MESSAGE();
	RETURN -1
	END CATCH
END



GO
CREATE PROCEDURE dbo.sp_Calcular_Intereses
	@inIdFactura INT
	, @outMonto MONEY OUTPUT
	, @outDetalle NVARCHAR(128) OUTPUT
AS	
DECLARE @fechaLimite DATE
BEGIN
	BEGIN TRY
		SELECT  @fechaLimite = f.FechaLimite
		FROM dbo.Facturas f
		WHERE f.Id = @inIdFactura
		IF (
				DATEDIFF(DAY ,@fechaLimite, GETDATE()) < 0
			)
		BEGIN
			SET @outMonto = 0;
			SET @outDetalle = ''
			RETURN
		END

		SELECT @outMonto = ((f.ToTPagarOringinal * 0.04) / 30)*(DATEDIFF(DAY, @fechaLimite, GETDATE()))
				, @outDetalle = 'InteresesMoratorios ' + CAST(@outMonto AS NVARCHAR(50))		
		FROM dbo.Facturas f
		WHERE f.Id = @inIdFactura;
		
		RETURN
	END TRY
	BEGIN CATCH
	PRINT 'Error al ejecutar store procedure calcular intereses'
	PRINT ERROR_MESSAGE();
	RETURN -1
	END CATCH
END



GO
CREATE PROCEDURE dbo.sp_Factura_Pendiente_Propiedad
	@inNumFinca NVARCHAR(20)
AS  
DECLARE @detalles NVARCHAR(MAX)
		, @lo INT = 1
		, @hi INT = 0 
		, @idFactura INT
		, @fechaLimite DATE
		, @monto INT
		, @detalle NVARCHAR(128)
BEGIN 
	BEGIN TRY
		DECLARE @Factura TABLE (
									SEC INT IDENTITY(1,1)
									, idFactura INT
									, fechaFactura DATE
									, fechaVencimiento DATE
									, TotalInicial MONEY
									, TotalFinal MONEY
									, Detalle NVARCHAR(MAX)
							   )
		INSERT INTO @Factura(
								idFactura
								, fechaFactura
								, fechaVencimiento
								, TotalInicial								
							)
		SELECT 
				f.Id
				, f.FechaFactura
				, f.FechaLimite
				, f.ToTPagarOringinal		   		
		FROM dbo.Facturas f	
		INNER JOIN Propiedad p ON p.id = f.IdPropiedad
		WHERE ( 
				p.NumeroFinca = @inNumFinca
				AND f.Estatus = 1 --Pendiente
			  )		
		SELECT @hi = MAX(f.SEC)
		FROM @Factura f

		WHILE (@lo <= @hi)
			BEGIN
			SELECT @idFactura = f.idFactura  --Obtener el id de la factura iterada
			FROM @Factura f
			WHERE f.SEC = @lo

			SELECT @fechaLimite = f.FechaLimite
			FROM dbo.Facturas f
			WHERE f.Id = @idFactura
			
			
			EXEC  dbo.sp_Calcular_Intereses @inIdFactura = @idFactura, @outMonto = @monto OUTPUT, @outDetalle = @detalle OUTPUT
			EXEC dbo.sp_Generar_Detalles @idFactura, @detalles OUTPUT;
			
			SET @detalles = @detalles + @detalle --a�ade el detalle de intereses
			SELECT @monto = f.ToTPagarFinal + @monto --A�adir total + intereses
			FROM Facturas f
			WHERE f.Id = @idFactura

			UPDATE @Factura --Actualiza la tabla variante, no la real
			SET Detalle = @detalles,
				TotalFinal = @monto
			WHERE SEC = @lo;
													
			SET @lo = @lo+1;
			SET @monto = 0
			SET @detalle = ''
			SET @detalles = ''
		END; --end del while
		
		SELECT  fc.idFactura            AS idFactura
				, fc.Detalle            AS ConceptoCobro
				, fc.FechaFactura       AS fechaFacturacion
				, fc.fechaVencimiento   AS FechaVence
				, fc.TotalInicial       AS TotalOriginal
				, fc.TotalFinal         AS TotalFinal
		FROM @Factura fc
		ORDER BY fc.FechaFactura ASC;
		RETURN;

	END TRY
	BEGIN CATCH;
		PRINT ERROR_MESSAGE();
		RETURN -1;
	END CATCH;

END;

GO
CREATE PROCEDURE dbo.sp_Factura_A_Cobrar --Brinda los datos de la factura disponible a pagar
	@inNumFinca NVARCHAR(20)
AS  
DECLARE @detalles NVARCHAR(MAX)
		, @lo INT = 1
		, @hi INT = 0 
		, @idFactura INT
		, @fechaLimite DATE
		, @monto MONEY
		, @detalle NVARCHAR(128)
BEGIN 
	BEGIN TRY
		DECLARE @Factura TABLE (
									SEC INT IDENTITY(1,1)
									, idFactura INT
									, fechaFactura DATE
									, fechaVencimiento DATE
									, TotalInicial MONEY
									, TotalFinal MONEY
									, Detalle NVARCHAR(MAX)
							   )
		INSERT INTO @Factura(
								idFactura
								, fechaFactura
								, fechaVencimiento
								, TotalInicial								
							)
		SELECT 
				f.Id
				, f.FechaFactura
				, f.FechaLimite
				, f.ToTPagarOringinal		   		
		FROM dbo.Facturas f	
		INNER JOIN Propiedad p ON p.id = f.IdPropiedad
		WHERE ( 
				p.NumeroFinca = @inNumFinca
				AND (f.Estatus = 1) --Pendiente
				AND ( 
						f.FechaFactura = --Solo selecciona la factura m�s vieja
								(
							SELECT MIN(f2.FechaFactura)
							FROM dbo.Facturas f2				
							WHERE f2.Estatus = 1
							AND f2.IdPropiedad = p.id
			                   )
					)
			   );				  
		SELECT @hi = MAX(f.SEC)
		FROM @Factura f

		WHILE (@lo <= @hi)
			BEGIN
			SELECT @idFactura = f.idFactura  --Obtener el id de la factura iterada
			FROM @Factura f
			WHERE f.SEC = @lo

			SELECT @fechaLimite = f.FechaLimite
			FROM dbo.Facturas f
			WHERE f.Id = @idFactura
			
			
			EXEC  dbo.sp_Calcular_Intereses @inIdFactura = @idFactura, @outMonto = @monto OUTPUT, @outDetalle = @detalle OUTPUT
			EXEC dbo.sp_Generar_Detalles @idFactura, @detalles OUTPUT;
			
			SET @detalles = @detalles + @detalle
			SELECT @monto = f.ToTPagarFinal + @monto
			FROM Facturas f
			WHERE f.Id = @idFactura

			UPDATE @Factura 
			SET Detalle = @detalles,
				TotalFinal = @monto
			WHERE SEC = @lo;
													
			SET @lo = @lo+1;
			SET @monto = 0
			SET @detalle = ''
			SET @detalles = ''
		END; --end del while

		
		SELECT  fc.idFactura            AS idFactura
				, fc.Detalle            AS ConceptoCobro
				, fc.FechaFactura       AS fechaFacturacion
				, fc.fechaVencimiento   AS FechaVence
				, fc.TotalInicial       AS TotalOriginal
				, fc.TotalFinal         AS TotalFinal
		FROM @Factura fc
		ORDER BY fc.FechaFactura ASC;
		RETURN;

	END TRY
	BEGIN CATCH;
		PRINT ERROR_MESSAGE();
		RETURN -1;
	END CATCH;
END;


GO
ALTER PROCEDURE dbo.sp_Pagar
    @inIdFactura INT,
    @inNumFinca NVARCHAR(20),
    @FechaOperacion DATE   -- NUEVO
AS
DECLARE   @idPropiedad INT,
          @numReferencia NVARCHAR(20),
          @montoPago MONEY = 0,
          @fechaLimite DATE,
          @detalle NVARCHAR(200)
BEGIN
    BEGIN TRY	

        SELECT @idPropiedad = p.id
        FROM dbo.Propiedad p
        WHERE p.NumeroFinca = @inNumFinca;

        SELECT @fechaLimite = f.FechaLimite
        FROM dbo.Facturas f
        WHERE f.Id = @inIdFactura;

        -- Número de referencia 
        SET @numReferencia = 'RCPT-' 
                             + FORMAT(@FechaOperacion, 'yyyyMM') + '-' 
                             + @inNumFinca;

        BEGIN TRANSACTION
            -- Si está vencida según FechaOperacion
            IF (DATEDIFF(DAY, @fechaLimite, @FechaOperacion) > 0)
            BEGIN
                EXEC dbo.sp_Calcular_Intereses 
                        @inIdFactura = @inIdFactura,
                        @outMonto = @montoPago OUTPUT,
                        @outDetalle = @detalle OUTPUT;

                INSERT INTO FacturaLinea
                (
                    IdFactura,
                    IdCC,
                    Detalle,
                    Monto
                )
                VALUES
                (
                    @inIdFactura,
                    7,
                    'InteresesMoratorios',
                    @montoPago
                );
            END

            UPDATE f 
            SET f.Estatus = 2,
                f.ToTPagarFinal = f.ToTPagarOringinal + @montoPago
            FROM dbo.Facturas f
            WHERE f.Id = @inIdFactura;

        COMMIT;

        SELECT @montoPago = f.ToTPagarFinal
        FROM dbo.Facturas f
        WHERE f.Id = @inIdFactura;

        IF EXISTS (
            SELECT 1
            FROM dbo.FacturaLinea fl
            WHERE fl.IdFactura = @inIdFactura
              AND fl.IdCC = 6
        )
        BEGIN
            UPDATE c
            SET c.Estado = 2
            FROM dbo.CorteAgua c
            WHERE c.FacturaId = @inIdFactura;
        END

        INSERT INTO dbo.Pagos
        (
            IdPropiedad,
            IdTipoMedioPago,
            NumeroReferencia
        )
        VALUES
        (
            @idPropiedad,
            1,
            @numReferencia
        );

        -- Insertar fecha simulada en comprobante
        INSERT INTO dbo.Comprobante
        (
            Fecha,
            Codigo
        )
        VALUES
        (
            @FechaOperacion,
            @numReferencia
        );

        -- Devolver fecha simulada, no la real
        SELECT @FechaOperacion AS Fecha,
               @numReferencia AS Referencia,
               @montoPago AS Monto;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW; 		
    END CATCH
END;

go
   

CREATE PROCEDURE dbo.InsertarPXCC
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



GO
CREATE PROCEDURE dbo.InsertarLectura
(
     @inNumeroFinca       NVARCHAR(20)
    , @inIdTipoMovimiento  INT
    , @inValor             DECIMAL(18,2)
    , @outResultCode       INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @outResultCode = 1; -- éxito por defecto

    BEGIN TRY


        DECLARE @IdPropiedad INT;

        SELECT @IdPropiedad = p.Id
        FROM dbo.Propiedad AS p
        WHERE p.NumeroFinca = @inNumeroFinca;

        IF (@IdPropiedad IS NULL)
        BEGIN
            SET @outResultCode = -2; -- Propiedad no existe
            RETURN;
        END


        IF NOT EXISTS (
            SELECT 1
            FROM dbo.TipoMovimientoLecturaMedidor AS tm
            WHERE tm.Id = @inIdTipoMovimiento
        )
        BEGIN
            SET @outResultCode = -3; -- Tipo movimiento no existe
            RETURN;
        END

        IF (@inIdTipoMovimiento = 1)
        BEGIN
            DECLARE @UltimaLectura DECIMAL(18,2);

            SELECT TOP 1 @UltimaLectura = lm.Valor
            FROM dbo.LecturasMedidor AS lm
            WHERE lm.IdPropiedad = @IdPropiedad
            ORDER BY lm.Id DESC;

            IF (@UltimaLectura IS NOT NULL AND @inValor < @UltimaLectura)
            BEGIN
                SET @outResultCode = -4; -- Lectura regresiva
                RETURN;
            END
        END

        ---------------------------------------------------------
        BEGIN TRAN

            INSERT INTO dbo.LecturasMedidor
            (
                  IdPropiedad
                , IdTipoMovimiento
                , Valor
            )
            VALUES
            (
                  @IdPropiedad
                , @inIdTipoMovimiento
                , @inValor
            );

        COMMIT;

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK;

        SET @outResultCode = -1; -- Error general
        RETURN;

    END CATCH
END;
GO

