USE TransLeo
GO
/*Ejercicio 1
La empresa de logística (transportes y algo más) TransLeo tiene una base de datos con la
información de los envíos que realiza. Hay una tabla llamada TL_PaquetesNormales en la que se
guardan los datos de los paquetes que pueden meterse en una caja normal. Las cajas normales
son paralelepípedos de base rectangular. Las columnas alto, ancho y largo, de tipo entero,
contienen las dimensiones de cada paquete en centímetros.
La estructura de la tabla TL_PaquetesNormales es:
·-----------------------------------------------------------·
| Columna            | Tipo           | Comentario  | Nulos |
·-----------------------------------------------------------·
| codigo             | int            | Es la clave | No    |
·-----------------------------------------------------------·
| alto               | int            |             | No    |
·-----------------------------------------------------------·
| largo              | int            |             | No    |
·-----------------------------------------------------------·
| codigoFregoneta    | int            |             | No    |
·-----------------------------------------------------------·
| fechaEntrega       | smalldatetime  |             | No    |
·-----------------------------------------------------------·
*/

/*1.Crea un función fn_VolumenPaquete que reciba el código de un paquete y nos devuelva
su volumen. El volumen se expresa en litros (dm^3) y será de tipo decimal(6,2).
Precondiciones:
	Ninguna
Entradas:
	Un entero
Salidas:
	Un entero
Postcondiciones:
	Se devolverá asociado al nombre el volumen de la caja cuyo código sea pasado como parámetro
	Se devolverá 0 en caso de que el código no esté en la base de datos
*/
CREATE FUNCTION fn_VolumenPaquete(@codigo int)
RETURNS int AS
BEGIN
	DECLARE @volumen DECIMAL(9,3) = 0
	SELECT @volumen = Alto*Ancho*Largo*0.001 FROM TL_PaquetesNormales WHERE Codigo = @codigo
	RETURN @volumen
END
GO
PRINT dbo.fn_VolumenPaquete(600)
--DROP FUNCTION fn_VolumenPaquete
GO
/*2.Los paquetes normales han de envolverse. Se calcula que la cantidad de papel necesaria
para envolver el paquete es 1,8 veces su superficie. Crea una función fn_PapelEnvolver
que reciba un código de paquete y nos devuelva la cantidad de papel necesaria para
envolverlo, en metros cuadrados.
Precondiciones:
	Ninguna
Entrada:
	Un entero
Salida:
	Un real
Postcondiciones:
	Se devolverá asociada al nombre la cantidad de papel necesario en metros cuadrados
	Se devolverá 0 en caso de que el código no esté en la base de datos
*/
CREATE FUNCTION fn_PapelEnvolverCaja(@codigo int)
RETURNS DECIMAL(9,3) AS
BEGIN
	DECLARE @volumen real = 0
	SELECT @volumen = 2*(Alto*Ancho + Alto*Largo + Ancho*Largo)*1.8*0.0001 FROM TL_PaquetesNormales WHERE Codigo = @codigo
	RETURN @volumen
END
GO
PRINT dbo.fn_PapelEnvolverCaja(600)

GO
/*3.Crea una función fn_OcupacionFregoneta a la que se pase el código de un vehículo y una
fecha y nos indique cuál es el volumen total que ocupan los paquetes que ese vehículo
entregó en el día en cuestión. Usa las funciones de fecha y hora para comparar sólo el
día, independientemente de la hora.
Precondiciones:
	El código de la fregoneta debe estar en la basede datos
Entradas:
	Un entero
Salidas:
	Un real
Postcondiciones:
	Se devolverá el volumen de los paquetes asociado al nombre
*/
ALTER FUNCTION fn_VolumenPaquetesFregoneta(@codigoFregoneta int)
RETURNS DECIMAL(9,3)
BEGIN
	DECLARE @volumen DECIMAL(9,3)
	SELECT @volumen = SUM(dbo.fn_VolumenPaquete(Codigo)) FROM TL_PaquetesNormales WHERE codigoFregoneta = @codigoFregoneta
	RETURN @volumen
