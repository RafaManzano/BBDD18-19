/*use master
go
drop database AquiHayTomate
*/

/*
CREATE DATABASE AquiHayTomate
go
USE AquiHayTomate
*/

CREATE TABLE Fm_Famosillos(
	CodigoFamosillo smallint
	,NombreFamosillo varchar
	,Apellidos varchar
	,Nacionalidad varchar
	,CONSTRAINT PK_Fm_Famosillos PRIMARY KEY (CodigoFamosillo)
)

CREATE TABLE Fm_Exclusivas(
	CodigoExclusiva smallint
	,FechaExclusiva smalldatetime
	,Precio smallint
	,Descripcion varchar
	,NombreMedio
	,CONSTRAINT PK_Fm_Exclusivas PRIMARY KEY (CodigoExclusiva)
	,CONSTRAINT FK_Fm_Medios FOREIGN KEY (NombreMedio) REFERENCES Fm_Medios(NombreMedio) ON UPDATE CASCADE
)

CREATE TABLE Fm_Medios(
	NombreMedio varchar
	,Tipo varchar
	,Direccion varchar
)

CREATE TABLE Fm_Lugares(
	ID_Local smallint
	,Nombre varchar
	,Descripcion varchar
)

CREATE TABLE Fm_Fiestas(
	FechaFiesta smalldatetime
	,Hora time
	,Tema varchar
)

CREATE TABLE Fm_Grupos(
	NombreGrupo
	,Estilo
	,Email
	,Telefono
)

CREATE TABLE Fm_Artistas(
	NombreArtista
	,DNI_Artista
	,Funcion
	,Instrumento
)

CREATE TABLE Fm_Famosillo_ama_Famosillo(
	CodigoFamosillo1 smallint
	,CodigoFamosillo2 smallint
	,Tipo
	,Persona
	,F_Inicio
	,F_Fin
)

CREATE TABLE Fm_Famosillo_odia_Famosillo(
	CodigoFamosillo1
	,CodigoFamosillo2
)

CREATE TABLE Fm_Famosillo_Fiesta(
	CodigoFamosillo
	,FechaFiesta
)

CREATE TABLE Fm_Famosillo_Exclusiva(
	CodigoFamosillo
	,CodigoExclusiva
)

CREATE TABLE Fm_Fiesta_Lugar(
	ID_Local
	,FechaFiesta
)

CREATE TABLE Fm_Fiesta_Grupo(
	NombreGrupo
	,FechaFiesta
)

CREATE TABLE Fm_Grupo_Artista(
	NombreGrupo
	,DNI_Artista
)
