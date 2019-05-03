--Examen
USE LEO

--1. Escribe un procedimiento ContratarTrabajadorFullTime que reciba como entrada el ID de un trabajador y el ID y n�mero de una 
--solicitud y cree un contrato para ese trabajador de acuerdo a la solicitud. La fecha de inicio ser� la actual, 
--la fecha de fin se calcular� teniendo en cuenta la duraci�n (en meses) que se pasar� tambi�n como par�metro. 
--El sueldo se tomar� de la solicitud. El n�mero de horas semanales ser� 40.
--El procedimiento devolver� el ID del contrato como par�metro de salida.

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
--Para ello queremos una funci�n que devuelva una tabla. A la funci�n pasaremos como par�metros el ID de una empresa y 
--el n�mero de una solicitud. Tambi�n se pasar�n dos n�meros enteros que ser�n la edad m�nima y m�xima para ese puesto. 
--Queremos que la funci�n nos devuelva una tabla con las siguientes columnas: ID del trabajador, Nombre, apellidos e �ndice de idoneidad 
--para el puesto.

--El �ndice de idoneidad de un trabajador se calcula del modo siguiente:
	--Por cada cualificaci�n que posea el trabajador y est� asociada a la solicitud se le asignar�n diez puntos
	--Por cada cualificaci�n que posea el trabajador y no est� asociada a esa solicitud, pero s� a otras solicitudes de la misma empresa 
	--se le asignar�n cinco puntos.
	--Por cada cualificaci�n del trabajador que no figure en ninguna solicitud de la misma empresa se le asignar�n dos puntos.
	--Si el trabajador ha mostrado inter�s en la solicitud se sumar�n 15 puntos.
	--Si el trabajador ha tenido con anterioridad un contrato con la misma empresa se incrementar� el resultado un 20%
	--Los trabajadores cuya edad no est� comprendida entre los l�mites quedar�n excluidos.

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
	--Por cada cualificaci�n que posea el trabajador y est� asociada a la solicitud se le asignar�n diez puntos
		IF EXISTS (SELECT * FROM Currantes AS CU 
			INNER JOIN CurranteCualificacion AS CC ON CU.ID = CC.IDCurrante
			INNER JOIN Cualificaciones AS C ON CC.IDCualificacion = C.ID
			INNER JOIN SolicitudCualificacion AS SC ON C.ID = SC.IDCualificacion
			INNER JOIN Solicitudes AS S ON SC.NumeroSolicitud = @NumeroSolicitud AND SC.IDClienteSolicitud = @IDCliente 
			WHERE DATEDIFF(Year,FechaNacimiento,CURRENT_TIMESTAMP) BETWEEN @EdadMinima AND @EdadMaxima)
			BEGIN
				SET @Idoneo += 10 
			END

		--Por cada cualificaci�n que posea el trabajador y no est� asociada a esa solicitud, pero s� a otras solicitudes de la misma empresa
		--se le asignar�n cinco puntos. 
		IF EXISTS (SELECT cu.ID FROM Currantes AS CU 
			INNER JOIN CurranteCualificacion AS CC ON CU.ID = CC.IDCurrante
			INNER JOIN Cualificaciones AS C ON CC.IDCualificacion = C.ID
			INNER JOIN SolicitudCualificacion AS SC ON C.ID = SC.IDCualificacion
			INNER JOIN Solicitudes AS S ON SC.NumeroSolicitud = @NumeroSolicitud AND SC.IDClienteSolicitud = @IDCliente 
			WHERE DATEDIFF(Year,FechaNacimiento,CURRENT_TIMESTAMP) BETWEEN @EdadMinima AND @EdadMaxima)
			BEGIN
				SET @Idoneo += 5
			END

		--Por cada cualificaci�n del trabajador que no figure en ninguna solicitud de la misma empresa se le asignar�n dos puntos.
		IF EXISTS (SELECT * FROM Currantes AS CU 
				INNER JOIN CurranteCualificacion AS CC ON CU.ID = CC.IDCurrante
				INNER JOIN Cualificaciones AS C ON CC.IDCualificacion = C.ID
				INNER JOIN SolicitudCualificacion AS SC ON C.ID = SC.IDCualificacion
				INNER JOIN Solicitudes AS S ON SC.NumeroSolicitud = @NumeroSolicitud AND SC.IDClienteSolicitud = @IDCliente 
				WHERE DATEDIFF(Year,FechaNacimiento,CURRENT_TIMESTAMP) BETWEEN @EdadMinima AND @EdadMaxima)
				BEGIN
					SET @Idoneo += 2
				END

		--Si el trabajador ha mostrado inter�s en la solicitud se sumar�n 15 puntos.
		IF EXISTS (SELECT * FROM Currantes AS CU 
				INNER JOIN CurranteSolicitud AS CS ON CU.ID = CS.IDCurrante
				WHERE DATEDIFF(Year,FechaNacimiento,CURRENT_TIMESTAMP) BETWEEN @EdadMinima AND @EdadMaxima AND CS.NumeroSolicitud = @NumeroSolicitud)
				BEGIN 
					SET @Idoneo += 15
				END
		--Si el trabajador ha tenido con anterioridad un contrato con la misma empresa se incrementar� el resultado un 20%
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

	--Por cada cualificaci�n que posea el trabajador y est� asociada a la solicitud se le asignar�n diez puntos
		IF EXISTS (SELECT * FROM Currantes AS CU 
			INNER JOIN CurranteCualificacion AS CC ON CU.ID = CC.IDCurrante
			INNER JOIN Cualificaciones AS C ON CC.IDCualificacion = C.ID
			INNER JOIN SolicitudCualificacion AS SC ON C.ID = SC.IDCualificacion
			INNER JOIN Solicitudes AS S ON SC.NumeroSolicitud = @NumeroSolicitud AND SC.IDClienteSolicitud = @IDCliente 
			WHERE @ID = CU.ID)
			BEGIN
				SET @Idoneo += 10 
			END

		--Por cada cualificaci�n que posea el trabajador y no est� asociada a esa solicitud, pero s� a otras solicitudes de la misma empresa
		--se le asignar�n cinco puntos. 
		IF EXISTS (SELECT * FROM Currantes AS CU 
			INNER JOIN CurranteCualificacion AS CC ON CU.ID = CC.IDCurrante
			INNER JOIN Cualificaciones AS C ON CC.IDCualificacion = C.ID
			INNER JOIN SolicitudCualificacion AS SC ON C.ID = SC.IDCualificacion
			INNER JOIN Solicitudes AS S ON SC.NumeroSolicitud = @NumeroSolicitud AND SC.IDClienteSolicitud = @IDCliente 
			WHERE @ID = CU.ID)
			BEGIN
				SET @Idoneo += 5
			END

		--Por cada cualificaci�n del trabajador que no figure en ninguna solicitud de la misma empresa se le asignar�n dos puntos.
		IF EXISTS (SELECT * FROM Currantes AS CU 
				INNER JOIN CurranteCualificacion AS CC ON CU.ID = CC.IDCurrante
				INNER JOIN Cualificaciones AS C ON CC.IDCualificacion = C.ID
				INNER JOIN SolicitudCualificacion AS SC ON C.ID = SC.IDCualificacion
				INNER JOIN Solicitudes AS S ON SC.NumeroSolicitud = @NumeroSolicitud AND SC.IDClienteSolicitud = @IDCliente 
				WHERE @ID = CU.ID)
				BEGIN
					SET @Idoneo += 2
				END

		--Si el trabajador ha mostrado inter�s en la solicitud se sumar�n 15 puntos.
		IF EXISTS (SELECT * FROM Currantes AS CU 
				INNER JOIN CurranteSolicitud AS CS ON CU.ID = CS.IDCurrante
				WHERE CS.NumeroSolicitud = @NumeroSolicitud AND @ID = CU.ID)
				BEGIN 
					SET @Idoneo += 15
				END
		--Si el trabajador ha tenido con anterioridad un contrato con la misma empresa se incrementar� el resultado un 20%
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