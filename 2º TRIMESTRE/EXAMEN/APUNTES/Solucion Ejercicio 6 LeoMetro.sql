/* Ejercicio 6 Calcular la media de los kilómetros que recoree cada tren al día
*/
--En esta vista tenemos todos los recorridos que ha hecho cada tren, indicando momento y estación de salida y de llegada y distancia recorrida entre ambos
 CREATE 
-- ALTER 
View VTramos AS
SELECT RA.Tren, RA.estacion AS EstacionSalida, TiempoTramos.EstacionLlegada, TiempoTramos.MomentoAnterior, TiempoTramos.Momento, I.Distancia
	FROM
	(SELECT R.Tren, R.estacion AS EstacionLlegada,  R.Momento, MAX (Anterior.Momento) AS Momentoanterior
		FROM LM_Recorridos as R
		INNER JOIN LM_Recorridos AS Anterior ON R.Tren = Anterior.Tren AND R.Linea = Anterior.Linea
		WHERE R.Momento > Anterior.Momento
		GROUP BY R.Tren,R.estacion, R.Momento) AS TiempoTramos
	INNER JOIN LM_Recorridos AS RA
		ON RA.Tren = TiempoTramos.Tren AND RA.Momento = TiempoTramos.Momentoanterior
	INNER JOIN LM_Itinerarios AS I
		ON RA.estacion = I.estacionIni AND TiempoTramos.EstacionLlegada = I.estacionFin
GO
-- Ahora agrupamos para calcular los Kilometros de cada día
SELECT Tren, CAST (Momento AS DATE) AS Dia, SUM(Distancia) AS Kilometros
	FROM VTramos AS T
	GROUP BY Tren,CAST (Momento AS DATE)


--Y por último calculamos la media sobre esa consulta. Hacemos JOIN con Trenes para obtener su matricula

SELECT DistanciaDiaria.Tren, T.Matricula, AVG(Kilometros) AS DistanciaMedia
	FROM LM_Trenes AS T
	INNER JOIN (SELECT Tren, CAST (Momento AS DATE) AS Dia, SUM(Distancia) AS Kilometros
					FROM VTramos
					GROUP BY Tren,CAST (Momento AS DATE)) AS DistanciaDiaria
	ON T.ID = DistanciaDiaria.Tren
	GROUP BY Tren, T.Matricula