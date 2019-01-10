--ОСНОВНЫЕ КОНСТРУКЦИИ И СИНТАКСИС

-- 4.2 выбор всех моделей и их диапозоны дальности полетов
SELECT model, range FROM aircrafts;

--4.3 Найти все самолеты, максимальная дальность полета которых:
--4.3.1 больше 10 000 и меньше 4 000 км
SELECT model, range FROM aircrafts
WHERE range > 10000 OR range < 4000;

--4.3.2 больше 6 000 и название не заканчивается на "100"
SELECT model, range FROM aircrafts
--символ % означает - любой символ аналог точки в RegEx
WHERE range > 6000 AND model NOT LIKE '%100';

--4.4 Определить номера и времена отправки всех рейсов,
-- прибывших в аэропорт назначени не вовремя
SELECT flight_no, actual_arrival FROM flights
WHERE actual_arrival NOTNULL AND scheduled_arrival != actual_arrival;


--4.5 Вывести количество отмененных рейсов из Пулково (LED)
--вылет и прибытие, которых назначено на четверг
SELECT flight_no, arrival_airport, scheduled_arrival, status FROM flights
WHERE arrival_airport = 'LED'
  AND status = 'Cancelled'
  --нашел в календаре день недели
  --преобразование timestamp --> date
  AND scheduled_arrival::date = '2017-09-14';


--Соединения

--Упражнение 4.6. Выведите имена пассажиров, купивших билеты эконом-класса за сумму,превышающую 70000 рублей.
SELECT tickets.passenger_name, bookings.total_amount, ticket_flights.fare_conditions FROM tickets
  --ON аналог если (JOIN будет выполнен если выражение после ON возвращает true)
LEFT JOIN bookings ON tickets.book_ref = bookings.book_ref
LEFT JOIN ticket_flights ON tickets.ticket_no = ticket_flights.ticket_no
WHERE fare_conditions = 'Economy' AND bookings.bookings.total_amount > 70000;


/*Упражнение 4.7. Напечатанный посадочный талон должен содержать фамилию и имя пассажира,
коды аэропортов вылета и прилета,дату и время вылета и прилета по расписанию,
номер места в салоне самолета. Напишите запрос,выводящий всю необходимую информацию
для полученных посадочных талонов на рейсы, которые еще не вылетели.
*/
--прописываю все необходимые поля из разных таблиц
--поля не из записи FROM прописываю через путь(лучше все поля через путь)
SELECT tickets.passenger_name, departure_airport,
       scheduled_departure,arrival_airport,
       scheduled_arrival,  status,
       boarding_passes.seat_no
FROM flights
  --указываю таблицу для объединения и условие соединения
LEFT JOIN boarding_passes ON flights.flight_id = boarding_passes.flight_id
LEFT JOIN tickets ON tickets.ticket_no = boarding_passes.ticket_no
--задаю условия фильтрации вывода
WHERE status = 'Sceduled' OR status = 'On Time' OR status = 'Delayed';


/*Упражнение 4.8. Некоторые пассажиры, вылетающие сегодняшним рейсом
(«сегодня» определяется функцией bookings.now),
еще не прошли регистрацию, то есть не получили посадочный талон.
Выведите имена этих пассажиров и номера рейсов.
*/




/*Упражнение 4.9. Выведите номера мест, оставшихся свободными в рейсах из Анапы (AAQ)
в Шереметьево (SVO), вместе с номером рейса и его датой.
*/

