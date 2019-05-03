--Examen
USE LEO

--1. Escribe un procedimiento ContratarTrabajadorFullTime que reciba como entrada el ID de un trabajador y el ID y número de una 
--solicitud y cree un contrato para ese trabajador de acuerdo a la solicitud. La fecha de inicio será la actual, 
--la fecha de fin se calculará teniendo en cuenta la duración (en meses) que se pasará también como parámetro. 
--El sueldo se tomará de la solicitud. El número de horas semanales será 40.
--El procedimiento devolverá el ID del contrato como parámetro de salida.

/*
Interfaz
Nombre: ContratarTrabajadorFullTime
Cabecera: CREATE PROCEDURE @IDTrabajador INT, @IDCliente SMALLINT, @NumeroSolicitud INT, @Duracion INT, @IDContrato UNIQUEIDENTIFIER OUTPUT
Precondiciones: Los parametros deben ser correctos
Entrada: - @IDTrabajador INT //El ID de un trabajador
		 - @IDCliente SMALLINT //El id del cliente que esta asociada al trabajador
		 - @NumeroSolicitud INT //El la solicitud 
		 - @Duracion INT //Es la duracion en meses
Salida: - @IDContrato UNIQUEIDENTIFIER
Postcondiciones: Se creara un nuevo contrato para el trabajador y se devolvera el ID del contrato
*/
SELECT * FROM Contratos
SELECT * FROM Solicitudes
SELECT * FROM Currantes

GO
CREATE PROCEDURE ContratarTrabajadorFullTime
	@IDTrabajador INT,
	@IDCliente SMALLINT,
	@NumeroSolicitud INT,
	@Duracion INT,
	@IDContrato UNIQUEIDENTIFIER OUTPUT AS

	SET @IDContrato = NEWID()

	INSERT Contratos (ID, IDEmpresa, IDTrabajador, FechaAlta, FechaFin, HorasSemana, Salario)
	SELECT @IDContrato, @IDCliente, @IDTrabajador, CURRENT_TIMESTAMP, DATEADD(MONTH, @Duracion, CAST(CURRENT_TIMESTAMP AS SMALLDATETIME)), 40, Salario
	FROM Solicitudes AS S
	WHERE Numero = @NumeroSolicitud AND IDCliente = @IDCliente
	
GO

--Test
BEGIN TRANSACTION
DECLARE @ID UNIQUEIDENTIFIER
EXECUTE ContratarTrabajadorFullTime 1,1,4,6,@ID OUTPUT
PRINT @ID
--ROLLBACK
--COMMIT

--Test
BEGIN TRANSACTION
DECLARE @ID UNIQUEIDENTIFIER
EXECUTE ContratarTrabajadorFullTime 2,2,1,12,@ID OUTPUT
PRINT @ID
--ROLLBACK
--COMMIT


--2. Queremos determinar el grado de idoneidad de los currantes para una solicitud concreta.
--Para ello queremos una función que devuelva una tabla. A la función pasaremos como parámetros el ID de una empresa y 
--el número de una solicitud. También se pasarán dos números enteros que serán la edad mínima y máxima para ese puesto. 
--Queremos que la función nos devuelva una tabla con las siguientes columnas: ID del trabajador, Nombre, apellidos e índice de idoneidad 
--para el puesto.

--El índice de idoneidad de un trabajador se calcula del modo siguiente:
	--Por cada cualificación que posea el trabajador y esté asociada a la solicitud se le asignarán diez puntos
	--Por cada cualificación que posea el trabajador y no esté asociada a esa solicitud, pero sí a otras solicitudes de la misma empresa 
	--se le asignarán cinco puntos.
	--Por cada cualificación del trabajador que no figure en ninguna solicitud de la misma empresa se le asignarán dos puntos.
	--Si el trabajador ha mostrado interés en la solicitud se sumarán 15 puntos.
	--Si el trabajador ha tenido con anterioridad un contrato con la misma empresa se incrementará el resultado un 20%
	--Los trabajadores cuya edad no está comprendida entre los límites quedarán excluidos.

/*
Interfaz
Nombre: CurrantesIdoneos
Cabecera: CREATE FUNCTION CurrantesIdoneos @IDCliente SMALLINT, @NumeroSolicitud INT, @EdadMinima INT, @EdadMaxima INT
Precondiciones: Los parametros de entrada deben ser correctos
Entrada: - @IDCliente SMALLINT
		 - @NumeroSolicitud INT
		 - @EdadMinima INT 
		 - @EdadMaxima INT
Salida: - @ BuenosTrabajadores TABLE
Postcondiciones: Se devolvera una tabla con los trabajadores y su indice de ser idoneos segun el trabajo
*/

