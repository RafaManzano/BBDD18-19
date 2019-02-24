USE LeoMetro
--1. Crea una función inline que nos devuelva el número de estaciones que ha recorrido cada tren en un determinado periodo de tiempo.
--El principio y el fin de ese periodo se pasarán como parámetros
GO
CREATE FUNCTION EstacionesTrenesPeriodo(@PeriodoInicio date, @PeriodoFin date)
RETURNS TABLE AS
RETURN
(SELECT
	T.ID, T.Matricula, COUNT(E.ID) AS [Estaciones recorridas]
FROM
	LM_Trenes AS T
	INNER JOIN LM_Recorridos AS R
	ON T.ID = R.Tren
	INNER JOIN LM_Estaciones AS E
	ON R.estacion = E.ID
WHERE
	R.Momento > @PeriodoInicio AND R.Momento < @PeriodoFin
GROUP BY
	T.ID, T.Matricula)
GO

SELECT * FROM EstacionesTrenesPeriodo('20170301', '20180101')
SELECT * FROM EstacionesTrenesPeriodo('20160301', '20180101')

--2. Crea una función inline que nos devuelva el número de veces que cada usuario ha entrado en el metro en un periodo de tiempo.
--El principio y el fin de ese periodo se pasarán como parámetros
GO
CREATE FUNCTION UsuarioEntradasPeiodo(@PeriodoInicio date, @PeriodoFin date)
RETURNS TABLE AS
RETURN
(SELECT
	P.Nombre, P.Apellidos, COUNT(V.MomentoEntrada) AS [Número de veces que entra en el metro]
FROM
	LM_Pasajeros AS P
	INNER JOIN LM_Viajes AS V
	ON P.ID = V.IDPasajero
WHERE
	V.MomentoEntrada > @PeriodoInicio AND V.MomentoEntrada < @PeriodoFin
GROUP BY V.IDPasajero, P.Nombre, P.Apellidos)
GO

SELECT * FROM UsuarioEntradasPeiodo('20170226', '20170228')

--3. Crea una función inline a la que pasemos la matrícula de un tren y una fecha de inicio y fin
--y nos devuelva una tabla con el número de veces que ese tren ha estado en cada estación, además del ID, nombre
--y dirección de la estación
GO
CREATE FUNCTION VecesEstacionMatriculaPeriodo(@Matricula char(7), @PeriodoInicio date, @PeriodoFin date)
RETURNS TABLE AS
RETURN
(SELECT
	E.ID, E.Denominacion, E.Direccion, COUNT(*) AS [Veces que ha pasado]
FROM
	LM_Trenes AS T
	INNER JOIN LM_Recorridos AS R
	ON T.ID = R.Tren
	INNER JOIN LM_Estaciones AS E
	ON R.estacion = E.ID
WHERE
	T.Matricula = @Matricula AND R.Momento > @PeriodoInicio AND R.Momento < @PeriodoFin
GROUP BY
	E.ID, E.Denominacion, E.Direccion)
GO
SELECT * FROM VecesEstacionMatriculaPeriodo('3290GPT', '20170226', '20170228')

--4. Crea una función inline que nos diga el número de personas que han pasado por una estacion en un periodo de tiempo.
--Se considera que alguien ha pasado por una estación si ha entrado o salido del metro por ella.
--El principio y el fin de ese periodo se pasarán como parámetros


--5. Crea una función inline que nos devuelva los kilómetros que ha recorrido cada tren en un periodo de tiempo.
--El principio y el fin de ese periodo se pasarán como parámetros


--6. Crea una función inline que nos devuelva el número de trenes que ha circulado por cada línea en un periodo de tiempo.
--El principio y el fin de ese periodo se pasarán como parámetros. Se devolverá el ID, denominación y color de la línea
GO
CREATE FUNCTION TrenesPorLineaPeriodo(@PeriodoInicio date, @PeriodoFin date)
RETURNS TABLE AS
RETURN
(SELECT
	L.ID, L.Denominacion, L.Color, COUNT(T.ID) AS [Número de trenes que han pasado]
FROM
	LM_Trenes AS T
	INNER JOIN LM_Recorridos AS R
	ON T.ID = R.Tren
	INNER JOIN LM_Lineas AS L
	ON R.Linea = L.ID
WHERE
	R.Momento > @PeriodoInicio AND R.Momento < @PeriodoFin
GROUP BY
	L.ID, L.Denominacion, L.Color)
GO
SELECT * FROM TrenesPorLineaPeriodo('20170226', '20170228')

--7. Crea una función inline que nos devuelva el tiempo total que cada usuario ha pasado en el metro en un periodo de tiempo.
--El principio y el fin de ese periodo se pasarán como parámetros. Se devolverá ID, nombre y apellidos del pasajero.
--El tiempo se expresará en horas y minutos.
