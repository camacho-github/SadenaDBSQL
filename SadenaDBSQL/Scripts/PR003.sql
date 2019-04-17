USE SADENADB
GO


IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRNIniciarSesion') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRNIniciarSesion
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que valida e inicia la sesi�n de un usuario
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRNIniciarSesion(  
 @pc_identificador varchar(60),  
 @pc_contrasena varchar(40),  
 @pc_ip varchar(31),  
 @po_msg_code INT OUTPUT,  
 @po_msg VARCHAR(255) OUTPUT)  
  
AS  
DECLARE  
 @vi_usuario_id int = -1,  
 @vi_rol_id int,  
 @vi_estatus_id int,  
 @vi_sesion_id int  
    
  
SET NOCOUNT ON  
BEGIN TRY   
 IF EXISTS( SELECT fi_usuario_id FROM SDB.TAUsuario  WITH( NOLOCK ) WHERE fc_usuario = @pc_identificador and fc_contrasena =  @pc_contrasena AND fi_estatus_id = 1)  
 BEGIN  
  SELECT @vi_usuario_id =fi_usuario_id, @vi_rol_id = fi_rol_id  
     FROM SDB.TAUsuario WITH( NOLOCK ) where fc_usuario = @pc_identificador AND fi_estatus_id = 1 
 END  
 ELSE IF EXISTS( SELECT fi_usuario_id FROM SDB.TAUsuario  WITH( NOLOCK ) WHERE fc_correo_e = @pc_identificador and fc_contrasena =  @pc_contrasena AND fi_estatus_id = 1)  
 BEGIN    
  SELECT @vi_usuario_id =fi_usuario_id, @vi_rol_id = fi_rol_id  
     FROM SDB.TAUsuario WITH( NOLOCK ) where fc_correo_e = @pc_identificador AND fi_estatus_id = 1   
     
 END   
 IF(@vi_usuario_id < 0 )
 BEGIN
	SELECT @po_msg_code=0, @po_msg = ' Usuario ' + @pc_identificador + ' no existente.'   
	SET NOCOUNT OFF  
	RETURN 0   
 END

IF EXISTS(SELECT fi_sesion_id FROM SDB.BIUsuarioSesion WITH( NOLOCK ) WHERE fi_usuario_id = @vi_usuario_id AND fi_estatus_id = 1)  
BEGIN  
	UPDATE SDB.BIUsuarioSesion SET fi_estatus_id = 2 ,fd_fecha_act = SYSDATETIME() WHERE fi_usuario_id = @vi_usuario_id AND fi_estatus_id = 1  
	INSERT INTO SDB.BIUsuarioSesion (fi_usuario_id,fc_ip,fi_estatus_id) values(@vi_usuario_id,@pc_ip,1)  
END  
  
IF NOT EXISTS(SELECT fi_sesion_id FROM SDB.BIUsuarioSesion WITH( NOLOCK ) WHERE fi_usuario_id = @vi_usuario_id AND fc_ip = @pc_ip AND fi_estatus_id = 1)  
BEGIN  
	INSERT INTO SDB.BIUsuarioSesion (fi_usuario_id,fc_ip,fi_estatus_id) values(@vi_usuario_id,@pc_ip,1)  
END    
  

SELECT @vi_sesion_id = fi_sesion_id FROM SDB.BIUsuarioSesion WITH( NOLOCK ) WHERE fi_usuario_id = @vi_usuario_id AND fc_ip = @pc_ip AND fi_estatus_id = 1  
  
SELECT @vi_sesion_id as SesionId, U.fi_usuario_id as UsuarioId, U.fc_usuario as UsuarioDesc, U.fc_correo_e as CorreoE, U.fi_rol_id as RolId, R.fc_rol_desc as RolDesc  
    FROM SDB.TAUsuario U  WITH( NOLOCK ) INNER JOIN SDB.CTRol R WITH( NOLOCK ) on U.fi_rol_id = R.fi_rol_id WHERE  U.fi_usuario_id = @vi_usuario_id  
  
SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'    
 
END TRY  
BEGIN CATCH    
  SELECT @po_msg_code=-1, @po_msg = ERROR_MESSAGE() + ' Error al consultar cuenta ' + @pc_identificador  
  GOTO ERROR  
END CATCH  
   
SET NOCOUNT OFF  
RETURN 0        
         
ERROR:          
 RAISERROR (@po_msg,18,1)        
 SET NOCOUNT OFF          
 RETURN -1             
 GO


IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRNFinalizarSesion') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRNFinalizarSesion
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que finaliza la sesi�n de un usuario
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRNFinalizarSesion(
	@pi_sesion_id int,	
	@po_msg_code INT OUTPUT,
	@po_msg	VARCHAR(255) OUTPUT)

AS
DECLARE
	@vi_usuario_id int	 