GO
ALTER FUNCTION CurrantesIdoneos (@IDCliente SMALLINT, @NumeroSolicitud INT, @EdadMinima INT, @EdadMaxima INT)
RETURNS @BuenosTrabajadores TABLE(
	IDTrabajador INT NOT NULL,
	Nombre VARCHAR(15) NULL,
	Apellidos VARCHAR(30) NULL,
	IndiceIdoneidad SMALLINT NULL) AS
	BEGIN
	DECLARE @Idoneo SMALLINT
	SET @Idoneo = 0
	--En todas las opciones siempre se excluyen a los mayores y los menores del rango de edad especificado por parametro
	--Por cada cualificación que posea el trabajador y esté asociada a la solicitud se le asignarán diez puntos
		IF EXISTS (SELECT * FROM Currantes AS CU 
			INNER JOIN CurranteCualificacion AS CC ON CU.ID = CC.IDCurrante
			INNER JOIN Cualificaciones AS C ON CC.IDCualificacion = C.ID
			INNER JOIN SolicitudCualificacion AS SC ON C.ID = SC.IDCualificacion
			INNER JOIN Solicitudes AS S ON SC.NumeroSolicitud = @NumeroSolicitud AND SC.IDClienteSolicitud = @IDCliente 
			WHERE DATEDIFF(Year,FechaNacimiento,CURRENT_TIMESTAMP) BETWEEN @EdadMinima AND @EdadMaxima)
			BEGIN
				SET @Idoneo += 10 
			END

		--Por cada cualificación que posea el trabajador y no esté asociada a esa solicitud, pero sí a otras solicitudes de la misma empresa
		--se le asignarán cinco puntos. 
		IF EXISTS (SELECT cu.ID FROM Currantes AS CU 
			INNER JOIN CurranteCualificacion AS CC ON CU.ID = CC.IDCurrante
			INNER JOIN Cualificaciones AS C ON CC.IDCualificacion = C.ID
			INNER JOIN SolicitudCualificacion AS SC ON C.ID = SC.IDCualificacion
			INNER JOIN Solicitudes AS S ON SC.NumeroSolicitud = @NumeroSolicitud AND SC.IDClienteSolicitud = @IDCliente 
			WHERE DATEDIFF(Year,FechaNacimiento,CURRENT_TIMESTAMP) BETWEEN @EdadMinima AND @EdadMaxima)
			BEGIN
				SET @Idoneo += 5
			END

		--Por cada cualificación del trabajador que no figure en ninguna solicitud de la misma empresa se le asignarán dos puntos.
		IF EXISTS (SELECT * FROM Currantes AS CU 
				INNER JOIN CurranteCualificacion AS CC ON CU.ID = CC.IDCurrante
				INNER JOIN Cualificaciones AS C ON CC.IDCualificacion = C.ID
				INNER JOIN SolicitudCualificacion AS SC ON C.ID = SC.IDCualificacion
				INNER JOIN Solicitudes AS S ON SC.NumeroSolicitud = @NumeroSolicitud AND SC.IDClienteSolicitud = @IDCliente 
				WHERE DATEDIFF(Year,FechaNacimiento,CURRENT_TIMESTAMP) BETWEEN @EdadMinima AND @EdadMaxima)
				BEGIN
					SET @Idoneo += 2
				END

		--Si el trabajador ha mostrado interés en la solicitud se sumarán 15 puntos.
		IF EXISTS (SELECT * FROM Currantes AS CU 
				INNER JOIN CurranteSolicitud AS CS ON CU.ID = CS.IDCurrante
				WHERE DATEDIFF(Year,FechaNacimiento,CURRENT_TIMESTAMP) BETWEEN @EdadMinima AND @EdadMaxima AND CS.NumeroSolicitud = @NumeroSolicitud)
				BEGIN 
					SET @Idoneo += 15
				END
		--Si el trabajador ha tenido con anterioridad un contrato con la misma empresa se incrementará el resultado un 20%
		IF EXISTS (SELECT * FROM Currantes AS CU 
					INNER JOIN Contratos AS C ON CU.ID = C.IDTrabajador
					WHERE DATEDIFF(Year,FechaNacimiento,CURRENT_TIMESTAMP) BETWEEN @EdadMinima AND @EdadMaxima AND C.IDEmpresa = @IDCliente)
					BEGIN 
						SET @Idoneo *= 1.2
					END
	
		INSERT @BuenosTrabajadores (IDTrabajador, Nombre, Apellidos, IndiceIdoneidad)
		SELECT ID, Nombre, Apellidos, @Idoneo FROM Currantes

	RETURN
	END
GO

--Select para las comprobaciones
--SELECT * FROM Currantes
--SELECT * FROM Solicitudes
--Test
SELECT * FROM dbo.CurrantesIdoneos(1,1,20,30)

/*
Al llegar aqui me he dado cuenta que habia que recorrer la tabla, pruebo con la v2
*/

