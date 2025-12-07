
USE Tarea3V1



ALTER TABLE dbo.Facturas
	ADD Concepto NVARCHAR(200)

ALTER TABLE dbo.Propiedad
	ADD metrosCuadrados INT



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
CREATE PROCEDURE dbo.sp_Factura_Pendiente_Propiedad
	@inNumFinca NVARCHAR(20)
AS  
BEGIN 
	BEGIN TRY
		
	
	SELECT f.Concepto AS ConceptoFactura
		   , f.FechaFactura AS Fecha
		   , f.FechaLimite AS FechaVencimiento
		   , f.ToTPagarOringinal AS TotalInicial
		   , CASE --Calcular los intereses en caso de ser necesario
				WHEN DATEDIFF(DAY,  f.FechaLimite, GETDATE()) < 0 
					THEN f.ToTPagarOringinal 
				ELSE f.ToTPagarOringinal + ((f.ToTPagarOringinal * 0.04) / 30)
			END AS TotalFinal		
	FROM dbo.Facturas f	
	INNER JOIN Propiedad p ON p.id = f.IdPropiedad
	WHERE ( p.NumeroFinca = @inNumFinca
			AND f.Estatus = 1 --Pendiente
		  )
	ORDER BY Fecha ASC;


	END TRY
	BEGIN CATCH;
		PRINT ERROR_MESSAGE();
		RETURN -1;
	END CATCH;

END;


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



GO
CREATE PROCEDURE dbo.sp_Factura_A_Cobrar
--Muestra las facturas válidas para pagar según la regla de negocio
--Regla Negocio: Solo se pueden pagar la factura más vieja de un concepto
	@inNumFinca NVARCHAR(20) 
AS
BEGIN
	BEGIN TRY
		DECLARE @FacturasCobro TABLE (   --Tiene las factura más vieja de cada concepto de cobro
			idFactura INT
			, Concepto VARCHAR(200)
			, FechaFactura DATE
			, FechaLimite DATE
			, TotalInicial INT
			, TotalFinal INT
									 );
	
		INSERT INTO @FacturasCobro( idFactura
									, Concepto
									, FechaFactura
									, FechaLimite
									, TotalInicial
									, TotalFinal
								  )
		SELECT    f.id
				, f.Concepto
				, f.FechaFactura
				, f.FechaLimite
				, f.ToTPagarOringinal
				, CASE --Calcular los intereses en caso de ser necesario
				  WHEN DATEDIFF(DAY, f.FechaLimite, GETDATE()) < 0 
					THEN f.ToTPagarOringinal
						ELSE f.ToTPagarOringinal + ((f.ToTPagarOringinal * 0.04) / 30)
					END
		FROM dbo.Facturas f		
		INNER JOIN dbo.Propiedad p ON p.id = f.IdPropiedad
		WHERE (  f.Estatus      = 1
			AND p.NumeroFinca = @inNumFinca
			AND f.FechaFactura = (
				SELECT MIN(f2.FechaFactura)
				FROM dbo.Facturas f2				
				WHERE f2.Concepto = f.Concepto
					AND f2.Estatus = 1
					AND f2.IdPropiedad = p.id
			                   )
			   );	

		SELECT  fc.idFactura       AS idFactura
				, fc.Concepto      AS ConceptoCobro
				, fc.FechaFactura  AS fechaFacturacion
				, fc.FechaLimite   AS FechaVence
				, fc.TotalInicial  AS TotalOriginal
				, fc.TotalFinal    AS TotalFinal
		FROM @FacturasCobro fc
		ORDER BY fc.FechaFactura ASC;
		RETURN;
		
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE();
	END CATCH
END


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


INSERT INTO dbo.Facturas(FechaFactura, FechaLimite, ToTPagarOringinal, Estatus, Concepto, IdPropiedad)
	VALUES('2025-07-02', '2025-07-17', 5000, 1, 'Agua', 1)
INSERT INTO dbo.Facturas(FechaFactura, FechaLimite, ToTPagarOringinal, Estatus, Concepto, IdPropiedad)
	VALUES('2025-08-02', '2025-08-17', 5000, 1, 'Agua', 1)
INSERT INTO dbo.Facturas(FechaFactura, FechaLimite, ToTPagarOringinal, Estatus, Concepto, IdPropiedad)
	VALUES('2025-08-02', '2025-08-17', 5000, 1, 'Recolección de basura', 1)

EXEC dbo.sp_Factura_A_Cobrar 'F-0001'



CREATE TABLE CorteAgua(
id INT PRIMARY KEY IDENTITY(1,1),
Estado INT, 
FacturaId INT NOT NULL,
FOREIGN KEY (FacturaId) REFERENCES dbo.Facturas(id)
);
CREATE TABLE dbo.OrdenReconexion(
id INT PRIMARY KEY IDENTITY(1,1),
FacturaId INT NOT NULL,
CorteAguaId INT NOT NULL,
FOREIGN KEY (FacturaId) REFERENCES dbo.Facturas(id),
FOREIGN KEY (CorteAguaId) REFERENCES dbo.CorteAgua(id)
);
ALTER TABLE dbo.Comprobante
ADD MontoPago Money	
ALTER TABLE dbo.Pagos
ALTER COLUMN NumeroReferencia NVARCHAR (20)


GO
CREATE PROCEDURE dbo.sp_Pagar
	@inIdFactura INT
	, @inNumFinca NVARCHAR(20)
AS
DECLARE   @idPropiedad INT
		, @numReferencia NVARCHAR(30)
		, @montoPago INT
BEGIN
	BEGIN TRY	
	BEGIN TRANSACTION
		SELECT @idPropiedad = p.id
		FROM dbo.Propiedad p
		WHERE p.NumeroFinca = @inNumFinca		
		
		SET @numReferencia =  'RCPT-' 
							  +  FORMAT(GETDATE(), 'yyyyMM') + '-'
							  +  @inNumFinca
		



		SELECT @montoPago = CASE --Calcular los intereses en caso de ser necesario
								WHEN DATEDIFF(DAY, f.FechaLimite, GETDATE()) < 0 
								THEN f.ToTPagarOringinal
								ELSE f.ToTPagarOringinal + ((f.ToTPagarOringinal * 0.04) / 30)
							END
		FROM dbo.Facturas f
		WHERE (f.Id = @inIdFactura);

		UPDATE f --Actualizar el estado de la factura a pagado
		SET f.Estatus = 2		
		FROM dbo.Facturas f
		WHERE (f.Id = @inIdFactura);

		IF EXISTS (
								
				SELECT	1				
				FROM dbo.Facturas f
				WHERE (
						f.Id = @inIdFactura
						AND
						f.Concepto = 'Reconexion Agua'
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
										, MontoPago
									)
				VALUES  (
							GETDATE()
							, @numReferencia
							, @montoPago
						)

		SELECT   GETDATE()      AS Fecha
			   , @numReferencia AS Referencia
			   , @montoPago     AS Monto

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW; 		
	END CATCH
END


EXEC dbo.sp_Pagar 4, 'F-0001'
INSERT INTO dbo.Facturas(FechaFactura, FechaLimite, ToTPagarOringinal, Estatus, Concepto, IdPropiedad)
	VALUES('2025-07-02', '2025-07-17', 5000, 1, 'Agua', 1)