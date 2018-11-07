CREATE DATABASE MezclasCafes

GO
USE MezclasCafes
GO

CREATE TABLE Cafes (
ID SMALLINT NOT NULL IDENTITY (1,1),
Nombre VARCHAR(25) NOT NULL,
LugarOrigen VARCHAR (40) NULL,
Precio MONEY NOT NULL,
CONSTRAINT PK_Cafes PRIMARY KEY (ID),
)

CREATE TABLE Propiedades (
Codigo SMALLINT NOT NULL IDENTITY (1,1),
ISAntioxidante BIT NULL,
ISDigestivo BIT NULL,
ISTonificante BIT NULL,
CONSTRAINT PK_Propiedades PRIMARY KEY (Codigo),
)
CREATE TABLE Mezclas (
Codigo SMALLINT NOT NULL IDENTITY (1,1),
CONSTRAINT PK_Mezclas PRIMARY KEY (Codigo),
)

CREATE TABLE Clientes (
Nick VARCHAR (25) NOT NULL,
Nombre VARCHAR (40) NULL,
Direccion VARCHAR (80) NULL,
Contraseņa VARCHAR (15) NOT NULL,
CONSTRAINT PK_Clientes PRIMARY KEY (Nick),
)