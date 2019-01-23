use SADENADB
go

IF  EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('sdb.FNConvierteNumero'))
	DROP FUNCTION sdb.FNConvierteNumero
GO 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de una función para eliminar caracteres de un número
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE FUNCTION sdb.FNConvierteNumero
(@strAlphaNumeric VARCHAR(256))
RETURNS VARCHAR(256)
AS
BEGIN
DECLARE @intAlpha INT
SET @intAlpha = PATINDEX('%[^0-9]%', @strAlphaNumeric)
BEGIN
WHILE @intAlpha > 0
BEGIN
SET @strAlphaNumeric = STUFF(@strAlphaNumeric, @intAlpha, 1, '' )
SET @intAlpha = PATINDEX('%[^0-9]%', @strAlphaNumeric )
END
END
RETURN ISNULL(@strAlphaNumeric,0)
END
GO
