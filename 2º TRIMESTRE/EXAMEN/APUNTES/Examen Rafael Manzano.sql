USE LeoTurf
SELECT * FROM LTApuestas
SELECT * FROM LTApuntes
SELECT * FROM LTCaballosCarreras
SELECT * FROM LTCaballos
SELECT * FROM LTCarreras
SELECT * FROM LTHipodromos
SELECT * FROM LTJugadores
-- Ejercicio 1. Queremos saber cuál es la cantidad media apostada y la mayor cantidad apostada a cada caballo.
--Columnas: ID Caballo, Nombre, Edad, Número de carreras disputadas, cantidad mayor apostada y cantidad media apostada a su favor

--Cantidad media apostada por cada caballo
GO
CREATE VIEW Media AS
SELECT AVG(Importe) AS Media, IDCaballo FROM LTApuestas
	GROUP BY IDCaballo
GO

--Mayor cantidad apostada por cada caballo
GO
CREATE VIEW Maximo AS 
SELECT MAX(Importe) AS MaximoApostado, IDCaballo FROM LTApuestas
	GROUP BY IDCaballo
GO


--Unimos las vistas
SELECT C.ID, C.Nombre,  DATEDIFF (YEAR, C.FechaNacimiento, CURRENT_TIMESTAMP) AS Edad, COUNT(CRR.ID) AS CarrerasDisputadas, MX.MaximoApostado, MD.Media  FROM LTCaballos AS C
	INNER JOIN Maximo AS MX
		ON MX.IDCaballo = C.ID
	INNER JOIN Media AS MD
		ON MD.IDCaballo = C.ID
	INNER JOIN LTCaballosCarreras AS CC
		ON CC.IDCaballo = C.ID
	INNER JOIN LTCarreras AS CRR
		ON CRR.ID = CC.IDCarrera
	GROUP BY C.ID, C.Nombre, DATEDIFF (YEAR, C.FechaNacimiento, CURRENT_TIMESTAMP), MX.MaximoApostado, MD.Media

-- Ejercicio 2. Tenemos sospechas de que algún jugador pueda estar intentando amañar las carreras. Queremos detectar los jugadores que son especialmente afortunados. 
--Haz una consulta que calcule, para cada jugador, la rentabilidad que obtiene con el menor riesgo posible. La rentabilidad se mide dividiendo el total de dinero ganado entre el dinero apostado y multiplicando el resultado por 100.
--Ten en cuenta solo el dinero que haya ganado por premios, no los ingresos que haya podido hacer en su cuenta.
--Columnas: ID, nombre y apellidos del jugador, total de dinero apostado, total de dinero ganado, rentabilidad.


--Total de dinero ganado (o perdido)
DROP VIEW TotalGanado
GO 
CREATE VIEW TotalGanado AS 
SELECT SUM(Importe) AS TotalGanado, IDJugador FROM LTApuntes
WHERE Concepto LIKE ('Premio%')
GROUP BY IDJugador
GO

--Total de dinero apostado
GO
CREATE VIEW TotalApostado AS
SELECT SUM(Importe) AS TotalApostado, IDJugador FROM LTApuestas
GROUP BY IDJugador
GO

--Rentabilidad que gana cada jugador
SELECT J.ID, J.Nombre, J.Apellidos, TA.TotalApostado, TG.TotalGanado, ((TG.TotalGanado/TA.TotalApostado) * 100) AS Rentabilidad FROM LTJugadores AS J
	INNER JOIN TotalApostado AS TA
		ON TA.IDJugador = J.ID
	INNER JOIN TotalGanado AS TG
		ON TG.IDJugador = J.ID
	GROUP BY J.ID, J.Nombre, J.Apellidos, TA.TotalApostado, TG.TotalGanado

--Ejercicio 3. Como todavía no estamos tranquilos, vamos a comprobar apuestas que se salgan de lo normal. Consideramos sospechosa una apuesta ganadora grande (al menos un 50% por encima del importe medio de las apuestas de esa carrera) a caballos que se pagasen a 2 o más. Columnas: ID Jugador, Nombre, apellidos, ID apuesta, Hipódromo, fecha de la carrera, caballo, premio, importe apostado e importe ganado.
--Si no devuelve ninguna fila no pasa nada. Nuestros clientes son honrados.


