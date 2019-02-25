--N�mero de veces que ha actuado cada cantaor en cada festival de la provincia de C�diz,
--incluyendo a los que no han actuado nunca.
SELECT * FROM F_Cantaores
SELECT * FROM F_Festivales_Cantaores
SELECT * FROM F_Festivales
SELECT COUNT(FC.Cod_Festival) AS[Veces Cantadas], C.Nombre_Artistico FROM F_Cantaores AS[C]
	LEFT JOIN F_Festivales_Cantaores AS[FC] ON C.Codigo = FC.Cod_Cantaor
	LEFT JOIN F_Festivales AS[F] ON FC.Cod_Festival = F.Cod AND F.Provincia = 'CA'
		--WHERE F.Provincia = 'CA'
		GROUP BY C.Nombre_Artistico
--Si le ponemos la condicion en el WHERE estamos eliminando los que no han cantado en Cadiz.

--Ejercicio 2
--Crea un nuevo palo llamado �Ton�.
--Haz que todos los cantaores que cantaban Bamberas o Peteneras canten Ton�s. No utilices
--los c�digos de los palos, sino sus nombres.


--Ejercicio 3
--N�mero de cantaores mayores de 30 a�os que han actuado cada a�o en cada pe�a. Se
--contar� la edad que ten�an en el a�o de la actuaci�n.
SELECT * FROM F_Cantaores
SELECT * FROM F_Actua
SELECT * FROM F_Penhas
--Numero de cantaores mayores de 30 a�os que ha habido cada a�o en cada pe�a
SELECT CA.A�o, count(CA.Nombre) AS[Numero Cantantes], CA.Nombre FROM (
--A�o de los cantaores cuando actuaron. //No sabemos la fecha exacta en la que nacio cada cantaor por tanto esta es la forma que he visto mejor.
	SELECT (YEAR(A.Fecha)-C.Anno) AS[Edad], C.Nombre_Artistico, YEAR(A.Fecha) AS[A�o], P.Nombre FROM F_Cantaores AS[C]
		INNER JOIN F_Actua AS[A] ON C.Codigo = A.Cod_Cantaor
		INNER JOIN F_Penhas AS[P] ON A.Cod_Penha = P.Codigo
	GROUP BY C.Nombre_Artistico, C.Anno, A.Fecha, P.Nombre) AS[CA]
WHERE CA.Edad > 30
GROUP BY CA.A�o, CA.Nombre
ORDER BY CA.A�o, CA.Nombre

--Ejercicio 4
--Cantaores (nombre, apellidos y nombre art�stico) que hayan actuado m�s de dos veces en
--pe�as de la provincia de Sevilla y canten Fandangos o Buler�as. S�lo se incluyen las
--actuaciones directas en Pe�as, no los festivales.
SELECT * FROM F_Cantaores
SELECT * FROM F_Actua
SELECT * FROM F_Penhas
SELECT * FROM F_Provincias
--Cantaores de sevilla que han actuado mas de 2 veces
SELECT COUNT(CS.Nombre_Artistico) AS[Actuaciones],CS.Nombre, CS.Apellidos FROM (
	--Cantaores que han actuado en penhas de Sevilla que canten Fandangos o Buler�as
	SELECT Provincia, C.Nombre, C.Apellidos, C.Nombre_Artistico FROM F_Palos AS[PA]
		INNER JOIN F_Palos_Cantaor AS[PC] ON PA.Cod_Palo = PC.Cod_Palo
		INNER JOIN F_Cantaores AS[C] ON PC.Cod_cantaor = C.Codigo
		INNER JOIN F_Actua AS[A] ON C.Codigo = A.Cod_Cantaor
		INNER JOIN F_Penhas AS[P] ON A.Cod_Penha = P.Codigo
		INNER JOIN F_Provincias AS[PR] ON P.Cod_provincia = PR.Cod_Provincia
		WHERE Provincia = 'Sevilla' AND PA.Cod_Palo IN('FH','BU')) AS[CS]
GROUP BY CS.Apellidos, CS.Nombre
HAVING COUNT(CS.Nombre_Artistico) > 2

--Ejercicio 5
--N�mero de actuaciones que se han celebrado en cada pe�a, incluyendo actuaciones directas
--y en festivales. Incluye el nombre de la pe�a y la localidad.
