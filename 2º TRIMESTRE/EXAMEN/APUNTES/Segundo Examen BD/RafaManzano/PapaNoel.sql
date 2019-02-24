CREATE DATABASE PapaNoel
GO
USE PapaNoel
GO

--DROP DATABASE PapaNoel

CREATE TABLE Persona (
DNI INT NOT NULL,
FechaNac DATE NULL,
Nombre VARCHAR (20) NOT NULL,
Telefono CHAR (9) NULL,
CONSTRAINT PK_DNI_Persona PRIMARY KEY (DNI),
)

CREATE TABLE Ruta (
Zona VARCHAR (30) NOT NULL,
ID SMALLINT NOT NULL,
CONSTRAINT PK_ID_Ruta PRIMARY KEY (ID),
)

CREATE TABLE Peticion (
ID SMALLINT NOT NULL,
DNI_Persona INT NOT NULL,
ID_Ruta SMALLINT NOT NULL,
EsAceptada BIT NOT NULL,
CONSTRAINT PK_ID_Peticion PRIMARY KEY (ID),
)

CREATE TABLE Pedido (
ID SMALLINT NOT NULL,
Fecha DATE NOT NULL,
ID_Tienda SMALLINT NOT NULL,
CONSTRAINT PK_ID_Pedido PRIMARY KEY (ID),
)

CREATE TABLE Tienda (
ID SMALLINT NOT NULL,
Denominacion VARCHAR (50) NOT NULL,
Direccion VARCHAR (50) NOT NULL,
Telefono CHAR (9) NULL,
CONSTRAINT PK_ID_Tienda PRIMARY KEY (ID),
)

CREATE TABLE Producto_Sust_Producto (
ID_Producto1 SMALLINT NOT NULL, 
ID_Producto2 SMALLINT NOT NULL,
CONSTRAINT PK_AmbosProducto_PSP PRIMARY KEY (ID_Producto1, ID_Producto2),
)

CREATE TABLE Accion (
Descripcion VARCHAR (70) NOT NULL,
FechaHora DATETIME NULL,
Lugar VARCHAR (50) NOT NULL,
Codigo SMALLINT NOT NULL,
CONSTRAINT PK_Codigo_Accion PRIMARY KEY (Codigo),
)

CREATE TABLE Buena (
Periodico VARCHAR (30) NOT NULL,
Recompensa SMALLMONEY NULL,
Codigo_Accion SMALLINT NOT NULL,
CONSTRAINT PK_CodigoAccion_Buena PRIMARY KEY (Codigo_Accion)
)

CREATE TABLE Mala (
Coste SMALLMONEY NULL,
Delito VARCHAR (50) NOT NULL,
Codigo_Accion SMALLINT NOT NULL,
CONSTRAINT PK_CodigoAccion_Mala PRIMARY KEY (Codigo_Accion)
)

CREATE TABLE Regalo (
ID SMALLINT NOT NULL,
CONSTRAINT PK_ID_Regalo PRIMARY KEY (ID),
)

CREATE TABLE Categoria (
ID_Regalo SMALLINT NOT NULL,
CONSTRAINT PK_IDRegalo_Categoria PRIMARY KEY (ID_Regalo),
)

CREATE TABLE Producto (
ID_Regalo SMALLINT NOT NULL,
CONSTRAINT PK_IDRegalo_Producto PRIMARY KEY (ID_Regalo),
)

CREATE TABLE PersonaInformaPersona (
DNI_Informante INT NOT NULL,
DNI_Sujeto INT NOT NULL,
CONSTRAINT PK_InformanteSujeto_PersonaInformaPersona PRIMARY KEY (DNI_Informante, DNI_Sujeto)
)

CREATE TABLE Persona_Accion (
DNI_Persona INT NOT NULL,
Codigo_Accion SMALLINT NOT NULL,
Mala VARCHAR (30) NULL,
CONSTRAINT PK_DNIPersona_CodigoAccion_Persona_Accion PRIMARY KEY (DNI_Persona, Codigo_Accion)
)

CREATE TABLE Persona_Mala (
DNI_Persona INT NOT NULL,
Codigo_Accion_Mala SMALLINT NOT NULL,
CONSTRAINT PK_DNIPersona_CodigoAccionMala_Persona_Accion PRIMARY KEY (DNI_Persona, Codigo_Accion_Mala),
)

CREATE TABLE Peticion_Regalo (
ID_Peticion SMALLINT NOT NULL,
ID_Regalo SMALLINT NOT NULL,
CONSTRAINT PK_IDPeticion_IDRegalo_PeticionRegalo PRIMARY KEY (ID_Regalo, ID_Peticion),
)

CREATE TABLE Producto_Pedido (
ID_Regalo_Producto SMALLINT NOT NULL,
ID_Pedido SMALLINT NOT NULL,
CONSTRAINT PK_IDRegaloProducto_IDPedido_ProdcutoPedido PRIMARY KEY (ID_Regalo_Producto, ID_Pedido),
)

