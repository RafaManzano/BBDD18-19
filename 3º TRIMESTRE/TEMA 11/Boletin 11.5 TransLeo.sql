USE TransLeo

--1. Crea un funci�n fn_VolumenPaquete que reciba el c�digo de un paquete y nos devuelva
--su volumen. El volumen se expresa en litros (dm3) y ser� de tipo decimal(6,2).
SELECT * FROM TL_PaquetesNormales
GO
CREATE FUNCTION FN_VolumenPaquete (@CodigoPaquete INT)
RETURNS DECIMAL AS
BEGIN
	DECLARE @Volumen DECIMAL (6,2)
	SELECT @Volumen = CAST((Alto * Ancho * Largo) AS DECIMAL (15,2)) FROM TL_PaquetesNormales
	WHERE Codigo = @CodigoPaquete
	RETURN @Volumen
END
GO

BEGIN TRANSACTION 
EXECUTE dbo.FN_VolumenPaquete 600
PRINT dbo.FN_VolumenPaquete
--ROLLBACK
--COMMIT

--2. Los paquetes normales han de envolverse. Se calcula que la cantidad de papel necesaria
--para envolver el paquete es 1,8 veces su superficie. Crea una funci�n fn_PapelEnvolver
--que reciba un c�digo de paquete y nos devuelva la cantidad de papel necesaria para
--envolverlo, en metros cuadrados.
GO
CREATE FUNCTION FN_PapelEnvolver  (@CodigoPaquete INT)
RETURNS DECIMAL AS
BEGIN
	DECLARE @Papel  DECIMAL (6,2)
	SELECT @Papel = CAST((Alto * Ancho * 1.8) AS DECIMAL(6,2)) FROM TL_PaquetesNormales
	WHERE Codigo = @CodigoPaquete
	RETURN @Papel
END
GO

BEGIN TRANSACTION 
EXECUTE dbo.FN_PapelEnvolver 600 
--ROLLBACK
--COMMIT

--3. Crea una funci�n fn_OcupacionFregoneta a la que se pase el c�digo de un veh�culo y una
--fecha y nos indique cu�l es el volumen total que ocupan los paquetes que ese veh�culo
--entreg� en el d�a en cuesti�n. Usa las funciones de fecha y hora para comparar s�lo el
--d�a, independientemente de la hora.
GO
CREATE FUNCTION FN_OcupacionFregoneta (@CodigoFurgona INT, @Fecha DATE) 
RETURNS DECIMAL AS
BEGIN 
	DECLARE @Volumen DECIMAL(6,2)
	SELECT @Volumen = CAST((Alto * Ancho * Largo) AS DECIMAL(6,2)) FROM TL_PaquetesNormales
	WHERE codigoFregoneta = @CodigoFurgona AND DAY(fechaEntrega) = DAY(@Fecha)
	RETURN @Volumen
END
GO

BEGIN TRANSACTION
DECLARE @Volumen DECIMAL(6,2) 
EXECUTE dbo.FN_OcupacionFregoneta 6, '2017,5,1'
--ROLLBACK
--COMMIT

--4. Crea una funci�n fn_CuantoPapel a la que se pase una fecha y nos diga la cantidad total
--de papel de envolver que se gast� para los paquetes entregados ese d�a. Trata la fecha
--igual que en el anterior
GO
CREATE FUNCTION FN_CuantoPapel (@Fecha SMALLDATETIME) 
RETURNS INT AS
BEGIN
	DECLARE @Total INT
	SELECT @Total = COUNT(Codigo) FROM TL_PaquetesNormales
	WHERE fechaEntrega = @Fecha
	RETURN @Total
END
GO

BEGIN TRANSACTION 
EXECUTE dbo.FN_CuantoPapel '2017,5,1'
--ROLLBACK
--COMMIT

--5. Modifica la funci�n anterior para que en lugar de aceptar una fecha, acepte un rango de
--fechas (inicio y fin). Si el inicio y fin son iguales, calcular� la cantidad gastada ese d�a. Si
--el fin es anterior al inicio devolver� 0.
GO
CREATE FUNCTION FN_CuantoPapel_Modificada (@FechaInicio SMALLDATETIME, @FechaFin SMALLDATETIME) 
RETURNS INT AS
BEGIN
	DECLARE @Total INT
	IF @FechaInicio = @FechaFin 
	BEGIN
		SET @Total = 0
	END
	ELSE
	BEGIN
		SELECT @Total = COUNT(Codigo) FROM TL_PaquetesNormales
		WHERE fechaEntrega BETWEEN @FechaInicio AND @FechaFin
	END
	RETURN @Total
END
GO

BEGIN TRANSACTION 
EXECUTE dbo.FN_CuantoPapel_Modificada '2017,5,1','2017,5,1'
--ROLLBACK
--COMMIT

--6. Crea una funci�n fn_Entregas a la que se pase un rango de fechas y nos devuelva una
--tabla con los c�digos de los paquetes entregados y los veh�culos que los entregaron entre
--esas fechas.
GO
CREATE FUNCTION FN_Entregas (@FechaInicio SMALLDATETIME, @FechaFin SMALLDATETIME)
RETURNS @Tabla TABLE (CodigoPaquete INT NOT NULL,
					  Vehiculo INT NOT NULL) AS
BEGIN
	INSERT INTO @Tabla (CodigoPaquete, Vehiculo)
	(SELECT Codigo, codigoFregoneta FROM TL_PaquetesNormales
     WHERE fechaEntrega BETWEEN @FechaInicio AND @FechaFin)
	 RETURN
END
GO

BEGIN TRANSACTION
--EXECUTE dbo.FN_Entregas '2017,5,1','2017,5,1'
--ROLLBACK
--COMMIT