CREATE DATABASE EjemplosRafa
GO
USE EjemplosRafa
GO

/*DatosRestrictivos. Columnas:
ID Es un SmallInt autonumérico que se rellenará con números impares.. No admite nulos. Clave primaria
Nombre: Cadena de tamaño 15. No puede empezar por "N” ni por "X” Añade una restiricción UNIQUE. No admite nulos
Numpelos: Int con valores comprendidos entre 0 y 145.000
TipoRopa: Carácter con uno de los siguientes valores: "C”, "F”, "E”, "P”, "B”, ”N”
NumSuerte: TinyInt. Tiene que ser un número divisible por 3.
Minutos: TinyInt Con valores comprendidos entre 20 y 85 o entre 120 y 185.
*/

/*DatosRelacionados. Columnas:
NombreRelacionado: Cadena de tamaño 15. Define una FK para relacionarla con la columna "Nombre” de la tabla DatosRestrictivos.
¿Deberíamos poner la misma restricción que en la columna correspondiente?
¿Qué ocurriría si la ponemos?
¿Y si no la ponemos?
PalabraTabu: Cadena de longitud max 20. No admitirá los valores "Barcenas”, "Gurtel”, "Púnica”, "Bankia” ni "sobre”. Tampoco admitirá ninguna palabra terminada en "eo”
NumRarito: TinyInt menor que 20. No admitirá números primos.
NumMasgrande: SmallInt. Valores comprendidos entre NumRarito y 1000. Definirlo como clave primaria.
¿Puede tener valores menores que 20?
*/

/*
DatosAlMogollon. Columnas:
ID. SmallInt. No admitirá múltiplos de 5. Definirlo como PK
LimiteSuperior. SmallInt comprendido entre 1500 y 2000.
OtroNumero. Será mayor que el ID y Menor que LimiteSuperior. Poner UNIQUE
NumeroQueVinoDelMasAlla: SmallInt FK relacionada con NumMasGrande de la tabla DatosRelacionados
Etiqueta. Cadena de 3 caracteres. No puede tener los valores "pao”, "peo”, "pio” ni "puo”
*/

CREATE TABLE DatosRestrictivos(
ID SMALLINT NOT NULL IDENTITY (1,2),
Nombre CHAR (15) NOT NULL, 
Numpelos INT NULL,
TipoRopa CHAR (1) NULL,
NumSuerte TINYINT NULL,
Minutos TINYINT NULL,
CONSTRAINT PK_ID PRIMARY KEY (ID),
CONSTRAINT UQ_Nombre UNIQUE (Nombre),
CONSTRAINT CHK_Nombre CHECK (Nombre NOT LIKE '[NX]%'),
CONSTRAINT CHK_Numpelos CHECK (Numpelos BETWEEN 0 AND 145000),
CONSTRAINT CHK_TipoRopa CHECK (TipoRopa IN ('C','F','E','P','B','N')),
CONSTRAINT CHK_NumSuerte CHECK (NumSuerte % 3 = 0),
CONSTRAINT CHK_Minutos CHECK (Minutos BETWEEN 20 AND 85 OR Minutos BETWEEN 120 AND 185)
)

CREATE TABLE DatosRelacionados(
NombreRelacionado CHAR (15) NOT NULL,
PalabraTabu VARCHAR (20) NOT NULL,
NumRarito TINYINT NULL,
NumMasgrande SMALLINT NOT NULL,
CONSTRAINT PK_NombreRelacionado PRIMARY KEY (NumMasgrande),
NombreRestrictivos CHAR (15) NOT NULL,
CONSTRAINT FK_Nombre_DatosRelacionados FOREIGN KEY (NombreRelacionado) REFERENCES DatosRestrictivos(Nombre), 
CONSTRAINT CHK_PalabraTabu CHECK (PalabraTabu NOT IN (('Barcenas', 'Gurtel', 'Púnica', 'Bankia', 'sobre') AND (PalabraTabu NOT LIKE '%eo')),
CONSTRAINT CHK_NumMasgrande CHECK (NumMasgrande BETWEEN NumRarito AND 1000)
)

CREATE TABLE DatosAlMogollon(
ID SMALLINT NOT NULL,
LimiteSuperior SMALLINT NOT NULL,
OtroNumero SMALLINT NOT NULL,
NumeroQueVinoDelMasAlla SMALLINT NULL,
Etiqueta VARCHAR (3) NULL,
CONSTRAINT PK_ID PRIMARY KEY (ID),
CONSTRAINT CK_ID_DatosAlMogollon CHECK (ID%5!=0),
CONSTRAINT CHK_LimiteSuperior CHECK (LimiteSuperior BETWEEN 1500 AND 2000),
-- Se va a poner en alter tableCONSTRAINT CHK_OtroNumero CHECK (OtroNumero > ID AND OtroNumero < LimiteSuperior),
CONSTRAINT UQ_OtroNumero UNIQUE (OtroNumero),
CONSTRAINT FK_NumeroQueVinoDelMasAlla FOREIGN KEY (NumeroQueVinoDelMasAlla) REFERENCES DatosRelacionados(NumMasgrande), 
CONSTRAINT CHK_Etiqueta CHECK (Etiqueta NOT IN ('pao', 'peo', 'pio', 'puo'))
)

ALTER TABLE DatosAlMogollon ADD
	CONSTRAINT CK_OtroNumero_DatosAlMogollon CHECK (OtroNumero>ID AND OtroNumero<LimiteSuperior)
