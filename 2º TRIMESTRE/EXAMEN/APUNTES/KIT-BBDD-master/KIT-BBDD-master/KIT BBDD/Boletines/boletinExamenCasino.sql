USE CasinOnLine2

SELECT * FROM COL_Apuestas
SELECT * FROM COL_Jugadas
SELECT * FROM COL_Jugadores
SELECT * FROM COL_Mesas
SELECT * FROM COL_NumerosApuesta
SELECT * FROM COL_TiposApuesta

--Especificaciones
--Cada apuesta tiene una serie de números (entre 1 y 24 números) asociados en la tabla COL_NumerosApuestas. 
--La apuesta es ganadora si alguno de esos números coincide con el número ganador de la jugada y perdedora en caso contrario.
--Si la apuesta es ganadora, el jugador recibe lo apostado (Importe) multiplicado por el valor de la columna Premio de la tabla COL_TiposApuestas 
--que corresponda con el tipo de la apuesta. Si la apuesta es perdedora, el jugador pierde lo que haya apostado (Importe)

--Ejercicio 1
--Escribe una consulta que nos devuelva el número de veces que se ha apostado a cada número con apuestas de los tipos 10, 13 o 15.
SELECT 
	J.Numero AS Número
	,A.Tipo
	,COUNT(*) AS [Número de apuestas]
FROM
	COL_Apuestas AS A
	JOIN COL_Jugadas AS J
		ON A.IDJugada = J.IDJugada
WHERE A.Tipo IN (10, 13, 15)
GROUP BY A.Tipo, J.Numero
ORDER BY [Número de apuestas] DESC

--Ordena el resultado de mayor a menos popularidad.

--Ejercicio 2
--El casino quiere fomentar la participación y decide regalar saldo extra a los jugadores que hayan apostado más de tres veces en el último mes. Se considera el mes de febrero.
--La cantidad que se les regalará será un 5% del total que hayan apostado en ese mes
																														--GO
																														--CREATE VIEW [NumeroApuestasMesJugador] AS
																														--SELECT
																														--	A.IDJugador
																														--	,COUNT(*) [Número de apuestas]
																														--	,MONTH(J.MomentoJuega) AS Mes
																														--	,YEAR(J.MomentoJuega) AS año
																														--FROM
																														--	COL_Apuestas AS A
																														--	JOIN COL_Jugadas AS J
																														--		ON A.IDJugada = J.IDJugada
																														----WHERE 
																														----	MONTH (J.MomentoJuega) = 2
																														--GROUP BY
																														--	A.IDJugador ,MONTH(J.MomentoJuega),YEAR(J.MomentoJuega)
																														--GO

-- Devuelve una tabla con el numero de apuestas de cada jugador en la fecha enviada
CREATE FUNCTION apuestasJugadoresMesAño (@mes tinyint, @año smallint, @numApuestas smallint)
RETURNS TABLE AS
RETURN
	SELECT
	A.IDJugador
	,COUNT(*) [Número de apuestas]
	,MONTH(J.MomentoJuega) AS Mes
	,YEAR(J.MomentoJuega) AS Año
FROM
	COL_Apuestas AS A
	JOIN COL_Jugadas AS J
		ON A.IDJugada = J.IDJugada
WHERE 
	MONTH (J.MomentoJuega) = @mes AND YEAR(J.MomentoJuega) = @año
GROUP BY
	A.IDJugador ,MONTH(J.MomentoJuega),YEAR(J.MomentoJuega)
HAVING
	COUNT(*) > @numApuestas
GO

SELECT * FROM apuestasJugadoresMesAño(2,2018,3)

--Ejercicio 3
--El día 2 de febrero se celebró el día de la marmota. Para conmemorarlo, el casino ha decidido volver a repetir todas las jugadas que se hicieron ese día,
--pero poniéndoles fecha de mañana (con la misma hora) y permitiendo que los jugadores apuesten. El número ganador de cada jugada se pondrá a NULL y el NoVaMas a 0.
--Crea esas nuevas filas con una instrucción INSERT-SELECT



--Ejercicio 4
--Crea una vista que nos muestre, para cada jugador, nombre, apellidos, Nick, número de apuestas realizadas, total de dinero apostado y total de dinero ganado/perdido.

--Ejercicio 5
--Nos comunican que la policía ha detenido a nuestro cliente Ombligo Pato por delitos de estafa, falsedad, administración desleal y mal gusto para comprar bañadores. 
--Dado que nuestro casino está en Gibraltar, siguiendo la tradición de estas tierras, queremos borrar todo rastro de su paso por nuestro casino.
--Borra todas las apuestas que haya realizado, pero no busques su ID a mano en la tabla COL_Clientes. Utiliza su Nick (bankiaman) para identificarlo en la instrucción DELETE.