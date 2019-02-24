USE LeoMetro
SET Dateformat 'ymd'
GO

------------------------------------------- EJEMPLO FUNCION INLINE -----------------------------------------------
-- 1. Crea una función inline que nos devuelva el número de estaciones que ha recorrido cada tren en un
--    determinado periodo de tiempo. El principio y el fin de ese periodo se pasarán como parámetros

-- Creamos la funcion inline
GO
CREATE FUNCTION dbo.calcularNumeroEstacionesRecorridasPorCadaTren (@inicio DateTime, @fin DateTime)
RETURNS TABLE AS
RETURN 
(
	SELECT COUNT(estacion) AS [Numero de estaciones recorridas], Tren
    FROM LM_Recorridos
    WHERE Momento BETWEEN @inicio AND @fin
    GROUP BY Tren
)
GO

-- Creamos las variables con los tipos correspondientes
DECLARE @fechaInicio DateTime
DECLARE @fechaFin DateTime

-- Asignamos valor a las variables
SET @fechaInicio = '2017-02-26'
SET @fechaFin = '2017-02-28'

SELECT * FROM dbo.calcularNumeroEstacionesRecorridasPorCadaTren(@fechaInicio, @fechaFin)
GO
-----------------------------------------------------------------------------------------------------------------

------------------------------------------- EJEMPLO FUNCION ESCALAR ---------------------------------------------
-- 2. Crear una funcion escalar que nos devuelva la matricula de un tren segun el id que le pasemos por parametro

-- Creamos la funcion escalar
GO
CREATE FUNCTION dbo.devolverMatriculaTren(@id Int)
    RETURNS Char(7)
    BEGIN
        DECLARE @resultado Char(7)
        SET @resultado = (SELECT Matricula FROM LM_Trenes WHERE ID = @id)
        RETURN @resultado
    END
GO

-- Creamos las variables con los tipos correspondientes
DECLARE @matriculaTren Char(7)
DECLARE @idTren Int

-- Asignamos valor a las variables
SET @idTren = 104
SET @matriculaTren = dbo.devolverMatriculaTren(@idTren)

-- Imprimimos la matricula del tren
PRINT @matriculaTren
GO
-----------------------------------------------------------------------------------------------------------------

------------------------------------------- EJEMPLO PROCEDIMIENTO -----------------------------------------------
-- 2- Crear un procedimiento que muestre el numero de veces que cada usuario subio al metro en el mes de febrero

-- Creamos el procedimiento
GO
CREATE PROCEDURE dbo.mostrarNumeroVecesCadaUsuarioSubioAlMetroEnFebrero
AS
    SELECT COUNT(V.MomentoEntrada) AS [NumeroVeces], P.Nombre
    FROM LM_Viajes AS V
    INNER JOIN LM_Pasajeros AS P
    ON V.IDPasajero = P.ID
    WHERE V.MomentoEntrada BETWEEN '2017-02-01' AND '2017-02-28'
    GROUP BY P.Nombre
GO

-- Ejecutamos el  procedimiento con la instruccion EXEC
EXEC dbo.mostrarNumeroVecesCadaUsuarioSubioAlMetroEnFebrero