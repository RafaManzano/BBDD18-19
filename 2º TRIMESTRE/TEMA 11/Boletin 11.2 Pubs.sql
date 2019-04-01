USE pubs
--1. Tienes que ir recorriendo la tabla con un bucle, leer cada fila y realizar la actualización que se indique.
--Si la columna TipoActualiza contiene una "I" hay que insertar una nueva fila en titles con todos los datos leídos 
--de esa fila de ActualizaTitles.
--Si TipoActualiza contiene una "D" hay que eliminar la fila cuyo código (title_id) se incluye.
--Si TipoActualiza es "U" hay que actualizar la fila identificada por title_id con las columnas que no sean Null. 
--Las que sean Null se dejan igual.
BEGIN TRANSACTION
WHILE (SELECT NumActualiza FROM ActualizaTitles) IS NOT NULL
--SELECT * FROM titles AS T
--INNER JOIN ActualizaTitles AS ATI ON T.title_id = ATI.title_id
WHERE CASE(TipoActualiza)
					  /*WHEN 'U' THEN UPDATE titles 
									  SET title_id = ATI.title_id,
										  title = ATI.title,
										  type = ATI.type,
										  pub_id = ATI.pub_id,
										  price = ATI.price,
										  advance = ATI.advance,
										  royalty = ATI.royalty,
										  ytd_sales = ATI.ytd_sales,
										  notes = ATI.notes,
										  pubdate = ATI.pubdate
									  FROM ActualizaTitles AS ATI
									--WHERE SI LOS ATRIBUTOS SON NULL SE QUEDAN IGUAL SI NO SE CAMBIA
									*/
					  WHEN 'I' THEN INSERT INTO titles(title_id, title, [type], pub_id, price, advance, royalty, ytd_sales, notes, pubdate)
									SELECT title_id, title, [type], pub_id, price, advance, royalty, ytd_sales, notes, pubdate FROM ActualizaTitles
					  WHEN 'D' THEN DELETE FROM titles
									WHERE title_id = (SELECT title_id FROM ActualizaTitles)		


