USE SADENADB
GO

 
IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSOficialias') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSOficialias
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que consulta las oficialias
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSOficialias(
@pc_municipios VARCHAR(255),
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 	
	
	SET NOCOUNT ON

BEGIN TRY		

	SELECT o.fi_oid AS OId,o.fi_oficialia_id AS OficialiaId,
	o.fi_mpio_id AS MpioId, l.fc_loc_mpio_desc AS MpioDesc, o.fi_loc_id AS LocId, l.fc_loc_desc AS LocDesc,
	o.fc_calle AS Calle,o.fc_numero AS Numero,o.fc_colonia AS Colonia,o.fc_cp AS CP,
	o.fc_telefono AS Telefono, o.fc_nombres AS Nombres, o.fc_apellidos AS Apellidos, 
	o.fc_correo_e AS CorreoE, o.fc_latitud AS Latitud, o.fc_longitud AS Longitud, 
	o.fc_observaciones AS Observaciones 
	FROM SDB.TAOficialias o
	INNER JOIN SDB.CTLocalidad l
	ON o.fi_edo_id = l.fi_loc_edo_id AND o.fi_mpio_id = L.fi_loc_mpio_id AND o.fi_loc_id = l.fi_loc_id
	WHERE o.fi_edo_id = 5 AND
	(@pc_municipios IS NULL OR (o.fi_mpio_id IN(SELECT Mun.numero FROM SDB.FNConvierteCadenaEnTablaEnteros(@pc_municipios) Mun)))
	
	SELECT @po_msg_code=0, @po_msg = 'La ejecución del procedimiento fue exitosa'	

END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al obtener las oficialias ' + ERROR_MESSAGE()
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO

 IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSOficialia') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSOficialia
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que consulta una oficialia
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSOficialia(
@pi_oid int,
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 	
	
	SET NOCOUNT ON

BEGIN TRY		

	SELECT o.fi_oid AS OId,o.fi_oficialia_id AS OficialiaId,
	o.fi_mpio_id AS MpioId, l.fc_loc_mpio_desc AS MpioDesc, o.fi_loc_id AS LocId, l.fc_loc_desc AS LocDesc,
	o.fc_calle AS Calle,o.fc_numero AS Numero,o.fc_colonia AS Colonia,o.fc_cp AS CP,
	o.fc_telefono AS Telefono, o.fc_nombres AS Nombres, o.fc_apellidos AS Apellidos, 
	o.fc_correo_e AS CorreoE, o.fc_latitud AS Latitud, o.fc_longitud AS Longitud, 
	o.fc_observaciones AS Observaciones 
	FROM SDB.TAOficialias o
	INNER JOIN SDB.CTLocalidad l
	ON o.fi_edo_id = l.fi_loc_edo_id AND o.fi_mpio_id = L.fi_loc_mpio_id AND o.fi_loc_id = l.fi_loc_id
	WHERE o.fi_oid = @pi_oid
	
	SELECT @po_msg_code=0, @po_msg = 'La ejecución del procedimiento fue exitosa'	

END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al obtener la oficialia ' + ERROR_MESSAGE()
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO


 IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRInsOficialia') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRInsOficialia
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que inserta las oficialias
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRInsOficialia(
@pi_oficialia_id int,
@pi_mpio_id int,
@pi_loc_id int,
@pc_calle varchar(60),
@pc_numero varchar(10),
@pc_colonia varchar(60),
@pc_cp varchar(5),
@pc_telefono varchar(15),
@pc_nombres varchar(80),
@pc_apellidos varchar(80),
@pc_correo_e varchar(60),
@pc_latitud varchar(20),
@pc_longitud varchar(20),
@pc_observaciones varchar(255),
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 	
DECLARE 	
	
@viConsecutivo INT
	
SET NOCOUNT ON

IF EXISTS(SELECT 1 FROM SDB.TAOFICIALIAS WHERE fi_oficialia_id = @pi_oficialia_id)
BEGIN
	SELECT @po_msg_code=-1, @po_msg = 'El número de Oficialía ya existe, favor de validar la información'
	GOTO ERROR
END

BEGIN TRY		

	--Obtiene el consecutivo para el número de Oficialia
	SELECT 
		@viConsecutivo = ISNULL(MAX(fi_oid), 0) + 1 
	FROM 
		SDB.TAOficialias WITH(ROWLOCK, UPDLOCK) 
END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al obtener el número de consecutivo' + ERROR_MESSAGE()
		GOTO ERROR
END CATCH

BEGIN TRY
	INSERT INTO SDB.TAOficialias 
		   (fi_oid
           ,fi_oficialia_id
           ,fi_mpio_id
           ,fi_loc_id
           ,fc_calle
           ,fc_numero
           ,fc_colonia
           ,fc_cp
           ,fc_telefono
           ,fc_nombres
           ,fc_apellidos
           ,fc_correo_e
           ,fc_latitud
           ,fc_longitud
           ,fc_observaciones)
     VALUES
           (@viConsecutivo,
		    @pi_oficialia_id,
			@pi_mpio_id,
			@pi_loc_id,
			@pc_calle,
			@pc_numero,
			@pc_colonia,
			@pc_cp,
			@pc_telefono,
			@pc_nombres,
			@pc_apellidos,
			@pc_correo_e,
			@pc_latitud,
			@pc_longitud,
			@pc_observaciones)

	SELECT @po_msg_code=0, @po_msg = 'La ejecución del procedimiento fue exitosa'	

END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al insertar oficialia ' + ERROR_MESSAGE()
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO
  

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRUOficialia') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRUOficialia
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que actualiza las oficialias
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRUOficialia(
@pi_o_id int,
@pi_oficialia_id int,
@pi_mpio_id int,
@pi_loc_id int,
@pc_calle varchar(60),
@pc_numero varchar(10),
@pc_colonia varchar(60),
@pc_cp varchar(5),
@pc_telefono varchar(15),
@pc_nombres varchar(80),
@pc_apellidos varchar(80),
@pc_correo_e varchar(60),
@pc_latitud varchar(20),
@pc_longitud varchar(20),
@pc_observaciones varchar(255),
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 	DECLARE
@vdFechaActual	DATETIME
	
SET NOCOUNT ON

BEGIN TRY
	
	SELECT @vdFechaActual = SYSDATETIME()
	
	UPDATE SDB.TAOficialias 
	SET 
        fi_oficialia_id = @pi_oficialia_id
        ,fi_mpio_id = @pi_mpio_id
        ,fi_loc_id = @pi_loc_id
        ,fc_calle = @pc_calle
        ,fc_numero = @pc_numero
        ,fc_colonia = @pc_colonia
        ,fc_cp = @pc_cp
        ,fc_telefono = @pc_telefono
        ,fc_nombres = @pc_nombres
        ,fc_apellidos = @pc_apellidos
        ,fc_correo_e = @pc_correo_e
        ,fc_latitud = @pc_latitud
        ,fc_longitud = @pc_longitud
        ,fc_observaciones = @pc_observaciones
		,fd_fecha_act = @vdFechaActual
     WHERE
		fi_oid = @pi_o_id

	SELECT @po_msg_code=0, @po_msg = 'La ejecución del procedimiento fue exitosa'	

END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al actualizar oficialia ' + ERROR_MESSAGE()
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO




IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRDelOficialia') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRDelOficialia
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que elimina las oficialias
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRDelOficialia(
@pi_o_id int,
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 	DECLARE
@vdFechaActual	DATETIME
	
SET NOCOUNT ON

BEGIN TRY
	
	SELECT @vdFechaActual = SYSDATETIME()
	
	UPDATE SDB.TAOficialias 
	SET         
		fi_estatus_id = 2
	    ,fd_fecha_act = @vdFechaActual
     WHERE
		fi_oid = @pi_o_id

	SELECT @po_msg_code=0, @po_msg = 'La ejecución del procedimiento fue exitosa'	

END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al eliminar oficialia ' + ERROR_MESSAGE()
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO
