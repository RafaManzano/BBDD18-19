/*
EXAMEN DE BASE DE DATOS DE LUIS ZUMÁRRAGA PUIG.
EN SEVILLA A 12 DE DICIEMBRE DE 2015.
*/


---------- EJERCICIO 2 ----------
CREATE DATABASE LZumarraga
GO
USE LZumarraga
GO

/*
USE Master
DROP DATABASE LZumarraga
*/

CREATE TABLE Apoderados(
	DNI_Apoderado Char Not Null UNIQUE
	,Nombre VarChar(40) not null default 'NombreApoderado'
	,Apellidos VarChar(40) not null default 'ApellidosApoderado'
	,F_Nacimiento SmallDateTime not null

	,CONSTRAINT PK_Apoderado PRIMARY KEY (DNI_Apoderado)
)
GO
CREATE TABLE Candidatos(
	DNI_Candidato Char Not Null UNIQUE
	,Nombre VarChar(40) not null default 'NombreCandidato'
	,Apellidos VarChar(40) not null default 'ApellidosCandidato'
	,F_Nacimiento SmallDateTime not null
	,Orden_Eleccion SmallInt Not null

	,CONSTRAINT PK_Candidatos PRIMARY KEY (DNI_Candidato)
)
GO
CREATE TABLE Interventores(
	DNI_Interventor Char Not Null UNIQUE
	,Nombre VarChar(40) not null default 'NombreInterventor'
	,Apellidos VarChar(40) not null default 'ApellidosInterventor'
	,F_Nacimiento SmallDateTime not null

	,CONSTRAINT PK_Interventores PRIMARY KEY (DNI_Interventor)
)
GO
CREATE TABLE Formaciones(
	ID_Formaciones smallint not null
	,Nombre_Completo VarChar(40) not null default 'NombreFormacion' UNIQUE
	,Abreviatura VarChar(40) not null default 'NombreFormacion' UNIQUE
	,F_Fundacion SmallDateTime Not Null

	,CONSTRAINT PK_Formaciones PRIMARY KEY (ID_Formaciones)
)
GO
CREATE TABLE Partidos(
	Nombre_Partido VarChar(40) not null default 'NombrePartido' UNIQUE
	,Ideologia VarChar (20) Not Null default 'Ideologia'
	,Nombre_Lider VarChar(40) not null default 'NombreLider'
	,ID_Formaciones_Partidos smallint not null

	,CONSTRAINT PK_Partidos PRIMARY KEY (Nombre_Partido)

	,CONSTRAINT FK_Formacion_Partidos FOREIGN KEY (ID_Formaciones_Partidos) REFERENCES Formaciones (ID_Formaciones)
)
GO
CREATE TABLE Coaliciones(
	Nombre_Coalicion VarChar(40) not null default 'Nombre Coalicion' UNIQUE
	,Ambito Varchar(20) Not null
	,ID_Formaciones_Coaliciones smallint not null

	,CONSTRAINT PK_Nombre_Coalicion PRIMARY KEY (Nombre_Coalicion)
	,CONSTRAINT FK_Formacion_Coaliciones FOREIGN KEY (ID_Formaciones_Coaliciones) REFERENCES Formaciones (ID_Formaciones)
)
GO
CREATE TABLE Candidaturas(
	ID_Candidatura smallInt Not Null
	,Nombre VarChar(40) not null default 'NombreCandidatura' UNIQUE
	,Nombre_Representante VarChar(40) not null default 'NombreRepresentante'
	,Apellidos_Representante VarChar(40) not null default 'ApellidosRepresentante'
	,Telefono char(9) not null UNIQUE
	,ID_Formaciones_Candidaturas smallint not null

	,DNI_Candidato Char Not Null
	,DNI_Apoderado Char Not Null
	,DNI_Interventor Char Not Null

	,CONSTRAINT PK_ID_Candidatura PRIMARY KEY (ID_Candidatura)

	,CONSTRAINT FK_DNI_Candidato FOREIGN KEY (DNI_Candidato) REFERENCES Candidatos (DNI_Candidato) ON DELETE NO ACTION ON UPDATE CASCADE
	,CONSTRAINT FK_DNI_Apoderado FOREIGN KEY (DNI_Apoderado) REFERENCES Apoderados (DNI_Apoderado) ON DELETE NO ACTION ON UPDATE CASCADE
	,CONSTRAINT FK_DNI_Interventor FOREIGN KEY (DNI_Interventor) REFERENCES Interventores (DNI_Interventor) ON DELETE NO ACTION ON UPDATE CASCADE
	,CONSTRAINT FK_ID_Formaciones_Candidaturas FOREIGN KEY (ID_Formaciones_Candidaturas) REFERENCES Formaciones (ID_Formaciones) ON DELETE NO ACTION ON UPDATE CASCADE
)
GO
CREATE TABLE Circunscripciones(
	Codigo_Circunscripcion smallInt not null
	,Nombre VarChar(40) not null default 'NombreCircunscripcion' UNIQUE

	,ID_Candidatura smallInt Not Null

	,CONSTRAINT PK_Circunscripciones PRIMARY KEY (Codigo_Circunscripcion)

	,CONSTRAINT FK_ID_Candidatura FOREIGN KEY (ID_Candidatura) REFERENCES Candidaturas (ID_Candidatura)
)
GO
CREATE TABLE Mesas(
	N_Distrito SmallInt NOT NULL
	,N_Seccion SmallInt NOT NULL
	,L_Mesa char(1) NOT NULL
	,Direccion varchar(1200) NOT NULL
	,N_Electores int

	,Codigo_Circunscripcion smallInt not null

	,CONSTRAINT PK_Mesas PRIMARY KEY (N_Distrito,N_Seccion,L_Mesa)

	,CONSTRAINT FK_Codigo_Circunscripcion FOREIGN KEY (Codigo_Circunscripcion) REFERENCES Circunscripciones (Codigo_Circunscripcion) ON DELETE NO ACTION ON UPDATE CASCADE
)
GO
CREATE TABLE Mesas_Candidaturas(
	ID_Mesas_Candidaturas int not null
	,N_VotosCongreso int not null

	,N_Distrito SmallInt not null 
	,N_Seccion SmallInt not null
	,L_Mesa char(1) NOT NULL

	,ID_Candidatura smallInt Not Null

	,CONSTRAINT PK_ID_Mesas_Candidaturas PRIMARY KEY (ID_Mesas_Candidaturas)

	,CONSTRAINT FK_Mesas FOREIGN KEY (N_Distrito,N_Seccion,L_Mesa) REFERENCES Mesas (N_Distrito,N_Seccion,L_Mesa) ON DELETE NO ACTION ON UPDATE CASCADE
	,CONSTRAINT FK_Candidatura FOREIGN KEY (ID_Candidatura) REFERENCES Candidaturas (ID_Candidatura) ON DELETE NO ACTION ON UPDATE CASCADE
)
GO
CREATE TABLE Mesas_Circunscripciones(
	N_VotosSenado int not null

	,N_Distrito SmallInt not null
	,N_Seccion SmallInt not null
	,L_Mesa SmallInt not null

	,Codigo_Circunscripcion smallInt not null

	,CONSTRAINT PK_ID_Mesas_Circunscripciones PRIMARY KEY (N_Distrito,N_Seccion,L_Mesa,Codigo_Circunscripcion)
	,CONSTRAINT FK_Codigo_Circunscripcion_Mesa FOREIGN KEY (Codigo_Circunscripcion) REFERENCES Circunscripciones (Codigo_Circunscripcion)
)

