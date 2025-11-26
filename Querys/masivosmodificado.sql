USE Tarea3

go
CREATE TABLE EventSP(
	Id INT IDENTITY (1,1 ) PRIMARY KEY
	, FechaOperacion DATE
	, Exitoso INT --1 S�, 2 No
	, TipoEvento INT --1 Facturar
)


GO 
CREATE PROCEDURE dbo.Calcular_Monto
			@inIdCC INT
			, @inIdPropiedad INT
			, @outMonto INT OUTPUT
AS
BEGIN
DECLARE @saldoM3 INT
		, @saldoM3UltimaFactura INT
		, @valorFiscal INT
		, @tamanoPropiedad INT
BEGIN TRY	

	IF(@inIdCC = 1) --Cobro agua
		BEGIN 
		SELECT @saldoM3                = p.SaldoM3
			   , @saldoM3UltimaFactura = P.SaltoM3UltimaFactura
		FROM dbo.Propiedad p 
		WHERE p.id = @inIdPropiedad
		SELECT 
			@outMonto	=	
				CASE WHEN (@saldoM3-@saldoM3UltimaFactura) > cc.ValorMinimoM3
				THEN (@saldoM3-@saldoM3UltimaFactura)*cc.ValorFijoM3Adicional
				ELSE cc.ValorMinimo
				END
		FROM dbo.CC cc		
		WHERE cc.id = 1
		
		UPDATE p --Actualizar consuma agua
		SET p.SaltoM3UltimaFactura = @saldoM3
		FROM dbo.Propiedad p
		WHERE p.id = @inIdPropiedad

		RETURN 
		END
	ELSE IF(@inIdCC = 2) --Cobro patente
		BEGIN 
		SELECT @outMonto = cc.ValorFijo/6
		FROM dbo.CC cc
		WHERE cc.id = 2
		RETURN
		END
	ELSE IF(@inIdCC = 3) --Impuesto sobre propiedad
		BEGIN 
		SELECT @valorFiscal = P.ValorFiscal
		FROM dbo.Propiedad p
		WHERE p.id = @inIdPropiedad
		SELECT @outMonto = (@valorFiscal*cc.ValorPorcentual)/12
		FROM dbo.CC cc
		WHERE cc.id = 3
		END
	ELSE IF(@inIdCC = 4) --Recolecci�n de basura
		BEGIN 
		SELECT @tamanoPropiedad = p.MetrosCuadrados			  
		FROM dbo.Propiedad p 
		WHERE p.id = @inIdPropiedad
		SELECT 
			@outMonto	=	
				CASE WHEN (@tamanoPropiedad) > cc.ValorM2Minimo
				THEN ((@tamanoPropiedad-cc.ValorM2Minimo)/200)*cc.ValorTramosM2 + cc.ValorFijo
				ELSE cc.ValorMinimo
				END
		FROM dbo.CC cc		
		WHERE cc.id = 1
		RETURN 
		END
	ELSE IF(@inIdCC = 5) --Mantenimiento de parques
		BEGIN 
		SELECT @outMonto = cc.ValorFijo/12
		FROM dbo.CC cc
		WHERE cc.id = 5
		END
END TRY
BEGIN CATCH 
	PRINT 'Error al ejecutar store procedure calcular monto'
	PRINT ERROR_MESSAGE();
	RETURN -1
END CATCH
END


GO
ALTER PROCEDURE dbo.sp_Facturar
    @FechaOperacion DATE,
	@outResult INT OUTPUT

AS
BEGIN
	DECLARE @lo			   INT = 1
			, @hi		   INT
			, @lo1         INT = 1
			, @hi1         INT
			, @montoTotal  INT
			, @monto       INT
			, @idPropiedad INT
			, @ultimoIdFac INT
			, @idCC		   INT
			, @idFacLin	   INT		
