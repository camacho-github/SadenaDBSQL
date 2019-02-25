IF EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.TAOficinas') AND SysStat & 0xf = 3)
BEGIN
	DROP TABLE SDB.TAOficinas	
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de la tabla Oficinas
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.TAOficinas') AND SysStat & 0xf = 3)
BEGIN
	CREATE TABLE SDB.TAOficinas
	( 
	fi_oid int NOT NULL,
	fi_oficina_id int,
	fi_tipo_id int,	
	fc_tipo_institucion varchar(30),
	fc_institucion varchar(30),
	fc_latitud varchar(20),
	fc_longitud varchar(20),
	fc_region varchar(20),
	fi_edo_id int,
	fi_mpio_id int,
	fi_loc_id int,
	fc_calle varchar(60),
	fc_numero varchar(10),
	fc_colonia varchar(60),
	fc_cp varchar(5),
	fc_entre_calles varchar(200),
	fc_horario_atencion varchar(50),
	fc_telefono varchar(25),
	fc_oficial_nombre varchar(80),
	fc_oficial_apellidos varchar(80),
	fc_oficial_correo_e varchar(60),
	fi_inv_serv_luz tinyint,
	fi_inv_serv_agua tinyint,
	fi_inv_local_propio tinyint,
	fi_inv_serv_sanitario tinyint,
	fi_inv_escritorios tinyint,
	fi_inv_sillas tinyint,
	fi_inv_archiveros tinyint,
	fi_inv_computo_priv tinyint,
	fi_inv_computo_gob tinyint,
	fi_inv_escaner_priv tinyint,
	fi_inv_escaner_gob tinyint,
	fi_inv_impresora_priv tinyint,
	fi_inv_impresora_gob tinyint,
	fi_equi_internet tinyint,
	fi_equi_trab_internet tinyint,
	fi_equi_vent_express tinyint,
	fi_equi_con_drc tinyint,
	fi_expide_curp tinyint,
	fi_expide_actas_foraneas tinyint,
	fi_estatus_id int NOT NULL,
	fd_fecha_alta datetime NOT NULL,
	fd_fecha_act datetime NOT NULL
	); 
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de la llave primaria para la tabla de oficinas
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.PK001TAOficinas'))
BEGIN
	ALTER TABLE SDB.TAOficinas 
	ADD CONSTRAINT PK001TAOficinas PRIMARY KEY CLUSTERED (fi_oid); 
END
GO

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un constraint default para la tabla oficinas 
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.DEF001TAOficinas'))
BEGIN
	ALTER TABLE SDB.TAOficinas
	ADD CONSTRAINT DEF001TAOficinas 
	DEFAULT (SYSDATETIME()) FOR fd_fecha_alta;  	
END
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.DEF002TAOficinas'))
BEGIN
	ALTER TABLE SDB.TAOficinas
	ADD CONSTRAINT DEF002TAOficinas
	DEFAULT (SYSDATETIME()) FOR fd_fecha_act;  	
END
GO
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.DEF003TAOficinas'))
BEGIN
	ALTER TABLE SDB.TAOficinas
	ADD CONSTRAINT DEF003TAOficinas
	DEFAULT (5) FOR fi_edo_id;  	
END
GO
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.DEF004TAOficinas'))
BEGIN
	ALTER TABLE SDB.TAOficinas
	ADD CONSTRAINT DEF004TAOficinas
	DEFAULT (1) FOR fi_estatus_id;  	
END
GO

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de la llave foranea para la tabla oficialias
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.FK001TAOficinas'))
BEGIN
	ALTER TABLE SDB.TAOficinas 
	ADD CONSTRAINT FK001TAOficinas 
	FOREIGN KEY (fi_edo_id,fi_mpio_id,fi_loc_id) REFERENCES SDB.CTLocalidad(fi_loc_edo_id,fi_loc_mpio_id,fi_loc_id);  
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de la llave foranea para la tabla oficialias
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.FK003TAOficinas'))
BEGIN
	ALTER TABLE SDB.TAOficinas 
	ADD CONSTRAINT FK002TAOficinas 
	FOREIGN KEY (fi_estatus_id) REFERENCES SDB.CTEstatus(fi_estatus_id);  
END
GO 


IF EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.CTTipoOficina') AND SysStat & 0xf = 3)
BEGIN
	DROP TABLE SDB.CTTipoOficina
END
GO 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación del catálogo de oficinas
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.CTTipoOficina') AND SysStat & 0xf = 3)
BEGIN
	CREATE TABLE SDB.CTTipoOficina 
	( 
	fi_tipo_oficina_id int NOT NULL,
	fi_tipo_oficina_desc varchar(30) NOT NULL
	); 
END
GO 

IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.PK001CTTipoOficina'))
BEGIN
	ALTER TABLE SDB.CTTipoOficina 
	ADD CONSTRAINT PK001CTTipoOficina PRIMARY KEY CLUSTERED (fi_tipo_oficina_id); 
END
GO
