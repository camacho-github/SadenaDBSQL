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
 fi_estatus_duplicado_sic int NOT NULL,
 fi_numero_registros int  
 )  
  
AS   
BEGIN   
 DECLARE   
 @CONST_SUBREGISTRO_ID INT = 1,  
 @CONST_OPORTUNO_ID INT = 2,  
 @CONST_EXTEMPORANEO_ID INT = 3,  
 @CONST_DUPLICADO_ID INT = 4,  
 @CONST_COAHUILA_EDO_ID INT = 5, 
 @vi_parametro_ext INT;
  
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
 fi_estatus_duplicado_sic,
 fi_numero_registros)  
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
 ISNULL(sic.fi_estatus_duplicado, 0),  
 ROW_NUMBER() over (partition by sinac.fc_folio_certificado, sinac.fd_rn_fecha_hora_nacimiento,sic.fi_estatus_duplicado
 order by sinac.fc_folio_certificado,  sic.fi_estatus_duplicado) RowNumber 
 FROM sdb.tasinac sinac  with(nolock)
 LEFT OUTER JOIN SDB.tasic sic with(nolock)   
 ON sinac.fc_folio_simple_certificado = sic.fc_folio_simple_certificado  
 and len(sinac.fc_folio_simple_certificado) > 1  
 WHERE   
 (  
 @pc_anos IS NULL OR (@pc_anos IS NOT NULL AND YEAR(sinac.fd_rn_fecha_hora_nacimiento) IN (SELECT A.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_anos) A)))  
 AND (@pc_meses IS NULL OR (@pc_meses IS NOT NULL AND MONTH(sinac.fd_rn_fecha_hora_nacimiento) IN (SELECT M.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_meses) M)))  
 AND (@pc_municipios IS NULL OR (@pc_municipios IS NOT NULL AND SINAC.fi_rn_mpio_id IN(SELECT Mun.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_municipios) Mun)))  


delete from @vtRegistros
where fi_numero_registros > 1

SELECT @vi_parametro_ext  = fi_parametro_valor	
FROM SDB.TAParametros
WHERE fi_parametro_id = 1
   
 UPDATE @vtRegistros  
 SET fi_estatus_registro_id = @CONST_DUPLICADO_ID  
 WHERE fi_estatus_duplicado_sic = 1  
 AND fc_folio_simple_certificado = fc_folio_simple_certificado_sic  
   
 UPDATE @vtRegistros  
 SET fi_estatus_registro_id = @CONST_EXTEMPORANEO_ID  
 WHERE fi_estatus_registro_id = 1   AND fd_rn_fecha_hora_nacimiento = fd_rn_fecha_hora_nacimiento_sic  
 AND fd_rn_fecha_registro_sic > DATEADD(day,+@vi_parametro_ext,fd_rn_fecha_hora_nacimiento) 
 AND fi_estatus_duplicado_sic = 0    
  
 UPDATE @vtRegistros  
 SET fi_estatus_registro_id = @CONST_EXTEMPORANEO_ID,
 fd_rn_fecha_registro_sic = S.fd_rn_fecha_registro    
 FROM @vtRegistros AS V INNER JOIN sdb.tasic AS S  with(nolock) 
 ON V.fd_rn_fecha_hora_nacimiento = S.fd_rn_fecha_hora_nacimiento    
 WHERE fi_estatus_registro_id = 1  
 AND fi_rn_mpio_id = S.fi_mpio_id  
 AND fd_rn_fecha_registro_sic > DATEADD(day,+@vi_parametro_ext, V.fd_rn_fecha_hora_nacimiento)
 AND fi_estatus_duplicado_sic = 0    
    
 UPDATE @vtRegistros  
 SET fi_estatus_registro_id = @CONST_OPORTUNO_ID  
 WHERE fi_estatus_registro_id = 1  
 AND fc_folio_simple_certificado = fc_folio_simple_certificado_sic
 AND fi_estatus_duplicado_sic = 0    
 --AND fd_rn_fecha_registro_sic <= DATEADD(day,+60,fd_rn_fecha_hora_nacimiento)  
   
  
 UPDATE @vtRegistros  
 SET fi_estatus_registro_id = @CONST_OPORTUNO_ID,
 fd_rn_fecha_registro_sic = S.fd_rn_fecha_registro  
 FROM @vtRegistros AS V INNER JOIN sdb.tasic AS S with(nolock)   
 ON V.fd_rn_fecha_hora_nacimiento = S.fd_rn_fecha_hora_nacimiento    
 WHERE fi_estatus_registro_id = 1  
 AND fi_rn_mpio_id = S.fi_mpio_id 
 AND fi_estatus_duplicado_sic = 0   
 --AND fd_rn_fecha_registro_sic > DATEADD(day,+60, V.fd_rn_fecha_hora_nacimiento)  
  
 UPDATE @vtRegistros  
 SET fi_estatus_registro_id = @CONST_OPORTUNO_ID  
 WHERE fi_estatus_registro_id = 1  
 AND fd_rn_fecha_hora_nacimiento = fd_rn_fecha_hora_nacimiento_sic
 AND fi_estatus_duplicado_sic = 0    
 --AND fd_rn_fecha_registro_sic > DATEADD(day,+60,fd_rn_fecha_hora_nacimiento)  
   
 UPDATE @vtRegistros  
 SET fi_estatus_registro_id = @CONST_EXTEMPORANEO_ID  
 WHERE fi_estatus_registro_id = @CONST_OPORTUNO_ID 
 AND fd_rn_fecha_registro_sic >= DATEADD(day,+@vi_parametro_ext, fd_rn_fecha_hora_nacimiento_sic)
 AND fi_estatus_duplicado_sic = 0    
 
 
 --  UPDATE @vtRegistros  
 --SET fi_estatus_registro_id = @CONST_EXTEMPORANEO_ID  
 --WHERE fd_rn_fecha_hora_nacimiento = fd_rn_fecha_hora_nacimiento_sic  
 ----AND fd_rn_fecha_registro_sic > DATEADD(day,+@vi_parametro_ext,fd_rn_fecha_hora_nacimiento)   
 --AND datediff(dd,fd_rn_fecha_registro_sic,fd_rn_fecha_hora_nacimiento) > @vi_parametro_ext

 RETURN   

