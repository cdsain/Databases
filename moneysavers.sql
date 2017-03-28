/* Alle klanten die in London wonen en minder dan 5 orders hebben gedaan, zonder ordening*/

SELECT Customers.CustomerID, Customers.CompanyName
FROM Customers
WHERE Customers.City = 'London'
	AND Customers.CustomerID IN (
	SELECT CustomerID
	FROM Orders
	WHERE OrderID IN (
		SELECT OrderID
		FROM [Order Details]
		WHERE Quantity < 5));

/* Alle klanten die in London wonen en minder dan 5 orders hebben gedaan, georderd op aantal orders */

SELECT Customers.CustomerID, Customers.CompanyName, MAX([Order Details].Quantity)
FROM Customers
	INNER JOIN Orders ON Orders.CustomerID = Customers.CustomerID
	INNER JOIN [Order Details] ON  [Order Details].OrderID = Orders.OrderID
WHERE Customers.City = 'London'
	AND [Order Details].Quantity < 5
GROUP BY Customers.CustomerID, Customers.CompanyName
ORDER BY MAX([Order Details].Quantity);


/* Alle orders voor pavlova met een sales resultaat van boven de 800 */

SELECT *
FROM Orders
WHERE OrderID IN (
	SELECT OrderID
	FROM [Order Details]
	WHERE Quantity * UnitPrice > 800 
	AND ProductID IN (
		SELECT ProductID
		FROM Products
		WHERE ProductName = 'Pavlova'));

/* Alle regio's waar chocolade is verkocht */

SELECT Region.RegionDescription
FROM Region
WHERE RegionID IN (
	SELECT RegionID
	FROM Territories
	WHERE TerritoryID IN (
		SELECT TerritoryID
		FROM EmployeeTerritories
		WHERE EmployeeID IN (
			SELECT EmployeeID
			FROM Orders
			WHERE OrderID IN (
				SELECT OrderID
				FROM [Order Details]
				WHERE ProductID IN (
					SELECT ProductID
					FROM Products
					WHERE ProductName = 'Chocolade')))));

/* Nu geschreven met INNER JOIN */
SELECT Region.RegionDescription
FROM Region
	INNER JOIN Territories ON Territories.RegionID = Region.RegionID
	INNER JOIN EmployeeTerritories ON EmployeeTerritories.TerritoryID = Territories.TerritoryID
	INNER JOIN Orders ON Orders.EmployeeID = EmployeeTerritories.EmployeeID
	INNER JOIN [Order Details] ON [Order Details].OrderID = Orders.OrderID
	INNER JOIN Products ON Products.ProductID = [Order Details].ProductID
WHERE ProductName = 'Chocolade'
GROUP BY Region.RegionDescription;

/* Alle orders voor tofu waar de freight kosten tussen 25 en 50 waren */

SELECT Orders.OrderID, Customers.CompanyName
FROM Orders
	INNER JOIN Customers ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.Freight BETWEEN 25 AND 50
	AND OrderID IN (
	SELECT OrderID
	FROM [Order Details]
	WHERE ProductID IN (
		SELECT ProductID
		FROM Products
		WHERE ProductName = 'Tofu'));

/* Plaatsnamen waar zowel klanten als werknemers wonen */

SELECT Employees.City AS City
FROM Employees, Customers
WHERE Employees.City = Customers.City
GROUP BY Employees.City;
	
/* Plaatsnamen waar zowel klanten als werknemers wonen, nu met subquery */
SELECT City
FROM Employees
WHERE Employees.City IN (
	SELECT City
	FROM Customers)
GROUP BY City;

/* Producten die het meest zijn verkocht aan Duitse klanten, en werknemers die ze hebben verkocht. Top 5 resultaten geordend op aantal */
SELECT TOP 5 Products.ProductID, Products.ProductName, Employees.EmployeeID, Employees.LastName, Employees.FirstName, Employees.Title
FROM Products
	INNER JOIN [Order Details] ON [Order Details].ProductID = Products.ProductID
	INNER JOIN Orders ON Orders.OrderID = [Order Details].OrderID
	INNER JOIN Employees ON Employees.EmployeeID = Orders.EmployeeID
	INNER JOIN Customers ON Customers.CustomerID = Orders.CustomerID
WHERE Customers.Country = 'Germany'
ORDER BY [Order Details].Quantity DESC;

/* Producten die het hoogste sales resultaat hebben opgeleverd bij Duitse klanten, en werknemers die ze hebben verkocht. Top 5 resultaten */
SELECT TOP 5 Products.ProductID, Products.ProductName, Employees.EmployeeID, Employees.LastName, Employees.FirstName, Employees.Title
FROM Products
	INNER JOIN [Order Details] ON [Order Details].ProductID = Products.ProductID
	INNER JOIN Orders ON Orders.OrderID = [Order Details].OrderID
	INNER JOIN Employees ON Employees.EmployeeID = Orders.EmployeeID
	INNER JOIN Customers ON Customers.CustomerID = Orders.CustomerID
WHERE Customers.Country = 'Germany'
ORDER BY [Order Details].Quantity * [Order Details].UnitPrice DESC;

/* Verschillende join methoden SQL */
SELECT *
FROM Products
	INNER JOIN Suppliers ON Suppliers.SupplierID = Products.SupplierID;

SELECT *
FROM Products
	LEFT JOIN Suppliers ON Suppliers.SupplierID = Products.SupplierID;

SELECT *
FROM Products
	RIGHT JOIN Suppliers ON Suppliers.SupplierID = Products.SupplierID;

SELECT *
FROM Products
	FULL OUTER JOIN Suppliers ON Suppliers.SupplierID = Products.SupplierID;

/* Gemiddelde sales resultaat van elke werknemer, geordend van laag naar hoog */

SELECT Employees.EmployeeID, Employees.LastName, Employees.FirstName, Employees.Title, AVG([Order Details].Quantity * [Order Details].UnitPrice) AS AverageResult
FROM Employees
	INNER JOIN Orders ON Orders.EmployeeID = Employees.EmployeeID
	INNER JOIN [Order Details] ON [Order Details].OrderID = Orders.OrderID
GROUP BY Employees.EmployeeID, Employees.LastName, Employees.FirstName, Employees.Title
ORDER BY AverageResult DESC;