USE Tarea3;
GO

---se limpian las tablas temporales que se crean en el script de llenado 
IF CURSOR_STATUS('global','cur_Dias') >= -1
BEGIN
    IF CURSOR_STATUS('global','cur_Dias') = 1 CLOSE cur_Dias;
    DEALLOCATE cur_Dias;
END;

IF CURSOR_STATUS('global','cur_Lecturas') >= -1
BEGIN
    IF CURSOR_STATUS('global','cur_Lecturas') = 1 CLOSE cur_Lecturas;
    DEALLOCATE cur_Lecturas;
END;

IF CURSOR_STATUS('global','cur_Pagos') >= -1
BEGIN
    IF CURSOR_STATUS('global','cur_Pagos') = 1 CLOSE cur_Pagos;
    DEALLOCATE cur_Pagos;
END;

IF OBJECT_ID('tempdb..#Dias') IS NOT NULL
    DROP TABLE #Dias;

--  se declaran las variables para la lectura del xml
DECLARE @RutaArchivoXML NVARCHAR(500) = N'C:\xmls\simulacionActu.xml';
DECLARE @SQLCargaXML NVARCHAR(MAX);
DECLARE @XMLDocumento XML;

SET @SQLCargaXML = '
SELECT @XML_OUT = TRY_CAST(BulkColumn AS XML)
FROM OPENROWSET(BULK ''' + @RutaArchivoXML + ''', SINGLE_BLOB) AS X;
';

EXEC sp_executesql ---sp temporal para lectura
      @SQLCargaXML,
      N'@XML_OUT XML OUTPUT',
      @XML_OUT = @XMLDocumento OUTPUT;

IF @XMLDocumento IS NULL  --- si ocurre error 
BEGIN
    PRINT 'ERROR: No se pudo cargar el XML.';
    RETURN;
END;


IF OBJECT_ID('tempdb..#Dias') IS NOT NULL
    DROP TABLE #Dias;

;WITH Dias AS ( ---se va por dias y se llena para lectura en el script
    SELECT
        X.value('@fecha','date') AS FechaOperacion,
        X.query('*')             AS NodoDiaCompleto
    FROM @XMLDocumento.nodes('/Operaciones/FechaOperacion') AS T(X)
)
SELECT * INTO #Dias FROM Dias;

DECLARE @DiaFechaOperacion DATE;
DECLARE @DiaNodoXML XML;

DECLARE cur_Dias CURSOR FOR
    SELECT FechaOperacion, NodoDiaCompleto
    FROM #Dias
    ORDER BY FechaOperacion;

OPEN cur_Dias;
FETCH NEXT FROM cur_Dias INTO @DiaFechaOperacion, @DiaNodoXML;