END 
GO

IF  EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('sdb.FNObtieneCoberturaSIC'))
	DROP FUNCTION sdb.FNObtieneCoberturaSIC
GO 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de una función para crear la tabla de combinaciones de  cobertura de sic
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE FUNCTION sdb.FNObtieneCoberturaSIC(    
@pc_anos_registro VARCHAR(255),
@pc_anos_nacimiento VARCHAR(255),  
@pc_meses VARCHAR(255),  
@pc_municipios VARCHAR(400))  
   
RETURNS @vtRegistros TABLE(  
 fi_id_renglon   INT NOT NULL IDENTITY(1,1),  
 fc_folio_certificado varchar(20) NOT NULL,  
 fc_folio_simple_certificado varchar(20) NOT NULL,  
 fd_rn_fecha_hora_nacimiento datetime,
 fd_rn_fecha_registro datetime,
 fi_edo_id int,  
 fi_mpio_id int,
 fi_mpio_ofi_id int,
 fi_oficialia_id int,
 fc_folio_certificado_sinac varchar(20),  
 fc_folio_simple_certificado_sinac varchar(20),  
 fd_rn_fecha_hora_nacimiento_sinac datetime, 
 fi_estatus_registro_id int NOT NULL, 
 fi_estatus_duplicado_sinac int NOT NULL,
 fi_numero_registros int,
 fi_tipo_relacionado_sic int
 )  
  
AS   
BEGIN   
 DECLARE   
 @CONST_REGISTRO_ID INT = 1,  
 @CONST_OPORTUNO_ID INT = 2,  
 @CONST_EXTEMPORANEO_ID INT = 3,  
 @CONST_DUPLICADO_ID INT = 4,  
 @CONST_COAHUILA_EDO_ID INT = 5, 
 @vi_parametro_ext INT;
  
 -- Inserta todos los registros del sinac, sin subregistro   


  --SELECT
  --ROW_NUMBER() over (
  --partition by sic.fc_folio_certificado,sic.fd_rn_fecha_registro,sic.fd_rn_fecha_hora_nacimiento,sic.fi_estatus_duplicado
  --order by sinac.fi_estatus_duplicado desc) RowNumber,*
  --FROM SDB.TASIC sic
  --left join sdb.tasinac sinac
  --on sic.fc_folio_simple_certificado = sinac.fc_folio_simple_certificado
  --AND len(sic.fc_folio_simple_certificado) > 1
  --WHERE YEAR(sic.fd_rn_fecha_hora_nacimiento) = '2018'
  ----and sic.fc_folio_certificado = '022076184'
  --ORDER BY ROWNUMBER DESC

