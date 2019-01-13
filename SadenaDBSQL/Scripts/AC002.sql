USE SADENADB
GO

SET NOCOUNT ON	
BEGIN TRY

IF EXISTS( SELECT fi_mpio_id FROM SDB.CTMunicipio WITH( NOLOCK ))
BEGIN
	DELETE FROM SDB.CTMunicipio
END
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que recupera el catálogo de municipio
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS( SELECT fi_mpio_id FROM SDB.CTMunicipio WITH( NOLOCK ))
BEGIN	
	INSERT INTO SDB.CTMunicipio VALUES(001,'Abasolo')
	INSERT INTO SDB.CTMunicipio VALUES(002,'Acuña')
	INSERT INTO SDB.CTMunicipio VALUES(003,'Allende')
	INSERT INTO SDB.CTMunicipio VALUES(004,'Arteaga')
	INSERT INTO SDB.CTMunicipio VALUES(005,'Candela')
	INSERT INTO SDB.CTMunicipio VALUES(006,'Castaños')
	INSERT INTO SDB.CTMunicipio VALUES(007,'Cuatro Ciénegas')
	INSERT INTO SDB.CTMunicipio VALUES(008,'Escobedo')
	INSERT INTO SDB.CTMunicipio VALUES(009,'Francisco I. Madero')
	INSERT INTO SDB.CTMunicipio VALUES(010,'Frontera')
	INSERT INTO SDB.CTMunicipio VALUES(011,'General Cepeda')
	INSERT INTO SDB.CTMunicipio VALUES(012,'Guerrero')
	INSERT INTO SDB.CTMunicipio VALUES(013,'Hidalgo')
	INSERT INTO SDB.CTMunicipio VALUES(014,'Jiménez')
	INSERT INTO SDB.CTMunicipio VALUES(015,'Juárez')
	INSERT INTO SDB.CTMunicipio VALUES(016,'Lamadrid')
	INSERT INTO SDB.CTMunicipio VALUES(017,'Matamoros')
	INSERT INTO SDB.CTMunicipio VALUES(018,'Monclova')
	INSERT INTO SDB.CTMunicipio VALUES(019,'Morelos')
	INSERT INTO SDB.CTMunicipio VALUES(020,'Múzquiz')
	INSERT INTO SDB.CTMunicipio VALUES(021,'Nadadores')
	INSERT INTO SDB.CTMunicipio VALUES(022,'Nava')
	INSERT INTO SDB.CTMunicipio VALUES(023,'Ocampo')
	INSERT INTO SDB.CTMunicipio VALUES(024,'Parras')
	INSERT INTO SDB.CTMunicipio VALUES(025,'Piedras Negras')
	INSERT INTO SDB.CTMunicipio VALUES(026,'Progreso')
	INSERT INTO SDB.CTMunicipio VALUES(027,'Ramos Arizpe')
	INSERT INTO SDB.CTMunicipio VALUES(028,'Sabinas')
	INSERT INTO SDB.CTMunicipio VALUES(029,'Sacramento')
	INSERT INTO SDB.CTMunicipio VALUES(030,'Saltillo')
	INSERT INTO SDB.CTMunicipio VALUES(031,'San Buenaventura')
	INSERT INTO SDB.CTMunicipio VALUES(032,'San Juan de Sabinas')
	INSERT INTO SDB.CTMunicipio VALUES(033,'San Pedro')
	INSERT INTO SDB.CTMunicipio VALUES(034,'Sierra Mojada')
	INSERT INTO SDB.CTMunicipio VALUES(035,'Torreón')
	INSERT INTO SDB.CTMunicipio VALUES(036,'Viesca')
	INSERT INTO SDB.CTMunicipio VALUES(037,'Villa Unión')
	INSERT INTO SDB.CTMunicipio VALUES(038,'Zaragoza')
END

IF EXISTS( SELECT fi_loc_edo_id FROM SDB.CTLocalidad WITH( NOLOCK ))
BEGIN
	DELETE FROM SDB.CTLocalidad
