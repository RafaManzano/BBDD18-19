CREATE DATABASE PopCornDark

GO 
USE PopCornDark
GO

--DROP DATABASE PopCornDark

CREATE TABLE Profesionales (
ID SMALLINT NOT NULL,
Nombre VARCHAR (30) NOT NULL,
Apellidos VARCHAR (50) NOT NULL,
Fecha_Nacimiento DATE NULL,
Sexo BIT NULL,

CONSTRAINT PK_Profesionales PRIMARY KEY (ID),
CONSTRAINT CK_Fecha_Nacimiento CHECK (Fecha_Nacimiento < CURRENT_TIMESTAMP),
)

CREATE TABLE ActoresDirectores (
IDProfesional SMALLINT NOT NULL,
NombreArtistico VARCHAR (25) NULL,
Papel VARCHAR (40) NULL,
IsDirector BIT NOT NULL,

CONSTRAINT PK_ActoresDirectores PRIMARY KEY (IDProfesional),
CONSTRAINT FK_ActoresDirectores FOREIGN KEY (IDProfesional) REFERENCES Profesionales (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE Distribuidoras (
ID SMALLINT NOT NULL,
Nombre VARCHAR (40) NOT NULL,
Telefono CHAR (9) NULL,
Direccion VARCHAR (80) NULL,

CONSTRAINT PK_Distribuidoras PRIMARY KEY (ID),
CONSTRAINT CK_Telefono CHECK (Telefono LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
)

CREATE TABLE Festivales (
ID SMALLINT NOT NULL,
Nombre VARCHAR (40) NOT NULL,
Fecha DATE NULL,
Pais VARCHAR (30) NULL,

CONSTRAINT PK_Festivales PRIMARY KEY (ID),
)

CREATE TABLE Premios (
ID SMALLINT NOT NULL,
Nombre VARCHAR (40) NOT NULL,
Precio MONEY NOT NULL,
IsAutor BIT NOT NULL,
IDFestival SMALLINT NOT NULL,

CONSTRAINT PK_Premios PRIMARY KEY (ID),
CONSTRAINT FK_Premios_Festivales FOREIGN KEY (IDFestival) REFERENCES Festivales (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT CK_Precio CHECK (Precio > 0),
)

CREATE TABLE PeliculasComerciales (
ID SMALLINT NOT NULL,
AñoEstreno DATE NULL,
IDFestival SMALLINT NOT NULL,
Productor VARCHAR (35) NULL,
Guionista VARCHAR (30) NULL,
Compañia VARCHAR (45) NULL,
Genero VARCHAR (20) NULL,
Nacionalidad VARCHAR (40) NULL,
Idioma VARCHAR (30) NULL,
Compositor VARCHAR (30) NULL,
Presupuesto MONEY NOT NULL,
IDDistribuidora SMALLINT NOT NULL,

CONSTRAINT PK_PeliculasComerciales PRIMARY KEY (ID),
CONSTRAINT FK_PeliculasComerciales_Festivales FOREIGN KEY (IDFestival) REFERENCES Festivales (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_PeliculasComerciales_Distribuidoras FOREIGN KEY (IDDistribuidora) REFERENCES Distribuidoras (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT CK_Presupuesto_Comercial CHECK (Presupuesto > 0),
)

CREATE TABLE PeliculasAutores(
ID SMALLINT NOT NULL,
AñoEstreno DATE NULL,
IDFestival SMALLINT NOT NULL,
Productor VARCHAR (35) NULL,
Guionista VARCHAR (30) NULL,
Compañia VARCHAR (45) NULL,
Genero VARCHAR (20) NULL,
Nacionalidad VARCHAR (40) NULL,
Idioma VARCHAR (30) NULL,
Compositor VARCHAR (30) NULL,
Presupuesto MONEY NOT NULL,

CONSTRAINT PK_PeliculasAutores PRIMARY KEY (ID),
CONSTRAINT FK_PeliculasAutores_Festivales FOREIGN KEY (IDFestival) REFERENCES Festivales (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT CK_Presupuesto_Autores CHECK (Presupuesto > 0),
)

CREATE TABLE ProfesionalesPeliculasComerciales (
IDProfesional SMALLINT NOT NULL,
IDPeliculaComercial SMALLINT NOT NULL,

CONSTRAINT PK_ProfesionalesPeliculasComerciales PRIMARY KEY (IDProfesional, IDPeliculaComercial),
CONSTRAINT FK_ProfesionalesPeliculasComerciales_Profesionales FOREIGN KEY (IDProfesional) REFERENCES Profesionales (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_ProfesionalesPeliculasComerciales_PeliculasComerciales FOREIGN KEY (IDPeliculaComercial) REFERENCES PeliculasComerciales (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE ProfesionalesPeliculasAutores (
IDProfesional SMALLINT NOT NULL,
IDPeliculaAutor SMALLINT NOT NULL,

CONSTRAINT PK_ProfesionalesPeliculasAutores PRIMARY KEY (IDProfesional, IDPeliculaAutor),
CONSTRAINT FK_ProfesionalesPeliculasAutores_Profesionales FOREIGN KEY (IDProfesional) REFERENCES Profesionales (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_ProfesionalesPeliculasAutores_PeliculasAutores FOREIGN KEY (IDPeliculaAutor) REFERENCES PeliculasAutores (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)