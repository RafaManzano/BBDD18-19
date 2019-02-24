--Unidad 11. Programaci�n avanzada de SQL Server
Use TransLeo
go
--Ejercicio 1
--La empresa de log�stica (transportes y algo m�s) TransLeo tiene una base de datos con la informaci�n 
--de los env�os que realiza. Hay una tabla llamada TL_PaquetesNormales en la que se guardan los datos 
--de los paquetes que pueden meterse en una caja normal. Las cajas normales son paralelep�pedos de base rectangular. 
--Las columnas alto, ancho y largo, de tipo entero, contienen las dimensiones de cada paquete en cent�metros.

--1. Crea un funci�n fn_VolumenPaquete que reciba el c�digo de un paquete y nos devuelva su volumen.
--El volumen se expresa en litros (dm3) y ser� de tipo decimal(6,2).
CREATE FUNCTION fn_VolumenPaquete (@codigo int) RETURNS decimal(6,2) AS
BEGIN
	declare @resultado decimal(6,2)
	Select @resultado=(cast(Alto as decimal(6,2))*Ancho*Largo /1000) from TL_PaquetesNormales
		Where Codigo=@codigo
	RETURN @resultado

END 
GO
declare @paquete decimal(6,2)
EXECUTE @paquete=fn_VolumenPaquete 600
print @paquete
go
--2. Los paquetes normales han de envolverse. Se calcula que la cantidad de papel necesaria para envolver el paquete es 1,8 veces su superficie. 
--Crea una funci�n fn_PapelEnvolver que reciba un c�digo de paquete y nos devuelva la cantidad de papel necesaria para envolverlo, en metros cuadrados.

ALTER FUNCTION fn_PapelEnvolver (@codigo int) RETURNS decimal(6,2) AS
BEGIN
	declare @resultado decimal(6,2)
	Select @resultado=(cast((Alto*Ancho+Alto*Largo+Ancho*Largo)as decimal(10,2))*2/10000)*1.8 from TL_PaquetesNormales
		where Codigo=@codigo
	RETURN @resultado
END
GO

GO
declare @papel decimal(6,2)
EXECUTE @papel=fn_PapelEnvolver 600
print @papel
go
--3. Crea una funci�n fn_OcupacionFregoneta a la que se pase el c�digo de un veh�culo y una fecha y nos indique 
--cu�l es el volumen total que ocupan los paquetes que ese veh�culo entreg� en el d�a en cuesti�n. 
--Usa las funciones de fecha y hora para comparar s�lo el d�a, independientemente de la hora.
ALTER FUNCTION fn_OcupacionFregoneta (@codigo int,@fecha Date) RETURNS decimal(6,2) AS
BEGIN
	declare @resultado decimal(6,2)
	declare @mitabla table (
	codigo int null,
	volumen decimal(6,2) null
	)
	insert into @mitabla(codigo)
		Select Codigo
		From TL_PaquetesNormales
		where codigoFregoneta=@codigo and cast(fechaEntrega as date)=@fecha
	update @mitabla
		set volumen=dbo.fn_VolumenPaquete(codigo)
		select @resultado=sum(volumen) from @mitabla
	RETURN @resultado
END
GO

GO
SET NOCOUNT ON
declare @ocupaci�n decimal(6,2)
EXECUTE @ocupaci�n=fn_OcupacionFregoneta 6,'2015-04-01'
print @ocupaci�n
Select * from TL_PaquetesNormales
go


--4. Crea una funci�n fn_CuantoPapel a la que se pase una fecha y nos diga la cantidad total de papel de envolver que se gast� 
--para los paquetes entregados ese d�a. Trata la fecha igual que en el anterior.
GO
CREATE FUNCTION fn_CuantoPapel (@fecha Date) RETURNS decimal(6,2) AS
BEGIN
	declare @resultado decimal(6,2)
	declare @mitabla table (
	codigo int null,
	papel decimal(6,2) null
	)
	insert into @mitabla(codigo)
		Select Codigo
		From TL_PaquetesNormales
		where cast(fechaEntrega as date)=@fecha
	update @mitabla
		set papel=dbo.fn_PapelEnvolver(codigo)
		select @resultado=sum(papel) from @mitabla
	RETURN @resultado
END
GO

GO
SET NOCOUNT ON
declare @papel decimal(6,2)
EXECUTE @papel=fn_CuantoPapel '2015-04-01'
print @papel
go
--5. Modifica la funci�n anterior para que en lugar de aceptar una fecha, acepte un rango de fechas (inicio y fin). 
--Si el inicio y fin son iguales, calcular� la cantidad gastada ese d�a. Si el fin es anterior al inicio devolver� 0.
GO
ALTER FUNCTION fn_CuantoPapelFechas (@fechainicio Date,@fechafin Date) RETURNS decimal(6,2) AS
BEGIN
	declare @resultado decimal(6,2)=0.00
	if(@fechainicio<@fechafin)
	BEGIN
		declare @mitabla table (
		codigo int null,
		papel decimal(6,2) null
		)
		insert into @mitabla(codigo)
			Select Codigo
			From TL_PaquetesNormales
			where cast(fechaEntrega as date) between @fechainicio and @fechafin
		update @mitabla
			set papel=dbo.fn_PapelEnvolver(codigo)
			select @resultado=sum(papel) from @mitabla
	END
	ELSE
	BEGIN
		if(@fechainicio=@fechafin)
		BEGIN
		EXECUTE @resultado=fn_CuantoPapel @fechainicio
		END
	END
	RETURN @resultado
