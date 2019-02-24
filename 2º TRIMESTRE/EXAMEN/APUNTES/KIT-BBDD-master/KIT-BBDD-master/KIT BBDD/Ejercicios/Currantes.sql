--use master
--go
--drop database Currantes

create database Currantes
go 
use Currantes
go

create table Usuarios
(
	NombreUsuario char(10) not null,
	Contraseña tinyint not null,
	Nombre varchar (15) not null,
	Apellidos varchar (20) not null,
	Direccion varchar (30) not null,
	Telefono varchar (12) not null,
	Nacionalidad varchar (20) not null,

	-------------------PK--------------
	constraint PK_Usuarios primary key (NombreUsuario)
)
go

create table Cursos
(
	ID tinyint not null,  ----------------inventado

	-------------------PK--------------
	constraint PK_Cursos primary key (ID)
)
go

create table Empresas
(
	CIF char (9) not null,             ----------------inventado
	Direccion varchar(30) not null,
	Poblacion varchar (15) not null,
	Provincia varchar (15) not null

	-------------------PK--------------
	constraint PK_Empresas primary key (CIF)
)
go

create table Ofertas
(
	ID tinyint not null,             ----------------inventado
	Puesto varchar(15) not null,
	NumeroPlazas tinyint not null,
	TipoContrato varchar (15) not null,
	Observaciones varchar (50) not null,
	CIFEmpresa char (9) not null, 

	-------------------PK--------------
	constraint PK_Ofertas primary key (ID),

	-------------------FK--------------
	constraint FK_Empresa_Oferta foreign key (CIFEmpresa) references Empresas(CIF) on update cascade on delete cascade,
)
go

create table UsuarioUsuario
(
	NombreUsuarioCon char(10) not null,---con relacion
	NombreUsuarioSin char(10) not null,--sin relacion
	Recomendacion char(2) not null,    --Si/No
	-------------------PK--------------
	constraint PK_Usuario_Usuario primary key (NombreUsuarioCon,NombreUsuarioSin),

	-------------------FK--------------
	constraint FK_Usuario_Usuario foreign key (NombreUsuarioCon) references Usuarios(NombreUsuario) on update cascade on delete cascade,
	constraint FK_Usuario_Usuario_Sin foreign key (NombreUsuarioSin) references Usuarios(NombreUsuario) on update no action
)
go

create table UsuarioCurso
(
	NombreUsuario char(10) not null,
	ID tinyint not null,
	Institucion varchar(20) not null,
	-------------------PK--------------
	constraint PK_Usuario_Curso primary key (NombreUsuario,ID),

	-------------------FK--------------
	constraint FK_Usuario_Curso foreign key (NombreUsuario) references Usuarios(NombreUsuario) on update cascade on delete cascade,
	constraint FK_Curso_Usuario foreign key (ID) references Cursos(ID)  on update cascade on delete cascade,
)
go

create table UsuarioEmpresa
(
	NombreUsuario char(10) not null,
	CIFEmpresa char (9) not null,
	FechaInicio datetime not null,
	FechaFin datetime not null,

	-------------------PK--------------
	constraint PK_Usuario_EmpresaT primary key (NombreUsuario,CIFEmpresa),

	-------------------FK--------------
	constraint FK_Usuario_EmpresaT foreign key (NombreUsuario) references Usuarios(NombreUsuario) on update cascade on delete cascade,
	constraint FK_Empresa_Usuario foreign key (CIFEmpresa) references Empresas(CIF)  on update cascade on delete cascade,
)
go

create table UsuarioAdministraEmpresa
(
	NombreUsuario char(10) not null,
	CIFEmpresa char (9) not null,

	-------------------PK--------------
	constraint PK_Usuario_Empresa primary key (NombreUsuario,CIFEmpresa),

	-------------------FK--------------
	constraint FK_Usuario_Empresa_Admin foreign key (NombreUsuario) references Usuarios(NombreUsuario) on update cascade on delete cascade,
	constraint FK_Admin_Empresa_Usuario foreign key (CIFEmpresa) references Empresas(CIF)  on update cascade on delete cascade,
)
go

create table UsuarioOferta
(
	NombreUsuario char(10) not null,
	IDOferta tinyint not null,

	-------------------PK--------------
	constraint PK_Usuario_Oferta primary key (NombreUsuario,IDOferta),

	-------------------FK--------------
	constraint FK_Usuario_Oferta foreign key (NombreUsuario) references Usuarios(NombreUsuario) on update cascade on delete cascade,
	constraint FK_Oferta_Usuario foreign key (IDOferta) references Ofertas(ID)  on update cascade on delete cascade,
)
go
/*
create table EmpresaOferta
(
	CIFEmpresa char (9) not null,
	IDOferta tinyint not null,

	-------------------PK--------------
	constraint PK_Empresa_Oferta primary key (CIFEmpresa,IDOferta),

	-------------------FK--------------
	constraint FK_Empresa_Oferta foreign key (CIFEmpresa) references Empresas(CIF) on update cascade on delete cascade,
	constraint FK_Oferta_Empresa foreign key (IDOferta) references Ofertas(ID)  on update cascade on delete cascade,
)
go*/