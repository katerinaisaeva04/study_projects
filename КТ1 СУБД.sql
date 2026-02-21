----------- Исаева Екатерина, группа Э-2208 -----------------------------------------------------------------------
----------- Вариант 1 ---------------------------------------------------------------------------------------------

-- ЗАДАНИЕ 1
-- Выведите названия самолетов без бизнес-класса. Используйте в решении функцию array_agg.
-- Информмция о классе обслуживания содержится в таблице seats.
select model
from aircrafts 
where aircraft_code not in (select aircraft_code from seats group by aircraft_code having 'Business' = any(array_agg(fare_conditions)))

-- ЗАДАНИЕ 2
-- Определить, в каких направлениях (больше всего задержанных рейсов.
-- В результирующую таблицу вывести город отправления, город назначения и количество задержанных рейсов.
-- Информация о статусе рейса содержится в таблице flights.
select departure.city, arrival.city, count(*)
from flights f, airports departure, airports arrival
where f.departure_airport = departure.airport_code and f.arrival_airport = arrival.airport_code and f.status = 'Delayed'
group by departure.city, arrival.city
order by count(*) desc
limit 2

-- Задание 3
-- Посчитать количество рейсов, на которые не было продано ни одного билета.
select count(*) 
from flights
left join ticket_flights tf using(flight_id)
where ticket_no is null

-- Задание 4
-- Определить направления полетов для пассажиров, купивших более 700 билетов. В результирующую таблицу 
-- вывести имя пассажира, уникальные направления его пролетов, общее количество купленных билетов.
select passenger_name, array_agg(distinct departure_airport||' '||arrival_airport), count(*)
from tickets
join ticket_flights tf using(ticket_no)
join flights f using(flight_id)
group by passenger_name
having count(*) > 700

-- Задание 5
-- Вывести одним запросом общее количество рейсов, вылетающих из Пулково, и количество рейсов, 
-- приземляющихся в Домодедово. Результирующая таблица должна содержать две строки.
select 'изПулково', count(*)
from flights 
where departure_airport = 'LED'
union all
select 'вДомодедово', count(*) 
from flights 
where arrival_airport = 'DME'

-- Задание 6
-- Определить список аэропортов, в которые прилетели самолеты 2 ноября 2016 года, 
-- и из которых не вылетело ни одного самолета в этот день.  
select arrival_airport 
from flights 
where scheduled_arrival::date = '2016-11-02'
except
select departure_airport 
from flights 
where scheduled_departure::date = '2016-11-02'
