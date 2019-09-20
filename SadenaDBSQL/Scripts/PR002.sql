USE SADENADB
GO

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSCatalogosPreConsulta') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSCatalogosPreConsulta
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que consulta los catálogos a mostrar en la búsqueda
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSCatalogosPreConsulta(
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
	
		SELECT  (x.number + 1) as MesId,DATENAME(MONTH, DATEADD(MONTH, x.number, '20000101')) AS MesDesc
		FROM    master.dbo.spt_values x
		WHERE   x.type = 'P'        
		AND     x.number <= DATEDIFF(MONTH, '20000101', '20001231'); 

		SELECT fi_mpio_id as MpioId,fc_mpio_desc as MpioDesc
		FROM SDB.CTMunicipio
		
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

 IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSCatalogosSICPreConsulta') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSCatalogosSICPreConsulta
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que consulta los catálogos a mostrar en la búsqueda del SIC
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSCatalogosSICPreConsulta(
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

	SET NOCOUNT ON
		
BEGIN TRY	

	IF EXISTS(		 
	SELECT SIC.fi_control_id FROM
		SDB.TAControlCarga SIC WITH( NOLOCK)		
	WHERE 
		SIC.fi_control_tipo_id = @CONST_CONTROL_TIPO_SIC AND SIC.fi_estatus_control_id = @CONST_ESTATUS_CONTROL_PROCESADO
	)
	BEGIN
		SELECT SIC.fc_ano as AnoRegistroSIC		
		FROM
		SDB.TAControlCarga SIC WITH(NOLOCK)		
		WHERE 
		SIC.fi_control_tipo_id = @CONST_CONTROL_TIPO_SIC AND  SIC.fi_estatus_control_id = @CONST_ESTATUS_CONTROL_PROCESADO		

		
		SELECT DISTINCT YEAR(fd_rn_fecha_hora_nacimiento) AS AnoNacSIC
		FROM SDB.TASIC WITH(NOLOCK)	
		WHERE YEAR(fd_rn_fecha_hora_nacimiento) > 0
		ORDER BY 1 ASC
		
		SET LANGUAGE Spanish
	
		SELECT  (x.number + 1) as MesId,DATENAME(MONTH, DATEADD(MONTH, x.number, '20000101')) AS MesDesc
		FROM    master.dbo.spt_values x
		WHERE   x.type = 'P'        
		AND     x.number <= DATEDIFF(MONTH, '20000101', '20001231'); 

		SELECT fi_mpio_id as MpioId,fc_mpio_desc as MpioDesc
		FROM SDB.CTMunicipio WITH(NOLOCK)	
		--UNION SELECT '666' as MpioId,'Otros' as MpioDesc
		
		

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
 

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSTotalesSubregistroNacimientos') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSTotalesSubregistroNacimientos
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que obtiene los totales del subregistro de los nacimientos
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSTotalesSubregistroNacimientos(
@pc_anos VARCHAR(255),
@pc_meses VARCHAR(255),
@pc_municipios VARCHAR(255),
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 	
	
	SET NOCOUNT ON

BEGIN TRY		

	SELECT 'Totales Subregistro', vt.fi_estatus_registro_id as IdGrupo, ct.fi_estatus_registro_desc as NombreGrupo,count(vt.fi_estatus_registro_id) as Total
	FROM SDB.FNObtieneTablaSubregistro(@pc_anos,@pc_meses,@pc_municipios) vt INNER JOIN SDB.CTEstatusRegistro ct
	ON vt.fi_estatus_registro_id = ct.fi_estatus_registro_id
	GROUP BY vt.fi_estatus_registro_id,ct.fi_estatus_registro_desc
	
	
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
	fc_ma_nombre varchar(40),
	fc_ma_ap_paterno varchar(20),
	fc_ma_ap_materno varchar(20),
	fi_ma_dom_edo_id int NOT NULL,
	fi_ma_dom_mpio_id int NOT NULL,
	fi_ma_dom_loc_id int NOT NULL,
	fc_ma_dom_col varchar(60),
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
	fc_ma_nombre,
	fc_ma_ap_paterno,
	fc_ma_ap_materno,
	fi_ma_dom_edo_id,
	fi_ma_dom_mpio_id,
	fi_ma_dom_loc_id,
	fc_ma_dom_col,
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
	VT.fc_folio_certificado,
	VT.fc_folio_simple_certificado,
	VT.fd_rn_fecha_hora_nacimiento,	
	VT.fi_rn_sexo_id,
	VT.fi_rn_edo_id,
	VT.fi_rn_mpio_id,
	VT.fc_ma_nombre,
	VT.fc_ma_ap_paterno,
	VT.fc_ma_ap_materno,
	VT.fi_ma_dom_edo_id,
	VT.fi_ma_dom_mpio_id,
	VT.fi_ma_dom_loc_id,
	VT.fc_ma_dom_col,
	VT.fc_ma_dom_calle,
	VT.fc_ma_dom_numext,
	VT.fc_ma_dom_numint,		
	VT.fi_ma_edad,
	VT.fi_ma_num_nacimiento,
	VT.fc_ma_ocupacion,
	VT.fi_ma_edo_civil_id,
	VT.fi_ma_escol_id,
	VT.fc_folio_simple_certificado_sic,
	VT.fd_rn_fecha_hora_nacimiento_sic,
	VT.fd_rn_fecha_registro_sic, 
	VT.fi_edo_id_sic,
	VT.fi_mpio_id_sic,
	VT.fi_estatus_registro_id,
	VT.fi_estatus_duplicado_sic
	FROM SDB.FNObtieneTablaSubregistro(@pc_anos,@pc_meses,@pc_municipios) VT		

	SELECT 'Totales Subregistro', vt.fi_estatus_registro_id as IdGrupo, ct.fi_estatus_registro_desc as NombreGrupo,count(vt.fi_estatus_registro_id) as Total
	FROM @vtRegistros vt INNER JOIN SDB.CTEstatusRegistro ct
	ON vt.fi_estatus_registro_id = ct.fi_estatus_registro_id
	GROUP BY vt.fi_estatus_registro_id,ct.fi_estatus_registro_desc
		
	SELECT 'Subregistros',r.fc_folio_certificado as Folio,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as FechaNacimiento,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 108) as HoraNacimiento,
	r.fi_rn_sexo_id as SexoId, cts.fc_sexo_desc as SexoDesc,
	r.fc_ma_nombre as Nombre,r.fc_ma_ap_paterno as Paterno,r.fc_ma_ap_materno as Materno,
	r.fi_ma_dom_edo_id as EdoId,ctloc.fc_loc_edo_desc as EdoDesc,
	r.fi_ma_dom_mpio_id as MpioId,ctloc.fc_loc_mpio_desc as MpioDesc,
	r.fi_ma_dom_loc_id as LocId, ctloc.fc_loc_desc as LocDesc,
	r.fc_ma_dom_col as Colonia, r.fc_ma_dom_calle as Calle,r.fc_ma_dom_numext as NoExt, r.fc_ma_dom_numint as NoInt,
	r.fi_ma_edad as Edad,
	r.fi_ma_num_nacimiento as NumNacimiento,
	r.fc_ma_ocupacion as Ocupacion,
	r.fi_ma_edo_civil_id as EdoCivilId, ctciv.fc_edo_civil_desc as EdoCivilDesc,
	r.fi_ma_escol_id as EscolId,ctescol.fc_escol_desc as EscolDesc 
	FROM @vtRegistros r 
	INNER JOIN SDB.CTSexo cts on cts.fi_sexo_id = r.fi_rn_sexo_id
	INNER JOIN SDB.CTEdoCivil ctciv on ctciv.fi_edo_civil_id = r.fi_ma_edo_civil_id
	INNER JOIN SDB.CTEscolaridad ctescol on ctescol.fi_escol_id = r.fi_ma_escol_id	
	left JOIN SDB.CTLocalidad ctloc on ctloc.fi_loc_edo_id = r.fi_ma_dom_edo_id and ctloc.fi_loc_mpio_id = r.fi_ma_dom_mpio_id and ctloc.fi_loc_id = r.fi_ma_dom_loc_id
	WHERE r.fi_estatus_registro_id = @CONST_SUBREGISTRO_ID

	SELECT 'Oportunos',r.fc_folio_certificado as Folio,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_registro_sic,105) as FechaRegistro,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as FechaNacimiento,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 108) as HoraNacimiento,
	r.fi_rn_sexo_id as SexoId, cts.fc_sexo_desc as SexoDesc,
	r.fc_ma_nombre as Nombre,r.fc_ma_ap_paterno as Paterno,r.fc_ma_ap_materno as Materno,
	r.fi_ma_dom_edo_id as EdoId,ctloc.fc_loc_edo_desc as EdoDesc,
	r.fi_ma_dom_mpio_id as MpioId,ctloc.fc_loc_mpio_desc as MpioDesc,
	r.fi_ma_dom_loc_id as LocId, ctloc.fc_loc_desc as LocDesc,
	r.fc_ma_dom_col as Colonia, r.fc_ma_dom_calle as Calle,r.fc_ma_dom_numext as NoExt, r.fc_ma_dom_numint as NoInt,
	r.fi_ma_edad as Edad,
	r.fi_ma_num_nacimiento as NumNacimiento,
	r.fc_ma_ocupacion as Ocupacion,
	r.fi_ma_edo_civil_id as EdoCivilId, ctciv.fc_edo_civil_desc as EdoCivilDesc,
	r.fi_ma_escol_id as EscolId,ctescol.fc_escol_desc as EscolDesc 
	FROM @vtRegistros r 
	INNER JOIN SDB.CTSexo cts on cts.fi_sexo_id = r.fi_rn_sexo_id
	INNER JOIN SDB.CTEdoCivil ctciv on ctciv.fi_edo_civil_id = r.fi_ma_edo_civil_id
	INNER JOIN SDB.CTEscolaridad ctescol on ctescol.fi_escol_id = r.fi_ma_escol_id	
	left JOIN SDB.CTLocalidad ctloc on ctloc.fi_loc_edo_id = r.fi_ma_dom_edo_id and ctloc.fi_loc_mpio_id = r.fi_ma_dom_mpio_id and ctloc.fi_loc_id = r.fi_ma_dom_loc_id
	WHERE fi_estatus_registro_id = @CONST_OPORTUNO_ID

	SELECT 'Extemporaneos',r.fc_folio_certificado as Folio,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_registro_sic,105) as FechaRegistro,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as FechaNacimiento,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 108) as HoraNacimiento,
	r.fi_rn_sexo_id as SexoId, cts.fc_sexo_desc as SexoDesc,
	r.fc_ma_nombre as Nombre,r.fc_ma_ap_paterno as Paterno,r.fc_ma_ap_materno as Materno,
	r.fi_ma_dom_edo_id as EdoId,ctloc.fc_loc_edo_desc as EdoDesc,
	r.fi_ma_dom_mpio_id as MpioId,ctloc.fc_loc_mpio_desc as MpioDesc,
	r.fi_ma_dom_loc_id as LocId, ctloc.fc_loc_desc as LocDesc,
	r.fc_ma_dom_col as Colonia, r.fc_ma_dom_calle as Calle,r.fc_ma_dom_numext as NoExt, r.fc_ma_dom_numint as NoInt,
	r.fi_ma_edad as Edad,
	r.fi_ma_num_nacimiento as NumNacimiento,
	r.fc_ma_ocupacion as Ocupacion,
	r.fi_ma_edo_civil_id as EdoCivilId, ctciv.fc_edo_civil_desc as EdoCivilDesc,
	r.fi_ma_escol_id as EscolId,ctescol.fc_escol_desc as EscolDesc 
	FROM @vtRegistros r 
	INNER JOIN SDB.CTSexo cts on cts.fi_sexo_id = r.fi_rn_sexo_id
	INNER JOIN SDB.CTEdoCivil ctciv on ctciv.fi_edo_civil_id = r.fi_ma_edo_civil_id
	INNER JOIN SDB.CTEscolaridad ctescol on ctescol.fi_escol_id = r.fi_ma_escol_id	
	left JOIN SDB.CTLocalidad ctloc on ctloc.fi_loc_edo_id = r.fi_ma_dom_edo_id and ctloc.fi_loc_mpio_id = r.fi_ma_dom_mpio_id and ctloc.fi_loc_id = r.fi_ma_dom_loc_id
	WHERE fi_estatus_registro_id = @CONST_EXTEMPORANEO_ID

	SELECT 'Duplicados'
	,r.fc_folio_certificado as Folio,	
	CONVERT(VARCHAR(10), sic.fd_rn_fecha_registro,105) as FechaRegistro,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as FechaNacimiento,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 108) as HoraNacimiento,
	r.fi_rn_sexo_id as SexoId, cts.fc_sexo_desc as SexoDesc,
	r.fc_ma_nombre as Nombre,r.fc_ma_ap_paterno as Paterno,r.fc_ma_ap_materno as Materno,
	r.fi_ma_dom_edo_id as EdoId,ctloc.fc_loc_edo_desc as EdoDesc,
	r.fi_ma_dom_mpio_id as MpioId,ctloc.fc_loc_mpio_desc as MpioDesc,
	r.fi_ma_dom_loc_id as LocId, ctloc.fc_loc_desc as LocDesc,
	r.fc_ma_dom_col as Colonia, r.fc_ma_dom_calle as Calle,r.fc_ma_dom_numext as NoExt, r.fc_ma_dom_numint as NoInt,
	r.fi_ma_edad as Edad,
	r.fi_ma_num_nacimiento as NumNacimiento,
	r.fc_ma_ocupacion as Ocupacion,
	r.fi_ma_edo_civil_id as EdoCivilId, ctciv.fc_edo_civil_desc as EdoCivilDesc,
	r.fi_ma_escol_id as EscolId,ctescol.fc_escol_desc as EscolDesc 
	FROM @vtRegistros r 
	INNER JOIN SDB.TASIC SIC ON r.fc_folio_simple_certificado = SIC.fc_folio_simple_certificado
	INNER JOIN SDB.CTSexo cts on cts.fi_sexo_id = r.fi_rn_sexo_id
	INNER JOIN SDB.CTEdoCivil ctciv on ctciv.fi_edo_civil_id = r.fi_ma_edo_civil_id
	INNER JOIN SDB.CTEscolaridad ctescol on ctescol.fi_escol_id = r.fi_ma_escol_id	
	left JOIN SDB.CTLocalidad ctloc on ctloc.fi_loc_edo_id = r.fi_ma_dom_edo_id and ctloc.fi_loc_mpio_id = r.fi_ma_dom_mpio_id and ctloc.fi_loc_id = r.fi_ma_dom_loc_id
	WHERE fi_estatus_registro_id = 4
	AND SIC.fi_estatus_duplicado = 1
	order by 1 asc

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

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSTotalSINAC') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSTotalSINAC
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que obtiene el total del SINAC
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSTotalSINAC(
@pc_anos VARCHAR(255),  
@pc_meses VARCHAR(255),
@pc_municipios VARCHAR(255),
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 		
	
	SET NOCOUNT ON

BEGIN TRY		
	
	SELECT COUNT(*) AS TotalSINAC
	FROM SDB.TASINAC sinac
	WHERE   
	(
	 --fi_rn_edo_id = 5
	 --fi_estatus_duplicado = 0
	 (@pc_anos IS NULL OR (@pc_anos IS NOT NULL AND YEAR(sinac.fd_rn_fecha_hora_nacimiento) IN (SELECT A.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_anos) A))))  
	 AND (@pc_meses IS NULL OR (@pc_meses IS NOT NULL AND MONTH(sinac.fd_rn_fecha_hora_nacimiento) IN (SELECT M.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_meses) M)))  
	 AND (@pc_municipios IS NULL OR (@pc_municipios IS NOT NULL AND SINAC.fi_rn_mpio_id IN(SELECT Mun.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_municipios) Mun)))  
	
	
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
 
IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSInconsistenciasSIC') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSInconsistenciasSIC
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que obtiene los folios inconsistentes en sic
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSInconsistenciasSIC(
@pc_anos_registro VARCHAR(255),
@pc_anos_nacimiento VARCHAR(255),  
@pc_meses VARCHAR(255),
@pc_municipios VARCHAR(255),
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 	
	
	
	SET NOCOUNT ON

BEGIN TRY		
	
	SELECT 	r.fc_folio_certificado as 'Folio SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as 'Fecha Nacimiento SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_registro, 105) as 'Fecha Registro SIC',
	r.fi_edo_id as 'Estado ID Nacimiento',
	loc.fc_loc_edo_desc as 'Estado Nacimiento',
	r.fi_mpio_id as 'Municipio ID Nacimiento',
	loc.fc_loc_mpio_desc as 'Municipio Nacimiento',
	r.fi_mpio_ofi_id as 'Municipio ID Oficialia',
	ctMpio.fc_mpio_desc as 'Municipio Oficialia',
	r.fi_oficialia_id as 'Oficialia ID'
	FROM sdb.tasic r 
	OUTER APPLY
    (
        SELECT TOP 1 *
        FROM SDB.CTLocalidad ctloc 
        WHERE ctloc.fi_loc_edo_id = r.fi_edo_id and ctloc.fi_loc_mpio_id = r.fi_mpio_id
    ) loc
	left JOIN SDB.CTMunicipio ctMpio on ctMpio.fi_mpio_id = r.fi_mpio_ofi_id
	WHERE 
	r.fi_edo_id = 5 AND
	PATINDEX('%[^a-zA-Z0-9 ]%', r.fc_folio_certificado) <> 0
	AND
	(@pc_anos_registro IS NULL OR (@pc_anos_registro IS NOT NULL AND 
	CAST(r.fc_ano AS INT) IN (SELECT A.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_anos_registro) A)
	)) 
	and
	(@pc_anos_nacimiento IS NULL OR (@pc_anos_nacimiento IS NOT NULL AND
	YEAR(r.fd_rn_fecha_hora_nacimiento) IN (SELECT N.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_anos_nacimiento) N)
	))
	AND (@pc_meses IS NULL OR (@pc_meses IS NOT NULL AND MONTH(r.fd_rn_fecha_hora_nacimiento) IN (SELECT M.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_meses) M)))  
    AND (@pc_municipios IS NULL OR (@pc_municipios IS NOT NULL AND r.fi_mpio_ofi_id IN(SELECT Mun.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_municipios) Mun)))  


	SELECT 	r.fc_folio_certificado as 'Folio SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as 'Fecha Nacimiento SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_registro, 105) as 'Fecha Registro SIC',
	r.fi_edo_id as 'Estado ID Nacimiento',
	loc.fc_loc_edo_desc as 'Estado Nacimiento',
	r.fi_mpio_id as 'Municipio ID Nacimiento',
	loc.fc_loc_mpio_desc as 'Municipio Nacimiento',
	r.fi_mpio_ofi_id as 'Municipio ID Oficialia',
	ctMpio.fc_mpio_desc as 'Municipio Oficialia',
	r.fi_oficialia_id as 'Oficialia ID'
	FROM sdb.tasic r 
	OUTER APPLY
    (
        SELECT TOP 1 *
        FROM SDB.CTLocalidad ctloc 
        WHERE ctloc.fi_loc_edo_id = r.fi_edo_id and ctloc.fi_loc_mpio_id = r.fi_mpio_id
    ) loc
	left JOIN SDB.CTMunicipio ctMpio on ctMpio.fi_mpio_id = r.fi_mpio_ofi_id
	WHERE 
	r.fi_edo_id = 5
	AND r.fi_estatus_duplicado = 1
	AND
	(@pc_anos_registro IS NULL OR (@pc_anos_registro IS NOT NULL AND 
	CAST(r.fc_ano AS INT) IN (SELECT A.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_anos_registro) A)
	)) 
	and
	(@pc_anos_nacimiento IS NULL OR (@pc_anos_nacimiento IS NOT NULL AND
	YEAR(r.fd_rn_fecha_hora_nacimiento) IN (SELECT N.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_anos_nacimiento) N)
	))
	AND (@pc_meses IS NULL OR (@pc_meses IS NOT NULL AND MONTH(r.fd_rn_fecha_hora_nacimiento) IN (SELECT M.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_meses) M)))  
    AND (@pc_municipios IS NULL OR (@pc_municipios IS NOT NULL AND r.fi_mpio_ofi_id IN(SELECT Mun.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_municipios) Mun)))  
 
    
	
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

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSOtrosFoliosSIC') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSOtrosFoliosSIC
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que obtiene registros sic de otros estados o nacidos en otros años
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSOtrosFoliosSIC(
@pc_anos_registro VARCHAR(255),
@pc_anos_nacimiento VARCHAR(255),  
@pc_meses VARCHAR(255),
@pc_municipios VARCHAR(255),
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 	
	
	
	SET NOCOUNT ON

BEGIN TRY		

	SELECT 	r.fc_folio_certificado as 'Folio SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as 'Fecha Nacimiento SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_registro, 105) as 'Fecha Registro SIC',
	r.fi_edo_id as 'Estado ID Nacimiento',
	loc.fc_loc_edo_desc as 'Estado Nacimiento',
	r.fi_mpio_id as 'Municipio ID Nacimiento',
	loc.fc_loc_mpio_desc as 'Municipio Nacimiento',
	r.fi_mpio_ofi_id as 'Municipio ID Oficialia',
	ctMpio.fc_mpio_desc as 'Municipio Oficialia',
	r.fi_oficialia_id as 'Oficialia ID'
	FROM sdb.tasic r 
	OUTER APPLY
    (
        SELECT TOP 1 *
        FROM SDB.CTLocalidad ctloc 
        WHERE ctloc.fi_loc_edo_id = r.fi_edo_id and ctloc.fi_loc_mpio_id = r.fi_mpio_id
    ) loc
	left JOIN SDB.CTMunicipio ctMpio on ctMpio.fi_mpio_id = r.fi_mpio_ofi_id
	WHERE 
	r.fi_edo_id <> 5
	AND
	(@pc_anos_registro IS NULL OR (@pc_anos_registro IS NOT NULL AND 
	CAST(r.fc_ano AS INT) IN (SELECT A.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_anos_registro) A)
	)) 
	and
	(@pc_anos_nacimiento IS NULL OR (@pc_anos_nacimiento IS NOT NULL AND
	YEAR(r.fd_rn_fecha_hora_nacimiento) IN (SELECT N.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_anos_nacimiento) N)
	))
	AND (@pc_meses IS NULL OR (@pc_meses IS NOT NULL AND MONTH(r.fd_rn_fecha_hora_nacimiento) IN (SELECT M.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_meses) M)))  

	  /*Soluciona registros que tienen slash en el certificado*/

	SELECT REPLACE(r.fc_folio_certificado, '/', ' ')  as 'Folio SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as 'Fecha Nacimiento SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_registro, 105) as 'Fecha Registro SIC',
	r.fi_edo_id as 'Estado ID Nacimiento',
	loc.fc_loc_edo_desc as 'Estado Nacimiento',
	r.fi_mpio_id as 'Municipio ID Nacimiento',
	loc.fc_loc_mpio_desc as 'Municipio Nacimiento',
	r.fi_mpio_ofi_id as 'Municipio ID Oficialia',
	ctMpio.fc_mpio_desc as 'Municipio Oficialia',
	r.fi_oficialia_id as 'Oficialia ID'
	FROM sdb.tasic r 
	OUTER APPLY
    (
        SELECT TOP 1 *
        FROM SDB.CTLocalidad ctloc 
        WHERE ctloc.fi_loc_edo_id = r.fi_edo_id and ctloc.fi_loc_mpio_id = r.fi_mpio_id
    ) loc
	left JOIN SDB.CTMunicipio ctMpio on ctMpio.fi_mpio_id = r.fi_mpio_ofi_id
	WHERE 
	(@pc_anos_registro IS NULL OR (@pc_anos_registro IS NOT NULL AND 
	CAST(r.fc_ano AS INT) IN (SELECT A.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_anos_registro) A)
	)) 
	and
	YEAR(r.fd_rn_fecha_hora_nacimiento) < 2015
	AND (@pc_meses IS NULL OR (@pc_meses IS NOT NULL AND MONTH(r.fd_rn_fecha_hora_nacimiento) IN (SELECT M.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_meses) M)))  
    AND (@pc_municipios IS NULL OR (@pc_municipios IS NOT NULL AND r.fi_mpio_ofi_id IN(SELECT Mun.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_municipios) Mun)))  
	
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
 
 IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSCoberturaSIC') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSCoberturaSIC
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que obtiene la covertura de información de sic
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSCoberturaSIC(
@pc_anos_registro VARCHAR(255),
@pc_anos_nacimiento VARCHAR(255),  
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
	
	DECLARE
	@CONST_DUPLICADO_ID INT = 4,
	@CONST_NOREGISTRADO_SINAC_ID INT = 5,    
	@CONST_REGISTRADO_FOLIO_SINAC_ID INT = 6, 
	@CONST_REGISTRADO_FECHA_SINAC_ID INT = 7,   
	@CONST_COAHUILA_EDO_ID INT = 5
	
	SET NOCOUNT ON

BEGIN TRY		
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
	fi_estatus_duplicado_sinac,
	fi_numero_registros,
	fi_tipo_relacionado_sic)   
	SELECT 
	VT.fc_folio_certificado,  
	VT.fc_folio_simple_certificado,  
	VT.fd_rn_fecha_hora_nacimiento,
	VT.fd_rn_fecha_registro, 
	VT.fi_edo_id,  
	VT.fi_mpio_id,
	VT.fi_mpio_ofi_id,
	VT.fi_oficialia_id,
	VT.fc_folio_certificado_sinac, 
	VT.fc_folio_simple_certificado_sinac,  
	VT.fd_rn_fecha_hora_nacimiento_sinac,   
	VT.fi_estatus_registro_id,
	VT.fi_estatus_duplicado_sinac,
	VT.fi_numero_registros,
	VT.fi_tipo_relacionado_sic
	FROM SDB.FNObtieneCoberturaSIC(@pc_anos_registro,@pc_anos_nacimiento,@pc_meses,@pc_municipios) VT

	
	--SELECT 'Totales Subregistro', vt.fi_estatus_registro_id as IdGrupo, ct.fi_estatus_registro_desc as NombreGrupo,count(vt.fi_estatus_registro_id) as Total
	--FROM @vtRegistros vt INNER JOIN SDB.CTEstatusRegistro ct
	--ON vt.fi_estatus_registro_id = ct.fi_estatus_registro_id
	--GROUP BY vt.fi_estatus_registro_id,ct.fi_estatus_registro_desc
	

	--'Registro Oportuno relacionado por folio'
	SELECT 'Registro Oportuno relacionado por folio',
	r.fc_folio_certificado as 'Folio SIC',
	r.fc_folio_certificado_sinac as 'Folio SINAC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as 'Fecha Nacimiento SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento_sinac, 105)  as 'Fecha Nacimiento SINAC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_registro, 105) as 'Fecha Registro SIC',
	r.fi_edo_id as 'Estado ID Nacimiento',
	loc.fc_loc_edo_desc as 'Estado Nacimiento',
	r.fi_mpio_id as 'Municipio ID Nacimiento',
	loc.fc_loc_mpio_desc as 'Municipio Nacimiento',
	r.fi_mpio_ofi_id as 'Municipio ID Oficialia',
	ctMpio.fc_mpio_desc as 'Municipio Oficialia',
	r.fi_oficialia_id as 'Oficialia ID'
	FROM @vtRegistros r 
	OUTER APPLY
    (
        SELECT TOP 1 *
        FROM SDB.CTLocalidad ctloc 
        WHERE ctloc.fi_loc_edo_id = r.fi_edo_id and ctloc.fi_loc_mpio_id = r.fi_mpio_id
    ) loc
	left JOIN SDB.CTMunicipio ctMpio on ctMpio.fi_mpio_id = r.fi_mpio_ofi_id
	WHERE r.fi_tipo_relacionado_sic = 1
	and r.fi_estatus_registro_id = 2

	--'Registro Oportuno relacionado por Fecha'
	SELECT 'Registro Oportuno relacionado por Fecha',
	r.fc_folio_certificado as 'Folio SIC',
	r.fc_folio_certificado_sinac as 'Folio SINAC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as 'Fecha Nacimiento SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento_sinac, 105)  as 'Fecha Nacimiento SINAC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_registro, 105) as 'Fecha Registro SIC',
	r.fi_edo_id as 'Estado ID Nacimiento',
	loc.fc_loc_edo_desc as 'Estado Nacimiento',
	r.fi_mpio_id as 'Municipio ID Nacimiento',
	loc.fc_loc_mpio_desc as 'Municipio Nacimiento',
	r.fi_mpio_ofi_id as 'Municipio ID Oficialia',
	ctMpio.fc_mpio_desc as 'Municipio Oficialia',
	r.fi_oficialia_id as 'Oficialia ID'
	FROM @vtRegistros r 
	OUTER APPLY
    (
        SELECT TOP 1 *
        FROM SDB.CTLocalidad ctloc 
        WHERE ctloc.fi_loc_edo_id = r.fi_edo_id and ctloc.fi_loc_mpio_id = r.fi_mpio_id
    ) loc
	left JOIN SDB.CTMunicipio ctMpio on ctMpio.fi_mpio_id = r.fi_mpio_ofi_id
	WHERE r.fi_tipo_relacionado_sic = 2
	and r.fi_estatus_registro_id = 2

	--'Registro Extemporaneo relacionado por folio'
	SELECT 'Registro Extemporaneo relacionado por folio',
	r.fc_folio_certificado as 'Folio SIC',
	r.fc_folio_certificado_sinac as 'Folio SINAC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as 'Fecha Nacimiento SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento_sinac, 105)  as 'Fecha Nacimiento SINAC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_registro, 105) as 'Fecha Registro SIC',
	r.fi_edo_id as 'Estado ID Nacimiento',
	loc.fc_loc_edo_desc as 'Estado Nacimiento',
	r.fi_mpio_id as 'Municipio ID Nacimiento',
	loc.fc_loc_mpio_desc as 'Municipio Nacimiento',
	r.fi_mpio_ofi_id as 'Municipio ID Oficialia',
	ctMpio.fc_mpio_desc as 'Municipio Oficialia',
	r.fi_oficialia_id as 'Oficialia ID'
	FROM @vtRegistros r 
	OUTER APPLY
    (
        SELECT TOP 1 *
        FROM SDB.CTLocalidad ctloc 
        WHERE ctloc.fi_loc_edo_id = r.fi_edo_id and ctloc.fi_loc_mpio_id = r.fi_mpio_id
    ) loc
	left JOIN SDB.CTMunicipio ctMpio on ctMpio.fi_mpio_id = r.fi_mpio_ofi_id
	WHERE r.fi_tipo_relacionado_sic = 1
	and r.fi_estatus_registro_id = 3

	--'Registro Extemporaneo relacionado por Fecha'
	SELECT 'Registro Extemporaneo relacionado por Fecha',
	r.fc_folio_certificado as 'Folio SIC',
	r.fc_folio_certificado_sinac as 'Folio SINAC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as 'Fecha Nacimiento SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento_sinac, 105)  as 'Fecha Nacimiento SINAC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_registro, 105) as 'Fecha Registro SIC',
	r.fi_edo_id as 'Estado ID Nacimiento',
	loc.fc_loc_edo_desc as 'Estado Nacimiento',
	r.fi_mpio_id as 'Municipio ID Nacimiento',
	loc.fc_loc_mpio_desc as 'Municipio Nacimiento',
	r.fi_mpio_ofi_id as 'Municipio ID Oficialia',
	ctMpio.fc_mpio_desc as 'Municipio Oficialia',
	r.fi_oficialia_id as 'Oficialia ID'
	FROM @vtRegistros r 
	OUTER APPLY
    (
        SELECT TOP 1 *
        FROM SDB.CTLocalidad ctloc 
        WHERE ctloc.fi_loc_edo_id = r.fi_edo_id and ctloc.fi_loc_mpio_id = r.fi_mpio_id
    ) loc
	left JOIN SDB.CTMunicipio ctMpio on ctMpio.fi_mpio_id = r.fi_mpio_ofi_id
	WHERE r.fi_tipo_relacionado_sic = 2
	and r.fi_estatus_registro_id = 3

	--Registros oportunos sólo SIC - sin relacion SINAC
	SELECT 'Registros oportunos sin relacion SINAC',
	r.fc_folio_certificado as 'Folio SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as 'Fecha Nacimiento SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_registro, 105) as 'Fecha Registro SIC',
	r.fi_edo_id as 'Estado ID Nacimiento',
	loc.fc_loc_edo_desc as 'Estado Nacimiento',
	r.fi_mpio_id as 'Municipio ID Nacimiento',
	loc.fc_loc_mpio_desc as 'Municipio Nacimiento',
	r.fi_mpio_ofi_id as 'Municipio ID Oficialia',
	ctMpio.fc_mpio_desc as 'Municipio Oficialia',
	r.fi_oficialia_id as 'Oficialia ID'
	FROM @vtRegistros r 
	OUTER APPLY
    (
        SELECT TOP 1 *
        FROM SDB.CTLocalidad ctloc 
        WHERE ctloc.fi_loc_edo_id = r.fi_edo_id and ctloc.fi_loc_mpio_id = r.fi_mpio_id
    ) loc
	left JOIN SDB.CTMunicipio ctMpio on ctMpio.fi_mpio_id = r.fi_mpio_ofi_id
	WHERE r.fi_tipo_relacionado_sic = 0
	and r.fi_estatus_registro_id = 2

	--Registros extemporaneos sólo SIC - sin relacion SINAC
	SELECT 'Registros extemporaneos sólo SIC',
	r.fc_folio_certificado as 'Folio SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as 'Fecha Nacimiento SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_registro, 105) as 'Fecha Registro SIC',
	r.fi_edo_id as 'Estado ID Nacimiento',
	loc.fc_loc_edo_desc as 'Estado Nacimiento',
	r.fi_mpio_id as 'Municipio ID Nacimiento',
	loc.fc_loc_mpio_desc as 'Municipio Nacimiento',
	r.fi_mpio_ofi_id as 'Municipio ID Oficialia',
	ctMpio.fc_mpio_desc as 'Municipio Oficialia',
	r.fi_oficialia_id as 'Oficialia ID'
	FROM @vtRegistros r 
	OUTER APPLY
    (
        SELECT TOP 1 *
        FROM SDB.CTLocalidad ctloc 
        WHERE ctloc.fi_loc_edo_id = r.fi_edo_id and ctloc.fi_loc_mpio_id = r.fi_mpio_id
    ) loc
	left JOIN SDB.CTMunicipio ctMpio on ctMpio.fi_mpio_id = r.fi_mpio_ofi_id
	WHERE r.fi_tipo_relacionado_sic = 0
	and r.fi_estatus_registro_id = 3

	
	----'Duplicados'
	--SELECT
	--r.fc_folio_certificado as 'Folio SIC',
	--CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as 'Fecha Nacimiento SIC',
	--CONVERT(VARCHAR(10), r.fd_rn_fecha_registro, 105) as 'Fecha Registro SIC',
	--r.fi_edo_id as 'Estado ID Nacimiento',
	--loc.fc_loc_edo_desc as 'Estado Nacimiento',
	--r.fi_mpio_id as 'Municipio ID Nacimiento',
	--loc.fc_loc_mpio_desc as 'Municipio Nacimiento',
	--r.fi_mpio_ofi_id as 'Municipio ID Oficialia',
	--ctMpio.fc_mpio_desc as 'Municipio Oficialia',
	--r.fi_oficialia_id as 'Oficialia ID'
	--FROM @vtRegistros r 
	--OUTER APPLY
 --   (
 --       SELECT TOP 1 *
 --       FROM SDB.CTLocalidad ctloc 
 --       WHERE ctloc.fi_loc_edo_id = r.fi_edo_id and ctloc.fi_loc_mpio_id = r.fi_mpio_id
 --   ) loc
	--left JOIN SDB.CTMunicipio ctMpio on ctMpio.fi_mpio_id = r.fi_mpio_ofi_id 
	--WHERE r.fi_estatus_registro_id = @CONST_DUPLICADO_ID

	----SinSINAC
	--SELECT
	--r.fc_folio_certificado as 'Folio SIC',
	--CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as 'Fecha Nacimiento SIC',
	--CONVERT(VARCHAR(10), r.fd_rn_fecha_registro, 105) as 'Fecha Registro SIC',
	--r.fi_edo_id as 'Estado ID Nacimiento',
	--loc.fc_loc_edo_desc as 'Estado Nacimiento',
	--r.fi_mpio_id as 'Municipio ID Nacimiento',
	--loc.fc_loc_mpio_desc as 'Municipio Nacimiento',
	--r.fi_mpio_ofi_id as 'Municipio ID Oficialia',
	--ctMpio.fc_mpio_desc as 'Municipio Oficialia',
	--r.fi_oficialia_id as 'Oficialia ID'
	--FROM @vtRegistros r 
	--OUTER APPLY
 --   (
 --       SELECT TOP 1 *
 --       FROM SDB.CTLocalidad ctloc 
 --       WHERE ctloc.fi_loc_edo_id = r.fi_edo_id and ctloc.fi_loc_mpio_id = r.fi_mpio_id
 --   ) loc
	--left JOIN SDB.CTMunicipio ctMpio on ctMpio.fi_mpio_id = r.fi_mpio_ofi_id
	--WHERE r.fi_estatus_registro_id = @CONST_NOREGISTRADO_SINAC_ID
	
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

 IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSAnalisisInfoSIC') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSAnalisisInfoSIC
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que obtiene el análisis de información de sic
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSAnalisisInfoSIC(
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
	fd_rn_fecha_registro datetime,   
	fi_edo_id int,  
	fi_mpio_id int,
	fi_mpio_ofi_id int,
	fi_oficialia_id int,
	fc_folio_certificado_sinac varchar(20),  
	fc_folio_simple_certificado_sinac varchar(20),  
	fd_rn_fecha_hora_nacimiento_sinac datetime,   
	fi_estatus_registro_id int NOT NULL
	)
	
	DECLARE
	@CONST_DUPLICADO_ID INT = 4,
	@CONST_NOREGISTRADO_SINAC_ID INT = 5,    
	@CONST_REGISTRADO_FOLIO_SINAC_ID INT = 6, 
	@CONST_REGISTRADO_FECHA_SINAC_ID INT = 7,   
	@CONST_COAHUILA_EDO_ID INT = 5
	
	SET NOCOUNT ON

