use Tarea3
go


---inicio operación del 2025-08-02

DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor='M-1001',     -- M-1004 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor = 118.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;

-- FACTURACIÓN del día

DECLARE @res2 INT;---variable de salida
EXEC sp_Facturar 
	@FechaOperacion ='2025-08-02',
	@outResult= @res2 OUTPUT;
SELECT Resultado = @res2;---codigo de salida

DECLARE @res3 INT;---variable de salida

-- CORTE DE AGUA del día
EXEC dbo.sp_Facturar_Corte_Agua
        @FechaOperacion = '2025-08-02',
        @outResult      = @res3 OUTPUT;

SELECT Resultado = @res3;---codigo de salida
---fin operación del dia 2025-08-02


---inicio operación del dia 2025-08-03
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1002',    -- M-1004 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor = 128.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;
-- FACTURACIÓN del día

DECLARE @res2 INT;---variable de salida
EXEC sp_Facturar 
	@FechaOperacion ='2025-08-03',
	@outResult= @res2 OUTPUT;
SELECT Resultado = @res2;---codigo de salida

DECLARE @res3 INT;---variable de salida

-- CORTE DE AGUA del día
EXEC dbo.sp_Facturar_Corte_Agua
        @FechaOperacion = '2025-08-03',
        @outResult      = @res3 OUTPUT;

SELECT Resultado = @res3;---codigo de salida
---fin operación del dia 2025-08-03


---inicio operación del dia 2025-08-05
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1003',    -- M-1004 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor = 133.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;

-- FACTURACIÓN del día

DECLARE @res2 INT;---variable de salida
EXEC sp_Facturar 
	@FechaOperacion ='2025-08-05',
	@outResult= @res2 OUTPUT;
SELECT Resultado = @res2;---codigo de salida

DECLARE @res3 INT;---variable de salida

-- CORTE DE AGUA del día
EXEC dbo.sp_Facturar_Corte_Agua
        @FechaOperacion = '2025-08-05',
        @outResult      = @res3 OUTPUT;

SELECT Resultado = @res3;---codigo de salida
---fin operación del dia 2025-08-05

---inicio operación del dia 2025-08-07
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1004',     -- M-1004 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor = 143.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;

-- FACTURACIÓN del día

DECLARE @res2 INT;---variable de salida
EXEC sp_Facturar 
	@FechaOperacion ='2025-08-07',
	@outResult= @res2 OUTPUT;
SELECT Resultado = @res2;---codigo de salida

DECLARE @res3 INT;---variable de salida

-- CORTE DE AGUA del día
EXEC dbo.sp_Facturar_Corte_Agua
        @FechaOperacion = '2025-08-07',
        @outResult      = @res3 OUTPUT;

SELECT Resultado = @res3;---codigo de salida
---fin operación del dia 2025-08-07


---inicio operación del dia 2025-08-09
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1005',     -- M-1004 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =146.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;

-- FACTURACIÓN del día

DECLARE @res2 INT;---variable de salida
EXEC sp_Facturar 
	@FechaOperacion ='2025-08-09',
	@outResult= @res2 OUTPUT;
SELECT Resultado = @res2;---codigo de salida

DECLARE @res3 INT;---variable de salida

-- CORTE DE AGUA del día
EXEC dbo.sp_Facturar_Corte_Agua
        @FechaOperacion = '2025-08-09',
        @outResult      = @res3 OUTPUT;

SELECT Resultado = @res3;---codigo de salida
---fin operación del dia 2025-08-09


---inicio operación del dia 2025-08-10
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1006',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =156.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;

-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-08-10',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-08-10',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;


---fin operación del dia 2025-08-10


---inicio operación del dia 2025-08-12
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1007',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =166.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;


-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-08-12',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-08-12',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;

---fin operación del dia 2025-08-12



---inicio operación del dia 2025-08-14
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1008',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =164.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;


-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-08-14',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-08-14',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;

---fin operación del dia 2025-08-14


---------------------------------------------
-----Inicio operación del dia 2025-08-15 ----
---------------------------------------------

-- FACTURACIÓN del día pasa antes por logica de facturar por orden de prioridad
DECLARE @resFACT INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-08-15',
     @outResult      = @resFACT OUTPUT;