--Media de apuestas por carreras
GO
CREATE VIEW ApuestasXCarreras AS
SELECT AVG(A.Importe) AS Media, C.ID FROM LTApuestas AS A
	INNER JOIN LTCarreras AS C
		ON A.IDCarrera = C.ID
	GROUP BY C.ID 
GO

--Apuestas de caballos en cada carrera
--La carrera 1 sus dos ganadores miramos su apuesta y vemos si sobrepasa la media de apuestas para esa carrera a caballos que pasen de 2 o mas
--Caballos ganadores o segundo de todas las carreras realizadas
SELECT J.ID, J.Nombre, J.Apellidos, A.ID, C.Hipodromo, C.Fecha, CAB.Nombre, SUM(A.Importe * CC.Premio1) AS PremioGanador, SUM(A.Importe * CC.Premio2) AS PremioSegundo , A.Importe FROM LTCaballos AS CAB
	INNER JOIN LTCaballosCarreras AS CC
		ON CC.IDCaballo = CAB.ID
	INNER JOIN LTCarreras AS C
		ON C.ID = CC.IDCarrera
	INNER JOIN ApuestasXCarreras AS AXC
		ON AXC.ID = C.ID
	INNER JOIN LTApuestas AS A
		ON A.IDCaballo = CAB.ID
	INNER JOIN LTJugadores AS J
		ON J.ID = A.IDJugador
WHERE CC.Posicion = 1 OR CC.Posicion = 2 AND A.Importe > AXC.Media * 1.5
GROUP BY J.ID, J.Nombre, J.Apellidos, A.ID, C.Hipodromo, C.Fecha, CAB.Nombre, A.Importe





--Comprobamos si los premios superan las ganancias en un 50%, estos son los jugadores que han ganado premios por encima de la media 
SELECT J.ID, J.Nombre, J.Apellidos, A.ID, C.Hipodromo, C.Fecha, CAB.Nombre, CC.Premio1, CC.Premio2, (A.Importe FROM LTApuestas AS A
	INNER JOIN LTJugadores AS J
		ON J.ID = A.IDJugador
	INNER JOIN LTCarreras AS C
		ON C.ID = A.IDCarrera
	INNER JOIN LTCaballosCarreras AS CC
		ON C.ID = CC.IDCarrera
	INNER JOIN LTCaballos AS CAB
		ON CC.IDCaballo = CAB.Nombre
	INNER JOIN ApuestasXCarreras AS AXC
		ON AXC.ID = C.ID
WHERE CC.Premio1 * Importe > AXC.Media * 1.5  AND CC.Premio2 * Importe > AXC.Media * 1.5 AND CC.Premio1 > 2 AND CC.Premio2 > 2
GROUP BY J.ID, J.Nombre, J.Apellidos, A.ID, C.Hipodromo, C.Fecha, CAB.Nombre, CC.Premio1, CC.Premio2, A.Importe


--Ejercicio 5a. Actualiza la tabla LTCaballoCarreras y genera los apuntes en LTApuntes correspondientes a los jugadores que hayan ganado utilizando dos instrucciones INSERT-SELECT, una para los que han acertado la ganadora y otra para los que han acertado la segunda.
UPDATE LTCaballosCarreras

--Ejercicio 5b. 
--Debido a una reclamación, el caballo Ciclón ha sido descalificado en la carrera 11 por utilizar herraduras de fibra de carbono, 
--prohibidas por el reglamento.
--Actualiza la tabla LTCaballosCarreras haciendo que la posición de Ciclón sea NULL y todos los que 
--entraron detrás de él suban un puesto. 
--Como Ciclón quedó segundo, este cambio afecta a los premios. Hay que anular (eliminar) todos los apuntes relativos a premios por ese caballo en esa carrera.
--Además, el segundo pasa a ser primero y el tercero pasa a ser segundo, lo que afecta a sus apuestas. 
--Genera o modifica los apuntes correspondientes a esos premios.