END
GO

GO
SET NOCOUNT ON
declare @papel decimal(6,2)
EXECUTE @papel=fn_CuantoPapelFechas '2015-04-01','2015-04-25'
print @papel
go

--6. Crea una funci�n fn_Entregas a la que se pase un rango de fechas y nos devuelva una tabla con los c�digos 
--de los paquetes entregados y los veh�culos que los entregaron entre esas fechas.
go
CREATE FUNCTION fn_Entregas (@Fechainicio Date,@FechaFin Date) RETURNS TABLE AS
RETURN (Select Codigo,
			   codigoFregoneta
		From TL_PaquetesNormales
		where cast(fechaEntrega as date)>=@fechainicio and cast(fechaEntrega as date)<=@fechafin
		)
go

Select * from fn_Entregas('2013-03-01','2015-04-06')




--Ejercicio 2:
Use AirLeo
go
set dateformat 'ymd'
--1. Dise�a una funci�n fn_distancia recorrida a la que se pase un c�digo de avi�n y 
--un rango de fechas y nos devuelva la distancia total recorrida por ese avi�n en ese rango de fechas.
GO
CREATE FUNCTION fn_distancia(@codigo char(10),@fechainicio Date,@fechafin Date) Returns decimal(8,2) as 
BEGIN
Declare @resultado decimal(8,2)
Select @resultado=SUM(Distancia) from AL_Distancias as D
	inner join AL_Vuelos as V
	on D.Origen=V.Aeropuerto_Llegada and D.Destino=V.Aeropuerto_Salida
return @resultado
END
GO
--2. Dise�a una funci�n fn_horasVuelo a la que se pase un c�digo de avi�n y un rango de fechas 
--y nos devuelva las horas totales que ha volado ese avi�n en ese rango de fechas.
GO
ALTER FUNCTION fn_horasVuelo (@codigo char(10),@fechainicio SmallDateTime,@fechafin SmallDateTime) RETURNS int as
BEGIN
DECLARE @resultado int=-1
	if(@fechainicio<@fechafin)
	BEGIN
		Select @resultado=sum(DATEDIFF(MINUTE,salida,llegada))/60
		from AL_Vuelos
		where Salida>=@fechainicio and Llegada<=@fechafin
				and Matricula_Avion=@codigo
	END
RETURN @resultado
END
GO

Select * from AL_Vuelos where Matricula_Avion='ESP4502'
declare @horas int
Execute @horas=fn_horasVuelo 'ESP4502','2010-11-13 15:00:00','2015-11-14 18:00:00' 
print @horas

--3. Dise�a una funci�n a la que se pase un c�digo de avi�n y un rango de fechas y nos devuelva 
--una tabla con los nombres y fechas de todos los aeropuertos en que ha estado el avi�n en ese intervalo.
GO
ALTER FUNCTION fn_EstacionamientoAvion (@codigo char(10),@fechainicio SmallDateTime,@fechafin SmallDateTime) 
			   RETURNS @tabla TABLE(
					Nombre_Aeropuerto varchar(30) null,
					Fecha DATE null
) AS
BEGIN
	Insert into @tabla
			(Nombre_Aeropuerto,
			 Fecha)
		SELECT 
			A.Nombre,
			cast(Llegada as Date)
			FROM AL_Vuelos as V
			inner join AL_Aeropuertos as A
			on V.Aeropuerto_Salida=A.Codigo
				where V.Matricula_Avion=@codigo and Salida>=@fechainicio and Llegada<=@fechafin
	
	Insert into @tabla
		(Nombre_Aeropuerto,
		 Fecha)
		SELECT 
			A.Nombre,
			cast(Llegada as Date)
			FROM AL_Vuelos as V
			inner join AL_Aeropuertos as A
			on V.Aeropuerto_Llegada=A.Codigo
				where V.Matricula_Avion=@codigo and Salida>=@fechainicio and Llegada<=@fechafin
	
RETURN
END
GO
Select * from AL_Vuelos where Matricula_Avion='USA5068'
order by Salida
Select * from fn_EstacionamientoAvion('USA5068','2012-01-14 00:00:00','2012-01-30 00:00:00')
order by Fecha
--4. Dise�a una funci�n fn_ViajesCliente que nos devuelva nombre y apellidos, 
--kil�metros recorridos y n�mero de vuelos efectuados por cada cliente en un rango de fechas, 
--ordenado de mayor a menor distancia recorrida.