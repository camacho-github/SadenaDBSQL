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
GO

IF  EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('sdb.FNObtieneTablaSubregistro'))
	DROP FUNCTION sdb.FNObtieneTablaSubregistro
GO 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de una función para crear la tabla de combinaciones de  subregistros de nacimientos
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE FUNCTION sdb.FNObtieneTablaSubregistro(  
@pc_anos VARCHAR(255),
@pc_meses VARCHAR(255),
@pc_municipios VARCHAR(400))

RETURNS @vtRegistros TABLE(
	fi_id_renglon   INT NOT NULL IDENTITY(1,1),
	fc_folio_certificado varchar(20) NOT NULL,
	fc_folio_simple_certificado varchar(20) NOT NULL,
	fd_rn_fecha_hora_nacimiento datetime,	
	fi_rn_sexo_id int,
	fi_rn_edo_id int,
	fi_rn_mpio_id int,
	fi_ma_dom_edo_id int NOT NULL,
	fi_ma_dom_mpio_id int NOT NULL,
	fi_ma_dom_loc_id int NOT NULL,
	fc_ma_dom_calle varchar(80) NOT NULL,
	fc_ma_dom_numext varchar(20),
	fc_ma_dom_numint varchar(20),		
	fi_ma_edad int NOT NULL,
	fi_ma_num_nacimiento int NOT NULL,
	fc_ma_ocupacion varchar(60) NOT NULL,
	fi_ma_edo_civil_id int NOT NULL,
	fi_ma_escol_id int NOT NULL,
	fc_folio_simple_certificado_sic varchar(20),
	fd_rn_fecha_hora_nacimiento_sic datetime,
	fd_rn_fecha_registro_sic datetime, 
	fi_edo_id_sic int,
	fi_mpio_id_sic int,
	fi_estatus_registro_id int NOT NULL,
	fi_estatus_duplicado_sic int NOT NULL
	)

AS 
BEGIN	
	DECLARE 
	@CONST_SUBREGISTRO_ID INT = 1,
	@CONST_OPORTUNO_ID INT = 2,
	@CONST_EXTEMPORANEO_ID INT = 3,
	@CONST_DUPLICADO_ID INT = 4,
	@CONST_COAHUILA_EDO_ID INT = 5

	-- Inserta todos los registros del sinac, sin subregistro 

INSERT @vtRegistros(
	fc_folio_certificado,
	fc_folio_simple_certificado,
	fd_rn_fecha_hora_nacimiento,	
	fi_rn_sexo_id,
	fi_rn_edo_id,
	fi_rn_mpio_id,
	fi_ma_dom_edo_id,
	fi_ma_dom_mpio_id,
	fi_ma_dom_loc_id,
	fc_ma_dom_calle,
	fc_ma_dom_numext,
	fc_ma_dom_numint,		
	fi_ma_edad,
	fi_ma_num_nacimiento,
	fc_ma_ocupacion,
	fi_ma_edo_civil_id,
	fi_ma_escol_id,
	fc_folio_simple_certificado_sic,
	fd_rn_fecha_hora_nacimiento_sic,
	fd_rn_fecha_registro_sic, 
	fi_edo_id_sic,
	fi_mpio_id_sic,
	fi_estatus_registro_id,
	fi_estatus_duplicado_sic)
	SELECT 
	sinac.fc_folio_certificado,
	sinac.fc_folio_simple_certificado,
	sinac.fd_rn_fecha_hora_nacimiento,	
	sinac.fi_rn_sexo_id,
	sinac.fi_rn_edo_id,
	sinac.fi_rn_mpio_id,
	sinac.fi_ma_dom_edo_id,
	sinac.fi_ma_dom_mpio_id,
	sinac.fi_ma_dom_loc_id,
	sinac.fc_ma_dom_calle,
	sinac.fc_ma_dom_numext,
	sinac.fc_ma_dom_numint,		
	sinac.fi_ma_edad,
	sinac.fi_ma_num_nacimiento,
	sinac.fc_ma_ocupacion,
	sinac.fi_ma_edo_civil_id,
	sinac.fi_ma_escol_id,
	sic.fc_folio_simple_certificado,
	sic.fd_rn_fecha_hora_nacimiento,
	sic.fd_rn_fecha_registro, 
	sic.fi_edo_id,
	sic.fi_mpio_id,	
	@CONST_SUBREGISTRO_ID,
	ISNULL(sic.fi_estatus_duplicado, 0)
	FROM sdb.tasinac sinac
	LEFT JOIN SDB.tasic sic
	ON sinac.fc_folio_simple_certificado = sic.fc_folio_simple_certificado
	and len(sinac.fc_folio_simple_certificado) > 1
	WHERE 
	(@pc_anos IS NULL OR (@pc_anos IS NOT NULL AND YEAR(sinac.fd_rn_fecha_hora_nacimiento) IN (SELECT A.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_anos) A)))
	AND (@pc_meses IS NULL OR (@pc_meses IS NOT NULL AND MONTH(sinac.fd_rn_fecha_hora_nacimiento) IN (SELECT M.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_meses) M)))
	AND (@pc_municipios IS NULL OR (sinac.fi_rn_edo_id = @CONST_COAHUILA_EDO_ID AND SINAC.fi_rn_mpio_id IN(SELECT Mun.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_municipios) Mun)))
	
	UPDATE @vtRegistros
	SET fi_estatus_registro_id = @CONST_DUPLICADO_ID
	WHERE fc_folio_simple_certificado = fc_folio_simple_certificado_sic
	AND fi_estatus_duplicado_sic = 1	
		
	UPDATE @vtRegistros
	SET fi_estatus_registro_id = @CONST_OPORTUNO_ID
	WHERE fc_folio_simple_certificado = fc_folio_simple_certificado_sic
	AND fi_estatus_registro_id = 1
	AND fd_rn_fecha_registro_sic <= DATEADD(day,+60,fd_rn_fecha_hora_nacimiento)

	UPDATE @vtRegistros
	SET fi_estatus_registro_id = @CONST_EXTEMPORANEO_ID
	WHERE fd_rn_fecha_hora_nacimiento = fd_rn_fecha_hora_nacimiento_sic
	AND fi_rn_edo_id = fi_edo_id_sic and fi_rn_mpio_id = fi_mpio_id_sic
	AND fi_estatus_registro_id = 1
	AND fd_rn_fecha_registro_sic > DATEADD(day,+60,fd_rn_fecha_hora_nacimiento)

	RETURN 
END 
GO