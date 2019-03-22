USE SADENADB
IF EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.TAOficialias') AND SysStat & 0xf = 3)
BEGIN
	DROP TABLE SDB.TAOficialias	
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de la tabla Oficialias
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.TAOficialias') AND SysStat & 0xf = 3)
BEGIN
	CREATE TABLE SDB.TAOficialias
	( 
	fi_oid int NOT NULL,
	fi_oficialia_id int NOT NULL, 	
	fi_edo_id int NOT NULL,
	fi_mpio_id int NOT NULL,
	fi_loc_id int NOT NULL,
	fc_calle varchar(60) NOT NULL,
	fc_numero varchar(10) NOT NULL,
	fc_colonia varchar(60) NOT NULL,
	fc_cp varchar(5) NOT NULL,
	fc_telefono varchar(15),
	fc_nombres varchar(80),
	fc_apellidos varchar(80),
	fc_correo_e varchar(60),
	fc_latitud varchar(20) NOT NULL,
	fc_longitud varchar(20) NOT NULL,
	fc_observaciones varchar(255),
	fi_estatus_id int NOT NULL,
	fd_fecha_alta datetime NOT NULL,
	fd_fecha_act datetime NOT NULL
	); 
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de la llave primaria para la tabla de oficialias
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.PK001TAOficialias'))
BEGIN
	ALTER TABLE SDB.TAOficialias 
	ADD CONSTRAINT PK001TAOficialias PRIMARY KEY CLUSTERED (fi_oid); 
END
GO

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un constraint default para la tabla oficialias 
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.DEF001TAOficialias'))
BEGIN
	ALTER TABLE SDB.TAOficialias
	ADD CONSTRAINT DEF001TAOficialias 
	DEFAULT (SYSDATETIME()) FOR fd_fecha_alta;  	
END
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.DEF002TAOficialias'))
BEGIN
	ALTER TABLE SDB.TAOficialias
	ADD CONSTRAINT DEF002TAOficialias
	DEFAULT (SYSDATETIME()) FOR fd_fecha_act;  	
END
GO
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.DEF003TAOficialias'))
BEGIN
	ALTER TABLE SDB.TAOficialias
	ADD CONSTRAINT DEF003TAOficialias
	DEFAULT (5) FOR fi_edo_id;  	
END
GO
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.DEF004TAOficialias'))
BEGIN
	ALTER TABLE SDB.TAOficialias
	ADD CONSTRAINT DEF004TAOficialias
	DEFAULT (1) FOR fi_estatus_id;  	
END
GO

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de la llave foranea para la tabla oficialias
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.FK001TAOficialias'))
BEGIN
	ALTER TABLE SDB.TAOficialias 
	ADD CONSTRAINT FK001TAOficialias 
	FOREIGN KEY (fi_edo_id,fi_mpio_id,fi_loc_id) REFERENCES SDB.CTLocalidad(fi_loc_edo_id,fi_loc_mpio_id,fi_loc_id);  
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de la llave foranea para la tabla oficialias
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.FK003TAOficialias'))
BEGIN
	ALTER TABLE SDB.TAOficialias 
	ADD CONSTRAINT FK002TAOficialias 
	FOREIGN KEY (fi_estatus_id) REFERENCES SDB.CTEstatus(fi_estatus_id);  
END
GO 

