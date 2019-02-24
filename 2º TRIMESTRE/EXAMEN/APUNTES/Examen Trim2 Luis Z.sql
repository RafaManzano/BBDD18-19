USE TMPrueba

--1.- Precio medio de los pedidos de cada mes de cada establecimiento y pedido más caro de ese mes.
--Tendrá cinco columnas: NombreEatablecimiento, ciudad, mes, precio medio, precio maximo

SELECT 
	E.Denominacion
	,E.Ciudad
	,MONTH(P.Enviado) AS Mes
	,YEAR(P.Enviado) AS Año
	,ROUND(AVG(Importe),2) AS Media
	,MAX(Importe) AS Maximo
FROM
	TMPedidos AS P
	JOIN TMEstablecimientos AS E
		ON P.IDEstablecimiento = E.ID
GROUP BY
	MONTH(P.Enviado), YEAR(P.Enviado), Denominacion, Ciudad
--Order BY
--	Denominacion
GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--2.- Mostachon favorito de cada cliente.
--Columnas: Nombre y apellidos, ciudad, mostachon favorito y topping favorito.

--Creamos una vista en la que podamos ver cuantas veces a pedido cada cliente cada mostachon y cada topping
GO
CREATE VIEW [MostachonesPedidosPorCadaCliente] AS  
SELECT 
	C.Nombre
	,C.Apellidos
	,M.Harina
	,COUNT(M.Harina) AS NumeroVecesMostachon
	,T.Topping
	,COUNT(MT.IDTopping) AS NumeroVecesTopping
FROM
	TMClientes AS C
	JOIN TMPedidos AS P
		ON C.ID = P.IDCliente
	JOIN TMMostachones AS M
		ON P.ID = M.IDPedido
	JOIN TMMostachonesToppings AS MT
		ON M.ID = MT.IDMostachon 
	JOIN TMToppings AS T
		ON MT.IDTopping = T.ID
GROUP BY 
	C.Nombre, C.Apellidos,M.Harina
	,MT.IDTopping
	,T.Topping


--con la vista anterior, creamos una nueva en la que podremos ver el mostachon mas pedido y el topping mas pedido por el cliente
GO
CREATE VIEW [MostachonesMasConsumidosCliente] AS
SELECT
	Nombre
	,Apellidos
	,MAX(NumeroVecesMostachon) AS VecesMostachon
	,MAX(NumeroVecesTopping) AS VecesTopping
FROM 
	[MostachonesPedidosPorCadaCliente]
GROUP BY 
	Nombre, Apellidos
GO

																																																																			--ToDo
--Un ultimo select para tener todos los datos bonitos que nos piden en el enunciado 
SELECT 
	MPC.Nombre
	,MPC.Apellidos
	,MPC.Harina
	,MPC.Topping
FROM	
	[MostachonesPedidosPorCadaCliente] AS MPC
	JOIN [MostachonesMasConsumidosCliente] AS MMP
	ON MMP.VecesMostachon = MPC.NumeroVecesMostachon AND MMP.VecesTopping = MPC.NumeroVecesTopping
GROUP BY 
	MPC.Nombre, MPC.Apellidos,MPC.Harina
	,MPC.Topping
ORDER BY
	 Apellidos
GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--3.- Establecimiento que aumentan o disminuyen ventas.
--Columnas: Nombre, ciudad, mostachones vendidos año actual, vendidos año pasado y diferencia

-- Vista en la que tenemos los pedidos de cada Establecimiento en el año actual. Utilizamos "GETDATE()" para que sea reutilizable en otros años
GO
CREATE VIEW [PedidosAñoActual] AS
SELECT
	E.ID 
	,E.Denominacion
	,E.Ciudad
	,YEAR(P.Enviado) AS Año
	,COUNT(P.ID) AS [NumeroPedidos]
FROM
	TMPedidos AS P
	JOIN TMEstablecimientos AS E
		ON P.IDEstablecimiento = E.ID
WHERE
	YEAR(P.Enviado) = YEAR(GETDATE())
