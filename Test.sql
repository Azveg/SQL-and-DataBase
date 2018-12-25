CREATE TABLE courses(
  c_no text PRIMARY KEY,
  title text,
  hours integer
);

INSERT INTO courses(c_no, title, hours)
VALUES ('CS301', 'Базы данных', 30),
       ('CS305', 'Сети ЭВМ', 60);

CREATE TABLE students(
  s_id integer PRIMARY KEY,
  name text,
  start_year integer
);

insert into students(s_id, name, start_year)
VALUES (1451, 'Анна', 2014),
(1432, 'Виктор', 2014),
(1556, 'Нина', 2015);

CREATE TABLE exams(
  s_id integer REFERENCES students(s_id),
  c_no text REFERENCES courses(c_no),
  score integer,
  CONSTRAINT pk PRIMARY KEY (s_id, c_no)
);

INSERT INTO exams(s_id, c_no, score)
VALUES (1451, 'CS301', 5),
       (1556, 'CS301', 5),
       (1451, 'CS305', 5),
       (1432, 'CS305', 4);

SELECT title AS course_title, hours
from courses;

SELECT start_year FROM students;

SELECT DISTINCT start_year FROM students;

SELECT * FROM courses WHERE hours>45;

SELECT * FROM courses, exams;

SELECT courses.title, exams.s_id, exams.score
FROM courses, exams
WHERE courses.c_no = exams.c_no;

SELECT students.name, exams.score
FROM students
JOIN exams
  ON students.s_id = exams.s_id
  AND exams.c_no = 'CS305';

SELECT students.name, exams.score
FROM students
LEFT JOIN exams
  ON students.s_id = exams.s_id
  AND exams.c_no = 'CS305';

--однострочный коментарий

/*
многострочный
коментарий
 */
SELECT students.name, exams.score
FROM students
LEFT JOIN exams ON students.s_id = exams.s_id
WHERE exams.c_no = 'CS305';

--подзапрос
SELECT name,
       (SELECT score
         FROM exams
         WHERE exams.s_id = students.s_id
         AND exams.c_no = 'CS305')
FROM students;

--фильтрация по подзапросу

SELECT *
FROM exams
WHERE (SELECT start_year
  FROM students
  WHERE students.s_id = exams.s_id) > 2014;

--IN - проверяет содержится ли знач в табл, возвращ подзапросом
SELECT name, start_year
FROM students
WHERE s_id IN (SELECT s_id
  FROM exams
  WHERE c_no = 'CS305');

--NOT IN - противоположность IN
SELECT name, start_year
FROM students
WHERE s_id NOT IN (SELECT s_id
  FROM exams
  WHERE score < 5);


--EXISTS - проверяет возр ли подзап хотя бы одну строку
SELECT name, start_year
FROM students
WHERE NOT exists(SELECT s_id
  FROM exams
  WHERE exams.s_id = students.s_id
  AND score < 5);

/*
Псевдонимы - используются чтобы избежать
неоднозначности в наименованиях
 */

SELECT s.name, ce.score
FROM students s
JOIN (SELECT exams.*
  FROM courses, exams
  WHERE courses.c_no = exams.c_no
  AND courses.title = 'Базы данных') ce
ON s.s_id = ce.s_id;

SELECT s.name, e.score
FROM students s, courses c, exams e
WHERE c.c_no = e.c_no
AND c.title = 'Базы данных'
AND s.s_id = e.s_id;


