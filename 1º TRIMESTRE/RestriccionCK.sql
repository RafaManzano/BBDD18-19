CREATE DATABASE RestriccionCK
GO
USE RestriccionCK
GO

--DROP DATABASE RestriccionCK
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
CONSTRAINT CK_ID_DR CHECK (ID % 2 <> 0),
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
CONSTRAINT CK_NumRarito CHECK(NumRarito < 20 AND NumRarito NOT IN (2,3,5,7,11,13,17,19)),
CONSTRAINT CK_NumMasgrande CHECK (NumMasgrande BETWEEN NumRarito AND 1000),
)

CREATE TABLE DatosAlMogollon (
ID SMALLINT NOT NULL,
LimiteSuperior SMALLINT NULL,
OtroNumero SMALLINT NULL,
NumeroQueVinoDelMasAlla SMALLINT NULL,
Etiqueta CHAR(3) NULL,

--PK,FK,UQ
CONSTRAINT PK_DatosAlMogollon PRIMARY KEY (ID),
CONSTRAINT UQ_DatosAlMogollon UNIQUE (OtroNumero),
CONSTRAINT FK_DAM_DR FOREIGN KEY (NumeroQueVinoDelMasAlla) REFERENCES DatosRelacionados (NumMasgrande) ON DELETE NO ACTION ON UPDATE CASCADE,


--CHECK
CONSTRAINT CK_ID_DAM CHECK (ID % 5 <> 0),
CONSTRAINT CK_LimiteSuperior CHECK (LimiteSuperior BETWEEN 1500 AND 2000),
CONSTRAINT CK_OtroNumero CHECK (OtroNumero > ID AND OtroNumero < LimiteSuperior),
CONSTRAINT CK_Etiqueta CHECK (Etiqueta NOT IN('pao', 'peo', 'pio' ,'puo')),
)

--Preguntas DATOS RELACIONADOS
--�Deber�amos poner la misma restricci�n que en la columna correspondiente?
--Pienso que no, puesto que al referirnos a la otra tabla tambien le acompa�an sus restricciones
--�Qu� ocurrir�a si la ponemos?
-- Seria redundante
--�Y si no la ponemos?
-- La restriccion seria siendo efectiva

--PREGUNTAS DATOS A MOGOLLON
--�Puede tener valores menores que 20?
-- No, puesto que la restriccion de NumRarito no deja tener valores menor que 20
