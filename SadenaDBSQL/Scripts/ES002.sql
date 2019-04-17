USE SADENADB
GO


IF EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.TMSINAC') AND SysStat & 0xf = 3)
BEGIN
	DROP TABLE SDB.TMSINAC
END
GO 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de la tabla temporal del SINAC
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.TMSINAC') AND SysStat & 0xf = 3)
BEGIN
		
	CREATE TABLE SDB.TMSINAC
	( 
	fc_folio varchar(20) NOT NULL,	
	fi_ent_nacm int NOT NULL,
	fi_mpo_nacm int NOT NULL,
	fd_fech_nac varchar(30) NOT NULL,
	fd_hora_nac varchar(5) NOT NULL,
	fi_edad_m int NOT NULL,
	fi_edocivil int NOT NULL,
	fc_calle_res varchar(80) NOT NULL,
	fc_numext_res varchar(20),
	fc_numint_res varchar(20),	
	fi_ent_res int NOT NULL,
	fi_mpo_res int NOT NULL,
	fi_loc_res int NOT NULL,	
	fi_num_nacvivo int NOT NULL,	
	fi_niv_escol int NOT NULL,
	fc_ocup_hab varchar(60) NOT NULL,
	fi_sexo int NOT NULL
	); 
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un constraint default para la tabla  
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.DEF001TMSINAC'))
BEGIN
	ALTER TABLE SDB.TMSINAC
	ADD CONSTRAINT DEF001TMSINAC 
	DEFAULT (99) FOR fi_ent_nacm;  	
END
GO



IF EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.TASINAC') AND SysStat & 0xf = 3)
BEGIN
	DROP TABLE SDB.TASINAC
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de la tabla SINAC
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.TASINAC') AND SysStat & 0xf = 3)
BEGIN
	CREATE TABLE SDB.TASINAC
	( 
	fc_folio_certificado varchar(20) NOT NULL,
	fc_folio_simple_certificado varchar(20) NOT NULL,
	fi_control_id int NOT NULL,
	fi_ma_edad int NOT NULL,
	fi_ma_edo_civil_id int NOT NULL,	
	fc_ma_dom_calle varchar(80) NOT NULL,
	fc_ma_dom_numext varchar(20),
	fc_ma_dom_numint varchar(20),
	fi_ma_dom_edo_id int NOT NULL,
	fi_ma_dom_mpio_id int NOT NULL,
	fi_ma_dom_loc_id int NOT NULL,
	fi_ma_num_nacimiento int NOT NULL,
	fi_ma_escol_id int NOT NULL,
	fc_ma_ocupacion varchar(60) NOT NULL,
	fd_rn_fecha_hora_nacimiento datetime,
	fi_rn_sexo_id int,
	fi_rn_edo_id int,
	fi_rn_mpio_id int
	); 
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un �ndice para la tabla TASINAC  
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM sys.indexes  WITH(NOLOCK)  WHERE NAME = 'IN001TASINAC')
BEGIN
	CREATE NONCLUSTERED INDEX IN001TASINAC ON SDB.TASINAC (fc_folio_simple_certificado DESC); 
END
GO
IF NOT EXISTS (SELECT name FROM sys.indexes  WITH(NOLOCK)  WHERE NAME = 'IN002TASINAC')
BEGIN
	CREATE NONCLUSTERED INDEX IN002TASINAC ON SDB.TASINAC (fd_rn_fecha_hora_nacimiento DESC); 
END
GO
IF NOT EXISTS (SELECT name FROM sys.indexes  WITH(NOLOCK)  WHERE NAME = 'IN002TASINAC')
BEGIN
	CREATE NONCLUSTERED INDEX IN003TASINAC ON SDB.TASINAC (fi_rn_mpio_id DESC); 
END
GO

IF EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.TMSIC') AND SysStat & 0xf = 3)
BEGIN
	DROP TABLE SDB.TMSIC
END
GO 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de la tabla temporal del SIC
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.TMSIC') AND SysStat & 0xf = 3)
BEGIN
	CREATE TABLE SDB.TMSIC
	( 
	fi_edo_ofi varchar(10) NOT NULL,
	fi_mun_ofi varchar(10) NOT NULL,
	fi_oficialia int NOT NULL,
	fc_ano varchar(4) NULL,
	fc_fecha_reg varchar(30),
	fc_fecha_nac varchar(30),
	fc_localidad varchar(60),
	fi_municipio int,
	fi_estado int NULL,	
	fi_pais int,	
	fc_no_certif varchar(30),
	); 
END
GO 

