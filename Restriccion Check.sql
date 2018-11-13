If Not Exists (SELECT * From Sys.databases Where name = 'Ejemplos' )
	Create Database Ejemplos
GO
USE Ejemplos
GO

CREATE TABLE CriaturitasRaras(
	ID tinyint NOT NULL,
	Nombre nvarchar(30) NULL,
	FechaNac Date NULL, 
	NumeroPie SmallInt NULL,
	NivelIngles NChar(2) NULL,
	Historieta VarChar(30) NULL,
	NumeroChico TinyInt NULL,
	NumeroGrande BigInt NULL,
	NumeroIntermedio SmallInt NULL,
	CONSTRAINT [PK_CriaturitasEx] PRIMARY KEY(ID),
	CONSTRAINT CK_NumeroPie CHECK (NumeroPie BETWEEN 25 AND 50),
	CONSTRAINT CK_NumeroChico CHECK (NumeroChico < 1000),
	CONSTRAINT CK_NumeroGrande CHECK (NumeroGrande > NumeroChico * 100),
	CONSTRAINT CK_NumeroIntermedio CHECK (NumeroIntermedio % 2 = 0 AND NumeroIntermedio BETWEEN NumeroChico AND NumeroGrande),
	CONSTRAINT CK_FechaNac CHECK (FechaNac < CURRENT_TIMESTAMP),
	CONSTRAINT CK_NivelIngles CHECK (NivelIngles IN ('A0','A1', 'A2', 'B1', 'B2', 'C1','C2')),
	CONSTRAINT CK_Historieta CHECK (Historieta NOT LIKE 'oscuro''apocalipsis'),
	--CONSTRAINT CK_Temperatura CHECK Temperatura BETWEEN 32.5 AND 44,
) 

GO

