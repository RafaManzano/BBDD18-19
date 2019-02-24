Use TeleMostachon
Go

    /*******************************************************************************************/
   /*                                                                                         */
  /*	                                  Ejercicio 1                                        */
 /*                                                                                         */
/*******************************************************************************************/
--Obtén el precio medio de los pedidos de cada mes de cada establecimiento, así como el precio del más caro. La consulta tendrá cinco columnas: Nombre del establecimiento, ciudad, nombre (o número) del mes, Precio medio de los pedidos y precio del más caro.
--Los meses que se llaman igual de cada año se consideran diferentes, es decir, enero de 2015 es un mes y enero de 2016 es otro.

SELECT E.Denominacion, E.Ciudad, YEAR(P.Recibido) AS [Año], MONTH (P.Recibido) AS Mes, AVG(P.Importe) AS ImporteMedio, MAX(P.Importe) AS ImporteMayor FROM TMPedidos AS P
	INNER JOIN TMEstablecimientos AS E ON P.IDEstablecimiento = E.ID
	GROUP BY E.ID,E.Denominacion, E.Ciudad, YEAR(P.Recibido), MONTH (P.Recibido)
	Order By E.Ciudad, E.Denominacion, YEAR(P.Recibido), MONTH (P.Recibido)

    /*******************************************************************************************/
   /*                                                                                         */
  /*	                                  Ejercicio 2                                        */
 /*                                                                                         */
/*******************************************************************************************/
--Queremos saber cuál es el tipo de mostachón y el topping favoritos de cada cliente. Nombre y apellidos del cliente, ciudad, tipo de mostachón favorito y topping favorito

--Número de veces que cada cliente ha pedido cada tipo
SELECT P.IDCliente, M.Harina, Count(*) As Veces FROM TMPedidos AS P
	INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
	Group By P.IDCliente, M.Harina

--Número de mayor de veces que cada cliente ha pedido el tipo favorito
Select MAX(Veces), IDCliente FROM
(SELECT P.IDCliente, M.Harina, Count(*) As Veces FROM TMPedidos AS P
	INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
	Group By P.IDCliente, M.Harina) AS TipoHarina
	Group By IDCliente

-- Unión de las dos consultas 
Select MaximaHarina.IDCliente, MaximaHarina.HarinaMaxima, TipoHarina.Harina FROM
	(Select MAX(Veces) AS HarinaMaxima, IDCliente FROM
	(SELECT P.IDCliente, M.Harina, Count(*) As Veces FROM TMPedidos AS P
		INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
		Group By P.IDCliente, M.Harina) AS TipoHarina
		Group By IDCliente) As MaximaHarina
	INNER Join
	(SELECT P.IDCliente, M.Harina, Count(*) As Veces FROM TMPedidos AS P
		INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
		Group By P.IDCliente, M.Harina) AS TipoHarina
	ON MaximaHarina.IDCliente = TipoHarina.IDCliente AND MaximaHarina.HarinaMaxima = TipoHarina.Veces

-- Ahora lo mismo con los toppings
--Número de veces que cada cliente ha pedido cada topping
SELECT P.IDCliente, MT.IDTopping, Count(*) As Veces FROM TMPedidos AS P
	INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
	INNER JOIN TMMostachonesToppings AS MT ON M.ID = MT.IDMostachon
	Group By P.IDCliente, MT.IDTopping

--Número de mayor de veces que cada cliente ha pedido el topping favorito
Select MAX(Veces) As ToppingMaximo, IDCliente FROM
(SELECT P.IDCliente, MT.IDTopping, Count(*) As Veces FROM TMPedidos AS P
	INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
	INNER JOIN TMMostachonesToppings AS MT ON M.ID = MT.IDMostachon
	Group By P.IDCliente, MT.IDTopping) AS Toppings
	Group By IDCliente

-- Unión de las dos consultas 
Select MaximoTopping.IDCliente, MaximoTopping.ToppingMaximo, TipoTopping.IDTopping FROM
	(Select MAX(Veces) As ToppingMaximo, IDCliente FROM
(SELECT P.IDCliente, MT.IDTopping, Count(*) As Veces FROM TMPedidos AS P
	INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
	INNER JOIN TMMostachonesToppings AS MT ON M.ID = MT.IDMostachon
	Group By P.IDCliente, MT.IDTopping) AS Toppings
	Group By IDCliente) As MaximoTopping
	INNER Join
	(SELECT P.IDCliente, MT.IDTopping, Count(*) As Veces FROM TMPedidos AS P
	INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
	INNER JOIN TMMostachonesToppings AS MT ON M.ID = MT.IDMostachon
	Group By P.IDCliente, MT.IDTopping) AS TipoTopping
	ON MaximoTopping.IDCliente = TipoTopping.IDCliente AND MaximoTopping.ToppingMaximo = TipoTopping.Veces

