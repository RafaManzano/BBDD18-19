--drop database Concierto

create database Concierto
go
use Concierto
go

create table Espectaculo
(
	Nombre varchar(30) not null,
	FechaIni date not null,
	FechaFin date not null,
	Codigo varchar(30) not null,
	constraint PK_Espectaculo primary key (Nombre),
	--constraint EspectaculoRecinto foreign key (Codigo) references Espectaculo (Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,
)
go

create table Grupo
(
	Nombre varchar (30) not null,
	Numero_Componentes tinyint not null,
	Cache varchar(5) not null,
	Estilo varchar (10) not null,
	Telefono varchar (30) not null,
	constraint PK_Grupo primary key (Nombre),
)
go

create table Escenario
(
	ID tinyint not null,
	Superficie tinyint not null,
	Potencia_de_sonido tinyint not null,
	Potencia_de_Luz tinyint not null,
	constraint PK_Escenario primary key (ID),
)
go


create table Representante
(
	Nombre varchar(20) not null,
	Telefono varchar (30) not null,
	constraint PK_Representante primary key(telefono),
	constraint Representante_Grupo foreign key (Telefono) references Grupo (Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,
)

create table Recinto
(
	Codigo varchar(30) not null,
	Direccion varchar(30) not null,
	Localidad varchar(30) not null,
	Provincia varchar(30) not null,
	Aforo_Maximo tinyint not null,
	NombreLocalidad varchar(30) not null,
	--Nombre_Esp varchar(30) not null,
	constraint PK_Resinto primary key (Codigo),
	constraint EspectaculoRecinto foreign key (Codigo) references Espectaculo (Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,
)
go

create table Localidad
(
	NombreLocalidad varchar(30) not null,
	Alcalde varchar(30) not null,
	Provincia varchar(30) not null,
	Telefono_Ayunt varchar(9) not null,
	constraint PK_Localidad primary key (NombreLocalidad),
	constraint Localidad_Recinto foreign key (NombreLocalidad) references Recinto (Codigo) ON DELETE NO ACTION ON UPDATE CASCADE,
)
go

create table EspectaculoGrupo
(
	Nombre_Esp varchar(30) not null,
	Nombre_Grupo varchar(30) not null,
	constraint PK_Espectaculo_Grupo primary key (Nombre_Esp,Nombre_Grupo),
	constraint Espectaculo_Grupo foreign key (Nombre_Esp) references Espectaculo (Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,
	constraint Grupo_Espectaculo foreign key (Nombre_Grupo) references Grupo (Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,
)

go

create table EspectaculoEscenario
(
	Nombre_Esp varchar(30) not null,
	ID_Escenario tinyint not null,
	constraint PK_Espectaculo_Escenario primary key (Nombre_Esp,ID_Escenario),
	constraint Espectaculo_Escenario foreign key (Nombre_Esp) references Espectaculo (Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,
	constraint Escenario_Espectaculo foreign key (ID_Escenario) references Escenario (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)
go

create table GrupoEscenario
(
	Nombre_Grupo varchar(30) not null,
	ID_Escenario tinyint not null,
	constraint PK_Grupo_Escenario primary key (Nombre_Grupo,ID_Escenario),
	constraint Grupo_Escenario foreign key (Nombre_Grupo) references Grupo (Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,
	constraint Escenario_Grupo foreign key (ID_Escenario) references Escenario (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)
go