--Ejercicio 2 v2
GO
ALTER FUNCTION CurrantesIdoneosV2 (@IDCliente SMALLINT, @NumeroSolicitud INT, @EdadMinima INT, @EdadMaxima INT)
RETURNS @BuenosTrabajadores TABLE(
	IDTrabajador INT NOT NULL,
	Nombre VARCHAR(15) NULL,
	Apellidos VARCHAR(30) NULL,
	IndiceIdoneidad SMALLINT NULL) AS
	BEGIN
	DECLARE @ID INT 
	SET @ID = (SELECT TOP 1 ID FROM Currantes)
	--BEGIN TRANSACTION
	SELECT @ID = MIN(ID) FROM Currantes 
	WHILE @ID IS NOT NULL
	BEGIN
	DECLARE @Idoneo SMALLINT
	SET @Idoneo = 0

	--Por cada cualificación que posea el trabajador y esté asociada a la solicitud se le asignarán diez puntos
		IF EXISTS (SELECT * FROM Currantes AS CU 
			INNER JOIN CurranteCualificacion AS CC ON CU.ID = CC.IDCurrante
			INNER JOIN Cualificaciones AS C ON CC.IDCualificacion = C.ID
			INNER JOIN SolicitudCualificacion AS SC ON C.ID = SC.IDCualificacion
			INNER JOIN Solicitudes AS S ON SC.NumeroSolicitud = @NumeroSolicitud AND SC.IDClienteSolicitud = @IDCliente 
			WHERE @ID = CU.ID)
			BEGIN
				SET @Idoneo += 10 
			END

		--Por cada cualificación que posea el trabajador y no esté asociada a esa solicitud, pero sí a otras solicitudes de la misma empresa
		--se le asignarán cinco puntos. 
		IF EXISTS (SELECT * FROM Currantes AS CU 
			INNER JOIN CurranteCualificacion AS CC ON CU.ID = CC.IDCurrante
			INNER JOIN Cualificaciones AS C ON CC.IDCualificacion = C.ID
			INNER JOIN SolicitudCualificacion AS SC ON C.ID = SC.IDCualificacion
			INNER JOIN Solicitudes AS S ON SC.NumeroSolicitud = @NumeroSolicitud AND SC.IDClienteSolicitud = @IDCliente 
			WHERE @ID = CU.ID)
			BEGIN
				SET @Idoneo += 5
			END

		--Por cada cualificación del trabajador que no figure en ninguna solicitud de la misma empresa se le asignarán dos puntos.
		IF EXISTS (SELECT * FROM Currantes AS CU 
				INNER JOIN CurranteCualificacion AS CC ON CU.ID = CC.IDCurrante
				INNER JOIN Cualificaciones AS C ON CC.IDCualificacion = C.ID
				INNER JOIN SolicitudCualificacion AS SC ON C.ID = SC.IDCualificacion
				INNER JOIN Solicitudes AS S ON SC.NumeroSolicitud = @NumeroSolicitud AND SC.IDClienteSolicitud = @IDCliente 
				WHERE @ID = CU.ID)
				BEGIN
					SET @Idoneo += 2
				END

		--Si el trabajador ha mostrado interés en la solicitud se sumarán 15 puntos.
		IF EXISTS (SELECT * FROM Currantes AS CU 
				INNER JOIN CurranteSolicitud AS CS ON CU.ID = CS.IDCurrante
				WHERE CS.NumeroSolicitud = @NumeroSolicitud AND @ID = CU.ID)
				BEGIN 
					SET @Idoneo += 15
				END
		--Si el trabajador ha tenido con anterioridad un contrato con la misma empresa se incrementará el resultado un 20%
		IF EXISTS (SELECT * FROM Currantes AS CU 
					INNER JOIN Contratos AS C ON CU.ID = C.IDTrabajador
					WHERE C.IDEmpresa = @IDCliente AND @ID = CU.ID)
					BEGIN 
						SET @Idoneo *= 1.2
					END
	
		--Aqui es donde no se introducen los trabajadores que salgan del rango de fechas 
		INSERT @BuenosTrabajadores (IDTrabajador, Nombre, Apellidos, IndiceIdoneidad)
		SELECT ID, Nombre, Apellidos, @Idoneo FROM Currantes
		WHERE ID = @ID AND DATEDIFF(Year,FechaNacimiento,CURRENT_TIMESTAMP) BETWEEN @EdadMinima AND @EdadMaxima

		SELECT @ID = MIN(ID) FROM Currantes 
		WHERE @ID < ID
	END
	RETURN
END
GO

--Select para las comprobaciones
--SELECT * FROM Currantes
--SELECT * FROM Solicitudes
--Test
SELECT * FROM dbo.CurrantesIdoneosV2(1,1,20,30)
SELECT * FROM dbo.CurrantesIdoneosV2(2,2,10,80)
SELECT * FROM dbo.CurrantesIdoneosV2(3,1,10,15)
SELECT * FROM dbo.CurrantesIdoneosV2(5,3,10,40)

--Creo que algun if esta equivocado, pero estoy bastante cerca de la solucion
--Los resultados no son convincentes para mi, he revisado los ifs pero a simple vista no veo error
--Ya no hay tiempo asi que espero que este medianamente correcto