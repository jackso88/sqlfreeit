--��������� � ��� (������ �� ��������)
use freeit

--- ������� �������
create table teachers (
phone int not null,
name nvarchar(40) not null,
br_date date,
course nvarchar(40) not null,
type_course  nvarchar(40),
role_in_course nvarchar(40) not null,
str_date date  not null,
lect_hours int,
labs_hours int,
progress_hours int,
primary key (phone,course, type_course,role_in_course,str_date)
)

--- ���������
insert into teachers values
(296465763, '������','19951012', 'C#','full', 'teacher','20200730',30,60,5),
(296465763, '������','19951012', 'C#','full', 'mentor','20200730',30,60,5),
(293542536, '������','19970115', 'C#','full', 'helper','20200730',30,60,5),
(293542536, '������','19970115', 'C#','express', 'teacher','20200803',0,60,2),
(293542536, '������','19970115', 'C#','express', 'mentor','20200803',0,60,2),
(337885561, '�������','19930425', 'Python','full', 'helper','00010101',null,null,null),
(333522596, '��������','19910605', 'IM','full', 'teacher','20200803',10,24,4),
(333522596, '��������','19910605', 'IM','full', 'mentor','20200803',10,24,4),
(446522891, '�������','19920815', 'IM','full', 'helper','20200803',10,24,4),
(446522891, '�������','19920815', 'IM','full', 'mentor','20200803',10,24,4), 
(337865529, '��������','19900915', 'BA','express', 'teacher','20200804',12,0,1), 
(335587921, '����������','19890327', 'BA','express', 'mentor','20200804',12,0,1), 
(299887925, '��������','19910323', 'SQL','full', 'teacher','20200801',12,30,6), 
(448689653, '����','19930313', 'SQL','full', 'helper','20200801',12,30,6), 
(298965356, '��������','19900313', 'Ruby','full', 'helper','20200804',10,24,8), 
(298965356, '�������','19950317', 'Ruby','full', 'teacher','20200804',10,24,8), 
(298965356, '�������','19950317', 'Java','full', 'helper','20200803',30,60,8), 
(298965356, '�������','19950317', 'Java','express', 'helper','20200801',0,60,8), 
(339465689, '������','19940213', 'Java','full', 'teacher','20200803',30,60,8),
(339465689, '������','19940213', 'Java','full', 'mentor','20200803',30,60,8),
(443946899, '������','19890716', 'Java','express', 'teacher','20200801',0,60,8),
(443946899, '������','19890716', 'Java','express', 'mentor','20200801',0,60,8)

--- 1.	����������, ����� ���������� ������� ������������ ���� �� Java � C# � ������ ���� ����� (����� ����).
SELECT course, type_course, COUNT(name) AS '����������' FROM teachers
WHERE course LIKE 'java' OR course LIKE 'C#'
GROUP BY course, type_course;

--- 2.	���������� ����� � ������ ����, �������� �� ������� �������� ����� 5 �����.
SELECT DISTINCT course, type_course FROM teachers
WHERE progress_hours > 5;

--- 3.	���������� ���������� �������������� ��������� � ������ ������ ����.
SELECT COUNT(DISTINCT name) AS 'count', DATENAME(month, br_date) AS 'month' FROM teachers
GROUP BY DATENAME(month, br_date);

--- 4.	���������� �����, ������� ������� �������������� �� ������� ����� 23.
SELECT course, type_course, AVG(DATEDIFF(year, br_date, GETDATE())) AS '������� �������' FROM teachers
GROUP BY course, type_course
HAVING AVG(DATEDIFF(year, br_date, GETDATE())) < 23;

--- 5.	���������� ������� ������� ��������� �� ������ ����� �� ����� ����.
SELECT course, type_course, AVG(DATEDIFF(year, br_date, '20201231')) as '������� �������' FROM studs
WHERE course IS NOT NULL
GROUP BY course, type_course
ORDER BY 2;

--- 6.	���������� ������� ������� ��������� �� ������ ����� �� ������� ������.
SELECT course, type_course, AVG(DATEDIFF(year, br_date, GETDATE())) as '������� �������' FROM studs
WHERE course IS NOT NULL
GROUP BY course, type_course
ORDER BY 2;

--- 7.	���������� ���������� helper - �� �� ������ �����.
SELECT course, type_course, SUM((CASE WHEN (role_in_course = 'helper') THEN 1 ELSE 0 END)) AS 'helpers count' FROM teachers
GROUP BY course, type_course;

--- 8.	����� ���� ����� mentor-�� ������� ������.
SELECT course, type_course, COUNT(role_in_course) AS 'count' FROM teachers
WHERE role_in_course LIKE 'mentor'
GROUP BY course, type_course
HAVING COUNT(role_in_course) > 1;

--- 9.	��� ������ ������� full ���������� ��������� ����� ������ � ����� ����� ��������.
SELECT ROUND(CAST(CAST(SUM(lect_hours) AS DECIMAL)/SUM(labs_hours) AS DECIMAL (6,3)),3) AS '���������' FROM teachers
WHERE type_course LIKE 'full'
HAVING SUM(labs_hours) != 0; 

--- 10.	���������� ����� �������� � �������.
SELECT COUNT(DISTINCT br_date) AS '����������' FROM teachers;

--- 11. ����� ��������������, ������� ������������� �����, ��� � ����� �����.
SELECT name, COUNT(DISTINCT course) AS 'count' FROM teachers
GROUP BY name
HAVING COUNT(DISTINCT course) > 1;

--- 12.	���������� ������� ������������� ������������ ����� �� ������ ���������������, mentor-� � ���� �� ���������.
SELECT SUM(labs_hours)/COUNT(DISTINCT br_date) as '�������' FROM teachers
WHERE role_in_course NOT LIKE 'mentor'
HAVING COUNT(DISTINCT br_date) != 0;

--- 13.	������� ������ ������, � ������� ������������ ����� ������, ��� ���������� � 2 ���� � �����.
SELECT DISTINCT course, type_course FROM teachers
WHERE lect_hours * 2 <= labs_hours;

SELECT DISTINCT course, type_course FROM teachers
WHERE lect_hours = 0 OR (labs_hours/lect_hours >= 2 AND lect_hours != 0); 

--- 14. ����� �����, �� ������� ����� ��������� � ����� 29 � ���������� � ������ ������ ����. 
SELECT course, type_course, COUNT(phone) AS 'count' FROM studs
WHERE phone LIKE '29%8%'
GROUP BY course, type_course
HAVING COUNT(phone) > 2;