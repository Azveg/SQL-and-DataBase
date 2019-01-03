CREATE VIEW svo_led_utilization AS
  SELECT f.flight_no,
         f.scheduled_departure,
         count(tf.ticket_no) passenger
FROM flights f
JOIN ticket_flights tf on f.flight_id = tf.flight_id
WHERE f.departure_airport = 'SVO'
  AND f.arrival_airport = 'LED'
  AND f.scheduled_departure BETWEEN bookings.now() - INTERVAL '1 day'
                                AND bookings.now()
GROUP BY f.flight_no, f.scheduled_departure;

SELECT * FROM svo_led_utilization;

EXPLAIN (costs off ) SELECT * FROM svo_led_utilization;