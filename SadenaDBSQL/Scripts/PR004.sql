USE SADENADB
GO

 
IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSOficinas') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSOficinas
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que consulta las Oficinas
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSOficinas(
@pc_municipios VARCHAR(255),
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 	
	
	SET NOCOUNT ON

BEGIN TRY		

	SELECT 
	o.fi_oid AS OId,
	o.fi_oficina_id AS OficinaId,
	o.fi_mpio_id AS MpioId, 
	l.fc_loc_mpio_desc AS MpioDesc, 
	o.fi_loc_id AS LocId, 
	l.fc_loc_desc AS LocDesc,	
	o.fi_tipo_id AS TipoId,	
	o.fc_tipo_institucion AS TipoInstitucion,
	o.fc_institucion AS Institucion,
	o.fc_latitud AS Latitud, 
	o.fc_longitud AS Longitud, 
	o.fc_region AS Region,
	o.fc_calle AS Calle,
	o.fc_numero AS Numero,
	o.fc_colonia AS Colonia,
	o.fc_cp AS CP,
	o.fc_entre_calles AS EntreCalles,
	o.fc_horario_atencion AS HorarioAtencion,
	o.fc_telefono AS Telefono,
	o.fc_oficial_nombre AS OficialNombre,
	o.fc_oficial_apellidos AS OficialApellidos,
	o.fc_oficial_correo_e As CorreoE,
	o.fi_inv_serv_luz AS InvSerLuz,
	o.fi_inv_serv_agua AS InvSerAgua,
	o.fi_inv_local_propio AS InvLocalPropio,
	o.fi_inv_serv_sanitario AS InvSerSanitario,
	o.fi_inv_escritorios AS InvEscritorios,
	o.fi_inv_sillas AS InvSillas,
	o.fi_inv_archiveros AS InvArchiveros,
	o.fi_inv_computo_priv AS InvCompPriv,
	o.fi_inv_computo_gob AS InvCompGob,
	o.fi_inv_escaner_priv AS InvEscanPriv,
	o.fi_inv_escaner_gob AS InvEscanGob,
	o.fi_inv_impresora_priv AS InvImpPriv,
	o.fi_inv_impresora_gob AS InvImpGob,
	o.fi_equi_internet AS EquiNet,
	o.fi_equi_trab_internet AS EquiTrabNet,
	o.fi_equi_vent_express AS EquiVentExpress,
	o.fi_equi_con_drc AS EquiConDrc,
	o.fi_expide_curp AS ExpideCurp,
	o.fi_expide_actas_foraneas AS ExpideActasForaneas,
	o.fi_estatus_id AS EstatusId,
	o.fd_fecha_alta AS FechaAlta,
	o.fd_fecha_act AS FechaAct
	FROM SDB.TAOficinas o
	INNER JOIN SDB.CTLocalidad l
	ON o.fi_edo_id = l.fi_loc_edo_id AND o.fi_mpio_id = L.fi_loc_mpio_id AND o.fi_loc_id = l.fi_loc_id
	WHERE fi_estatus_id = 1
	AND o.fi_edo_id = 5 AND
	(@pc_municipios IS NULL OR (o.fi_mpio_id IN(SELECT Mun.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_municipios) Mun)))
	
	SELECT @po_msg_code=0, @po_msg = 'La ejecución del procedimiento fue exitosa'	