CREATE TABLE Producto_Tienda (
ID_Regalo_Producto SMALLINT NOT NULL,
ID_Tienda SMALLINT NOT NULL,
CONSTRAINT PK_IDRegaloproducto_IDTienda PRIMARY KEY (ID_Regalo_Producto, ID_Tienda)
)

CREATE TABLE Producto_Categoria (
IDRegalo_Producto SMALLINT NOT NULL,
IDRegalo_Categoria SMALLINT NOT NULL,
CONSTRAINT PK_IDRegaloProducto_IDRegaloCategoria PRIMARY KEY (IDRegalo_Producto, IDRegalo_Categoria)
)


--Añadiremos todos las foreign key con los alter tables
ALTER TABLE Peticion ADD CONSTRAINT FK_DNIPersona_Peticion FOREIGN KEY (DNI_Persona) REFERENCES Persona (DNI)
ALTER TABLE Peticion ADD CONSTRAINT FK_IDRuta_Peticion 	FOREIGN KEY (ID_Ruta) REFERENCES Ruta (ID)
ALTER TABLE Pedido ADD CONSTRAINT FK_IDTienda_Pedido FOREIGN KEY (ID_Tienda) REFERENCES Tienda (ID)
ALTER TABLE Producto_Sust_Producto ADD CONSTRAINT FK_IDProducto1_PSP FOREIGN KEY (ID_Producto1) REFERENCES Producto (ID_Regalo)
ALTER TABLE Producto_Sust_Producto ADD CONSTRAINT FK_IDProducto2_PSP FOREIGN KEY (ID_Producto2) REFERENCES Producto (ID_Regalo)
ALTER TABLE Buena ADD CONSTRAINT FK_CodigoAccion_Buena FOREIGN KEY (Codigo_Accion) REFERENCES Accion (Codigo)
ALTER TABLE Mala ADD CONSTRAINT FK_CodigoAccion_Mala FOREIGN KEY (Codigo_Accion) REFERENCES Accion (Codigo)
ALTER TABLE Categoria ADD CONSTRAINT FK_IDRegalo_Categoria FOREIGN KEY (ID_Regalo) REFERENCES Regalo (ID)
ALTER TABLE Producto ADD CONSTRAINT FK_IDRegalo_Producto FOREIGN KEY (ID_Regalo) REFERENCES Regalo (ID)
ALTER TABLE PersonaInformaPersona ADD CONSTRAINT FK_DNIInformante_PIP FOREIGN KEY (DNI_Informante) REFERENCES Persona (DNI)
ALTER TABLE PersonaInformaPersona ADD CONSTRAINT FK_DNISujeto_PIP FOREIGN KEY (DNI_Sujeto) REFERENCES Persona (DNI)
ALTER TABLE Persona_Accion ADD CONSTRAINT FK_DNIPersona_PersonaAccion FOREIGN KEY (DNI_Persona) REFERENCES Persona (DNI)
ALTER TABLE Persona_Accion ADD CONSTRAINT FK_CodigoAccion_PersonaAccion FOREIGN KEY (Codigo_Accion) REFERENCES Accion (Codigo)
ALTER TABLE Persona_Mala ADD CONSTRAINT FK_DNIPersona_PersonaMala FOREIGN KEY (DNI_Persona) REFERENCES Persona (DNI)
ALTER TABLE Persona_Mala ADD CONSTRAINT FK_CodigoAccionMala_PersonaMala FOREIGN KEY (Codigo_Accion_Mala) REFERENCES Mala (Codigo_Accion)
ALTER TABLE Peticion_Regalo ADD CONSTRAINT FK_IDPeticion_PeticionRegalo FOREIGN KEY (ID_Peticion) REFERENCES Peticion (ID)
ALTER TABLE Peticion_Regalo ADD CONSTRAINT FK_IDRegalo_PeticionRegalo FOREIGN KEY (ID_Regalo) REFERENCES Regalo (ID)
ALTER TABLE Producto_Pedido ADD CONSTRAINT FK_IDRegaloProducto_ProductoPedido FOREIGN KEY (ID_Regalo_Producto) REFERENCES Producto (ID_Regalo)
ALTER TABLE Producto_Pedido ADD CONSTRAINT FK_IDPedido_ProductoPedido FOREIGN KEY (ID_Pedido) REFERENCES Pedido (ID)
ALTER TABLE Producto_Tienda ADD CONSTRAINT FK_IDRegaloProducto_ProductoTienda FOREIGN KEY (ID_Regalo_Producto) REFERENCES Producto (ID_Regalo)
ALTER TABLE Producto_Tienda ADD CONSTRAINT FK_IDTienda_ProductoTienda FOREIGN KEY (ID_Tienda) REFERENCES Tienda (ID)
ALTER TABLE Producto_Categoria ADD CONSTRAINT FK_IDRegaloProducto_ProductoCategoria FOREIGN KEY (IDRegalo_Producto) REFERENCES Producto (ID_Regalo)
ALTER TABLE Producto_Categoria ADD CONSTRAINT FK_IDRegaloCategoria_ProductoCategoria FOREIGN KEY (IDRegalo_Categoria) REFERENCES Categoria (ID_Regalo)



