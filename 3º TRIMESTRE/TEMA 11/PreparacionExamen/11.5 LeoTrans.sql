USE TransLeo
SELECT * FROM TL_PaquetesNormales
--1. Crea un función fn_VolumenPaquete que reciba el código de un paquete y nos devuelva
--su volumen. El volumen se expresa en litros (dm3) y será de tipo decimal(6,2).
/*
Interfaz
Nombre: FN_VolumenPaquete
Cabecera: CREATE FUNCTION FN_VolumenPaquete @CodigoPaquete INT
Precondiciones: No hay
Entrada: - @CodigoPaquete INT //Es el codigo del paquete para que digamos su volumen
Salida: - @Volumen DECIMAL (6,2) //Es el volumen del paquete indicado por parametros
E/S: No hay
Postcondiciones: Se devolvera el volumen del paquete introducido por parametros
*/

GO
ALTER FUNCTION FN_VolumenPaquetev2 (@CodigoPaquete INT)
RETURNS DECIMAL (6,2) AS
BEGIN
DECLARE @Volumen DECIMAL (6,2)
DECLARE @Mil DECIMAL (6,2)
SET @Mil = 1000
SET @Volumen = (SELECT SUM((Alto * Ancho * Largo) / @Mil) AS Suma FROM TL_PaquetesNormales
			   WHERE Codigo = @CodigoPaquete)
RETURN @Volumen
END
GO	

SELECT dbo.FN_VolumenPaquetev2(600)

