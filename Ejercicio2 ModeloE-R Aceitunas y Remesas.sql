CREATE DATABASE Granja
GO
USE Granja
GO

--DROP DATABASE Granja
CREATE TABLE Agricultores (
ID INT NOT NULL IDENTITY (1,1), --Identity se usa para hacer que una columa tenga valores automaticos
Nombre VARCHAR (25) NOT NULL,
Apellidos VARCHAR (40) NOT NULL,
Direccion VARCHAR (80) NULL,
Telefono CHAR(9) NULL,
CONSTRAINT PK_Agricultor PRIMARY KEY (ID),
)

CREATE TABLE Distribuidoras(
ID INT NOT NULL IDENTITY (1,1),
Nombre VARCHAR (40) NOT NULL,
Direccion VARCHAR (80) NULL,
Telefono CHAR(9) NOT NULL,
CONSTRAINT PK_Distribuidora PRIMARY KEY (ID),
)

CREATE TABLE Fincas (
Nombre CHAR (20) NOT NULL,
Distancia INT NULL,
Municipio VARCHAR (20) NOT NULL,
CONSTRAINT PK_Finca PRIMARY KEY (Nombre),
)

CREATE TABLE Tractores (
Matricula CHAR (7) NOT NULL, --char(7) matricula tiene 7 digitos siempre
Marca VARCHAR (15) NOT NULL,
Modelo VARCHAR (30) NOT NULL,
ID_Agricultor INT NOT NULL,
CONSTRAINT PK_Tractor PRIMARY KEY (Matricula),
CONSTRAINT FK_Tractor_Agricultor FOREIGN KEY (ID_Agricultor) REFERENCES
Agricultores(ID) ON DELETE NO ACTION ON UPDATE CASCADE --cascade se usa para las foreign key (cuidado hay veces que hay que poner no action)
)

CREATE TABLE Lotes(
ID INT NOT NULL IDENTITY (1,1),
Peso INT NOT NULL,
Fecha SMALLDATETIME NOT NULL,
Finca_Procedencia CHAR(20) NOT NULL,
Metodo_Ecologico BIT NULL, --Es el tipo booleano
Variedad VARCHAR (20) NULL,
ID_Agricultor INT NOT NULL,
CONSTRAINT PK_Lote PRIMARY KEY (ID),
CONSTRAINT FK_Lote_Agricultor FOREIGN KEY (Id_Agricultor) REFERENCES
Agricultores(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_Lote_Finca FOREIGN KEY (Finca_Procedencia) REFERENCES
Fincas(Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,
)



CREATE TABLE Remesas (
ID INT NOT NULL IDENTITY (1,1),
Acidez VARCHAR(20) NULL,
Cantidad INT NOT NULL,
ID_Lote INT NOT NULL,
ID_Distribuidora INT NOT NULL,
CONSTRAINT PK_Remesa PRIMARY KEY (ID),
CONSTRAINT FK_Remesa_Lote FOREIGN KEY (ID_Lote) REFERENCES
Lotes(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT UQ_Remesa_Lote UNIQUE(ID_Lote),
CONSTRAINT FK_Remesa_Distribuidora FOREIGN KEY (ID_Distribuidora) REFERENCES
Distribuidoras (ID) ON DELETE NO ACTION ON UPDATE CASCADE, --Este error es porque sql entiende que no esta creada
)

