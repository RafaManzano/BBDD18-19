CREATE DATABASE Ciclogreen 

GO 
USE Ciclogreen
GO

--DROP DATABASE Ciclogreen
CREATE TABLE Zonas (
Nombre VARCHAR (40) NOT NULL,

--PK, FK, UQ
CONSTRAINT PK_Zonas PRIMARY KEY (Nombre),
)


CREATE TABLE Ciudades (
CodigoPostal INT NOT NULL,
TipoOrografia VARCHAR (25) NOT NULL,
KM INT NULL,
NumeroHabitantes INT NOT NULL,
Extension SMALLINT NULL,
NombreZona VARCHAR (40) NOT NULL,

--PK, FK, UQ
CONSTRAINT PK_Ciudades PRIMARY KEY (CodigoPostal),
CONSTRAINT FK_Ciudades_Zonas FOREIGN KEY (NombreZona) REFERENCES Zonas (Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE Estacionamientos (
ID SMALLINT NOT NULL,
NombreZona VARCHAR (40) NOT NULL,

--PK, FK, UQ
CONSTRAINT PK_Estacionamientos PRIMARY KEY (ID, NombreZona),
CONSTRAINT PK_Estacionamientos_Zonas FOREIGN KEY (NombreZona) REFERENCES Zonas(Nombre) ON DELETE CASCADE ON UPDATE CASCADE,
)

CREATE TABLE Clientes (
ID SMALLINT NOT NULL,
Nombre VARCHAR (40) NOT NULL,
Apellidos VARCHAR (80) NOT NULL,
MedioPago VARCHAR (20) NOT NULL,

--PK, FK, UQ
CONSTRAINT PK_Clientes PRIMARY KEY (ID),
)

CREATE TABLE Clientes_Estacionamientos (
IDEstacionamiento SMALLINT NOT NULL,
IDClientes SMALLINT NOT NULL,
NombreZona VARCHAR (40) NOT NULL,

--PK, FK, UQ
CONSTRAINT PK_ClientesEstacionamiento PRIMARY KEY (IDEstacionamiento, IDClientes, NombreZona),
CONSTRAINT FK_ClientesEstacionamientos_Estacionamientos FOREIGN KEY (NombreZona, IDEstacionamiento) REFERENCES Estacionamientos(NombreZona, ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_ClientesEstacionamientos_Clientes FOREIGN KEY (IDClientes) REFERENCES Clientes(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE Alquileres (
ID SMALLINT NOT NULL,
IDCliente SMALLINT NOT NULL,

--PK, FK, UQ
CONSTRAINT PK_Alquiler PRIMARY KEY (ID),
CONSTRAINT FK_Alquiler_Cliente FOREIGN KEY (IDCliente) REFERENCES Clientes(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE Recibos (
ID SMALLINT NOT NULL,
FechaEnvio DATE NULL,
FechaCobro DATE NULL,
IDAlquiler SMALLINT NOT NULL,

--PK, FK, UQ
CONSTRAINT PK_Recibo PRIMARY KEY (ID),
CONSTRAINT FK_ReciboAlquiler FOREIGN KEY (IDAlquiler) REFERENCES Alquileres(ID) ON DELETE NO ACTION ON UPDATE CASCADE
)

CREATE TABLE Bicicletas (
ID SMALLINT NOT NULL,
Tipo VARCHAR (30) NOT NULL,

--PK, FK, UQ
CONSTRAINT PK_Bicicleta PRIMARY KEY (ID),
)

CREATE TABLE Estacionamientos_Bicicletas (
IDBicicleta SMALLINT NOT NULL,
IDEstacionamiento SMALLINT NOT NULL,
NombreZona VARCHAR (40) NOT NULL,

--PK, FK, UQ
CONSTRAINT PK_Bicicletas_Estacionamiento PRIMARY KEY (IDEstacionamiento, IDBicicleta, NombreZona),
CONSTRAINT FK_BicicletasEstacionamientos_Estacionamientos FOREIGN KEY (NombreZona, IDEstacionamiento) REFERENCES Estacionamientos(NombreZona, ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_BicicletasEstacionamientos_Bicicletas FOREIGN KEY (IDBicicleta) REFERENCES Bicicletas(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE Averias (
ID SMALLINT NOT NULL,
Incidencia VARCHAR (45) NOT NULL,
Descripcion VARCHAR (200) NULL,

--PK, FK, UQ
CONSTRAINT PK_Averias PRIMARY KEY (ID),
)

CREATE TABLE Reportes (
IDAverias SMALLINT NOT NULL,
IDClientes SMALLINT NOT NULL,

--PK, FK, UQ
CONSTRAINT PK_Reportes PRIMARY KEY (IDAverias, IDClientes),
CONSTRAINT FK_Reportes_Averias FOREIGN KEY (IDAverias) REFERENCES Averias(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_Reportes_Clientes FOREIGN KEY (IDClientes) REFERENCES Clientes(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE Tecnicos (
ID SMALLINT NOT NULL,
Nombre VARCHAR (40) NOT NULL,
Apellidos VARCHAR (80) NOT NULL,

--PK, FK, UQ
CONSTRAINT PK_Tecnicos PRIMARY KEY (ID),
)

CREATE TABLE Averias_Tecnicos (
IDAveria SMALLINT NOT NULL,
IDTecnico SMALLINT NOT NULL,

--PK, FK, UQ
CONSTRAINT PK_AveriasTecnicos PRIMARY KEY (IDAveria, IDTecnico),
CONSTRAINT FK_AveriasTecnicos_Averias FOREIGN KEY (IDAveria) REFERENCES Averias(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_AveriasTecnicos_Tecnico FOREIGN KEY (IDTecnico) REFERENCES Tecnicos(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)