IF EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.TASIC') AND SysStat & 0xf = 3)
BEGIN
	DROP TABLE SDB.TASIC
END
GO
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de la tabla SINAC
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.TASIC') AND SysStat & 0xf = 3)
BEGIN
	CREATE TABLE SDB.TASIC
	(
	fc_identificador varchar(60) NOT NULL,	
	fc_folio_certificado varchar(20),
	fc_folio_simple_certificado varchar(20) NOT NULL,
	fi_control_id int NOT NULL,
	fi_edo_id int,
	fi_mpio_id int,
	fi_mpio_ofi_id int,
	fi_oficialia_id int,
	fd_rn_fecha_hora_nacimiento datetime,
	fd_rn_fecha_registro datetime,
	fi_estatus_duplicado int
	); 
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un �ndice para la tabla TASINAC  
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM sys.indexes  WITH(NOLOCK)  WHERE NAME = 'IN002TASIC')
BEGIN
	CREATE NONCLUSTERED INDEX IN002TASIC ON SDB.TASIC (fi_mpio_id,fd_rn_fecha_hora_nacimiento); 
END
GO

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un �ndice para la tabla TASINAC  
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM sys.indexes  WITH(NOLOCK)  WHERE NAME = 'IN001TASIC')
BEGIN
	CREATE NONCLUSTERED INDEX IN001TASIC ON SDB.TASIC (fc_folio_simple_certificado DESC); 
END
GO

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de la tabla Usuarios
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.TAUsuario') AND SysStat & 0xf = 3)
BEGIN	
	CREATE TABLE SDB.TAUsuario 
	( 
	fi_usuario_id int NOT NULL,
	fc_usuario varchar(40) NOT NULL, 
	fc_correo_e varchar(60) NOT NULL, 
	fi_rol_id int NOT NULL,
	fi_estatus_id int NOT NULL,
	fc_contrasena varchar(40) NOT NULL,
	fd_fecha_alta datetime NOT NULL,
	fd_fecha_act datetime NOT NULL
	); 
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de la llave primaria para la tabla Usuarios  
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.PK001TAUsuario'))
BEGIN
	ALTER TABLE SDB.TAUsuario 
	ADD CONSTRAINT PK001TAUsuario PRIMARY KEY CLUSTERED (fi_usuario_id); 
END
GO 

 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de la llave foranea para la tabla Usuarios
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.FK001TAUsuario'))
BEGIN
	ALTER TABLE SDB.TAUsuario 
	ADD CONSTRAINT FK001TAUsuario 
	FOREIGN KEY (fi_rol_id) REFERENCES SDB.CTRol(fi_rol_id);  
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de la llave foranea para la tabla Usuarios
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.FK002TAUsuario'))
BEGIN
	ALTER TABLE SDB.TAUsuario 
	ADD CONSTRAINT FK002TAUsuario 
	FOREIGN KEY (fi_estatus_id) REFERENCES SDB.CTEstatus(fi_estatus_id);  
END
GO 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un constraint default para la tabla  
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.DEF001TAUsuario'))
BEGIN
	ALTER TABLE SDB.TAUsuario
	ADD CONSTRAINT DEF001TAUsuario 
	DEFAULT (SYSDATETIME()) FOR fd_fecha_alta;  	
END
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.DEF002TAUsuario'))
BEGIN
	ALTER TABLE SDB.TAUsuario
	ADD CONSTRAINT DEF002TAUsuario 
	DEFAULT (SYSDATETIME()) FOR fd_fecha_act;  	
END
GO


IF EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.BIUsuarioSesion') AND SysStat & 0xf = 3)
BEGIN
	
	IF EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.FK001BIUsuarioSesion'))
	BEGIN
		ALTER TABLE SDB.BIUsuarioSesion DROP CONSTRAINT FK001BIUsuarioSesion 
	END	

	IF  EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.FK001TAControlCarga'))
	BEGIN
		ALTER TABLE SDB.TAControlCarga DROP CONSTRAINT FK001TAControlCarga 	 
	END
	DROP TABLE SDB.BIUsuarioSesion
END
GO 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de la tabla Usuario Sesi�n
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.BIUsuarioSesion') AND SysStat & 0xf = 3)
BEGIN
	CREATE TABLE SDB.BIUsuarioSesion
	( 
	fi_sesion_id int NOT NULL IDENTITY(1,1),
	fi_usuario_id int NOT NULL,
	fc_ip varchar(31) NOT NULL,
	fi_estatus_id int NOT NULL,	
	fd_fecha_alta datetime NOT NULL,
	fd_fecha_act datetime NOT NULL
	); 
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de la llave primaria para el cat�logo roles
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.PK001BIUsuarioSesion'))
BEGIN
	ALTER TABLE SDB.BIUsuarioSesion 
	ADD CONSTRAINT PK001BIUsuarioSesion PRIMARY KEY CLUSTERED (fi_sesion_id); 
