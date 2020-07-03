CREATE DATABASE freeit;

USE freeit;

CREATE TABLE STUDENTS (
"идентификатор студента" INT NOT NULL IDENTITY,
"имя" VARCHAR(30),
"фамилия" VARCHAR(30),
"отчество" VARCHAR(30),
"дата рождения" DATE,
"идентификатор группы" INT,
CONSTRAINT PK_STUD PRIMARY KEY ("идентификатор студента"));

CREATE TABLE TEACHERS (
"идентификатор преподавателя" INT NOT NULL IDENTITY,
"имя" VARCHAR(30),
"фамилия" VARCHAR(30),
"отчество" VARCHAR(30),
CONSTRAINT PK_TEACH PRIMARY KEY ("идентификатор преподавателя"));

CREATE TABLE GROUPS (
"идентификатор группы" INT NOT NULL IDENTITY,
"наименование" VARCHAR(30),
"курс" INT,
CONSTRAINT PK_GROUPS PRIMARY KEY ("идентификатор группы"));

CREATE TABLE "PLAN" (
"идентификатор группы" INT NOT NULL,
"идентификатор преподавателя" INT NOT NULL,
"идентификатор предмета" INT NOT NULL,
CONSTRAINT PK_PLAN PRIMARY KEY ("идентификатор группы", "идентификатор преподавателя", "идентификатор предмета"));

CREATE TABLE SUBJECTS (
"идентификатор предмета" INT NOT NULL IDENTITY,
"наименование предмета" VARCHAR(50),
"количество часов по предмету" INT
CONSTRAINT PK_SUBJECTS PRIMARY KEY ("идентификатор предмета"));

ALTER TABLE STUDENTS ADD CONSTRAINT FK_STUD_GR FOREIGN KEY ("идентификатор группы") REFERENCES GROUPS ("идентификатор группы");

ALTER TABLE "PLAN" ADD CONSTRAINT FK_PLAN_TE FOREIGN KEY ("идентификатор преподавателя") REFERENCES TEACHERS ("идентификатор преподавателя"),
CONSTRAINT FK_PLAN_SU FOREIGN KEY ("идентификатор предмета") REFERENCES SUBJECTS ("идентификатор предмета"),
CONSTRAINT FK_PLAN_GR FOREIGN KEY ("идентификатор группы") REFERENCES GROUPS ("идентификатор группы");

INSERT INTO GROUPS VALUES ('ПО134', 1),
('ПО135', 1),
('ПО235', 2),
('ПО335', 3);

INSERT INTO STUDENTS VALUES ('П.', 'Федоренко', 'Р.', '1997-12-25', 2),
('О.', 'Зингел','','1985-12-25', 2),
('П.', 'Михеенок', 'Г.', '1993-02-05', 1),
('Н.', 'Савицкая', '', '1987-09-22', 3),
('М.', 'Ковальчук', 'Е.', '1992-06-17', 3),
('Н.', 'Заболотная', 'Г.', '1992-06-18', 4),
('Т.', 'Ковриго', 'Р.', '1992-05-13', 4),
('Н.', 'Шарапо', '', '1992-08-14', 4);

INSERT INTO TEACHERS VALUES ('Н.', 'Сафроненко', ''),
('Н.', 'Зайцева', 'У.'),
('П.', 'Лисопад', 'Г.'),
('К.', 'Клюев', 'Н.'),
('П.', 'Рогачевский', 'Н.'),
('Н.', 'Макаров', 'Г.');

INSERT INTO SUBJECTS VALUES ('Физика', 200),
('Математика', 120),
('Основы алгоритмизации', 70),
('Проектирование БД', 130),
('Средства визуального программирования', 90),
('Объектно-ориентированное программирование', 70);

INSERT INTO "PLAN" VALUES (1, 1, 1),
(1, 2, 2),
(2, 1, 1),
(2, 2, 2),
(3, 3, 3),
(3, 4, 4),
(4, 5, 5),
(4, 6, 6);

UPDATE STUDENTS SET "идентификатор группы" = 1 WHERE "идентификатор группы" = 2;

ALTER TABLE "PLAN" DROP FK_PLAN_GR;
ALTER TABLE "PLAN" ADD CONSTRAINT FK_PLAN_GR FOREIGN KEY ("идентификатор группы") REFERENCES GROUPS ("идентификатор группы") ON DELETE CASCADE;

DELETE FROM GROUPS
WHERE "наименование" LIKE 'ПО135';

UPDATE SUBJECTS SET "количество часов по предмету" = "количество часов по предмету" + 30
WHERE "наименование предмета" LIKE 'Средства визуального программирования' OR "наименование предмета" LIKE 'Объектно-ориентированное программирование';

ALTER TABLE SUBJECTS ADD "средство контроля" VARCHAR(30);

UPDATE SUBJECTS SET "средство контроля" = 'экзамен'
WHERE "наименование предмета" NOT LIKE 'Основы алгоритмизации';

UPDATE SUBJECTS SET "средство контроля" = 'зачет'
WHERE "наименование предмета" LIKE 'Основы алгоритмизации';

ALTER TABLE STUDENTS DROP COLUMN "Отчество";

ALTER TABLE TEACHERS DROP COLUMN "Отчество";

