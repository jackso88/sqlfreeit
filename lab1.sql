CREATE DATABASE freeit;

USE freeit;

CREATE TABLE STUDENTS (
"������������� ��������" INT NOT NULL IDENTITY,
"���" VARCHAR(30),
"�������" VARCHAR(30),
"��������" VARCHAR(30),
"���� ��������" DATE,
"������������� ������" INT,
CONSTRAINT PK_STUD PRIMARY KEY ("������������� ��������"));

CREATE TABLE TEACHERS (
"������������� �������������" INT NOT NULL IDENTITY,
"���" VARCHAR(30),
"�������" VARCHAR(30),
"��������" VARCHAR(30),
CONSTRAINT PK_TEACH PRIMARY KEY ("������������� �������������"));

CREATE TABLE GROUPS (
"������������� ������" INT NOT NULL IDENTITY,
"������������" VARCHAR(30),
"����" INT,
CONSTRAINT PK_GROUPS PRIMARY KEY ("������������� ������"));

CREATE TABLE "PLAN" (
"������������� ������" INT NOT NULL,
"������������� �������������" INT NOT NULL,
"������������� ��������" INT NOT NULL,
CONSTRAINT PK_PLAN PRIMARY KEY ("������������� ������", "������������� �������������", "������������� ��������"));

CREATE TABLE SUBJECTS (
"������������� ��������" INT NOT NULL IDENTITY,
"������������ ��������" VARCHAR(50),
"���������� ����� �� ��������" INT
CONSTRAINT PK_SUBJECTS PRIMARY KEY ("������������� ��������"));

ALTER TABLE STUDENTS ADD CONSTRAINT FK_STUD_GR FOREIGN KEY ("������������� ������") REFERENCES GROUPS ("������������� ������");

ALTER TABLE "PLAN" ADD CONSTRAINT FK_PLAN_TE FOREIGN KEY ("������������� �������������") REFERENCES TEACHERS ("������������� �������������"),
CONSTRAINT FK_PLAN_SU FOREIGN KEY ("������������� ��������") REFERENCES SUBJECTS ("������������� ��������"),
CONSTRAINT FK_PLAN_GR FOREIGN KEY ("������������� ������") REFERENCES GROUPS ("������������� ������");

INSERT INTO GROUPS VALUES ('��134', 1),
('��135', 1),
('��235', 2),
('��335', 3);

INSERT INTO STUDENTS VALUES ('�.', '���������', '�.', '1997-12-25', 2),
('�.', '������','','1985-12-25', 2),
('�.', '��������', '�.', '1993-02-05', 1),
('�.', '��������', '', '1987-09-22', 3),
('�.', '���������', '�.', '1992-06-17', 3),
('�.', '����������', '�.', '1992-06-18', 4),
('�.', '�������', '�.', '1992-05-13', 4),
('�.', '������', '', '1992-08-14', 4);

INSERT INTO TEACHERS VALUES ('�.', '����������', ''),
('�.', '�������', '�.'),
('�.', '�������', '�.'),
('�.', '�����', '�.'),
('�.', '�����������', '�.'),
('�.', '�������', '�.');

INSERT INTO SUBJECTS VALUES ('������', 200),
('����������', 120),
('������ ��������������', 70),
('�������������� ��', 130),
('�������� ����������� ����������������', 90),
('��������-��������������� ����������������', 70);

INSERT INTO "PLAN" VALUES (1, 1, 1),
(1, 2, 2),
(2, 1, 1),
(2, 2, 2),
(3, 3, 3),
(3, 4, 4),
(4, 5, 5),
(4, 6, 6);

UPDATE STUDENTS SET "������������� ������" = 1 WHERE "������������� ������" = 2;

ALTER TABLE "PLAN" DROP FK_PLAN_GR;
ALTER TABLE "PLAN" ADD CONSTRAINT FK_PLAN_GR FOREIGN KEY ("������������� ������") REFERENCES GROUPS ("������������� ������") ON DELETE CASCADE;

DELETE FROM GROUPS
WHERE "������������" LIKE '��135';

UPDATE SUBJECTS SET "���������� ����� �� ��������" = "���������� ����� �� ��������" + 30
WHERE "������������ ��������" LIKE '�������� ����������� ����������������' OR "������������ ��������" LIKE '��������-��������������� ����������������';

ALTER TABLE SUBJECTS ADD "�������� ��������" VARCHAR(30);

UPDATE SUBJECTS SET "�������� ��������" = '�������'
WHERE "������������ ��������" NOT LIKE '������ ��������������';

UPDATE SUBJECTS SET "�������� ��������" = '�����'
WHERE "������������ ��������" LIKE '������ ��������������';

ALTER TABLE STUDENTS DROP COLUMN "��������";

ALTER TABLE TEACHERS DROP COLUMN "��������";