INSERT @vtRegistros(  
 fc_folio_certificado,  
 fc_folio_simple_certificado,  
 fd_rn_fecha_hora_nacimiento,
 fd_rn_fecha_registro, 
 fi_edo_id,  
 fi_mpio_id,
 fi_mpio_ofi_id,
 fi_oficialia_id,
 fc_folio_certificado_sinac, 
 fc_folio_simple_certificado_sinac,  
 fd_rn_fecha_hora_nacimiento_sinac,   
 fi_estatus_registro_id,  
 fi_estatus_duplicado_sinac,
 fi_numero_registros,
 fi_tipo_relacionado_sic)   
 SELECT   
 sic.fc_folio_certificado,  
 sic.fc_folio_simple_certificado,  
 sic.fd_rn_fecha_hora_nacimiento,
 sic.fd_rn_fecha_registro, 
 sic.fi_edo_id,  
 sic.fi_mpio_id,
 sic.fi_mpio_ofi_id,
 sic.fi_oficialia_id, 
 sinac.fc_folio_certificado,  
 sinac.fc_folio_simple_certificado,  
 sinac.fd_rn_fecha_hora_nacimiento,     
 @CONST_REGISTRO_ID, 
 ISNULL(sinac.fi_estatus_duplicado, 0), 
 ROW_NUMBER() over (partition by sic.fc_folio_certificado,sic.fd_rn_fecha_registro,sic.fd_rn_fecha_hora_nacimiento,sic.fi_estatus_duplicado
 order by sinac.fi_estatus_duplicado desc) RowNumber 
 ,0--guarda el tipo de relación con el sinac, si es por folio o fecha
 FROM sdb.tasic sic  with(nolock)
 LEFT JOIN SDB.TASINAC SINAC
 ON sic.fc_folio_simple_certificado = sinac.fc_folio_simple_certificado 
 AND len(sic.fc_folio_simple_certificado) > 1 
 WHERE
 (
	 sic.fi_edo_id = 5 AND
	(@pc_anos_registro IS NULL OR (@pc_anos_registro IS NOT NULL AND 
	CAST(sic.fc_ano AS INT) IN (SELECT A.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_anos_registro) A)
	)) 
	and
	(@pc_anos_nacimiento IS NULL OR (@pc_anos_nacimiento IS NOT NULL AND
	YEAR(sic.fd_rn_fecha_hora_nacimiento) IN (SELECT N.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_anos_nacimiento) N)
	))
	AND (@pc_meses IS NULL OR (@pc_meses IS NOT NULL AND MONTH(sinac.fd_rn_fecha_hora_nacimiento) IN (SELECT M.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_meses) M)))  
    AND (@pc_municipios IS NULL OR (@pc_municipios IS NOT NULL AND SINAC.fi_rn_mpio_id IN(SELECT Mun.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_municipios) Mun)))  

 )

  /*Soluciona registros que tienen slash en el certificado*/
 UPDATE @vtRegistros
 SET fc_folio_certificado = REPLACE(fc_folio_certificado, '/', '-')
 WHERE fc_folio_certificado LIKE '%/%'
 
delete from @vtRegistros
where fi_numero_registros > 1

SELECT @vi_parametro_ext  = fi_parametro_valor	
FROM SDB.TAParametros
WHERE fi_parametro_id = 1
   
 --UPDATE @vtRegistros  
 --SET fi_estatus_registro_id = @CONST_DUPLICADO_ID  
 --WHERE fi_estatus_duplicado_sinac = 1  
 --AND fc_folio_simple_certificado = fc_folio_simple_certificado_sinac  
   
 UPDATE @vtRegistros 
 SET fi_estatus_registro_id = @CONST_EXTEMPORANEO_ID,
 fi_tipo_relacionado_sic = 1  --relacionado por folio
 WHERE fi_estatus_registro_id = @CONST_REGISTRO_ID
 AND fc_folio_simple_certificado = fc_folio_simple_certificado_sinac
 AND fd_rn_fecha_registro > DATEADD(day,+@vi_parametro_ext,fd_rn_fecha_hora_nacimiento_sinac) 
 --AND fi_estatus_duplicado_sinac = 0  
 
 UPDATE @vtRegistros  
 SET fi_estatus_registro_id = @CONST_OPORTUNO_ID,
 fi_tipo_relacionado_sic = 1  --relacionado por folio  
 WHERE fi_estatus_registro_id = @CONST_REGISTRO_ID  
 AND fc_folio_simple_certificado = fc_folio_simple_certificado_sinac
 --AND fi_estatus_duplicado_sinac = 0    

  
 UPDATE @vtRegistros  
 SET fi_estatus_registro_id = @CONST_EXTEMPORANEO_ID,
 fi_tipo_relacionado_sic = 2,   --relacionado por fecha
 fd_rn_fecha_hora_nacimiento_sinac = s.fd_rn_fecha_hora_nacimiento,
 fc_folio_simple_certificado_sinac = s.fc_folio_simple_certificado,
 fc_folio_certificado_sinac = s.fc_folio_certificado 
 FROM @vtRegistros AS V INNER JOIN sdb.tasinac AS S  with(nolock) 
 ON V.fd_rn_fecha_hora_nacimiento = S.fd_rn_fecha_hora_nacimiento    
 WHERE fi_estatus_registro_id = @CONST_REGISTRO_ID  
 AND v.fi_mpio_id = S.fi_rn_mpio_id  
 AND fd_rn_fecha_registro > DATEADD(day,+@vi_parametro_ext, V.fd_rn_fecha_hora_nacimiento)
 --AND fi_estatus_duplicado_sinac = 0    
  
 UPDATE @vtRegistros  
 SET fi_estatus_registro_id = @CONST_OPORTUNO_ID,
 fi_tipo_relacionado_sic = 2,   --relacionado por fecha 
 fd_rn_fecha_hora_nacimiento_sinac = s.fd_rn_fecha_hora_nacimiento,
 fc_folio_simple_certificado_sinac = s.fc_folio_simple_certificado,
 fc_folio_certificado_sinac = s.fc_folio_certificado 
 FROM @vtRegistros AS V INNER JOIN sdb.tasinac AS S with(nolock)   
 ON V.fd_rn_fecha_hora_nacimiento = S.fd_rn_fecha_hora_nacimiento    
 WHERE fi_estatus_registro_id = @CONST_REGISTRO_ID  
 AND v.fi_mpio_id = S.fi_rn_mpio_id 
 --AND fi_estatus_duplicado_sinac = 0   
   
 UPDATE @vtRegistros  
 SET fi_estatus_registro_id = @CONST_EXTEMPORANEO_ID  
 WHERE fi_estatus_registro_id = @CONST_OPORTUNO_ID 
 AND fd_rn_fecha_registro >= DATEADD(day,+@vi_parametro_ext, fd_rn_fecha_hora_nacimiento_sinac)
 --AND fi_estatus_duplicado_sinac = 0 
 
 --solo sic extemporaneo
 UPDATE @vtRegistros  
 SET fi_estatus_registro_id = @CONST_EXTEMPORANEO_ID
 WHERE 
 fi_tipo_relacionado_sic = 0
 and fi_estatus_registro_id = @CONST_REGISTRO_ID  
 --AND fi_estatus_duplicado_sinac = 0 
 
  --solo sic oportuno
 UPDATE @vtRegistros  
 SET fi_estatus_registro_id = @CONST_OPORTUNO_ID
 WHERE 
 fi_tipo_relacionado_sic = 0
 and fi_estatus_registro_id = @CONST_EXTEMPORANEO_ID 
 AND fd_rn_fecha_registro < DATEADD(day,+@vi_parametro_ext, fd_rn_fecha_hora_nacimiento) 
 --AND fi_estatus_duplicado_sinac = 0        
 

 RETURN   

END 
GO


IF  EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('sdb.FNObtieneTablaSICAnalisis'))
	DROP FUNCTION sdb.FNObtieneTablaSICAnalisis
GO 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de una función para crear la tabla de combinaciones de  subregistros de nacimientos
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE FUNCTION sdb.FNObtieneTablaSICAnalisis(    
@pc_anos VARCHAR(255),  
@pc_meses VARCHAR(255),  
@pc_municipios VARCHAR(400))  
  
RETURNS @vtRegistros TABLE(  
 fi_id_renglon   INT NOT NULL IDENTITY(1,1),  
 fc_folio_certificado varchar(20) NOT NULL,  
 fc_folio_simple_certificado varchar(20) NOT NULL,  
 fd_rn_fecha_hora_nacimiento datetime,  
 fd_rn_fecha_registro datetime,   
 fi_edo_id int,  
 fi_mpio_id int,
 fi_mpio_ofi_id int,
 fi_oficialia_id int,
 fc_folio_certificado_sinac varchar(20),  
 fc_folio_simple_certificado_sinac varchar(20),  
 fd_rn_fecha_hora_nacimiento_sinac datetime,   
 fi_estatus_registro_id int NOT NULL,  
 fi_estatus_duplicado_sic int NOT NULL  
 )  
  
AS   
BEGIN   
 DECLARE
 @CONST_DUPLICADO_ID INT = 4,
 @CONST_NOREGISTRADO_SINAC_ID INT = 5,    
 @CONST_REGISTRADO_FOLIO_SINAC_ID INT = 6, 
 @CONST_REGISTRADO_FECHA_SINAC_ID INT = 7,   
 @CONST_COAHUILA_EDO_ID INT = 5 
  
 -- Inserta todos los registros del sinac, sin subregistro   
  
