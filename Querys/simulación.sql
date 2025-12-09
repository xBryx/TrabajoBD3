USE Tarea3;
GO

DECLARE @RutaArchivoXML NVARCHAR(500) = N'C:\xmls\simulacionActu.xml';
DECLARE @SQL NVARCHAR(MAX);
DECLARE @XML XML;

SET @SQL = '
SELECT @X = TRY_CAST(BulkColumn AS XML)
FROM OPENROWSET(BULK ''' + @RutaArchivoXML + ''', SINGLE_BLOB) AS X;
';

EXEC sp_executesql
      @SQL,
      N'@X XML OUTPUT',
      @X = @XML OUTPUT;

IF @XML IS NULL
BEGIN
    PRINT 'ERROR: no se pudo cargar el XML.';
    RETURN;
END;

PRINT 'XML cargado correctamente.';


IF OBJECT_ID('tempdb..#Dias') IS NOT NULL DROP TABLE #Dias;

SELECT
    Dia.value('@fecha','date') AS FechaOperacion,
    Dia.query('.') AS NodoDia
INTO #Dias
FROM @XML.nodes('/Operaciones/FechaOperacion') AS T(Dia);


DECLARE @Fecha DATE, @Nodo XML;

WHILE EXISTS(SELECT 1 FROM #Dias)
BEGIN
    SELECT TOP 1
           @Fecha = FechaOperacion,
           @Nodo  = NodoDia
    FROM #Dias ORDER BY FechaOperacion;

    PRINT '--------------------------------------------------------';
    PRINT '--- INICIO operación del día ' + CONVERT(VARCHAR,@Fecha) + ' ---';


    INSERT INTO Propietario (ValorDocumentoIdentidad, Nombre, Email, Telefono)
    SELECT
        P.value('@valorDocumento','varchar(20)'),
        P.value('@nombre','nvarchar(128)'),
        P.value('@email','nvarchar(128)'),
        P.value('@telefono','varchar(20)')
    FROM @Nodo.nodes('FechaOperacion/Personas/Persona') AS T(P);


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
    FROM @Nodo.nodes('FechaOperacion/Propiedades/Propiedad') AS T(P);

    INSERT INTO PropietarioPropiedad (Idpropiertario, IdPropiedad, IdTipoAsociacion, FechaInicio)
    SELECT
        pr.Id,
        p.Id,
        Mov.value('@tipoAsociacionId','int'),
        @Fecha
    FROM @Nodo.nodes('FechaOperacion/PropiedadPersona/Movimiento') AS T(Mov)
    JOIN Propietario pr
         ON pr.ValorDocumentoIdentidad = Mov.value('@valorDocumento','varchar(20)')
    JOIN Propiedad p
         ON p.NumeroFinca = Mov.value('@numeroFinca','varchar(20)');


    INSERT INTO PXCC (IdPropiedad, IdCC, IdTipoAsociacion)
    SELECT
        p.Id,
        Mov.value('@idCC','int'),
        Mov.value('@tipoAsociacionId','int')
    FROM @Nodo.nodes('FechaOperacion/CCPropiedad/Movimiento') AS T(Mov)
    JOIN Propiedad p
         ON p.NumeroFinca = Mov.value('@numeroFinca','varchar(20)');


    ---------------------------------------------------------
    DECLARE @Lecturas TABLE (Med VARCHAR(20), Mov INT, Val DECIMAL(18,2));

    INSERT INTO @Lecturas
    SELECT
        L.value('@numeroMedidor','varchar(20)'),
        L.value('@tipoMovimientoId','int'),
        L.value('@valor','decimal(18,2)')
    FROM @Nodo.nodes('FechaOperacion/LecturasMedidor/Lectura') AS T(L);


    DECLARE @Med VARCHAR(20), @Tip INT, @Val DECIMAL(18,2), @Res INT;

    WHILE EXISTS(SELECT 1 FROM @Lecturas)
    BEGIN
        SELECT TOP 1 @Med = Med, @Tip = Mov, @Val = Val FROM @Lecturas;

        EXEC dbo.InsertarLectura
             @numeroMedidor      = @Med,
             @inIdTipoMovimiento = @Tip,
             @inValor            = @Val,
             @outResultCode      = @Res OUTPUT;

        PRINT 'LECTURA → ' + @Med + ' Tipo:' + CAST(@Tip AS VARCHAR)
            + ' Val:' + CAST(@Val AS VARCHAR)
            + ' Res:' + CAST(@Res AS VARCHAR);

        DELETE FROM @Lecturas WHERE Med=@Med AND Mov=@Tip AND Val=@Val;
    END;


    IF OBJECT_ID('tempdb..#TempPagos') IS NOT NULL DROP TABLE #TempPagos;

    CREATE TABLE #TempPagos(
        Finca VARCHAR(20),
        Medio INT,
        Ref VARCHAR(100)
    );

    INSERT INTO #TempPagos
    SELECT
        P.value('@numeroFinca','varchar(20)'),
        P.value('@tipoMedioPagoId','int'),
        P.value('@numeroReferencia','varchar(100)')
    FROM @Nodo.nodes('FechaOperacion/Pagos/Pago') AS T(P);

    DECLARE @F VARCHAR(20), @M INT, @R VARCHAR(100);

    WHILE EXISTS(SELECT 1 FROM #TempPagos)
    BEGIN
        SELECT TOP 1 @F = Finca, @M = Medio, @R = Ref
        FROM #TempPagos;

        PRINT 'PAGO → ' + @F + ' Medio:' + CAST(@M AS VARCHAR)
            + ' Ref:' + @R;

        EXEC dbo.sp_Pagar
             @inNumFinca        = @F,
             @inIdTipoMedioPago = @M,
             @FechaOperacion    = @Fecha;

        DELETE FROM #TempPagos WHERE Finca=@F AND Medio=@M AND Ref=@R;
    END;

    DECLARE @RF INT;

    EXEC dbo.sp_Facturar
         @FechaOperacion = @Fecha,
         @outResult      = @RF OUTPUT;

    PRINT 'FACTURACIÓN → ' + CAST(@RF AS VARCHAR);



    DECLARE @RC INT;

    EXEC dbo.sp_Facturar_Corte_Agua
         @FechaOperacion = @Fecha,
         @outResult      = @RC OUTPUT;

    PRINT 'CORTE AGUA → ' + CAST(@RC AS VARCHAR);


    DELETE FROM #Dias WHERE FechaOperacion=@Fecha;
END;

PRINT '--- FIN SIMULACIÓN COMPLETA ---';


