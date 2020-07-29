USE motocars;

--- 1. ������� �� �� �������� ����� �������, ����� ��������, ����� ������, � ����� ����� � ������� ������
GO
CREATE PROCEDURE p1
AS
DECLARE @shops INT;
DECLARE @cli INT;
DECLARE @sales INT;
DECLARE @cars INT;
DECLARE @date DATE;

SELECT @shops = COUNT(*) FROM shops
SELECT @cli = COUNT(*) FROM clients
SELECT @sales = COUNT(*) FROM sales
SELECT @cars = COUNT(*) FROM cars
SELECT @date = GETDATE()

PRINT '�� ' + CONVERT(NVARCHAR, @date) + ' ���������� ����������� ���������� ' + CONVERT(NVARCHAR, @shops) + ' ��., ���������� �������� - ' + CONVERT(NVARCHAR, @cli) + ' ��., ���������� ������ - ' + 
CONVERT(NVARCHAR, @sales) + ' ��., ���������� ����������� - ' + CONVERT(NVARCHAR, @cars) + ' ��.';

GO 
EXEC p1;

--- 2. ������� �������� ��������� �������� ���������� ������ �� �������,
--- ����� ������ �� ������� � ����� �������� �� ������� ��� ��������� ����������. ��������� ������� � ���� ���������. 
--- ���������� ������ ��������� ����� ������������ ���������� 
GO
CREATE PROCEDURE p2 (@shop NVARCHAR(20))
AS 
IF EXISTS (SELECT * FROM shops
			WHERE shop_name = @shop)
	BEGIN
		SELECT COUNT(sales.id) AS 'count_sales', DATENAME(MONTH, sales.sale_date) AS 'month', SUM(cars.price) AS 'sum', COUNT(clients.id) AS 'count_clients' FROM sales
		JOIN shops ON shops.id = sales.shop_id AND shops.shop_name = @shop
		JOIN cars ON cars.id = sales.car_id
		JOIN clients ON clients.id = sales.client_id
		GROUP BY DATENAME(MONTH, sales.sale_date)
	END
ELSE
	BEGIN
		print '�������� ���������� ������ �������'
	END;

GO
EXEC p2 '4 ������';

--- 3. ������� �������� ��������� ��� �������� ���������a ������ � ���������� � �������� �����(������� ������ �������� ���������� � ����� ������).
---    ��������� ������� � �������� ���������� ��������� � ���� ���������). ���������� ������ ��������� ����� 
GO
CREATE PROCEDURE p3 (@shop NVARCHAR(20), @month INT)
AS 
DECLARE @sales INT;

IF EXISTS (SELECT * FROM shops
			WHERE shop_name = @shop) AND @month <= 12
	BEGIN
		SELECT @sales = COUNT(sales.id) FROM sales
		JOIN shops ON shops.id = sales.shop_id AND shops.shop_name = @shop
		WHERE MONTH(sale_date) = @month
		PRINT '���������� ������ �� ���������� ' + '"' + @shop + '"'  + ' � ������ �' + CONVERT(NVARCHAR, @month) + ' ��������� ' + CONVERT(NVARCHAR, @sales) + ' ��.'
	END
ELSE
	BEGIN
		print '������� ������������ ������'
	END;

GO
EXEC p3 '��������', 3;

--- 4. ������� �������� ��������� ��� ���������� ����� �������. ������� ����� ������������ ����� ������ ��� ��� ���������.
---    ������� ������ ������������ ���� � ������������ �������. ���������� ������
GO
CREATE PROCEDURE p4 (@client NVARCHAR(20), @shop NVARCHAR(20), @car NVARCHAR(20), @date DATE)
AS
DECLARE @id_client INT;
DECLARE @id_shop INT;
DECLARE @id_car INT;

IF EXISTS (SELECT * FROM clients
			WHERE name = @client)
	BEGIN
		IF EXISTS (SELECT * FROM shops
					WHERE shop_name = @shop) AND EXISTS (SELECT * FROM cars
														  WHERE model = @car) AND @date <= GETDATE()
			BEGIN
				SELECT @id_client = id FROM clients
					WHERE name = @client
				SELECT @id_shop = id FROM shops
					WHERE shop_name = @shop
				SELECT @id_car = id FROM cars
					WHERE model = @car
				INSERT INTO sales (shop_id, client_id, car_id, sale_date) VALUES (@id_shop, @id_client, @id_car, @date)
			END
		ELSE
			BEGIN
				PRINT '������� ������������ ������'
			END
	END
ELSE
	BEGIN
		INSERT INTO clients (name) VALUES (@client)
		SELECT @id_client = id FROM clients
			WHERE name = @client
		SELECT @id_shop = id FROM shops
			WHERE shop_name = @shop
		SELECT @id_car = id FROM cars
			WHERE model = @car
		INSERT INTO sales (shop_id, client_id, car_id, sale_date) VALUES (@id_shop, @id_client, @id_car, @date)
	END;

GO
EXEC p4 '�����', '4 ������', 'audi a6', '2020-01-01';

--- 4. ������ � ������������� 
GO
CREATE PROCEDURE p6 (@client2 NVARCHAR(20), @shop2 NVARCHAR(20), @car2 NVARCHAR(20), @date2 DATE)
AS
DECLARE @id_client INT;
DECLARE @id_shop INT;
DECLARE @id_car INT;

SELECT @id_client = id FROM clients
	WHERE name = @client2
SELECT @id_shop = id FROM shops
	WHERE shop_name = @shop2
SELECT @id_car = id FROM cars
	WHERE model = @car2
INSERT INTO sales (shop_id, client_id, car_id, sale_date) VALUES (@id_shop, @id_client, @id_car, @date2);

GO 
CREATE PROCEDURE p5 (@client NVARCHAR(20), @shop NVARCHAR(20), @car NVARCHAR(20), @date DATE)
AS
IF EXISTS (SELECT * FROM clients
			WHERE name = @client)
	BEGIN
		IF EXISTS (SELECT * FROM shops
					WHERE shop_name = @shop) AND EXISTS (SELECT * FROM cars
														  WHERE model = @car) AND @date <= GETDATE()
			BEGIN
				EXEC p6 @client, @shop, @car, @date
			END
		ELSE
			BEGIN
				PRINT '������� ������������ ������'
			END
	END
ELSE
	BEGIN
		INSERT INTO clients (name) VALUES (@client)
		EXEC p6 @client, @shop, @car, @date
	END;