------inicio de las operaciones por dia
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '--------------------------------------------------------';
    PRINT '--- INICIO operación del día ' + CONVERT(VARCHAR,@DiaFechaOperacion) + ' ---';

  
    -- se insertan propietarios
   INSERT INTO Propietario (ValorDocumentoIdentidad, Nombre, Email, Telefono)
	SELECT
		P.value('@valorDocumento','varchar(20)'),
		P.value('@nombre','nvarchar(128)'),
		P.value('@email','nvarchar(20)'),
		P.value('@telefono','varchar(20)')
	FROM @DiaNodoXML.nodes('./Personas/Persona') AS T(P);


	--  se insertan las propiedades
	INSERT INTO Propiedad (NumeroFinca, NumeroMedidor, MetrosCuadrados,
						   TipoUsoId, TipoLocalizacionId, ValorFiscal, FechaRegistro)
	SELECT
		P.value('@numeroFinca','varchar(20)'),
		P.value('@numeroMedidor','varchar(20)'),
		P.value('@metrosCuadrados','int'),
		P.value('@tipoUsoId','int'),
		P.value('@tipoZonaId','int'),
		P.value('@valorFiscal','decimal(18,2)'),
		P.value('@fechaRegistro','date')
	FROM @DiaNodoXML.nodes('./Propiedades/Propiedad') AS T(P);


	-- se insertan los pxp
	INSERT INTO PropietarioPropiedad (idpropiertario, IdPropiedad, IdTipoAsociacion, FechaInicio)
	SELECT
		pr.Id,
		p.Id,
		M.value('@tipoAsociacionId','int'),
		@DiaFechaOperacion
	FROM @DiaNodoXML.nodes('./PropiedadPersona/Movimiento') AS T(M)
	INNER JOIN Propietario pr ON pr.ValorDocumentoIdentidad = M.value('@valorDocumento','varchar(20)')
	INNER JOIN Propiedad p ON p.NumeroFinca = M.value('@numeroFinca','varchar(20)');

	---se agregan los pxcc que ya vienen los demas van por trigger
	INSERT INTO PXCC (IdPropiedad, IdCC, IdTipoAsociacion)
	SELECT
		p.Id,
		M.value('@idCC','int'),
		M.value('@tipoAsociacionId','int')
	FROM @DiaNodoXML.nodes('./CCPropiedad/Movimiento') AS T(M)
	INNER JOIN Propiedad p ON p.NumeroFinca = M.value('@numeroFinca','varchar(20)');

	----se va haciendo lectura por el documento
    DECLARE @LecturaMedidor VARCHAR(20),
            @LecturaTipoMov INT,
            @LecturaValor DECIMAL(18,2),
            @LecturaResultado INT;

    DECLARE cur_Lecturas CURSOR FOR
        SELECT
            L.value('@numeroMedidor','varchar(20)'),
            L.value('@tipoMovimientoId','int'),
            L.value('@valor','decimal(18,2)')
        FROM @DiaNodoXML.nodes('LecturasMedidor/Lectura') AS T(L);

    OPEN cur_Lecturas;
    FETCH NEXT FROM cur_Lecturas INTO @LecturaMedidor, @LecturaTipoMov, @LecturaValor;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.InsertarLectura
             @numeroMedidor      = @LecturaMedidor,
             @inIdTipoMovimiento = @LecturaTipoMov,
             @inValor            = @LecturaValor,
             @outResultCode      = @LecturaResultado OUTPUT;

        PRINT 'Lectura → Medidor:' + @LecturaMedidor 
            + ' Tipo:' + CAST(@LecturaTipoMov AS VARCHAR)
            + ' Valor:' + CAST(@LecturaValor AS VARCHAR)
            + ' Resultado:' + CAST(@LecturaResultado AS VARCHAR);

        FETCH NEXT FROM cur_Lecturas INTO @LecturaMedidor, @LecturaTipoMov, @LecturaValor;
    END

    CLOSE cur_Lecturas;
    DEALLOCATE cur_Lecturas;

    ----se recorre y se hace los pagos
    DECLARE @PagoFinca NVARCHAR(20),
            @PagoMedio INT,
            @PagoReferencia VARCHAR(100);

    DECLARE cur_Pagos CURSOR FOR
        SELECT
            P.value('@numeroFinca','varchar(20)'),
            P.value('@tipoMedioPagoId','int'),
            P.value('@numeroReferencia','varchar(100)')
        FROM @DiaNodoXML.nodes('Pagos/Pago') AS T(P);

    OPEN cur_Pagos;
    FETCH NEXT FROM cur_Pagos INTO @PagoFinca, @PagoMedio, @PagoReferencia;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'Pago → Finca:' + @PagoFinca 
              + ' Medio:' + CAST(@PagoMedio AS VARCHAR)
              + ' Ref:' + @PagoReferencia;

        EXEC dbo.sp_Pagar
             @inNumFinca        = @PagoFinca,
             @inIdTipoMedioPago = @PagoMedio,
             @FechaOperacion    = @DiaFechaOperacion;

        FETCH NEXT FROM cur_Pagos INTO @PagoFinca, @PagoMedio, @PagoReferencia;
    END

    CLOSE cur_Pagos;
    DEALLOCATE cur_Pagos;

   ----se hace facturaciones
    DECLARE @ResultadoFact INT;

    EXEC dbo.sp_Facturar
         @FechaOperacion = @DiaFechaOperacion,
         @outResult      = @ResultadoFact OUTPUT;

    PRINT 'Facturación resultado: ' + CAST(@ResultadoFact AS VARCHAR);

   --se hacen cortes de agua
    DECLARE @ResultadoCorte INT;

    EXEC dbo.sp_Facturar_Corte_Agua
         @FechaOperacion = @DiaFechaOperacion,
         @outResult      = @ResultadoCorte OUTPUT;

    PRINT 'Corte Agua resultado: ' + CAST(@ResultadoCorte AS VARCHAR);


    PRINT '--- FIN operación del día ' + CONVERT(VARCHAR,@DiaFechaOperacion) + ' ---';

    FETCH NEXT FROM cur_Dias INTO @DiaFechaOperacion, @DiaNodoXML;
END

CLOSE cur_Dias;
DEALLOCATE cur_Dias;

DROP TABLE #Dias;
GO
