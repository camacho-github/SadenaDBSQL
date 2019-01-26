USE SADENADB
GO

--ALTER USER [UserDev] WITH DEFAULT_SCHEMA = SDB;

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un Schema  
--- Aplicacion:  SADENADB  
---------------------------------------------------------------------------------------------------------------------------------- 
IF NOT EXISTS ( SELECT  * FROM    sys.schemas  WHERE   name = N'SDB' ) 
    EXEC('CREATE SCHEMA [SDB] AUTHORIZATION [dbo]');
GO

IF EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.CTControlTipo') AND SysStat & 0xf = 3)
BEGIN
	
	IF EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.FK003TAControlCarga'))
	BEGIN
		ALTER TABLE SDB.TAControlCarga DROP CONSTRAINT FK003TAControlCarga 
	END	

	DROP TABLE SDB.CTControlTipo
END
GO 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación del catálogo tipo de carga
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.CTControlTipo') AND SysStat & 0xf = 3)
BEGIN
	CREATE TABLE SDB.CTControlTipo 
	( 
	fi_control_tipo_id int NOT NULL,
	fc_control_tipo_desc varchar(30) NOT NULL
	); 
END
GO 

IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.PK001CTControlTipo'))
BEGIN
	ALTER TABLE SDB.CTControlTipo 
	ADD CONSTRAINT PK001CTControlTipo PRIMARY KEY CLUSTERED (fi_control_tipo_id); 
END
GO

IF EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.CTEstatusRegistro') AND SysStat & 0xf = 3)
BEGIN
	DROP TABLE SDB.CTEstatusRegistro
END
GO 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación del catálogo estatus del registro 
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.CTEstatusRegistro') AND SysStat & 0xf = 3)
BEGIN
	CREATE TABLE SDB.CTEstatusRegistro 
	( 
	fi_estatus_registro_id int NOT NULL,
	fi_estatus_registro_desc varchar(30) NOT NULL
	); 
END
GO 

IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.PK001CTEstatusRegistro'))
BEGIN
	ALTER TABLE SDB.CTEstatusRegistro 
	ADD CONSTRAINT PK001CTEstatusRegistro PRIMARY KEY CLUSTERED (fi_estatus_registro_id); 
END
GO


IF EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.CTSexo') AND SysStat & 0xf = 3)
BEGIN
	DROP TABLE SDB.CTSexo
END
GO 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación del catálogo sexo  
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.CTSexo') AND SysStat & 0xf = 3)
BEGIN
	CREATE TABLE SDB.CTSexo 
	( 
	fi_sexo_id int NOT NULL,
	fc_sexo_desc varchar(20) NOT NULL
	); 
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de la llave primaria para la tabla CatSexo  
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.PK001CTSexo'))
BEGIN
	ALTER TABLE SDB.CTSexo 
	ADD CONSTRAINT PK001CTSexo PRIMARY KEY CLUSTERED (fi_sexo_id); 
END
GO 


IF EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.CTEdoCivil') AND SysStat & 0xf = 3)
BEGIN
	DROP TABLE SDB.CTEdoCivil
END
GO 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación del catálogo edo civil  
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.CTEdoCivil') AND SysStat & 0xf = 3)
BEGIN
	CREATE TABLE SDB.CTEdoCivil 
	( 
	fi_edo_civil_id int NOT NULL,
	fc_edo_civil_desc varchar(20) NOT NULL
	); 
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de la llave primaria para la tabla CatEdoCivil  
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.PK001CTEdoCivil'))
BEGIN
	ALTER TABLE SDB.CTEdoCivil 
	ADD CONSTRAINT PK001CTEdoCivil PRIMARY KEY CLUSTERED (fi_edo_civil_id); 
END
GO 


IF EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.CTEscolaridad') AND SysStat & 0xf = 3)
BEGIN
	DROP TABLE SDB.CTEscolaridad
