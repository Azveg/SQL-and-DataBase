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


--Сортировка
/*
Рекомендуется выполнять в конце запроса, перед получением результата

Производится ключевым словом "ORDER BY"
направления сортировки указываются:
ASC - по возрастанию (по умолчанию);
DESC - по убыванию
 */

 SELECT * FROM exams
ORDER BY score DESC , s_id DESC , c_no;

--Группировка
/*
При группировке в одной строке результата размещается значение,
вычисленное на основании данных нескольких строк исходных таблиц.
Также можно совместно использовать агрегатные функции.
 */

 SELECT count(*), count(DISTINCT s_id),
        avg(score)
FROM exams;

--разбивка сгруппированная по курсу
SELECT c_no, count(*),
       count(DISTINCT s_id), avg(score)
FROM exams
GROUP BY c_no;

--фильтрация
/*
WHERE - используется до группировки
HAVING - после группировки
 */

 SELECT students.name
FROM students, exams
WHERE students.s_id = exams.s_id AND exams.score = 5
 GROUP BY students.name
HAVING count(*) > 1;

UPDATE courses
SET hours = hours * 4
WHERE c_no = 'CS301';

SELECT hours FROM courses
WHERE c_no = 'CS301';

DELETE FROM exams WHERE score < 5;

CREATE TABLE groups(
  g_no Text PRIMARY KEY ,
  monitor INTEGER NOT NULL REFERENCES students(s_id)
);

ALTER TABLE students
ADD g_no text REFERENCES groups(g_no);

BEGIN ;

INSERT INTO groups(g_no, monitor)
SELECT 'A-101', s_id
FROM students
WHERE name = 'Анна';

UPDATE students SET g_no = 'A-101';

SELECT * FROM students;

COMMIT ;