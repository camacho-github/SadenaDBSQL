USE SADENADB
GO

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSCTEstatusRegistro') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSCTEstatusRegistro
END

GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que recupera el cat�logo de estatus registro
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSCTEstatusRegistro(
	@po_msg_code INT OUTPUT,
	@po_msg	VARCHAR(255) OUTPUT)

AS 

SET NOCOUNT ON

BEGIN TRY	
	IF EXISTS( SELECT fi_estatus_registro_id FROM SDB.CTEstatusRegistro WITH( NOLOCK ))
	BEGIN
		SELECT fi_estatus_registro_id as EstatusRegistroId, fi_estatus_registro_desc as EstatusRegistroDesc
		   FROM SDB.CTEstatusRegistro

		SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'		
	END
	ELSE
	BEGIN
		SELECT @po_msg_code=1, @po_msg = 'No se encontraron registros en el cat�logo estatus del registro'		
	END
END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al consultar cat�logo de estatus del registro'
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSCTSexo') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSCTSexo
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que recupera el cat�logo de sexo
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSCTSexo(
	@po_msg_code INT OUTPUT,
	@po_msg	VARCHAR(255) OUTPUT)

AS 

SET NOCOUNT ON

BEGIN TRY	
	IF EXISTS( SELECT fi_sexo_id FROM SDB.CTSexo WITH( NOLOCK ))
	BEGIN
		SELECT fi_sexo_id as SexoId, fc_sexo_desc as SexoDesc
		   FROM SDB.CTSexo

		SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'		
	END
	ELSE
	BEGIN
		SELECT @po_msg_code=1, @po_msg = 'No se encontraron registros en el cat�logo de sexo'		
	END
END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al consultar cat�logo de sexo'
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO


 IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSCTEdoCivil') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSCTEdoCivil
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que recupera el cat�logo de estado civil
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSCTEdoCivil(
	@po_msg_code INT OUTPUT,
	@po_msg	VARCHAR(255) OUTPUT)

AS 

SET NOCOUNT ON

BEGIN TRY	
	IF EXISTS( SELECT fi_edo_civil_id FROM SDB.CTEdoCivil WITH( NOLOCK ))
	BEGIN
		SELECT fi_edo_civil_id as EdoCivilId, fc_edo_civil_desc as EdoCivilDesc
		   FROM SDB.CTEdoCivil

		SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'		
	END
	ELSE
	BEGIN
		SELECT @po_msg_code=1, @po_msg = 'No se encontraron registros en el cat�logo estado civil'		
	END
END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al consultar cat�logo de estado civil'
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO


IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSCTEscolaridad') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSCTEscolaridad
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que recupera el cat�logo de escolaridad
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSCTEscolaridad(
	@po_msg_code INT OUTPUT,
	@po_msg	VARCHAR(255) OUTPUT)

AS 

SET NOCOUNT ON

BEGIN TRY	
	IF EXISTS( SELECT fi_escol_id FROM SDB.CTEscolaridad WITH( NOLOCK ))
	BEGIN
		SELECT fi_escol_id as EscolId, fc_escol_desc as EscolDesc
		   FROM SDB.CTEscolaridad 

		SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'		
	END
	ELSE
	BEGIN
		SELECT @po_msg_code=1, @po_msg = 'No se encontraron registros en el cat�logo escolaridad'		
	END
END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al consultar cat�logo de escolaridad'
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSCTLocalidad') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSCTLocalidad
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que recupera el cat�logo de localidad
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSCTLocalidad(
	@po_msg_code INT OUTPUT,
	@po_msg	VARCHAR(255) OUTPUT)

AS 

SET NOCOUNT ON

BEGIN TRY	
	IF EXISTS( SELECT fi_loc_id FROM SDB.CTLocalidad WITH( NOLOCK ))
	BEGIN
		SELECT fi_loc_edo_id as LocEdoId, fc_loc_edo_desc as LocEdoDesc, fi_loc_mpio_id as LocMpioId, fc_loc_mpio_desc as LocMpioDesc, fi_loc_id as LocId, fc_loc_desc as LocDesc
		   FROM SDB.CTLocalidad order by fi_loc_edo_id,fi_loc_mpio_id,fi_loc_id

		SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'		
	END
	ELSE
	BEGIN
		SELECT @po_msg_code=1, @po_msg = 'No se encontraron registros en el cat�logo localidad'		
	END
