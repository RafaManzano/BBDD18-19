USE master
GO --DROP DATABASE [ONG Trata de Blancas]
CREATE DATABASE [ONG Trata de Blancas]
GO
USE [ONG Trata de Blancas]
SET DATEFORMAT 'YMD'
GO

----    EJERCICIO 2    ----

CREATE TABLE Sicarios(
	ID int IDENTITY(1,1)
	,nombre varchar(20) NOT NULL
	,apellidos varchar(50) NULL
	,apodo varchar(15) NULL
	,nacionalidad varchar(15) NULL

	,CONSTRAINT PK_Sicario PRIMARY KEY (ID)
)

CREATE TABLE Matones(
	ID int IDENTITY(1,1)
	,ArmaFavorita varchar(15) NULL
	,ID_Sicario int

	,CONSTRAINT PK_Maton PRIMARY KEY (ID)
	,CONSTRAINT FK_Maton_Sicario FOREIGN KEY (ID_sicario) REFERENCES Sicarios (ID) ON UPDATE CASCADE ON DELETE NO ACTION
)

CREATE TABLE Ganchos(
	ID int IDENTITY(1,1)
	,f_nacimiento Date NULL
	,ID_Sicario int

	,CONSTRAINT PK_Gancho PRIMARY KEY (ID)
	,CONSTRAINT FK_Gancho_Sicario FOREIGN KEY (ID_sicario) REFERENCES Sicarios (ID) ON UPDATE CASCADE ON DELETE NO ACTION
)

CREATE TABLE Idiomas(
	ID int IDENTITY(1,1)
	,denominacion varchar(12) NOT NULL

	,CONSTRAINT PK_Idioma PRIMARY KEY (ID)
)

CREATE TABLE Ganchos_Idiomas(
	ID_Gancho int
	,ID_Idioma int
	,nivel varchar(10) NOT NULL

	,CONSTRAINT FK_Ganchos_Idiomas_Gancho FOREIGN KEY (ID_Gancho) REFERENCES Ganchos (ID) ON UPDATE CASCADE ON DELETE NO ACTION
	,CONSTRAINT FK_Ganchos_Idiomas_Idioma FOREIGN KEY (ID_Idioma) REFERENCES Idiomas (ID) ON UPDATE CASCADE ON DELETE NO ACTION
	,CONSTRAINT PK_Ganchos_Idiomas_Gancho PRIMARY KEY (ID_Gancho, ID_Idioma)
)

CREATE TABLE Victimas(
	ID int IDENTITY(1,1)
	,nombre varchar(20) NOT NULL
	,apellidos varchar(50) NULL
	,nacionalidad varchar(10) NULL
	,f_nacimeinto Date NOT NULL
	,estatura decimal(4,2) NULL
	,tallaRopa tinyint NOT NULL
	,raza char(1) NOT NULL --Se usaran letras como identificador EJ: N: Negroide, C: Caucasica, etc
	,colorPelo varchar(10) NOT NULL
	,contornoPecho varchar(5) NOT NULL

	--Relacion entre Víctima y Gancho
	,ID_Gancho int
	,promesa varchar(50) NOT NULL
	,deuda smallmoney NULL --Admite nulos porque algunas chicas no tienen deuda. En caso de tenerla, esperamos que no supere los 214.748,3647 €

	,CONSTRAINT PK_Victima PRIMARY KEY (ID)
	,CONSTRAINT FK_Victima_Gancho FOREIGN KEY (ID_Gancho) REFERENCES Ganchos(ID) ON UPDATE CASCADE ON DELETE NO ACTION
)

