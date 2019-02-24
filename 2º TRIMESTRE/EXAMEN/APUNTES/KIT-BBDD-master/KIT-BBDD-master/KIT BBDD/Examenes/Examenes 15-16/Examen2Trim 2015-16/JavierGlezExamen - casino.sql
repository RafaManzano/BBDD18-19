USE CasinOnLine
--EJERCICIO 1.-Numero veces apostado a apuestas tipo 10,13 y 15. Ordenador de mayor a menor popularidad.
GO
SELECT Tipo, COUNT(IDJugada) AS Numero FROM COL_Apuestas
	WHERE Tipo IN (10,13,15)
	--WHERE Tipo=8 --Este es para comprobar que funciona, solo hay del tipo8
	GROUP BY Tipo
	ORDER BY Numero
GO

--EJERCICIO 4.- Vista(Nombre, Apellidos, Nick, NumeroApuestasRealizadas, TotalDineroApostado(SumarImporteJugadas), TotalDineroGanadoPerdido(DineroGanado-DineroPerdido))
GO
--VISTA PARA SACAR GANANCIAS
CREATE VIEW Ganacias AS
SELECT ID AS IDJugador, SUM(Acierto.Importe*Acierto.Premio) AS Ganado  FROM COL_Jugadores AS J1
	JOIN COL_Apuestas AS A
	ON J1.ID=A.IDJugador
	JOIN (SELECT NA.IDMesa, NA.IDJugada, A.Importe ,TA.Premio FROM COL_NumerosApuesta AS NA --aciertosTipo
			JOIN COL_Apuestas AS A
			ON NA.IDJugada=A.IDJugada
			JOIN COL_TiposApuesta AS TA
			ON A.Tipo=TA.ID
			JOIN COL_Jugadas AS J2
			ON A.IDJugada=J2.IDJugada
				WHERE NA.Numero=J2.Numero
				GROUP BY NA.IDMesa, NA.IDJugada, A.Importe, TA.Premio
			) AS Acierto
	ON A.IDJugada=Acierto.IDJugada
	GROUP BY J1.ID
GO
--VISTA DE PERDIDAS
CREATE VIEW Perdidas AS
SELECT ID AS IDJugador, SUM(Error.Importe) AS Perdido FROM COL_Jugadores AS J1
	JOIN COL_Apuestas AS A
	ON J1.ID=A.IDJugador
	JOIN (SELECT NA.IDMesa, NA.IDJugada, A.Importe ,TA.Premio FROM COL_NumerosApuesta AS NA --aciertosTipo
			JOIN COL_Apuestas AS A
			ON NA.IDJugada=A.IDJugada
			JOIN COL_TiposApuesta AS TA
			ON A.Tipo=TA.ID
			JOIN COL_Jugadas AS J2
			ON A.IDJugada=J2.IDJugada
				WHERE NA.Numero!=J2.Numero
				GROUP BY NA.IDMesa, NA.IDJugada, A.Importe, TA.Premio
			) AS Error
	ON A.IDJugada=Error.IDJugada
	GROUP BY J1.ID

GO
--VISTA QUE SE PIDE
CREATE VIEW DatosJugadores AS
SELECT J.Nombre, J.Apellidos, J.Nick, COUNT(A.IDJugada) AS NumeroJugadas, SUM(A.Importe) AS TotalApostado, (G.Ganado-P.Perdido) AS GANANCIAS FROM COL_Jugadores AS J
	JOIN COL_Apuestas AS A
	ON J.ID=A.IDJugador
	JOIN Ganacias AS G
	ON G.IDJugador=J.ID
	JOIN Perdidas AS P
	ON P.IDJugador=J.ID
GROUP BY J.Nombre, J.Apellidos, J.Nick, (G.Ganado-P.Perdido)
GO


--EJERCICIO 2.- Actualizar con +5% del total apostado en (2/16) a jugadores con mas de 3 apuestas en ultimo mes(2/16)
BEGIN TRANSACTION
UPDATE COL_Jugadores
	SET Saldo=Saldo+(DJ.TotalApostado*5/100)
	FROM DatosJugadores AS DJ
	WHERE ID IN (SELECT J.ID FROM COL_Jugadores AS J--Principal
					JOIN (SELECT COUNT(A.IDJugada) AS VecesJugado, J2.ID FROM COL_Apuestas AS A --Sub para contar jugadas
							JOIN COL_Jugadores AS J2
							ON J2.ID=A.IDJugador
							GROUP BY J2.ID
					) AS Sub1
					ON J.ID=Sub1.ID
					WHERE J.ID IN (SELECT ID FROM COL_Jugadores AS J
									JOIN COL_Apuestas AS A
									ON J.ID=A.IDJugador
									JOIN COL_Jugadas AS J2
									ON A.IDJugada=J2.IDJugada
									WHERE Sub1.VecesJugado>3 AND MONTH(J2.MomentoJuega)=2
									--WHERE Sub1.VecesJugado>3 AND MONTH(J2.MomentoJuega)=1
					)

				)
GO
ROLLBACK TRANSACTION

--COMMIT TRANSACTION





--EJERCICIO 3.- Volver a repetir jugadas del 2 febrero
GO

--JugadasDiaMarmota(No hay ninguna)
SELECT A.IDMesa, A.IDJugada, A.IDJugador FROM COL_Apuestas AS A
	WHERE IDJugada IN (SELECT IDJugada FROM COL_Jugadas AS J
					WHERE DAY(J.MomentoJuega)=2 AND MONTH(J.MomentoJuega)=2 AND YEAR(J.MomentoJuega)=2016
					)

GO

--EJERCICIO 5.- Eliminar bankiaman (Todo rastro)
BEGIN TRANSACTION

DELETE FROM COL_Apuestas
	WHERE IDJugador IN (SELECT ID FROM COL_Jugadores
				WHERE Nick='bankiaman'
	)
GO
DELETE FROM COL_Jugadores
	WHERE ID IN (SELECT DISTINCT ID FROM COL_Jugadores
				WHERE Nick='bankiaman'
	)

ROLLBACK TRANSACTION
--COMMIT TRANSACTION
