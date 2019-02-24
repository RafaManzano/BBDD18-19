--use master
--go
--drop database Almacen

create database Almacen
go
use Almacen
go

create table Tipos
(
	Codigo tinyint not null,

	----------------PK-----------------
	constraint PK_Pieza primary key (Codigo)
)
go
create table Piezas
(
	ID tinyint not null,
	Modelo varchar (15) not null,
	Descripcion varchar (40) not null,
	Precio decimal (5,2) not null,
	CodigoTipo tinyint not null,

	----------------PK-----------------
	constraint PK_Piezas primary key (ID),

	----------------FK-----------------
	constraint FK_Tipo_Pieza foreign key (CodigoTipo) references Tipos(Codigo) on update cascade on delete cascade
)
go

create table Estanterias
(
	Codigo tinyint not null,

	----------------PK-----------------
	constraint PK_Estanterias primary key (Codigo)
)
go

create table Almacenes
(
	NumeroAlmacen tinyint not null,
	Direccion varchar (20) not null,
	Descripcion varchar (20) not null,
	NombreEstanteria varchar (10)not null,
	CantidadPieza tinyint not null,

	----------------PK-----------------
	constraint PK_Almacenes primary key (NumeroAlmacen)
)

create table PiezasEstanterias
(
	IDPiezas tinyint not null,
	CodigoEstanterias tinyint not null,
	CantidadPieza tinyint not null,

	----------------PK----------------
	constraint PK_Estanterias_Piezas primary key (IDPiezas,CodigoEstanterias),

	----------------FK-----------------
	constraint FK_Estanterias_Piezas foreign key (IDPiezas) references Piezas(ID) on update cascade on delete cascade,
	constraint FK_Piezas_Estanterias foreign key (CodigoEstanterias) references Estanterias(Codigo) on update cascade on delete cascade
)
go

create table PiezasPiezas
(
	IDCompone tinyint not null,
	IDCompuesta tinyint not null,

	----------------PK----------------
	constraint PK_Piezas_Piezas primary key (IDCompone,IDCompuesta),

	----------------FK-----------------
	constraint FK_Piezas_Piezas foreign key (IDCompone) references Piezas(ID) on update cascade on delete cascade,
	constraint FK_Piezas_Compone_Piezas foreign key (IDCompuesta) references Piezas(ID) on update no action
)
go

create table AlmasenesEstanterias
(
	NumeroAlmacenes tinyint not null,
	CodigoEstanterias tinyint not null,

	----------------PK----------------
	constraint PK_Almasenes_Estanterias primary key (NumeroAlmacenes,CodigoEstanterias),

	----------------FK-----------------
	constraint FK_Almasenes_Estanterias foreign key (NumeroAlmacenes) references Almacenes(NumeroAlmacen) on update cascade on delete cascade,
	constraint FK_Estanterias_Almasenes foreign key (CodigoEstanterias) references Estanterias(Codigo) on update cascade on delete cascade
)