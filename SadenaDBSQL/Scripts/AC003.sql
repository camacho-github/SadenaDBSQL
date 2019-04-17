USE SADENADB
GO

SET NOCOUNT ON	

BEGIN
	IF EXISTS( SELECT fi_parametro_id FROM SDB.TAParametros WITH( NOLOCK ))
	BEGIN
		DELETE FROM SDB.TAParametros
	END
	--------------------------------------------------------------------------------------------------------------------------------      
	-- Responsable: Jorge Alberto de la Rosa  
	-- Fecha      : Diciembre 2018  
	-- Descripcion: Alta de registros de oficialias
	-- Aplicacion:  SADENADB  
	--------------------------------------------------------------------------------------------------------------------------------  
	IF NOT EXISTS( SELECT fi_parametro_id FROM SDB.TAParametros WITH( NOLOCK ))
	BEGIN	
		INSERT INTO SDB.TAParametros (fi_parametro_id,fi_parametro_descripcion,fi_parametro_valor) VALUES(1,'Valor de registro extemporaneo',60)
	END

END
