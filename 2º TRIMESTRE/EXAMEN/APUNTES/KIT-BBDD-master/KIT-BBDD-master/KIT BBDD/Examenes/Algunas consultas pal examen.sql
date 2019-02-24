/* Dinero total gastado por el cliente "Paco Merselo" */
SELECT * FROM TMClientes
SELECT * FROM TMPedidos

SELECT SUM(p.Importe) AS [Dinero total], c.Nombre, c.Apellidos
	FROM TMClientes AS c
	INNER JOIN TMPedidos AS p
	ON c.ID = p.IDCliente
		WHERE c.Nombre = 'Paco' AND c.Apellidos = 'Merselo'
		GROUP BY c.Nombre, c.Apellidos

/* Dinero gastado en complementos por el cliente "Paco Merselo" */
SELECT * FROM TMClientes
SELECT * FROM TMPedidos
SELECT * FROM TMPedidosComplementos
SELECT * FROM TMComplementos

SELECT SUM(com.Importe * pcom.Cantidad) AS [Dinero total], cli.Nombre, cli.Apellidos
	FROM TMClientes AS cli
	INNER JOIN TMPedidos AS p
	ON cli.ID = p.IDCliente
	INNER JOIN TMPedidosComplementos AS pcom
	ON p.ID = pcom.IDPedido
	INNER JOIN TMComplementos AS com
	ON pcom.IDComplemento = com.ID
		WHERE cli.Nombre = 'Paco' AND cli.Apellidos = 'Merselo'
		GROUP BY cli.Nombre, cli.Apellidos

/*Tiempo medio transcurrido (en minutos) entre la hora de envío y de llegada de los pedidos del 
repartidor "Ana Conda" entre los meses 3 y 7 del año 2017*/
SELECT * FROM TMPedidos
SELECT * FROM TMRepartidores

SELECT AVG(DATEDIFF(MINUTE, p.Recibido, p.Enviado)) AS [Media en minutos], r.Nombre, r.Apellidos
	FROM TMPedidos AS p
	INNER JOIN TMRepartidores AS r
	ON p.IDRepartidor = r.ID
		WHERE r.Nombre = 'Ana' AND r.Apellidos = 'Conda' AND YEAR(p.Recibido) = '2017' AND (MONTH(p.Recibido) BETWEEN 3 AND 7)
		GROUP BY r.Nombre, r.Apellidos

/*Mes de mayor recaudacion de cada establecimiento durante el año 2015 y cantidad del mismo*/
SELECT * FROM TMPedidos
SELECT * FROM TMEstablecimientos

GO
CREATE VIEW [DineroMes] AS
SELECT YEAR(p.Recibido) AS [Año], MONTH(p.Recibido) AS [Mes], SUM(p.Importe) AS [Total recaudacion], e.Denominacion
	FROM TMPedidos AS p
	INNER JOIN TMEstablecimientos AS e
	ON p.IDEstablecimiento = e.ID
		WHERE YEAR(p.Recibido) = '2015'
		GROUP BY YEAR(p.Recibido), MONTH(p.Recibido), e.Denominacion
GO

GO
CREATE VIEW [DineroMesTotal] AS 
SELECT MAX(a.[Total recaudacion]) AS [MaximoTotalRecaudacion], a.Denominacion
	FROM (SELECT YEAR(p.Recibido) AS [Año], MONTH(p.Recibido) AS [Mes], SUM(p.Importe) AS [Total recaudacion], e.Denominacion
			FROM TMPedidos AS p
			INNER JOIN TMEstablecimientos AS e
			ON p.IDEstablecimiento = e.ID
				WHERE YEAR(p.Recibido) = '2015'
				GROUP BY YEAR(p.Recibido), MONTH(p.Recibido), e.Denominacion) AS a
		GROUP BY a.Denominacion
GO

SELECT dmt.MaximoTotalRecaudacion, dm.Denominacion, dm.Mes
	FROM DineroMes AS dm
	INNER JOIN DineroMesTotal AS dmt
	ON dm.[Total recaudacion] = dmt.MaximoTotalRecaudacion

/* Numero de mostachones de cada tipo que ha comprado el cliente Armando Bronca Segura*/
SELECT * FROM TMTiposMostachon
SELECT * FROM TMMostachones
SELECT * FROM TMPedidos
SELECT * FROM TMClientes

SELECT c.Nombre, c.Apellidos, COUNT(tm.Harina) AS [Tipo harina], tm.Harina
	FROM TMTiposMostachon AS tm
	INNER JOIN TMMostachones AS m
	ON tm.Harina = m.Harina
	INNER JOIN TMPedidos AS p
	ON m.IDPedido = p.ID
	INNER JOIN TMClientes AS c
	ON P.IDCliente = C.ID
		WHERE c.Nombre = 'Armando' AND c.Apellidos = 'Bronca Segura'
		GROUP BY c.Nombre, c.Apellidos, tm.Harina

/*Añade un nuevo mostachón, el cual ha sido pedido por el nuevo cliente. 
Este mostachón está hecho de harina integral, tiene lacasitos y gominolas y se ha servido en base de aluminio.*/
SELECT * FROM TMTiposMostachon
SELECT * FROM TMMostachones

INSERT INTO TMMostachones (ID, IDPedido, TMTiposMostachon, Harina)
	VALUES (7000, )

begin transaction

insert into TMPedidos 
values (2501,CURRENT_TIMESTAMP, '2018-02-12 19:55:00', 666, 1, 32, 0.20)

insert into TMMostachones
values (6236, 2501, 'Aluminio', 'Integral')

insert into TMMostachonesToppings
values (6236,
	(select id from TMToppings
	where Topping = 'Lacasitos')
),
(6236,
	(select id from TMToppings
	where Topping = 'Gominolas')
)

-- commit transaction

rollback

/*Cambia el topping añadido en la insercción anterior de "Gominolas" por "Sirope"*/

begin transaction

update TMMostachonesToppings
set IDTopping = (select ID from TMToppings  
					where Topping = 'Sirope')

where IDMostachon = 6236 and IDTopping = (select id from TMToppings
											where Topping = 'Gominolas')

rollback