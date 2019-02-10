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
