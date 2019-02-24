CREATE DATABASE TransporteLeoDAM
GO
USE TransporteLeoDAM
GO

CREATE TABLE Cliente (
Nombre VARCHAR (30) NOT NULL,
Apellidos VARCHAR (40) NOT NULL,
Codigo INT NOT NULL,
Direccion VARCHAR (80) NOT NULL,
Ciudad VARCHAR (20) NULL,
CodigoPostal INT NOT NULL,
Provincia VARCHAR (20) NOT NULL,
Telefono CHAR (9) NULL,
TelefonoAlternativo CHAR (9) NULL,
Usuario VARCHAR (15) NOT NULL,
Contraseña VARCHAR (10) NOT NULL,
CONSTRAINT PK_Codigo_Cliente PRIMARY KEY (Codigo),
)

CREATE TABLE Remitente (
Codigo_Cliente INT NOT NULL,
CONSTRAINT PK_CodigoCliente_Remitente PRIMARY KEY (Codigo_Cliente),
)

CREATE TABLE Destinatario (
Codigo_Cliente INT NOT NULL,
CONSTRAINT PK_CodigoCliente_Remitente PRIMARY KEY (Codigo_Cliente),

CREATE TABLE Paquete (
Codigo BIGINT NOT NULL,
Alto INT NULL,
Ancho INT NULL,
Cargo INT NULL,
Peso INT NOT NULL,
Matricula_Vehiculo BIGINT NOT NULL,
Codigo_Centro INT NOT NULL,
CodigoCliente_Destinatario INT NOT NULL,
CodigoCliente_Remitente INT NOT NULL,
FechaTranslado DATE NOT NULL,
FechaTransporte DATE NOT NULL,
FechaReccogida DATE NOT NULL,
CONSTRAINT PK_Codigo_Paquete PRIMARY KEY (Codigo),
)

CREATE TABLE Centro (
Codigo INT NOT NULL,
Denominacion VARCHAR (40) NULL,
Direccion VARCHAR (80) NOT NULL,
Ciudad VARCHAR (20) NOT NULL,
CodigoPostal INT NOT NULL,
Provincia VARCHAR (20) NOT NULL,
Telefono CHAR (9) NULL,
TelefonoAlternativo CHAR (9) NULL,
CONSTRAINT PK_Codigo_Centro PRIMARY KEY (Codigo),
)

CREATE TABLE Vehiculo (
Matricula CHAR (7) NOT NULL,
Tipo CHAR (1) NOT NULL,
FechaAdq CHAR (3) NULL,
FechaMatri CHAR (3) NOT NULL,
TipoCarnet CHAR (3) NULL,
Capacidad INT NULL,
Peso INT NULL,
CONSTRAINT PK_Matricula_Vehiculo PRIMARY KEY (Matricula),
)


CREATE TABLE Traslado (
Codigo_Paquete BIGINT NOT NULL,
Codigo_Centro_1 INT NOT NULL,
Codigo_Centro_2 INT NOT NULL,
Matricula_Vehiculo BIGINT NOT NULL,
CONSTRAINT PK_CodigoPaquete_Traslado PRIMARY KEY (Codigo_Paquete),
)

--Con esto introducimos las foreign key
ALTER TABLE Paquete ADD CONSTRAINT FK_MatriculaVehiculo_Paquete FOREIGN KEY (Matricula_Vehiculo) REFERENCES Vehiculo(Matricula)
ALTER TABLE Paquete ADD CONSTRAINT FK_CodigoCentro_Paquete FOREIGN KEY (Codigo_Centro) REFERENCES Centro(Codigo)
ALTER TABLE Paquete ADD CONSTRAINT FK_CodigoClienteRemitente_Paquete FOREIGN KEY (CodigoCliente_Remitente) REFERENCES Remitente(Codigo_Cliente)
ALTER TABLE Paquete ADD CONSTRAINT FK_CodigoClienteDestinatario_Paquete FOREIGN KEY (CodigoCliente_Destinatario) REFERENCES Destinatario(Codigo_Cliente)
ALTER TABLE Remitente ADD CONSTRAINT FK_CodigoCliente_Remitente FOREIGN KEY (Codigo_Cliente) REFERENCES Cliente(Codigo)
ALTER TABLE Destinatario ADD CONSTRAINT FK_CodigoCliente_Destinatario FOREIGN KEY (Codigo_Cliente) REFERENCES Cliente(Codigo)
ALTER TABLE Traslado ADD CONSTRAINT FK_CodigoPaquete_Translado FOREIGN KEY (Codigo_Paquete) REFERENCES Paquete(Codigo)

