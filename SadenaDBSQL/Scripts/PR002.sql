USE SADENADB
GO

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSCatatalogosPreConsulta') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSCatatalogosPreConsulta
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que consulta los catálogos a mostrar en la búsqueda
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSCatatalogosPreConsulta(
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 	
	DECLARE 
	@CONST_CONTROL_TIPO_SINAC INT = 2,
	@CONST_CONTROL_TIPO_SIC INT = 3,
	@CONST_COAHUILA_EDO_ID INT = 5,
		
	@CONST_ESTATUS_CONTROL_PROCESADO INT = 3,
	@vi_registros int,
	@vi_renglonId int	

	DECLARE @vtAnos TABLE(
	fi_id_renglon   INT NOT NULL IDENTITY(1,1),
	fc_ano varchar(4) NOT NULL
	)
	

	SET NOCOUNT ON
		
BEGIN TRY	

	IF EXISTS(		 
	SELECT SINAC.fi_control_id FROM
		SDB.TAControlCarga SINAC WITH( NOLOCK)		
	WHERE 
		SINAC.fi_control_tipo_id = @CONST_CONTROL_TIPO_SINAC AND SINAC.fi_estatus_control_id = @CONST_ESTATUS_CONTROL_PROCESADO
	)
	BEGIN
		INSERT @vtAnos(fc_ano)
		SELECT SINAC.fc_ano		
		FROM
		SDB.TAControlCarga SINAC WITH(NOLOCK)		
		WHERE 
		SINAC.fi_control_tipo_id = @CONST_CONTROL_TIPO_SINAC AND  SINAC.fi_estatus_control_id = @CONST_ESTATUS_CONTROL_PROCESADO		

		SELECT fc_ano as AnoCarga FROM @vtAnos

		SET LANGUAGE Spanish
		SELECT DISTINCT(DATENAME(MONTH, SINAC.fd_rn_fecha_hora_nacimiento)) AS MesCarga 
		FROM SDB.TASINAC SINAC,@vtAnos VT
		WHERE VT.fc_ano = YEAR(SINAC.fd_rn_fecha_hora_nacimiento) 

		--SELECT DISTINCT(SINAC.fi_rn_mpio_id) as MpioId,CTLOC.fc_loc_mpio_desc as MpioDesc
		--FROM @vtAnos VT INNER JOIN SDB.TASINAC SINAC 
		--ON VT.fc_ano = YEAR(SINAC.fd_rn_fecha_hora_nacimiento)
		--INNER JOIN SDB.CTLocalidad CTLOC
		--ON SINAC.fi_rn_edo_id = CTLOC.fi_loc_edo_id		
		--AND SINAC.fi_rn_mpio_id = CTLOC.fi_loc_mpio_id		
		--WHERE 
		--CTLOC.fi_loc_edo_id = @CONST_COAHUILA_EDO_ID
		--ORDER BY fc_loc_mpio_desc

		SELECT DISTINCT(SINAC.fi_rn_mpio_id) as MpioId,CTLOC.fc_loc_mpio_desc as MpioDesc
		FROM SDB.TASINAC SINAC 
		INNER JOIN SDB.CTLocalidad CTLOC
		ON SINAC.fi_rn_edo_id = CTLOC.fi_loc_edo_id		
		AND SINAC.fi_rn_mpio_id = CTLOC.fi_loc_mpio_id		
		WHERE 
		CTLOC.fi_loc_edo_id = @CONST_COAHUILA_EDO_ID
		ORDER BY fc_loc_mpio_desc

	END
	ELSE
		BEGIN
			SELECT @po_msg_code=1, @po_msg = 'No existen registros cargados para consultar, favor de notificar al administrador'
		END

	SELECT @po_msg_code=0, @po_msg = 'La ejecución del procedimiento fue exitosa'	
END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al obtener la consulta de años cargados ' + ERROR_MESSAGE()
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO


IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSConsultaMesesXAnio') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSConsultaMesesXAnio
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que obtiene los meses de un año
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSConsultaMesesXAnio(
@pc_ano VARCHAR(4),
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 	
	DECLARE 
	@StartDate  DATETIME,
	@EndDate    DATETIME

	SET NOCOUNT ON
		
BEGIN TRY	

	SET LANGUAGE Spanish
	SET @StartDate = CAST(@pc_ano + CAST('01' AS varchar) + CAST('01' AS varchar) AS DATETIME)

	IF(@pc_ano = FORMAT(SYSDATETIME(),'yyyy'))
		BEGIN
			SET @EndDate   = CAST(@pc_ano + FORMAT(SYSDATETIME(),'MM') + FORMAT(SYSDATETIME(),'dd') AS DATETIME)
		END 
	ELSE
		BEGIN
			SET @EndDate   = CAST(@pc_ano + CAST('12' AS varchar) + CAST('31' AS varchar) AS DATETIME)
		END

	SELECT  MONTH(DATEADD(MONTH, x.number, @StartDate)) AS MesId,DATENAME(MONTH, DATEADD(MONTH, x.number, @StartDate)) AS MesDesc
	FROM    master.dbo.spt_values x
	WHERE   x.type = 'P'        
	AND     x.number <= DATEDIFF(MONTH, @StartDate, @EndDate);

	SELECT @po_msg_code=0, @po_msg = 'La ejecución del procedimiento fue exitosa'
		
END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al obtener la consulta de los mesesde un año' + ERROR_MESSAGE()
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO


IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRNSubregistroTotalNacimientos') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRNSubregistroTotalNacimientos
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que obtiene el subregistro de los nacimientos
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRNSubregistroTotalNacimientos(
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 	
	DECLARE @vtRegistros TABLE(
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

	DECLARE 
	@CONST_SUBREGISTRO_ID INT = 1,
	@CONST_OPORTUNO_ID INT = 2,
	@CONST_EXTEMPORANEO_ID INT = 3,
	@CONST_DUPLICADO_ID INT = 4
	
	SET NOCOUNT ON

BEGIN TRY		
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
	
	SELECT 'Totales Subregistro', ct.fi_estatus_registro_desc,count(vt.fi_estatus_registro_id) as total
	FROM @vtRegistros vt INNER JOIN SDB.CTEstatusRegistro ct
	ON vt.fi_estatus_registro_id = ct.fi_estatus_registro_id
	GROUP BY vt.fi_estatus_registro_id,ct.fi_estatus_registro_desc
		
	SELECT 'Subregistros',r.fc_folio_certificado as Folio,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as FechaNacimiento,
	r.fi_rn_sexo_id as SexoId, cts.fc_sexo_desc as SexoDesc,
	r.fi_rn_edo_id as EdoId,
	r.fi_rn_mpio_id as MpioId,
	r.fi_ma_dom_edo_id as LocId, ctloc.fc_loc_desc as LocDesc,
	CONCAT(r.fc_ma_dom_calle,' No.Ext:',r.fc_ma_dom_numext,' Int:',r.fc_ma_dom_numint) as Domicilio,
	r.fi_ma_edad as Edad,
	r.fi_ma_num_nacimiento as NumNacimiento,
	r.fc_ma_ocupacion as Ocupacion,
	r.fi_ma_edo_civil_id as EdoCivilId, ctciv.fc_edo_civil_desc as EdoCivilDesc,
	r.fi_ma_escol_id as EscolId,ctescol.fc_escol_desc as EscolDesc 
	FROM @vtRegistros r 
	INNER JOIN SDB.CTSexo cts on cts.fi_sexo_id = r.fi_rn_sexo_id
	INNER JOIN SDB.CTEdoCivil ctciv on ctciv.fi_edo_civil_id = r.fi_ma_edo_civil_id
	INNER JOIN SDB.CTEscolaridad ctescol on ctescol.fi_escol_id = r.fi_ma_escol_id	
	INNER JOIN SDB.CTLocalidad ctloc on ctloc.fi_loc_edo_id = r.fi_rn_edo_id and ctloc.fi_loc_mpio_id = r.fi_rn_mpio_id and ctloc.fi_loc_id = r.fi_ma_dom_edo_id
	WHERE r.fi_estatus_registro_id = @CONST_SUBREGISTRO_ID

	SELECT 'Oportunos',r.fc_folio_certificado as Folio,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as FechaNacimiento,
	r.fi_rn_sexo_id as SexoId, cts.fc_sexo_desc as SexoDesc,
	r.fi_rn_edo_id as EdoId,
	r.fi_rn_mpio_id as MpioId,
	r.fi_ma_dom_edo_id as LocId, ctloc.fc_loc_desc as LocDesc,
	CONCAT(r.fc_ma_dom_calle,' No.Ext:',r.fc_ma_dom_numext,' Int:',r.fc_ma_dom_numint) as Domicilio,
	r.fi_ma_edad as Edad,
	r.fi_ma_num_nacimiento as NumNacimiento,
	r.fc_ma_ocupacion as Ocupacion,
	r.fi_ma_edo_civil_id as EdoCivilId, ctciv.fc_edo_civil_desc as EdoCivilDesc,
	r.fi_ma_escol_id as EscolId,ctescol.fc_escol_desc as EscolDesc 
	FROM @vtRegistros r 
	INNER JOIN SDB.CTSexo cts on cts.fi_sexo_id = r.fi_rn_sexo_id
	INNER JOIN SDB.CTEdoCivil ctciv on ctciv.fi_edo_civil_id = r.fi_ma_edo_civil_id
	INNER JOIN SDB.CTEscolaridad ctescol on ctescol.fi_escol_id = r.fi_ma_escol_id
	INNER JOIN SDB.CTLocalidad ctloc on ctloc.fi_loc_edo_id = r.fi_rn_edo_id and ctloc.fi_loc_mpio_id = r.fi_rn_mpio_id and ctloc.fi_loc_id = r.fi_ma_dom_edo_id	 
	WHERE fi_estatus_registro_id = @CONST_OPORTUNO_ID

	SELECT 'Extemporaneos',r.fc_folio_certificado as Folio,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as FechaNacimiento,
	r.fi_rn_sexo_id as SexoId, cts.fc_sexo_desc as SexoDesc,
	r.fi_rn_edo_id as EdoId,
	r.fi_rn_mpio_id as MpioId,
	r.fi_ma_dom_edo_id as LocId, ctloc.fc_loc_desc as LocDesc,
	CONCAT(r.fc_ma_dom_calle,' No.Ext:',r.fc_ma_dom_numext,' Int:',r.fc_ma_dom_numint) as Domicilio,
	r.fi_ma_edad as Edad,
	r.fi_ma_num_nacimiento as NumNacimiento,
	r.fc_ma_ocupacion as Ocupacion,
	r.fi_ma_edo_civil_id as EdoCivilId, ctciv.fc_edo_civil_desc as EdoCivilDesc,
	r.fi_ma_escol_id as EscolId,ctescol.fc_escol_desc as EscolDesc 
	FROM @vtRegistros r 
	INNER JOIN SDB.CTSexo cts on cts.fi_sexo_id = r.fi_rn_sexo_id
	INNER JOIN SDB.CTEdoCivil ctciv on ctciv.fi_edo_civil_id = r.fi_ma_edo_civil_id
	INNER JOIN SDB.CTLocalidad ctloc on ctloc.fi_loc_edo_id = r.fi_rn_edo_id and ctloc.fi_loc_mpio_id = r.fi_rn_mpio_id and ctloc.fi_loc_id = r.fi_ma_dom_edo_id
	INNER JOIN SDB.CTEscolaridad ctescol on ctescol.fi_escol_id = r.fi_ma_escol_id	
	WHERE fi_estatus_registro_id = @CONST_EXTEMPORANEO_ID

	SELECT 'Duplicados'
	,r.fc_folio_certificado as Folio,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as FechaNacimiento,
	r.fi_rn_sexo_id as SexoId, cts.fc_sexo_desc as SexoDesc,
	r.fi_rn_edo_id as EdoId,
	r.fi_rn_mpio_id as MpioId,
	r.fi_ma_dom_edo_id as LocId, ctloc.fc_loc_desc as LocDesc,
	CONCAT(r.fc_ma_dom_calle,' No.Ext:',r.fc_ma_dom_numext,' Int:',r.fc_ma_dom_numint) as Domicilio,
	r.fi_ma_edad as Edad,
	r.fi_ma_num_nacimiento as NumNacimiento,
	r.fc_ma_ocupacion as Ocupacion,
	r.fi_ma_edo_civil_id as EdoCivilId, ctciv.fc_edo_civil_desc as EdoCivilDesc,
	r.fi_ma_escol_id as EscolId,ctescol.fc_escol_desc as EscolDesc 
	FROM @vtRegistros r 
	INNER JOIN SDB.CTSexo cts on cts.fi_sexo_id = r.fi_rn_sexo_id
	INNER JOIN SDB.CTEdoCivil ctciv on ctciv.fi_edo_civil_id = r.fi_ma_edo_civil_id
	INNER JOIN SDB.CTEscolaridad ctescol on ctescol.fi_escol_id = r.fi_ma_escol_id
	INNER JOIN SDB.CTLocalidad ctloc on ctloc.fi_loc_edo_id = r.fi_rn_edo_id and ctloc.fi_loc_mpio_id = r.fi_rn_mpio_id and ctloc.fi_loc_id = r.fi_ma_dom_edo_id
	WHERE fi_estatus_registro_id = @CONST_DUPLICADO_ID

	SELECT @po_msg_code=0, @po_msg = 'La ejecución del procedimiento fue exitosa'	

END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al obtener subregistro ' + ERROR_MESSAGE()
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSSubregistroNacimientos') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSSubregistroNacimientos
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que obtiene el subregistro de los nacimientos a través de parámetros de búsqueda
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSSubregistroNacimientos(
@pc_anos VARCHAR(255),
@pc_meses VARCHAR(255),
@pc_municipios VARCHAR(255),
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 	
	DECLARE @vtRegistros TABLE(
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

	DECLARE 
	@CONST_SUBREGISTRO_ID INT = 1,
	@CONST_OPORTUNO_ID INT = 2,
	@CONST_EXTEMPORANEO_ID INT = 3,
	@CONST_DUPLICADO_ID INT = 4,
	@CONST_COAHUILA_EDO_ID INT = 5
	
	SET NOCOUNT ON

BEGIN TRY		
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
	WHERE @pc_anos IS NULL OR (YEAR(sinac.fd_rn_fecha_hora_nacimiento) IN (@pc_anos))
	AND @pc_meses IS NULL OR (MONTH(sinac.fd_rn_fecha_hora_nacimiento) IN (@pc_meses))
	AND @pc_municipios IS NULL OR (sinac.fi_rn_edo_id = @CONST_COAHUILA_EDO_ID AND SINAC.fi_rn_mpio_id IN(@pc_municipios))
		
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
	
	SELECT 'Totales Subregistro', ct.fi_estatus_registro_desc as NombreGrupo,count(vt.fi_estatus_registro_id) as Total
	FROM @vtRegistros vt INNER JOIN SDB.CTEstatusRegistro ct
	ON vt.fi_estatus_registro_id = ct.fi_estatus_registro_id
	GROUP BY vt.fi_estatus_registro_id,ct.fi_estatus_registro_desc
		
	SELECT 'Subregistros',r.fc_folio_certificado as Folio,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as FechaNacimiento,
	r.fi_rn_sexo_id as SexoId, cts.fc_sexo_desc as SexoDesc,
	r.fi_rn_edo_id as EdoId,
	r.fi_rn_mpio_id as MpioId,
	r.fi_ma_dom_edo_id as LocId, ctloc.fc_loc_desc as LocDesc,
	CONCAT(r.fc_ma_dom_calle,' No.Ext:',r.fc_ma_dom_numext,' Int:',r.fc_ma_dom_numint) as Domicilio,
	r.fi_ma_edad as Edad,
	r.fi_ma_num_nacimiento as NumNacimiento,
	r.fc_ma_ocupacion as Ocupacion,
	r.fi_ma_edo_civil_id as EdoCivilId, ctciv.fc_edo_civil_desc as EdoCivilDesc,
	r.fi_ma_escol_id as EscolId,ctescol.fc_escol_desc as EscolDesc 
	FROM @vtRegistros r 
	INNER JOIN SDB.CTSexo cts on cts.fi_sexo_id = r.fi_rn_sexo_id
	INNER JOIN SDB.CTEdoCivil ctciv on ctciv.fi_edo_civil_id = r.fi_ma_edo_civil_id
	INNER JOIN SDB.CTEscolaridad ctescol on ctescol.fi_escol_id = r.fi_ma_escol_id	
	INNER JOIN SDB.CTLocalidad ctloc on ctloc.fi_loc_edo_id = r.fi_rn_edo_id and ctloc.fi_loc_mpio_id = r.fi_rn_mpio_id and ctloc.fi_loc_id = r.fi_ma_dom_edo_id
	WHERE r.fi_estatus_registro_id = @CONST_SUBREGISTRO_ID

	SELECT 'Oportunos',r.fc_folio_certificado as Folio,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as FechaNacimiento,
	r.fi_rn_sexo_id as SexoId, cts.fc_sexo_desc as SexoDesc,
	r.fi_rn_edo_id as EdoId,
	r.fi_rn_mpio_id as MpioId,
	r.fi_ma_dom_edo_id as LocId, ctloc.fc_loc_desc as LocDesc,
	CONCAT(r.fc_ma_dom_calle,' No.Ext:',r.fc_ma_dom_numext,' Int:',r.fc_ma_dom_numint) as Domicilio,
	r.fi_ma_edad as Edad,
	r.fi_ma_num_nacimiento as NumNacimiento,
	r.fc_ma_ocupacion as Ocupacion,
	r.fi_ma_edo_civil_id as EdoCivilId, ctciv.fc_edo_civil_desc as EdoCivilDesc,
	r.fi_ma_escol_id as EscolId,ctescol.fc_escol_desc as EscolDesc 
	FROM @vtRegistros r 
	INNER JOIN SDB.CTSexo cts on cts.fi_sexo_id = r.fi_rn_sexo_id
	INNER JOIN SDB.CTEdoCivil ctciv on ctciv.fi_edo_civil_id = r.fi_ma_edo_civil_id
	INNER JOIN SDB.CTEscolaridad ctescol on ctescol.fi_escol_id = r.fi_ma_escol_id
	INNER JOIN SDB.CTLocalidad ctloc on ctloc.fi_loc_edo_id = r.fi_rn_edo_id and ctloc.fi_loc_mpio_id = r.fi_rn_mpio_id and ctloc.fi_loc_id = r.fi_ma_dom_edo_id	 
	WHERE fi_estatus_registro_id = @CONST_OPORTUNO_ID

	SELECT 'Extemporaneos',r.fc_folio_certificado as Folio,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as FechaNacimiento,
	r.fi_rn_sexo_id as SexoId, cts.fc_sexo_desc as SexoDesc,
	r.fi_rn_edo_id as EdoId,
	r.fi_rn_mpio_id as MpioId,
	r.fi_ma_dom_edo_id as LocId, ctloc.fc_loc_desc as LocDesc,
	CONCAT(r.fc_ma_dom_calle,' No.Ext:',r.fc_ma_dom_numext,' Int:',r.fc_ma_dom_numint) as Domicilio,
	r.fi_ma_edad as Edad,
	r.fi_ma_num_nacimiento as NumNacimiento,
	r.fc_ma_ocupacion as Ocupacion,
	r.fi_ma_edo_civil_id as EdoCivilId, ctciv.fc_edo_civil_desc as EdoCivilDesc,
	r.fi_ma_escol_id as EscolId,ctescol.fc_escol_desc as EscolDesc 
	FROM @vtRegistros r 
	INNER JOIN SDB.CTSexo cts on cts.fi_sexo_id = r.fi_rn_sexo_id
	INNER JOIN SDB.CTEdoCivil ctciv on ctciv.fi_edo_civil_id = r.fi_ma_edo_civil_id
	INNER JOIN SDB.CTLocalidad ctloc on ctloc.fi_loc_edo_id = r.fi_rn_edo_id and ctloc.fi_loc_mpio_id = r.fi_rn_mpio_id and ctloc.fi_loc_id = r.fi_ma_dom_edo_id
	INNER JOIN SDB.CTEscolaridad ctescol on ctescol.fi_escol_id = r.fi_ma_escol_id	
	WHERE fi_estatus_registro_id = @CONST_EXTEMPORANEO_ID

	SELECT 'Duplicados'
	,r.fc_folio_certificado as Folio,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as FechaNacimiento,
	r.fi_rn_sexo_id as SexoId, cts.fc_sexo_desc as SexoDesc,
	r.fi_rn_edo_id as EdoId,
	r.fi_rn_mpio_id as MpioId,
	r.fi_ma_dom_edo_id as LocId, ctloc.fc_loc_desc as LocDesc,
	CONCAT(r.fc_ma_dom_calle,' No.Ext:',r.fc_ma_dom_numext,' Int:',r.fc_ma_dom_numint) as Domicilio,
	r.fi_ma_edad as Edad,
	r.fi_ma_num_nacimiento as NumNacimiento,
	r.fc_ma_ocupacion as Ocupacion,
	r.fi_ma_edo_civil_id as EdoCivilId, ctciv.fc_edo_civil_desc as EdoCivilDesc,
	r.fi_ma_escol_id as EscolId,ctescol.fc_escol_desc as EscolDesc 
	FROM @vtRegistros r 
	INNER JOIN SDB.CTSexo cts on cts.fi_sexo_id = r.fi_rn_sexo_id
	INNER JOIN SDB.CTEdoCivil ctciv on ctciv.fi_edo_civil_id = r.fi_ma_edo_civil_id
	INNER JOIN SDB.CTEscolaridad ctescol on ctescol.fi_escol_id = r.fi_ma_escol_id
	INNER JOIN SDB.CTLocalidad ctloc on ctloc.fi_loc_edo_id = r.fi_rn_edo_id and ctloc.fi_loc_mpio_id = r.fi_rn_mpio_id and ctloc.fi_loc_id = r.fi_ma_dom_edo_id
	WHERE fi_estatus_registro_id = @CONST_DUPLICADO_ID

	SELECT @po_msg_code=0, @po_msg = 'La ejecución del procedimiento fue exitosa'	

END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al obtener subregistro ' + ERROR_MESSAGE()
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSTotalesSubregistroNacimientos') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSTotalesSubregistroNacimientos
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que obtiene los totales el subregistro de los nacimientos a través de parámetros de búsqueda
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  





