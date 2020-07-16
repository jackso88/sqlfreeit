USE freeIT2;

--- 1. ������� ������ ���, ��� ������ �� ����� ����� � �������
SELECT students.name, students.phone, students.br_date, students.desired FROM students
JOIN connects ON connects.id_student = students.id
JOIN courses ON courses.id = connects.id_course
WHERE courses.id IN (SELECT courses.id FROM courses
					 JOIN connects ON connects.id_course = courses.id
					 JOIN students ON students.id = connects.id_student AND students.name = '�����')
AND students.name != '�����';

--- 2.	������� ������ ������, �� ������� �������� ������� ���������� �����
SELECT themes.name AS 'theme', forms.name AS 'form', courses.labs_hours, courses.lect_hours, courses.progress_hours, courses.str_date FROM courses
JOIN themes ON themes.id = courses.id_theme
JOIN forms ON forms.id = courses.id_form
WHERE courses.lect_hours = (SELECT MAX(lect_hours) FROM courses);

SELECT TOP 1 WITH ties themes.name AS 'theme', forms.name AS 'form', courses.labs_hours, courses.lect_hours, courses.progress_hours, courses.str_date FROM courses
JOIN themes ON themes.id = courses.id_theme
JOIN forms ON forms.id = courses.id_form
ORDER BY courses.lect_hours DESC;

--- 3.	������� ������ ������, �� ������� ������ ���������� ���������� ���������
SELECT themes.name AS 'theme', forms.name AS 'form', courses.labs_hours, courses.lect_hours, courses.progress_hours, courses.str_date FROM courses
JOIN themes ON themes.id = courses.id_theme
JOIN forms ON forms.id = courses.id_form
JOIN (SELECT TOP 1 WITH ties courses.id AS cours_id, COUNT(students.id) AS count_stud FROM courses
	  JOIN connects ON connects.id_course = courses.id
	  JOIN students ON students.id = connects.id_student
	  GROUP BY courses.id
	  ORDER BY 2 DESC) cnt ON cnt.cours_id = courses.id;

--- 4.	������� ������ ���, ��� ������ �� ����� ����� � �������, �� ������ ���
SELECT students.name, students.phone, students.br_date, students.desired FROM students
JOIN connects ON connects.id_student = students.id
JOIN courses ON courses.id = connects.id_course
WHERE courses.id IN (SELECT courses.id FROM courses
					 JOIN connects ON connects.id_course = courses.id
					 JOIN students ON students.id = connects.id_student AND students.name = '�����')
AND students.br_date > (SELECT br_date FROM students
					    WHERE name = '�����');

--- 5.	����� �����, �� ������� ���������� ������ � ������������ ������� ��, ������� � �� ����� IM
SELECT themes.name AS 'theme', forms.name AS 'form', courses.labs_hours, courses.lect_hours, courses.progress_hours, courses.str_date FROM courses
JOIN themes ON themes.id = courses.id_theme AND themes.name != 'IM'
JOIN forms ON forms.id = courses.id_form
JOIN (SELECT courses.labs_hours AS labs, courses.lect_hours AS lect FROM courses
	  JOIN themes ON themes.id = courses.id_theme AND themes.name = 'IM') im ON im.labs = courses.labs_hours AND im.lect = courses.lect_hours;

--- 6.	����� �����, ��� ����� ������� ������, ��� �� ����� Ruby
SELECT themes.name AS 'theme', forms.name AS 'form', courses.labs_hours, courses.lect_hours, courses.progress_hours, courses.str_date FROM courses
JOIN themes ON themes.id = courses.id_theme
JOIN forms ON forms.id = courses.id_form
JOIN (SELECT courses.id AS cours_id, COUNT(students.id) AS count_st FROM courses
	  JOIN themes ON themes.id = courses.id_theme
	  JOIN forms ON forms.id = courses.id_form
	  JOIN connects ON connects.id_course = courses.id
	  JOIN students ON students.id = connects.id_student
	  GROUP BY courses.id) cnt ON cnt.cours_id = courses.id
WHERE cnt.count_st > (SELECT COUNT(students.id) FROM courses
				      JOIN themes ON themes.id = courses.id_theme AND themes.name = 'Ruby'
				      JOIN forms ON forms.id = courses.id_form
				      JOIN connects ON connects.id_course = courses.id
				      JOIN students ON students.id = connects.id_student);

--- 7.	����� ���������� ���������, � ������� ����� �������� ����� �� ��� C�����, � �������������� ������� ��� �� ������� ����� ������ �������� ������ (����� ���� �����)
SELECT COUNT(id)-1 AS 'count', MONTH(br_date) AS 'month' FROM students
WHERE MONTH(br_date) = (SELECT MONTH(br_date) FROM students
						WHERE name = '�����')
GROUP BY MONTH(br_date);

--- 8.	����� ��������������, ���� ��� ���� ������� ��������� � ����� ��� ������ ������ (���� ����� ������)
SELECT DISTINCT persones.name, persones.phone, persones.br_date FROM persones
JOIN missions ON persones.id = missions.id_persone
JOIN roles ON missions.id_role = roles.id AND roles.name IN (SELECT roles.name FROM persones
															 JOIN missions ON persones.id = missions.id_persone AND persones.name = '������'
															 JOIN roles ON missions.id_role = roles.id)
WHERE persones.name != '������';