END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al consultar cat�logo de localidad'
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO

 IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSCTLocalidadCoahuila') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSCTLocalidadCoahuila
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que recupera el cat�logo de localidades de Coahuila
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSCTLocalidadCoahuila(
	@po_msg_code INT OUTPUT,
	@po_msg	VARCHAR(255) OUTPUT)

AS 
	DECLARE 
	@CONST_COAHUILA_EDO_ID INT = 5

SET NOCOUNT ON

BEGIN TRY	
	IF EXISTS( SELECT fi_loc_id FROM SDB.CTLocalidad WITH( NOLOCK ))
	BEGIN
		SELECT fi_loc_edo_id as LocEdoId, fc_loc_edo_desc as LocEdoDesc, fi_loc_mpio_id as LocMpioId, fc_loc_mpio_desc as LocMpioDesc, fi_loc_id as LocId, fc_loc_desc as LocDesc
		   FROM SDB.CTLocalidad 
		   WHERE fi_loc_edo_id = @CONST_COAHUILA_EDO_ID
		   AND fi_loc_mpio_id > 0 AND fi_loc_mpio_id < 999
		   order by fi_loc_mpio_id,fi_loc_id

		SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'		
	END
	ELSE
	BEGIN
		SELECT @po_msg_code=1, @po_msg = 'No se encontraron registros en el cat�logo localidad'		
	END
END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al consultar cat�logo de localidad'
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSCTMunicipio') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSCTMunicipio
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que recupera el cat�logo de municipios
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSCTMunicipio(
	@po_msg_code INT OUTPUT,
	@po_msg	VARCHAR(255) OUTPUT)

AS 

SET NOCOUNT ON

BEGIN TRY	
	IF EXISTS( SELECT fi_mpio_id FROM SDB.CTMunicipio WITH( NOLOCK ))
	BEGIN
		SELECT fi_mpio_id as MpioId, fc_mpio_desc as MpioDesc, fc_latitud as Latitud, fc_longitud as Longitud, fc_poligono.ToString() as Poligono
		   FROM SDB.CTMunicipio
		   ORDER BY fc_mpio_desc ASC

		SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'		
	END
	ELSE
	BEGIN
		SELECT @po_msg_code=1, @po_msg = 'No se encontraron registros en el cat�logo municipio'		
	END
END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al consultar cat�logo de municipio'
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO

 IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSCTRol') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSCTRol
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que recupera el cat�logo de roles
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSCTRol(
	@po_msg_code INT OUTPUT,
	@po_msg	VARCHAR(255) OUTPUT)

AS 

SET NOCOUNT ON

BEGIN TRY	
	IF EXISTS( SELECT 1 FROM SDB.CTRol WITH( NOLOCK ))
	BEGIN
		SELECT fi_rol_id as RolId, fc_rol_desc as RolDesc
		   FROM SDB.CTRol
		   WHERE fi_rol_id > 1
		   ORDER BY 1 ASC

		SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'		
	END
	ELSE
	BEGIN
		SELECT @po_msg_code=1, @po_msg = 'No se encontraron registros en el cat�logo Rol'		
	END
END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al consultar cat�logo de Rol'
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRDelTMSINAC') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRDelTMSINAC
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que elimina los registros de la tabla temporal SINAC
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRDelTMSINAC(		
	@po_msg_code INT OUTPUT,
	@po_msg	VARCHAR(255) OUTPUT)

AS 

SET NOCOUNT ON
BEGIN TRY	
	IF EXISTS( SELECT TOP 1 fc_folio FROM SDB.TMSINAC  WITH( NOLOCK ))
	BEGIN
		TRUNCATE TABLE SDB.TMSINAC		
	END	

	SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'
END TRY
BEGIN CATCH		
		SELECT @po_msg_code=-1, @po_msg = 'Error al eliminar la tabla temporal del SINAC '
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRDelTMSIC') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRDelTMSIC
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que elimina los registros de la tabla temporal SIC
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRDelTMSIC(		
	@po_msg_code INT OUTPUT,
	@po_msg	VARCHAR(255) OUTPUT)

AS 

SET NOCOUNT ON
BEGIN TRY	
	IF EXISTS( SELECT TOP 1 fi_edo_ofi FROM SDB.TMSIC  WITH( NOLOCK ))
	BEGIN
		TRUNCATE TABLE SDB.TMSIC				
	END	
	
	SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'

END TRY
BEGIN CATCH		
		SELECT @po_msg_code=-1, @po_msg = 'Error al eliminar la tabla temporal del SIC '
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO


IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRNInsControlCarga') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRNInsControlCarga
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que inserta en la tabla control de carga
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRNInsControlCarga(
	@pi_sesion_id int,
	@pi_control_tipo_id int,
	@pc_ano varchar(4),
	@pc_nombre_archivo varchar(255),	
	@po_msg_code int OUTPUT,
	@po_msg	varchar(255) OUTPUT)
AS
	DECLARE 
	@CONST_ESTATUS_CONTROL_PRECARGADO INT = 1,
	@CONST_ESTATUS_CONTROL_PRECARGADO_ELIMINADO INT = 2,
	@CONST_ESTATUS_CONTROL_PROCESADO INT = 3,
	@CONST_ESTATUS_CONTROL_PROCESADO_ELIMINADO INT = 4

SET NOCOUNT ON
BEGIN TRY	
	IF EXISTS( SELECT fi_sesion_id FROM SDB.BIUsuarioSesion  WITH( NOLOCK ) WHERE fi_sesion_id = @pi_sesion_id and fi_estatus_id =  1)
	BEGIN
		IF EXISTS( SELECT fi_control_tipo_id from SDB.TAControlCarga WITH( NOLOCK ) WHERE fi_control_tipo_id = @pi_control_tipo_id AND fi_estatus_control_id = @CONST_ESTATUS_CONTROL_PRECARGADO)
		BEGIN
			UPDATE SDB.TAControlCarga SET fi_estatus_control_id = @CONST_ESTATUS_CONTROL_PRECARGADO_ELIMINADO, fd_fecha_act = SYSDATETIME()  WHERE fi_control_tipo_id = @pi_control_tipo_id AND fi_estatus_control_id = @CONST_ESTATUS_CONTROL_PRECARGADO
		END

		INSERT INTO SDB.TAControlCarga(fi_sesion_id,fi_control_tipo_id,fc_ano,fc_nombre_archivo) VALUES( @pi_sesion_id,@pi_control_tipo_id,@pc_ano,@pc_nombre_archivo)		
		
		SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'		
	END
	ELSE
	BEGIN
		SELECT @po_msg_code=1, @po_msg = 'La sesi�n no existe o ya fue cerrada'		
	END
END TRY
BEGIN CATCH		
		SELECT @po_msg_code=-1, @po_msg = 'Error al insertar en tabla de control de carga' + @pi_sesion_id
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRNDepurarCargaSINAC') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRNDepurarCargaSINAC
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  ++++
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que depura la informaci�n de una carga SINAC anterior
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRNDepurarCargaSINAC(
	@pi_control_id int,
	@po_msg_code int OUTPUT,
	@po_msg	varchar(255) OUTPUT)
AS DECLARE
	@vi_anterior_control_id int,
	@vc_ano_control varchar(4)

	DECLARE 
	@CONST_CONTROL_TIPO_SINAC INT = 2,	
	@CONST_ESTATUS_CONTROL_PRECARGADO INT = 1,
	@CONST_ESTATUS_CONTROL_PROCESADO INT = 3,
	@CONST_ESTATUS_CONTROL_PROCESADO_ELIMINADO INT = 4
			
SET NOCOUNT ON
BEGIN TRY	
	--TODO
	--i) como una mejora de limpieza de la base, 
	--ser� necesario una soluci�n diferente que evite escribir en log todos los registros depurados
	------
	IF EXISTS( SELECT fi_control_id FROM SDB.TAControlCarga  WITH( NOLOCK ) WHERE fi_control_id = @pi_control_id and fi_estatus_control_id = @CONST_ESTATUS_CONTROL_PRECARGADO)
	BEGIN		
		SELECT @vc_ano_control = fc_ano FROM SDB.TAControlCarga  WITH( NOLOCK ) WHERE fi_control_id = @pi_control_id and fi_estatus_control_id = @CONST_ESTATUS_CONTROL_PRECARGADO
		
		SELECT @vi_anterior_control_id = fi_control_id FROM SDB.TAControlCarga  WITH( NOLOCK ) WHERE  fc_ano = @vc_ano_control and fi_control_tipo_id = @CONST_CONTROL_TIPO_SINAC and fi_estatus_control_id = @CONST_ESTATUS_CONTROL_PROCESADO
		
		IF(@vi_anterior_control_id > 0)
		BEGIN			
			UPDATE SDB.TAControlCarga SET fi_estatus_control_id = @CONST_ESTATUS_CONTROL_PROCESADO_ELIMINADO, fd_fecha_act = SYSDATETIME()  WHERE fi_control_id = @vi_anterior_control_id
			DELETE SDB.TASINAC WHERE fi_control_id = @vi_anterior_control_id		
		END
	END
	
	SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'			