---------- EJERCICIO 3 ----------

ALTER TABLE Formaciones add constraint CK_Fecha_Fundacion check (F_Fundacion<=CURRENT_Timestamp) 
GO
ALTER TABLE Mesas_Candidaturas ADD CONSTRAINT CK_NumeroVotosCongreso CHECK (N_VotosCongreso>0)
GO
ALTER TABLE Mesas_Circunscripciones ADD CONSTRAINT CK_NumeroVotosSenado CHECK (N_VotosSenado>0)
GO


ALTER TABLE Apoderados ADD CONSTRAINT LK_DNI_Apoderados CHECK (DNI_Apoderado LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_') 
GO
ALTER TABLE Interventores ADD CONSTRAINT LK_DNI_Interventores CHECK (DNI_Interventor LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_') 
GO
ALTER TABLE Candidatos ADD CONSTRAINT LK_DNI_Candidatos CHECK (DNI_Candidato LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_')
GO


ALTER TABLE Mesas ADD CONSTRAINT BT_Electores CHECK (N_Electores BETWEEN 10 AND 1500)
GO

ALTER TABLE	Coaliciones ADD CONSTRAINT IN_Ambito CHECK (Ambito IN ('LOCAL','PROVINCIAL','REGIONAL','NACIONAL','EUROPEA'))