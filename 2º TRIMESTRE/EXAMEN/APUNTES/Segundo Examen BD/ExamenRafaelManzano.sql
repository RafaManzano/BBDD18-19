CREATE DATABASE ExamenRafaelManzano
GO
USE ExamenRafaelManzano
GO
DROP DATABASE ExamenRafaelManzano

CREATE TABLE Sicario (
ID SMALLINT NOT NULL, --Somos poquitos
Nombre VARCHAR (20) NOT NULL,
Apellidos VARCHAR (50) NOT NULL,
Apodo VARCHAR (15) NULL,
Nacionalidad VARCHAR (20) NULL,
armaFavorita VARCHAR (15) NULL,
Fecha_Nac DATE NULL,
CONSTRAINT PK_ID_Sicario PRIMARY KEY (ID),
)

CREATE TABLE Idioma_Sicario ( --Incumplia la primera forma normal por lo que la solucion ha sido pasarla a otra tabla diferente
Idioma VARCHAR (20) NOT NULL,
Nivel CHAR (2) NOT NULL,
ID_Sicario SMALLINT NOT NULL,
CONSTRAINT PK_IDSicario_IdiomaSicario PRIMARY KEY (ID_Sicario),
)

CREATE TABLE Victima (
ID INT NOT NULL, --Capturamos bastantes mas
Nombre VARCHAR (20) NOT NULL,
Apellidos VARCHAR (50) NOT NULL,
Nacionalidad VARCHAR (20) NULL,
Fecha_Nac DATE NULL,
Estatura DECIMAL(5,2) NULL,
TallaRopa TINYINT NULL,
Raza VARCHAR (20) NULL,
ColorPelo VARCHAR (15) NULL,
ContornoPecho SMALLINT NULL,
ImporteCobrado SMALLMONEY NOT NULL,
CONSTRAINT PK_ID_Victima PRIMARY KEY (ID),
)

CREATE TABLE Familiar (
ID TINYINT NOT NULL,--Aproximamos como maximo 50 familiares por victima
ID_Victima INT NOT NULL, 
Nombre VARCHAR (20) NOT NULL,
Apellidos VARCHAR (50) NULL,
Domicilio VARCHAR (80) NULL,
Parentesco VARCHAR (20) NOT NULL,
CONSTRAINT PK_ID_IDVictima_Familiar PRIMARY KEY (ID, ID_Victima) -- ID_Victima he decidido que se debe hacer clave primaria por esta tabla ser una entidad debil de victima
)

CREATE TABLE Servicio (
ID INT NOT NULL, --Realizan muchisimos servicios nuestras chicas
FechaHora TIME NOT NULL,
PracticaRealizada VARCHAR (25) NULL,
NombrePutero VARCHAR (20) NOT NULL,
ImporteAbonado SMALLMONEY NOT NULL,
ImporteVictima SMALLMONEY NOT NULL,
ID_Victima INT NOT NULL,
CONSTRAINT PK_ID_Servicio PRIMARY KEY (ID),
)


CREATE TABLE Lugar (
ID INT NOT NULL, --Como tenemos tantas pueden ir a muchos lugares
Denominacion VARCHAR (30) NULL,
Direccion VARCHAR (80) NOT NULL,
CONSTRAINT PK_ID_Lugar PRIMARY KEY (ID),
)

CREATE TABLE Habitacion (
NumeroHabitacion SMALLINT NOT NULL, --Un TINYINT me parece demasiado poco
Superficie SMALLINT NULL,
ID_Servicio INT NOT NULL,
CONSTRAINT PK_NumeroHabitacion_Habitacion PRIMARY KEY (NumeroHabitacion),
CONSTRAINT UQ_ID_Servicio_Habitacion UNIQUE (ID_Servicio),
)

--Al incumplir la segunda forma normal la hemos separado en dos tablas distintas (Habitacion y Hotel)

CREATE TABLE Hotel (
NombreHotel VARCHAR (50) NOT NULL, --Creo que con 50 tiene bastante
Direccion VARCHAR (80) NOT NULL,
NumeroHabitacion SMALLINT NOT NULL,
CONSTRAINT PK_NombreHotel_Hotel PRIMARY KEY (NombreHotel),
)

CREATE TABLE Reside (
FechaIngreso DATE NOT NULL,
FechaSalida DATE NOT NULL,
ID_Victima INT NOT NULL,
ID_Lugar INT NOT NULL,
CONSTRAINT PK_IDVictima_IDLugar_Reside PRIMARY KEY (ID_Victima, ID_Lugar),
)

CREATE TABLE Agrede (
Agresion VARCHAR (40) NULL,
ID_Victima INT NOT NULL,
ID_Lugar INT NOT NULL,
ID_Sicario SMALLINT NOT NULL,
CONSTRAINT PK_IDSicario_IDVictima_IDLugar_Agrede PRIMARY KEY (ID_Sicario, ID_Lugar ,ID_Victima)
)

