--Datos de prueba
USE Tarea3
go

---script para inserción de datos necesarios para la ejecución de procesos

---inserción de los tipos de lecturas 
INSERT INTO dbo.TipoMovimientoLecturaMedidor (Id, Nombre)
VALUES
(1, 'Lectura'),
(2, 'Ajuste Crédito'),
(3, 'Ajuste Débito');

INSERT INTO dbo.TipoUso(IdTipoUso, Nombre)---inserción de los tipos de uso
	VALUES
	(1, 'Habitación'),
	(2, 'Comercial'),
	(3, 'Industrial'),
	(4, 'Lote Baldío'),
	(5, 'Agrícola');

INSERT INTO dbo.TipoLocalizacion (IdTipoLocalizacion, Nombre) ---inserción de los tipos de localización 
VALUES
(1, 'Residencial'),
(2, 'Agrícola'),
(3, 'Bosque'),
(4, 'Industrial'),
(5, 'Comercial');

INSERT INTO dbo.TipoAsociacion (Id, Nombre)---inserción de los tipos de asociación 
VALUES
(1, 'Asociar'),
(2, 'Desasociar');

INSERT INTO dbo.TipoMedioPago (Id, Nombre)---inserción de los tipos de medios de pago 
VALUES
( 1, 'Efectivo'),
(2, 'Tarjeta');

INSERT INTO dbo.PeriodoMontoCC (Id, Nombre, QMeses, Dias) ---inserción de los periodos de monto para el concepto de cobro
VALUES
(1, 'Mensual', 1, NULL),
(2, 'Trimestral', 3, NULL),
(3, 'Semestral', 6, NULL),
(4, 'Anual', 12, NULL),
(5, 'Único', 1, NULL),
(6, 'Interés Diario', 1, 30);  

INSERT INTO dbo.TipoMontoCC (Id, Nombre) ---inserción de los tipos monto para los conceptos de cobro
VALUES
(1, 'Monto Fijo'),
(2, 'Monto Variable'),
(3, 'Porcentaje');

INSERT INTO dbo.CC   ---inserción de los conceptos de cobro ultimo de catalogo
(
      Id
    , Nombre
    , IdTipoMontoCC
    , IdPeriodoMontoCC
    , ValorMinimo
    , ValorMinimoM3
    , ValorFijoM3Adicional
    , ValorPorcentual
    , ValorFijo
    , ValorM2Minimo
    , ValorTramosM2
)
VALUES
(1, 'ConsumoAgua', 
    2, 1, 
    5000, 30, 1000, 
    NULL, NULL, NULL, NULL),

(2, 'PatenteComercial', 
    1, 3, 
    NULL, NULL, NULL, 
    NULL, 150000, NULL, NULL),

(3, 'ImpuestoPropiedad', 
    3, 4, 
    NULL, NULL, NULL, 
    0.01, NULL, NULL, NULL),

(4, 'RecoleccionBasura', 
    1, 1, 
    150, NULL, NULL, 
    NULL, 300, 400, 75),

(5, 'MantenimientoParques', 
    1, 1, 
    NULL, NULL, NULL, 
    NULL, 2000, NULL, NULL),

(6, 'ReconexionAgua', 
    1, 5, 
    NULL, NULL, NULL, 
    NULL, 30000, NULL, NULL),

(7, 'InteresesMoratorios', 
    3, 6, 
    NULL, NULL, NULL, 
    0.04, NULL, NULL, NULL);

---inserción de usuarios
INSERT INTO dbo.TipoUsuario(Id, Nombre)
	VALUES (1, 'Admin')

INSERT INTO dbo.Usuario( IdTipoUsuario, Nombre, Contraseña)
	VALUES( 1, 'Administrador', 'SoyAdmin')


---operaciones del dia 2025-06-01 
DECLARE @out INT;