END TRY
BEGIN CATCH		
		SELECT @po_msg_code=-1, @po_msg = 'Error al depurar cargas de tabla SINAC'  + ERROR_MESSAGE()
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRNDepurarCargaSIC') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRNDepurarCargaSIC
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que depura la informaci�n de una carga anterior
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRNDepurarCargaSIC(
	@pi_control_id int,
	@po_msg_code int OUTPUT,
	@po_msg	varchar(255) OUTPUT)
AS DECLARE
	@vi_anterior_control_id int,
	@vc_ano_control varchar(4)

	DECLARE 
	@CONST_CONTROL_TIPO_SIC INT = 3,
	@CONST_ESTATUS_CONTROL_PRECARGADO INT = 1,
	@CONST_ESTATUS_CONTROL_PROCESADO INT = 3,
	@CONST_ESTATUS_CONTROL_PROCESADO_ELIMINADO INT = 4
			
SET NOCOUNT ON
BEGIN TRY	
	--TODO
	--i) como una mejora de limpieza de la base, 
	--ser� necesario una soluci�n diferente que evite escribir en log todos los registros depurados
	------
	IF EXISTS( SELECT fi_control_id FROM SDB.TAControlCarga  WITH( NOLOCK ) WHERE fi_control_id = @pi_control_id and fi_estatus_control_id = @CONST_ESTATUS_CONTROL_PRECARGADO)
	BEGIN		
		SELECT @vc_ano_control = fc_ano FROM SDB.TAControlCarga  WITH( NOLOCK ) WHERE fi_control_id = @pi_control_id and fi_estatus_control_id = @CONST_ESTATUS_CONTROL_PRECARGADO
		
		SELECT @vi_anterior_control_id = fi_control_id FROM SDB.TAControlCarga  WITH( NOLOCK ) WHERE  fc_ano = @vc_ano_control and fi_control_tipo_id = @CONST_CONTROL_TIPO_SIC and fi_estatus_control_id = @CONST_ESTATUS_CONTROL_PROCESADO
		
		IF(@vi_anterior_control_id > 0)
		BEGIN			
			UPDATE SDB.TAControlCarga SET fi_estatus_control_id = @CONST_ESTATUS_CONTROL_PROCESADO_ELIMINADO, fd_fecha_act = SYSDATETIME()  WHERE fi_control_id = @vi_anterior_control_id
			DELETE SDB.TASIC WHERE fi_control_id = @vi_anterior_control_id		
		END
	END
	
	SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'			
END TRY
BEGIN CATCH		
		SELECT @po_msg_code=-1, @po_msg = 'Error al depurar tablas de carga '  + ERROR_MESSAGE()
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRNProcesarCargaSINAC') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRNProcesarCargaSINAC
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que procesa y copia los registros del SINAC
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRNProcesarCargaSINAC(
	@po_msg_code int OUTPUT,
	@po_msg	varchar(255) OUTPUT)
AS DECLARE
	@vi_control_id int,
	@vi_resultado_exec int