CREATE TABLE SicarioCaptaVictima (
ID_Sicario SMALLINT NOT NULL,
ID_Victima INT NOT NULL,
Promesa VARCHAR (30) NOT NULL,
CantidadDebida SMALLMONEY NOT NULL,
CONSTRAINT PK_IDSicario_IDVictima_SCV PRIMARY KEY (ID_Sicario, ID_Victima),
)

--Aqui van todas las claves foraneas que haya en el ejercicio
ALTER TABLE Idioma_Sicario ADD CONSTRAINT FK_IDSicario_IdiomaSicario FOREIGN KEY (ID_Sicario) REFERENCES Sicario (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
ALTER TABLE Familiar ADD CONSTRAINT FK_IDVictima_Familiar FOREIGN KEY (ID_Victima) REFERENCES Victima (ID) ON DELETE CASCADE ON UPDATE NO ACTION
ALTER TABLE Servicio ADD CONSTRAINT FK_IDVictima_Servicio FOREIGN KEY (ID_Victima) REFERENCES Victima (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
ALTER TABLE Habitacion ADD CONSTRAINT FK_IDServicio_Habitacion FOREIGN KEY (ID_Servicio) REFERENCES Servicio (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
ALTER TABLE Hotel ADD CONSTRAINT FK_NumeroHabitacion_Hotel FOREIGN KEY (NumeroHabitacion) REFERENCES Habitacion (NumeroHabitacion) ON DELETE NO ACTION ON UPDATE NO ACTION
ALTER TABLE Reside ADD CONSTRAINT FK_IDVictima_Reside FOREIGN KEY (ID_Victima) REFERENCES Victima (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
ALTER TABLE Reside ADD CONSTRAINT FK_IDLugar_Reside FOREIGN KEY (ID_Lugar) REFERENCES Lugar (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
ALTER TABLE Agrede ADD CONSTRAINT FK_IDVictima_Agrede FOREIGN KEY (ID_Victima) REFERENCES Victima (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
ALTER TABLE Agrede ADD CONSTRAINT FK_IDLugar_Agrede FOREIGN KEY (ID_Lugar) REFERENCES Lugar (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
ALTER TABLE Agrede ADD CONSTRAINT FK_IDSicario_Agrede FOREIGN KEY (ID_Sicario) REFERENCES Sicario (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
ALTER TABLE SicarioCaptaVictima ADD CONSTRAINT FK_IDSicario_SCV FOREIGN KEY (ID_Sicario) REFERENCES Sicario (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
ALTER TABLE SicarioCaptaVictima ADD CONSTRAINT FK_IDVictima_SCV FOREIGN KEY (ID_Victima) REFERENCES Victima (ID) ON DELETE NO ACTION ON UPDATE NO ACTION

--Ejercicio 3 CHECK
Set Dateformat 'YMD'
ALTER TABLE Victima ADD CONSTRAINT CK_Mayor18_FechaNac CHECK (Fecha_Nac < Year(1999)) --No sabia hacerlo
ALTER TABLE Victima ADD CONSTRAINT CK_TallaRopaEntre36y46 CHECK (TallaRopa BETWEEN 36 AND 46)
ALTER TABLE Reside ADD CONSTRAINT CK_FechaIngresoInfFechaSalida CHECK (FechaSalida > FechaIngreso OR FechaSalida = NULL)
ALTER TABLE Servicio ADD CONSTRAINT CK_ImporteVictimaNoMas20 CHECK (ImporteVictima > (ImporteAbonado * 0.20))

--Ejercicio 4 Jefes
CREATE TABLE JefesSicarios (
ID_Sicario_Jefe SMALLINT NOT NULL,
ID_Sicario_Raso SMALLINT NOT NULL,
CONSTRAINT PK_IDSicarioJefe_IDSicarioRaso_JefeSicario PRIMARY KEY (ID_Sicario_Jefe, ID_Sicario_Raso),
)

ALTER TABLE JefesSicarios ADD CONSTRAINT IDSicarioJefe_JefesSicarios FOREIGN KEY (ID_Sicario_Jefe) REFERENCES Sicario (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
ALTER TABLE JefesSicarios ADD CONSTRAINT IDSicarioRaso_JefesSicarios FOREIGN KEY (ID_Sicario_Raso) REFERENCES Sicario (ID) ON DELETE NO ACTION ON UPDATE NO ACTION

--Ejercicio5 

CREATE TABLE Envio (
ID_Victima INT NOT NULL,
ID_Familiar TINYINT NOT NULL,
Fecha_Llegada DATE NOT NULL,
Importe SMALLMONEY NOT NULL,
CONSTRAINT PK_IDVictima_IDFamiliar_Envio PRIMARY KEY (ID_Victima, ID_Familiar),
)

ALTER TABLE Envio ADD CONSTRAINT FK_IDVictima_Envio FOREIGN KEY (ID_Victima) REFERENCES Victima (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
ALTER TABLE Envio ADD CONSTRAINT FK_IDFamiliar_Envio FOREIGN KEY (ID_Familiar) REFERENCES Familiar (ID) ON DELETE CASCADE ON UPDATE CASCADE