END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al obtener las Oficinas ' + ERROR_MESSAGE()
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSOficina') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSOficina
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que consulta una Oficina
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSOficina(
@pi_o_id int,
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 	
	
	SET NOCOUNT ON

BEGIN TRY		

	SELECT 
	o.fi_oid AS OId,
	o.fi_oficina_id AS OficinaId,
	o.fi_tipo_id AS TipoId,	
	t.fi_tipo_oficina_desc AS TipoDesc,	-------------------------
	o.fc_tipo_institucion AS TipoInstitucion,
	o.fc_institucion AS Institucion,
	o.fc_latitud AS Latitud, 
	o.fc_longitud AS Longitud, 
	o.fc_region AS Region,	
	o.fi_edo_id AS EdoId,
	o.fi_mpio_id AS MpioId, 
	l.fc_loc_mpio_desc AS MpioDesc, 
	o.fi_loc_id AS LocId, 
	l.fc_loc_desc AS LocDesc,
	o.fc_calle AS Calle,
	o.fc_numero AS Numero,
	o.fc_colonia AS Colonia,
	o.fc_cp AS CP,
	o.fc_entre_calles AS EntreCalles,
	o.fc_horario_atencion AS HorarioAtencion,
	o.fc_telefono AS Telefono,
	o.fc_oficial_nombre AS OficialNombre,
	o.fc_oficial_apellidos AS OficialApellidos,
	o.fc_oficial_correo_e As CorreoE,
	o.fi_inv_serv_luz AS InvSerLuz,
	o.fi_inv_serv_agua AS InvSerAgua,
	o.fi_inv_local_propio AS InvLocalPropio,
	o.fi_inv_serv_sanitario AS InvSerSanitario,
	o.fi_inv_escritorios AS InvEscritorios,
	o.fi_inv_sillas AS InvSillas,
	o.fi_inv_archiveros AS InvArchiveros,
	o.fi_inv_computo_priv AS InvCompPriv,
	o.fi_inv_computo_gob AS InvCompGob,
	o.fi_inv_escaner_priv AS InvEscanPriv,
	o.fi_inv_escaner_gob AS InvEscanGob,
	o.fi_inv_impresora_priv AS InvImpPriv,
	o.fi_inv_impresora_gob AS InvImpGob,
	o.fi_equi_internet AS EquiNet,
	o.fi_equi_trab_internet AS EquiTrabNet,
	o.fi_equi_vent_express AS EquiVentExpress,
	o.fi_equi_con_drc AS EquiConDrc,
	o.fi_expide_curp AS ExpideCurp,
	o.fi_expide_actas_foraneas AS ExpideActasForaneas,
	o.fi_estatus_id AS EstatusId,
	o.fd_fecha_alta AS FechaAlta,
	o.fd_fecha_act AS FechaAct
	FROM SDB.TAOficinas o
	INNER JOIN SDB.CTTipoOficina t
	ON o.fi_tipo_id = t.fi_tipo_oficina_id
	INNER JOIN SDB.CTLocalidad l
	ON o.fi_edo_id = l.fi_loc_edo_id AND o.fi_mpio_id = L.fi_loc_mpio_id AND o.fi_loc_id = l.fi_loc_id
	WHERE o.fi_oid = @pi_o_id
	ORDER BY o.fi_mpio_id,o.fi_loc_id ASC
	
	SELECT @po_msg_code=0, @po_msg = 'La ejecución del procedimiento fue exitosa'	

END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al obtener la Oficina ' + ERROR_MESSAGE()
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO


IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRInsOficina') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRInsOficina
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que inserta las Oficinas
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  

CREATE PROCEDURE SDB.PRInsOficina(
@pi_oficina_id int,
@pi_tipo_id int,
@pc_tipo_institucion varchar(60),
@pc_institucion varchar(30),
@pc_latitud varchar(20),
@pc_longitud varchar(20),
@pc_region varchar(20),
@pi_edo_id int=5,
@pi_mpio_id int,
@pi_loc_id int, 
@pc_calle varchar(60),
@pc_numero varchar(10),
@pc_colonia varchar(60),
@pc_cp varchar(5),
@pc_entre_calles varchar(200),
@pc_horario_atencion varchar(50),
@pc_telefono varchar(25),
@pc_oficial_nombre varchar(80),
@pc_oficial_apellidos varchar(80),
@pc_oficial_correo_e varchar(60),
@pi_inv_serv_luz tinyint,
@pi_inv_serv_agua tinyint,
@pi_inv_local_propio tinyint,
@pi_inv_serv_sanitario tinyint,
@pi_inv_escritorios tinyint,
@pi_inv_sillas tinyint,
@pi_inv_archiveros tinyint,
@pi_inv_computo_priv tinyint,
@pi_inv_computo_gob tinyint,
@pi_inv_escaner_priv tinyint,
@pi_inv_escaner_gob tinyint,
@pi_inv_impresora_priv tinyint,
@pi_inv_impresora_gob tinyint,
@pi_equi_internet tinyint,
@pi_equi_trab_internet tinyint,
@pi_equi_vent_express tinyint,
@pi_equi_con_drc tinyint,
@pi_expide_curp tinyint,
@pi_expide_actas_foraneas tinyint,
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 	
DECLARE 	
	
@viConsecutivo INT
	
SET NOCOUNT ON

IF EXISTS(SELECT 1 FROM SDB.TAOficinas WHERE fi_Oficina_id = @pi_Oficina_id and fi_tipo_id =  @pi_tipo_id AND fi_edo_id = @pi_edo_id AND fi_mpio_id=@pi_mpio_id)
BEGIN
	SELECT @po_msg_code=-1, @po_msg = 'El número de Oficina ya existe, favor de validar la información'
	GOTO ERROR
END

BEGIN TRY		

	--Obtiene el consecutivo para el número de Oficina
	SELECT 
		@viConsecutivo = ISNULL(MAX(fi_oid), 0) + 1 
	FROM 
		SDB.TAOficinas WITH(ROWLOCK, UPDLOCK) 

END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al obtener el número de consecutivo' + ERROR_MESSAGE()
		GOTO ERROR
END CATCH

BEGIN TRY
	INSERT INTO SDB.TAOficinas 
		   (fi_oid,
			fi_oficina_id,
			fi_tipo_id,
			fc_tipo_institucion,
			fc_institucion,
			fc_latitud,
			fc_longitud,
			fc_region,
			fi_edo_id,
			fi_mpio_id,
			fi_loc_id,			
			fc_calle,
			fc_numero,
			fc_colonia,
			fc_cp,
			fc_entre_calles,
			fc_horario_atencion,
			fc_telefono,
			fc_oficial_nombre,
			fc_oficial_apellidos,
			fc_oficial_correo_e,
			fi_inv_serv_luz,
			fi_inv_serv_agua,
			fi_inv_local_propio,
			fi_inv_serv_sanitario,
			fi_inv_escritorios,
			fi_inv_sillas,
			fi_inv_archiveros,
			fi_inv_computo_priv,
			fi_inv_computo_gob,
			fi_inv_escaner_priv,
			fi_inv_escaner_gob,
			fi_inv_impresora_priv,
			fi_inv_impresora_gob,
			fi_equi_internet,
			fi_equi_trab_internet,
			fi_equi_vent_express,
			fi_equi_con_drc,
			fi_expide_curp,
			fi_expide_actas_foraneas)
     VALUES
           (@viConsecutivo,
			@pi_oficina_id,
			@pi_tipo_id,
			@pc_tipo_institucion,
			@pc_institucion,
			@pc_latitud,
			@pc_longitud,
			@pc_region,
			@pi_edo_id,
			@pi_mpio_id,
			@pi_loc_id,
			@pc_calle,
			@pc_numero,
			@pc_colonia,
			@pc_cp,
			@pc_entre_calles,
			@pc_horario_atencion,
			@pc_telefono,
			@pc_oficial_nombre,
			@pc_oficial_apellidos,
			@pc_oficial_correo_e,
			@pi_inv_serv_luz,
			@pi_inv_serv_agua,
			@pi_inv_local_propio,
			@pi_inv_serv_sanitario,
			@pi_inv_escritorios,
			@pi_inv_sillas,
			@pi_inv_archiveros,
			@pi_inv_computo_priv,
			@pi_inv_computo_gob,
			@pi_inv_escaner_priv,
			@pi_inv_escaner_gob,
			@pi_inv_impresora_priv,
			@pi_inv_impresora_gob,
			@pi_equi_internet,
			@pi_equi_trab_internet,
			@pi_equi_vent_express,
			@pi_equi_con_drc,
			@pi_expide_curp,
			@pi_expide_actas_foraneas)

	SELECT @po_msg_code=0, @po_msg = 'La ejecución del procedimiento fue exitosa'	

END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al insertar Oficina ' + ERROR_MESSAGE()
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO
  

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRUOficina') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRUOficina
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que actualiza las Oficinas
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRUOficina(
@pi_o_id int,
@pi_oficina_id int,
@pi_tipo_id int,
@pc_tipo_institucion varchar(60),
@pc_institucion varchar(30),
@pc_latitud varchar(20),
@pc_longitud varchar(20),
@pc_region varchar(20),
@pi_edo_id int,
@pi_mpio_id int,
@pi_loc_id int, 
@pc_calle varchar(60),
@pc_numero varchar(10),
@pc_colonia varchar(60),
@pc_cp varchar(5),
@pc_entre_calles varchar(200),
@pc_horario_atencion varchar(50),
@pc_telefono varchar(15),
@pc_oficial_nombre varchar(80),
@pc_oficial_apellidos varchar(80),
@pc_oficial_correo_e varchar(60),
@pi_inv_serv_luz tinyint,
@pi_inv_serv_agua tinyint,
@pi_inv_local_propio tinyint,
@pi_inv_serv_sanitario tinyint,
@pi_inv_escritorios tinyint,
@pi_inv_sillas tinyint,
@pi_inv_archiveros tinyint,
@pi_inv_computo_priv tinyint,
@pi_inv_computo_gob tinyint,
@pi_inv_escaner_priv tinyint,
@pi_inv_escaner_gob tinyint,
@pi_inv_impresora_priv tinyint,
@pi_inv_impresora_gob tinyint,
@pi_equi_internet tinyint,
@pi_equi_trab_internet tinyint,
@pi_equi_vent_express tinyint,
@pi_equi_con_drc tinyint,
@pi_expide_curp tinyint,
@pi_expide_actas_foraneas tinyint,
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 	DECLARE
@vdFechaActual	DATETIME
	
SET NOCOUNT ON

BEGIN TRY
	
	SELECT @vdFechaActual = SYSDATETIME()
	
	UPDATE SDB.TAOficinas 
	SET         
		fi_oficina_id = @pi_oficina_id,
		fi_tipo_id = @pi_tipo_id,
		fc_tipo_institucion = @pc_tipo_institucion,
		fc_institucion = @pc_institucion,
		fc_latitud = @pc_latitud,
		fc_longitud = @pc_longitud,
		fc_region = @pc_region,
		fi_edo_id = @pi_edo_id,
		fi_mpio_id = @pi_mpio_id,
		fi_loc_id = @pi_loc_id,
		fc_calle = @pc_calle,
		fc_numero = @pc_numero,
		fc_colonia = @pc_colonia,
		fc_cp = @pc_cp,
		fc_entre_calles = @pc_entre_calles,
		fc_horario_atencion = @pc_horario_atencion,
		fc_telefono = @pc_telefono,
		fc_oficial_nombre = @pc_oficial_nombre,
		fc_oficial_apellidos = @pc_oficial_apellidos,
		fc_oficial_correo_e = @pc_oficial_correo_e,
		fi_inv_serv_luz = @pi_inv_serv_luz,
		fi_inv_serv_agua = @pi_inv_serv_agua,
		fi_inv_local_propio = @pi_inv_local_propio,
		fi_inv_serv_sanitario = @pi_inv_serv_sanitario,
		fi_inv_escritorios = @pi_inv_escritorios,
		fi_inv_sillas = @pi_inv_sillas,
		fi_inv_archiveros = @pi_inv_archiveros,
		fi_inv_computo_priv = @pi_inv_computo_priv,
		fi_inv_computo_gob = @pi_inv_computo_gob,
		fi_inv_escaner_priv = @pi_inv_escaner_priv,
		fi_inv_escaner_gob = @pi_inv_escaner_gob,
		fi_inv_impresora_priv = @pi_inv_impresora_priv,
		fi_inv_impresora_gob = @pi_inv_impresora_gob,
		fi_equi_internet = @pi_equi_internet,
		fi_equi_trab_internet = @pi_equi_trab_internet,
		fi_equi_vent_express = @pi_equi_vent_express,
		fi_equi_con_drc = @pi_equi_con_drc,
		fi_expide_curp = @pi_expide_curp,
		fi_expide_actas_foraneas = @pi_expide_actas_foraneas,
		fd_fecha_act = @vdFechaActual
     WHERE
		fi_oid = @pi_o_id

	SELECT @po_msg_code=0, @po_msg = 'La ejecución del procedimiento fue exitosa'	

END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al actualizar Oficina ' + ERROR_MESSAGE()
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRDelOficina') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRDelOficina
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que elimina las Oficinas
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRDelOficina(
@pi_o_id int,
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 	DECLARE
@vdFechaActual	DATETIME
	
SET NOCOUNT ON

BEGIN TRY
	
	SELECT @vdFechaActual = SYSDATETIME()
	
	UPDATE SDB.TAOficinas 
	SET         
		fi_estatus_id = 2
	    ,fd_fecha_act = @vdFechaActual
     WHERE
		fi_oid = @pi_o_id

	SELECT @po_msg_code=0, @po_msg = 'La ejecución del procedimiento fue exitosa'	

END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al eliminar Oficina ' + ERROR_MESSAGE()
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO
