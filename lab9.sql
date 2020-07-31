USE motocars;

---1. ������� ������� �� �������� ����� ������� �������� �������� � ��������� ����������.
GO
CREATE FUNCTION count_clients (@name NVARCHAR(40), @shop NVARCHAR(40))
RETURNS INT
AS
BEGIN
	DECLARE @cnt INT
	SELECT @cnt = COUNT(sales.id) FROM sales
	JOIN clients ON clients.id = sales.client_id AND clients.name = @name
	JOIN shops ON shops.id = sales.shop_id AND shops.shop_name = @shop
	RETURN @cnt
END
GO;

---������������ ������ �������  � ������� �� ������ ����������� � ������� ���� ������ ������ ������� ������
SELECT clients.name, shops.shop_name, COUNT(sales.id) AS 'count' FROM sales
	JOIN clients ON clients.id = sales.client_id AND clients.name = '�����'
	JOIN shops ON shops.id = sales.shop_id
GROUP BY clients.name, shops.shop_name
HAVING COUNT(sales.id) > dbo.count_clients('�����', '�������');

---2. ������� �������, ��� ������ �������� ��������� ���������� � ��������� ����(���������� ����� ������, ���� ����� ������� ������ ������ - ������� ���)
GO
CREATE FUNCTION pop_shops (@date DATE)
RETURNS TABLE
AS
RETURN (SELECT TOP 1 WITH ties shops.shop_name, sales.sale_date, COUNT(sales.id) AS 'count' FROM shops
			JOIN sales ON sales.shop_id = shops.id AND sales.sale_date = @date
		GROUP BY shops.shop_name, sales.sale_date
		ORDER BY 3 DESC)
GO;
--- ������������ ��������� ������ ������� � ������� �� ����������� ������� ������� (���, ���, ���������) � ����� �������� ���������� � ��������� ���� 
SELECT shops.shop_name, clients.name, cars.model, cars.price FROM sales
	JOIN clients ON clients.id = sales.client_id
	JOIN cars ON cars.id = sales.car_id
	JOIN shops ON shops.id = sales.shop_id
	JOIN pop_shops('20180123') tmp ON tmp.shop_name = shops.shop_name AND tmp.sale_date = sales.sale_date;
		
--- 3.������� �������, ������� ��� ���������� ������� � ������ ����� �������� ���������� ������� ������ �������� � ���� ����������. 
GO
CREATE FUNCTION cnt_sales (@name NVARCHAR(40), @shop NVARCHAR(40))
RETURNS @result TABLE

("����������" NVARCHAR (40),
 "���������" NVARCHAR (40),
 "���������� �������" INT)

AS
BEGIN
	IF (SELECT COUNT(sales.id) FROM sales
			JOIN clients ON clients.id = sales.client_id AND clients.name = @name
			JOIN shops ON shops.id = sales.shop_id AND shops.shop_name = @shop) > 0
		BEGIN
			INSERT INTO @result
			SELECT clients.name, shops.shop_name, COUNT(sales.id) FROM sales
				JOIN clients ON clients.id = sales.client_id AND clients.name = @name
				JOIN shops ON shops.id = sales.shop_id AND shops.shop_name = @shop
			GROUP BY clients.name, shops.shop_name
		END
	ELSE
		BEGIN
			INSERT INTO @result
			SELECT clients.name, shop_name, 0 FROM clients, shops
			WHERE name = @name AND shop_name = @shop
			UNION
			SELECT clients.name, '������ ����������', COUNT(sales.id) FROM sales
				JOIN clients ON clients.id = sales.client_id AND clients.name = @name
				LEFT JOIN shops ON shops.id = sales.shop_id
			GROUP BY clients.name
			ORDER BY 3
		END
RETURN
END
GO;

SELECT * FROM dbo.cnt_sales('������', '4 ������');