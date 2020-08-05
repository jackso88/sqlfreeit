USE univer;

--- Создание таблиц
CREATE TABLE teachers (
ID INT IDENTITY PRIMARY KEY NOT NULL,
last_name NVARCHAR(40) NOT NULL,
f_name NVARCHAR(40),
s_name NVARCHAR(40),
br_date DATE,
start_work_date DATE
);

CREATE TABLE subjects (
ID INT IDENTITY PRIMARY KEY NOT NULL,
sub_name NVARCHAR(80),
);

CREATE TABLE subj_teach (
ID INT IDENTITY PRIMARY KEY NOT NULL,
id_teach INT NOT NULL,
id_subj INT NOT NULL
);

CREATE TABLE students (
ID INT IDENTITY PRIMARY KEY NOT NULL,
last_name NVARCHAR(40) NOT NULL,
f_name NVARCHAR(40),
s_name NVARCHAR(40),
br_date DATE,
in_date DATE,
exm DECIMAL(2,1)
);

CREATE TABLE connects_teach (
course_id INT NOT NULL,
sub_teach_id INT  NOT NULL,
hours INT
);

CREATE TABLE connects_stud(
course_id INT NOT NULL,
students_id INT NOT NULL
);

CREATE TABLE faculty (
ID INT IDENTITY PRIMARY KEY NOT NULL,
faculty_name NVARCHAR(40) NOT NULL
);

CREATE TABLE form (
ID INT IDENTITY PRIMARY KEY NOT NULL,
form_name NVARCHAR(40),
);

CREATE TABLE connects_form (
ID INT IDENTITY PRIMARY KEY NOT NULL,
id_faculty INT NOT NULL,
id_form INT NOT NULL
);

CREATE TABLE courses (
ID INT IDENTITY PRIMARY KEY NOT NULL,
id_con_form INT NOT NULL,
year INT NOT NULL,
in_class INT,
all_hours INT
);

--- Создание связей
ALTER TABLE connects_form ADD CONSTRAINT FK_FORM_FORM FOREIGN KEY (id_form) REFERENCES form (id),
CONSTRAINT FK_FACULTY FOREIGN KEY (id_faculty) REFERENCES faculty (id);
ALTER TABLE courses ADD CONSTRAINT FK_COURS_FORM FOREIGN KEY (id_con_form) REFERENCES connects_form (id);
ALTER TABLE subj_teach ADD CONSTRAINT FK_ST_TEACH FOREIGN KEY (id_teach) REFERENCES teachers (id),
CONSTRAINT FK_ST_SUBJ FOREIGN KEY (id_subj) REFERENCES subjects (id);
ALTER TABLE connects_teach ADD CONSTRAINT FK_CON_SUB FOREIGN KEY (sub_teach_id) REFERENCES subj_teach (id),
CONSTRAINT FK_CON_COURSES FOREIGN KEY (course_id) REFERENCES courses (id);
ALTER TABLE connects_stud ADD CONSTRAINT FK_CON_STUD FOREIGN KEY (students_id) REFERENCES students (id),
CONSTRAINT FK_CON_STCOURSE FOREIGN KEY (course_id) REFERENCES courses (id);

---создание первичных ключей
ALTER TABLE connects_teach ADD PRIMARY KEY (course_id, sub_teach_id);
ALTER TABLE connects_stud ADD PRIMARY KEY (course_id, students_id);

--- Заполнение таблиц
INSERT INTO faculty
SELECT DISTINCT faculty FROM teach;

INSERT INTO form
SELECT DISTINCT form FROM teach;

INSERT INTO connects_form
SELECT DISTINCT faculty.ID, form.ID FROM teach
JOIN form ON form.form_name = teach.form
JOIN faculty ON faculty.faculty_name = teach.faculty;

INSERT INTO teachers
SELECT DISTINCT last_name, f_name, s_name, br_date, start_work_date FROM teach;

INSERT INTO subjects
SELECT DISTINCT subj FROM teach;

INSERT INTO subj_teach
SELECT DISTINCT teachers.id, subjects.id FROM teach
JOIN teachers ON teachers.last_name = teach.last_name AND teachers.br_date = teach.br_date
JOIN subjects ON subjects.sub_name = teach.subj;

INSERT INTO students
SELECT DISTINCT last_name, f_name, s_name, br_date, in_date, exm FROM stud;

INSERT INTO courses
SELECT DISTINCT tmp.id, tmp.year, stud.inclass_h, stud.all_h FROM stud
RIGHT JOIN (SELECT DISTINCT connects_form.id AS ID, form.form_name AS form, faculty.faculty_name AS faculty, teach.year AS year FROM connects_form
			JOIN form ON form.id = connects_form.id_form
			JOIN faculty ON faculty.ID = connects_form.id_faculty
			JOIN teach ON teach.form = form.form_name AND teach.faculty = faculty.faculty_name) tmp ON tmp.faculty = stud.faculty AND tmp.form = stud.form AND tmp.year = stud.year;

INSERT INTO connects_teach
SELECT tmp.id, tmp2.id, teach.hours FROM teach
JOIN (SELECT courses.id AS id, courses.year AS year, form.form_name AS form, faculty.faculty_name AS faculty FROM courses
		JOIN connects_form ON connects_form.id = courses.id_con_form
		JOIN faculty ON faculty.id = connects_form.id_faculty
		JOIN form ON form.id = connects_form.id_form) tmp ON teach.year = tmp.year AND teach.form = tmp.form AND teach.faculty = tmp.faculty
JOIN (SELECT subj_teach.id AS id, teachers.last_name AS name, subjects.sub_name AS subjects FROM subj_teach
		JOIN teachers ON teachers.ID = subj_teach.id_teach 
		JOIN subjects ON subjects.ID = subj_teach.id_subj) tmp2 ON tmp2.name = teach.last_name AND tmp2.subjects = teach.subj;

INSERT INTO connects_stud
SELECT tmp.id, students.id FROM stud
JOIN (SELECT courses.id AS id, courses.year AS year, form.form_name AS form, faculty.faculty_name AS faculty FROM courses
		JOIN connects_form ON connects_form.id = courses.id_con_form
		JOIN faculty ON faculty.id = connects_form.id_faculty
		JOIN form ON form.id = connects_form.id_form) tmp ON stud.year = tmp.year AND stud.form = tmp.form AND stud.faculty = tmp.faculty
JOIN students ON students.last_name = stud.last_name AND students.br_date = stud.br_date;