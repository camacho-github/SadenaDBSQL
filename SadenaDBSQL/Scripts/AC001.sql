USE SADENADB
GO

SET NOCOUNT ON	
BEGIN TRY

	----------------------------------------------------------------------------------------------------------------------------------      
	--- Responsable: Jorge Alberto de la Rosa  
	--- Fecha      : Diciembre 2018  
	--- Descripcion: Creación de registros del catálogo de rol
	--- Aplicacion:  SADENADB  
	----------------------------------------------------------------------------------------------------------------------------------  
	IF NOT EXISTS( SELECT fi_rol_id FROM SDB.CTRol WITH( NOLOCK ) WHERE fi_rol_id IN (1,2,3))
	BEGIN
		INSERT INTO SDB.CTRol(fi_rol_id,fc_rol_desc) VALUES(1,'Sistemas')
		INSERT INTO SDB.CTRol(fi_rol_id,fc_rol_desc) VALUES(2,'Administrador')
		INSERT INTO SDB.CTRol(fi_rol_id,fc_rol_desc) VALUES(3,'Analista')
	END


	----------------------------------------------------------------------------------------------------------------------------------      
	--- Responsable: Jorge Alberto de la Rosa  
	--- Fecha      : Diciembre 2018  
	--- Descripcion: Creación de registros del catálogo de estatus
	--- Aplicacion:  SADENADB  
	----------------------------------------------------------------------------------------------------------------------------------  
	IF NOT EXISTS( SELECT fi_estatus_id FROM SDB.CTEstatus WITH( NOLOCK ) WHERE fi_estatus_id IN (1,2))
	BEGIN
		INSERT INTO SDB.CTEstatus(fi_estatus_id,fc_estatus_desc) VALUES(1,'Activo')
		INSERT INTO SDB.CTEstatus(fi_estatus_id,fc_estatus_desc) VALUES(2,'Inactivo')	
	END



	IF EXISTS( SELECT fi_estatus_registro_id FROM SDB.CTEstatusRegistro WITH( NOLOCK ))
	BEGIN
		DELETE FROM SDB.CTEstatusRegistro
	END
	----------------------------------------------------------------------------------------------------------------------------------      
	--- Responsable: Jorge Alberto de la Rosa  
	--- Fecha      : Diciembre 2018  
	--- Descripcion: Creación de registros del catálogo estatus registro
	--- Aplicacion:  SADENADB  
	----------------------------------------------------------------------------------------------------------------------------------  
	IF NOT EXISTS( SELECT fi_estatus_registro_id FROM SDB.CTEstatusRegistro WITH( NOLOCK ))
	BEGIN
		INSERT INTO SDB.CTEstatusRegistro(fi_estatus_registro_id,fi_estatus_registro_desc) VALUES(01,'SUBREGISTRO')
		INSERT INTO SDB.CTEstatusRegistro(fi_estatus_registro_id,fi_estatus_registro_desc) VALUES(02,'REGISTRO OPORTUNO')
		INSERT INTO SDB.CTEstatusRegistro(fi_estatus_registro_id,fi_estatus_registro_desc) VALUES(03,'REGISTRO EXTEMPORANEO')
	END


	IF EXISTS( SELECT fi_sexo_id FROM SDB.CTSexo WITH( NOLOCK ))
	BEGIN
		DELETE FROM SDB.CTSexo
	END
	----------------------------------------------------------------------------------------------------------------------------------      
	--- Responsable: Jorge Alberto de la Rosa  
	--- Fecha      : Diciembre 2018  
	--- Descripcion: Creación de registros del catálogo de sexo
	--- Aplicacion:  SADENADB  
	----------------------------------------------------------------------------------------------------------------------------------  
	IF NOT EXISTS( SELECT fi_sexo_id FROM SDB.CTSexo WITH( NOLOCK ))
	BEGIN
		INSERT INTO SDB.CTSexo(fi_sexo_id,fc_sexo_desc) VALUES(1,'HOMBRE')
		INSERT INTO SDB.CTSexo(fi_sexo_id,fc_sexo_desc) VALUES(2,'MUJER')
		INSERT INTO SDB.CTSexo(fi_sexo_id,fc_sexo_desc) VALUES(9,'SIN INFORMACIÓN')
	END	


	IF EXISTS( SELECT fi_edo_civil_id FROM SDB.CTEdoCivil WITH( NOLOCK ))
	BEGIN
		DELETE FROM SDB.CTEdoCivil
	END
	----------------------------------------------------------------------------------------------------------------------------------      
	--- Responsable: Jorge Alberto de la Rosa  
	--- Fecha      : Diciembre 2018  
	--- Descripcion: Descripcion: Creación de registros del catálogo de estado civil
	--- Aplicacion:  SADENADB  
	----------------------------------------------------------------------------------------------------------------------------------  
	IF NOT EXISTS( SELECT fi_edo_civil_id FROM SDB.CTEdoCivil WITH( NOLOCK ))
	BEGIN
		INSERT INTO SDB.CTEdoCivil(fi_edo_civil_id,fc_edo_civil_desc)VALUES(11,'CASADA')
		INSERT INTO SDB.CTEdoCivil(fi_edo_civil_id,fc_edo_civil_desc)VALUES(12,'SOLTERA')
		INSERT INTO SDB.CTEdoCivil(fi_edo_civil_id,fc_edo_civil_desc)VALUES(13,'DIVORCIADA')
		INSERT INTO SDB.CTEdoCivil(fi_edo_civil_id,fc_edo_civil_desc)VALUES(14,'VIUDA')
		INSERT INTO SDB.CTEdoCivil(fi_edo_civil_id,fc_edo_civil_desc)VALUES(15,'UNIÓN LIBRE')
		INSERT INTO SDB.CTEdoCivil(fi_edo_civil_id,fc_edo_civil_desc)VALUES(16,'SEPARADA')
		INSERT INTO SDB.CTEdoCivil(fi_edo_civil_id,fc_edo_civil_desc)VALUES(88,'N.E.')
		INSERT INTO SDB.CTEdoCivil(fi_edo_civil_id,fc_edo_civil_desc)VALUES(99,'S.I.')
	END	


	IF EXISTS( SELECT fi_escol_id FROM SDB.CTEscolaridad WITH( NOLOCK ))
	BEGIN
		DELETE FROM SDB.CTEscolaridad
	END
	----------------------------------------------------------------------------------------------------------------------------------      
	--- Responsable: Jorge Alberto de la Rosa  
	--- Fecha      : Diciembre 2018  
	--- Descripcion: Creación de registros del catálogo de escolaridad
	--- Aplicacion:  SADENADB  
	----------------------------------------------------------------------------------------------------------------------------------  
	IF NOT EXISTS( SELECT fi_escol_id FROM SDB.CTEscolaridad WITH( NOLOCK ))
	BEGIN
		INSERT INTO SDB.CTEscolaridad(fi_escol_id,fc_escol_desc) VALUES(01,'NINGUNA')
		INSERT INTO SDB.CTEscolaridad(fi_escol_id,fc_escol_desc) VALUES(02,'PRIMARIA INCOMPLETA')
		INSERT INTO SDB.CTEscolaridad(fi_escol_id,fc_escol_desc) VALUES(03,'PRIMARIA COMPLETA')
		INSERT INTO SDB.CTEscolaridad(fi_escol_id,fc_escol_desc) VALUES(04,'SECUNDARIA INCOMPLETA')
		INSERT INTO SDB.CTEscolaridad(fi_escol_id,fc_escol_desc) VALUES(05,'SECUNDARIA COMPLETA')
		INSERT INTO SDB.CTEscolaridad(fi_escol_id,fc_escol_desc) VALUES(06,'BACHILLERATO O PREPARATORIA INCOMPLETA')
		INSERT INTO SDB.CTEscolaridad(fi_escol_id,fc_escol_desc) VALUES(07,'BACHILLERATO O PREPARATORIA COMPLETA')
		INSERT INTO SDB.CTEscolaridad(fi_escol_id,fc_escol_desc) VALUES(08,'PROFESIONAL')
		INSERT INTO SDB.CTEscolaridad(fi_escol_id,fc_escol_desc) VALUES(10,'POSGRADO')
		INSERT INTO SDB.CTEscolaridad(fi_escol_id,fc_escol_desc) VALUES(11,'PROFESIONAL INCOMPLETO')
		INSERT INTO SDB.CTEscolaridad(fi_escol_id,fc_escol_desc) VALUES(12,'POSGRADO INCOMPLETO')
		INSERT INTO SDB.CTEscolaridad(fi_escol_id,fc_escol_desc) VALUES(88,'N.E.')
		INSERT INTO SDB.CTEscolaridad(fi_escol_id,fc_escol_desc) VALUES(99,'S.I.')
	END


	IF EXISTS( SELECT fi_usuario_id FROM SDB.TAUsuario WITH( NOLOCK ))
	BEGIN
		DELETE FROM SDB.TAUsuario
	END
	----------------------------------------------------------------------------------------------------------------------------------      
	--- Responsable: Jorge Alberto de la Rosa  
	--- Fecha      : Diciembre 2018  
	--- Descripcion: Creación de registros de la tabla usuario
	--- Aplicacion:  SADENADB  
	----------------------------------------------------------------------------------------------------------------------------------  	
	IF NOT EXISTS( SELECT fi_usuario_id FROM SDB.TAUsuario WITH( NOLOCK ))
	BEGIN
		INSERT INTO SDB.TAUsuario(fi_usuario_id,fc_usuario,fc_correo_e,fi_rol_id,fi_estatus_id,fc_contrasena) VALUES(1,'Sistemas','sistemas@sadena.gob.mx',1,1,'Sistemas123')		
		INSERT INTO SDB.TAUsuario(fi_usuario_id,fc_usuario,fc_correo_e,fi_rol_id,fi_estatus_id,fc_contrasena) VALUES(2,'Administrador','administrador@sadena.gob.mx',2,1,'Administrador123')
		INSERT INTO SDB.TAUsuario(fi_usuario_id,fc_usuario,fc_correo_e,fi_rol_id,fi_estatus_id,fc_contrasena) VALUES(3,'Analista','analista@sadena.gob.mx',3,1,'Analista123')
	END


	IF EXISTS( SELECT fi_estatus_control_id FROM SDB.CTEstatusControl WITH( NOLOCK ))
	BEGIN
		DELETE FROM SDB.CTEstatusControl
	END
	----------------------------------------------------------------------------------------------------------------------------------      
	--- Responsable: Jorge Alberto de la Rosa  
	--- Fecha      : Diciembre 2018  
	--- Descripcion: Creación de registros del catálogo de estatus de control
	--- Aplicacion:  SADENADB  
	----------------------------------------------------------------------------------------------------------------------------------  
	IF NOT EXISTS(SELECT fi_estatus_control_id FROM SDB.CTEstatusControl WITH( NOLOCK ))
	BEGIN
		INSERT INTO SDB.CTEstatusControl(fi_estatus_control_id,fc_descripcion) VALUES(1,'PRECARGADO')
		INSERT INTO SDB.CTEstatusControl(fi_estatus_control_id,fc_descripcion) VALUES(2,'PRECARGADO ELIMINADO')
		INSERT INTO SDB.CTEstatusControl(fi_estatus_control_id,fc_descripcion) VALUES(3,'CARGA PROCESADO')
		INSERT INTO SDB.CTEstatusControl(fi_estatus_control_id,fc_descripcion) VALUES(4,'CARGA ELIMINIDO')
	END


	IF EXISTS( SELECT fi_control_tipo_id FROM SDB.CTControlTipo WITH( NOLOCK ))
	BEGIN
		DELETE FROM SDB.CTControlTipo
	END
	----------------------------------------------------------------------------------------------------------------------------------      
	--- Responsable: Jorge Alberto de la Rosa  
	--- Fecha      : Diciembre 2018  
	--- Descripcion: Creación de registros del catálogo de tipo de carga
	--- Aplicacion:  SADENADB  
	----------------------------------------------------------------------------------------------------------------------------------  
	IF NOT EXISTS(SELECT fi_control_tipo_id FROM SDB.CTControlTipo WITH( NOLOCK ))
	BEGIN
		INSERT INTO SDB.CTControlTipo(fi_control_tipo_id,fc_control_tipo_desc) VALUES(1,'Localidad')
		INSERT INTO SDB.CTControlTipo(fi_control_tipo_id,fc_control_tipo_desc) VALUES(2,'SINAC')
		INSERT INTO SDB.CTControlTipo(fi_control_tipo_id,fc_control_tipo_desc) VALUES(3,'SIC')
		
	END


END TRY
BEGIN CATCH
	RAISERROR ('Error al insertar catálogos',18,1)      
	SET NOCOUNT OFF  
END CATCH

	