---se ejecuta sp de inserción de propietarios en total 30
EXEC InsertarPropietario 'Valeria Solano','10000001','p01@ejemplo.org','8001-0001',@out OUTPUT;
EXEC InsertarPropietario 'José Miguel Rodríguez','10000002','p02@ejemplo.org','8002-0002',@out OUTPUT;
EXEC InsertarPropietario 'Andrea Vargas','10000003','p03@ejemplo.org','8003-0003',@out OUTPUT;
EXEC InsertarPropietario 'Daniel Méndez','10000004','p04@ejemplo.org','8004-0004',@out OUTPUT;
EXEC InsertarPropietario 'María Fernanda Sánchez','10000005','p05@ejemplo.org','8005-0005',@out OUTPUT;
EXEC InsertarPropietario 'Luis Diego Araya','10000006','p06@ejemplo.org','8006-0006',@out OUTPUT;
EXEC InsertarPropietario 'Sofía Morales','10000007','p07@ejemplo.org','8007-0007',@out OUTPUT;
EXEC InsertarPropietario 'Alejandro Navarro','10000008','p08@ejemplo.org','8008-0008',@out OUTPUT;
EXEC InsertarPropietario 'Carolina Pérez','10000009','p09@ejemplo.org','8009-0009',@out OUTPUT;
EXEC InsertarPropietario 'Ricardo Castro','10000010','p10@ejemplo.org','8010-0010',@out OUTPUT;
EXEC InsertarPropietario 'Natalia Salazar','10000011','p11@ejemplo.org','8011-0011',@out OUTPUT;
EXEC InsertarPropietario 'Gabriel Hernández','10000012','p12@ejemplo.org','8012-0012',@out OUTPUT;
EXEC InsertarPropietario 'Paola Rojas','10000013','p13@ejemplo.org','8013-0013',@out OUTPUT;
EXEC InsertarPropietario 'Esteban Calderón','10000014','p14@ejemplo.org','8014-0014',@out OUTPUT;
EXEC InsertarPropietario 'Laura Jiménez','10000015','p15@ejemplo.org','8015-0015',@out OUTPUT;
EXEC InsertarPropietario 'Kevin López','10000016','p16@ejemplo.org','8016-0016',@out OUTPUT;
EXEC InsertarPropietario 'Adriana Cordero','10000017','p17@ejemplo.org','8017-0017',@out OUTPUT;
EXEC InsertarPropietario 'Mauricio Rojas','10000018','p18@ejemplo.org','8018-0018',@out OUTPUT;
EXEC InsertarPropietario 'Daniela Alfaro','10000019','p19@ejemplo.org','8019-0019',@out OUTPUT;
EXEC InsertarPropietario 'Ignacio Chaves','10000020','p20@ejemplo.org','8020-0020',@out OUTPUT;
EXEC InsertarPropietario 'Karina Gutiérrez','10000021','p21@ejemplo.org','8021-0021',@out OUTPUT;
EXEC InsertarPropietario 'Diego Porras','10000022','p22@ejemplo.org','8022-0022',@out OUTPUT;
EXEC InsertarPropietario 'Juliana Villalobos','10000023','p23@ejemplo.org','8023-0023',@out OUTPUT;
EXEC InsertarPropietario 'Marco Antonio Mora','10000024','p24@ejemplo.org','8024-0024',@out OUTPUT;
EXEC InsertarPropietario 'Ximena Sánchez','10000025','p25@ejemplo.org','8025-0025',@out OUTPUT;
EXEC InsertarPropietario 'Cristian Valverde','10000026','p26@ejemplo.org','8026-0026',@out OUTPUT;
EXEC InsertarPropietario 'Rebeca Bonilla','10000027','p27@ejemplo.org','8027-0027',@out OUTPUT;
EXEC InsertarPropietario 'Sebastián Madriz','10000028','p28@ejemplo.org','8028-0028',@out OUTPUT;
EXEC InsertarPropietario 'Pamela Hidalgo','10000029','p29@ejemplo.org','8029-0029',@out OUTPUT;
EXEC InsertarPropietario 'Fabián Arias','10000030','p30@ejemplo.org','8030-0030',@out OUTPUT;