END
GO
PRINT dbo.fn_VolumenPaquetesFregoneta(3789)

GO
/*4.Crea una función fn_CuantoPapel a la que se pase una fecha y nos diga la cantidad total
de papel de envolver que se gastó para los paquetes entregados ese día. Trata la fecha
igual que en el anterior.
Precondiciones:
	Ninguna
Entradas:
	Una fecha tipo DATE
Salidas:
	Un entero
Precondiciones:
	Se devolverá la cantidad total de papel en metros cuadrados ese día
*/
ALTER FUNCTION fn_PapelGastadoFecha(@fecha DATE)
RETURNS DECIMAL(9,2)
BEGIN
	DECLARE @papelTotal DECIMAL(9,2)
	SELECT @papelTotal = SUM(dbo.fn_PapelEnvolverCaja(Codigo))
	FROM TL_PaquetesNormales
	WHERE CAST(fechaEntrega AS DATE) = @fecha
	GROUP BY CAST(fechaEntrega AS DATE)
	IF(@papelTotal IS NULL)
	BEGIN
		SET @papelTotal = 0
	END
RETURN @papelTotal
END
GO
PRINT dbo.fn_PapelGastadoFecha(DATEFROMPARTS(2085,4,1))
GO

/*5.Modifica la función anterior para que en lugar de aceptar una fecha, acepte un rango de
fechas (inicio y fin). Si el inicio y fin son iguales, calculará la cantidad gastada ese día. Si
el fin es anterior al inicio devolverá 0.
Precondiciones:
	Ninguna
Entradas:
	Dos fechas tipo DATE
Salidas:
	Un entero
Precondiciones:
	Se devolverá la cantidad total de papel en metros cuadrados ese rango de días
*/
CREATE FUNCTION fn_PapelGastadoFecha2(@fechaInicio DATE, @fechaFin DATE)
RETURNS DECIMAL(9,2)
BEGIN
	DECLARE @papelTotal DECIMAL(9,2)
	SELECT @papelTotal = SUM(dbo.fn_PapelEnvolverCaja(Codigo))
	FROM TL_PaquetesNormales
	WHERE CAST(fechaEntrega AS DATE) >= @fechaInicio AND CAST(fechaEntrega AS DATE) <= @fechaFin
	IF(@papelTotal IS NULL)
	BEGIN
		SET @papelTotal = 0
END
RETURN @papelTotal
END
GO
PRINT dbo.fn_PapelGastadoFecha2(DATEFROMPARTS(2085,4,1), DATEFROMPARTS(1995,11,10))
GO

/*6.Crea una función fn_Entregas a la que se pase un rango de fechas y nos devuelva una
tabla con los códigos de los paquetes entregados y los vehículos que los entregaron entre
esas fechas.*/

CREATE FUNCTION fn_Entregas(@fechaInicio DATE, @fechaFin DATE)
RETURNS TABLE
RETURN
SELECT Codigo, codigoFregoneta FROM TL_PaquetesNormales WHERE fechaEntrega BETWEEN @fechaInicio AND @fechaFin
GO

SELECT * FROM dbo.fn_Entregas(DATEFROMPARTS(2014,6,25), DATEFROMPARTS(2016,5,10))

---------------------------------------------------------------------------------------------------------------

/*Ejercicio 2
Sobre la base de datos AirLeo

1.Diseña una función fn_distancia recorrida a la que se pase un código de avión y un rango
de fechas y nos devuelva la distancia total recorrida por ese avión en ese rango de
fechas.*/

/*2.Diseña una función fn_horasVuelo a la que se pase un código de avión y un rango de
fechas y nos devuelva las horas totales que ha volado ese avión en ese rango de fechas.*/

/*3.Diseña una función a la que se pase un código de avión y un rango de fechas y nos
devuelva una tabla con los nombres y fechas de todos los aeropuertos en que ha estado
el avión en ese intervalo.*/

/*4.Diseña una función fn_ViajesCliente que nos devuelva nombre y apellidos, kilómetros
recorridos y número de vuelos efectuados por cada cliente en un rango de fechas,
ordenado de mayor a menor distancia recorrida.*/