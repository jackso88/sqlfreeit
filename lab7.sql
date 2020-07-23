USE motocars;

--- 1) ������� ������������� ���������� � �������� �� ���� �����������
GO
CREATE VIEW v1
AS
SELECT shops.shop_name, COUNT(sales.id) AS 'count_sales', SUM(cars.price) AS 'sum', COUNT(sales.client_id) AS 'count_clients'
FROM sales
JOIN shops ON shops.id = sales.shop_id
JOIN cars ON cars.id = sales.car_id
GROUP BY shops.shop_name;

--- 2) ������� ������������� (2 ���������) � ������� � �������� � ������ �������� � 4 ������
GO
CREATE VIEW v2
AS
SELECT clients.name, cars.model, cars.price, sales.sale_date FROM sales
JOIN shops ON shops.id = sales.shop_id AND shops.shop_name = '4 ������'
JOIN clients ON clients.id = sales.client_id
JOIN cars ON cars.id = sales.car_id;

GO
CREATE VIEW v3
AS
SELECT clients.name, cars.model, cars.price, sales.sale_date FROM sales
JOIN shops ON shops.id = sales.shop_id AND shops.shop_name = '��������'
JOIN clients ON clients.id = sales.client_id
JOIN cars ON cars.id = sales.car_id;

---3) ������� �������������, ������� ����� ��������� ���������� � ��������, ������� ������� ������� �� ���� �����������
GO
CREATE VIEW v4
AS
SELECT clients.name FROM clients
JOIN (SELECT sales.client_id as 'id', COUNT(DISTINCT sales.shop_id) AS 'count' FROM sales
	  GROUP BY sales.client_id
      HAVING COUNT(DISTINCT sales.shop_id) = (SELECT COUNT(id) FROM shops)) tmp ON tmp.id = clients.id;

---4) ����� �����������, ������� ����������� ������ � ���������� ��������, ��� ���� �� ����������� ���������� � ������ 4 ������, ��������� ������ ��� �������������
GO
CREATE VIEW v5
AS
SELECT name FROM v3
EXCEPT
SELECT name FROM v2;

---5) ������� ������ ����������� � ������������ �� ������� (���� ������� ������ 10 - VIP, �� 10 �� 6 - Gold, 5 � ����� - Usual), ��������� ������ ��� �������������
GO
CREATE VIEW v6
AS
SELECT clients.name, (CASE WHEN (COUNT(sales.id) > 10) THEN 'VIP' ELSE (CASE WHEN (COUNT(sales.id) IN (10,6)) THEN 'Gold' ELSE 'Usual' END) END) AS 'status'
FROM sales
JOIN clients ON clients.id = sales.client_id
GROUP BY clients.name;

---���
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

---6) ������� ������ ��� ����������� ������ �� ���������� ��������
GO
CREATE VIEW v8
AS
SELECT '����� ����������� ������' AS '������������ ���������', tmp.mnth AS '�������� ���������' 
FROM (SELECT TOP 1 WITH ties MONTH(sale_date) AS 'mnth', SUM(cars.price) AS 'cnt' FROM sales
	  JOIN shops ON shops.id = sales.shop_id AND shops.shop_name = '��������'
	  JOIN cars ON cars.id = sales.car_id
      GROUP BY MONTH(sale_date)
      ORDER BY 2) tmp
UNION
SELECT '����� ������������ ������' AS '������������ ���������', tmp.mnth AS '�������� ���������' 
FROM (SELECT TOP 1 WITH ties MONTH(sale_date) AS 'mnth', SUM(cars.price) AS 'cnt' FROM sales
	  JOIN shops ON shops.id = sales.shop_id AND shops.shop_name = '��������'
	  JOIN cars ON cars.id = sales.car_id
      GROUP BY MONTH(sale_date)
	  ORDER BY 2 DESC) tmp
UNION 
SELECT '������� ����� ������ �� �������' AS '������������ ���������', tmp.cnt AS '�������� ���������' 
FROM (SELECT CONVERT(FLOAT, COUNT(sales.id)/COUNT(DISTINCT MONTH(sales.sale_date))) AS 'cnt' FROM sales
	  JOIN shops ON shops.id = sales.shop_id AND shops.shop_name = '��������') tmp;