SET NOCOUNT ON
BEGIN TRY	
	IF EXISTS( SELECT fi_control_id FROM SDB.TAControlCarga  WITH( NOLOCK ) WHERE fi_control_tipo_id = 2 and fi_estatus_control_id = 1)
	BEGIN
		
		SELECT @vi_control_id = fi_control_id FROM SDB.TAControlCarga  WITH( NOLOCK ) WHERE fi_control_tipo_id = 2 and fi_estatus_control_id = 1
		UPDATE SDB.TMSINAC SET fd_hora_nac = '00:00' WHERE fd_hora_nac = '99:99'
		
		INSERT INTO SDB.TASINAC(fc_folio_certificado, fc_folio_simple_certificado,fi_control_id, 
		fc_ma_nombre,fc_ma_ap_paterno,fc_ma_ap_materno,
		fi_ma_edad,fi_ma_edo_civil_id,
		fc_ma_dom_calle,fc_ma_dom_numext,fc_ma_dom_numint,
		fi_ma_dom_edo_id,fi_ma_dom_mpio_id,fi_ma_dom_loc_id,fc_ma_dom_col,
		fi_ma_num_nacimiento,fi_ma_escol_id,fc_ma_ocupacion,
		fd_rn_fecha_hora_nacimiento,fi_rn_sexo_id,fi_rn_edo_id,fi_rn_mpio_id)
		SELECT fc_folio, SDB.FNConvierteNumero(fc_folio),@vi_control_id,
		fc_nombre,fc_paterno,fc_materno,
		fi_edad_m, fi_edocivil,
		fc_calle_res,fc_numext_res,fc_numint_res,
		fi_ent_res,fi_mpo_res,fi_loc_res,fc_nomasen_res,
		fi_num_nacvivo,fi_niv_escol,fc_ocup_hab,
		convert(datetime,SUBSTRING(fd_fech_nac,0,11) + ' ' + ltrim(rtrim(fd_hora_nac)),103),fi_sexo,fi_ent_nacm,fi_mpo_nacm
		FROM SDB.TMSINAC

		----------------------------------------------------------------------------

		EXEC SDB.PRNDepurarCargaSINAC @vi_control_id, @po_msg_code output, @po_msg output   
		EXEC SDB.PRNProcesarDuplicadosSINAC @vi_control_id, @po_msg_code output, @po_msg output   
		-----------------------------------------------------------------------------
		
		UPDATE SDB.TAControlCarga SET fi_estatus_control_id = 3, fd_fecha_act = SYSDATETIME()  WHERE fi_control_tipo_id = 2 AND fi_estatus_control_id = 1
		
		SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'		
	END
	ELSE
	BEGIN
		SELECT @po_msg_code=1, @po_msg = 'La sesi�n no existe o ya fue cerrada'		
	END
END TRY
BEGIN CATCH		
		SELECT @po_msg_code=-1, @po_msg = 'Error al procesar tabla SINAC ' + ERROR_MESSAGE()
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO


IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRNProcesarCargaSIC') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRNProcesarCargaSIC
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que procesa y copia los registros del SIC
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRNProcesarCargaSIC(
	@po_msg_code int OUTPUT,
	@po_msg	varchar(255) OUTPUT)
AS DECLARE
	@vi_control_id int,
	@vc_ano varchar(4)
		
