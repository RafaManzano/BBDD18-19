--use master 
--go
--drop database Acuaristas

--Ejercicio 1
--Obtén el modelo relacional (tablas) en 3FN correspondiente al diagrama y las
--especificaciones anteriores. Asigna identificadores sólo a aquellas tablas que no tengan una
--columna que sirva para identificarlas apropiadamente.

--Ejercicio 2
--Escribe el código SQL necesario para implementar el modelo anterior.

create database Acuaristas
go
use Acuaristas
go

create table Tierras
(
	Nombre char (15) not null,
	arcillas float not null,
	silicatos float not null,
	nitratos float not null,
	sustratos float not null,
	otros float not null,

	------------------------------
	constraint PK_Tierras primary key (Nombre)
)
go

create table SeresVivos
(
	ID smallint not null,
	Especie varchar (20) not null,
	TemperaturaMaxima tinyint not null,
	TemperaturaMinima tinyint not null,

	------------------------------
	constraint PK_SeresVivos primary key (ID)
)
go

--fundo las tablas Acuario y socio porque la relacion es 1:1 y las cardinalidades minimas son 1
create table Acuarios
(
	ID smallint not null,
	CapacidaadLitro decimal (5,1) not null,
	Alto decimal (5,1) not null,
	Ancho decimal (5,1) not null,
	Largo decimal (5,1) not null,
	Temperatura smallint not null,
	NumeroSocio smallint not null,
	NombreSocio varchar (15) not null,
	Apellidos varchar (20) not null,
	Direccion varchar (40) not null,
	Email varchar (30) null,
	Telefono char (9) not null,

	------------------------------
	constraint PK_Acuarios primary key (ID)
)
go

create table SeresVivosAcuarios
(
	IDSeresVivos smallint not null,
	IDAcuarios smallint not null,
	Cantidad smallint not null,

	------------------------------
	constraint PK_SeresVivosAcuarios primary key (IDSeresVivos,IDAcuarios)
)
go

create table Bombas
(
	Marca char (15) not null,
	Modelo char (15) not null,
	IDAcuario smallint not null,

	------------------------------
	constraint PK_Bombas primary key (Marca,Modelo)
)
go

--incumplia la 2FN por eso he creado una nueva tabla
create table Caracteristicas
(
	ID smallint not null,
	Caudal smallint not null,
	Consumo smallint not null,

	------------------------------
	constraint PK_Caracteristicas primary key (ID)
)
go

create table CaracteristicasBombas
(
	IDCaracteristicas smallint not null,
	MarcaBombas char (15) not null,
	ModeloBombas char (15) not null,

	------------------------------
	constraint PK_CaracteristicasBombas primary key (IDCaracteristicas,MarcaBombas,ModeloBombas)
)
go

create table Peces
(
	IDSerVivo smallint not null,
	NombreComun varchar (15) not null,
	Tipo char (1) not null,
	TamañoMedio tinyint not null,
	IDAlimento smallint not null,--1:N propagacion

	------------------------------
	constraint PK_Peces primary key (IDSerVivo)
)
go
--incumple la 1FN, porque es un atributo multievaluado, por eso hago una nueva tabla
create table Colores
(
	ID tinyint not null,
	Color varchar (15) not null,
	NombreComunPeces char (15) not null,

	------------------------------
	constraint PK_Colores primary key (ID)
)
go

-------N:M
create table PecesColores
(
	IDSerVivoPeces smallint not null,
	IDColores tinyint not null,

	------------------------------
	constraint PK_PecesColores primary key (IDSerVivoPeces,IDColores)
)
go

create table PezIncompatibleConPez
(
	IDSerVivoPecesIncompatible smallint not null,
	IDSerVivoPeces smallint not null,

	------------------------------
	constraint PK_PezIncompatibleConPez primary key (IDSerVivoPecesIncompatible,IDSerVivoPeces)
)
go

create table Plantas
(
	IDSerVivo smallint not null,
	NombreComun varchar (15) not null,
	TamañoMaximo tinyint not null,
	NecesidadLuz Tinyint not null,

	------------------------------
	constraint PK_Plantas primary key (IDSerVivo)
)
go

create table Alimentos 
(
	ID smallint not null,
	Nombre varchar (15) not null,
	Tipo varchar (20) not null,
	ValorEnergetico smallint not null,

	------------------------------
	constraint PK_Alimentos primary key (ID)
)
go


create table PlantaTierra 
(
	IDSerVivoPlanta smallint not null,
	NombreTierra char (15) not null,

	------------------------------
	constraint PK_PlantaTierra primary key (IDSerVivoPlanta,NombreTierra)
)
go



----------------------CLAVES AJENAS---------------------------------