SET NOCOUNT ON
BEGIN TRY	
	IF EXISTS( SELECT fi_usuario_id FROM SDB.BIUsuarioSesion  WITH( NOLOCK ) WHERE fi_sesion_id = @pi_sesion_id and fi_estatus_id =  1)
	BEGIN
		
		SELECT @vi_usuario_id = fi_usuario_id
		   FROM SDB.BIUsuarioSesion WITH( NOLOCK ) WHERE fi_sesion_id = @pi_sesion_id

		UPDATE SDB.BIUsuarioSesion SET fi_estatus_id = 2,fd_fecha_act = SYSDATETIME() WHERE fi_sesion_id = @pi_sesion_id

		SELECT @pi_sesion_id as SesionId, U.fi_usuario_id as UsuarioId, U.fc_usuario as UsuarioDesc, U.fc_correo_e as CorreoE, U.fi_rol_id as RolId, R.fc_rol_desc as RolDesc
		   FROM SDB.TAUsuario U WITH( NOLOCK ) INNER JOIN SDB.CTRol R WITH( NOLOCK ) on U.fi_rol_id = R.fi_rol_id WHERE  U.fi_usuario_id = @vi_usuario_id

		SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'		
	END
	ELSE
	BEGIN
		SELECT @po_msg_code=1, @po_msg = 'La sesi�n no existe o ya fue cerrada'		
	END
END TRY
BEGIN CATCH		
		SELECT @po_msg_code=-1, @po_msg = 'Error al actualizar la sesi�n ' + @pi_sesion_id
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO

IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSSesionActiva') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSSesionActiva
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que consulta que una sesi�n se encuentre activa
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSSesionActiva(
	@pi_sesion_id int,	
	@po_msg_code int OUTPUT,
	@po_msg	varchar(255) OUTPUT)

AS

SET NOCOUNT ON
BEGIN TRY	
	IF EXISTS( SELECT fi_sesion_id FROM SDB.BIUsuarioSesion  WITH( NOLOCK ) WHERE fi_sesion_id = @pi_sesion_id and fi_estatus_id =  1)
	BEGIN
				
		SELECT @po_msg_code=0, @po_msg = 'La sesi�n se encuentra activa'		
	END
	ELSE
	BEGIN
		SELECT @po_msg_code=1, @po_msg = 'La sesi�n no existe o ya fue cerrada'		
	END
END TRY
BEGIN CATCH		
		SELECT @po_msg_code=-1, @po_msg = 'Error al consultar la sesi�n' + @pi_sesion_id
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO
 
IF EXISTS (SELECT name FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.PRSBIUsuarioSesion') AND SysStat & 0xf = 4)
BEGIN
	DROP PROC SDB.PRSBIUsuarioSesion
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un stored procedure que consulta la bit�cora de usuarios
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE SDB.PRSBIUsuarioSesion(
@po_msg_code INT OUTPUT,
@po_msg	VARCHAR(255) OUTPUT)

AS 		
	SET NOCOUNT ON

BEGIN TRY		

    SET LANGUAGE Spanish

	SELECT top 50 b.fi_sesion_id AS 'Sesi�n ID',b.fi_usuario_id AS 'Usuario ID', u.fc_usuario as 'Usuario',
	r.fc_rol_desc as 'Rol',
	b.fi_estatus_id AS 'Estatus Sesi�n ID',
	CASE
    WHEN b.fi_estatus_id = 1 THEN 'Activa'
	WHEN b.fi_estatus_id = 2 THEN 'Finalizada'
	END AS 'Estatus Sesi�n',
	CONVERT(VARCHAR(20),b.fd_fecha_alta,13) as 'Fecha inicio Sesi�n',
	CASE
    WHEN CONVERT(VARCHAR(20),b.fd_fecha_alta,0) =  CONVERT(VARCHAR(20),b.fd_fecha_act,0) THEN ''
	ELSE CONVERT(VARCHAR(20),b.fd_fecha_act,13) 
	END AS 'Fecha fin Sesi�n' 
	FROM SDB.BIUsuarioSesion b
	INNER JOIN SDB.TAUsuario u on b.fi_usuario_id = u.fi_usuario_id
	INNER JOIN SDB.CTRol r on u.fi_rol_id = r.fi_rol_id	
	where r.fi_rol_id > 0
	order by  b.fi_sesion_id desc
	
	
	SELECT @po_msg_code=0, @po_msg = 'La ejecuci�n del procedimiento fue exitosa'	

END TRY
BEGIN CATCH
		SELECT @po_msg_code=-1, @po_msg = 'Error al obtener la bit�cora ' + ERROR_MESSAGE()
		GOTO ERROR
END CATCH
	
SET NOCOUNT OFF
RETURN 0        
       
ERROR:        
	RAISERROR (@po_msg,18,1)      
	SET NOCOUNT OFF        
	RETURN -1      
 GO
