--1. Crea una base de datos de nombre “Laboratorio Quimico”.
CREATE DATABASE [Laboratorio Quimico]

USE [Laboratorio Quimico]

--2. Crea una tabla de nombre LQ_Elementos, con las columnas simbolo (dos caracteres,
--clave primaria) y nombre (Cadena variable de tamaño 15). Ninguna admite nulos.
CREATE TABLE [LQ_Elementos] (
	simbolo char(2)
	,nombre varchar(15) NOT NULL

	,CONSTRAINT PK_LQ_Elementos PRIMARY KEY (simbolo)
)

--3. Crea otra tabla llamada LQ_Tipos_Compuesto con dos columnas: tipo (entero corto,
--clave primaria, identidad) y denominacion (cadena variable de tamaño 30). Ninguna
--admite nulos. Define denominacion como clave alternativa.
CREATE TABLE [LQ_Tipos_Compuesto] (
	tipo smallint IDENTITY
	,denominacion varchar(30) NOT NULL UNIQUE

	,CONSTRAINT PK_LQ_Tipos_Compuesto PRIMARY KEY (tipo)
)

--4. Crea otra tabla llamada LQ_Moleculas con las columnas nombre_clasico (cadena
--variable longitud 30), nombre_IUPAC (cadena variable longitud 30), color (cadena
--variable longitud 20), densidad (decimal de dos cifras enteras y tres decimales),
--punto_fusion(real), punto_ebullicion (real). Ninguna admite nulos excepto densidad y
--color.
--punto_fusion y punto_ebullicion toman valores positivos. El valor de punto_ebullición
--ha de ser superior a punto_fusion.
CREATE TABLE [LQ_Moleculas] (
	nombre_clasico varchar(30) NOT NULL
	,nombre_IUPAC varchar(30) NOT NULL
	,color varchar(20) NULL
	,densidad decimal(5,2) NULL
	,punto_fusion decimal NOT NULL
	,punto_ebullicion decimal NOT NULL

	,CONSTRAINT CK_Positivo_Fusion CHECK ( punto_fusion >= 0 )
	,CONSTRAINT CK_Positivo_Ebullicion CHECK ( punto_ebullicion >= 0 )
	,CONSTRAINT CK_Ebullicion_Fusion CHECK ( punto_ebullicion > punto_fusion )
)

--5. Añade dos nuevas columnas a la tabla LQ_Elementos: numero_atomico (entero corto,
--sin nulos) y masa_atomica (tres cifras enteras y cinco decimales, admite nulos). El
--número atómico no debe admitir valores inferiores a uno ni superiores a 300 y será clave
--alternativa.

--6. Añade una nueva columna a LQ_Moleculas llamada codigo. Será de tipo entero,
--identidad y defínela como clave primaria.

--7. Crea una nueva tabla que relacione LQ_Elementos con LQ_Moleculas, llámala
--LQ_MoleculasElementos. Añade una columna numero que indique el subíndice del
--elemento en la molécula (entero corto sin nulos, valor mínimo 1). Crea las restricciones de
--clave primaria y ajena que sean necesarias.

--8. Añade una nueva columna a LQ_Moleculas llamada tipo que la relacione con
--LQ_Tipos_Compuesto. Puede admitir valores nulos. Añade la restricción de clave ajena
--necesaria.

--9. Crea una tabla de nombre LQ_Colores para normalizar los colores y crea una clave ajena
--en LQ_Moleculas que relacione la columna color con esta nueva tabla.

--10. Añade una nueva columna a LQ_Elementos de nombre tipo, que puede tomar
--únicamente los siguientes valores: Metal, No metal, Gas noble, Tierra rara

--11. Propón una solución para registrar datos sobre las reacciones químicas. En una reacción
--química intervienen varias moléculas como reactivos y se obtienen otras como productos.
--Es importante saber las cantidades relativas de cada reactivo y cada producto. Una
--reacción puede absorber energía o liberarla, también nos interesa saber este dato. 
