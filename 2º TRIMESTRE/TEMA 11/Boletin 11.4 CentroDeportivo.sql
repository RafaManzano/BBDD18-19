USE CentroDeportivo
--Hacer las interfaces de las funciones, POR DIOS

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

--3. Escribe un procedimiento que reciba como par�metros el c�digo de una instalaci�n y dos fechas (DATE) y devuelva en otro par�metro de salida 
--el n�mero de horas que esa instalaci�n ha estado alquilada entre esas dos fechas, ambas incluidas. 
--Si se omite la segunda fecha, se tomar� la actual con GETDATE().
--Devuelve con return c�digos de error si el c�digo de la instalaci�n es err�neo  o si la fecha de inicio es posterior a la de fin.