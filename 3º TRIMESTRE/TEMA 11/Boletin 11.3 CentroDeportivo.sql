USE CentroDeportivo
SET DATEFORMAT YMD
/*
INTERFAZ
Nombre: EliminarUsuario
Cabecera: CREATE PROCEDURE EliminarUsuario @DNI CHAR(9)
Entrada: DNI CHAR
Salida: No hay
*/
--1. Escribe un procedimiento EliminarUsuario que reciba como parámetro el DNI de un usuario, 
--le coloque un NULL en la columna Sex y borre todas las reservas futuras de ese usuario. 
--Ten en cuenta que si alguna de esas reservas tiene asociado un alquiler de material habrá que borrarlo también.
SELECT * FROM Reservas
SELECT * FROM Usuarios

GO
CREATE PROCEDURE EliminarUsuario
	@DNI CHAR(9)
AS
BEGIN
	UPDATE Usuarios
	SET Sex = NULL 
	--FROM Usuarios
	WHERE DNI = @DNI

	DELETE ReservasMateriales FROM ReservasMateriales AS RM
	INNER JOIN Reservas AS R ON RM.CodigoReserva = R.Codigo
	INNER JOIN Usuarios AS U ON R.ID_Usuario = U.ID
	WHERE U.DNI = @DNI AND CURRENT_TIMESTAMP < R.Fecha_Hora

	DELETE Reservas FROM Reservas AS R
	INNER JOIN Usuarios AS U ON R.ID_Usuario = U.ID
	WHERE U.DNI = @DNI AND CURRENT_TIMESTAMP < R.Fecha_Hora
END
GO

EXECUTE EliminarUsuario '59544420G'

/*
INTERFAZ
Nombre: EstaAlquilado
Cabecera: CREATE PROCEDURE EstaAlquilado @CodigoInstalacion INT, @Fecha SMALLDATETIME, @IDUsuario CHAR(12) OUTPUT AS
Entrada: @CodigoInstalacion INT, @Fecha SMALLDATETIME
Salida: @IDUsuario CHAR(12)
*/
--2. Escribe un procedimiento que reciba como parámetros el código de una instalación y una fecha/hora (SmallDateTime) y 
--devuelva en otro parámetro de salida el ID del usuario que la tenía alquilada si en ese 
--momento la instalación estaba ocupada. Si estaba libre, devolverá un NULL.
GO
CREATE PROCEDURE EstaAlquilado 
	@CodigoInstalacion INT,
	@Fecha SMALLDATETIME,
	@IDUsuario CHAR(12) OUTPUT AS
	BEGIN
		SELECT  @IDUsuario = R.ID_Usuario  FROM Reservas AS R
		WHERE R.Fecha_Hora = @Fecha AND @CodigoInstalacion = R.Cod_Instalacion
	END
GO
DECLARE @IDUsuario CHAR(12)
EXECUTE EstaAlquilado 1, '2020-12-12 15:00:00', @IDUsuario OUTPUT
SELECT @IDUsuario

/*
INTERFAZ
Nombre: EstaAlquilado
Cabecera: CREATE PROCEDURE NumeroHorasInstalacion @CodigoInstalacion INT, @FechaInicial DATE, @FechaFinal DATE,	@Horas INT OUTPUT AS 
Entrada: @CodigoInstalacion INT, @FechaInicial DATE, @FechaFinal DATE,
Salida: @Horas INT
*/
--3. Escribe un procedimiento que reciba como parámetros el código de una instalación y dos fechas (DATE) y 
--devuelva en otro parámetro de salida el número de horas que esa instalación ha estado alquilada entre esas dos fechas, 
--ambas incluidas. Si se omite la segunda fecha, se tomará la actual con GETDATE().
--Devuelve con return códigos de error si el código de la instalación es erróneo  o si la fecha de inicio es posterior a la de fin.
--Hay una clausula tiempo que te dice cuanto tiempo se ha llevado alquilado la pista

--Modificar los varios returns
SELECT * FROM Reservas
GO
CREATE PROCEDURE NumeroHorasInstalacion
	@CodigoInstalacion INT,
	@FechaInicial DATE,
	@FechaFinal DATE,
	@Horas INT OUTPUT AS 
	BEGIN 
		IF @CodigoInstalacion <> (SELECT Cod_Instalacion FROM Reservas)
		BEGIN
			RETURN -1
		END
		ELSE IF @FechaInicial > @FechaFinal
			 BEGIN 
				RETURN -2
			 END
			 ELSE IF @FechaFinal = NULL
					BEGIN
						SELECT @Horas = DATEDIFF(HH, @FechaInicial, GETDATE()) FROM Reservas
						WHERE @FechaInicial < GETDATE() AND @CodigoInstalacion = Cod_Instalacion
						RETURN @Horas
					END
						ELSE IF @FechaFinal <> NULL
						BEGIN
							SELECT @Horas = DATEDIFF(HH, @FechaInicial, @FechaFinal) FROM Reservas
							WHERE @FechaInicial < @FechaFinal AND @CodigoInstalacion = Cod_Instalacion
							RETURN @Horas
						END
	END
