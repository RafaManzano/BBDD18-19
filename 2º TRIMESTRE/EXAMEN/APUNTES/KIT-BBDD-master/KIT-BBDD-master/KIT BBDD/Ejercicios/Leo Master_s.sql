--use master
--go
--drop database [Leo Master's]

create database [Leo Master's]
go 
use [Leo Master's]
go


create table LM_Modalidades
(
	ID tinyint not null,
	IDPartidos tinyint not null,
	----------------------------
	constraint PK_LM_Modalidades primary key (ID)
)
go

create table LM_Rondas
(
	ID tinyint not null,
	Ronda char (1) not null constraint CK_ID check (Ronda  in ('D','O','C','S','F')),
	IDPartidos tinyint not null,
	----------------------------
	constraint PK_LM_Rondas primary key (ID)
)
go

create table LM_Ediciones
(
	ID tinyint not null,
	IDPartidos tinyint not null,

	----------------------------
	constraint PK_LM_Edicion primary key (ID)
)
go

create table LM_Partidos
(
	ID tinyint not null,
	FechaHora datetime not null,
	Resultado varchar(10) not null,
	Duracion varchar (10) not null,
	IDModalidades tinyint not null,
	IDRondas tinyint not null,
	IDEdiciones tinyint not null,

	----------------------------
	constraint PK_LM_Partidos primary key (ID),

	---------------------------------
	constraint FK_LM_Partidos_LM_Modalidades foreign key (IDModalidades) references LM_Modalidades (ID) on delete cascade on update cascade,
	constraint FK_LM_Partidos_LM_Rondas foreign key (IDRondas) references LM_Rondas (ID) on delete cascade on update cascade,
	constraint FK_LM_Partidos_LM_Ediciones foreign key (IDEdiciones) references LM_Ediciones (ID) on delete cascade on update cascade
)
go

create table LM_Sets
(
	ID tinyint not null,
	IDPartidos tinyint not null,
	----------------------------
	constraint PK_LM_Sets primary key (ID),

	---------------------------------
	constraint FK_LM_Sets_LM_Partidos foreign key (IDPartidos) references LM_Partidos (ID) on delete cascade on update cascade
)
go

create table LM_ModalidadesEdicionesRondas
(
	IDModalidades tinyint not null,
	IDEdiciones tinyint not null,
	IDRondas tinyint not null,

	----------------------------
	constraint PK_LM_ModalidadesEdicionesRondas primary key (IDModalidades,IDEdiciones,IDRondas),

	--------------------------------
	constraint FK_LM_Modalidades_Ediciones_Rondas foreign key (IDModalidades) references LM_Modalidades (ID) on delete cascade on update cascade,
	constraint FK_LM_Edicione_Modalidadess_Rondas foreign key (IDEdiciones) references LM_Ediciones (ID) on delete no action on update no action,
	constraint FK_LM_Rondas_Edicione_Modalidades foreign key (IDRondas) references LM_Rondas (ID) on delete no action on update no action
)
go

create table LM_Participantes
(
	ID tinyint not null,
	Nombre varchar (15) not null,
	Apellidos varchar (20) not null,
	Nacionalidad varchar (15) not null,

	----------------------------
	constraint PK_LM_Participantes primary key (ID)
)
go

create table LM_ParticipantesPartidos
(
	IDParticipantes tinyint not null,
	IDPartidos tinyint not null,

	----------------------------
	constraint PK_LM_ParticipantesPartidos primary key (IDParticipantes,IDPartidos),

	--------------------------------
	constraint FK_LM_Participantes_Partidos foreign key (IDParticipantes) references LM_Participantes (ID)on delete cascade on update cascade,
	constraint FK_LM_Partidos_Participantes foreign key (IDPartidos) references LM_Partidos (ID) on delete cascade on update cascade
)
go

create table LM_ParticipantesEdiciones
(
	IDParticipantes tinyint not null,
	IDEdiciones tinyint not null,

	----------------------------
	constraint PK_LM_ParticipantesEdiciones primary key (IDParticipantes,IDEdiciones),

	--------------------------------
	constraint FK_LM_Participantes_Ediciones foreign key (IDParticipantes) references LM_Participantes (ID) on delete cascade on update cascade,
	constraint FK_LM_Ediciones_Participantes foreign key (IDEdiciones) references LM_Ediciones (ID) on delete cascade on update cascade
)
go

create table LM_Tenistas
(
	ID tinyint not null,

	----------------------------
	constraint PK_LM_Tenistas primary key (ID)
)
go

create table LM_ParticipantesTenistas
(
	IDParticipantes tinyint not null,
	IDTenistas tinyint not null,

	----------------------------
	constraint PK_LM_ParticipantesTenistas primary key (IDParticipantes,IDTenistas),

	--------------------------------
	constraint FK_LM_Participantes_Tenistas foreign key (IDParticipantes) references LM_Participantes (ID) on delete cascade on update cascade,
	constraint FK_LM_Tenistas_Participantes foreign key (IDTenistas) references LM_Tenistas (ID) on delete cascade on update cascade
)
go