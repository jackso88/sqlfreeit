USE freeit;

--- ������� �������.
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

----- ���������.
insert into studs 
(name,phone,br_date,desired, course,type_course,lect_hours, labs_hours,str_date)values 
(N'����', 337302952,'20000105','C#, JS,  IM, Ruby', 'C#', 'full', 30,60, '20200730'),
(N'�����', 447758172,'19971207','C#, JS', 'C#','full', 30,60, '20200730'),
(N'���������',445036950,'19931007','C#, Java','Java','express', 0,60, '20200803'),
(N'����',335171515,'20010129','C#, Java', 'C#', 'full', 30,60, '20200730'),
(N'����',335665262,'19960117','BA, IM','IM', 'full', 10,24, '20200803'),
(N'����', 297698996,'19990107','C#, JS, SQL, BA, IM, Ruby',  'C#', 'express', 0,60, '20200803'),
(N'����',292542686,'19961227','C#, Java',  'C#','express', 0,60, '20200803'),
(N'���������',447035175,'19890907','C#, JS, SQL, BA, IM, Ruby', 'C#','express', 0,60,'20200803'),
(N'������',292751237,'19930807','Java, BA', 'Java', 'full', 30,60,'20200801'),
(N'���', 295666092,'19950607','Java', 'Java', 'full', 30,60,'20200801'),
(N'����������',295036950,'19890107','Java, IM', 'Java', 'full', 30,60,'20200801'),
(N'����',335580629,'19980116', 'C#,Python', 'C#', 'full', 30,60, '20200730'),
(N'������',445513335,'19991117',' IM','IM','full', 10,24, '20200803'),
(N'��������',337711379,'19920307','Java','Java','express', 0,60, '20200803'),
(N'�����',447698996,'19940125', 'Ruby','Ruby', 'full', 10,24, '20200804'),
(N'������',297718719,'19890123', 'Java,Python','Java', 'full', 30,60,'20200801'), 
(N'�����' ,335075429,'20030505','BA','BA', 'express', 12,0, '20200804'),
(N'�������',295665262,'19890227','BA, IM','BA', 'express', 12,0, '20200804'),
(N'�������',335666092,'19940215','Python',null,'none',0,0,null),
(N'������',297758172,'19971007','Java,JS, SQL', 'SQL', 'full', 12,30, '20200801');

--- 1.	������� ���������� � ��������� (���, ���� ��������, �������) � ����� ������� ����� "�" ���   "�" � ����� ����������� � �������.
SELECT name, br_date, phone FROM studs
WHERE name LIKE '%�%' OR name LIKE '%�%';

SELECT name, br_date, phone FROM studs
WHERE name LIKE '%[��]%';

SELECT name, br_date, phone FROM studs
WHERE name LIKE '%�%'
UNION
SELECT name, br_date, phone FROM studs
WHERE name LIKE '%�%';

--- 2.	������� �������� � ���������(�����, ������������ �����, ��� �����, ���� ������), ������� ������ �� ������ C#, Java ��� JS.
SELECT name, course, type_course, str_date FROM studs
WHERE course = 'C#' OR course = 'Java' OR course = 'JS';

--- 3.	������� �������� �  ���������, ������� ������ �� ������� �� �����, ��� ����� �����.
SELECT name, phone, br_date, desired FROM studs
WHERE desired LIKE '%,%';

--- 4.	������� �������� � ���������, ����� ������� �������� ��� ������, ��� ������ ������� �������� (�� �� ����� ������ ��������), ��� ���� ���� �� ���� �����  'a'.
SELECT name, phone, br_date, desired FROM studs
WHERE name NOT LIKE '____' AND name LIKE '%�%';

SELECT name, phone, br_date, desired FROM studs
WHERE len(name) != 4 AND name LIKE '%�%';

--- 5.	����� ���� ��������� �������� �� BA, ������������� ���������� �� ���� ���.
SELECT name, phone, br_date, desired FROM studs
WHERE course LIKE '%BA%'
ORDER BY 1;

SELECT name, phone, br_date, desired FROM studs
WHERE course LIKE '%BA%'
ORDER BY name ASC;

--- 6.	������� ���������� � ���������, ������� ������ �� ������� � �� Java, � �� SQL, ��� ���� �� ������� ������ 25 ��� (������������ ����� �������� � �������).
SELECT name, phone, br_date, desired, course FROM studs
WHERE (desired LIKE '%java%sql%' OR desired LIKE '%sql%java%') AND DATEDIFF(year, br_date, GETDATE()) > 25;

--- 7.	������� ���������� � ��������� (�����, ���� ��������), ������� �������� � �����, ����, ��������.
SELECT name, br_date FROM studs
WHERE DATENAME(month, br_date) = 'March' OR DATENAME(month, br_date) = 'June' OR DATENAME(month, br_date) = 'September';

SELECT name, br_date FROM studs
WHERE MONTH(br_date) = 3 OR MONTH(br_date) = 6 OR MONTH(br_date) = 9;

--- 8.	������ ���������� � ������, ���������� ������������ ����� � ������� 30 ����� � �����.
SELECT DISTINCT course, type_course, lect_hours, labs_hours, str_date FROM studs
WHERE labs_hours >= 30;

--- 9.	������� ���������� � ������, ������� ��� ��������.
SELECT DISTINCT course, type_course, lect_hours, labs_hours, str_date FROM studs
WHERE str_date IS NOT NULL AND str_date <= GETDATE();

--- 10.	������� ���������� � ���, ����� ���� ������ �������� ���������.
SELECT DISTINCT type_course FROM studs
WHERE course IS NOT NULL;

--- 11.	������� ���������� � ���������, ������� ������� ������ ������.
SELECT name, phone, br_date, desired FROM studs
WHERE str_date IS NULL OR str_date > GETDATE();

--- 12.	������� ���������� � ������, � ������� ����� ������������ ������� ������ ����� ������������. 
SELECT DISTINCT course, type_course, lect_hours, labs_hours, str_date FROM studs
WHERE lect_hours > labs_hours;

--- 13.	������� ������ ���������, ������� ������ ��������� � ����.
SELECT name, phone, br_date, desired FROM studs
WHERE DATENAME(month, str_date) = 'July' AND str_date <= GETDATE();

--- 14.	 ������� ������ ��������� ��������� ������ 25 ���.
SELECT name, phone, br_date, desired FROM studs
WHERE DATEDIFF(year, br_date, GETDATE()) > 25;

--- 15.	������� ������ ���������, ��� ��������� ������� 33, ������������� ��������� �� ���� �������� ��������.
SELECT name, phone, br_date, desired FROM studs
WHERE phone LIKE '33%'
ORDER BY 3 DESC;


