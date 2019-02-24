USE ICOTR

-- Inserta un cliente que haga un pedido con un helado de sabor chocolate con toppin de Caramelo una cocacola como complemento y en recipiente tulipa
SELECT * FROM ICToppings
SELECT * FROM ICClientes
SELECT * FROM ICPedidos
SELECT * FROM ICEstablecimientos
SELECT * FROM ICRepartidores
SELECT * FROM ICHelados
SELECT * FROM ICComplementos
SELECT * FROM ICPedidosComplementos
SELECT * FROM ICToppings
SELECT * FROM ICHeladosToppings

GO
CREATE VIEW V_HeladosCompradosTomiRabo AS
	SELECT I.ID FROM ICHelados as I
	JOIN ICPedidos AS P ON I.IDPedido = P.ID
	WHERE P.IDCliente IN (SELECT ID FROM ICClientes WHERE Nombre = 'Tomi' AND Apellidos = 'Rabo')
GO

GO
CREATE VIEW V_Pedidos AS
	SELECT ID FROM ICPedidos
	WHERE IDCliente IN (SELECT ID FROM ICClientes WHERE Nombre = 'Tomi' AND Apellidos = 'Rabo')
GO

-- Insertamos un nuevo cliente
BEGIN TRANSACTION 
INSERT INTO ICClientes (ID, Nombre, Apellidos, Direccion, Ciudad, Telefono1, Telefono2)
VALUES (34, 'Tomi', 'Rabo', 'C/ Carajo', 'Sevilla', 699699699, 699499399)
ROLLBACK TRANSACTION

-- Insertamos un nuevo pedido realizado por el cliente anterior
INSERT INTO ICPedidos (ID, Recibido, Enviado, IDCliente, IDEstablecimiento, IDRepartidor, Importe)
VALUES (2501, 2015, 2014, (SELECT ID FROM ICClientes WHERE Nombre = 'Tomi' AND Apellidos = 'Rabo'), 7, 30, 3.5)

-- Insertamos un nuevo helado pedido por el cliente anterior
INSERT INTO ICHelados (ID ,IDPedido, TipoContenedor, Sabor)
VALUES (6236, (SELECT ID FROM V_Pedidos), 'Tulipa', 'Chocolate')

-- Insertamos los toppin del helado anterior
INSERT INTO ICHeladosToppings(IDHelado, IDTopping)
SELECT (SELECT ID FROM V_HeladosCompradosTomiRabo), (SELECT ID FROM ICToppings WHERE Topping = 'Caramelo')

-- Insertamos los complementos del pedido
INSERT INTO ICPedidosComplementos (IDPedido, IDComplemento, Cantidad)
SELECT (SELECT ID FROM V_Pedidos), (SELECT ID FROM ICComplementos WHERE Complemento = 'Refresco'), 1

 -- Consultamos
 SELECT IDCliente FROM ICClientes AS C
 JOIN ICPedidos AS P ON C.ID = P.IDCliente
 WHERE P.IDCliente IN (SELECT ID FROM ICClientes WHERE Nombre = 'Tomi' AND Apellidos = 'Rabo')