alter table SeresVivosAcuarios add constraint FK_SeresVivos_Acuarios foreign key (IDSeresVivos) references SeresVivos (ID) on delete cascade on update cascade
go
alter table SeresVivosAcuarios add constraint FK_Acuarios_SeresVivos foreign key (IDAcuarios) references Acuarios (ID) on delete cascade on update cascade
go


alter table Bombas add constraint FK_Bombas_Acuarios foreign key (IDAcuario) references Acuarios (ID) on delete cascade on update cascade
go


alter table CaracteristicasBombas add constraint FK_Caracteristicas foreign key (IDCaracteristicas) references Caracteristicas (ID) on delete cascade on update cascade
go
alter table CaracteristicasBombas add constraint FK_Bombas foreign key (MarcaBombas,ModeloBombas) references Bombas (Marca,Modelo) on delete cascade on update cascade
go


alter table PecesColores add constraint FK_Peces_Colores foreign key (IDSerVivoPeces) references Peces (IDSerVivo) on delete cascade on update cascade
go
alter table PecesColores add constraint FK_Colores_Peces foreign key (IDColores) references Colores (ID) on delete cascade on update cascade
go


alter table PezIncompatibleConPez add constraint FK_PezIncompatibleConPez foreign key (IDSerVivoPecesIncompatible) references Peces (IDSerVivo) on delete cascade on update cascade
go
alter table PezIncompatibleConPez add constraint FK_PezIncompatible_ConPez foreign key (IDSerVivoPeces) references Peces (IDSerVivo) on delete no action on update no action
go


alter table Plantas add constraint FK_Plantas_SerVivo foreign key (IDSerVivo) references SeresVivos (ID) on delete cascade on update cascade
go


alter table Peces add constraint FK_Peces_SerVivo foreign key (IDSerVivo) references SeresVivos (ID) on delete cascade on update cascade
go
alter table Peces add constraint FK_Peces_Alimentos foreign key (IDAlimento) references Alimentos (ID) on delete cascade on update cascade
go


alter table PlantaTierra add constraint FK_Planta_Tierra foreign key (IDSerVivoPlanta) references Plantas (IDSerVivo) on delete cascade on update cascade
go
alter table PlantaTierra add constraint FK_Tierra_Planta foreign key (NombreTierra) references Tierras (Nombre) on delete cascade on update cascade
go


--Ejercicio 3
--Una vez creadas las tablas, incluye las siguientes restricciones
-- Las dimensiones del acuario no pueden ser negativas.

alter table Acuarios add constraint CK_Alto check (Alto>0)
go
alter table Acuarios add constraint CK_Ancho check (Ancho>0)
go
alter table Acuarios add constraint CK_Largo check (Largo>0)
go

-- La temperatura del acuario debe estar entre 10 y 30º.
alter table Acuarios add constraint CK_Temperatura check (Temperatura between 10 and 30)
go
-- El atributo “tipo” de los peces puede tomar uno de los siguientes valores: T, R, P, S, A o L.
alter table Peces add constraint CK_Tipo check (Tipo in('T','R','P','S','A','L'))
go
-- La necesidad de luz de las plantas mide el número de horas que necesitan luz directa y es un valor entre 4 y 10.
alter table Plantas add constraint CK_NecesidadLuz check (NecesidadLuz between 4 and 10)
go
--Una especie no puede ser incompatible con ella misma.
alter table PezIncompatibleConPez add constraint CK_IDSerVivoPecesIncompatible check (IDSerVivoPecesIncompatible <> IDSerVivoPeces)
go
-- Los porcentajes de arcillas, silicatos, nitratos, sustratos y otros sumados deben ser igual a 100.
alter table Tierras add constraint CK_CantidadMezcla check (arcillas+silicatos+nitratos+sustratos+otros=100)
go
--Dos socios no pueden tener el mismo email
alter table Acuarios add constraint UQ_Email unique (Email)
go


--Ejercicio 4
--Ante la proliferación de peces tropicales, que tienen varios colores, observamos que con el
--modelo actual no podemos recoger esta información porque incumpliríamos una de las
--formas normales.
--¿Cuál? 
		--La primera forma normal
--¿Cómo podemos solucionarlo? Escribe el código para hacer esas modificaciones.
		--creando otra tabla

--Ejercicio 5
--Deseamos saber qué tipo o tipos de tierra tiene cada acuario.
--¿Es posible con el modelo actual?
		-- A traves de SeresVivos, Plantas Se puede llegar a Tierras
--En caso de que no sea posible, ¿qué habríamos de añadir o modificar para tener esta
--información?
		--la mejor solucion es crear una relacion N:M entre TIERRAS Y ACUARIOS