END
GO 


----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de la llave foranea para la tabla UsuarioSesion
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.FK001BIUsuarioSesion'))
BEGIN
	ALTER TABLE SDB.BIUsuarioSesion 
	ADD CONSTRAINT FK001BIUsuarioSesion 
	FOREIGN KEY (fi_usuario_id) REFERENCES SDB.TAUsuario(fi_usuario_id);  
END
GO 


----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de un constraint default para la tabla  
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.DEF001BTUsuarioSesion'))
BEGIN
	ALTER TABLE SDB.BIUsuarioSesion
	ADD CONSTRAINT DEF001BTUsuarioSesion 
	DEFAULT (SYSDATETIME()) FOR fd_fecha_alta;  	
END
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.DEF002BTUsuarioSesion'))
BEGIN
	ALTER TABLE SDB.BIUsuarioSesion
	ADD CONSTRAINT DEF002BTUsuarioSesion
	DEFAULT (SYSDATETIME()) FOR fd_fecha_act;  	
END
GO

IF EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.TAControlCarga') AND SysStat & 0xf = 3)
BEGIN
	DROP TABLE SDB.TAControlCarga
END
GO 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de la tabla para control de carga de archivos
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------   
IF NOT EXISTS (SELECT ID FROM SysObjects WITH ( NOLOCK ) WHERE ID = OBJECT_ID('SDB.TAControlCarga') AND SysStat & 0xf = 3)
BEGIN
	CREATE TABLE SDB.TAControlCarga
	( 
	fi_control_id int NOT NULL IDENTITY(1,1),
	fi_sesion_id int NOT NULL,
	fi_control_tipo_id int NOT NULL,
	fc_ano varchar(4) NOT NULL,
	fc_nombre_archivo varchar(255) NOT NULL,
	fi_estatus_control_id int NOT NULL,
	fd_fecha_alta datetime NOT NULL,
	fd_fecha_act datetime NOT NULL
	); 
END
GO  


----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de la llave primaria para la tabla control de carga
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.PK001TAControlCarga'))
BEGIN
	ALTER TABLE SDB.TAControlCarga 
	ADD CONSTRAINT PK001TAControlCarga PRIMARY KEY CLUSTERED (fi_control_id); 
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de la llave foranea para la tabla control de carga
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.FK001TAControlCarga'))
BEGIN
	ALTER TABLE SDB.TAControlCarga 
	ADD CONSTRAINT FK001TAControlCarga 
	FOREIGN KEY (fi_sesion_id) REFERENCES SDB.BIUsuarioSesion(fi_sesion_id);  
END
GO 
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de la llave foranea para la tabla control de carga
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.FK002TAControlCarga'))
BEGIN
	ALTER TABLE SDB.TAControlCarga 
	ADD CONSTRAINT FK002TAControlCarga 
	FOREIGN KEY (fi_estatus_control_id) REFERENCES SDB.CTEstatusControl(fi_estatus_control_id);  
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de la llave foranea para la tabla control de carga y tipo de carga
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.FK003TAControlCarga'))
BEGIN
	ALTER TABLE SDB.TAControlCarga 
	ADD CONSTRAINT FK003TAControlCarga 
	FOREIGN KEY (fi_control_tipo_id) REFERENCES SDB.CTControlTipo(fi_control_tipo_id);  
END
GO 

----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creaci�n de los constraint default para la tabla  TAControlCarga
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.DEF001TAControlCarga'))
BEGIN
	ALTER TABLE SDB.TAControlCarga
	ADD CONSTRAINT DEF001TAControlCarga 
	DEFAULT (SYSDATETIME()) FOR fd_fecha_alta;  	
END
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.DEF002TAControlCarga'))
BEGIN
	ALTER TABLE SDB.TAControlCarga
	ADD CONSTRAINT DEF002TAControlCarga 
	DEFAULT (SYSDATETIME()) FOR fd_fecha_act;  	
END
IF NOT EXISTS (SELECT name FROM SYSOBJECTS  WITH(NOLOCK)  WHERE Id = Object_Id('SDB.DEF003TAControlCarga'))
BEGIN
	ALTER TABLE SDB.TAControlCarga
	ADD CONSTRAINT DEF003TAControlCarga 
	DEFAULT (1) FOR fi_estatus_control_id;  	
END


