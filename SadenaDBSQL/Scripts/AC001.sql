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
		INSERT INTO SDB.CTEstatusRegistro(fi_estatus_registro_id,fi_estatus_registro_desc) VALUES(04,'SIC DUPLICADO')
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

	IF EXISTS( SELECT fi_mpio_id FROM SDB.CTMunicipio WITH( NOLOCK ))
	BEGIN
		DELETE FROM SDB.CTMunicipio
	END
	----------------------------------------------------------------------------------------------------------------------------------      
	--- Responsable: Jorge Alberto de la Rosa  
	--- Fecha      : Diciembre 2018  
	--- Descripcion: Creación de registros del catálogo de municipios
	--- Aplicacion:  SADENADB  
	----------------------------------------------------------------------------------------------------------------------------------  
	IF NOT EXISTS(SELECT fi_mpio_id FROM SDB.CTMunicipio WITH( NOLOCK ))
	BEGIN
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(1,'Abasolo','27.1822222222222','-101.425277777777')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(2,'Acuña','29.470833','-102.280277')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(3,'Allende','28.3416666666666','-100.833888888888')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(4,'Arteaga','25.4327777777777','-100.846667')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(5,'Candela','26.8402777777777','-100.661944444444')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(6,'Castaños','26.7841666666666','-101.432777777777')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(7,'Cuatro Ciénegas','26.9861111111111','-102.066388888888')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(8,'Escobedo','27.235','-101.412222222222')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(9,'Francisco I. Madero','25.7752777777777','-103.273055555555')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(10,'Frontera','26.9266666666666','-101.4525')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(11,'General Cepeda','25.3780555555555','-101.475')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(12,'Guerrero','28.3088888888888','-100.378333333333')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(13,'Hidalgo','27.7888888888888','-99.8755555555555')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(14,'Jiménez','29.0697222222222','-100.674722222222')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(15,'Juárez','27.6069444444444','-100.726111111111')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(16,'Lamadrid','27.0497222222222','-101.794722222222')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(17,'Matamoros','25.5280555555555','-103.228333333333')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(18,'Monclova','26.9102777777777','-101.422222222222')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(19,'Morelos','28.4077777777777','-100.885')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(20,'Múzquiz','27.8786111111111','-101.517222222222')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(21,'Nadadores','27.016667','-101.593611111111')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(22,'Nava','28.4208333333333','-100.768611111111')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(23,'Ocampo','27.3138888888888','-102.396388888888')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(24,'Parras','25.4408333333333','-102.186111111111')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(25,'Piedras Negras','28.7222222222222','-100.568055555555')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(26,'Progreso','27.4283333333333','-100.987222222222')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(27,'Ramos Arizpe','25.5405555555555','-100.950555555555')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(28,'Sabinas','27.8527777777777','-101.119722222222')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(29,'Sacramento','27.0036111111111','-101.724722222222')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(30,'Saltillo','25.3997222222222','-101')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(31,'San Buenaventura','27.0625','-101.546666666666')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(32,'San Juan de Sabinas','27.9291666666666','-101.303333333333')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(33,'San Pedro','25.7588888888888','-102.982777777777')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(34,'Sierra Mojada','26.904444','-103.296667')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(35,'Torreón','25.5444444444444','-103.4425')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(36,'Viesca','25.3411111111111','-102.804444444444')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(37,'Villa Unión','28.2202777777777','-100.724444444444')
		INSERT INTO SDB.CTMunicipio (fi_mpio_id,fc_mpio_desc,fc_latitud,fc_longitud) VALUES(38,'Zaragoza','28.4752777777777','-100.919444444444')
	END


END TRY
BEGIN CATCH
	RAISERROR ('Error al insertar catálogos',18,1)      
	SET NOCOUNT OFF  
END CATCH

	