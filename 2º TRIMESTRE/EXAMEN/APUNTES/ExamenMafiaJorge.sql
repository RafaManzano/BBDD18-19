--use AirLeo 
--drop database Jorge_MafiaExamen

--create database Jorge_MafiaExamen
--go
--use Jorge_MafiaExamen
--go

create table Dones(
ID Int Not null 
	Constraint PK_ID_Dones Primary key,
Nombre VarChar (20) Not null,
Apellidos VarChar (40) Not null,
Apodo Varchar (30) Not null,
FechaNacimiento Date Not null,
Procedencia VarChar (30)
)

create table Consiglieres(
Nombre VarChar (20) Not null
	Constraint PK_Nombre_Consiglieres Primary key,
Apellidos VarChar (40) Not null,
Apodo VarChar (30) Not null,
FechaNacimiento Date Not null,
Procedencia VarChar (30),
ID_Dones Int Not null
	Constraint FK_ID_Dones_Consiglieres Foreign key
	References Dones(ID)
	ON DELETE CASCADE ON UPDATE CASCADE
)

create table Negocios(
ID Int Not null
	Constraint PK_ID_Negocios Primary key,
Denominacion VarChar (20),
LegalSN Bit Not null
)

create table Territorios(
ID Int Not Null
	Constraint PK_ID_Territorios Primary key,
Ciudad VarChar (20) Not null,
Barrio VarChar (20)
)

create table Famiglias (
Nombre Varchar (20) Not null
	Constraint PK_Nombre_Famiglia Primary key,
Procedencia VarChar (30),
)
--creamos la tabla de la relacion entre Don y Famigliat para Añadir FechaNombramiento
create table DonesFamiglias(
ID_Dones Int Not null
	Constraint FK_ID_Dones_Famiglias
	References Dones(ID)
	ON DELETE NO ACTION ON UPDATE CASCADE
	Constraint UQ_ID_Dones Unique,
Nombre_Famiglia VarChar (20) Not null
	Constraint FK_ID_Nombre_Familgias
	References Famiglias(Nombre)
	ON DELETE NO ACTION ON UPDATE CASCADE
	Constraint UQ_Nombre_Famiglia Unique,
Constraint PK_ID_Dones_Nombre_Famiglia_DonesFamiglias Primary key (ID_Dones, Nombre_Famiglia),
FechaNombramiento Date Not null
)

--Aqui creamos la tabla de la relaccion ternaria entre Negocio/Territorio/Famiglia
create table FamigliasNegociosTerritorios(
Nombre_Famiglia VarChar (20) Not null
	Constraint FK_Nombre_Famiglia_FNT Foreign key
	References Famiglias(Nombre)
	ON DELETE NO ACTION ON UPDATE CASCADE,
ID_Negocios Int Not null
	Constraint FK_ID_Negocios_FNT Foreign key
	References Negocios(ID)
	ON DELETE NO ACTION ON UPDATE CASCADE,
ID_Territorios Int Not null
	Constraint FK_ID_Territorios_FNT Foreign key
	References Territorios(ID)
	ON DELETE NO ACTION ON UPDATE CASCADE,
Constraint PK_FamigliasNegociosTerritorios Primary key (Nombre_Famiglia, ID_Negocios, ID_Territorios)
)

create table Lugartenientes(
ID Int Not null
	Constraint PK_ID_Lugartenientes Primary Key,
Nombre VarChar (20) Not null,
Apellidos VarChar (40) Not null,
Apodo Varchar (30) Not null
)

create table TecnicasPersuasion(
ID Int Not null
	Constraint PK_ID_TecnicasPersuasion Primary key,
Denominacion VarChar (20)
)

--Creamos la tabla de la generalizacion de Capo
create table CaposCaporegimesCapodecimes(
ID Int Not null
	Constraint PK_ID_CaposCaporegimesCapodecimes Primary Key,
Nombre VarChar (20) Not null,
Apellidos VarChar (40) Not null,
Apodo Varchar (30) Not null,
FechaNacimiento Date Not null,
Procedencia VarChar (30),
PorcentajeComision NVarChar(3), --El porcentaje puede varias entre tres cifras, 0 min 100 max
Sueldo SmallMoney,
FechaContratacion Date,
Nombre_Famiglia Varchar (20) Not null
	Constraint FK_Nombre_Famiglia_CCC Foreign key
	References Famiglias(Nombre)
	ON DELETE NO ACTION ON UPDATE CASCADE,
ID_Lugarteniente Int Not null
	Constraint FK_ID_Lugarteniente_CCC Foreign key
	References Lugartenientes(ID)
	ON DELETE NO ACTION ON UPDATE CASCADE
	Constraint UQ_Lugarteniente Unique
)

create table Soldatos (
ID Int Not null
	Constraint ID_Soldatos Primary key,
Nombre VarChar (20) Not null,
Apellidos VarChar (40) Not null,
Apodo Varchar (30) Not null,
FechaNacimiento Date Not null,
Procedencia VarChar (30),
TatuajePrincipal Char Not null,
ID_CapoCaporegimesCapodecimes Int Not null
	Constraint FK_ID_CCC_Soldatos Foreign key
	References CaposCaporegimesCapodecimes(ID)
	ON DELETE NO ACTION ON UPDATE CASCADE 	 
)

