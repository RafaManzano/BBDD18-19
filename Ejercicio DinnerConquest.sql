CREATE DATABASE DinnerConquest

GO
USE DinnerConquest
GO

--DROP DATABASE DinnerConquest

CREATE TABLE Alumnos (
ID SMALLINT NOT NULL,
Nombre VARCHAR (30) NOT NULL,
Apellidos VARCHAR (50) NOT NULL,
Fecha_Nac DATE NULL,

CONSTRAINT PK_Alumnos PRIMARY KEY (ID),
)

CREATE TABLE Establecimientos (
ID SMALLINT NOT NULL,
Nombre VARCHAR (30) NOT NULL,
TipoComida VARCHAR (30) NULL,
Direccion VARCHAR (80) NULL,
Km INT NOT NULL,

CONSTRAINT PK_Establecimientos PRIMARY KEY (ID),
)

CREATE TABLE Menus (
ID SMALLINT NOT NULL,
Plato VARCHAR (30) NOT NULL,
Bebida VARCHAR (40) NOT NULL,
Precio MONEY NOT NULL,
IDEstablecimiento SMALLINT NOT NULL,

CONSTRAINT PK_Menus PRIMARY KEY (ID),
CONSTRAINT FK_Menus_Establecimientos FOREIGN KEY (IDEstablecimiento) REFERENCES Establecimientos(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE Valoraciones (
ID INT NOT NULL,
Nombre VARCHAR (40) NOT NULL,
Puntuacion TINYINT NULL,
Votacion TINYINT NULL,
IDAlumno SMALLINT NOT NULL,
IDMenu SMALLINT NOT NULL,

CONSTRAINT PK_Valoraciones PRIMARY KEY (ID),
CONSTRAINT FK_Valoraciones_Alumnos FOREIGN KEY (IDAlumno) REFERENCES Alumnos(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_Valoraciones_Menus FOREIGN KEY (IDMenu) REFERENCES Menus(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE Grupos (
ID SMALLINT NOT NULL,
Nombre VARCHAR (15) NOT NULL,

CONSTRAINT PK_Grupos PRIMARY KEY (ID),
)

CREATE TABLE AlumnosGrupos (
IDAlumno SMALLINT NOT NULL,
IDGrupo SMALLINT NOT NULL,

CONSTRAINT PK_AlumnosGrupos PRIMARY KEY (IDAlumno, IDGrupo),
CONSTRAINT FK_AlumnosGrupos_Alumnos FOREIGN KEY (IDAlumno) REFERENCES Alumnos(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_AlumnosGrupos_Grupos FOREIGN KEY (IDGrupo) REFERENCES Grupos(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE AlumnosEstablecimientos (
IDAlumno SMALLINT NOT NULL,
IDEstablecimiento SMALLINT NOT NULL,

CONSTRAINT PK_AlumnosEstablecimientos PRIMARY KEY (IDAlumno, IDEstablecimiento),
CONSTRAINT FK_AlumnosEstablecimientos_Alumnos FOREIGN KEY (IDAlumno) REFERENCES Alumnos(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_AlumnosEstablecimientos_Establecimientos FOREIGN KEY (IDEstablecimiento) REFERENCES Establecimientos(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)