---- inserció de propiedades por medio de sp insertarpropiedades
EXEC SP_InsertarPropiedades 'F-0001',21500000,0,'2025-06-02',1,1,'M-1001';
EXEC SP_InsertarPropiedades 'F-0002',23000000,0,'2025-06-03',2,1,'M-1002';
EXEC SP_InsertarPropiedades 'F-0003',24500000,0,'2025-06-05',3,4,'M-1003';
EXEC SP_InsertarPropiedades 'F-0004',26000000,0,'2025-06-07',1,1,'M-1004';
EXEC SP_InsertarPropiedades 'F-0005',27500000,0,'2025-06-09',2,5,'M-1005';
EXEC SP_InsertarPropiedades 'F-0006',29000000,0,'2025-06-10',1,1,'M-1006';
EXEC SP_InsertarPropiedades 'F-0007',30500000,0,'2025-06-12',2,1,'M-1007';
EXEC SP_InsertarPropiedades 'F-0008',32000000,0,'2025-06-14',3,4,'M-1008';
EXEC SP_InsertarPropiedades 'F-0009',33500000,0,'2025-06-16',1,1,'M-1009';
EXEC SP_InsertarPropiedades 'F-0010',35000000,0,'2025-06-18',4,3,'M-1010';
EXEC SP_InsertarPropiedades 'F-0011',36500000,0,'2025-06-20',4,1,'M-1011';
EXEC SP_InsertarPropiedades 'F-0012',38000000,0,'2025-06-21',4,5,'M-1012';
EXEC SP_InsertarPropiedades 'F-0013',39500000,0,'2025-06-23',2,5,'M-1013';
EXEC SP_InsertarPropiedades 'F-0014',41000000,0,'2025-06-26',1,1,'M-1014';
EXEC SP_InsertarPropiedades 'F-0015',42500000,0,'2025-06-28',5,2,'M-1015';


--- se ejecuta la asoción correspondiente al dia 

DECLARE @res INT;

EXEC SP_Asociar '2025-06-01','10000001','F-0001',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000002','F-0001',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000003','F-0001',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000004','F-0002',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000005','F-0003',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000006','F-0003',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000007','F-0004',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000008','F-0004',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000009','F-0004',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000010','F-0004',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000011','F-0005',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000012','F-0006',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000013','F-0006',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000014','F-0007',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000015','F-0007',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000016','F-0007',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000017','F-0008',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000018','F-0009',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000019','F-0009',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000020','F-0010',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000021','F-0011',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000022','F-0011',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000023','F-0011',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000024','F-0011',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000025','F-0012',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000026','F-0013',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000027','F-0013',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000028','F-0013',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000029','F-0014',1,@res OUTPUT;
EXEC SP_Asociar '2025-06-01','10000030','F-0015',1,@res OUTPUT;

---inserción de pxcc o propiedad concepto de pago

DECLARE @rc INT;

EXEC InsertarPXCC 'F-0002',4,1,@rc OUTPUT;
EXEC InsertarPXCC 'F-0005',4,1,@rc OUTPUT;
EXEC InsertarPXCC 'F-0007',4,1,@rc OUTPUT;
EXEC InsertarPXCC 'F-0010',4,1,@rc OUTPUT;
EXEC InsertarPXCC 'F-0013',4,1,@rc OUTPUT;

---fin operación del dia 2025-06-01

---inicio operación del 2025-07-02

DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor='M-1001',     -- M-1004 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor = 108.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;

-- FACTURACIÓN del día

DECLARE @res2 INT;---variable de salida
EXEC sp_Facturar 
	@FechaOperacion ='2025-07-02',
	@outResult= @res2 OUTPUT;
SELECT Resultado = @res2;---codigo de salida

DECLARE @res3 INT;---variable de salida

-- CORTE DE AGUA del día
EXEC dbo.sp_Facturar_Corte_Agua
        @FechaOperacion = '2025-07-02',
        @outResult      = @res3 OUTPUT;

SELECT Resultado = @res3;---codigo de salida
---fin operación del dia 2025-07-02


---inicio operación del dia 2025-07-03
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1002',    -- M-1004 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor = 116.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;
-- FACTURACIÓN del día

DECLARE @res2 INT;---variable de salida
EXEC sp_Facturar 
	@FechaOperacion ='2025-07-03',
	@outResult= @res2 OUTPUT;
SELECT Resultado = @res2;---codigo de salida

DECLARE @res3 INT;---variable de salida

