use flight_reservation_system;


-- 1. Write a query to retrieve all available flights between New york and Miami departure between 8:00 - 10:00, 
-- including flight number, Aircraft Type, and arrival time
select flight_number, Aircraft_type, scheduled_arrival_time from flights where ((departure_airport = (select airport_code from airports where city = "New york") or departure_airport = (select airport_code from airports where city = "Miami")) and (arrival_airport = (select airport_code from airports where city = "New york") or arrival_airport = (select airport_code from airports where city = "Miami")) and (scheduled_departure_time >= "08:00:00" and scheduled_departure_time <= "10:00:00"));

-- 2. Write a query to display the booking history of a passenger whoes Phone no is "5551234" , including flight details and booking dates.
-- create a view .
create view BookingHistory_view as
select booking.booking_reference_number,booking.booking_status, flights.* from passenger 
join booking on passenger.passenger_ID = booking.passenger_ID
join flights on booking.flight_number = flights.flight_number 
where passenger.phone_number = "5551234";

-- 3. Write a query to retrieve the ticket prices for all flights from "JSK" to "MIA", including different classes (e.g., Economy, Business).
-- (create a view).
create view TicketPrice_view as
select class,base_fare from fares where fare_ID in(select fare_ID from tickets where passenger_ID in(select passenger_ID from booking where flight_number in(select flight_number from flights where departure_airport = "JFK" and arrival_airport = "MIA")));

-- 4. Write a query to apply a discount code "D013"  to a booking , adjusting the total ticket price of fare_id "F010" accordingly.
select  total_fare,(select Discount_Amount from discount where discount_ID = "D013") as discount, concat("$",(CAST(REPLACE(total_fare, '$', '') AS DECIMAL) * (100 - (select Discount_Amount from discount where discount_ID = "D013")))/100) as discounted_fare from fares where fare_Id = "F010";

-- 5. Write a query to retrieve detailed information about a passenger with id "p015", including their booking history (status, class, seat assign) ,
-- departure and arrival airport id's and payment mode. (create a view).
select passenger.*, booking.booking_status ,tickets.class ,tickets.seat_Assignment , flights.departure_airport, 
flights.arrival_airport, payment_details.payment_mode from passenger 
join booking on passenger.passenger_ID = booking.passenger_ID
join tickets on passenger.passenger_ID = tickets.passenger_ID
join payment_details on passenger.passenger_ID = payment_details.passenger_ID
join flights on booking.flight_number = flights.flight_number
where passenger.passenger_id = "P015";

-- 6. Write a query to count the number of passengers booked on a flight with flight_number "FN003".
select flight_number,count(passenger_ID) as passenger_count from booking where flight_number = "FN003";

-- 7. Write a query to list all available discount codes, including their percentage discounts and expiration dates.
select * from discount;

-- 8. Write a query to track how many times each discount code has been used.
select discount_ID,count(passenger_ID) from payment_details group by discount_ID;

-- 9. Write a query to find the top 3 airport with the most connections (i.e., the highest number of departing or arriving flights)
select departure_airport as airport_code, count(departure_airport) + count(arrival_airport) as airport_traffic from flights group by departure_airport order by airport_traffic desc limit 0,3;

-- 10. Write a query to retrieve information about all aircraft in the fleet, including model, capacity, and current status.
select * from aircraft where aircraft_ID > "a010";

-- 11. Write a query to retrieve the list of crew members of the aircrafts which where build in between 2010 - 2015.
select * from crew where flight_number in(select flight_number from flights where aircraft_id in(select aircraft_id from aircraft where year_built >= 2010 and year_built <= 2015));

-- 12. Write a query to generate a schedule of all flights of the passengers if their booking is confirmed,
-- including departure and arrival city,and frequency. (sort them by arrival time).
select departure_city, arrival_city, arrival_time, frequency from schedules where flight_number in(select flight_number from booking where booking_status = "Confirmed") order by arrival_time;

-- 13. Create a query to retrieve a list of all flights that have been delayed, including the duration of the delay and the reason.
select flight_number,delay,reason from schedules where delay <> 0;

-- 14. Write a query to record a payment for a booking of passenger with email "isabella.white@example.com", including the amount, 
-- payment method, and transaction date.
select passenger_ID, amount_paid, Payment_Mode, payment_date from payment_details where passenger_ID =(select passenger_ID from passenger where email_address = "isabella.white@example.com");

-- 15. A passenger has upgraded their booking class. Update the BookingClass for the booking with 
-- BookingID = BRN017 from 'Economy' to 'Business'.
update tickets set class = "Business" where passenger_ID = (select passenger_ID from booking where Booking_Reference_Number = "BRN017");

-- 16. A passenger requests to change their seat. Update the SeatNumber for the booking with BookingID = BRN002 to "13A"
update tickets set seat_assignment = "13A" where passenger_ID = (select passenger_ID from booking where Booking_Reference_Number = "BRN002");

-- 17. A flight's departure time has been changed. Update the DepartureTime for the flight with 
-- FlightNumber = 'FN016' to a 18:25.
update flights set Scheduled_Departure_Time = "18:25:00" where flight_number = "FN016";
