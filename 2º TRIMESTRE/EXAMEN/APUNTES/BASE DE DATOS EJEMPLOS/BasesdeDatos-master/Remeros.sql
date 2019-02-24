create database [Remeros Compiten]
go
use [Remeros Compiten]
go
create table RC_Competiciones (
 Id_Competici�n smallint Not Null
 , Ciudad nvarchar (20) Not Null
 , Pa�s nvarchar (20) Not Null
 , Car�cter nvarchar (20) Not Null
 , constraint PK_RC_Competici�n primary key (Id_Competici�n)
 )
 create table RC_Remeros (
 Num_Licencia smallint Not Null
 , Nombre nvarchar(50) Not Null
 , constraint PK_RC_Remero primary key (Num_Licencia)
 )
 create table RC_Embarcaciones (
 Nombre nvarchar(30) Not Null
 , Tipo nvarchar(30) Not Null
 , Marca nvarchar(30) Not Null
 , Modelo nvarchar(30) Not Null
 , Color nvarchar(30) Not Null
 , A�o_Botadura smallint Null
 , constraint PK_RC_Embarcaci�n primary key (Nombre)
 )
 create table RC_CompeticionesRemerosEmbarcaciones (
 Id_Competici�n smallint Not Null
 , Num_Licencia smallint Not Null
 , Nombre nvarchar(30) Not Null
 , Puesto tinyint Not Null
 , constraint PK_RC_CompeticionesRemerosEmbarcaciones primary key (Id_Competici�n,Num_Licencia,Nombre)
 , constraint FK_RC_Competiciones_CompeticionesRemerosEmbarcaciones foreign key(Id_Competici�n) references RC_Competiciones (Id_Competici�n)
   on delete no action on update cascade
 , constraint FK_RC_Remeros_CompeticionesRemerosEmbarcaciones foreign key(Num_Licencia) references RC_Remeros (Num_Licencia)
   on delete no action on update cascade
 , constraint FK_RC_Embarcaciones_CompeticionesRemerosEmbarcaciones foreign key (Nombre) references RC_Embarcaciones (Nombre)
 )