SET NOCOUNT ON
BEGIN TRY	
	IF EXISTS( SELECT fi_control_id FROM SDB.TAControlCarga  WITH( NOLOCK ) WHERE fi_control_tipo_id = 3 and fi_estatus_control_id = 1)
	BEGIN
		
		SELECT @vi_control_id = fi_control_id,@vc_ano = fc_ano FROM SDB.TAControlCarga  WITH( NOLOCK ) WHERE fi_control_tipo_id = 3 and fi_estatus_control_id = 1
		SELECT * FROM SDB.TAControlCarga  WITH( NOLOCK ) WHERE fi_control_tipo_id = 3 and fi_estatus_control_id = 1
		
		/*Actualiza nulos de tabla temporal*/
		UPDATE SDB.TMSIC
		SET fc_no_certif = ''
		WHERE fc_no_certif IS NULL

		IF EXISTS(SELECT 1 FROM SDB.TMSIC WHERE CHARINDEX(' ', fc_fecha_reg) = 9)
		BEGIN
			UPDATE SDB.TMSIC
			SET fc_fecha_reg = 
			FORMAT(
				DATETIMEFROMPARTS(
					(CASE 
						WHEN CONVERT(INT,SUBSTRING(fc_fecha_reg,7,2)) <= SUBSTRING(@vc_ano,3,2) 
							THEN '20'+ SUBSTRING(fc_fecha_reg,7,2)
						ELSE 
							'19'+ SUBSTRING(fc_fecha_reg,7,2)
					END),
					SUBSTRING(fc_fecha_reg,4,2),
					SUBSTRING(fc_fecha_reg,1,2),
					SUBSTRING(fc_fecha_reg,10,2),
					SUBSTRING(fc_fecha_reg,13,2),
					SUBSTRING(fc_fecha_reg,16,2),
					SUBSTRING(fc_fecha_reg,19,1)
				)
			,'yyyy-MM-dd hh:mm:ss.0')
			FROM SDB.TMSIC
			WHERE CHARINDEX(' ', fc_fecha_reg) = 9
		END

		IF EXISTS(SELECT 1 FROM SDB.TMSIC WHERE CHARINDEX(' ', fc_fecha_nac) = 9)
		BEGIN
			
			UPDATE SDB.TMSIC
			SET fc_fecha_nac = 
			FORMAT(
				DATETIMEFROMPARTS(
					(CASE 
						WHEN CONVERT(INT,SUBSTRING(fc_fecha_nac,7,2)) <= SUBSTRING(@vc_ano,3,2) 
							THEN '20'+ SUBSTRING(fc_fecha_nac,7,2)
						ELSE 
							'19'+ SUBSTRING(fc_fecha_nac,7,2)
					END),
					SUBSTRING(fc_fecha_nac,4,2),
					SUBSTRING(fc_fecha_nac,1,2),
					SUBSTRING(fc_fecha_nac,10,2),
					SUBSTRING(fc_fecha_nac,13,2),
					SUBSTRING(fc_fecha_nac,16,2),
					SUBSTRING(fc_fecha_nac,19,1)
				)
			,'yyyy-MM-dd hh:mm:ss.0')
			FROM SDB.TMSIC
			WHERE CHARINDEX(' ', fc_fecha_nac) = 9
		END

		INSERT INTO SDB.TASIC(fc_identificador,fc_folio_certificado,fc_folio_simple_certificado, fi_control_id,
		fi_edo_id,fi_mpio_id,fd_rn_fecha_hora_nacimiento,fd_rn_fecha_registro,fi_mpio_ofi_id,fi_oficialia_id,fc_ano,fi_estatus_duplicado)
		SELECT CONCAT(fc_no_certif, fc_fecha_reg) ,fc_no_certif,SDB.FNConvierteNumero(fc_no_certif), @vi_control_id, 
		fi_estado,fi_municipio,
		--convert(datetime,SUBSTRING(ltrim(rtrim(fc_fecha_nac)),0,9) + ' ' + SUBSTRING(ltrim(rtrim(fc_fecha_nac)),10,5),3),
		convert(datetime,fc_fecha_nac),
		--convert(datetime,SUBSTRING(ltrim(rtrim(fc_fecha_reg)),0,9),3),0
		convert(datetime,fc_fecha_reg),fi_mun_ofi,fi_oficialia,fc_ano,0					
		FROM SDB.TMSIC
		--WHERE YEAR(convert(datetime,fc_fecha_nac)) >= '1900' AND 
		--YEAR(convert(datetime,fc_fecha_reg)) = @vc_ano

		----------------------------------------------------------------------------

		EXEC SDB.PRNDepurarCargaSIC @vi_control_id, @po_msg_code output, @po_msg output 
		EXEC SDB.PRNProcesarDuplicadosSIC @vi_control_id, @po_msg_code output, @po_msg output   
		
		-----------------------------------------------------------------------------

		UPDATE SDB.TAControlCarga SET fi_estatus_control_id = 3, fd_fecha_act = SYSDATETIME()  WHERE fi_control_tipo_id = 3 AND fi_estatus_control_id = 1
		
		SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'		
	END
	ELSE
	BEGIN
		SELECT @po_msg_code=1, @po_msg = 'La sesi�n no existe o ya fue cerrada'		
	END
END TRY
BEGIN CATCH		
		SELECT @po_msg_code=-1, @po_msg = 'Error al procesar tabla SIC ' + ERROR_MESSAGE()
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO

--exec SDB.PRNProcesarDuplicadosSIC 2,null,null

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRNProcesarDuplicadosSIC') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRNProcesarDuplicadosSIC
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que procesa quita los duplicados del SIC
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRNProcesarDuplicadosSIC(
	@pi_control_id int,
	@po_msg_code int OUTPUT,
	@po_msg	varchar(255) OUTPUT)
