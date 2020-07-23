USE motocars;

--- 1) Создать представление статистики о продажах во всех автосалонах
GO
CREATE VIEW v1
AS
SELECT shops.shop_name, COUNT(sales.id) AS 'count_sales', SUM(cars.price) AS 'sum', COUNT(sales.client_id) AS 'count_clients'
FROM sales
JOIN shops ON shops.id = sales.shop_id
JOIN cars ON cars.id = sales.car_id
GROUP BY shops.shop_name;

--- 2) Создать представления (2 отдельных) с данными о продажах в салоне Иномарка и 4 колеса
GO
CREATE VIEW v2
AS
SELECT clients.name, cars.model, cars.price, sales.sale_date FROM sales
JOIN shops ON shops.id = sales.shop_id AND shops.shop_name = '4 колеса'
JOIN clients ON clients.id = sales.client_id
JOIN cars ON cars.id = sales.car_id;

GO
CREATE VIEW v3
AS
SELECT clients.name, cars.model, cars.price, sales.sale_date FROM sales
JOIN shops ON shops.id = sales.shop_id AND shops.shop_name = 'Иномарка'
JOIN clients ON clients.id = sales.client_id
JOIN cars ON cars.id = sales.car_id;

---3) Создать представление, которое будет содержать информацию о клиентах, которые сделали покупки во всех автосалонах
GO
CREATE VIEW v4
AS
SELECT clients.name FROM clients
JOIN (SELECT sales.client_id as 'id', COUNT(DISTINCT sales.shop_id) AS 'count' FROM sales
	  GROUP BY sales.client_id
      HAVING COUNT(DISTINCT sales.shop_id) = (SELECT COUNT(id) FROM shops)) tmp ON tmp.id = clients.id;

---4) Найти покупателей, которые приобретали машины в автосалоне Иномарка, при этом не приобретали автомобили в салоне 4 колеса, сохранить запрос как представление
GO
CREATE VIEW v5
AS
SELECT name FROM v3
EXCEPT
SELECT name FROM v2;

---5) Вывести список покупателей с отображением их статуса (если покупок больше 10 - VIP, от 10 до 6 - Gold, 5 и менее - Usual), сохранить запрос как представление
GO
CREATE VIEW v6
AS
SELECT clients.name, (CASE WHEN (COUNT(sales.id) > 10) THEN 'VIP' ELSE (CASE WHEN (COUNT(sales.id) IN (10,6)) THEN 'Gold' ELSE 'Usual' END) END) AS 'status'
FROM sales
JOIN clients ON clients.id = sales.client_id
GROUP BY clients.name;

---или
GO
CREATE VIEW v7
AS
SELECT clients.name, 'VIP' AS 'status' FROM clients
JOIN (SELECT client_id AS 'id', COUNT(sales.id) AS 'cnt' FROM sales
	  GROUP BY client_id
	  HAVING COUNT(sales.id) > 10) tmp ON tmp.id = clients.id 
UNION
SELECT clients.name, 'Gold' AS 'status' FROM clients
JOIN (SELECT client_id AS 'id', COUNT(sales.id) AS 'cnt' FROM sales
	  GROUP BY client_id
	  HAVING COUNT(sales.id) IN (10, 6)) tmp ON tmp.id = clients.id
UNION
SELECT clients.name, 'Usual' AS 'status' FROM clients
JOIN (SELECT client_id AS 'id', COUNT(sales.id) AS 'cnt' FROM sales
	  GROUP BY client_id
	  HAVING COUNT(sales.id) < 6) tmp ON tmp.id = clients.id;

---6) Создать запрос для отображения данных по автосалону Иномарка
GO
CREATE VIEW v8
AS
SELECT 'Месяц минимальных продаж' AS 'Наименование параметра', tmp.mnth AS 'Значение параметра' 
FROM (SELECT TOP 1 WITH ties MONTH(sale_date) AS 'mnth', SUM(cars.price) AS 'cnt' FROM sales
	  JOIN shops ON shops.id = sales.shop_id AND shops.shop_name = 'Иномарка'
	  JOIN cars ON cars.id = sales.car_id
      GROUP BY MONTH(sale_date)
      ORDER BY 2) tmp
UNION
SELECT 'Месяц максимальных продаж' AS 'Наименование параметра', tmp.mnth AS 'Значение параметра' 
FROM (SELECT TOP 1 WITH ties MONTH(sale_date) AS 'mnth', SUM(cars.price) AS 'cnt' FROM sales
	  JOIN shops ON shops.id = sales.shop_id AND shops.shop_name = 'Иномарка'
	  JOIN cars ON cars.id = sales.car_id
      GROUP BY MONTH(sale_date)
	  ORDER BY 2 DESC) tmp
UNION 
SELECT 'Среднее число продаж по месяцам' AS 'Наименование параметра', tmp.cnt AS 'Значение параметра' 
FROM (SELECT CONVERT(FLOAT, COUNT(sales.id)/COUNT(DISTINCT MONTH(sales.sale_date))) AS 'cnt' FROM sales
	  JOIN shops ON shops.id = sales.shop_id AND shops.shop_name = 'Иномарка') tmp;