GO
/*
INTERFAZ
Nombre: EfectuarReserva
Cabecera: CREATE PROCEDURE EfectuarReserva @DNI CHAR(9), @CodigoInstalacion INT, @FechaInicial SMALLDATETIME, @FechaFinal SMALLDATETIME, @CodigoReserva INT OUTPUT AS 
Entrada: @DNI CHAR(9), @CodigoInstalacion INT, @FechaInicial SMALLDATETIME, @FechaFinal SMALLDATETIME
Salida: @CodigoReserva INT
*/
--4. Escribe un procedimiento EfectuarReserva que reciba como parámetro el DNI de un usuario, el código de la instalación, 
--la fecha/hora de inicio de la reserva y la fecha/hora final.
--El procedimiento comprobará que los datos de entradas son correctos y grabará la correspondiente reserva. 
--Devolverá el código de reserva generado mediante un parámetro de salida. 
--Para obtener el valor generado usar la función @@identity tras el INSERT.
--Devuelve un cero si la operación se realiza con éxito y un código de error según la lista siguiente:
--3: La instalación está ocupada para esa fecha y hora
--4: El código de la instalación es incorrecto
--5: El usuario no existe
--8: La fecha/hora de inicio del alquiler es posterior a la de fin
--11: La fecha de inicio y de fin son diferentes
SELECT * FROM Reservas
SELECT * FROM Instalaciones
GO

ALTER PROCEDURE EfectuarReserva
	@DNI CHAR(9),
	@CodigoInstalacion INT,
	@FechaInicial SMALLDATETIME,
	@FechaFinal SMALLDATETIME,
	@CodigoReserva INT OUTPUT AS 
	BEGIN
	DECLARE @CodigoError INT 
		IF NOT EXISTS (SELECT Codigo FROM Instalaciones WHERE @CodigoInstalacion = Codigo) 
		BEGIN
			SET @CodigoError = 4
		END
		ELSE IF NOT EXISTS (SELECT DNI FROM Usuarios WHERE @DNI = DNI)
			 BEGIN
				SET @CodigoError = 5
			 END
			 ELSE IF @FechaInicial > @FechaFinal
				  BEGIN
					 SET @CodigoError = 8
				  END
				  ELSE IF DAY(@FechaInicial) <> DAY(@FechaFinal)
					   BEGIN
						  SET @CodigoError = 11
					   END
					   ELSE IF EXISTS (SELECT * FROM Reservas WHERE Fecha_Hora < @FechaInicial AND DATEADD(HH,Fecha_Hora,Tiempo) > @FechaFinal AND Fecha_Hora NOT BETWEEN @FechaInicial AND @FechaFinal AND DATEADD(HH,Fecha_Hora,Tiempo) NOT BETWEEN @FechaInicial AND @FechaFinal AND @CodigoInstalacion = Cod_Instalacion)
					   BEGIN
						  SET @CodigoError = 3
					   END
						   ELSE
						   BEGIN
								INSERT Reservas (Tiempo, Fecha_Hora, ID_Usuario, Cod_Instalacion)
								VALUES (DATEDIFF(HH, @FechaInicial,@FechaFinal), @FechaInicial, (SELECT ID FROM Usuarios AS U WHERE U.ID = @DNI), @CodigoInstalacion)
								SET @CodigoError = 0
								SET @CodigoReserva = @@IDENTITY
						   END
	RETURN @CodigoError
	END
GO

BEGIN TRANSACTION
DECLARE @Error INT
DECLARE @CodigoReserva INT
EXECUTE @Error =  EfectuarReserva '59544420G', 1, '2019-04-22 10:44', '2019-04-22 12:44', @CodigoReserva OUTPUT

SELECT @Error, @CodigoReserva
SELECT * FROM Reservas
--ROLLBACK
--COMMIT

--SELECT * FROM Instalaciones
--SELECT * FROM Materiales
--SELECT * FROM Reservas
--SELECT * FROM Usuarios
--SELECT * FROM ReservasMateriales