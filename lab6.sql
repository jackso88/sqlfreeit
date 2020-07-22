USE motocars;

--- �������� ������
CREATE TABLE shops (
id INT NOT NULL IDENTITY,
shop_name VARCHAR(50),
shop_address VARCHAR(50),
CONSTRAINT pk_shops PRIMARY KEY (id)
);

CREATE TABLE clients (
id INT NOT NULL IDENTITY,
"name" VARCHAR(30),
CONSTRAINT pk_clients PRIMARY KEY (id)
);

CREATE TABLE cars (
id INT NOT NULL IDENTITY,
model VARCHAR(30),
price INT NOT NULL,
CONSTRAINT pk_cars PRIMARY KEY (id)
);

CREATE TABLE sales (
id INT NOT NULL IDENTITY,
shop_id INT NOT NULL,
client_id INT NOT NULL,
car_id INT NOT NULL,
sale_date DATE NOT NULL,
CONSTRAINT pk_sales PRIMARY KEY (id)
);

--- ����������� ������ ����� ���������
ALTER TABLE sales ADD CONSTRAINT fk_sales_shops FOREIGN KEY (shop_id) REFERENCES shops (id),
CONSTRAINT fk_sales_clients FOREIGN KEY (client_id) REFERENCES clients (id),
CONSTRAINT fk_sales_cars FOREIGN KEY (car_id) REFERENCES cars (id);

--- ���������� ������
INSERT INTO shops
SELECT DISTINCT shop_name, shop_address FROM all_sales;

INSERT INTO clients
SELECT DISTINCT client_name FROM all_sales;

INSERT INTO cars
SELECT DISTINCT car, price FROM all_sales;

INSERT INTO sales
SELECT shops.id, clients.id, cars.id, all_sales.sale_date FROM all_sales
JOIN shops ON shops.shop_name = all_sales.shop_name AND shops.shop_address = all_sales.shop_address
JOIN clients ON clients.name = all_sales.client_name
JOIN cars ON cars.model = all_sales.car AND cars.price = all_sales.price;

--- a.	����������, � ����� �� ����������� ������ �������� ������ 2018-01-05
SELECT DISTINCT shops.shop_name FROM sales
JOIN shops ON shops.id = sales.shop_id
JOIN clients ON clients.id = sales.client_id
WHERE clients.name = '������' AND sales.sale_date = '20180105';

--- b.	������� �������� �����������, ���� � ����� �� ������������ �������� �������� � �������, ������������ �� ����� �������
SELECT clients.name, cars.model, shops.shop_name, sales.sale_date FROM sales
JOIN cars ON cars.id = sales.car_id
JOIN shops ON shops.id = sales.shop_id
JOIN clients ON clients.id = sales.client_id
WHERE clients.name = '�������' OR clients.name = '������'
ORDER BY 1;

--- c.	������� ����� ������ � ������� ���� �����������
SELECT SUM(cars.price) AS '�����' FROM sales
JOIN cars ON cars.id = sales.car_id
WHERE DATENAME(MONTH, sale_date) = 'February';

--- d.	���������� �����(������), ����������� ���������� ����� ������ �� ���� ������
SELECT shops.shop_name FROM shops
JOIN (SELECT TOP 1 WITH ties sales.shop_id AS 'ids', COUNT(sales.id) AS 'count' FROM sales
	  GROUP BY sales.shop_id
	  ORDER BY 2 DESC) cnt ON cnt.ids = shops.id;

--- e.	����������, ����� ����������� (��������) ���� ������� ������ ����� � ���������� ��������
SELECT cars.model FROM cars
JOIN (SELECT TOP 1 WITH ties sales.car_id AS 'car', COUNT(sales.id) AS 'count' FROM sales
	  JOIN shops ON shops.id = sales.shop_id AND shops.shop_name = '��������'
	  GROUP BY sales.car_id
	  ORDER BY 2 DESC) cnt ON cnt.car = cars.id;

--- f.	���������� ����� ���������� �������� ������ Automall
SELECT COUNT(DISTINCT sales.client_id) AS 'count' FROM sales
JOIN shops ON shops.id = sales.shop_id AND shops.shop_name = 'Automall';

--- g.	������� ������ (����������) ���� ������� � ������ "4 ������" � ����� 
SELECT COUNT(sales.id) AS 'count' FROM sales
JOIN shops ON shops.id = sales.shop_id AND shops.shop_name = '4 ������'
WHERE DATENAME(MONTH, sale_date) = 'March';