-- Unión de todo y con la tabla Clientes para tener su nombre
SELECT C.Nombre, C.Apellidos, Harina.Harina, Harina.HarinaMaxima, T.Topping, Toppings.ToppingMaximo FROM
	(Select MaximaHarina.IDCliente, MaximaHarina.HarinaMaxima, TipoHarina.Harina FROM
		(Select MAX(Veces) AS HarinaMaxima, IDCliente FROM
		(SELECT P.IDCliente, M.Harina, Count(*) As Veces FROM TMPedidos AS P
			INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
			Group By P.IDCliente, M.Harina) AS TipoHarina
			Group By IDCliente) As MaximaHarina
		INNER Join
		(SELECT P.IDCliente, M.Harina, Count(*) As Veces FROM TMPedidos AS P
			INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
			Group By P.IDCliente, M.Harina) AS TipoHarina
		ON MaximaHarina.IDCliente = TipoHarina.IDCliente AND MaximaHarina.HarinaMaxima = TipoHarina.Veces) As Harina
	INNER JOIN
	(Select MaximoTopping.IDCliente, MaximoTopping.ToppingMaximo, TipoTopping.IDTopping FROM
		(Select MAX(Veces) As ToppingMaximo, IDCliente FROM
	(SELECT P.IDCliente, MT.IDTopping, Count(*) As Veces FROM TMPedidos AS P
		INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
		INNER JOIN TMMostachonesToppings AS MT ON M.ID = MT.IDMostachon
		Group By P.IDCliente, MT.IDTopping) AS Toppings
		Group By IDCliente) As MaximoTopping
		INNER Join
		(SELECT P.IDCliente, MT.IDTopping, Count(*) As Veces FROM TMPedidos AS P
		INNER JOIN TMMostachones AS M ON P.ID = M.IDPedido
		INNER JOIN TMMostachonesToppings AS MT ON M.ID = MT.IDMostachon
		Group By P.IDCliente, MT.IDTopping) AS TipoTopping
		ON MaximoTopping.IDCliente = TipoTopping.IDCliente AND MaximoTopping.ToppingMaximo = TipoTopping.Veces) As Toppings
	ON Harina.IDCliente = Toppings.IDCliente
	JOIN TMClientes AS C ON Harina.IDCliente = C.ID
	JOIN TMToppings AS T ON Toppings.IDTopping = T.ID

    /*******************************************************************************************/
   /*                                                                                         */
  /*	                                  Ejercicio 3                                        */
 /*                                                                                         */
/*******************************************************************************************/

--Queremos saber los establecimientos que aumentan o disminuyen el número de mostachones que venden, para ello queremos una consulta que nos diga el nombre y ciudad del establecimiento, el número de mostachones vendidos en el año actual, en el año anterior (si existe) y su aumento o disminución en tanto por ciento

--Número de mostachones vendidos por cada establecimiento cada año
SELECT P.IDEstablecimiento, Year(P.Recibido) As Anno, Count(*) As NumeroMostachones 
	From TMPedidos AS P
	Inner JOIN TMMostachones AS M ON P.ID = M.IDPedido
	GROUP BY P.IDEstablecimiento, Year(P.Recibido)
	
-- Hacemos JOIN de esa consulta consigo misma y con la tabla TMEstablecimientos
SELECT E.Denominacion, E.Ciudad, Actual.Anno, Actual.NumeroMostachones AS Ventas, Anterior.NumeroMostachones AS  AñoAnterior,
	(CAST((Actual.NumeroMostachones-Anterior.NumeroMostachones) AS Decimal (8,3))/Anterior.NumeroMostachones)*100 AS Variacion 
	FROM (SELECT P.IDEstablecimiento, Year(P.Recibido) As Anno, Count(*) As NumeroMostachones 
		From TMPedidos AS P
		Inner JOIN TMMostachones AS M ON P.ID = M.IDPedido
		GROUP BY P.IDEstablecimiento, Year(P.Recibido)) AS Actual
	JOIN (SELECT P.IDEstablecimiento, Year(P.Recibido) As Anno, Count(*) As NumeroMostachones 
		From TMPedidos AS P
		Inner JOIN TMMostachones AS M ON P.ID = M.IDPedido
		GROUP BY P.IDEstablecimiento, Year(P.Recibido)) AS Anterior
	ON Actual.IDEstablecimiento = Anterior.IDEstablecimiento AND Actual.Anno = Anterior.Anno + 1
	JOIN TMEstablecimientos As E ON Actual.IDEstablecimiento = E.ID
	Order By E.Ciudad,E.Denominacion,Actual.Anno

    /*******************************************************************************************/
   /*                                                                                         */
  /*	                                  Ejercicio 4                                        */
 /*                                                                                         */