SELECT ResultadoFacturar = @resFACT;


-- CORTE DE AGUA del día cortes realizados antes por orden de prioridad
DECLARE @resCorte INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-08-15',
     @outResult      = @resCorte OUTPUT;

SELECT ResultadoCorte = @resCorte;

EXEC dbo.sp_Pagar
     @inNumFinca      = 'F-0001',
     @inIdTipoMedioPago  = 1,
     @FechaOperacion     = '2025-08-15'


EXEC dbo.sp_Pagar
     @inNumFinca      = 'F-0002',
     @inIdTipoMedioPago  = 1,
     @FechaOperacion     = '2025-08-15'


EXEC dbo.sp_Pagar
     @inNumFinca      = 'F-0004',
     @inIdTipoMedioPago  = 1,
     @FechaOperacion     = '2025-08-15'


EXEC dbo.sp_Pagar
     @inNumFinca      = 'F-0005',
     @inIdTipoMedioPago  = 1,
     @FechaOperacion     = '2025-08-15'



EXEC dbo.sp_Pagar
     @inNumFinca      = 'F-0006',
     @inIdTipoMedioPago  = 1,
     @FechaOperacion     = '2025-08-15'




EXEC dbo.sp_Pagar
     @inNumFinca      = 'F-0008',
     @inIdTipoMedioPago  = 1,
     @FechaOperacion     = '2025-08-15'

---------------------------------------------
-----FIN operación del dia 2025-08-15 -------
---------------------------------------------



---inicio operación del dia 2025-08-16
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1009',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =174.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;


-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-08-16',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-08-16',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;

---fin operación del dia 2025-08-16

---inicio operación del dia 2025-08-18
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1010',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =184.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;


-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-08-18',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-08-18',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;

---fin operación del dia 2025-08-18


---inicio operación del dia 2025-08-20
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1011',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =194.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;


-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-08-20',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-08-20',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;

---fin operación del dia 2025-08-20

---inicio operación del dia 2025-08-21
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1012',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =197.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;


-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-08-21',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-08-21',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;

---fin operación del dia 2025-08-21

---inicio operación del dia 2025-08-23
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1013',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =202.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;


-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-08-23',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-08-23',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;

---fin operación del dia 2025-08-23

---inicio operación del dia 2025-08-26
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1014',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =212.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;


-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-08-26',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-08-26',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;

---fin operación del dia 2025-08-26

---inicio operación del dia 2025-08-28
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1015',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =215.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;

-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-08-28',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-08-28',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;

---fin operación del dia 2025-08-28

---------------------------------------------
-----Inicio operación del dia 2025-07-30 ----
---------------------------------------------

-- FACTURACIÓN del día (si corresponde según fecha de registro)
DECLARE @resFACT INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-08-30',
     @outResult      = @resFACT OUTPUT;

SELECT ResultadoFacturar = @resFACT;


-- CORTE DE AGUA del día (antes de pagos)
DECLARE @resCorte INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-08-30',
     @outResult      = @resCorte OUTPUT;

SELECT ResultadoCorte = @resCorte;

---pagos del dia

EXEC dbo.sp_Pagar
     @inNumFinca         = 'F-0009',
     @inIdTipoMedioPago  = 1,
     @FechaOperacion     = '2025-08-30';


EXEC dbo.sp_Pagar
     @inNumFinca         = 'F-0010',
     @inIdTipoMedioPago  = 1,
     @FechaOperacion     = '2025-08-30';


EXEC dbo.sp_Pagar
     @inNumFinca         = 'F-0012',
     @inIdTipoMedioPago  = 1,
     @FechaOperacion     = '2025-08-30';


EXEC dbo.sp_Pagar
     @inNumFinca         = 'F-0013',
     @inIdTipoMedioPago  = 1,
     @FechaOperacion     = '2025-08-30';


EXEC dbo.sp_Pagar
     @inNumFinca         = 'F-0015',
     @inIdTipoMedioPago  = 1,
     @FechaOperacion     = '2025-08-30';


---------------------------------------------
-----FIN operación del dia 2025-07-30 -------
----------------------------