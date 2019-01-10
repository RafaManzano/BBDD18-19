CREATE DATABASE IesNervion

GO
USE IesNervion
GO

--DROP DATABASE IesNervion
CREATE TABLE Obligaciones (
Codigo SMALLINT NOT NULL,
Denominacion VARCHAR (30) NULL,
IsPuntual BIT NOT NULL,
CONSTRAINT PK_Obligaciones PRIMARY KEY (Codigo),
)

CREATE TABLE Alumnos(
ID SMALLINT NOT NULL,
Nombre VARCHAR (30) NOT NULL,
Apellidos VARCHAR (50) NOT NULL,
Direccion VARCHAR (100) NULL,
Telefono CHAR (9) NULL,
Grupo VARCHAR (5) NOT NULL,

CONSTRAINT PK_Alumnos PRIMARY KEY (ID),
CONSTRAINT CK_Telefono_Alumnos CHECK (Telefono LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)

CREATE TABLE Profesores(
ID SMALLINT NOT NULL,
Nombre VARCHAR (30) NOT NULL,
Apellidos VARCHAR (50) NOT NULL,
Direccion VARCHAR (100) NULL,
Telefono CHAR (9) NULL,
NombrePareja VARCHAR (30) NOT NULL,

CONSTRAINT PK_Profesores PRIMARY KEY (ID),
CONSTRAINT CK_Telefono_Profesores CHECK (Telefono LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)

CREATE TABLE Aulas (
Numero SMALLINT NOT NULL,
Superficie SMALLINT NOT NULL,
Tipo VARCHAR (30) NULL,

CONSTRAINT PK_Aulas PRIMARY KEY (Numero),
)

CREATE TABLE RegalosComestibles (
ID SMALLINT NOT NULL,
Nombre VARCHAR (30) NOT NULL,
Precio MONEY NULL,
FechaCaducidad DATE NULL,
IDProfesor SMALLINT NOT NULL,

CONSTRAINT PK_RegalosComestibles PRIMARY KEY (ID),
CONSTRAINT FK_RegalosComestibles_Profesor FOREIGN KEY (IDProfesor) REFERENCES Profesores (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE RegalosNoComestibles (
ID SMALLINT NOT NULL,
Nombre VARCHAR (30) NOT NULL,
Precio MONEY NULL,
IDProfesor SMALLINT NOT NULL,

CONSTRAINT PK_RegalosNoComestibles PRIMARY KEY (ID),
CONSTRAINT FK_RegalosNoComestibles_Profesor FOREIGN KEY (IDProfesor) REFERENCES Profesores (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE Categorias (
ID SMALLINT NOT NULL,

CONSTRAINT PK_Categorias PRIMARY KEY (ID),
)

CREATE TABLE ObligacionesAlumnos (
CodigoObligacion SMALLINT NOT NULL,
IDAlumno SMALLINT NOT NULL,

CONSTRAINT PK_ObligacionesAlumnos PRIMARY KEY (CodigoObligacion, IDAlumno),
CONSTRAINT FK_ObligacionesAlumnos_Obligaciones FOREIGN KEY (CodigoObligacion) REFERENCES Obligaciones(Codigo) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_ObligacionesAlumnos_Alumnos FOREIGN KEY (IDAlumno) REFERENCES Alumnos (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE AlumnosProfesoresAulas (
IDAlumno SMALLINT NOT NULL,
IDProfesor SMALLINT NOT NULL,
NumeroAula SMALLINT NOT NULL,

CONSTRAINT PK_AlumnosProfesoresAulas PRIMARY KEY (IDAlumno, IDProfesor),
CONSTRAINT FK_AlumnosProfesoresAulas_Alumnos FOREIGN KEY (IDAlumno) REFERENCES Alumnos(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_AlumnosProfesoresAulas_Profesores FOREIGN KEY (IDProfesor) REFERENCES Profesores (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_AlumnosProfesoresAulas_Aulas FOREIGN KEY (NumeroAula) REFERENCES Aulas (Numero) ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE AlumnosRegalosComestibles(
IDAlumno SMALLINT NOT NULL,
IDComestible SMALLINT NOT NULL,

CONSTRAINT PK_AlumnosRegalosComestibles PRIMARY KEY (IDAlumno, IDComestible),
CONSTRAINT FK_AlumnosRegalosComestibles_Alumnos FOREIGN KEY (IDAlumno) REFERENCES Alumnos(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_AlumnosRegalosComestibles_RegalosComestibles FOREIGN KEY (IDComestible) REFERENCES RegalosComestibles (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE AlumnosRegalosNoComestibles(
IDAlumno SMALLINT NOT NULL,
IDNoComestible SMALLINT NOT NULL,

CONSTRAINT PK_AlumnosRegalosNoComestibles PRIMARY KEY (IDAlumno, IDNoComestible),
CONSTRAINT FK_AlumnosRegalosNoComestibles_Alumnos FOREIGN KEY (IDAlumno) REFERENCES Alumnos(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_AlumnosRegalosNoComestibles_RegalosNoComestibles FOREIGN KEY (IDNoComestible) REFERENCES RegalosNoComestibles (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE CategoriasRegalosNoComestibles (
IDCategoria SMALLINT NOT NULL,
IDNoComestible SMALLINT NOT NULL,

CONSTRAINT PK_CategoriasRegalosNoComestibles PRIMARY KEY (IDCategoria, IDNoComestible),
CONSTRAINT FK_CategoriasRegalosNoComestibles_Categorias FOREIGN KEY (IDCategoria) REFERENCES Categorias(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_CategoriasRegalosNoComestibles_RegalosNoComestibles FOREIGN KEY (IDNoComestible) REFERENCES RegalosNoComestibles (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)