GROUP BY
	E.ID, Denominacion, Ciudad,YEAR(P.Enviado)
GO

-- Vista en la que tenemos los pedidos de cada Establecimiento en el año pasado. Utilizamos "GETDATE()-1" para que sea reutilizable en otros años
CREATE VIEW [PedidosAñoPasado] AS
SELECT 
	E.ID 
	,E.Denominacion
	,E.Ciudad
	,YEAR(P.Enviado) AS Año
	,COUNT(P.ID) AS [NumeroPedidos]
FROM
	TMPedidos AS P
	JOIN TMEstablecimientos AS E
		ON P.IDEstablecimiento = E.ID
WHERE
	YEAR(P.Enviado) = YEAR(GETDATE())-1
GROUP BY
	E.ID, Denominacion, Ciudad,YEAR(P.Enviado)
GO

--Select final con todas las columnas que nos pide el enunciado
SELECT
	PAA.Denominacion
	,PAP.NumeroPedidos AS PedidosAñoPasado
	,PAA.NumeroPedidos AS PedidosAñoActual
	,CAST(((CAST(PAA.NumeroPedidos AS Decimal(5,2)) - PAP.NumeroPedidos) / PAP.NumeroPedidos) *100 AS Decimal(5,2)) AS Diferencia  --Lo mas probable es que esté mal este porcentaje
--	(act - ant) / ant *100
FROM
	[PedidosAñoPasado] AS PAP 
	JOIN [PedidosAñoActual] AS PAA
	ON PAP.ID = PAA.ID

GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE VIEW [NPedidosAño] AS
	SELECT 
		E.ID 
		,E.Denominacion
		,E.Ciudad
		,YEAR(P.Enviado) AS Año
		,COUNT(P.ID) AS [NumeroPedidos]
	FROM
		TMPedidos AS P
		JOIN TMEstablecimientos AS E
			ON P.IDEstablecimiento = E.ID
	--WHERE
	--	YEAR(P.Enviado) = YEAR(GETDATE())-1
	GROUP BY
		E.ID, Denominacion, Ciudad,YEAR(P.Enviado)
GO



SELECT
	PAA.Denominacion
	,PAA.Año
	,PAA.NumeroPedidos AS PedidosAño

	,PAP.Año
	,PAP.NumeroPedidos AS PedidosAño
	
	,CAST(((CAST(PAP.NumeroPedidos AS Decimal(6,2)) - PAA.NumeroPedidos) / PAP.NumeroPedidos) *100 AS Decimal(6,2)) AS Diferencia  --Lo mas probable es que esté mal este porcentaje
FROM
	[NPedidosAño] AS PAP 
	JOIN [NPedidosAño] AS PAA
	ON PAP.ID = PAA.ID AND  PAP.Año-1 = PAA.Año





-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--4.- Cambiar wasabi por sirope y tradicional por bambu en los pedidos de japon

--SELECT   -- ID = 28
--	ID
--FROM
--	TMEstablecimientos
--WHERE
--	Ciudad LIKE 'Tokyo'

INSERT INTO [dbo].[TMToppings] ([ID] ,[Topping])
     VALUES
           (123 ,'Wasabi')
GO

SELECT
	M.ID
FROM
	TMPedidos AS P
	JOIN TMMostachones AS M
		ON P.ID = M.IDPedido
	JOIN TMMostachonesToppings AS MT
		ON M.ID = MT.IDMostachon
	JOIN TMToppings AS T
		ON MT.IDTopping = T.ID
WHERE
	IDEstablecimiento = (SELECT ID FROM TMEstablecimientos WHERE Ciudad LIKE 'Tokyo') 
		AND IDTopping = (SELECT ID FROM TMToppings WHERE Topping LIKE 'Sirope')
		AND TipoBase LIKE 'Tradicional'
