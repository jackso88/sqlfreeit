use freeIT2;

--- 1.	Вывести информацию о курсах, которые проводятся в формате full
SELECT themes.name AS 'theme', forms.name AS 'form', courses.str_date, courses.lect_hours, courses.labs_hours, courses.progress_hours
FROM courses
JOIN forms ON forms.id = courses.id_form AND forms.name = 'full'
JOIN themes ON themes.id = courses.id_theme;

--- 2.	Вывеси информацию о курсах, на которых учатся Людмила и Семен
SELECT DISTINCT themes.name AS 'theme', forms.name AS 'form', courses.str_date, courses.lect_hours, courses.labs_hours, courses.progress_hours
FROM courses
JOIN forms ON forms.id = courses.id_form
JOIN themes ON themes.id = courses.id_theme
JOIN connects ON connects.id_course = courses.id
JOIN students ON students.id = connects.id_student
WHERE students.name = 'Людмила' OR students.name = 'Семен';

--- 3.	Вывести информацию о сопровождающих курс, на котором учится Семен
SELECT persones.name AS 'teacher_name', persones.phone, persones.br_date, roles.name AS 'role' 
FROM persones
JOIN missions ON persones.id = missions.id_persone
JOIN roles ON roles.id = missions.id_role
JOIN teams ON teams.id_mission = missions.id
JOIN courses ON courses.id = teams.id_course
JOIN connects ON connects.id_course = courses.id
JOIN students ON students.id = connects.id_student AND students.name = 'Семен';

--- 4.	Вывести информацию обо всех направлениях и количестве курсов которые по ним организованы 
SELECT themes.name AS 'theme', COUNT(courses.id) AS 'count_courses'
FROM courses
RIGHT JOIN themes ON themes.id = courses.id_theme
GROUP BY themes.name;

--- 5.	Вывести информацию о курсах и количестве сопровождающих
SELECT themes.name AS 'theme', forms.name AS 'form', courses.lect_hours, courses.labs_hours, courses.progress_hours, COUNT(persones.id) AS 'count persones' 
FROM courses
JOIN teams ON teams.id_course = courses.id
JOIN missions ON missions.id = teams.id_mission
JOIN roles ON roles.id = missions.id_role
JOIN persones ON persones.id = missions.id_persone
JOIN forms ON forms.id = courses.id_form
JOIN themes ON themes.id = courses.id_theme
GROUP BY themes.name, forms.name,  courses.lect_hours, courses.labs_hours, courses.progress_hours;

--- 6.	Найти сопровождающи,х которые задействованы в разных курсах
SELECT persones.name AS 'teacher_name', COUNT(DISTINCT courses.id) AS 'count_courses'
FROM courses
JOIN teams ON teams.id_course = courses.id
JOIN missions ON missions.id = teams.id_mission
JOIN persones ON persones.id = missions.id_persone
GROUP BY persones.name
HAVING COUNT(DISTINCT courses.id) > 1;

--- 7.	На каких курах учится более 5 студентов
SELECT courses.id, themes.name AS 'theme', forms.name AS 'form', COUNT(students.id) AS 'count'
FROM courses
JOIN themes ON themes.id = courses.id_theme
JOIN forms ON forms.id = courses.id_form
JOIN connects ON connects.id_course = courses.id
JOIN students ON students.id = connects.id_student
GROUP BY courses.id, themes.name, forms.name
HAVING COUNT(students.id) > 5;

--- 8.	Вывести информацию о курсах, по которым не проводятся лекции
SELECT themes.name AS 'theme', forms.name AS 'form', courses.str_date, courses.lect_hours, courses.labs_hours, courses.progress_hours
FROM courses
JOIN forms ON forms.id = courses.id_form 
JOIN themes ON themes.id = courses.id_theme
WHERE lect_hours = 0 OR lect_hours IS NULL;

--- 9.	Вывести информацию обо всех сопровождающих и определить количество ролей в которых они выполняют сопровождение
SELECT persones.name, persones.phone, persones.br_date, COUNT(roles.id) AS 'roles_count'
FROM persones
LEFT JOIN missions ON missions.id_persone = persones.id
LEFT JOIN roles ON missions.id_role = roles.id
GROUP BY persones.name, persones.phone, persones.br_date;

--- 10.	Определить количество helper-ов в проекте
SELECT COUNT(*) AS 'count'
FROM missions
JOIN roles ON roles.id = missions.id_role AND roles.name = 'helper'

--- 11.	Определить количество helper-ов в каждом направлении
SELECT themes.name, COUNT(missions.id_persone) AS 'helpers count'
FROM missions
RIGHT JOIN roles ON roles.id = missions.id_role AND roles.name = 'helper'
RIGHT JOIN themes ON themes.id = missions.id_theme
GROUP BY themes.name;

SELECT themes.name, SUM((CASE WHEN (roles.name = 'helper') THEN 1 ELSE 0 END)) AS 'helpers count'
FROM missions
JOIN roles ON roles.id = missions.id_role
JOIN themes ON themes.id = missions.id_theme
GROUP BY themes.name;

--- 12.	Вывести информацию о направлениях, в которых есть mentor-ы
SELECT DISTINCT themes.name AS 'theme'
FROM missions
JOIN roles ON roles.id = missions.id_role AND roles.name = 'mentor'
JOIN themes ON themes.id = missions.id_theme

--- 13.	Вывести информацию о направлениях и количестве mentor-ов в каждом из направлений
SELECT themes.name AS 'theme', COUNT(missions.id_persone) AS 'mentors count'
FROM missions
RIGHT JOIN roles ON roles.id = missions.id_role AND roles.name = 'mentor'
RIGHT JOIN themes ON themes.id = missions.id_theme
GROUP BY themes.name;

SELECT DISTINCT themes.name AS 'theme', SUM((CASE WHEN (roles.name = 'mentor') THEN 1 ELSE 0 END)) AS 'mentors count'
FROM missions
JOIN themes ON themes.id = missions.id_theme
JOIN roles ON roles.id = missions.id_role
GROUP BY themes.name;

--- 14.	определить число студентов, которые учатся на курсах, в которых предусмотрены лекции
SELECT COUNT(students.id) AS 'count'
FROM courses
JOIN connects ON connects.id_course = courses.id
JOIN students ON students.id = connects.id_student
WHERE lect_hours > 0 OR lect_hours IS NOT NULL;

--- 15.	Определить количество студентов на каждом  курсе младше 27 на текущий момент
SELECT courses.id, themes.name AS 'theme', forms.name AS 'form', COUNT(students.id) AS 'count'
FROM courses
JOIN themes ON themes.id = courses.id_theme
JOIN forms ON forms.id = courses.id_form
JOIN connects ON connects.id_course = courses.id
JOIN students ON students.id = connects.id_student
WHERE DATEDIFF(DAY, students.br_date, GETDATE())/365 < 27
GROUP BY courses.id, themes.name, forms.name;

SELECT courses.id, themes.name AS 'theme', forms.name AS 'form', SUM((CASE WHEN (DATEDIFF(DAY, students.br_date, GETDATE())/365 < 27) THEN 1 ELSE 0 END)) AS 'students count'
FROM courses
JOIN themes ON themes.id = courses.id_theme
JOIN forms ON forms.id = courses.id_form
JOIN connects ON connects.id_course = courses.id
JOIN students ON students.id = connects.id_student
GROUP BY courses.id, themes.name, forms.name;