USE freeIT2;

--- 1. Вывести список тех, кто учится на одном курсе с Семеном
SELECT students.name, students.phone, students.br_date, students.desired FROM students
JOIN connects ON connects.id_student = students.id
JOIN courses ON courses.id = connects.id_course
WHERE courses.id IN (SELECT courses.id FROM courses
					 JOIN connects ON connects.id_course = courses.id
					 JOIN students ON students.id = connects.id_student AND students.name = 'Семен')
AND students.name != 'Семен';

--- 2.	Вывести список курсов, по которым начитано большее количество часов
SELECT themes.name AS 'theme', forms.name AS 'form', courses.labs_hours, courses.lect_hours, courses.progress_hours, courses.str_date FROM courses
JOIN themes ON themes.id = courses.id_theme
JOIN forms ON forms.id = courses.id_form
WHERE courses.lect_hours = (SELECT MAX(lect_hours) FROM courses);

SELECT TOP 1 WITH ties themes.name AS 'theme', forms.name AS 'form', courses.labs_hours, courses.lect_hours, courses.progress_hours, courses.str_date FROM courses
JOIN themes ON themes.id = courses.id_theme
JOIN forms ON forms.id = courses.id_form
ORDER BY courses.lect_hours DESC;

--- 3.	Вывести список курсов, на которых учится наибольшее количество студентов
SELECT themes.name AS 'theme', forms.name AS 'form', courses.labs_hours, courses.lect_hours, courses.progress_hours, courses.str_date FROM courses
JOIN themes ON themes.id = courses.id_theme
JOIN forms ON forms.id = courses.id_form
JOIN (SELECT TOP 1 WITH ties courses.id AS cours_id, COUNT(students.id) AS count_stud FROM courses
	  JOIN connects ON connects.id_course = courses.id
	  JOIN students ON students.id = connects.id_student
	  GROUP BY courses.id
	  ORDER BY 2 DESC) cnt ON cnt.cours_id = courses.id;

--- 4.	Вывести список тех, кто учится на одном курсе с Романом, но младше его
SELECT students.name, students.phone, students.br_date, students.desired FROM students
JOIN connects ON connects.id_student = students.id
JOIN courses ON courses.id = connects.id_course
WHERE courses.id IN (SELECT courses.id FROM courses
					 JOIN connects ON connects.id_course = courses.id
					 JOIN students ON students.id = connects.id_student AND students.name = 'Роман')
AND students.br_date > (SELECT br_date FROM students
					    WHERE name = 'Роман');

--- 5.	Найти курсы, на которых количество лекций и лабораторных столько же, сколько и на курсе IM
SELECT themes.name AS 'theme', forms.name AS 'form', courses.labs_hours, courses.lect_hours, courses.progress_hours, courses.str_date FROM courses
JOIN themes ON themes.id = courses.id_theme AND themes.name != 'IM'
JOIN forms ON forms.id = courses.id_form
JOIN (SELECT courses.labs_hours AS labs, courses.lect_hours AS lect FROM courses
	  JOIN themes ON themes.id = courses.id_theme AND themes.name = 'IM') im ON im.labs = courses.labs_hours AND im.lect = courses.lect_hours;

--- 6.	Найти курсы, где число человек больше, чем на курсе Ruby
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

--- 7.	Найти количество студентов, у которых месяц рождения такой же как Cемена, в результирующей выборке так же вывести номер месяца рождения Семена (Семен один любой)
SELECT COUNT(id)-1 AS 'count', MONTH(br_date) AS 'month' FROM students
WHERE MONTH(br_date) = (SELECT MONTH(br_date) FROM students
						WHERE name = 'Семен')
GROUP BY MONTH(br_date);

--- 8.	Найти сопровождающих, роль или роли которых совпадают с ролью или ролями Андрея (один любой Андрей)
SELECT DISTINCT persones.name, persones.phone, persones.br_date FROM persones
JOIN missions ON persones.id = missions.id_persone
JOIN roles ON missions.id_role = roles.id AND roles.name IN (SELECT roles.name FROM persones
															 JOIN missions ON persones.id = missions.id_persone AND persones.name = 'Андрей'
															 JOIN roles ON missions.id_role = roles.id)
WHERE persones.name != 'Андрей';
