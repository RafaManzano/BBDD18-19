USE pubs

--1. T�tulo, precio y notas de los libros (titles) que tratan de cocina, ordenados de mayor a menor precio.
SELECT * FROM titles

SELECT title, price, notes FROM titles
WHERE [type] LIKE '%cook%'
ORDER BY price DESC

--2. ID, descripci�n y nivel m�ximo y m�nimo de los puestos de trabajo (jobs) que pueden tener un nivel 110.