/*******************************************************************************************/
--Una auditoría interna ha descubierto que las instrucciones enviadas al establecimiento de Japón tenían errores de traducción y los pedidos en los que se ha pedido topping de jalapeño los han servido con wasabi. Además en lugar de la base tradicional han utilizado bambú.
--Inserta ese topping y esa base si no aparecen en la base de datos y actualiza los pedidos del establecimiento de Japón para que la información sea correcta.

-- Insertamos la base que falta
INSERT INTO TMBases (Base) VALUES ('Bambú')

-- Insertamos el topping

GO
--Primero vamos a ver los mostachones que tenemos que cambiar: Todos los servidos por el establecimiento de Japón con base Tradicional
Select * FROM TMMostachones AS M
	INNER Join TMPedidos AS P ON M.IDPedido = P.ID
	INNER Join TMEstablecimientos AS E ON P.IDEstablecimiento = E.ID
	Where E.Ciudad = 'Tokyo' AND M.TipoBase = 'Tradicional        '

--Forma sencilla: Con una subconsulta
Begin transaction
UPDATE TMMostachones 
	Set TipoBase = 'Bambú'
		Where ID IN (
		Select M.ID FROM TMMostachones AS M
		INNER Join TMPedidos AS P ON M.IDPedido = P.ID
		INNER Join TMEstablecimientos AS E ON P.IDEstablecimiento = E.ID
		Where E.Ciudad = 'Tokyo' AND M.TipoBase = 'Tradicional         ')
Rollback
-- Relacionando tablas
UPDATE TMMostachones 
		Set TipoBase = 'Bambú'
		From TMPedidos AS P
		INNER Join TMEstablecimientos AS E ON P.IDEstablecimiento = E.ID
		Where (TMMostachones.IDPedido = P.ID) AND (E.Ciudad = 'Tokyo' AND TipoBase = 'Tradicional         ')

-- O también
UPDATE TMMostachones
	Set TipoBase = 'Bambú'
	FROM TMMostachones AS M
	INNER Join TMPedidos AS P ON M.IDPedido = P.ID
	INNER Join TMEstablecimientos AS E ON P.IDEstablecimiento = E.ID
	Where E.Ciudad = 'Tokyo' AND M.TipoBase = 'Tradicional         '

    /*******************************************************************************************/
   /*                                                                                         */
  /*	                                  Ejercicio 5                                        */
 /*                                                                                         */
/*******************************************************************************************/
--Nuestra cliente Olga Llinero de Madrid ha hecho un pedido ahora mismo al establecimiento Sol Naciente. El pedido está formado por dos mostachones, uno de Maíz sobre base de papel reciclado con topping de mermelada y otro de espelta sobre base de cartulina con toppings de nata y almendras picadas. Además se añade un café.
--Se valorará positivamente si se crea ese pedido insertando las nuevas filas que correspondan con instrucciones INSERT-SELECT para cada tabla sin usar más datos que los que se te han proporcionado o los que tu añadas (ID del pedido e ID del mostachón). Cada mostachón vale 2€ y cada topping 0,60€. El repartidor y la fecha de envío se dejan a NULL.

-- Primero creamos el pedido
Insert INTO TMPedidos (ID,Recibido,Enviado,IDCliente,IDEstablecimiento,IDRepartidor,Importe)
	SELECT 1001,CURRENT_TIMESTAMP,Null,C.ID,E.ID,Null, 2*2+3*0.6+Co.Importe
		FROM TMClientes AS C
		CROSS JOIN TMEstablecimientos AS E
		CROSS JOIN TMComplementos AS Co
		Where C.Apellidos = 'Llinero' AND C.Nombre = 'Olga' AND E.Denominacion = 'Sol Naciente' AND Co.Complemento = 'Café'

-- Ahora los mostachones
Insert INTO TMMostachones(ID,IDPedido,TipoBase,Harina)
	VALUES (1001, 1001, 'Reciclado', 'Maíz'),(1002, 1001,'Cartulina', 'Espelta')

-- Añadimos el café

-- Y los toppings