--creamos la tabla de la relacion entre capos y tecnicas de persuasion
create table CaposTecnicasPersuasion(
ID_Capo Int Not null
	Constraint FK_ID_Capo_CaposTecnicasPersuasion Foreign key
	References CaposCaporegimesCapodecimes(ID)
	ON DELETE NO ACTION ON UPDATE CASCADE,
ID_TecnicaPersuasion Int Not null
	Constraint FK_ID_TecnicaPersuasion_CaposTecnicasPersuasion Foreign key
	References TecnicasPersuasion(ID)
	ON DELETE NO ACTION ON UPDATE CASCADE,
Constraint PK_ID_Capo_ID_TecnicaPersuasion_CaposTecnicasPersuasion Primary key (ID_Capo, ID_TecnicaPersuasion)
)

--creamos las tablas de la generaliacion de las armas
create table ArmasArmasBlancas(
ID_Arma Int Not null
	Constraint PK_ID_ArmaBlanca Primary key,
Denominacion VarChar (20),
LegalSN Bit Not null,
LicenciaSN Bit Not null,
LongitudHoja NVarChar (10) Not null,
TipoFilo VarChar (20) Not null,
RetractilSN Char Not null
)

create table ArmasArmasFuego(
ID_Arma Int Not null
	Constraint PK_ID_ArmaFuego Primary key,
Denominacion VarChar (20),
LegalSN Bit Not null,
LicenciaSN Bit Not null,
Marca VarChar (15) Not null,
Modelo VarChar (20) Not null, 
Calibre NVarChar (3) Not null, --El numero de cifras que pueden tener los calibres
CapacidadProyectiles NVarChar (20) Not null
)

--creamos la tabla de la relacion entre Armas y Soldatos (Hago dos debido a mi generaliacion)
create table ArmasFuegoSoldatos(
ID_Arma Int Not null
	Constraint FK_ID_Arma_ArmasFuegoSoldatos Foreign key
	References ArmasArmasFuego (ID_Arma)
	ON DELETE NO ACTION ON UPDATE CASCADE,
ID_Soldato Int Not null
	Constraint FK_ID_Soldato_ArmasFuegoSoldatos Foreign key
	References Soldatos(ID)
	ON DELETE NO ACTION ON UPDATE CASCADE,
Destreza SmallInt Not null,
)

create table ArmasBlancasSoldatos(
ID_Arma Int Not null
	Constraint FK_ID_Arma_ArmasBlancasSoldatos Foreign key
	References ArmasArmasBlancas (ID_Arma)
	ON DELETE NO ACTION ON UPDATE CASCADE,
ID_Soldato Int Not null
	Constraint FK_ID_Soldato_ArmasBlancasSoldatos Foreign key
	References Soldatos(ID)
	ON DELETE NO ACTION ON UPDATE CASCADE,
Destreza SmallInt Not null,
)

--Un soldato tiene que ser mayor de 15 años y menor de 55
alter table Soldatos Add
	Constraint CK_EdadSoldato Check ((Year (Current_Timestamp - Cast(FechaNacimiento as SmallDatetime))- 1900) between 15 and 55)

--Un arma ilegal debe de tener el valor licencia a NULL
--alter table ArmaArmasFuego Add
	--Constraint CK_LicenciaNULL Check (LicenciaSN isNULL)

--No puede haber varios capos con el mismo nick
alter table CaposCaporegimesCapodecimes Add
	Constraint CK_NickDistinto Unique (Apodo)

--El tipo de filo de un arma puede ser 'recto' 'convexo' 'scandi' 'serrado' 'mixto'
alter table ArmasArmasBlancas Add
	Constraint CK_TipoFilo Check (TipoFilo in('recto','convexo','scandi','serrado','mixto'))

--Añade una columna calculada a la tabla que contenga losd atos de las armas de fuego
--La columna se llamara "pupa" y se calcula como calibre/10 por NºProyectiles
alter table ArmasArmasFuego Add
	Pupa As ((Calibre/10)*(CapacidadProyectiles))

--La columna procedencia de capos tendra como valor por defecto sicilia
alter table CaposCaporegimesCapodecimes Add
	Constraint CK_SiciliaDefault DEFAULT 'Sicilia' FOR Procedencia

--crear tabla delitos
create table Delitos(
ID Int Not null
	Constraint ID_Delitos Primary key,
Denominacion VarChar (20),
ArticuloCP float Not null,
CondenaMin Date,
CondenaMax Date
)

--alter table Delitos Add
	--Constraint CK_TiempoCondena Check (Cast (CondenaMax as SmallINt) Between Cast (CondenaMin as SmallINt) and 360)


--Añado valores a la base de datos
/*
create table Famiglias (
Nombre Varchar (20) Not null
	Constraint PK_Nombre_Famiglia Primary key,
Procedencia VarChar (30),
)

*/
insert into Famiglias (Nombre,Procedencia)
values ('PizzaMargarita','Marsella')

insert into Famiglias (Nombre, Procedencia)
values ('LosRaviolis','Florencia')

select *
from Famiglias
	