-- CORTE DE AGUA del día
EXEC dbo.sp_Facturar_Corte_Agua
        @FechaOperacion = '2025-07-03',
        @outResult      = @res3 OUTPUT;

SELECT Resultado = @res3;---codigo de salida
---fin operación del dia 2025-07-03


---inicio operación del dia 2025-07-05
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1003',    -- M-1004 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor = 119.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;

-- FACTURACIÓN del día

DECLARE @res2 INT;---variable de salida
EXEC sp_Facturar 
	@FechaOperacion ='2025-07-05',
	@outResult= @res2 OUTPUT;
SELECT Resultado = @res2;---codigo de salida

DECLARE @res3 INT;---variable de salida

-- CORTE DE AGUA del día
EXEC dbo.sp_Facturar_Corte_Agua
        @FechaOperacion = '2025-07-05',
        @outResult      = @res3 OUTPUT;

SELECT Resultado = @res3;---codigo de salida
---fin operación del dia 2025-07-05

---inicio operación del dia 2025-07-07
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1004',     -- M-1004 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor = 127.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;

-- FACTURACIÓN del día

DECLARE @res2 INT;---variable de salida
EXEC sp_Facturar 
	@FechaOperacion ='2025-07-07',
	@outResult= @res2 OUTPUT;
SELECT Resultado = @res2;---codigo de salida

DECLARE @res3 INT;---variable de salida

-- CORTE DE AGUA del día
EXEC dbo.sp_Facturar_Corte_Agua
        @FechaOperacion = '2025-07-07',
        @outResult      = @res3 OUTPUT;

SELECT Resultado = @res3;---codigo de salida
---fin operación del dia 2025-07-07


---inicio operación del dia 2025-07-09
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1005',     -- M-1004 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =135.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;

-- FACTURACIÓN del día

DECLARE @res2 INT;---variable de salida
EXEC sp_Facturar 
	@FechaOperacion ='2025-07-09',
	@outResult= @res2 OUTPUT;
SELECT Resultado = @res2;---codigo de salida

DECLARE @res3 INT;---variable de salida

-- CORTE DE AGUA del día
EXEC dbo.sp_Facturar_Corte_Agua
        @FechaOperacion = '2025-07-09',
        @outResult      = @res3 OUTPUT;

SELECT Resultado = @res3;---codigo de salida
---fin operación del dia 2025-07-09


---inicio operación del dia 2025-07-10
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1006',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =143.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;


DECLARE @resp INT;

EXEC dbo.InsertarLectura
     @NumeroMedidor   = 'M-1004',
     @inIdTipoMovimiento = 2,     -- Ajuste crédito
     @inValor            = 3,     -- Resta 3 m³
     @outResultCode      = @resp OUTPUT;

SELECT ResultadoLectura = @resp;


-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-07-10',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-07-10',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;


---fin operación del dia 2025-07-10


---inicio operación del dia 2025-07-12
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1007',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =151.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;


-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-07-12',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-07-12',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;

---fin operación del dia 2025-07-12



---inicio operación del dia 2025-07-14
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1008',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =154.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;


-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-07-14',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-07-14',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;

---fin operación del dia 2025-07-14


---------------------------------------------
-----Inicio operación del dia 2025-07-15 ----
---------------------------------------------

-- FACTURACIÓN del día pasa antes por logica de facturar por orden de prioridad
DECLARE @resFACT INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-07-15',
     @outResult      = @resFACT OUTPUT;

SELECT ResultadoFacturar = @resFACT;


-- CORTE DE AGUA del día cortes realizados antes por orden de prioridad
DECLARE @resCorte INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-07-15',
     @outResult      = @resCorte OUTPUT;

SELECT ResultadoCorte = @resCorte;

EXEC dbo.sp_Pagar
     @inNumFinca      = 'F-0001',
     @inIdTipoMedioPago  = 2,
     @FechaOperacion     = '2025-07-15'


EXEC dbo.sp_Pagar
     @inNumFinca      = 'F-0002',
     @inIdTipoMedioPago  = 2,
     @FechaOperacion     = '2025-07-15'


