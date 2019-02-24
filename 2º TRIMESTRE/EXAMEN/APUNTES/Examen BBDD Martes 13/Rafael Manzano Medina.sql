USE TMPrueba

SELECT * FROM TMMostachones
SELECT * FROM TMToppings
SELECT * FROM TMTiposMostachon
SELECT * FROM TMPedidos
--Ejercicio 1. Obten el precio medio de los pedidos de cada mes de cada establecimmiento, asi como el precio del mas caro NO ESTOY SEGURO
/*
GO
CREATE VIEW TotalMesEstablecimiento AS
SELECT  SUM(Importe) AS ImporteTotal,  DATEPART(MONTH,Enviado) AS Mes, DATEPART(YEAR,Enviado)  AS Anho, IDEstablecimiento FROM TMPedidos
GROUP BY DATEPART(MONTH,Enviado), DATEPART(YEAR,Enviado), IDEstablecimiento
GO

SELECT E.Denominacion, E.Ciudad, TME.Mes, AVG(TME.ImporteTotal) AS ImporteMedio, MAX(TME.ImporteTotal) AS ImporteMaximo FROM TotalMesEstablecimiento AS TME
INNER JOIN TMEstablecimientos AS E
ON TME.IDEstablecimiento = E.ID
GROUP BY E.Denominacion, E.Ciudad, TME.Mes
ORDER BY TME.Mes ASC
*/

SELECT E.Denominacion, E.Ciudad, YEAR(P.Recibido) AS [Año], MONTH (P.Recibido) AS Mes, AVG(P.Importe) AS ImporteMedio, MAX(P.Importe) AS ImporteMayor FROM TMPedidos AS P
	INNER JOIN TMEstablecimientos AS E ON P.IDEstablecimiento = E.ID
	GROUP BY E.ID,E.Denominacion, E.Ciudad, YEAR(P.Recibido), MONTH (P.Recibido)
	Order By E.Ciudad, E.Denominacion, YEAR(P.Recibido), MONTH (P.Recibido)


--Ejercicio 2. Queremos saber cual es el tipo de mostachon y topping favorito de cada cliente. 
--Nombre y apellidos del cliente, ciudad, tipo de mostachon favorito y topping favorito INACABADO

GO
CREATE VIEW TiposMostachones AS
SELECT COUNT(IDPedido) AS Mostachones, TM.Harina FROM TMMostachones AS M
INNER JOIN TMTiposMostachon AS TM
ON M.Harina = TM.Harina
GROUP BY TM.Harina
GO


GO
CREATE VIEW MaximoTopping AS 
SELECT COUNT(M.IDPedido) AS Toppinings, T.Topping FROM TMMostachones AS M
INNER JOIN TMMostachonesToppings AS MT
ON MT.IDMostachon = M.ID
INNER JOIN TMToppings AS T
ON T.ID = MT.IDTopping
GROUP BY T.Topping
GO

SELECT MAX(TM.Harina) AS Mostachones, P.IDCliente FROM TiposMostachones AS TM
INNER JOIN TMPedidos AS P
ON P.ID = TM.Mostachones
INNER JOIN MaximoTopping AS MT
ON MT.Toppinings = TM.Mostachones
GROUP BY P.IDCliente

--Ejercicio 3. Queremos saber los establecimientos que aumentan o disminuyen el numero de mostachones que venden, para ello queremos una consulta
-- que nos diga el nombre y ciudad del establecimiento, el numero de mostachones vendidos en el año actual, 
--en el anterior (si existe) y su aumento o disminucion en tantos por ciento NI POR ASOMO, NO VEO COMO HACERLO
GO
CREATE VIEW PedidosEstablecimientosAnhos AS
SELECT COUNT(P.ID) AS Pedidos, E.Denominacion, DATEPART(YEAR,P.Enviado) AS Anho FROM TMEstablecimientos AS E
INNER JOIN TMPedidos AS P
ON E.ID = P.IDEstablecimiento
GROUP BY E.Denominacion, DATEPART(YEAR,P.Enviado)
GO





--Ejercicio 4. Inserta ese topping y esa base si no aparecen en la base de datos y actualiza los pedidos del establecimiento de Japon para que la
--informacion sea correcta DE MOMENTO SE QUEDA ASI
SELECT * FROM TMToppings
SELECT * FROM TMBases
INSERT INTO TMToppings(ID, Topping)
	VALUES (199, 'Wasabi')

INSERT INTO TMBases (Base) 
	VALUES ('Bambu')

begin transaction

UPDATE TMMostachones 
		Set TipoBase = 'Bambú               '
		From TMPedidos AS P
		INNER Join TMEstablecimientos AS E ON P.IDEstablecimiento = E.ID
		Where (TMMostachones.IDPedido = P.ID) AND (E.Ciudad = 'Tokyo' AND TipoBase = 'Tradicional')

UPDATE TMMostachonesToppings 
		SET IDTopping = 199
		FROM TMMostachones AS M
		INNER JOIN TMPedidos AS P
		ON P.ID = M.IDPedido
		INNER JOIN TMEstablecimientos AS E
		ON P.IDEstablecimiento = E.ID
		WHERE (TMMostachonesToppings.IDMostachon = M.ID) AND (E.Ciudad = 'Tokyo' AND IDTopping = 1)
--Ejercicio 5. Nuestra clienta Olga Llinero de Madrid ha hecho un pedido ahora mismo al establecimiento Sol naciente. El pedido esta formado
-- por dos mostachones, uno de Maiz sobre base de papel reciclado con topping de mermelada y otro de espelta sobre base de cartulina con toppings
-- de nata y almendras picadas. Ademas se añade un cafe
INSERT INTO TMMostachones (ID, IDPedido, TipoBase, Harina)
	VALUES (7000, 65600, 'Reciclado' , 'Maiz')

INSERT INTO TMMostachones (ID, IDPedido, TipoBase, Harina)
	VALUES (7001, 65630, 'Cartulina', 'Espelta')

INSERT INTO TMPedidosComplementos (IDPedido, IDComplemento, Cantidad)
	VALUES (5005,39,1)