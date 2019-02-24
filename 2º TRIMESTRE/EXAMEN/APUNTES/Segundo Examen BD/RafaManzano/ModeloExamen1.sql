CREATE DATABASE Examen1
GO
USE Examen1
GO 
--DROP DATABASE Examen1
CREATE TABLE SerVivo (
Codigo INT NOT NULL,
Especie VARCHAR (30) NOT NULL,
TempMax SMALLINT NULL,
TempMin SMALLINT NULL,
NombreComun VARCHAR (40) NOT NULL,
CONSTRAINT UQ_Codigo_SerVivo UNIQUE (Codigo),
)

CREATE TABLE Acuario (
Codigo SMALLINT NOT NULL,
Capacidad SMALLINT NULL,
Medida VARCHAR (30) NULL,
Temperatura SMALLINT NULL,
Codigo_Bomba SMALLINT NOT NULL,
CONSTRAINT PK_Codigo_Acuario PRIMARY KEY (Codigo),
)

CREATE TABLE Bomba (
Codigo SMALLINT NOT NULL,
Marca VARCHAR (30) NOT NULL,
Modelo VARCHAR (20) NOT NULL,
Caudal SMALLINT NULL,
Consumo SMALLINT NULL,
CONSTRAINT PK_Codigo_Bomba PRIMARY KEY (Codigo),
)

CREATE TABLE Pez (
Codigo INT NOT NULL,
Tipo CHAR (1) NOT NULL,
Color VARCHAR (15) NULL,
Tamaño SMALLINT NULL,
Codigo_SerVivo INT NOT NULL,
Codigo_Alimento INT NOT NULL,
CONSTRAINT PK_Codigo_Pez PRIMARY KEY (Codigo),
)

CREATE TABLE Planta (
Codigo INT NOT NULL,
Tamaño SMALLINT NULL,
NecesidadLuz BIT NULL,
Codigo_SerVivo INT NOT NULL,
CONSTRAINT PK_Codigo_Planta PRIMARY KEY (Codigo),
)

CREATE TABLE Socio (
NumSocio SMALLINT NOT NULL,
Nombre VARCHAR (20) NOT NULL,
Apellidos VARCHAR (40) NOT NULL,
Direccion VARCHAR (80) NULL,
Email VARCHAR (50) NULL,
Telefono CHAR (9) NULL,
Codigo_Acuario SMALLINT NOT NULL,
Codigo_Alimento INT NOT NULL,
CONSTRAINT PK_NumSocio_Socio PRIMARY KEY (NumSocio),
)

CREATE TABLE Alimento (
Codigo INT NOT NULL,
Tipo VARCHAR (20) NOT NULL,
Nombre VARCHAR (20) NOT NULL,
ValorEnergetico SMALLINT NULL,
CONSTRAINT PK_Codigo_Alimento PRIMARY KEY (Codigo),
)

CREATE TABLE SVAcuario (
Codigo_Acuario SMALLINT NOT NULL,
Codigo_SerVivo INT NOT NULL,
Habitantes SMALLINT NULL,
CONSTRAINT PK_CodigoAcuarioSerVivo PRIMARY KEY (Codigo_Acuario,Codigo_SerVivo),
)

CREATE TABLE Tierra (
Nombre VARCHAR (30) NOT NULL,
Codigo INT NOT NULL,
CONSTRAINT PK_Codigo_Tierra PRIMARY KEY (Codigo)
)

CREATE TABLE MezclaTierra (
Codigo_Tierra INT NOT NULL,
Mezcla VARCHAR (30) NOT NULL,
CONSTRAINT PK_CodigoTierra_MezclaTierra PRIMARY KEY (Codigo_Tierra)
)

CREATE TABLE Incompatible (
Codigo_Pez1 INT NOT NULL,
Codigo_Pez2 INT NOT NULL,
CONSTRAINT PK_Peces_Pez PRIMARY KEY (Codigo_Pez1,Codigo_Pez2),
)

ALTER TABLE Acuario ADD CONSTRAINT FK_CodigoBomba_Acuario FOREIGN KEY (Codigo_Bomba) REFERENCES Bomba (Codigo)
ALTER TABLE Pez ADD CONSTRAINT FK_CodigoSerVivo_Pez FOREIGN KEY (Codigo_SerVivo) REFERENCES SerVivo (Codigo)
ALTER TABLE Pez ADD CONSTRAINT FK_CodigoAlimento_Pez FOREIGN KEY (Codigo_Alimento) REFERENCES Alimento (Codigo)
ALTER TABLE Planta ADD CONSTRAINT FK_CodigoSerVivo_Planta FOREIGN KEY (Codigo_SerVivo) REFERENCES SerVivo (Codigo)
ALTER TABLE Socio ADD CONSTRAINT FK_CodigoAlimento_Socio FOREIGN KEY (Codigo_Alimento) REFERENCES Alimento(Codigo)
ALTER TABLE SVAcuario ADD CONSTRAINT FK_CodigoAcuario_SVAcuario FOREIGN KEY (Codigo_Acuario) REFERENCES Acuario (Codigo)
ALTER TABLE SVAcuario ADD CONSTRAINT FK_CodigoSerVivo_SVAcuario FOREIGN KEY (Codigo_SerVivo) REFERENCES SerVivo (Codigo)
ALTER TABLE MezclaTierra ADD CONSTRAINT FK_CodigoTierra_MezclaTierra FOREIGN KEY (Codigo_Tierra) REFERENCES Tierra (Codigo)
ALTER TABLE Incompatible ADD CONSTRAINT FK_CodigoPez1_Incompatible FOREIGN KEY (Codigo_Pez1) REFERENCES Pez (Codigo)
ALTER TABLE Incompatible ADD CONSTRAINT FK_CodigoPez2_Incompatible FOREIGN KEY (Codigo_Pez2) REFERENCES Pez (Codigo)
ALTER TABLE Acuario ADD CONSTRAINT CK_CapacidadM0_Acuario CHECK (Capacidad > 0)
ALTER TABLE Acuario ADD CONSTRAINT CK_Temperatura10y30_Acuario CHECK (Temperatura BETWEEN 10 AND 30)
ALTER TABLE Pez ADD CONSTRAINT CK_TipoValores_Pez CHECK (Tipo IN('T','R','S','A','L'))
ALTER TABLE Planta ADD CONSTRAINT CK_NecesidadLuz4y10_Planta CHECK (NecesidadLuz BETWEEN 4 AND 10)


/*
CREATE TABLE Color (
Codigo_Pez INT NOT NULL,
Color VARCHAR (15) NOT NULL,
CONSTRAINT PK_CodigoPez_Color PRIMARY KEY (Codigo_Pez)
)

ALTER TABLE Color ADD CONSTRAINT FK_CodigoPez_Color FOREIGN KEY (Codigo_Pez) REFERENCES Pez (Codigo)
*/




