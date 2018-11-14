CREATE DATABASE RestriccionCK
GO
USE RestriccionCK
GO

CREATE TABLE DatosRestrictivos (
ID SMALLINT NOT NULL,
Nombre CHAR (15) NOT NULL,
NumPelos INT NULL,
TipoRopa CHAR(1) NULL,
NumSuerte TINYINT NULL,
Minutos TINYINT NULL,
--PK,FK,UQ
CONSTRAINT PK_DatosRestrictivos PRIMARY KEY (ID),
CONSTRAINT UQ_DatosRestrictivos UNIQUE (Nombre),

--CHECK
CONSTRAINT CK_ID CHECK (ID % 2 <> 0),
CONSTRAINT CK_Nombre CHECK (Nombre NOT LIKE'[NX]%'),
CONSTRAINT CK_NumPelos CHECK (NumPelos BETWEEN 0 AND 145000),
CONSTRAINT CK_TipoRopa CHECK (TipoRopa IN('C','F','E','P','B','N')),
CONSTRAINT CK_NumSuerte CHECK (NumSuerte % 3 = 0),
CONSTRAINT CK_Minutos CHECK (Minutos BETWEEN 20 AND 85 OR Minutos BETWEEN 120 AND 185),
)

CREATE TABLE DatosRelacionados (
NombreRelacionado CHAR (15) NULL,
PalabraTabu CHAR (20) NULL,
NumRarito TINYINT NULL,
NumMasgrande SMALLINT NOT NULL,

--PK,FK,UQ
CONSTRAINT FK_DRelacionados_DRestrictivos FOREIGN KEY (NombreRelacionado) REFERENCES DatosRestrictivos(Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT PK_DatosRelacionados PRIMARY KEY (NumMasgrande),

--CHECK
CONSTRAINT CK_PalabraTabu CHECK (PalabraTabu NOT IN ('Barcenas', 'Gurtel', 'Punica', 'Bankia', 'sobre') AND PalabraTabu NOT LIKE '%eo'),
CONSTRAINT CK_NumRarito CHECK(NumRarito < 20 AND NumRarito % 2 = 0 OR NumRarito % 3 = 0 OR NumRarito % 5 = 0),
CONSTRAINT CK_NumMasgrande CHECK (NumMasgrande BETWEEN NumRarito AND 1000),
)

CREATE TABLE DatosAlMogollon (
ID SMALLINT NOT NULL,
LimiteSuperior SMALLINT NULL,

--PK,FK,UQ
CONSTRAINT PK_DatosAlMogollon PRIMARY KEY (ID),

--CHECK
CONSTRAINT CK_ID CHECK (ID % 5 <> 0),
CONSTRAINT CK_LimiteSuperior CHECK (LimiteSuperior BETWEEN 1500 AND 2000),
)