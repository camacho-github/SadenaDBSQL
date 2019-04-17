USE SADENADB
IF EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.TAParametros') AND SysStat & 0xf = 3)
BEGIN
	DROP TABLE SDB.TAParametros	
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de la tabla parametros
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.TAParametros') AND SysStat & 0xf = 3)
BEGIN
	CREATE TABLE SDB.TAParametros
	( 
	fi_parametro_id int NOT NULL,
	fi_parametro_descripcion VARCHAR(100) NOT NULL,
	fi_parametro_valor int NOT NULL	
	); 
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de la llave primaria para la tabla de parametros
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.PK001TAParametros'))
BEGIN
	ALTER TABLE SDB.TAParametros 
	ADD CONSTRAINT PK001TAParametros PRIMARY KEY CLUSTERED (fi_parametro_id); 
END
GO