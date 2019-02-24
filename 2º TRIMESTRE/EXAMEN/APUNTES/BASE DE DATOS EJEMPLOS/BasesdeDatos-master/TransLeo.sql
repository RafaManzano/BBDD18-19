--1. TransLeo s�lo realiza env�os en Espa�a.


--5. Las relaciones se recoge, traslada y entrega tienen un atributo fecha.

--6. Cuando un cliente deposita un paquete en un centro, se dan de alta en la base de datos remitente y destinatario (si no ten�amos ya sus datos) 
--y se asigna unn�mero de referencia al paquete. Al cliente se le asigna un nombre de usuario (cadena variable de longitud m�xima 15) y 
--una contrase�a (cadena variable de longitud m�xima 10), para que pueda consultar el estado de su env�o. Estos datos deben ser incorporados como atributos de la entidad cliente.

--7. El paquete puede ser trasladado de un centro a otro o entregado directamente al destinatario. Puede ser trasladado varias veces de centro antes de ser entregado. 
--Todos los movimientos del paquete se registran en labase de datos, al partir y al llegar. 

--8. El traslado de un paquete debe iniciarse en el centro donde fue entregado o donde termin� el traslado anterior. Las fechas deben estar correctamente encadenadas.

--10. Todos los movimientos de veh�culos se registran en la base de datos como traslados, aunque no lleven ning�n paquete. 
--Cada movimiento de un veh�culo debe comenzar en el centro donde termin� el anterior. Cuando un veh�culo sale a entregar paquetes a clientes siempre vuelve al centro de origen.

CREATE DATABASE TransLeo
go
use TransLeo
go

--2. Tenemos una serie de clientes, que act�an como remitentes o destinatarios de cada env�o. 
--Los atributos del cliente son nombre (cadena variable de longitud m�xima 20), apellidos (cadena variable de longitud m�xima 40), 
--c�digo (entero), direcci�n (cadena variable de longitud m�xima 80), ciudad (cadena variable de longitud m�xima 20), c�digo postal (entero), 
--provincia (cadena variable de longitud m�xima 20), tel�fono (cadena fija de longitud 9), tel�fono alternativo (cadena fija de longitud 9).

CREATE TABLE Clientes(
C�digo Int identity (1,1) constraint PK_Clientes primary key ,
Nombre nvarchar(20) Not Null,
Apellidos nvarchar(40) Not Null,
Direcci�n nvarchar(80) Null,
Ciudad nvarchar(20) Null,
C�digo_Postal Int Not Null,
Tel�fono char(9) Not Null,
Tel�fono2 char(9) Null,
Nombre_Usuario nvarchar(15) Null,
Contrase�a nvarchar(10) Null
)

--3. Un cliente puede ser remitente de uno o varios env�os y destinatario de uno o varios. 
--Cada env�o consta de un �nico paquete. Los atributos del paquete son: c�digo (entero largo), alto (entero), ancho (entero), largo (entero), peso (entero). 


CREATE TABLE Paquetes(
C�digo BigInt identity (1,1) constraint PK_Paquetes primary key,
Alto Int Null,
Ancho Int Null,
Largo Int Null,
Peso Int Not Null,
C�digo_Remitente Int Not Null,
C�digo_Destinatario Int Not Null,
C�digo_Centro Int Not Null,
Matr�cula char(7) Not Null,
Fecha_Entrega datetime Null,
Fecha_Env�o datetime Null,
 constraint CK_Paquetes check (Fecha_Env�o>=Fecha_Entrega)
)


--4. TransLeo tiene centros en distintas ciudades. La empresa realiza dos tipos de traslados: entre oficinas de la empresa y de una oficina a la direcci�n del destinatario. 
--Estos �ltimos se conocen como entregas. Los atributos del centro son c�digo(entero), denominacion (cadena variable de longitud m�xima 40), 
--direcci�n (cadena variable de longitud m�xima 80), ciudad (cadena variable de longitud m�xima 20), c�digo postal (entero), provincia (cadena variable de longitud m�xima 20),
-- tel�fono (cadena fija de longitud 9), tel�fono alternativo (cadena fija de longitud 9).

CREATE TABLE Centros(
C�digo Int identity (1,1) constraint PK_Centros primary key,
Denominaci�n nvarchar(40) Null,
Direcci�n nvarchar(80) Null,
Ciudad nvarchar(20) Null,
C�digo_Postal int Not Null,
Tel�fono nchar(9),
Tel�fono_Alternativo nchar(9)
)

--9. Transleo dispone de una flota de veh�culos que realizan los traslados y entregas. 
--Los atributos del veh�culo son matricula (cadena fija de longitud 7), tipo (car�cter), fecha adquisicion, fecha matriculacion, tipo carnet (cadena de longitud 3), 
--capacidad (entero), peso m�ximo transportable (entero).