BEGIN TRY
	DECLARE @Hoy INT = DAY(@FechaOperacion),
            @ultimoDiaMes INT = DAY(EOMONTH(@FechaOperacion));
	DECLARE @PropiedadesFacturan TABLE(
				SEC INT IDENTITY(1,1)
				, idPropiedad INT);			

	IF EXISTS (
    SELECT 1 
    FROM dbo.EventSP EL
    WHERE (EL.TipoEvento = 1)
      AND (CAST(EL.FechaOperacion AS DATE) = CAST(@FechaOperacion AS DATE))
      AND (EL.Exitoso = 1)
		)

		BEGIN
			SET @outResult = 50201 --Proceso ya se corri� correctamente en el d�a
			RETURN;
		END

	IF (@Hoy = 28 --Febrero en a�o no bisiesto
		AND @Hoy = @ultimoDiaMes) 
		BEGIN
		INSERT INTO @PropiedadesFacturan(idPropiedad)
		SELECT p.id
		FROM dbo.Propiedad p
		WHERE ( DAY(p.FechaRegistro ) IN (28
										  , 29
										  , 30
										  , 31))
		END
	ELSE IF (@Hoy = 29 --Febrero en a�o bisiesto
		AND @Hoy = @ultimoDiaMes) 
		BEGIN
		INSERT INTO @PropiedadesFacturan(idPropiedad)
		SELECT p.id
		FROM dbo.Propiedad p
		WHERE ( DAY(p.FechaRegistro ) IN (29
										  , 30
										  , 31))
		END
	ELSE IF (@Hoy = 30 --Mes con 30 d�as
		AND @Hoy = @ultimoDiaMes) 
		BEGIN
		INSERT INTO @PropiedadesFacturan(idPropiedad)
		SELECT p.id
		FROM dbo.Propiedad p
		WHERE ( DAY(p.FechaRegistro ) IN (30
										  , 31))
		END
	ELSE --Caso general
		BEGIN
		INSERT INTO @PropiedadesFacturan(idPropiedad)
		SELECT p.id
		FROM dbo.Propiedad p
		WHERE (DAY(p.FechaRegistro ) = @Hoy)
		END

	SELECT @hi = MAX(pf.SEC)
		FROM @PropiedadesFacturan pf
	
	WHILE @lo<=@hi
		BEGIN
		SELECT @idPropiedad = pf.idPropiedad
		FROM @PropiedadesFacturan pf
		WHERE pf.SEC = @lo
		
		SET @montoTotal = 0;		
		
		DECLARE @CCPropiedad TABLE(	SEC INT IDENTITY(1,1) 
									, IdCC INT);
		INSERT INTO @CCPropiedad(IdCC)
		SELECT pc.IdCC
		FROM dbo.PXCC pc
		WHERE pc.IdPropiedad = @idPropiedad

		SELECT @hi1 = MAX(cp.SEC)
		FROM @CCPropiedad cp
		SET @lo1 = 1
		
		BEGIN TRAN
		   INSERT INTO dbo.Facturas (
							IdPropiedad
							, FechaFactura
							, FechaLimite
							, FechaCortaAgua
							, ToTPagarOringinal
							, ToTPagarFinal
							, Estatus
										)
			VALUES (
					@idPropiedad
					, @FechaOperacion
					, DATEADD(DAY, 15, @FechaOperacion)
					, DATEADD(DAY, 10, @FechaOperacion)
					, 0
					, 0
					, 1  -- pendiente
				   );
			SET @ultimoIdFac = SCOPE_IDENTITY();
		


		WHILE @lo1<=@hi1
			BEGIN
			SELECT @idCC = cp.IdCC
			FROM @CCPropiedad cp
			WHERE cp.SEC = @lo1

			EXEC dbo.Calcular_Monto @inIdCC = @idCC, @inIdPropiedad = @idPropiedad,@outMonto = @monto OUTPUT				
				
				INSERT INTO dbo.FacturaLinea(IdFactura
												, IdCC
												, Monto)
												
						VALUES(@ultimoIdFac
								, @idCC
								, @monto)
				SET @idFacLin = SCOPE_IDENTITY()				
				UPDATE fl 
				SET fl.Detalle = c.Nombre
				FROM dbo.FacturaLinea fl
				INNER JOIN dbo.CC c ON c.id = @idCC
				WHERE fl.Id = @idFacLin				
			SET @lo1 = @lo1 + 1;
			SET @montoTotal = @montoTotal + @monto;
			END		
			UPDATE f
			SET f.ToTPagarFinal = @montoTotal
			FROM dbo.Facturas f
			WHERE f.Id = @ultimoIdFac
		COMMIT
		SET @lo = @lo + 1
		END--del while
	
	INSERT INTO dbo.EventSP(FechaOperacion, Exitoso, TipoEvento)
	VALUES( @FechaOperacion
			, 1
			, 1
			)

END TRY
BEGIN CATCH
	IF (@@TRANCOUNT > 0)
		BEGIN 
		ROLLBACK TRAN
		END;
	INSERT INTO dbo.EventSP(FechaOperacion, Exitoso, TipoEvento)
	VALUES( @FechaOperacion
			, 2 --Fall�
			, 1
			)
END CATCH
END


GO
ALTER PROCEDURE dbo.sp_Facturar_Corte_Agua
		@FechaOperacion DATE,
		@outResult INT OUTPUT
AS
BEGIN 
	DECLARE @lo INT = 1
			, @hi INT
BEGIN TRY
	IF EXISTS (SELECT 1 FROM dbo.EventSP EL --Validar el proceso no ha corrido
						WHERE (EL.TipoEvento = 2)
						AND (CAST(EL.FechaOperacion AS DATE) = CAST(@FechaOperacion AS DATE))
						AND (EL.Exitoso = 1))
		BEGIN
			SET @outResult = 50201 --Proceso ya se corri� correctamente en el d�a
			RETURN;
		END

	DECLARE @PropiedadCorteAgua TABLE (
										SEC INT IDENTITY(1,1)
										, IdFactura INT
										, Estado INT);
	
	INSERT INTO @PropiedadCorteAgua(IdFactura
									, Estado
									)							  
		SELECT f.Id
				, f.Estatus
		FROM dbo.Facturas f		
		WHERE FechaCortaAgua =@FechaOperacion
			  AND (f.Estatus = 1)
			  

	SELECT @hi = MAX(SEC)
	FROM @PropiedadCorteAgua	
	
	WHILE @lo <= @hi
		BEGIN

			BEGIN TRANSACTION 
				INSERT INTO dbo.CorteAgua(	Estado
											, FacturaId)
				SELECT  pca.Estado
						, pca.IdFactura
				FROM @PropiedadCorteAgua pca
				WHERE pca.SEC = @lo
			COMMIT

		SET @lo = @lo + 1
		END
	INSERT INTO dbo.EventSP(FechaOperacion, Exitoso, TipoEvento)
	VALUES( @FechaOperacion
			, 1
			, 2
			)
	SET @outResult = 200;
	RETURN
END TRY
BEGIN CATCH
	IF (@@TRANCOUNT > 0)
		BEGIN 
		ROLLBACK TRANSACTION 
		END;
	INSERT INTO dbo.EventSP(FechaOperacion, Exitoso, TipoEvento)
	VALUES( @FechaOperacion
			, 2 --Fall�
			, 2
			)
END CATCH
END
