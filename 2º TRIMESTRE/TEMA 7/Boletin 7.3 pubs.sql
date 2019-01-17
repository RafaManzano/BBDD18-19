USE pubs

--1. Título, precio y notas de los libros (titles) que tratan de cocina, ordenados de mayor a menor precio.
SELECT * FROM titles

SELECT title, price, notes FROM titles
WHERE [type] LIKE '%cook%'
ORDER BY price DESC

--2. ID, descripción y nivel máximo y mínimo de los puestos de trabajo (jobs) que pueden tener un nivel 110.
