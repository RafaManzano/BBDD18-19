USE CentroDeportivo
/*
INTERFAZ
Nombre: EliminarUsuario
Cabecera: CREATE PROCEDURE EliminarUsuario @DNI CHAR(9)
Entrada: DNI CHAR
Salida: No hay
*/
--1. Escribe un procedimiento EliminarUsuario que reciba como par�metro el DNI de un usuario, 
--le coloque un NULL en la columna Sex y borre todas las reservas futuras de ese usuario. 
--Ten en cuenta que si alguna de esas reservas tiene asociado un alquiler de material habr� que borrarlo tambi�n.
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
--2. Escribe un procedimiento que reciba como par�metros el c�digo de una instalaci�n y una fecha/hora (SmallDateTime) y 
--devuelva en otro par�metro de salida el ID del usuario que la ten�a alquilada si en ese 
--momento la instalaci�n estaba ocupada. Si estaba libre, devolver� un NULL.
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
--3. Escribe un procedimiento que reciba como par�metros el c�digo de una instalaci�n y dos fechas (DATE) y 
--devuelva en otro par�metro de salida el n�mero de horas que esa instalaci�n ha estado alquilada entre esas dos fechas, 
--ambas incluidas. Si se omite la segunda fecha, se tomar� la actual con GETDATE().
--Devuelve con return c�digos de error si el c�digo de la instalaci�n es err�neo  o si la fecha de inicio es posterior a la de fin.
--Hay una clausula tiempo que te dice cuanto tiempo se ha llevado alquilado la pista
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
--4. Escribe un procedimiento EfectuarReserva que reciba como par�metro el DNI de un usuario, el c�digo de la instalaci�n, 
--la fecha/hora de inicio de la reserva y la fecha/hora final.
--El procedimiento comprobar� que los datos de entradas son correctos y grabar� la correspondiente reserva. 
--Devolver� el c�digo de reserva generado mediante un par�metro de salida. 
--Para obtener el valor generado usar la funci�n @@identity tras el INSERT.
--Devuelve un cero si la operaci�n se realiza con �xito y un c�digo de error seg�n la lista siguiente:
--3: La instalaci�n est� ocupada para esa fecha y hora
--4: El c�digo de la instalaci�n es incorrecto
--5: El usuario no existe
--8: La fecha/hora de inicio del alquiler es posterior a la de fin
--11: La fecha de inicio y de fin son diferentes
SELECT * FROM Reservas
SELECT * FROM Instalaciones
GO
--Este no esta correcto faltan cosas
CREATE PROCEDURE EfectuarReserva
	@DNI CHAR(9),
	@CodigoInstalacion INT,
	@FechaInicial SMALLDATETIME,
	@FechaFinal SMALLDATETIME,
	@CodigoReserva INT OUTPUT AS 
	BEGIN 
		IF @CodigoInstalacion <> (SELECT Cod_Instalacion FROM Reservas)
		BEGIN
			SET @CodigoReserva = 4
		END
		ELSE IF @DNI <> (SELECT DNI FROM Usuarios)
			 BEGIN
				SET @CodigoReserva = 5
			 END
			 ELSE IF @FechaInicial > @FechaFinal
				  BEGIN
					 SET @CodigoReserva = 8
				  END
				  ELSE IF DAY(@FechaInicial) <> DAY(@FechaFinal)
					   BEGIN
						  SET @CodigoReserva = 11
					   END
					   ELSE IF --SELECT * FROM Reservas
					           --WHERE @FechaInicial
	END
GO
