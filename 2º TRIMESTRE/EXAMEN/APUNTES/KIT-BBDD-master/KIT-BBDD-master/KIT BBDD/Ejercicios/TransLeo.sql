--use master 
--go
--drop database TransLeo

create database TransLeo
go
use TransLeo
go

--es una generalizacion y he decidido hacer una sola tabla
create table ClientesRemitentesDestinatarios
(
	Codigo tinyint not null,
	Nombre varchar (20) not null,
	Apellidos varchar (40) not null,
	Tipo varchar (12) not null,
	Direccion varchar (80) not null,
	Ciudad  varchar (20) not null,
	CodigoPostal tinyint not null,
	Provincias varchar (20) not null,
	Telefono char (9) not null,
	TelefonoAlternativo char (9) null,
	NombreUsuario varchar (15) not null, 
	Contraseña varchar (10) not null,

	------------------------------------------------------
	constraint PK_ClientesRemitentesDestinatarios primary key (Codigo),
)
go

create table Paquetes
(
	Codigo int not null,
	Alto tinyint not null,
	Ancho tinyint not null,
	Largo tinyint not null,
	Peso tinyint not null,
	CodigoClientes tinyint not null,
	NumReferencia int identity not null,

	---------------------------------------------------------
	constraint PK_Paquetes primary key (Codigo),

	------------------------------------------------------
	constraint FK_Clientes_Remitentes foreign key (CodigoClientes) references ClientesRemitentesDestinatarios (Codigo) on update cascade on delete cascade,
	constraint FK_Clientes_Destinatarios foreign key (CodigoClientes) references ClientesRemitentesDestinatarios (Codigo) on update no action on delete no action
)
go

create table Centros
(
	Codigo tinyint not null unique,
	Denominacion varchar (40) not null,
	Direccion varchar (80) not null,
	Ciudad varchar (20) not null,
	CodigoPostal tinyint not null,
	Provincia varchar (20) not null,
	Telefono char (9) not null,
	TelefonoAlternativo char (9) null,
	Distancia tinyint not null,
	CodigoPaquetse int not null,
	FechaRecogida date not null,
	---------------------------------------------------------
	constraint PK_Centros primary key (Codigo),

	---------------------------------------------------------
	constraint FK_Centro_dista_Centro foreign key (Codigo) references Centros (Codigo) on update no action on delete no action,
	constraint FK_Centro_Paquetse foreign key (CodigoPaquetse) references Paquetes (Codigo) on update no action on delete no action
)
go


create table Vehiculos
(
	Matricula char (7) not null,
	Tipo char (1) not null,
	FechaAdquisicion date not null,
	FechaMatriculacion date not  null,
	TipoCarnet char (3) not null,
	Capacidad tinyint not null,
	PesoMaximoTransportable smallint not null,

	---------------------------------------------------------
	constraint PK_Vehiculos primary key (Matricula)
)
go

create table CentroCentroPaqueteVehiculos
(
	CodigoCentros tinyint not null,
	CodigoTrasladaCentros tinyint not null,
	CodigoPaquetes int not null,
	MatriculaVehiculos char (7) not null,
	FechaTraslado date not null,
	FechaEntrega date not null,
	---------------------------------------------------------
	constraint PK_CentroCentroPaqueteVehiculos primary key (CodigoPaquetes),

	----------------------------------------------------------
	constraint FK_Centro_Centro_Paquete_Vehiculos foreign key (CodigoCentros) references Centros (Codigo) on update cascade on delete cascade,
	constraint FK_Centro_CentroT_Paquete_Vehiculos foreign key (CodigoTrasladaCentros) references Centros (Codigo) on update no action,
	constraint FK_Paquete_Centro_CentroT_Vehiculos foreign key (CodigoPaquetes) references Paquetes (Codigo) on update cascade on delete cascade,
	constraint FK_Vehiculos_Paquete_Centro_CentroT foreign key (MatriculaVehiculos) references Vehiculos (Matricula) on update cascade on delete cascade
)
go