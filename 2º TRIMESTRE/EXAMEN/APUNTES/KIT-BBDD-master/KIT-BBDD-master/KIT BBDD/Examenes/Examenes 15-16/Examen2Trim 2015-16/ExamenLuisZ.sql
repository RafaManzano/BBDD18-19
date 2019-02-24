USE CasinOnLine
GO
--USE MASTER DROP DATABASE CasinOnLine

--------------------------------------------------------------------- EJERCICIO 1---------------------------------------------------------------------
--Escribe una consulta que nos devuelva el número de veces que se ha apostado
-- a cada número con apuestas de los tipos 10, 13 o 15. Ordena el resultado de mayor a menos popularidad.

SELECT 
	Apuestas.Tipo AS TipoDeApuesta,
	COUNT(Numero.Numero) AS Numero
FROM
	COL_Apuestas AS Apuestas
JOIN
	COL_NumerosApuesta AS Numero
	ON Apuestas.IDJugada = Numero.IDJugada
WHERE 
	Apuestas.Tipo IN (10,13,15)
GROUP BY
	Apuestas.Tipo 
ORDER BY
	Apuestas.Tipo DESC

GO
--------------------------------------------------------------------- EJERCICIO 2---------------------------------------------------------------------
--El casino quiere fomentar la participación y decide regalar saldo extra a los jugadores que hayan 
--apostado más de tres veces en el último mes. Se considera el mes de febrero.
--La cantidad que se les regalará será un 5% del total que hayan apostado en ese mes

SELECT
	J.Nombre,
	J.Apellidos,
	J.Nick,
	SUM (A.Importe) AS TotalApostado,
	COUNT (A.IDJugada) AS NumeroJugadas,     
	(SUM (A.Importe) * 0.05) AS SaldoARegalar
	
FROM
	COL_Jugadores AS J
JOIN
	COL_Apuestas AS A
	ON J.ID = A.IDJugador
JOIN
	COL_Jugadas AS G
	ON A.IDJugada = G.IDJugada
WHERE G.MomentoJuega = MONTH(2) 
GROUP BY J.Nombre, J.Apellidos, J.Nick, A.Importe
HAVING  (COUNT (A.IDJugada) > 3)
GO
--------------------------------------------------------------------- EJERCICIO 3---------------------------------------------------------------------
--El día 2 de febrero se celebró el día de la marmota. Para conmemorarlo, el casino ha decidido volver 
--a repetir todas las jugadas que se hicieron ese día, pero poniéndoles fecha de mañana (con la misma hora) 
--y permitiendo que los jugadores apuesten. El número ganador de cada jugada se pondrá a NULL y el NoVaMas a 0.
--Crea esas nuevas filas con una instrucción INSERT-SELECT

INSERT INTO COL_Jugadas (IDMesa,IDJugada,MomentoJuega)
	SELECT 
		IDMesa,
		IDJugada,
		MomentoJuega
	FROM 
		COL_Jugadas
	WHERE 
		MONTH(MomentoJuega)=2 AND DAY(MomentoJuega)=2
--Falta poner NumGanador a NULL y NoVaMas a 0

GO
--------------------------------------------------------------------- EJERCICIO 4---------------------------------------------------------------------
--Crea una vista que nos muestre, para cada jugador, nombre, apellidos, Nick, número de apuestas realizadas, total de dinero 
--apostado y total de dinero ganado/perdido.

CREATE VIEW EstadisticasGeneralesJugador AS
(
	SELECT
		J.Nombre,
		J.Apellidos,
		J.Nick,
		SUM (A.Importe) AS TotalApostado,
		COUNT (A.IDJugada) AS NumeroApuestas
	FROM
		COL_Jugadores AS J
	JOIN 
		COL_Apuestas AS A
	ON J.ID = A.IDJugador
	
	GROUP BY J.Nombre, J.Apellidos, J.Nick
)
GO

--------------------------------------------------------------------- EJERCICIO 5---------------------------------------------------------------------
--Nos comunican que la policía ha detenido a nuestro cliente Ombligo Pato por delitos de estafa, falsedad, administración desleal 
--y mal gusto para comprar bañadores. Dado que nuestro casino está en Gibraltar, siguiendo la tradición de estas tierras, queremos 
--borrar todo rastro de su paso por nuestro casino. Borra todas las apuestas que haya realizado, pero no busques su ID a mano en 
--la tabla COL_Clientes. Utiliza su Nick (bankiaman) para identificarlo en la instrucción DELETE.

GO
Select * INTO TEMP_Jugadores FROM COL_Jugadores 
GO
Select * INTO TEMP_Apuestas FROM COL_Apuestas 
GO


CREATE VIEW OmbligoPato AS (
	SELECT
		ID, 
		Nick,
		COUNT(ID) AS numeroApuestas
	FROM
		TEMP_Jugadores AS J
	JOIN 
		TEMP_Apuestas AS A
	ON J.ID=A.IDJugador
	WHERE
		Nick = 'bankiaman'
	GROUP BY ID, Nick
)
--DROP VIEW OmbligoPato
GO
BEGIN TRANSACTION 
GO

DELETE FROM OmbligoPato
	WHERE Nick = 'bankiaman'

--ROLLBACK TRANSACTION