CREATE TABLE Veh�culos(
Matr�cula char(7) Not Null constraint PK_Veh�culo primary key,
Tipo char(1) Null,
Fecha_Adquisici�n date Null,
Fecha_Matriculaci�n date Null,
Tipo_Carnet varchar (3),
Capacidad Int Null,
Peso_M�ximo Int Not Null
)


--11. La relaci�n dista tiene un atributo distancia (entero) que indica la distancia en kil�metros entre dos centros.


Create Table Centros_Centros(
C�digo_CentroA Int,
C�digo_CentroB Int,
Distancia Int,
constraint PK_CentroCentro primary key (C�digo_centroA,C�digo_CentroB),
constraint CK_CentrosCentros check (C�digo_centroA<>C�digo_CentroB),
constraint FK_CentroCentro foreign key (C�digo_CentroA) references Centros (C�digo) ON UPDATE CASCADE ON DELETE NO ACTION,
constraint FK_CentroCentro2 foreign key (C�digo_CentroB) references Centros (C�digo) ON UPDATE NO ACTION ON DELETE NO ACTION
)

--Para cumplir las formas normales, creamos la siguiente tabla

Create Table Provincias(
C�digo_Postal Int Not Null constraint PK_Provincias primary key, 
Provincia nvarchar(20) Not Null
)

--Create Table Clientes_Paquetes(
--C�digo_Remitente Int Not Null,
--C�digo_Destinatario Int Not Null,
--C�digo_Paquete BigInt Not Null,
--constraint PK_ClientesPaquetes primary key (C�digo_Remitente,C�digo_Destinatario,C�digo_Paquete),
--constraint FK_ClientesPaquetes_Clientes foreign key (C�digo_Remitente) references Clientes (C�digo) ON UPDATE CASCADE ON DELETE NO ACTION,
--constraint FK_CLientesPaquetes_Clientes2 foreign key (C�digo_Destinatario) references Clientes(C�digo) ON UPDATE NO ACTION ON DELETE NO ACTION,
--constraint FK_ClientesPaquetes_Paquetes foreign key (C�digo_Paquete) references Paquetes (C�digo) ON UPDATE CASCADE ON DELETE NO ACTION
--)

Create Table Centros_Paquetes_Veh�culos(
C�digo_Traslado Int Identity (1,1) Not Null,
C�digo_Centro_Remitente Int Not Null,
C�digo_Centro_Destinatario Int Not Null,
C�digo_Paquete BigInt  Null,
Matr�cula char(7) Not Null,
Fecha_Traslado_Salida smalldatetime Null, --No conocemos a�n los medios para las restricciones entre tablas--
Fecha_Traslado_Llegada smalldatetime Null,
constraint PK_CentrosPaquetesVeh�culos primary key (C�digo_Traslado), --�Fecha Traslado?--
constraint FK_CentrosPaquetesVeh�culos_Centros foreign key (C�digo_Centro_Remitente) references Centros (C�digo) ON UPDATE CASCADE ON DELETE NO ACTION,
constraint FK_CentrosPaquetesVeh�culos_Paquetes foreign key (C�digo_Paquete) references Paquetes (C�digo) ON UPDATE CASCADE ON DELETE NO ACTION,
constraint FK_CentrosPaquetesVeh�culos_Veh�culos foreign key (Matr�cula) references Veh�culos (Matr�cula) ON UPDATE CASCADE ON DELETE NO ACTION
)
GO 

alter table Centros_Paquetes_Veh�culos add constraint FK_CentrosPaquetesVeh�culos_Centros2 foreign key (C�digo_Centro_Destinatario) references Centros (C�digo) ON UPDATE NO ACTION ON DELETE cascade
alter table Clientes add constraint FK_Clientes_Provincias foreign key (C�digo_Postal) references Provincias (C�digo_Postal) on update CASCADE ON DELETE CASCADE
alter table Centros add constraint FK_Centros_Provincias foreign key (C�digo_Postal) references Provincias (C�digo_Postal) on update NO ACTION ON DELETE CASCADE
alter table Paquetes add constraint FK_ClientesPaquetes_Clientes foreign key (C�digo_Remitente) references Clientes (C�digo) ON UPDATE CASCADE ON DELETE NO ACTION
alter table Paquetes add constraint FK_CLientesPaquetes_Clientes2 foreign key (C�digo_Destinatario) references Clientes(C�digo) ON UPDATE NO ACTION ON DELETE NO ACTION
go
alter table Paquetes add constraint FK_Paquetes_Centros foreign key (C�digo_Centro) references Centros (C�digo) ON UPDATE NO ACTION ON DELETE NO ACTION
alter table Paquetes add constraint FK_Paquetes_Veh�culos foreign key (Matr�cula) references Veh�culos (Matr�cula) ON UPDATE NO ACTION ON DELETE NO ACTION