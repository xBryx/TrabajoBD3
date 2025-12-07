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
			SET @outmsj = 'No existe propiedad con ese número';
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

DECLARE @msj NVARCHAR(MAX)

EXEC dbo.sp_Generar_Detalles 1, @outConcepto = @msj OUTPUT;
SELECT @msj



GO
ALTER PROCEDURE dbo.sp_Calcular_Intereses
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

DECLARE @outMonto2 INT, @outMsj NVARCHAR(128);

EXEC dbo.sp_Calcular_Intereses
    @inIdFactura = 1,
    @outMonto = @outMonto2 OUTPUT,
    @outDetalle = @outMsj OUTPUT;

SELECT @outMonto2 AS Monto, @outMsj AS Mensaje;


GO
ALTER PROCEDURE dbo.sp_Factura_Pendiente_Propiedad
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
			
			SET @detalles = @detalles + @detalle --añade el detalle de intereses
			SELECT @monto = f.ToTPagarFinal + @monto --Añadir total + intereses
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
						f.FechaFactura = --Solo selecciona la factura más vieja
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

CREATE TABLE dbo.CorteAgua( --Tabla necesaria
id INT PRIMARY KEY IDENTITY(1,1),
Estado INT, 
FacturaId INT NOT NULL,
FOREIGN KEY (FacturaId) REFERENCES dbo.Facturas(id)
);
ALTER TABLE dbo.Pagos --iMPORTANTE
ALTER COLUMN NumeroReferencia NVARCHAR(20)

--RECREAR TABLA FACTURA LINEA CON IDENTITY MANTENIENDO LOS DATOS
EXEC sp_rename 'FacturaLinea', 'FacturaLinea_old';
CREATE TABLE dbo.FacturaLinea (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    IdFactura INT NOT NULL,
    IdCC INT NOT NULL,
    Monto MONEY NOT NULL,
    Detalle NVARCHAR(200) NULL,

    CONSTRAINT FK_Linea_Factura_
        FOREIGN KEY (IdFactura)
        REFERENCES Facturas(Id),

    CONSTRAINT FK_Linea_CC_
        FOREIGN KEY (IdCC)
        REFERENCES CC(Id)
);
SET IDENTITY_INSERT FacturaLinea ON; --Meter los datos a la nueva tabla

INSERT INTO FacturaLinea (Id, IdFactura, IdCC, Detalle, Monto)
SELECT Id, IdFactura, IdCC, Detalle, Monto
FROM FacturaLinea_old;

SET IDENTITY_INSERT FacturaLinea OFF;
DROP TABLE FacturaLinea_old;



GO
CREATE PROCEDURE dbo.sp_Pagar
	@inIdFactura INT
	, @inNumFinca NVARCHAR(20)
AS
DECLARE   @idPropiedad INT
		, @numReferencia NVARCHAR(20)
		, @montoPago MONEY = 0
		, @fechaLimite DATE
		, @detalle NVARCHAR(200)
BEGIN
	BEGIN TRY	
	
		SELECT @idPropiedad = p.id
		FROM dbo.Propiedad p
		WHERE p.NumeroFinca = @inNumFinca	
		
		SELECT @fechaLimite = f.FechaLimite
		FROM dbo.Facturas f
		WHERE f.Id = @inIdFactura
		
		SET @numReferencia =  'RCPT-' 
							  +  FORMAT(GETDATE(), 'yyyyMM') + '-'
							  +  @inNumFinca	

		BEGIN TRANSACTION
			IF (DATEDIFF(DAY, @fechaLimite, GETDATE()) > 0) --En caso de que la factura ya haya vencido
				BEGIN 				
				EXEC  dbo.sp_Calcular_Intereses @inIdFactura = @inIdFactura, @outMonto = @montoPago OUTPUT, @outDetalle = @detalle OUTPUT			
						
				INSERT INTO FacturaLinea(  --Se inserta una nueva linea en la factura
										  IdFactura
										, IdCC
										, Detalle
										, Monto)
					VALUES(  
							@inIdFactura
							, 7
							, 'InteresesMoratorios'
							, @montoPago
						  )							 
				END
		
			UPDATE f --Actualizar el estado de la factura a pagado y agrega el monto de los impuestos
			SET f.Estatus = 2	
				, f.ToTPagarFinal =	f.ToTPagarOringinal + @montoPago
			FROM dbo.Facturas f
			WHERE (f.Id = @inIdFactura);
		COMMIT

		SELECT @montoPago = f.ToTPagarFinal --
		FROM dbo.Facturas f
		WHERE (f.Id = @inIdFactura);

		IF EXISTS (						--Orden de reconexion de agua		
				SELECT	1				
				FROM dbo.FacturaLinea fl
				WHERE (
						fl.IdFactura = @inIdFactura
						AND
						fl.IdCC = 6
					  )			 
					)			
			BEGIN				
				UPDATE c --Actualizar el estado de corte de agua 
				SET c.Estado = 2
				FROM dbo.CorteAgua c
				WHERE c.FacturaId = @inIdFactura				
			END
		INSERT INTO dbo.Pagos   (  --Insertar el pago hecho
								  IdPropiedad
								, IdTipoMedioPago
								, NumeroReferencia
								)
			VALUES  ( 
					  @idPropiedad
					, 1
					, @numReferencia
					)
		INSERT INTO dbo.Comprobante (
										Fecha
										, Codigo									
									)
				VALUES  (
							GETDATE()
							, @numReferencia
						)

		SELECT   GETDATE()      AS Fecha
			   , @numReferencia AS Referencia
			   , @montoPago     AS Monto	
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW; 		
	END CATCH
END



--Datos de prueba
EXEC dbo.sp_Factura_Pendiente_Propiedad 'F-0001'
EXEC dbo.sp_Factura_A_Cobrar 'F-0001'
EXEC dbo.sp_Pagar 3, 'F-0001'

INSERT INTO dbo.PXCC
            (
                  IdPropiedad
                , IdCC
                , IdTipoAsociacion
            )
            VALUES
            (
                  1
                , 7
                , 1
            );

INSERT INTO dbo.Facturas(IdPropiedad, FechaFactura, FechaLimite, FechaCortaAgua, ToTPagarOringinal, ToTPagarFinal, Estatus)
VALUES (1, '2025-08-11', '2025-08-16', '2025-08-19', 15000, 15000, 1),
	   (1, '2025-09-11', '2025-09-16', '2025-09-19', 15000, 15000, 1)	

INSERT INTO dbo.FacturaLinea(IdFactura, IdCC, Monto, Detalle)
VALUES (5, 1, 10000, 'Agua'),
	   (5, 4, 5000, 'RecoleccionBasura'),
	   (4, 1, 10000, 'Agua'),
	   (4, 4, 5000, 'RecoleccionBasura')
	   