USE pubs
SELECT * FROM titles
--1. Tienes que ir recorriendo la tabla con un bucle, leer cada fila y realizar la actualización que se indique.
--Si la columna TipoActualiza contiene una "I" hay que insertar una nueva fila en titles con todos los datos leídos 
--de esa fila de ActualizaTitles.
--Si TipoActualiza contiene una "D" hay que eliminar la fila cuyo código (title_id) se incluye.
--Si TipoActualiza es "U" hay que actualizar la fila identificada por title_id con las columnas que no sean Null. 
--Las que sean Null se dejan igual.

BEGIN TRANSACTION
--SELECT * FROM ActualizaTitles
--Se declara un numero para el contador cogiendo el numero de NumActualiza
DECLARE @Numero INT 
SET @Numero = (SELECT TOP 1 NumActualiza FROM ActualizaTitles)
BEGIN TRANSACTION
SELECT @Numero = MIN(NumActualiza) FROM ActualizaTitles 
WHILE @Numero IS NOT NULL
BEGIN
--SELECT * FROM titles AS T
--INNER JOIN ActualizaTitles AS ATI ON T.title_id = ATI.title_id

--Hay que mirar con un select de que el TipoActualiza es el indicado
IF 'U' = (SELECT TipoActualiza FROM ActualizaTitles WHERE NumActualiza = @Numero)
	BEGIN 
		UPDATE titles 
		--La funcion isnull te dice que si no es nulo coja la primera parte (,) y si lo es la segunda
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
		FROM titles AS T
		INNER JOIN ActualizaTitles AS ATI ON T.title_id = ATI.title_id
		--Lo mas importante es el where
		WHERE ATI.NumActualiza = @Numero
	END
	--Hay que mirar con un select de que el TipoActualiza es el indicado
	ELSE IF 'I' = (SELECT TipoActualiza FROM ActualizaTitles WHERE NumActualiza = @Numero)
		 BEGIN
			INSERT INTO titles(title_id, title, [type], pub_id, price, advance, royalty, ytd_sales, notes, pubdate)
			SELECT title_id, title, [type], pub_id, price, advance, royalty, ytd_sales, notes, pubdate FROM ActualizaTitles
			--Lo mas importante es el where
			WHERE NumActualiza = @Numero
		 END

		 ELSE
			BEGIN
				DELETE FROM titles
				--Lo mas importante es el where
				WHERE title_id = (SELECT title_id FROM ActualizaTitles WHERE NumActualiza = @Numero)
			END
			
SELECT @Numero = MIN(NumActualiza) FROM ActualizaTitles 
WHERE @Numero < NumActualiza		
END
--ROLLBACK
--COMMIT

