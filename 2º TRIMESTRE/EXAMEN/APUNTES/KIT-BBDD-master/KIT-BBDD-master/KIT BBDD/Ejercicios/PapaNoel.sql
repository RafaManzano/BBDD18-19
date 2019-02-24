--use master 
--go
--drop database PapaNoel


create database PapaNoel
go
use PapaNoel
go

create table Personas
(
	DNI char(9) not null,
	Nombre varchar (15) not null,
	Telefono varchar (20) not null,
	FechaNacimiento date not null

	----------------------------------
	constraint PK_Personas primary key (DNI)
)
go

create table Rutas
(
	ID tinyint not null,
	Zona varchar (30) not null,

	----------------------------------
	constraint PK_Rutas primary key (ID)
)
go

create table Peticiones
(
	ID tinyint not null,
	EsAceptada char (2) not null,
	DNIPersonas char(9) not null,
	IDRutas tinyint not null,

	----------------------------------
	constraint PK_Peticiones primary key (ID),

	----------------------------------
	constraint FK_Peticiones_Personas foreign key (DNIPersonas) references Personas (DNI) on delete cascade on update cascade,
	constraint FK_Peticiones_Rutas foreign key (IDRutas) references Rutas (ID) on delete cascade on update cascade
)
go

create table Acciones
(
	Codigo tinyint not null,
	Lugar varchar (30) not null,
	Descripcion varchar(50) not null,
	FechaHora datetime not null,

	----------------------------------
	constraint PK_Acciones primary key (Codigo)
)
go

create table Buenas
(
	CodigoAcciones tinyint not null,
	Recompensa varchar (30) not null,
	NombrePeriodico varchar (15) not null,
	----------------------------------
	constraint PK_Buenas primary key (CodigoAcciones),

	----------------------------------
	constraint FK_Acciones_Buenas foreign key (CodigoAcciones) references Acciones (Codigo) on delete cascade on update cascade
)
go

create table Malas
(
	CodigoAcciones tinyint not null,
	Coste decimal (3,1) not null,
	Delito varchar (15) not null,
	----------------------------------
	constraint PK_Malas primary key (CodigoAcciones),

	----------------------------------
	constraint FK_Acciones_Malas foreign key (CodigoAcciones) references Acciones (Codigo) on delete cascade on update cascade
)
go

create table Tiendas
(
	ID tinyint not null,
	Denominacion varchar (10) not null,
	Direccion varchar (30) not null,
	Telefono varchar (20) not null,

	----------------------------------
	constraint PK_Tiendas primary key (ID)
)
go

create table Pedidos
(
	ID tinyint not null,
	Fecha date not null,
	IDTienda tinyint not null,
	----------------------------------
	constraint PK_Pedido primary key (ID),

	----------------------------------
	constraint FK_Pedidos_Tiendas foreign key (IDTienda) references Tiendas (ID) on delete cascade on update cascade
)
go

create table Regalos
(
	ID tinyint not null,
	----------------------------------
	constraint PK_Regalos primary key (ID)
)
go

create table Categorias
(
	IDRegalos tinyint not null,
	----------------------------------
	constraint PK_Categorias primary key (IDRegalos),

	----------------------------------
	constraint FK_Categorias_Regalos foreign key (IDRegalos) references Regalos (ID) on delete cascade on update cascade
)
go

create table Productos
(
	IDRegalos tinyint not null,

	----------------------------------
	constraint PK_Productos primary key (IDRegalos),

	----------------------------------
	constraint FK_Productos_Regalos foreign key (IDRegalos) references Regalos (ID) on delete cascade on update cascade
)
go

create table ProductosSustituyenProductos
(
	IDProducto1 tinyint not null,
	IDProducto2 tinyint not null,

	----------------------------------
	constraint PK_ProductosSustituyenProductos primary key (IDProducto1,IDProducto2),

	----------------------------------
	constraint FK_Productos_Sustituyen_Productos foreign key (IDProducto1) references Productos (IDRegalos) on delete cascade on update cascade,
	constraint FK_ProductosSustituyen_Productos foreign key (IDProducto2) references Productos (IDRegalos) on delete no action on update no action
)
go

