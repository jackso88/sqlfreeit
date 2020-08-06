USE motocars;

--- Создание таблицы для отображения статистики с первичным наполнением
CREATE TABLE stats (
clients_count INT NOT NULL,
shops_count INT NOT NULL,
sales_count INT NOT NULL,
sum_salles INT NOT NULL
);

INSERT INTO stats (clients_count, shops_count, sales_count, sum_salles) VALUES (0, 0, 0, 0);

--- 1. Создать триггеры, которые при изменении количества записей в таблицах клиентов, таблице автосалонов и журнале продаж обновлял бы содержание таблицы статистики
GO
CREATE TRIGGER tr1
ON clients AFTER INSERT, DELETE
AS
UPDATE stats SET clients_count = (SELECT COUNT(id) FROM clients)

GO
CREATE TRIGGER tr2
ON shops AFTER INSERT, DELETE
AS
UPDATE stats SET shops_count = (SELECT COUNT(id) FROM shops)

GO
CREATE TRIGGER tr3
ON sales AFTER INSERT, DELETE
AS
UPDATE stats SET sales_count = (SELECT COUNT(id) FROM sales)

GO
CREATE TRIGGER tr4
ON sales AFTER INSERT, DELETE
AS
UPDATE stats SET sum_salles = (SELECT SUM(cars.price) FROM sales
								  JOIN cars ON cars.id = sales.car_id)
GO
INSERT INTO shops VALUES ('развалюха', 'Притыцкого 5');
INSERT INTO clients VALUES ('Хункермурзаев');
INSERT INTO sales VALUES (1, 1, 1, '20200505');

--- 2. создать триггер, который при изменении суммы авто (корректируем существующую запись),
--- не разрешал бы изменение данных только, если новая стоимость отличается больше чем на 10% от старой. 
--- При внесении изменений должна обновляться таблица статистики
GO
CREATE TRIGGER tr5
ON cars INSTEAD OF UPDATE
AS
IF (SELECT inserted.price FROM inserted) > (SELECT deleted.price*1.1 FROM deleted)
	BEGIN
		PRINT 'Слишком большая цена'
	END
ELSE
	BEGIN
		UPDATE cars SET cars.price = (SELECT inserted.price FROM inserted),
		cars.model = (SELECT inserted.model FROM inserted)
		WHERE cars.id IN (SELECT id FROM inserted);
		UPDATE stats SET sum_salles = (SELECT SUM(cars.price) FROM sales
										JOIN cars ON cars.id = sales.car_id);
	END
GO

UPDATE cars SET model = 'Audi A2', price = 105 where cars.id = 1

--- 3. создать триггер который при удалении клиента будет переносить данные о всех его покупках с деталями (что где когда купил ) в архивную таблицу
CREATE TABLE arch (
name NVARCHAR(40),
model NVARCHAR(40),
shop NVARCHAR(40),
price INT,
sale_date DATE
);

GO 
CREATE TRIGGER tr6
ON clients INSTEAD OF DELETE
AS
INSERT INTO arch
SELECT deleted.name, cars.model, shops.shop_name, cars.price, sales.sale_date FROM sales
JOIN deleted ON deleted.id = sales.client_id
JOIN cars ON cars.id = sales.car_id
JOIN shops ON shops.id = sales.shop_id;
DELETE FROM sales WHERE sales.client_id IN (SELECT id FROM deleted);
DELETE FROM clients WHERE clients.id IN (SELECT id FROM deleted);
GO

delete from clients where id = 3;