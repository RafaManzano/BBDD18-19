
--drop database Nervionia

create database Nervionia
go
use Nervionia
go

create table Especie
(
	Nombre_Comun varchar(10) not null,
	Nombre_Cientifico varchar(10) not null,
	Alimentacion varchar(10) not null,
	Vuelo char(2) not null,
	constraint PK_Especie primary key (Nombre_Comun),
)

go

create table Ser
(
	Nombre varchar(10) not null,
	Nombre_Comun_Esp varchar(10) not null,
	Nombre_Tribu varchar(10) not null,
	constraint PK_Ser primary key (Nombre),
	constraint FK_Ser_Especie foreign key (Nombre_Comun_Esp) references Especie(Nombre_Comun) ON DELETE NO ACTION ON UPDATE CASCADE,
	constraint FK_Ser_Tribu foreign key (Nombre_Tribu) references Tribu(Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,
)

go

--drop table Tribu

create table Tribu
(
	Nombre varchar(10) not null,
	Lema varchar(30) not null,
	NombrePoblado varchar(10) not null,
	constraint PK_Tribu primary key(Nombre),
)

go

create table Religion
(
	Nombre varchar(10) not null,
	Tipo varchar(15) not null,
	constraint PK_Religion primary key(Nombre),
)

go

--drop table Poblado

create table Poblado
(
	Nombre varchar(10) not null,
	Numero_Habitantes int not null,
	Numero_Fortificaciones tinyint not null,
	Coordenadas tinyint not null,
	NombreTribu varchar(10) not null,
	constraint PK_Poblado primary key(Nombre),
	constraint Tribu_Poblado foreign key (NombreTribu) references Tribu (Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,-----
	--constraint Tribu_Poblado foreign key (Nombre) references Poblado (Nombre) ON DELETE NO ACTION,----REFLEXIVA
)

go

--drop table Tribu_Religion

go


create table Bando
(
	Nombre varchar(10) not null,
	NombreTribu varchar(10) not null,
	--NombreBatalla varchar(10) not null,
	constraint PK_Bando primary key(Nombre),
	constraint Tribu_Bando foreign key (NombreTribu) references Tribu (Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,
	--constraint FK_Batalla_Bando foreign key (NombreBatalla) references Batalla (Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,
)

go

--drop table Batalla

create table Batalla
(
	Nombre varchar(10) not null,
	Fecha date not null,
	NombrePoblado varchar(10) not null,
	--NombreBando varchar(10) not null,
	constraint PK_Batalla primary key(Nombre),
	constraint FK_Batalla_Poblado foreign key (NombrePoblado) references Poblado (Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,--error
	--constraint FK_Batalla_Bando foreign key (NombreBando) references Bando (Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,-----
)

go

create table Guerra
(
	Nombre varchar(10) not null,
	FechaInicio date not null,
	FechaFin date not null,
	NombreBatalla varchar(10) not null,
	constraint PK_Guerra primary key (Nombre),
	constraint FK_Batalla_Guerra foreign key (NombreBatalla) references Batalla (Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,
)

go

--drop table Esclavo

create table Esclavo
(
	Nombre varchar(10) not null,
	Fecha date not null,
	NombreSerLibre varchar(10) not null,
	Nombre_Ser varchar(10) not null,
	constraint PK_Esclavo primary key (Nombre),
	constraint FK_Ser_Libre_Esclavo foreign key (NombreSerLibre) references Ser_Libre (Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,
	constraint FK_Esclavo_Ser foreign key (Nombre_Ser) references Ser (Nombre) ON DELETE NO ACTION,
)

go

create table Tribu_Religion
(
	NombreTribu varchar(10) not null,
	NombreReligion varchar(10) not null,
	Religion_Prohibida varchar(10) not null,
	Religion_Oficial varchar(10) not null,
	constraint PK_Tribu_Religion primary key(NombreTribu,NombreReligion),
	constraint FK_Tribu_Religion foreign key (NombreTribu) references Tribu (Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,
	constraint FK_Religion_Tribu foreign key (NombreReligion) references Religion (Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,
)

go


create table Batalla_Bando
(
	NombreBando varchar(10) not null,
	NombreBatalla varchar(10) not null,
	constraint PK_Batalla_bando primary key(NombreBando,NombreBatalla),
	constraint FK_Batalla_Bando foreign key (NombreBando) references Bando (Nombre) ON DELETE NO ACTION,
	constraint FK_Bando_Batalla foreign key (NombreBatalla) references Batalla (Nombre) ON DELETE NO ACTION,
)

go

create table Tribu_Batalla
(
	NombreTribu varchar(10) not null,
	NombreBatalla varchar(10) not null,
	Bajas tinyint not null,
	constraint PK_Tribu_Batalla primary key(NombreTribu,NombreBatalla),
	constraint FK_Tribu_Batalla foreign key (NombreTribu) references Tribu (Nombre) ON DELETE NO ACTION,
	constraint FK_Batalla_Tribu foreign key (NombreBatalla) references Batalla (Nombre) ON DELETE NO ACTION,
)

go

--drop table Ser_Libre

create table Ser_Libre
(
	Nombre varchar(10) not null,
	Nombre_Ser varchar(10) not null,
	constraint PK_Ser_Libre primary key (Nombre),
	constraint FK_Ser_Libre_Ser foreign key (Nombre_Ser) references Ser (Nombre) ON DELETE NO ACTION ON UPDATE CASCADE,
)

go

