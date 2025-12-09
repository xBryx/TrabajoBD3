USE Tarea3;
GO

---se carga el xml
DECLARE @RutaArchivoXML NVARCHAR(500) = N'C:\xmls\simulacionActu.xml';
DECLARE @SQL NVARCHAR(MAX);
DECLARE @XML XML;

SET @SQL = '
SELECT @XML_OUT = TRY_CAST(BulkColumn AS XML)
FROM OPENROWSET(BULK ''' + @RutaArchivoXML + ''', SINGLE_BLOB) AS X;
';

EXEC sp_executesql
      @SQL,
      N'@XML_OUT XML OUTPUT',
      @XML_OUT = @XML OUTPUT;

IF @XML IS NULL
BEGIN
    PRINT 'ERROR: No se pudo cargar el XML';
    RETURN;
END;

PRINT 'XML cargado correctamente.';


-------------------------------------------------------------
-- extración de fechas de operación
-------------------------------------------------------------
DECLARE @Fecha DATE, @Nodo XML;

DECLARE curFechas CURSOR FOR
SELECT  
    X.value('@fecha','date') AS Fecha,
    X.query('.')             AS NodoDia
FROM @XML.nodes('/Operaciones/FechaOperacion') AS T(X);

OPEN curFechas;
FETCH NEXT FROM curFechas INTO @Fecha, @Nodo;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '------------------------------------------';
    PRINT '--- Procesando día ' + CONVERT(VARCHAR,@Fecha);
    PRINT '------------------------------------------';

    ---------------------------------------------------
    -- inserción de propietarios
    ---------------------------------------------------
    INSERT INTO Propietario (ValorDocumentoIdentidad, Nombre, Email, Telefono)
    SELECT
        P.value('@valorDocumento','varchar(20)'),
        P.value('@nombre','nvarchar(128)'),
        P.value('@email','nvarchar(20)'),
        P.value('@telefono','varchar(20)')
    FROM @Nodo.nodes('FechaOperacion/Personas/Persona') AS T(P);

    ---------------------------------------------------
    -- inserción de propiedades
    ---------------------------------------------------
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

    ---------------------------------------------------
    -- insercuón de relaciones PropietarioPropiedad

    INSERT INTO PropietarioPropiedad (Idpropiertario, IdPropiedad, IdTipoAsociacion, FechaInicio)
    SELECT
        pr.Id,
        p.Id,
        M.value('@tipoAsociacionId','int'),
        @Fecha
    FROM @Nodo.nodes('FechaOperacion/PropiedadPersona/Movimiento') AS T(M)
    INNER JOIN Propietario pr
        ON pr.ValorDocumentoIdentidad = M.value('@valorDocumento','varchar(20)')
    INNER JOIN Propiedad p
        ON p.NumeroFinca = M.value('@numeroFinca','varchar(20)');

    ---------------------------------------------------
    -- inserción de asociaciones PXCC
    ---------------------------------------------------
    INSERT INTO PXCC (IdPropiedad, IdCC, IdTipoAsociacion)
    SELECT
        p.Id,
        M.value('@idCC','int'),
        M.value('@tipoAsociacionId','int')
    FROM @Nodo.nodes('FechaOperacion/CCPropiedad/Movimiento') AS T(M)
    INNER JOIN Propiedad p
        ON p.NumeroFinca = M.value('@numeroFinca','varchar(20)');

    ---------------------------------------------------
    -- procesado de lecturas
    ---------------------------------------------------
    DECLARE @Medidor VARCHAR(20),
            @TipoMov INT,
            @Valor DECIMAL(18,2),
            @ResLect INT;

    DECLARE curLect CURSOR FOR
        SELECT
            L.value('@numeroMedidor','varchar(20)'),
            L.value('@tipoMovimientoId','int'),
            L.value('@valor','decimal(18,2)')
        FROM @Nodo.nodes('FechaOperacion/LecturasMedidor/Lectura') AS T(L);

    OPEN curLect;
    FETCH NEXT FROM curLect INTO @Medidor, @TipoMov, @Valor;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC InsertarLectura
            @numeroMedidor=@Medidor,
            @inIdTipoMovimiento=@TipoMov,
            @inValor=@Valor,
            @outResultCode=@ResLect OUTPUT;

        PRINT 'Lectura → ' + @Medidor + ' Resultado=' + CAST(@ResLect AS VARCHAR);

        FETCH NEXT FROM curLect INTO @Medidor, @TipoMov, @Valor;
    END

    CLOSE curLect;
    DEALLOCATE curLect;

    ---------------------------------------------------
    -- procesado de los pagos 
    ---------------------------------------------------
    DECLARE @Finca NVARCHAR(20), @Medio INT, @Ref VARCHAR(100);

    DECLARE curPag CURSOR FOR
        SELECT
            P.value('@numeroFinca','varchar(20)'),
            P.value('@tipoMedioPagoId','int'),
            P.value('@numeroReferencia','varchar(100)')
        FROM @Nodo.nodes('FechaOperacion/Pagos/Pago') AS T(P);

    OPEN curPag;
    FETCH NEXT FROM curPag INTO @Finca, @Medio, @Ref;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC sp_Pagar
            @inNumFinca=@Finca,
            @inIdTipoMedioPago=@Medio,
            @FechaOperacion=@Fecha;

        FETCH NEXT FROM curPag INTO @Finca, @Medio, @Ref;
    END

    CLOSE curPag;
    DEALLOCATE curPag;

    ---------------------------------------------------
    --generado de facturas
    ---------------------------------------------------
    DECLARE @ResFact INT;

    EXEC sp_Facturar
         @FechaOperacion=@Fecha,
         @outResult=@ResFact OUTPUT;

    PRINT 'Facturación → ' + CAST(@ResFact AS VARCHAR);

    ---------------------------------------------------
    -- generado de cortes de agua
    ---------------------------------------------------
    DECLARE @ResCorte INT;

    EXEC sp_Facturar_Corte_Agua
         @FechaOperacion=@Fecha,
         @outResult=@ResCorte OUTPUT;

    PRINT 'CorteAgua → ' + CAST(@ResCorte AS VARCHAR);

    ---------------------------------------------------
    PRINT '--- FIN del día ' + CONVERT(VARCHAR,@Fecha);
    ---------------------------------------------------

    FETCH NEXT FROM curFechas INTO @Fecha, @Nodo;
END

CLOSE curFechas;
DEALLOCATE curFechas;