END
GO 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación del catálogo escolaridad 
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.CTEscolaridad') AND SysStat & 0xf = 3)
BEGIN
	CREATE TABLE SDB.CTEscolaridad 
	( 
	fi_escol_id int NOT NULL,
	fc_escol_desc varchar(40) NOT NULL
	); 
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de la llave primaria para la tabla escolaridad  
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.PK001CTEscolaridad'))
BEGIN
	ALTER TABLE SDB.CTEscolaridad 
	ADD CONSTRAINT PK001CTEscolaridad PRIMARY KEY CLUSTERED (fi_escol_id); 
END
GO 


IF EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.CTMunicipio') AND SysStat & 0xf = 3)
BEGIN
	DROP TABLE SDB.CTMunicipio
END
GO 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación del catálogo municipios 
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.CTMunicipio') AND SysStat & 0xf = 3)
BEGIN
	CREATE TABLE SDB.CTMunicipio 
	( 
	fi_mpio_id int NOT NULL,
	fc_mpio_desc varchar(30) NOT NULL,
	fc_latitud varchar(20) NOT NULL,
	fc_longitud varchar(20) NOT NULL,
	fc_poligono geometry null
	); 
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de la llave primaria para la tabla localidad  
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.PK001CTMunicipio'))
BEGIN
	ALTER TABLE SDB.CTMunicipio 
	ADD CONSTRAINT PK001CTMunicipio PRIMARY KEY CLUSTERED (fi_mpio_id); 
END
GO 

IF EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.CTLocalidad') AND SysStat & 0xf = 3)
BEGIN
	DROP TABLE SDB.CTLocalidad
END
GO 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación del catálogo localidad 
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.CTLocalidad') AND SysStat & 0xf = 3)
BEGIN
	CREATE TABLE SDB.CTLocalidad 
	( 
	fi_loc_edo_id int NOT NULL,
	fc_loc_edo_desc varchar(60) NOT NULL,
	fi_loc_mpio_id int NOT NULL,
	fc_loc_mpio_desc varchar(60) NOT NULL,
	fi_loc_id int NOT NULL,
	fc_loc_desc varchar(60)
	); 
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de la llave primaria para la tabla localidad  
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.PK001CTLocalidad'))
BEGIN
	ALTER TABLE SDB.CTLocalidad 
	ADD CONSTRAINT PK001CTLocalidad PRIMARY KEY CLUSTERED (fi_loc_edo_id,fi_loc_mpio_id,fi_loc_id); 
END
GO 


--ALTER USER [UserDev] WITH DEFAULT_SCHEMA = SDB;

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación del catálogo roles
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.CTRol') AND SysStat & 0xf = 3)
BEGIN
	CREATE TABLE SDB.CTRol 
	( 
	fi_rol_id int NOT NULL,
	fc_rol_desc varchar(30) NOT NULL
	); 
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de la llave primaria para el catálogo roles
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.PK001CTRol'))
BEGIN
	ALTER TABLE SDB.CTRol 
	ADD CONSTRAINT PK001CTRol PRIMARY KEY CLUSTERED (fi_rol_id); 
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación del catálogo status (usuario, sesión)
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.CTEstatus') AND SysStat & 0xf = 3)
BEGIN
	CREATE TABLE SDB.CTEstatus 
	( 
	fi_estatus_id int NOT NULL,
	fc_estatus_desc varchar(30) NOT NULL
	); 
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de la llave primaria para el catálogo roles
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.PK001CTEstatus'))
BEGIN
	ALTER TABLE SDB.CTEstatus
	ADD CONSTRAINT PK001CTEstatus PRIMARY KEY CLUSTERED (fi_estatus_id); 
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación del catálogo Estatus de control
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.CTEstatusControl') AND SysStat & 0xf = 3)
BEGIN
	CREATE TABLE SDB.CTEstatusControl 
	( 
	fi_estatus_control_id int NOT NULL,
	fc_descripcion varchar(30) NOT NULL
	); 
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de la llave primaria para el catálogo de estatus de carga
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.PK001CTEstatusControl'))
BEGIN
	ALTER TABLE SDB.CTEstatusControl 
	ADD CONSTRAINT PK001CTEstatusControl PRIMARY KEY CLUSTERED (fi_estatus_control_id); 
END
GO 





