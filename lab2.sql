USE freeit;

--- создаем таблицу.
create table studs (
id int primary key not null identity,
name nvarchar(40) not null,
phone int not null,
br_date date,
desired nvarchar(150),
course  nvarchar(40),
type_course nvarchar(40) not null default 'none',
lect_hours int not null,
labs_hours int not null,
str_date date);

----- заполняем.
insert into studs 
(name,phone,br_date,desired, course,type_course,lect_hours, labs_hours,str_date)values 
(N'Иван', 337302952,'20000105','C#, JS,  IM, Ruby', 'C#', 'full', 30,60, '20200730'),
(N'Роман', 447758172,'19971207','C#, JS', 'C#','full', 30,60, '20200730'),
(N'Александр',445036950,'19931007','C#, Java','Java','express', 0,60, '20200803'),
(N'Юлия',335171515,'20010129','C#, Java', 'C#', 'full', 30,60, '20200730'),
(N'Рита',335665262,'19960117','BA, IM','IM', 'full', 10,24, '20200803'),
(N'Олег', 297698996,'19990107','C#, JS, SQL, BA, IM, Ruby',  'C#', 'express', 0,60, '20200803'),
(N'Глеб',292542686,'19961227','C#, Java',  'C#','express', 0,60, '20200803'),
(N'Анастасия',447035175,'19890907','C#, JS, SQL, BA, IM, Ruby', 'C#','express', 0,60,'20200803'),
(N'Сергей',292751237,'19930807','Java, BA', 'Java', 'full', 30,60,'20200801'),
(N'Яна', 295666092,'19950607','Java', 'Java', 'full', 30,60,'20200801'),
(N'Константин',295036950,'19890107','Java, IM', 'Java', 'full', 30,60,'20200801'),
(N'Петр',335580629,'19980116', 'C#,Python', 'C#', 'full', 30,60, '20200730'),
(N'Ксения',445513335,'19991117',' IM','IM','full', 10,24, '20200803'),
(N'Кристина',337711379,'19920307','Java','Java','express', 0,60, '20200803'),
(N'Ольга',447698996,'19940125', 'Ruby','Ruby', 'full', 10,24, '20200804'),
(N'Оксана',297718719,'19890123', 'Java,Python','Java', 'full', 30,60,'20200801'), 
(N'Семен' ,335075429,'20030505','BA','BA', 'express', 12,0, '20200804'),
(N'Людмила',295665262,'19890227','BA, IM','BA', 'express', 12,0, '20200804'),
(N'Алексей',335666092,'19940215','Python',null,'none',0,0,null),
(N'Андрей',297758172,'19971007','Java,JS, SQL', 'SQL', 'full', 12,30, '20200801');

--- 1.	Вывести информацию о студентах (имя, дату рождения, телефон) в имена которых буквы "а" или   "и" в любых комбинациях и порядке.
SELECT name, br_date, phone FROM studs
WHERE name LIKE '%а%' OR name LIKE '%и%';

SELECT name, br_date, phone FROM studs
WHERE name LIKE '%[аи]%';

SELECT name, br_date, phone FROM studs
WHERE name LIKE '%а%'
UNION
SELECT name, br_date, phone FROM studs
WHERE name LIKE '%и%';

--- 2.	Вывести сведения о студентах(имена, наименование курса, тип курса, дата начала), которые учатся на курсах C#, Java или JS.
SELECT name, course, type_course, str_date FROM studs
WHERE course = 'C#' OR course = 'Java' OR course = 'JS';

--- 3.	Вывести сведения о  студентах, которые хотели бы учиться на более, чем одном курсе.
SELECT name, phone, br_date, desired FROM studs
WHERE desired LIKE '%,%';

--- 4.	Вывести сведения о студентах, имена которых содержат или больше, или меньше четырех символов (но не ровно четыре символов), при этом одна из букв имени  'a'.
SELECT name, phone, br_date, desired FROM studs
WHERE name NOT LIKE '____' AND name LIKE '%а%';

SELECT name, phone, br_date, desired FROM studs
WHERE len(name) != 4 AND name LIKE '%а%';

--- 5.	Найти всех студентов учащихся на BA, отсортировать результаты по полю имя.
SELECT name, phone, br_date, desired FROM studs
WHERE course LIKE '%BA%'
ORDER BY 1;

SELECT name, phone, br_date, desired FROM studs
WHERE course LIKE '%BA%'
ORDER BY name ASC;

--- 6.	Вывести информацию о студентах, которые хотели бы учиться и на Java, и на SQL, при этом их возраст больше 25 лет (наименование курса включить в выборку).
SELECT name, phone, br_date, desired, course FROM studs
WHERE (desired LIKE '%java%sql%' OR desired LIKE '%sql%java%') AND DATEDIFF(year, br_date, GETDATE()) > 25;

--- 7.	Вывести информацию о студентах (имена, даты рождения), которые родились в марте, июне, сентябре.
SELECT name, br_date FROM studs
WHERE DATENAME(month, br_date) = 'March' OR DATENAME(month, br_date) = 'June' OR DATENAME(month, br_date) = 'September';

SELECT name, br_date FROM studs
WHERE MONTH(br_date) = 3 OR MONTH(br_date) = 6 OR MONTH(br_date) = 9;

--- 8.	Вывеси информацию о курсах, количество лабораторных часов в которых 30 часов и более.
SELECT DISTINCT course, type_course, lect_hours, labs_hours, str_date FROM studs
WHERE labs_hours >= 30;

--- 9.	Вывести информацию о курсах, которые уже начались.
SELECT DISTINCT course, type_course, lect_hours, labs_hours, str_date FROM studs
WHERE str_date IS NOT NULL AND str_date <= GETDATE();

--- 10.	Вывести информацию о том, какие типы курсов доступны студентам.
SELECT DISTINCT type_course FROM studs
WHERE course IS NOT NULL;

--- 11.	Вывести информацию о студентах, которые ожидают начала курсов.
SELECT name, phone, br_date, desired FROM studs
WHERE str_date IS NULL OR str_date > GETDATE();

--- 12.	Вывести информацию о курсах, в которых число практических занятий больше числа лабораторных. 
SELECT DISTINCT course, type_course, lect_hours, labs_hours, str_date FROM studs
WHERE lect_hours > labs_hours;

--- 13.	Вывести список студентов, которые начали обучаться в июле.
SELECT name, phone, br_date, desired FROM studs
WHERE DATENAME(month, str_date) = 'July' AND str_date <= GETDATE();

--- 14.	 Вывести список студентов возрастом старше 25 лет.
SELECT name, phone, br_date, desired FROM studs
WHERE DATEDIFF(year, br_date, GETDATE()) > 25;

--- 15.	Вывести список студентов, код оператора которых 33, отсортировать результат по дате рождения студента.
SELECT name, phone, br_date, desired FROM studs
WHERE phone LIKE '33%'
ORDER BY 3 DESC;


