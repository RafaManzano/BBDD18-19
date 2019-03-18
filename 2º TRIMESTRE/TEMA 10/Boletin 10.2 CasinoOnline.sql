USE CasinOnLine2
--Actividades
--Especificaciones
--Cada apuesta tiene una serie de números (entre 1 y 24 números) asociados en la tabla COL_NumerosApuestas. 
--La apuesta es ganadora si alguno de esos números coincide con el número ganador de la jugada y perdedora en caso contrario.

--Si la apuesta es ganadora, el jugador recibe lo apostado (Importe) multiplicado por el valor de la columna 
--Premio de la tabla COL_TiposApuestas que corresponda con el tipo de la apuesta. Si la apuesta es perdedora, 
--el jugador pierde lo que haya apostado (Importe)

--1. Escribe una consulta que nos devuelva el número de veces que se ha apostado a cada número con apuestas de los tipos 10, 13 o 15.
--Ordena el resultado de mayor a menos popularidad.
SELECT * FROM COL_Apuestas
SELECT * FROM COL_Jugadas
SELECT * FROM COL_NumerosApuesta

SELECT COUNT(*) AS NumeroApuestas, Numero FROM COL_NumerosApuesta AS NA
INNER JOIN COL_Apuestas AS A ON NA.IDJugada = A.IDJugada AND NA.IDMesa = A.IDMesa AND NA.IDJugador = A.IDJugador
WHERE A.Tipo = 15 OR A.Tipo = 13 OR A.Tipo = 10 
GROUP BY Numero
ORDER BY NumeroApuestas DESC

--2. El casino quiere fomentar la participación y decide regalar saldo extra a los jugadores que hayan apostado más de 
--tres veces en el último mes. Se considera el mes de febrero.
--La cantidad que se les regalará será un 5% del total que hayan apostado en ese mes
SELECT * FROM COL_Jugadores
SELECT COUNT(*) AS Apuestas, A.IDJugador FROM COL_Jugadas AS J
INNER JOIN COL_Apuestas AS A ON J.IDMesa = A.IDMesa AND J.IDJugada = A.IDJugada
WHERE MONTH(J.MomentoJuega) = 2 AND YEAR(J.MomentoJuega) = 2018
GROUP BY A.IDJugador


BEGIN TRANSACTION
UPDATE COL_Jugadores 
SET Saldo = Saldo * 1.05
FROM COL_Jugadas AS J 
INNER JOIN COL_Apuestas AS A ON J.IDMesa = A.IDMesa AND J.IDJugada = A.IDJugada
WHERE MONTH(J.MomentoJuega) = 2 AND YEAR(J.MomentoJuega) = 2018
--ROLLBACK
--COMMIT