create table PersonasInformanPersonas
(
	DNIInformante char(9) not null,
	DNISujeto char(9) not null,

	----------------------------------
	constraint PK_PersonasInformanPersonas primary key (DNIInformante,DNISujeto),

	----------------------------------
	constraint FK_Personas_Informan_Personas foreign key (DNIInformante) references Personas (DNI) on delete cascade on update cascade,
	constraint FK_PersonasInforman_Personas foreign key (DNISujeto) references Personas (DNI) on delete no action on update no action
)
go

create table PersonasAcciones
(
	DNIPersonas char(9) not null,
	CodigoAcciones tinyint not null,
	Motivo varchar (30) not null,

	----------------------------------
	constraint PK_PersonasAcciones primary key (DNIPersonas,CodigoAcciones),

	----------------------------------
	constraint FK_Personas_Acciones foreign key (DNIPersonas) references Personas (DNI) on delete cascade on update cascade,
	constraint FK_Acciones_Personas foreign key (CodigoAcciones) references Acciones (Codigo) on delete cascade on update cascade
)
go

create table PersonasMalas
(
	DNIPersonas char(9) not null,
	CodigoAccionesMalas tinyint not null,
	Motivo varchar (30) not null,

	----------------------------------
	constraint PK_PersonasMalas primary key (DNIPersonas,CodigoAccionesMalas),

	----------------------------------
	constraint FK_Personas_Malas foreign key (DNIPersonas) references Personas (DNI) on delete cascade on update cascade,
	constraint FK_Malas_Personas foreign key (CodigoAccionesMalas) references Malas (CodigoAcciones) on delete cascade on update cascade
)
go

create table PeticionesRegalos
(
	IDPeticiones tinyint not null,
	IDRegalos tinyint not null,

	----------------------------------
	constraint PK_PeticionesRegalos primary key (IDPeticiones,IDRegalos),

	----------------------------------
	constraint FK_Peticiones_Regalos foreign key (IDPeticiones) references Peticiones (ID) on delete cascade on update cascade,
	constraint FK_Regalos_Peticiones foreign key (IDRegalos) references Regalos (ID) on delete cascade on update cascade
)
go

create table ProductosPedidos
(
	IDRegalosProductos tinyint not null,
	IDPedidos tinyint not null,

	----------------------------------
	constraint PK_ProductosPedidos primary key (IDRegalosProductos,IDPedidos),

	----------------------------------
	constraint FK_Productos_Pedidos foreign key (IDRegalosProductos) references Productos (IDRegalos) on delete cascade on update cascade,
	constraint FK_Pedidos_Productos foreign key (IDPedidos) references Pedidos (ID) on delete cascade on update cascade
)
go

create table ProductosTiendas
(
	IDRegalosProductos tinyint not null,
	IDTiendas tinyint not null,

	----------------------------------
	constraint PK_ProductosTiendas primary key (IDRegalosProductos,IDTiendas),

	----------------------------------
	constraint FK_Productos_Tiendas foreign key (IDRegalosProductos) references Productos (IDRegalos) on delete cascade on update cascade,
	constraint FK_Tiendas_Productos foreign key (IDTiendas) references Tiendas (ID) on delete cascade on update cascade
)
go

create table ProductosCategorias
(
	IDRegalosProductos tinyint not null,
	IDRegalosCategorias tinyint not null,

	----------------------------------
	constraint PK_ProductosCategorias primary key (IDRegalosProductos,IDRegalosCategorias),

	----------------------------------
	constraint FK_Productos_Categorias foreign key (IDRegalosProductos) references Productos (IDRegalos) on delete cascade on update cascade,
	constraint FK_Categorias_Productos foreign key (IDRegalosCategorias) references Categorias (IDRegalos) on delete no action on update no action
)
go