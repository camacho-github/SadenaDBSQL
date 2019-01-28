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

IF  EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('sdb.FNConvierteCadenaEnTablaEnteros'))
	DROP FUNCTION sdb.FNConvierteCadenaEnTablaEnteros
GO 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de una función para convertir una cadena divida por comas a una tabla
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE FUNCTION sdb.FNConvierteCadenaEnTablaEnteros (@lista VARCHAR(MAX))
   RETURNS @tbl TABLE (numero int NOT NULL) AS
BEGIN
   DECLARE @pos        int,
           @siguientepos    int,
           @largo   int

   SELECT @pos = 0, @siguientepos = 1

   IF(@lista IS NOT NULL)
	   WHILE @siguientepos > 0
	   BEGIN
		  SELECT @siguientepos = charindex(',', @lista, @pos + 1)
		  SELECT @largo = CASE WHEN @siguientepos > 0
								  THEN @siguientepos
								  ELSE len(@lista) + 1
							 END - @pos - 1
		  INSERT @tbl (numero)
			 VALUES (convert(int, substring(@lista, @pos + 1, @largo)))
		  SELECT @pos = @siguientepos
	   END
   RETURN
END