INSERT @vtRegistros(  
 fc_folio_certificado,  
 fc_folio_simple_certificado,  
 fd_rn_fecha_hora_nacimiento,
 fd_rn_fecha_registro, 
 fi_edo_id,  
 fi_mpio_id,
 fi_mpio_ofi_id,
 fi_oficialia_id,
 fc_folio_certificado_sinac, 
 fc_folio_simple_certificado_sinac,  
 fd_rn_fecha_hora_nacimiento_sinac,   
 fi_estatus_registro_id,  
 fi_estatus_duplicado_sic)  
 SELECT   
 sic.fc_folio_certificado,  
 sic.fc_folio_simple_certificado,  
 sic.fd_rn_fecha_hora_nacimiento,
 sic.fd_rn_fecha_registro, 
 sic.fi_edo_id,  
 sic.fi_mpio_id,
 sic.fi_mpio_ofi_id,
 sic.fi_oficialia_id, 
 sinac.fc_folio_certificado,  
 sinac.fc_folio_simple_certificado,  
 sinac.fd_rn_fecha_hora_nacimiento,     
 @CONST_NOREGISTRADO_SINAC_ID,  
 ISNULL(sic.fi_estatus_duplicado, 0)  
 FROM sdb.tasic sic  with(nolock)
 LEFT JOIN SDB.tasinac sinac with(nolock)   
 ON rtrim(ltrim(sic.fc_folio_certificado)) = rtrim(ltrim(sinac.fc_folio_certificado))
 WHERE
(  
 @pc_anos IS NULL OR (@pc_anos IS NOT NULL AND YEAR(sic.fd_rn_fecha_registro) IN (SELECT A.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_anos) A)))  
 AND (@pc_meses IS NULL OR (@pc_meses IS NOT NULL AND MONTH(sic.fd_rn_fecha_registro) IN (SELECT M.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_meses) M)))  
 AND (@pc_municipios IS NULL OR (@pc_municipios IS NOT NULL AND sic.fi_mpio_id IN(SELECT Mun.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_municipios) Mun)))  
 AND (@pc_municipios IS NULL OR sic.fi_edo_id = @CONST_COAHUILA_EDO_ID)
 and sinac.fc_folio_simple_certificado is null
 
 UPDATE @vtRegistros  
 SET fi_estatus_registro_id = @CONST_DUPLICADO_ID  
 WHERE fi_estatus_registro_id = @CONST_NOREGISTRADO_SINAC_ID   
 AND fi_estatus_duplicado_sic = 1 

 UPDATE @vtRegistros  
 SET fi_estatus_registro_id = @CONST_REGISTRADO_FOLIO_SINAC_ID,
 fc_folio_certificado_sinac = sinac.fc_folio_certificado,
 fc_folio_simple_certificado_sinac = sinac.fc_folio_simple_certificado,
 fd_rn_fecha_hora_nacimiento_sinac = sinac.fd_rn_fecha_hora_nacimiento
 FROM @vtRegistros AS V INNER JOIN sdb.tasinac AS sinac with(nolock)   
 ON v.fc_folio_simple_certificado = sinac.fc_folio_simple_certificado     
 WHERE v.fi_estatus_registro_id = @CONST_NOREGISTRADO_SINAC_ID 
 AND len(v.fc_folio_simple_certificado) > 1
 
 UPDATE @vtRegistros  
 SET fi_estatus_registro_id = @CONST_REGISTRADO_FECHA_SINAC_ID,
 fc_folio_certificado_sinac = sinac.fc_folio_certificado,
 fc_folio_simple_certificado_sinac = sinac.fc_folio_simple_certificado,
 fd_rn_fecha_hora_nacimiento_sinac = sinac.fd_rn_fecha_hora_nacimiento
 FROM @vtRegistros AS V INNER JOIN sdb.tasinac AS sinac with(nolock)   
 ON V.fd_rn_fecha_hora_nacimiento = sinac.fd_rn_fecha_hora_nacimiento
 AND V.fi_mpio_id = sinac.fi_rn_mpio_id     
 WHERE v.fi_estatus_registro_id = @CONST_NOREGISTRADO_SINAC_ID

  /*Soluciona registros que tienen slash en el certificado*/
 UPDATE @vtRegistros
 SET fc_folio_certificado = REPLACE(fc_folio_certificado, '/', '-')
 WHERE fc_folio_certificado LIKE '%/%'

 RETURN   

END 
GO


