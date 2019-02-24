
 -- Boletin 7.3
 -- Consultas sobre una sola Tabla sin agregados

 -- 1. Nombre, numero de producto, precio y color de los productos de color rojo o amarillo cuyo precio esté comprendido entre 50 y 500
 -- 2. Nombre, número de producto, precio de coste,  precio de venta, margen de beneficios total y margen de beneficios en % del precio de venta de los productos de categorías inferiores a 16
 -- 3. Empleados cuyo nombre o apellidos contenga la letra "r". Los empleados son los que tienen el valor "EM" en la columna PersonType de la tabla Person
 -- 4. LoginID, nationalIDNumber, edad y puesto de trabajo (jobTitle) de los empleados (tabla Employees) de sexo femenino que tengan más de cinco años de antigüedad
 -- 5. Ciudades correspondientes a los estados 11, 14, 35 o 70, sin repetir. Usar la tabla Person.Address

USE AdventureWorks2012

-- 1. Nombre, numero de producto, precio y color de los productos de color rojo o amarillo cuyo precio esté comprendido entre 50 y 500
 SELECT Name, ProductNumber, ListPrice, Color
 FROM   Production.Product 
 WHERE ListPrice between 50 and 500  AND Color LIKE 'Red' OR Color LIKE 'Yellow'

 -- 2. Nombre, número de producto, precio de coste,  precio de venta, margen de beneficios total y margen de beneficios en % del precio
 -- de venta de los productos de categorías inferiores a 16
 SELECT Name, ProductNumber, ListPrice
 FROM Production.Product