CREATE TABLE Familiares( --Entidad débil, cuando desaparece la Víctima, desaparecen sus familiares (no literalmente)
	ID int IDENTITY(1,1)
	,nombre varchar(20) NOT NULL
	,apellidos varchar(50) NULL
	,direccion varchar(70) NOT NULL
	,parentesco varchar(15) NOT NULL
	,ID_Victima int

	--Relacion entre Victima y Familiar
	,CONSTRAINT PK_Familiar PRIMARY KEY (ID)
	,CONSTRAINT FK_Familiar_Victima FOREIGN KEY (ID_Victima) REFERENCES Victimas(ID) ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE Servicios(
	ID int IDENTITY(1,1)
	,fechaHora DateTime NOT NULL
	,practicaRealizada varchar(20) NOT NULL
	,nombrePutero varchar(20) NOT NULL
	,importeAbonado smallmoney  NOT NULL--esperamos que no supere los 214.748,3647 €
	,importeVictima smallMoney NOT NULL

	--Relacion entre victima y servicio
	,ID_Victima int 
	,importeCobrado smallmoney NOT NULL

	,CONSTRAINT PK_Servicio PRIMARY KEY (ID)
	,CONSTRAINT FK_Servicio_Victima FOREIGN KEY (ID_Victima) REFERENCES Victimas(ID)

	--EN UN FUTURO HABRIA QUE CONFIGURAR UN TRIGGER QUE CUANDO SE HAGA UN SERVCIO SE REDUZCA LA DEUDA EN CASO DE SEGUIR TENIENDOLA
)
CREATE TABLE Lugares(
	ID int IDENTITY(1,1)
	,denominacion varchar(10) NOT NULL
	,direccion varchar(50) NOT NULL

	,CONSTRAINT PK_Lugar PRIMARY KEY (ID)
)

CREATE TABLE Habitaciones(
	ID int UNIQUE
	,NombreHotel char(20) NOT NULL
	,numeroHabitacion int NOT NULL --Muchos hoteles su numero de haibtacion empieza por la planta en la que están, por lo que en la planta 2 serán 2-- NO PODEMOS USAR TINYINT
	,superficie decimal(5,3) NULL
	,direccion varchar(50) NOT NULL

	,CONSTRAINT PK_Habitacion PRIMARY KEY (NombreHotel, numeroHabitacion)
)

CREATE TABLE Servicios_Habitaciones(
	ID_Habitacion int 
	,ID_servicio int

	,CONSTRAINT FK_Servicios_Habitaciones_Habitacion FOREIGN KEY (ID_Habitacion) REFERENCES Habitaciones(ID)
	,CONSTRAINT FK_Servicios_Habitaciones_Servicio FOREIGN KEY (ID_servicio) REFERENCES Servicios(ID)
	,CONSTRAINT PK_Servicios_Habitaciones PRIMARY KEY (ID_Habitacion, ID_servicio)
)

CREATE TABLE Victimas_Lugares(
	ID_Victima int
	,ID_Lugar int
	,f_ingreso date NOT NULL
	,f_salida date NULL --Admite nulos puesto que no tiene porque no ha salido de la que reside en ese momento

	,CONSTRAINT FK_Victimas_Lugares_Victima FOREIGN KEY (ID_Victima) REFERENCES Victimas(ID)
	,CONSTRAINT FK_Victimas_Lugares_Lugar FOREIGN KEY (ID_Lugar) REFERENCES Lugares(ID)
	,CONSTRAINT PK_Victimas_Lugares PRIMARY KEY (ID_Victima, ID_Lugar)
)

CREATE TABLE Agresiones(
	agresion varchar(50) NOT NULL
	,ID_Victima int
	,ID_Maton int
	,ID_Lugar int

	,CONSTRAINT FK_Agresion_Victimas FOREIGN KEY (ID_Victima) REFERENCES Victimas(ID)
	,CONSTRAINT FK_Agresion_Lugar FOREIGN KEY (ID_Lugar) REFERENCES Lugares(ID)
	,CONSTRAINT FK_Agresion_Maton FOREIGN KEY (ID_Maton) REFERENCES Matones(ID)
	,CONSTRAINT PK_Agresiones PRIMARY KEY (ID_Victima, ID_Maton, ID_Lugar)
)

----    EJERCICIO 3    ----

--VICTIMAS MAYORES DE EDAD               --PRINT YEAR(Current_TimeStamp - '1995-12-14')-1900
ALTER TABLE Victimas ADD CONSTRAINT CK_MayoriaEdad CHECK ( (Year(Current_Timestamp -CAST(f_nacimeinto AS SmallDateTime))-1900) >= 18 )

--TALLA DE ROPA ENTRE 36 Y 46
ALTER TABLE Victimas ADD CONSTRAINT CK_TallaRopa CHECK (TallaRopa BETWEEN 36 AND 46)

--FECHA DE SALIDA POSTERIOR O NULL
ALTER TABLE Victimas_Lugares ADD CONSTRAINT CK_FechaSalida_Valida CHECK ( (f_salida>f_ingreso) OR (f_salida = NULL) )

--IMPORTE VICTIMA NO SUPERIOR AL 20% TOTAL
ALTER TABLE Servicios ADD CONSTRAINT CK_ImporteVictima_Valido CHECK ( importeVictima <= ( importeAbonado*0.02 ) )

----    EJERCICIO 4    ----

CREATE TABLE JerarquiaSicarios (
	ID_Jefe int
	,ID_Subordinado int

	,CONSTRAINT FK_JerarquiaSicarios FOREIGN KEY (ID_Jefe) REFERENCES Sicarios(ID)
	,CONSTRAINT FK_JerarquiaSicarios2 FOREIGN KEY (ID_Subordinado) REFERENCES Sicarios(ID)
	,CONSTRAINT PK_JerarquiaSicarios PRIMARY KEY (ID_Jefe, ID_Subordinado)
)

----    EJERCICIO 5    ----

CREATE TABLE EnviosDineros (
	ID_Transaccion int IDENTITY(1,1)
	,ID_Victima int
	,ID_Familiar int
	,cantidad smallmoney NOT NULL
	,fecha date NOT NULL

	,CONSTRAINT PK_EnvioDinero PRIMARY KEY (ID_Transaccion)
	,CONSTRAINT FK_Transaccion_Victima FOREIGN KEY (ID_Victima) REFERENCES Victimas(ID)
	,CONSTRAINT FK_Transaccion_Familiar FOREIGN KEY (ID_Familiar) REFERENCES Familiares(ID)

	--HABRIA QUE COMPROBAR MEDIANTE UNA CONSULTA QUE ESE FAMILIAR ES FAMILIAR DE ESA VICTIMA
)