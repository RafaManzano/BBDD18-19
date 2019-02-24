/*DatosRestrictivos. Columnas:
ID Es un SmallInt autonumérico que se rellenará con números impares.. No admite nulos. Clave primaria
Nombre: Cadena de tamaño 15. No puede empezar por "N” ni por "X” Añade una restiricción UNIQUE. No admite nulos
Numpelos: Int con valores comprendidos entre 0 y 145.000
TipoRopa: Carácter con uno de los siguientes valores: "C”, "F”, "E”, "P”, "B”, ”N”
NumSuerte: TinyInt. Tiene que ser un número divisible por 3.
Minutos: TinyInt Con valores comprendidos entre 20 y 85 o entre 120 y 185.*/

USE MASTER
go
CREATE DATABASE RestriccionesRelacionesyMogollon
go
USE RestriccionesRelacionesyMogollon


CREATE TABLE DatosRestrictivos(
	
	ID SmallInt 	NOT NULL	 CONSTRAINT CK_Impar CHECK (ID%2<>0)	CONSTRAINT PK_ID PRIMARY KEY (ID)
	,Nombre varchar(15)		NOT NULL	UNIQUE		CONSTRAINT CK_NX CHECK (Nombre NOT LIKE ('nNxX'))
	,Numpelos Int	NOT NULL	 CONSTRAINT CK_HastaCientoCuarentaYCincoMil CHECK (Numpelos  BETWEEN 0 and 145000)
	,TipoRopa char 		CONSTRAINT CK_Caracter CHECK (TipoRopa LIKE ('[CFEPBN]'))
	,NumSuerte TinyInt 		CONSTRAINT CK_Divisible CHECK (NumSuerte%3=0)
	,Minutos TinyInt		CONSTRAINT CK_Intervalo1 CHECK (Minutos BETWEEN 20 and 85 or Minutos BETWEEN 120 and 185)

)
/*
DatosRelacionados. Columnas:
NombreRelacionado: Cadena de tamaño 15. Define una FK para relacionarla con la columna "Nombre” de la tabla DatosRestrictivos.
¿Deberíamos poner la misma restricción que en la columna correspondiente?
¿Qué ocurriría si la ponemos?
¿Y si no la ponemos?
PalabraTabu: Cadena de longitud max 20. No admitirá los valores "Barcenas”, "Gurtel”, "Púnica”, "Bankia” ni "sobre”. Tampoco admitirá ninguna palabra terminada en "eo”
NumRarito: TinyInt menor que 20. No admitirá números primos.
NumMasgrande: SmallInt. Valores comprendidos entre NumRarito y 1000. Definirlo como clave primaria.
¿Puede tener valores menores que 20?*/

CREATE TABLE DatosRelacionados(

	NombreRelacionado varchar(15) CONSTRAINT FK_NombreRelacionado FOREIGN KEY REFERENCES DatosRestrictivos(Nombre) ON UPDATE CASCADE
	,PalabraTabu NVARCHAR(20) CONSTRAINT CK_PalabraTabu CHECK (PalabraTabu NOT IN ('barcenas','gurtel','punica','Bankia','sobre') AND PalabraTabu NOT LIKE ('%EO'))
	,NumRarito TinyInt CONSTRAINT CK_NumRarito CHECK ((NumRarito BETWEEN 0 AND 20)AND(NumRarito NOT IN (1,2,3,5,7,11,13,17,19)))
	,NumMasGrande SmallInt CONSTRAINT PK_NumMasGrande PRIMARY KEY 
	,CONSTRAINT CK_NumMasGrande CHECK(NumMasGrande BETWEEN NumRarito AND 1000),
)


/*DatosAlMogollon. Columnas:
ID. SmallInt. No admitirá múltiplos de 5. Definirlo como PK
LimiteSuperior. SmallInt comprendido entre 1500 y 2000.
OtroNumero. Será mayor que el ID y Menor que LimiteSuperior. Poner UNIQUE
NumeroQueVinoDelMasAlla: SmallInt FK relacionada con NumMasGrande de la tabla DatosRelacionados
Etiqueta. Cadena de 3 caracteres. No puede tener los valores "pao”, "peo”, "pio” ni "puo”*/

CREATE TABLE DatosAlMogollon(

	ID SmallInt NOT NULL 	CONSTRAINT PK_ID_DatosAlMogollon PRIMARY KEY 
							CONSTRAINT CK_ID_DatosAlMogollon CHECK (ID%5!=0)
	,LimiteSuperior SmallInt CONSTRAINT CK_LimiteSuperior CHECK (LimiteSuperior BETWEEN 1500 AND 2000)
	,OtroNumero SmallInt CONSTRAINT UN_OtroNumero UNIQUE
	,NumeroQueVinoDelMasAlla SmallInt CONSTRAINT FK_NumeroQueVieneDelMasAlla FOREIGN KEY (NumeroQueVinoDelMasAlla) REFERENCES DatosRelacionados(NumMasGrande)
	,Etiqueta nchar(3) CONSTRAINT CK_Etiqueta CHECK (Etiqueta NOT LIKE 'P[AEIU]O')
	

)
