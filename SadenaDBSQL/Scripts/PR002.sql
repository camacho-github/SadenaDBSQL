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
	
		SELECT  DATENAME(MONTH, DATEADD(MONTH, x.number, '20000101')) AS MesCarga
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
	VT.fc_folio_certificado,
	VT.fc_folio_simple_certificado,
	VT.fd_rn_fecha_hora_nacimiento,	
	VT.fi_rn_sexo_id,
	VT.fi_rn_edo_id,
	VT.fi_rn_mpio_id,
	VT.fi_ma_dom_edo_id,
	VT.fi_ma_dom_mpio_id,
	VT.fi_ma_dom_loc_id,
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
		
	SELECT 'Totales Subregistro', ct.fi_estatus_registro_desc as NombreGrupo,count(vt.fi_estatus_registro_id) as Total
	FROM @vtRegistros vt INNER JOIN SDB.CTEstatusRegistro ct
	ON vt.fi_estatus_registro_id = ct.fi_estatus_registro_id
	GROUP BY vt.fi_estatus_registro_id,ct.fi_estatus_registro_desc
		
	SELECT 'Subregistros',r.fc_folio_certificado as Folio,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 105) as FechaNacimiento,
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 108) as HoraNacimiento,
	r.fi_rn_sexo_id as SexoId, cts.fc_sexo_desc as SexoDesc,
	r.fi_rn_edo_id as EdoId,ctloc.fc_loc_edo_desc as EdoDesc,
	r.fi_rn_mpio_id as MpioId,ctloc.fc_loc_mpio_desc as MpioDesc,
	r.fi_ma_dom_edo_id as LocId, ctloc.fc_loc_desc as LocDesc,
	r.fc_ma_dom_calle as Calle,r.fc_ma_dom_numext as NoExt, r.fc_ma_dom_numint as NoInt,
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
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 108) as HoraNacimiento,
	r.fi_rn_sexo_id as SexoId, cts.fc_sexo_desc as SexoDesc,
	r.fi_rn_edo_id as EdoId,ctloc.fc_loc_edo_desc as EdoDesc,
	r.fi_rn_mpio_id as MpioId,ctloc.fc_loc_mpio_desc as MpioDesc,
	r.fi_ma_dom_edo_id as LocId, ctloc.fc_loc_desc as LocDesc,
	r.fc_ma_dom_calle as Calle,r.fc_ma_dom_numext as NoExt, r.fc_ma_dom_numint as NoInt,
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
	CONVERT(VARCHAR(10), r.fd_rn_fecha_hora_nacimiento, 108) as HoraNacimiento,
	r.fi_rn_sexo_id as SexoId, cts.fc_sexo_desc as SexoDesc,
	r.fi_rn_edo_id as EdoId,ctloc.fc_loc_edo_desc as EdoDesc,
	r.fi_rn_mpio_id as MpioId,ctloc.fc_loc_mpio_desc as MpioDesc,
	r.fi_ma_dom_edo_id as LocId, ctloc.fc_loc_desc as LocDesc,
	r.fc_ma_dom_calle as Calle,r.fc_ma_dom_numext as NoExt, r.fc_ma_dom_numint as NoInt,
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


IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSReporteSubregistroMunicipios') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSReporteSubregistroMunicipios
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que obtiene el reporte por municipios
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSReporteSubregistroMunicipios(
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

	SELECT  IdMun as 'IDA0Municipio',Municipio,ISNULL([1],0) as 'TotalA0Subregistro',ISNULL([2],0) as 'TotalA0RegistroA0Oportuno',ISNULL([3],0)  as 'TotalA0RegistroA0Extemporaneo'
	FROM    (	
	SELECT vt.fi_rn_mpio_id As IdMun,ctM.fc_mpio_desc AS Municipio, vt.fi_estatus_registro_id as IdGrupo,count(vt.fi_estatus_registro_id) as Total
	FROM SDB.FNObtieneTablaSubregistro(@pc_anos,@pc_meses,@pc_municipios) vt 
	INNER JOIN SDB.CTMunicipio ctM ON vt.fi_rn_mpio_id = ctM.fi_mpio_id	
	GROUP BY vt.fi_rn_mpio_id,ctM.fc_mpio_desc,vt.fi_estatus_registro_id
	)s
	PIVOT   (SUM(Total) FOR IdGrupo IN ([1] ,[2], [3])) pvt	
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
	SELECT @colNombre += N', isnull(p.' + QUOTENAME(fi_ma_edad)+', 0) as ''Edad'+ REPLACE(QUOTENAME(fi_ma_edad,'"'),'"','')+'años''',
	@colPivote += N', ' + QUOTENAME(fi_ma_edad)
	  FROM (
	  SELECT DISTINCT(fi_ma_edad) FROM sdb.tasinac
	  WHERE 
	  (@pc_anos IS NULL OR (@pc_anos IS NOT NULL AND YEAR(fd_rn_fecha_hora_nacimiento) IN (SELECT A.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_anos) A)))
		AND (@pc_meses IS NULL OR (@pc_meses IS NOT NULL AND MONTH(fd_rn_fecha_hora_nacimiento) IN (SELECT M.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_meses) M)))
		AND (@pc_municipios IS NULL OR (fi_rn_edo_id = @CONST_COAHUILA_EDO_ID AND fi_rn_mpio_id IN(SELECT Mun.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_municipios) Mun)))
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
		SET @sql = @sql + ' SET @pc_meses =''' + @pc_meses + ''''
	END

	IF(@pc_municipios IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @pc_municipios =''' + @pc_municipios + ''''
	END

	SET @sql = @sql + '	SELECT IdMun,Municipio,' + STUFF(@colNombre, 1, 2, '') + '
	FROM
	(
		SELECT vt.fi_rn_mpio_id As IdMun,ctM.fc_mpio_desc AS Municipio,vt.fi_ma_edad AS Edad,count(vt.fi_ma_edad) as Total
		FROM SDB.FNObtieneTablaSubregistro(@vc_anos,@vc_meses,@vc_municipios) vt 
		INNER JOIN SDB.CTMunicipio ctM ON vt.fi_rn_mpio_id = ctM.fi_mpio_id	
		GROUP BY vt.fi_rn_mpio_id,ctM.fc_mpio_desc,vt.fi_ma_edad
	) AS j
	PIVOT
	(
	  SUM(Total) FOR Edad IN ('
	  + STUFF(@colPivote, 1, 1, '')
	  + ')
	) AS p  FOR XML PATH(''Fila''), ROOT(''Reporte'')' ;
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
--- Descripcion: Creación de un stored procedure que obtiene el reporte de escolaridad por municipios
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSReporteEscolaridadSubregistroMunicipios(
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
	--SELECT fi_escol_id,fc_escol_desc FROM sdb.CTEscolaridad
	
	DECLARE
	@colPivote NVARCHAR(MAX),@colNombre NVARCHAR(MAX),@sql NVARCHAR(MAX)
	SELECT @colPivote = N'', @colNombre = N''
	SELECT @colNombre += N', isnull(p.' + QUOTENAME(fi_ma_escol_id)+', 0) as ''Escol'+ REPLACE(QUOTENAME(fi_ma_escol_id,'"'),'"','')+'ID''',
	@colPivote += N', ' + QUOTENAME(fi_ma_escol_id)
	  FROM (
	  SELECT DISTINCT(fi_ma_escol_id) FROM sdb.tasinac
	  WHERE 
	  (@pc_anos IS NULL OR (@pc_anos IS NOT NULL AND YEAR(fd_rn_fecha_hora_nacimiento) IN (SELECT A.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_anos) A)))
		AND (@pc_meses IS NULL OR (@pc_meses IS NOT NULL AND MONTH(fd_rn_fecha_hora_nacimiento) IN (SELECT M.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_meses) M)))
		AND (@pc_municipios IS NULL OR (fi_rn_edo_id = @CONST_COAHUILA_EDO_ID AND fi_rn_mpio_id IN(SELECT Mun.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_municipios) Mun)))
	  ) AS x order by fi_ma_escol_id asc;
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
		SET @sql = @sql + ' SET @pc_meses =''' + @pc_meses + ''''
	END

	IF(@pc_municipios IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @pc_municipios =''' + @pc_municipios + ''''
	END

	SET @sql = @sql + '	SELECT IdMun,Municipio,' + STUFF(@colNombre, 1, 2, '') + '
	FROM
	(
		SELECT vt.fi_rn_mpio_id As IdMun,ctM.fc_mpio_desc AS Municipio,vt.fi_ma_escol_id AS Escol,count(vt.fi_ma_escol_id) as Total
		FROM SDB.FNObtieneTablaSubregistro(@vc_anos,@vc_meses,@vc_municipios) vt 
		INNER JOIN SDB.CTMunicipio ctM ON vt.fi_rn_mpio_id = ctM.fi_mpio_id	
		GROUP BY vt.fi_rn_mpio_id,ctM.fc_mpio_desc,vt.fi_ma_escol_id
	) AS j
	PIVOT
	(
	  SUM(Total) FOR Escol IN ('
	  + STUFF(@colPivote, 1, 1, '')
	  + ')
	) AS p FOR XML PATH(''Fila''), ROOT(''Reporte'')' ;
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
	
	SELECT  fi_rn_mpio_id as IDA0Municipio,fc_mpio_desc AS Municipio,ISNULL([1],0) as 'Hombre',ISNULL([2],0) as 'Mujer',ISNULL([3],0)  as 'SinA0Información'
	FROM    (	
	SELECT vt.fi_rn_mpio_id,ctM.fc_mpio_desc,vt.fi_rn_sexo_id,count(vt.fi_rn_sexo_id) as Total
	FROM SDB.FNObtieneTablaSubregistro(@pc_anos,@pc_meses,@pc_municipios) vt 
	INNER JOIN SDB.CTMunicipio ctM ON vt.fi_rn_mpio_id = ctM.fi_mpio_id	
	GROUP BY vt.fi_rn_mpio_id,ctM.fc_mpio_desc,vt.fi_rn_sexo_id
	)s
	PIVOT   (SUM(Total) FOR fi_rn_sexo_id IN ([1] ,[2], [3])) pvt	
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

	SELECT  IdMun,Municipio,ISNULL([11],0) as CASADA,ISNULL([12],0) as SOLTERA,ISNULL([13],0) as DIVORCIADA,ISNULL([14],0) as VIUDA,ISNULL([15],0) as 'UNIÓNA0LIBRE',ISNULL([16],0) as SEPARADA,ISNULL([88],0) as 'N.E.',ISNULL([99],0) as 'S.I.'
	FROM    (	
	SELECT vt.fi_rn_mpio_id As IdMun,ctM.fc_mpio_desc AS Municipio, vt.fi_ma_edo_civil_id as IdEdoCivil,count(vt.fi_ma_edo_civil_id) as Total
	FROM SDB.FNObtieneTablaSubregistro(@pc_anos,@pc_meses,@pc_municipios) vt 
	INNER JOIN SDB.CTMunicipio ctM ON vt.fi_rn_mpio_id = ctM.fi_mpio_id	
	GROUP BY vt.fi_rn_mpio_id,ctM.fc_mpio_desc,vt.fi_ma_edo_civil_id
	)s
	PIVOT   (SUM(Total) FOR IdEdoCivil IN ([11] ,[12], [13], [14], [15], [16], [88], [99])) pvt	
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
	SELECT @colNombre += N', isnull(p.' + QUOTENAME(fi_ma_num_nacimiento)+', 0) as ''NumNacimiento'+ REPLACE(QUOTENAME(fi_ma_num_nacimiento,'"'),'"','')+'''',
	@colPivote += N', ' + QUOTENAME(fi_ma_num_nacimiento)	
	 FROM (
	  SELECT DISTINCT(fi_ma_num_nacimiento) FROM sdb.tasinac
	  WHERE 
	  (@pc_anos IS NULL OR (@pc_anos IS NOT NULL AND YEAR(fd_rn_fecha_hora_nacimiento) IN (SELECT A.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_anos) A)))
		AND (@pc_meses IS NULL OR (@pc_meses IS NOT NULL AND MONTH(fd_rn_fecha_hora_nacimiento) IN (SELECT M.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_meses) M)))
		AND (@pc_municipios IS NULL OR (fi_rn_edo_id = @CONST_COAHUILA_EDO_ID AND fi_rn_mpio_id IN(SELECT Mun.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_municipios) Mun)))
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
		SET @sql = @sql + ' SET @pc_meses =''' + @pc_meses + ''''
	END

	IF(@pc_municipios IS NOT NULL)
	BEGIN
		SET @sql = @sql + ' SET @pc_municipios =''' + @pc_municipios + ''''
	END

	SET @sql = @sql + '	SELECT IdMun,Municipio,' + STUFF(@colNombre, 1, 2, '') + '
	FROM
	(
		SELECT vt.fi_rn_mpio_id As IdMun,ctM.fc_mpio_desc AS Municipio,vt.fi_ma_num_nacimiento AS NumNac,count(vt.fi_ma_num_nacimiento) as Total
		FROM SDB.FNObtieneTablaSubregistro(@vc_anos,@vc_meses,@vc_municipios) vt 
		INNER JOIN SDB.CTMunicipio ctM ON vt.fi_rn_mpio_id = ctM.fi_mpio_id	
		GROUP BY vt.fi_rn_mpio_id,ctM.fc_mpio_desc,vt.fi_ma_num_nacimiento
	) AS j
	PIVOT
	(
	  SUM(Total) FOR NumNac IN ('
	  + STUFF(@colPivote, 1, 1, '')
	  + ')
	) AS p FOR XML PATH(''Fila''), ROOT(''Reporte'')' ;
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