AS DECLARE

	@vi_registros int,
	@vi_renglonId int,
	@vc_folio_simple_certificado varchar(20),
	@vd_rn_fecha_registro datetime,
	@vd_rn_fecha_hora_nacimiento datetime

	DECLARE @vtRegistrosDuplicados TABLE(
	fi_id_renglon   INT NOT NULL IDENTITY(1,1),	
	fc_folio_simple_certificado varchar(20) NOT NULL,	
	fd_rn_fecha_registro datetime	
	)
	
	DECLARE @vtRegistrosDuplicadosSFolio TABLE(
	fi_id_renglon   INT NOT NULL IDENTITY(1,1),	
	fd_rn_fecha_hora_nacimiento datetime,	
	fd_rn_fecha_registro datetime	
	)	

SET NOCOUNT ON
BEGIN TRY	
	
	INSERT @vtRegistrosDuplicados(
	fc_folio_simple_certificado,
	fd_rn_fecha_registro)
	SELECT fc_folio_simple_certificado,
	MAX(fd_rn_fecha_registro)		
	FROM SDB.TASIC
	WHERE LEN(fd_rn_fecha_registro) > 0
	--AND fi_control_id = @pi_control_id
	GROUP BY fc_folio_simple_certificado
	having COUNT(fc_folio_simple_certificado) > 1
	AND LEN(fc_folio_simple_certificado) >0	

	SELECT @vi_registros = 0, @vi_renglonId = 1

	SELECT 
		@vi_registros = COUNT(fi_id_renglon) 
	FROM 
		@vtRegistrosDuplicados 
	WHERE 
		fi_id_renglon > 0

	WHILE @vi_renglonId <= @vi_registros
	BEGIN
		SELECT 
		@vc_folio_simple_certificado = Isnull(Nullif(LTRIM(RTRIM(fc_folio_simple_certificado)), '0'), LTRIM(RTRIM(fc_folio_simple_certificado))),
		@vd_rn_fecha_registro = fd_rn_fecha_registro
		FROM @vtRegistrosDuplicados
		WHERE fi_id_renglon = @vi_renglonId
		
		IF (@vc_folio_simple_certificado <> '0' and len(@vc_folio_simple_certificado) > 6 )
		BEGIN
		
			if exists(select 1 from SDB.TASIC where fc_folio_simple_certificado =  @vc_folio_simple_certificado 
			and fd_rn_fecha_registro <> @vd_rn_fecha_registro)
				begin
					UPDATE SDB.TASIC SET fi_estatus_duplicado = 0
					WHERE fc_folio_simple_certificado = @vc_folio_simple_certificado
					
					UPDATE SDB.TASIC SET fi_estatus_duplicado = 1
					WHERE fc_folio_simple_certificado = @vc_folio_simple_certificado
					AND fd_rn_fecha_registro <> @vd_rn_fecha_registro
				end
			else
				begin
					--print @vc_folio_simple_certificado
					UPDATE SDB.TASIC SET fi_estatus_duplicado = 0
					WHERE fc_folio_simple_certificado = @vc_folio_simple_certificado

					UPDATE top (1) SDB.TASIC  
					SET fi_estatus_duplicado = 1
					WHERE fc_folio_simple_certificado = @vc_folio_simple_certificado
				end
		END		

		SET @vi_renglonId = @vi_renglonId + 1
	END

	----------------------------------------------
	--marca registros duplicados sin folio
	
	INSERT @vtRegistrosDuplicadosSFolio(
	fd_rn_fecha_hora_nacimiento,
	fd_rn_fecha_registro)
	SELECT fd_rn_fecha_hora_nacimiento,
	MAX(fd_rn_fecha_registro)		
	FROM SDB.TASIC
	WHERE LEN(fd_rn_fecha_registro) > 0
	--AND fi_control_id = @pi_control_id
	GROUP BY fd_rn_fecha_hora_nacimiento,fd_rn_fecha_registro,fc_folio_simple_certificado
	having COUNT(fd_rn_fecha_hora_nacimiento) > 1
	and LEN(fc_folio_simple_certificado) = 0
	
	SELECT @vi_registros = 0, @vi_renglonId = 1

	SELECT 
		@vi_registros = COUNT(fi_id_renglon) 
	FROM 
		@vtRegistrosDuplicadosSFolio 
	WHERE 
		fi_id_renglon > 0
	
	WHILE @vi_renglonId <= @vi_registros
	BEGIN
		SELECT 
		@vd_rn_fecha_hora_nacimiento = fd_rn_fecha_hora_nacimiento,
		@vd_rn_fecha_registro = fd_rn_fecha_registro
		FROM @vtRegistrosDuplicadosSFolio
		WHERE fi_id_renglon = @vi_renglonId

		print @vd_rn_fecha_hora_nacimiento

		UPDATE SDB.TASIC SET fi_estatus_duplicado = 0
		WHERE fd_rn_fecha_hora_nacimiento = @vd_rn_fecha_hora_nacimiento
		and fd_rn_fecha_registro = @vd_rn_fecha_registro

		UPDATE top (1) SDB.TASIC  
		SET fi_estatus_duplicado = 1
		WHERE fd_rn_fecha_hora_nacimiento = @vd_rn_fecha_hora_nacimiento
		and fd_rn_fecha_registro = @vd_rn_fecha_registro
		and LEN(fc_folio_simple_certificado) = 0
		
		SET @vi_renglonId = @vi_renglonId + 1
	END
		

	SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'		
	