EXEC dbo.sp_Pagar
     @inNumFinca      = 'F-0004',
     @inIdTipoMedioPago  = 2,
     @FechaOperacion     = '2025-07-15'


EXEC dbo.sp_Pagar
     @inNumFinca      = 'F-0005',
     @inIdTipoMedioPago  = 2,
     @FechaOperacion     = '2025-07-15'



EXEC dbo.sp_Pagar
     @inNumFinca      = 'F-0006',
     @inIdTipoMedioPago  = 2,
     @FechaOperacion     = '2025-07-15'




EXEC dbo.sp_Pagar
     @inNumFinca      = 'F-0008',
     @inIdTipoMedioPago  = 2,
     @FechaOperacion     = '2025-07-15'

---------------------------------------------
-----FIN operación del dia 2025-07-15 -------
---------------------------------------------



---inicio operación del dia 2025-07-16
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1009',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =162.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;


-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-07-16',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-07-16',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;

---fin operación del dia 2025-07-16

---inicio operación del dia 2025-07-18
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1010',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =170.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;


-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-07-18',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-07-18',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;

---fin operación del dia 2025-07-18


---inicio operación del dia 2025-07-20
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1011',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =178.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;


-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-07-20',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-07-20',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;

---fin operación del dia 2025-07-20

---inicio operación del dia 2025-07-21
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1012',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =186.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;


-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-07-21',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-07-21',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;

---fin operación del dia 2025-07-21

---inicio operación del dia 2025-07-23
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1013',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =189.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;


-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-07-23',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-07-23',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;

---fin operación del dia 2025-07-23

---inicio operación del dia 2025-07-26
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1014',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =197.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;


-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-07-26',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-07-26',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;

---fin operación del dia 2025-07-26

---inicio operación del dia 2025-07-28
DECLARE @res INT;

EXEC dbo.InsertarLectura
     @numeroMedidor = 'M-1015',     -- M-1006 Numero de medidor para buscar implicito
     @inIdTipoMovimiento = 1,      
     @inValor =205.0,
     @outResultCode = @res OUTPUT;

SELECT Resultado = @res;

-- FACTURACIÓN del día
DECLARE @res2 INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-07-28',
     @outResult      = @res2 OUTPUT;

SELECT ResultadoFacturar = @res2;


-- CORTE DE AGUA del día
DECLARE @res3 INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-07-28',
     @outResult      = @res3 OUTPUT;

SELECT ResultadoCorte = @res3;

---fin operación del dia 2025-07-28

---------------------------------------------
-----Inicio operación del dia 2025-07-30 ----
---------------------------------------------

-- FACTURACIÓN del día (si corresponde según fecha de registro)
DECLARE @resFACT INT;

EXEC dbo.sp_Facturar
     @FechaOperacion = '2025-07-30',
     @outResult      = @resFACT OUTPUT;

SELECT ResultadoFacturar = @resFACT;


-- CORTE DE AGUA del día (antes de pagos)
DECLARE @resCorte INT;

EXEC dbo.sp_Facturar_Corte_Agua
     @FechaOperacion = '2025-07-30',
     @outResult      = @resCorte OUTPUT;

SELECT ResultadoCorte = @resCorte;

---pagos del dia

EXEC dbo.sp_Pagar
     @inNumFinca         = 'F-0009',
     @inIdTipoMedioPago  = 2,
     @FechaOperacion     = '2025-07-30';


EXEC dbo.sp_Pagar
     @inNumFinca         = 'F-0010',
     @inIdTipoMedioPago  = 2,
     @FechaOperacion     = '2025-07-30';


EXEC dbo.sp_Pagar
     @inNumFinca         = 'F-0012',
     @inIdTipoMedioPago  = 2,
     @FechaOperacion     = '2025-07-30';


EXEC dbo.sp_Pagar
     @inNumFinca         = 'F-0013',
     @inIdTipoMedioPago  = 2,
     @FechaOperacion     = '2025-07-30';


EXEC dbo.sp_Pagar
     @inNumFinca         = 'F-0015',
     @inIdTipoMedioPago  = 2,
     @FechaOperacion     = '2025-07-30';


---------------------------------------------
-----FIN operación del dia 2025-07-30 -------
---------------------------------------------