BEGIN TRY		
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
	fi_estatus_registro_id)
	SELECT 
	VT.fc_folio_certificado,  
	VT.fc_folio_simple_certificado,  
	VT.fd_rn_fecha_hora_nacimiento,
	VT.fd_rn_fecha_registro, 
	VT.fi_edo_id,  
	VT.fi_mpio_id,
	VT.fi_mpio_ofi_id,
	VT.fi_oficialia_id,
	VT.fc_folio_certificado_sinac, 
	VT.fc_folio_simple_certificado_sinac,  
	VT.fd_rn_fecha_hora_nacimiento_sinac,   
	VT.fi_estatus_registro_id
	FROM SDB.FNObtieneTablaSICAnalisis(@pc_anos,@pc_meses,@pc_municipios) VT

	
	SELECT 'Totales Subregistro', vt.fi_estatus_registro_id as IdGrupo, ct.fi_estatus_registro_desc as NombreGrupo,count(vt.fi_estatus_registro_id) as Total
	FROM @vtRegistros vt INNER JOIN SDB.CTEstatusRegistro ct
	ON vt.fi_estatus_registro_id = ct.fi_estatus_registro_id
	GROUP BY vt.fi_estatus_registro_id,ct.fi_estatus_registro_desc
	

	--'PorFolio'
	SELECT 
	r.fc_folio_certificado as 'Folio SIC',
	r.fc_folio_certificado_sinac as 'Folio SINAC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as 'Fecha Nacimiento SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento_sinac, 105)  as 'Fecha Nacimiento SINAC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_registro, 105) as 'Fecha Registro SIC',
	r.fi_edo_id as 'Estado ID Nacimiento',
	loc.fc_loc_edo_desc as 'Estado Nacimiento',
	r.fi_mpio_id as 'Municipio ID Nacimiento',
	loc.fc_loc_mpio_desc as 'Municipio Nacimiento',
	r.fi_mpio_ofi_id as 'Municipio ID Oficialia',
	ctMpio.fc_mpio_desc as 'Municipio Oficialia',
	r.fi_oficialia_id as 'Oficialia ID'
	FROM @vtRegistros r 
	OUTER APPLY
    (
        SELECT TOP 1 *
        FROM SDB.CTLocalidad ctloc 
        WHERE ctloc.fi_loc_edo_id = r.fi_edo_id and ctloc.fi_loc_mpio_id = r.fi_mpio_id
    ) loc
	left JOIN SDB.CTMunicipio ctMpio on ctMpio.fi_mpio_id = r.fi_mpio_ofi_id
	WHERE r.fi_estatus_registro_id = @CONST_REGISTRADO_FOLIO_SINAC_ID

	--'PorFecha',
	SELECT 
	r.fc_folio_certificado as 'Folio SIC',
	r.fc_folio_certificado_sinac as 'Folio SINAC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as 'Fecha Nacimiento SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento_sinac, 105)  as 'Fecha Nacimiento SINAC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_registro, 105) as 'Fecha Registro SIC',
	r.fi_edo_id as 'Estado ID Nacimiento',
	loc.fc_loc_edo_desc as 'Estado Nacimiento',
	r.fi_mpio_id as 'Municipio ID Nacimiento',
	loc.fc_loc_mpio_desc as 'Municipio Nacimiento',
	r.fi_mpio_ofi_id as 'Municipio ID Oficialia',
	ctMpio.fc_mpio_desc as 'Municipio Oficialia',
	r.fi_oficialia_id as 'Oficialia ID'
	FROM @vtRegistros r 
	OUTER APPLY
    (
        SELECT TOP 1 *
        FROM SDB.CTLocalidad ctloc 
        WHERE ctloc.fi_loc_edo_id = r.fi_edo_id and ctloc.fi_loc_mpio_id = r.fi_mpio_id
    ) loc
	left JOIN SDB.CTMunicipio ctMpio on ctMpio.fi_mpio_id = r.fi_mpio_ofi_id
	WHERE r.fi_estatus_registro_id = @CONST_REGISTRADO_FECHA_SINAC_ID

	--'Duplicados'
	SELECT
	r.fc_folio_certificado as 'Folio SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as 'Fecha Nacimiento SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_registro, 105) as 'Fecha Registro SIC',
	r.fi_edo_id as 'Estado ID Nacimiento',
	loc.fc_loc_edo_desc as 'Estado Nacimiento',
	r.fi_mpio_id as 'Municipio ID Nacimiento',
	loc.fc_loc_mpio_desc as 'Municipio Nacimiento',
	r.fi_mpio_ofi_id as 'Municipio ID Oficialia',
	ctMpio.fc_mpio_desc as 'Municipio Oficialia',
	r.fi_oficialia_id as 'Oficialia ID'
	FROM @vtRegistros r 
	OUTER APPLY
    (
        SELECT TOP 1 *
        FROM SDB.CTLocalidad ctloc 
        WHERE ctloc.fi_loc_edo_id = r.fi_edo_id and ctloc.fi_loc_mpio_id = r.fi_mpio_id
    ) loc
	left JOIN SDB.CTMunicipio ctMpio on ctMpio.fi_mpio_id = r.fi_mpio_ofi_id 
	WHERE r.fi_estatus_registro_id = @CONST_DUPLICADO_ID

	--SinSINAC
	SELECT
	r.fc_folio_certificado as 'Folio SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as 'Fecha Nacimiento SIC',
	CONVERT(VARCHAR(10), r.fd_rn_fecha_registro, 105) as 'Fecha Registro SIC',
	r.fi_edo_id as 'Estado ID Nacimiento',
	loc.fc_loc_edo_desc as 'Estado Nacimiento',
	r.fi_mpio_id as 'Municipio ID Nacimiento',
	loc.fc_loc_mpio_desc as 'Municipio Nacimiento',
	r.fi_mpio_ofi_id as 'Municipio ID Oficialia',
	ctMpio.fc_mpio_desc as 'Municipio Oficialia',
	r.fi_oficialia_id as 'Oficialia ID'
	FROM @vtRegistros r 
	OUTER APPLY
    (
        SELECT TOP 1 *
        FROM SDB.CTLocalidad ctloc 
        WHERE ctloc.fi_loc_edo_id = r.fi_edo_id and ctloc.fi_loc_mpio_id = r.fi_mpio_id
    ) loc
	left JOIN SDB.CTMunicipio ctMpio on ctMpio.fi_mpio_id = r.fi_mpio_ofi_id
	WHERE r.fi_estatus_registro_id = @CONST_NOREGISTRADO_SINAC_ID
	
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


IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSReporteXMLSubregistroMunicipios') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSReporteXMLSubregistroMunicipios
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que obtiene el reporte por municipios
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSReporteXMLSubregistroMunicipios(
@pc_anos VARCHAR(255),
@pc_meses VARCHAR(255),
@pc_municipios VARCHAR(255),
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 			
	DECLARE 
	@CONST_COAHUILA_EDO_ID INT = 5
	
	SET NOCOUNT ON

BEGIN TRY		

	SELECT  fi_ma_dom_mpio_id as 'IDA0Municipio',Municipio,ISNULL([1],0) as 'TotalA0Subregistro',ISNULL([2],0) as 'TotalA0RegistroA0Oportuno',ISNULL([3],0)  as 'TotalA0RegistroA0Extemporaneo',ISNULL([4],0)  as 'TotalA0RegistroA0Duplicado'
	FROM    (	
	SELECT vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc AS Municipio, vt.fi_estatus_registro_id as IdGrupo,count(vt.fi_estatus_registro_id) as Total
	FROM SDB.FNObtieneTablaSubregistro(@pc_anos,@pc_meses,@pc_municipios) vt 
	INNER JOIN SDB.CTMunicipio ctM ON vt.fi_ma_dom_mpio_id = ctM.fi_mpio_id	
	GROUP BY vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_estatus_registro_id
	)s
	PIVOT   (SUM(Total) FOR IdGrupo IN ([1] ,[2], [3], [4])) pvt	
	FOR XML PATH('Fila'), ROOT('Reporte')	

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


IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSReporteTotalesMunicipios') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSReporteTotalesMunicipios
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que obtiene el reporte por municipios
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSReporteTotalesMunicipios(
@pc_anos VARCHAR(255),
@pc_meses VARCHAR(255),
@pc_municipios VARCHAR(255),
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 			
	DECLARE 
	@CONST_COAHUILA_EDO_ID INT = 5
	
	SET NOCOUNT ON

BEGIN TRY		

	SELECT  fi_ma_dom_mpio_id As IdMunicipio,fc_mpio_desc as MpioDesc,ISNULL([1],0) as 'TotalSubregistro',ISNULL([2],0) as 'TotalRegistroOportuno',ISNULL([3],0)  as 'TotalRegistroExtemporaneo'
	FROM    (	
	SELECT vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc, vt.fi_estatus_registro_id as IdGrupo,count(vt.fi_estatus_registro_id) as Total
	FROM SDB.FNObtieneTablaSubregistro(@pc_anos,@pc_meses,@pc_municipios) vt 
	INNER JOIN SDB.CTMunicipio ctM ON vt.fi_ma_dom_mpio_id = ctM.fi_mpio_id	
	GROUP BY vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_estatus_registro_id
	)s
	PIVOT   (SUM(Total) FOR IdGrupo IN ([1] ,[2], [3])) pvt	
	
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


IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSReporteEdadSubregistroMunicipios') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSReporteEdadSubregistroMunicipios
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que obtiene el reporte por edades de los nacimientos a través de parámetros de búsqueda
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSReporteEdadSubregistroMunicipios(
@pc_anos VARCHAR(255),
@pc_meses VARCHAR(255),
@pc_municipios VARCHAR(400),
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 	
	
	DECLARE 
	@CONST_SUBREGISTRO_ID INT = 1,
	@CONST_OPORTUNO_ID INT = 2,
	@CONST_EXTEMPORANEO_ID INT = 3,
	@CONST_DUPLICADO_ID INT = 4,
	@CONST_COAHUILA_EDO_ID INT = 5
			
	SET NOCOUNT ON

BEGIN TRY		
	DECLARE 
	@colPivote NVARCHAR(MAX),@colNombre NVARCHAR(MAX),@sql NVARCHAR(MAX)
	SELECT @colPivote = N'', @colNombre = N''
	SELECT @colNombre += N', isnull(p.' + QUOTENAME(fi_ma_edad)+', 0) as '''+ REPLACE(QUOTENAME(fi_ma_edad,'"'),'"','')+' años''',
	@colPivote += N', ' + QUOTENAME(fi_ma_edad)
	  FROM (
	  SELECT DISTINCT(fi_ma_edad) FROM sdb.tasinac
	  WHERE 
	  (@pc_anos IS NULL OR (@pc_anos IS NOT NULL AND YEAR(fd_rn_fecha_hora_nacimiento) IN (SELECT A.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_anos) A)))
		AND (@pc_meses IS NULL OR (@pc_meses IS NOT NULL AND MONTH(fd_rn_fecha_hora_nacimiento) IN (SELECT M.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_meses) M)))
		AND (@pc_municipios IS NULL OR (fi_rn_mpio_id IN(SELECT Mun.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_municipios) Mun)))
	  ) AS x order by fi_ma_edad asc;
	SET @sql = N'
	DECLARE 
	@vc_anos VARCHAR(255),
	@vc_meses VARCHAR(255),
	@vc_municipios VARCHAR(400)'

	IF(@pc_anos IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @vc_anos =''' + @pc_anos + ''''
	END
	
	IF(@pc_meses IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @vc_meses =''' + @pc_meses + ''''
	END

	IF(@pc_municipios IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @vc_municipios =''' + @pc_municipios + ''''
	END

	SET @sql = @sql + '	SELECT fi_ma_dom_mpio_id as ''ID Municipio'',Municipio,' + STUFF(@colNombre, 1, 2, '') + '
	FROM
	(
		SELECT vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc AS Municipio,vt.fi_ma_edad AS Edad,count(vt.fi_ma_edad) as Total
		FROM SDB.FNObtieneTablaSubregistro(@vc_anos,@vc_meses,@vc_municipios) vt 
		INNER JOIN SDB.CTMunicipio ctM ON vt.fi_ma_dom_mpio_id = ctM.fi_mpio_id
		WHERE vt.fi_estatus_registro_id = 1
		GROUP BY vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_ma_edad
	) AS j
	PIVOT
	(
	  SUM(Total) FOR Edad IN ('
	  + STUFF(@colPivote, 1, 1, '')
	  + ')
	) AS p';--  FOR XML PATH(''Fila''), ROOT(''Reporte'')' ;
	PRINT @sql;
	EXEC sp_executesql @sql;

	SET @sql = N'
	DECLARE 
	@vc_anos VARCHAR(255),
	@vc_meses VARCHAR(255),
	@vc_municipios VARCHAR(400)'

	IF(@pc_anos IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @vc_anos =''' + @pc_anos + ''''
	END
	
	IF(@pc_meses IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @vc_meses =''' + @pc_meses + ''''
	END

	IF(@pc_municipios IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @vc_municipios =''' + @pc_municipios + ''''
	END

	SET @sql = @sql + '	SELECT fi_ma_dom_mpio_id as ''ID Municipio'',Municipio,' + STUFF(@colNombre, 1, 2, '') + '
	FROM
	(
		SELECT vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc AS Municipio,vt.fi_ma_edad AS Edad,count(vt.fi_ma_edad) as Total
		FROM SDB.FNObtieneTablaSubregistro(@vc_anos,@vc_meses,@vc_municipios) vt 
		INNER JOIN SDB.CTMunicipio ctM ON vt.fi_ma_dom_mpio_id = ctM.fi_mpio_id
		WHERE vt.fi_estatus_registro_id = 2
		GROUP BY vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_ma_edad
	) AS j
	PIVOT
	(
	  SUM(Total) FOR Edad IN ('
	  + STUFF(@colPivote, 1, 1, '')
	  + ')
	) AS p';--  FOR XML PATH(''Fila''), ROOT(''Reporte'')' ;
	PRINT @sql;
	EXEC sp_executesql @sql;

		SET @sql = N'
	DECLARE 
	@vc_anos VARCHAR(255),
	@vc_meses VARCHAR(255),
	@vc_municipios VARCHAR(400)'

	IF(@pc_anos IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @vc_anos =''' + @pc_anos + ''''
	END
	
	IF(@pc_meses IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @vc_meses =''' + @pc_meses + ''''
	END

	IF(@pc_municipios IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @vc_municipios =''' + @pc_municipios + ''''
	END

	SET @sql = @sql + '	SELECT fi_ma_dom_mpio_id as ''ID Municipio'',Municipio,' + STUFF(@colNombre, 1, 2, '') + '
	FROM
	(
		SELECT vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc AS Municipio,vt.fi_ma_edad AS Edad,count(vt.fi_ma_edad) as Total
		FROM SDB.FNObtieneTablaSubregistro(@vc_anos,@vc_meses,@vc_municipios) vt 
		INNER JOIN SDB.CTMunicipio ctM ON vt.fi_ma_dom_mpio_id = ctM.fi_mpio_id
		WHERE vt.fi_estatus_registro_id = 3
		GROUP BY vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_ma_edad
	) AS j
	PIVOT
	(
	  SUM(Total) FOR Edad IN ('
	  + STUFF(@colPivote, 1, 1, '')
	  + ')
	) AS p';--  FOR XML PATH(''Fila''), ROOT(''Reporte'')' ;
	PRINT @sql;
	EXEC sp_executesql @sql;


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

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSReporteEscolaridadSubregistroMunicipios') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSReporteEscolaridadSubregistroMunicipios
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que obtiene el reporte por municipios
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSReporteEscolaridadSubregistroMunicipios(
@pc_anos VARCHAR(255),
@pc_meses VARCHAR(255),
@pc_municipios VARCHAR(255),
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 			
	
	SET NOCOUNT ON

BEGIN TRY		
	
	SELECT  fi_ma_dom_mpio_id as 'ID Municipio',fc_mpio_desc AS Municipio,ISNULL([1],0) as NINGUNA,ISNULL([2],0) as 'PRIMARIA INCOMPLETA',ISNULL([3],0) as 'PRIMARIA COMPLETA',ISNULL([4],0) as 'SECUNDARIA INCOMPLETA',ISNULL([5],0) as 'SECUNDARIA COMPLETA',ISNULL([6],0) as 'BACHILLERATO O PREPARATORIA INCOMPLETA',ISNULL([7],0) as 'BACHILLERATO O PREPARATORIA COMPLETA',ISNULL([8],0) as 'PROFESIONAL',ISNULL([10],0) as 'POSGRADO',ISNULL([11],0) as 'PROFESIONAL INCOMPLETO',ISNULL([12],0) as 'POSGRADO INCOMPLETO',ISNULL([88],0) as 'N.E.',ISNULL([99],0) as 'S.I.'
	--SELECT  fi_rn_mpio_id as 'ID Municipio',fc_mpio_desc AS Municipio,[1] as NINGUNA,[2] as 'PRIMARIA INCOMPLETA',[3] as 'PRIMARIA COMPLETA',[4] as 'SECUNDARIA INCOMPLETA',[5] as 'SECUNDARIA COMPLETA',[6] as 'BACHILLERATO O PREPARATORIA INCOMPLETA',[7] as 'BACHILLERATO O PREPARATORIA COMPLETA',[8] as 'PROFESIONAL',[10] as 'POSGRADO',[11] as 'PROFESIONAL INCOMPLETO',[12] as 'POSGRADO INCOMPLETO',[88] as 'N.E.',[99] as 'S.I.'
	FROM    (	
	SELECT vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc, vt.fi_ma_escol_id,count(vt.fi_ma_escol_id) as Total
	FROM SDB.FNObtieneTablaSubregistro(@pc_anos,@pc_meses,@pc_municipios) vt 
	INNER JOIN SDB.CTMunicipio ctM ON vt.fi_ma_dom_mpio_id = ctM.fi_mpio_id	
	WHERE vt.fi_estatus_registro_id = 1
	GROUP BY vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_ma_escol_id
	)s
	PIVOT   (SUM(Total) FOR fi_ma_escol_id IN ([1] ,[2], [3], [4], [5], [6], [7], [8], [10], [11], [12], [88], [99])) pvt	

	SELECT  fi_ma_dom_mpio_id as 'ID Municipio',fc_mpio_desc AS Municipio,ISNULL([1],0) as NINGUNA,ISNULL([2],0) as 'PRIMARIA INCOMPLETA',ISNULL([3],0) as 'PRIMARIA COMPLETA',ISNULL([4],0) as 'SECUNDARIA INCOMPLETA',ISNULL([5],0) as 'SECUNDARIA COMPLETA',ISNULL([6],0) as 'BACHILLERATO O PREPARATORIA INCOMPLETA',ISNULL([7],0) as 'BACHILLERATO O PREPARATORIA COMPLETA',ISNULL([8],0) as 'PROFESIONAL',ISNULL([10],0) as 'POSGRADO',ISNULL([11],0) as 'PROFESIONAL INCOMPLETO',ISNULL([12],0) as 'POSGRADO INCOMPLETO',ISNULL([88],0) as 'N.E.',ISNULL([99],0) as 'S.I.'
	FROM    (	
	SELECT vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc, vt.fi_ma_escol_id,count(vt.fi_ma_escol_id) as Total
	FROM SDB.FNObtieneTablaSubregistro(@pc_anos,@pc_meses,@pc_municipios) vt 
	INNER JOIN SDB.CTMunicipio ctM ON vt.fi_ma_dom_mpio_id = ctM.fi_mpio_id	
	WHERE vt.fi_estatus_registro_id = 2
	GROUP BY vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_ma_escol_id
	)s
	PIVOT   (SUM(Total) FOR fi_ma_escol_id IN ([1] ,[2], [3], [4], [5], [6], [7], [8], [10], [11], [12], [88], [99])) pvt	

	SELECT  fi_ma_dom_mpio_id as 'ID Municipio',fc_mpio_desc AS Municipio,ISNULL([1],0) as NINGUNA,ISNULL([2],0) as 'PRIMARIA INCOMPLETA',ISNULL([3],0) as 'PRIMARIA COMPLETA',ISNULL([4],0) as 'SECUNDARIA INCOMPLETA',ISNULL([5],0) as 'SECUNDARIA COMPLETA',ISNULL([6],0) as 'BACHILLERATO O PREPARATORIA INCOMPLETA',ISNULL([7],0) as 'BACHILLERATO O PREPARATORIA COMPLETA',ISNULL([8],0) as 'PROFESIONAL',ISNULL([10],0) as 'POSGRADO',ISNULL([11],0) as 'PROFESIONAL INCOMPLETO',ISNULL([12],0) as 'POSGRADO INCOMPLETO',ISNULL([88],0) as 'N.E.',ISNULL([99],0) as 'S.I.'
	FROM    (	
	SELECT vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc, vt.fi_ma_escol_id,count(vt.fi_ma_escol_id) as Total
	FROM SDB.FNObtieneTablaSubregistro(@pc_anos,@pc_meses,@pc_municipios) vt 
	INNER JOIN SDB.CTMunicipio ctM ON vt.fi_ma_dom_mpio_id = ctM.fi_mpio_id	
	WHERE vt.fi_estatus_registro_id = 3
	GROUP BY vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_ma_escol_id
	)s
	PIVOT   (SUM(Total) FOR fi_ma_escol_id IN ([1] ,[2], [3], [4], [5], [6], [7], [8], [10], [11], [12], [88], [99])) pvt	
	
	
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

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSReporteSexoSubregistroMunicipios') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSReporteSexoSubregistroMunicipios
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que obtiene el reporte por municipios
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSReporteSexoSubregistroMunicipios(
@pc_anos VARCHAR(255),
@pc_meses VARCHAR(255),
@pc_municipios VARCHAR(255),
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 			
	
	SET NOCOUNT ON

BEGIN TRY		
	
	SELECT  fi_ma_dom_mpio_id as 'ID Municipio',fc_mpio_desc AS Municipio,ISNULL([1],0) as 'Hombre',ISNULL([2],0) as 'Mujer',ISNULL([3],0)  as 'Sin Información'
	FROM    (	
	SELECT vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_rn_sexo_id,count(vt.fi_rn_sexo_id) as Total
	FROM SDB.FNObtieneTablaSubregistro(@pc_anos,@pc_meses,@pc_municipios) vt 
	INNER JOIN SDB.CTMunicipio ctM ON vt.fi_ma_dom_mpio_id = ctM.fi_mpio_id
	WHERE vt.fi_estatus_registro_id = 1	
	GROUP BY vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_rn_sexo_id
	)s
	PIVOT   (SUM(Total) FOR fi_rn_sexo_id IN ([1] ,[2], [3])) pvt	

	SELECT  fi_ma_dom_mpio_id as 'ID Municipio',fc_mpio_desc AS Municipio,ISNULL([1],0) as 'Hombre',ISNULL([2],0) as 'Mujer',ISNULL([3],0)  as 'Sin Información'
	FROM    (	
	SELECT vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_rn_sexo_id,count(vt.fi_rn_sexo_id) as Total
	FROM SDB.FNObtieneTablaSubregistro(@pc_anos,@pc_meses,@pc_municipios) vt 
	INNER JOIN SDB.CTMunicipio ctM ON vt.fi_ma_dom_mpio_id = ctM.fi_mpio_id
	WHERE vt.fi_estatus_registro_id = 2	
	GROUP BY vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_rn_sexo_id
	)s
	PIVOT   (SUM(Total) FOR fi_rn_sexo_id IN ([1] ,[2], [3])) pvt	
	

	SELECT  fi_ma_dom_mpio_id as 'ID Municipio' ,fc_mpio_desc AS Municipio,ISNULL([1],0) as 'Hombre',ISNULL([2],0) as 'Mujer',ISNULL([3],0)  as 'Sin Información'
	FROM    (	
	SELECT vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_rn_sexo_id,count(vt.fi_rn_sexo_id) as Total
	FROM SDB.FNObtieneTablaSubregistro(@pc_anos,@pc_meses,@pc_municipios) vt 
	INNER JOIN SDB.CTMunicipio ctM ON vt.fi_ma_dom_mpio_id = ctM.fi_mpio_id
	WHERE vt.fi_estatus_registro_id = 3	
	GROUP BY vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_rn_sexo_id
	)s
	PIVOT   (SUM(Total) FOR fi_rn_sexo_id IN ([1] ,[2], [3])) pvt
		
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


IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSReporteEdoCivilSubregistroMunicipios') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSReporteEdoCivilSubregistroMunicipios
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que obtiene el reporte por municipios
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSReporteEdoCivilSubregistroMunicipios(
@pc_anos VARCHAR(255),
@pc_meses VARCHAR(255),
@pc_municipios VARCHAR(255),
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 			
	
	SET NOCOUNT ON

BEGIN TRY		
	--SELECT fi_edo_civil_id,fc_edo_civil_desc FROM SDB.CTEdoCivil

	SELECT  fi_ma_dom_mpio_id as 'ID Municipio',Municipio,ISNULL([11],0) as CASADA,ISNULL([12],0) as SOLTERA,ISNULL([13],0) as DIVORCIADA,ISNULL([14],0) as VIUDA,ISNULL([15],0) as 'UNIÓN LIBRE',ISNULL([16],0) as SEPARADA,ISNULL([88],0) as 'N.E.',ISNULL([99],0) as 'S.I.'
	FROM    (	
	SELECT vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc AS Municipio, vt.fi_ma_edo_civil_id as IdEdoCivil,count(vt.fi_ma_edo_civil_id) as Total
	FROM SDB.FNObtieneTablaSubregistro(@pc_anos,@pc_meses,@pc_municipios) vt 
	INNER JOIN SDB.CTMunicipio ctM ON vt.fi_ma_dom_mpio_id = ctM.fi_mpio_id	
	WHERE vt.fi_estatus_registro_id = 1
	GROUP BY vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_ma_edo_civil_id
	)s
	PIVOT   (SUM(Total) FOR IdEdoCivil IN ([11] ,[12], [13], [14], [15], [16], [88], [99])) pvt	

	SELECT  fi_ma_dom_mpio_id as 'ID Municipio',Municipio,ISNULL([11],0) as CASADA,ISNULL([12],0) as SOLTERA,ISNULL([13],0) as DIVORCIADA,ISNULL([14],0) as VIUDA,ISNULL([15],0) as 'UNIÓN LIBRE',ISNULL([16],0) as SEPARADA,ISNULL([88],0) as 'N.E.',ISNULL([99],0) as 'S.I.'
	FROM    (	
	SELECT vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc AS Municipio, vt.fi_ma_edo_civil_id as IdEdoCivil,count(vt.fi_ma_edo_civil_id) as Total
	FROM SDB.FNObtieneTablaSubregistro(@pc_anos,@pc_meses,@pc_municipios) vt 
	INNER JOIN SDB.CTMunicipio ctM ON vt.fi_ma_dom_mpio_id = ctM.fi_mpio_id	
	WHERE vt.fi_estatus_registro_id = 2
	GROUP BY vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_ma_edo_civil_id
	)s
	PIVOT   (SUM(Total) FOR IdEdoCivil IN ([11] ,[12], [13], [14], [15], [16], [88], [99])) pvt	

	SELECT  fi_ma_dom_mpio_id as 'ID Municipio',Municipio,ISNULL([11],0) as CASADA,ISNULL([12],0) as SOLTERA,ISNULL([13],0) as DIVORCIADA,ISNULL([14],0) as VIUDA,ISNULL([15],0) as 'UNIÓN LIBRE',ISNULL([16],0) as SEPARADA,ISNULL([88],0) as 'N.E.',ISNULL([99],0) as 'S.I.'
	FROM    (	
	SELECT vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc AS Municipio, vt.fi_ma_edo_civil_id as IdEdoCivil,count(vt.fi_ma_edo_civil_id) as Total
	FROM SDB.FNObtieneTablaSubregistro(@pc_anos,@pc_meses,@pc_municipios) vt 
	INNER JOIN SDB.CTMunicipio ctM ON vt.fi_ma_dom_mpio_id = ctM.fi_mpio_id	
	WHERE vt.fi_estatus_registro_id = 3
	GROUP BY vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_ma_edo_civil_id
	)s
	PIVOT   (SUM(Total) FOR IdEdoCivil IN ([11] ,[12], [13], [14], [15], [16], [88], [99])) pvt	
	--FOR XML PATH('Fila'), ROOT('Reporte')
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


  IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSReporteNumNacSubregistroMunicipios') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSReporteNumNacSubregistroMunicipios
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que obtiene el reporte por municipios
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSReporteNumNacSubregistroMunicipios(
@pc_anos VARCHAR(255),
@pc_meses VARCHAR(255),
@pc_municipios VARCHAR(400),
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 	
	
	DECLARE 
	@CONST_SUBREGISTRO_ID INT = 1,
	@CONST_OPORTUNO_ID INT = 2,
	@CONST_EXTEMPORANEO_ID INT = 3,
	@CONST_DUPLICADO_ID INT = 4,
	@CONST_COAHUILA_EDO_ID INT = 5
			
	SET NOCOUNT ON

BEGIN TRY		
	DECLARE
	@colPivote NVARCHAR(MAX),@colNombre NVARCHAR(MAX),@sql NVARCHAR(MAX)
	SELECT @colPivote = N'', @colNombre = N''
	SELECT @colNombre += N', isnull(p.' + QUOTENAME(fi_ma_num_nacimiento)+', 0) as ''No. Nacimientos '+ REPLACE(QUOTENAME(fi_ma_num_nacimiento,'"'),'"','')+'''',
	@colPivote += N', ' + QUOTENAME(fi_ma_num_nacimiento)	
	 FROM (
	  SELECT DISTINCT(fi_ma_num_nacimiento) FROM sdb.tasinac
	  WHERE 
	  (@pc_anos IS NULL OR (@pc_anos IS NOT NULL AND YEAR(fd_rn_fecha_hora_nacimiento) IN (SELECT A.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_anos) A)))
		AND (@pc_meses IS NULL OR (@pc_meses IS NOT NULL AND MONTH(fd_rn_fecha_hora_nacimiento) IN (SELECT M.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_meses) M)))
		AND (@pc_municipios IS NULL OR (fi_rn_mpio_id IN(SELECT Mun.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_municipios) Mun)))
	  ) AS x order by fi_ma_num_nacimiento asc;
	SET @sql = N'
	DECLARE 
	@vc_anos VARCHAR(255),
	@vc_meses VARCHAR(255),
	@vc_municipios VARCHAR(400)'

	IF(@pc_anos IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @vc_anos =''' + @pc_anos + ''''
	END
	
	IF(@pc_meses IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @vc_meses =''' + @pc_meses + ''''
	END

	IF(@pc_municipios IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @vc_municipios =''' + @pc_municipios + ''''
	END

	SET @sql = @sql + '	SELECT fi_ma_dom_mpio_id as ''ID Municipio'',Municipio,' + STUFF(@colNombre, 1, 2, '') + '
	FROM
	(
		SELECT vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc AS Municipio,vt.fi_ma_num_nacimiento AS NumNac,count(vt.fi_ma_num_nacimiento) as Total
		FROM SDB.FNObtieneTablaSubregistro(@vc_anos,@vc_meses,@vc_municipios) vt 
		INNER JOIN SDB.CTMunicipio ctM ON vt.fi_ma_dom_mpio_id = ctM.fi_mpio_id
		WHERE vt.fi_estatus_registro_id = 1
		GROUP BY vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_ma_num_nacimiento
	) AS j
	PIVOT
	(
	  SUM(Total) FOR NumNac IN ('
	  + STUFF(@colPivote, 1, 1, '')
	  + ')
	) AS p;'
	-- FOR XML PATH(''Fila''), ROOT(''Reporte'')' ;
	PRINT @sql;
	EXEC sp_executesql @sql;

	SET @sql = N'
	DECLARE 
	@vc_anos VARCHAR(255),
	@vc_meses VARCHAR(255),
	@vc_municipios VARCHAR(400)'

	IF(@pc_anos IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @vc_anos =''' + @pc_anos + ''''
	END
	
	IF(@pc_meses IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @vc_meses =''' + @pc_meses + ''''
	END

	IF(@pc_municipios IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @vc_municipios =''' + @pc_municipios + ''''
	END

	SET @sql = @sql + '	SELECT fi_ma_dom_mpio_id as ''ID Municipio'',Municipio,' + STUFF(@colNombre, 1, 2, '') + '
	FROM
	(
		SELECT vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc AS Municipio,vt.fi_ma_num_nacimiento AS NumNac,count(vt.fi_ma_num_nacimiento) as Total
		FROM SDB.FNObtieneTablaSubregistro(@vc_anos,@vc_meses,@vc_municipios) vt 
		INNER JOIN SDB.CTMunicipio ctM ON vt.fi_ma_dom_mpio_id = ctM.fi_mpio_id
		WHERE vt.fi_estatus_registro_id = 2
		GROUP BY vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_ma_num_nacimiento
	) AS j
	PIVOT
	(
	  SUM(Total) FOR NumNac IN ('
	  + STUFF(@colPivote, 1, 1, '')
	  + ')
	) AS p;'
	-- FOR XML PATH(''Fila''), ROOT(''Reporte'')' ;
	PRINT @sql;
	EXEC sp_executesql @sql;

	SET @sql = N'
	DECLARE 
	@vc_anos VARCHAR(255),
	@vc_meses VARCHAR(255),
	@vc_municipios VARCHAR(400)'

	IF(@pc_anos IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @vc_anos =''' + @pc_anos + ''''
	END
	
	IF(@pc_meses IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @vc_meses =''' + @pc_meses + ''''
	END

	IF(@pc_municipios IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @vc_municipios =''' + @pc_municipios + ''''
	END

	SET @sql = @sql + '	SELECT fi_ma_dom_mpio_id as ''ID Municipio'',Municipio,' + STUFF(@colNombre, 1, 2, '') + '
	FROM
	(
		SELECT vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc AS Municipio,vt.fi_ma_num_nacimiento AS NumNac,count(vt.fi_ma_num_nacimiento) as Total
		FROM SDB.FNObtieneTablaSubregistro(@vc_anos,@vc_meses,@vc_municipios) vt 
		INNER JOIN SDB.CTMunicipio ctM ON vt.fi_ma_dom_mpio_id = ctM.fi_mpio_id
		WHERE vt.fi_estatus_registro_id = 3
		GROUP BY vt.fi_ma_dom_mpio_id,ctM.fc_mpio_desc,vt.fi_ma_num_nacimiento
	) AS j
	PIVOT
	(
	  SUM(Total) FOR NumNac IN ('
	  + STUFF(@colPivote, 1, 1, '')
	  + ')
	) AS p;'
	-- FOR XML PATH(''Fila''), ROOT(''Reporte'')' ;
	PRINT @sql;
	EXEC sp_executesql @sql;

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
