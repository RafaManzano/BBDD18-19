USE pubs
SELECT * FROM titles
--1. Tienes que ir recorriendo la tabla con un bucle, leer cada fila y realizar la actualización que se indique.
--Si la columna TipoActualiza contiene una "I" hay que insertar una nueva fila en titles con todos los datos leídos 
--de esa fila de ActualizaTitles.
--Si TipoActualiza contiene una "D" hay que eliminar la fila cuyo código (title_id) se incluye.
--Si TipoActualiza es "U" hay que actualizar la fila identificada por title_id con las columnas que no sean Null. 
--Las que sean Null se dejan igual.
BEGIN TRANSACTION
SELECT * FROM ActualizaTitles
DECLARE @Numero INT 
SET @Numero = (SELECT TOP 1 NumActualiza FROM ActualizaTitles)
BEGIN TRANSACTION
SELECT @Numero = MIN(NumActualiza) FROM ActualizaTitles 
WHILE @Numero IS NOT NULL
BEGIN

--SELECT * FROM titles AS T
--INNER JOIN ActualizaTitles AS ATI ON T.title_id = ATI.title_id

IF 'U' = (SELECT TipoActualiza FROM ActualizaTitles WHERE NumActualiza = @Numero)
	BEGIN 
		UPDATE titles 
		SET title_id = ISNULL(ATI.title_id, T.title_id)
		, title = ISNULL(ATI.title, T.title)
		, type = ISNULL(ATI.type, T.type)
		, pub_id = ISNULL(ATI.pub_id, T.pub_id)
		, price = ISNULL(ATI.price, T.price)
		, advance = ISNULL(ATI.advance, T.advance)
		, royalty = ISNULL(ATI.royalty, T.royalty)
		, ytd_sales = ISNULL(ATI.ytd_sales, T.ytd_sales)
		, notes = ISNULL(ATI.notes, T.notes)
		, pubdate = ISNULL(ATI.pubdate, T.pubdate)
		--WHERE SI LOS ATRIBUTOS SON NULL SE QUEDAN IGUAL SI NO SE CAMBIA
		FROM titles AS T
		INNER JOIN ActualizaTitles AS ATI ON T.title_id = ATI.title_id 
		WHERE ATI.NumActualiza = @Numero
	END
	ELSE IF 'I' = (SELECT TipoActualiza FROM ActualizaTitles WHERE NumActualiza = @Numero)
		 BEGIN
			INSERT INTO titles(title_id, title, [type], pub_id, price, advance, royalty, ytd_sales, notes, pubdate)
			SELECT title_id, title, [type], pub_id, price, advance, royalty, ytd_sales, notes, pubdate FROM ActualizaTitles
			WHERE NumActualiza = @Numero
		 END

		 ELSE
			BEGIN
				DELETE FROM titles
				WHERE title_id = (SELECT title_id FROM ActualizaTitles WHERE NumActualiza = @Numero)
			END
			
SELECT @Numero = MIN(NumActualiza) FROM ActualizaTitles 
WHERE @Numero < NumActualiza		
END
--ROLLBACK
--COMMIT