END
----------------------------------------------------------------------------------------------------------------------------------      
--- Responsable: Jorge Alberto de la Rosa  
--- Fecha      : Diciembre 2018  
--- Descripcion: Creación de un stored procedure que recupera el catálogo de localidad
--- Aplicacion:  SADENADB  
----------------------------------------------------------------------------------------------------------------------------------  
IF NOT EXISTS( SELECT fi_loc_edo_id FROM SDB.CTLocalidad WITH( NOLOCK ))
BEGIN	
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(00,'SE IGNORA',000,'SE IGNORA',0000,'SE IGNORA')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',000,'SE IGNORA',0000,'SE IGNORA')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0000,'SE IGNORA')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0001,'AGUASCALIENTES')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0094,'GRANJA ADELITA')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0096,'AGUA AZUL')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0100,'RANCHO ALEGRE')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0102,'LOS ARBOLITOS (RANCHO DE LOS ARBOLITOS)')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0104,'ARDILLAS DE ABAJO (LAS ARDILLAS)')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0106,'ARELLANO')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0112,'BAJÍO LOS VÁZQUEZ')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0113,'BAJÍO DE MONTORO')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0114,'RESIDENCIAL SAN NICOLÁS (BAÑOS LA CANTERA)')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0120,'BUENAVISTA DE PEÑUELAS')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0121,'CABECITA 3 MARÍAS (RANCHO NUEVO)')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0125,'CAÑADA GRANDE DE COTORINA')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0126,'ESTACIÓN CAÑADA HONDA')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0127,'LOS CAÑOS')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0128,'EL CARIÑÁN')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0129,'GRANJA EL CARMEN')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0135,'EL CEDAZO (CEDAZO DE SAN ANTONIO)')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0138,'CENTRO DE ARRIBA (EL TARAY)')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0139,'CIENEGUILLA (LA LUMBRERA)')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0141,'COBOS')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0144,'EL COLORADO (EL SOYATAL)')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0146,'EL CONEJAL')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0157,'COTORINA DE ABAJO')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0162,'COYOTES')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0166,'LA HUERTA (LA CRUZ)')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0170,'CUAUHTÉMOC (LAS PALOMAS)')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0171,'LOS CUERVOS (LOS OJOS DE AGUA)')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0172,'GRANJA SAN JOSÉ')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0176,'LA CHIRIPA')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0182,'DOLORES')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0183,'LOS DOLORES')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0190,'EL DURAZNILLO')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0191,'LOS DURÓN')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0192,'GRANJA EL EDÉN')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0197,'LA ESCONDIDA')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0201,'BODEGAS BRANDE VIN')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0207,'VALLE REDONDO')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0209,'LA FORTUNA')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0212,'LOMAS DEL GACHUPÍN')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0213,'RANCHO EL CARMEN (GALLINAS GUERAS)')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0216,'LA GLORIA')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0226,'HACIENDA NUEVA')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0227,'LA HACIENDITA (LA ESPERANZA)')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0228,'LA HERRADA')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0230,'RANCHO DON ABRAHAM')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0231,'LOS HOYOS (PUERTA DE LOS HOYOS)')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0236,'LAS JABONERAS')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0237,'JALTOMATE')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0239,'GRAL. JOSÉ MA. MORELOS Y PAVÓN (CAÑADA HONDA)')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0253,'LOS LIRIOS')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0256,'LA LOMA DE LOS NEGRITOS')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0265,'EL MALACATE')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0270,'LA MASCOTA')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0272,'MATAMOROS')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0279,'EL MIRADOR')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0280,'LOS MIRASOLES')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0283,'EL MOLINO')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0285,'MONTORO')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0291,'LOS NEGRITOS')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0292,'EL NIÁGARA (RANCHO EL NIÁGARA)')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0293,'NORIAS DE OJOCALIENTE')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0296,'EL OCOTE')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0297,'COMUNIDAD EL ROCÍO')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0309,'LAS PALOMAS')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0315,'PEÑUELAS (EL CIENEGAL)')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0321,'PIEDRAS CHINAS')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0329,'PRESA DE GUADALUPE')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0336,'SOLEDAD DE ARRIBA')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0340,'LA PUERTA (GRANJAS CARIÑÁN)')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0345,'EL REFUGIO DE PEÑUELAS')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0347,'EL REFUGIO I')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0353,'EL RODEO')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0355,'EL SALTO DE LOS SALADO')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0357,'NORIAS DEL PASO HONDO')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0358,'SAN AGUSTÍN')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0362,'GRANJA SAN ANTONIO')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0363,'GRANJA SAN ANTONIO')
	INSERT INTO SDB.CTLocalidad(fi_loc_edo_id,fc_loc_edo_desc,fi_loc_mpio_id,fc_loc_mpio_desc,fi_loc_id,fc_loc_desc) values(01,'AGUASCALIENTES',001,'AGUASCALIENTES',0366,'EJIDO SAN ANTONIO DE LOS PEDROZA')
END

END TRY
BEGIN CATCH
	RAISERROR ('Error al insertar catálogos',18,1)      
	SET NOCOUNT OFF  
END CATCH