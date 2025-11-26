CREATE TRIGGER trg_AsociarCCPropiedad
ON dbo.Propiedad
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO PXCC(IdPropiedad, IdCC, IdTipoAsociacion)
    SELECT i.id, 3, 1  -- Asumo IdTipoAsociacion = 1 por default
    FROM inserted i;

    -- Consumo de agua
    INSERT INTO PXCC(IdPropiedad, IdCC, IdTipoAsociacion)
    SELECT i.id, 1, 1
    FROM inserted i
    WHERE i.TipoUsoId IN (1,2,3);

    -- Recolección de basura
    INSERT INTO PXCC(IdPropiedad, IdCC, IdTipoAsociacion)
    SELECT i.id, 4, 1
    FROM inserted i
    WHERE i.TipoLocalizacionId <> 2;

    -- Mantenimiento de parques
    INSERT INTO PXCC(IdPropiedad, IdCC, IdTipoAsociacion)
    SELECT i.id, 5, 1
    FROM inserted i
    WHERE i.TipoLocalizacionId IN (1,5);
END;
GO