GO
BEGIN TRAN
UPDATE [dbo].[TMMostachones]
   SET 
	  [TipoBase] = 'Wasabi'
 WHERE ID=(
		 SELECT
			M.ID
		FROM
			TMPedidos AS P
			JOIN TMMostachones AS M
				ON P.ID = M.IDPedido
			JOIN TMMostachonesToppings AS MT
				ON M.ID = MT.IDMostachon
			JOIN TMToppings AS T
				ON MT.IDTopping = T.ID
		WHERE
			IDEstablecimiento = (SELECT ID FROM TMEstablecimientos WHERE Ciudad LIKE 'Tokyo') 
				AND IDTopping = (SELECT ID FROM TMToppings WHERE Topping LIKE 'Sirope')
			)
GO

update TMMostachonesToppings
set IDTopping = (
	select ID from TMToppings  
	where Topping = 'Wasabi'
	)
where IDTopping = (
	select id from TMToppings
	where Topping = 'Sirope'
)

GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--5.-inserta un nuevo pedido
--Olga LLinero de Madrid: Dos mostachones, uno de maiz sobre base de papel reciclado con mermelada
--																			uno de espelta sobre base de cartulina con nata y almendras picadas.  Y un Café

--SELECT  --Select para comprobar si existe el mostachon como el que ha pedido Olga en primer lugar
--	M.ID
--	,B.Base
--	,M.Harina
--	,Topping
--FROM
--	TMMostachones AS M
--	JOIN TMMostachonesToppings AS MT
--		ON M.ID = MT.IDMostachon 
--	JOIN TMBases AS B
--		ON M.TipoBase = B.Base
--	JOIN TMToppings AS T
--		ON MT.IDTopping = T.ID
--WHERE
--	Harina LIKE 'Maíz' AND Base LIKE 'Reciclado' AND Topping LIKE 'Mermelada'


--SELECT  --Select para comprobar si existe el mostachon como el que ha pedido Olga en segundo lugar
--	M.ID
--	,B.Base
--	,M.Harina
--	,Topping
--FROM
--	TMMostachones AS M
--	JOIN TMMostachonesToppings AS MT
--		ON M.ID = MT.IDMostachon 
--	JOIN TMBases AS B
--		ON M.TipoBase = B.Base
--	JOIN TMToppings AS T
--		ON MT.IDTopping = T.ID
--WHERE
--	Harina LIKE 'Espelta' AND Base LIKE 'Cartulina' AND Topping LIKE 'Nata'

--SELECT ID FROM TMClientes WHERE Nombre LIKE 'Olga' AND Apellidos LIKE 'Llinero'
--SELECT ID FROM TMEstablecimientos WHERE Denominacion LIKE 'Sol Naciente'

--SELECT * FROM TMPedidos WHERE ID = 66666
--SELECT COUNT(*) FROM TMMostachones WHERE IDPedido = 66666
--ROLLBACK TRAN

BEGIN TRAN
INSERT INTO TMPedidos  ([ID] ,[Recibido]  ,[Enviado]  ,[IDCliente]  ,[IDEstablecimiento]  ,[IDRepartidor]  ,[Importe])
     VALUES
           (66666
           ,CURRENT_TIMESTAMP
           ,NULL
           ,(SELECT ID FROM TMClientes WHERE Nombre LIKE 'Olga' AND Apellidos LIKE 'Llinero')
           ,(SELECT ID FROM TMEstablecimientos WHERE Denominacion LIKE 'Sol Naciente')
           ,NULL
           ,((2 * 2) + (0.6 * 2))+(SELECT Importe FROM TMComplementos WHERE Complemento Like 'Café') -- (2 * 2) + (0.6 * 2) + (6/5)  --Habra que calcularlo haciendo una consulta
		   ) 
GO

INSERT INTO TMMostachones (TipoBase, Harina, IDPedido,ID)
     VALUES
           ('Reciclado'
		   ,'Maíz'
		   ,66666
		   ,122312
		   )
GO
INSERT INTO TMMostachones (TipoBase, Harina, IDPedido,ID)
     VALUES
		('Cartulina'
		   ,'Espelta'
		   ,66666
		   , 122313
		   )
GO