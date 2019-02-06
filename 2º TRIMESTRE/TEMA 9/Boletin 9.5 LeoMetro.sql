USE LeoMetro
SELECT * FROM LM_Estaciones
SELECT * FROM LM_Lineas

--1. Indica el número de estaciones por las que pasa cada línea
SELECT COUNT(DISTINCT LMR.estacion) AS NumeroEstaciones, LML.ID FROM LM_Estaciones AS LME
INNER JOIN LM_Recorridos AS LMR ON LMR.estacion = LME.ID
INNER JOIN LM_Lineas AS LML ON LML.ID = LMR.Linea
GROUP BY LML.ID

--2. Indica el número de trenes diferentes que han circulado en cada línea
SELECT COUNT(DISTINCT LMR.Tren) AS NumeroEstaciones, LML.ID FROM LM_Estaciones AS LME
INNER JOIN LM_Recorridos AS LMR ON LMR.estacion = LME.ID
INNER JOIN LM_Lineas AS LML ON LML.ID = LMR.Linea
GROUP BY LML.ID

--3. Indica el número medio de trenes de cada clase que pasan al día por cada estación. 

--4. Calcula el tiempo necesario para recorrer una línea completa, contando con el tiempo estimado de cada 
--itinerario y considerando que cada parada en una estación dura 30 s.
--No puedo sumar los 30 segundos ni realizar la media
SELECT * FROM LM_Itinerarios

SELECT * FROM LM_Itinerarios
GROUP BY Linea

--5. Indica el número total de pasajeros que entran (a pie) cada día por cada estación y los que salen del metro en la misma.
--Esta mal porque no da ningun resultado, creo que hay que hacer una subconsulta en el where, despues de varias pruebas no di resultado
SELECT * FROM LM_Pasajeros
SELECT * FROM LM_Viajes

SELECT COUNT(LMP.ID) AS TotalPasajeros, LME.ID FROM LM_Pasajeros AS LMP
INNER JOIN LM_Viajes AS LMV ON LMV.IDPasajero = LMP.ID
INNER JOIN LM_Estaciones AS LME ON LME.ID = LMV.IDEstacionEntrada
WHERE LMV.IDEstacionEntrada = LMV.IDEstacionSalida
GROUP BY LME.ID

--6. Calcula la media de kilómetros al día que hace cada tren. Considera únicamente los días que ha estado en servicio 