END TRY
BEGIN CATCH		
		SELECT @po_msg_code=-1, @po_msg = 'Error al quitar duplicados en tabla SIC'
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO

 IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRNProcesarDuplicadosSINAC') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRNProcesarDuplicadosSINAC
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que procesa quita los duplicados del SINAC
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRNProcesarDuplicadosSINAC(
	@pi_control_id int,
	@po_msg_code int OUTPUT,
	@po_msg	varchar(255) OUTPUT)
AS DECLARE

	@vi_registros int,
	@vi_renglonId int,
	@vc_folio_simple_certificado varchar(20),
	@vd_rn_fecha_hora_nacimiento datetime

	DECLARE @vtRegistrosDuplicados TABLE(
	fi_id_renglon   INT NOT NULL IDENTITY(1,1),	
	fc_folio_simple_certificado varchar(20) NOT NULL,	
	fd_rn_fecha_hora_nacimiento datetime	
	)	

SET NOCOUNT ON
BEGIN TRY	
	
	INSERT @vtRegistrosDuplicados(
	fc_folio_simple_certificado,
	fd_rn_fecha_hora_nacimiento)
	SELECT fc_folio_simple_certificado,
	MAX(fd_rn_fecha_hora_nacimiento)		
	FROM SDB.TASINAC
	WHERE LEN(fd_rn_fecha_hora_nacimiento) > 0
	--AND fi_control_id = @pi_control_id
	GROUP BY fc_folio_simple_certificado
	having COUNT(fc_folio_simple_certificado) > 1
	AND LEN(fc_folio_simple_certificado) >0	

	SELECT @vi_registros = 0, @vi_renglonId = 1

	SELECT 
		@vi_registros = COUNT(fi_id_renglon) 
	FROM 
		@vtRegistrosDuplicados 
	WHERE 
		fi_id_renglon > 0

	WHILE @vi_renglonId <= @vi_registros
	BEGIN
		SELECT 
		@vc_folio_simple_certificado = Isnull(Nullif(LTRIM(RTRIM(fc_folio_simple_certificado)), '0'), LTRIM(RTRIM(fc_folio_simple_certificado))),
		@vd_rn_fecha_hora_nacimiento = fd_rn_fecha_hora_nacimiento
		FROM @vtRegistrosDuplicados
		WHERE fi_id_renglon = @vi_renglonId
		
		IF (@vc_folio_simple_certificado <> '0' and len(@vc_folio_simple_certificado) > 8 )
		BEGIN			
			UPDATE SDB.TASINAC SET fi_estatus_duplicado = 0
			WHERE fc_folio_simple_certificado = @vc_folio_simple_certificado

			UPDATE SDB.TASINAC SET fi_estatus_duplicado = 1
			WHERE fc_folio_simple_certificado = @vc_folio_simple_certificado
			AND fd_rn_fecha_hora_nacimiento <> @vd_rn_fecha_hora_nacimiento
		END		

		SET @vi_renglonId = @vi_renglonId + 1
	END

	SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'		
	
END TRY
BEGIN CATCH		
		SELECT @po_msg_code=-1, @po_msg = 'Error al quitar duplicados en tabla SINAC'
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO
 


