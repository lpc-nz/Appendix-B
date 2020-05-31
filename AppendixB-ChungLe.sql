USE [GuestHouse2020];
GO
--Q1
SELECT guest_id, room_no, booking_date
FROM booking
WHERE room_no = 101 AND booking_date = '2016-11-17';
GO

--Q2
SELECT booking_date, nights, guest_id
FROM booking
WHERE guest_id = 1540;
GO

--Q3
SELECT arrival_time AS 'Arrival Time',
			first_name AS 'First Name',
			last_name AS 'Last Name'	
FROM booking
INNER JOIN guest
ON booking.guest_id = guest.id
WHERE booking_date = '2016-11-05'
ORDER BY arrival_time;
GO

--Q4
SELECT booking_id AS 'Booking ID', 
			room_type_requested AS 'Room Type', 
			occupants AS 'Occupants', 
			amount AS 'Amount'
FROM booking
INNER JOIN rate
ON booking.room_type_requested = rate.room_type AND  booking.occupants = rate.occupancy
WHERE booking_id IN (5152, 5165, 5154, 5295);
GO

--Q5
SELECT first_name AS 'First Name', 
			last_name AS 'Last Name', 
			address AS 'Address', 
			room_no AS 'Room', 
			booking_date AS 'Booking Date'
FROM guest
INNER JOIN booking
ON booking.guest_id = guest.id
WHERE room_no = 101 AND booking_date = '2016-12-03';
GO

--Q6
SELECT guest_id AS 'Guest ID', 
			SUM (nights) AS 'Total Nights', 
			COUNT (booking_id) AS 'Total Booking'
FROM booking
WHERE guest_id IN (1185, 1270)
GROUP BY guest_id;
GO

--Q7
SELECT first_name +' '+last_name AS 'Full Name',
			SUM(nights * amount) AS 'Total'
FROM guest
JOIN booking
ON  guest.id = booking.guest_id
JOIN rate
ON booking.room_type_requested = rate.room_type 
	AND booking.occupants = rate.occupancy
WHERE first_name = 'Ruth' AND last_name = 'Cadbury'
GROUP BY first_name +' '+last_name
GO

--Q7--Version 2
SELECT first_name +' '+last_name AS 'Full Name',
			room_type_requested AS 'Room Type',
			occupants,
			nights,
			amount AS 'Rate',
			(nights * amount) AS 'Total'
FROM booking
JOIN guest
ON booking.guest_id = guest.id
JOIN rate
ON booking.room_type_requested = rate.room_type 
	AND booking.occupants = rate.occupancy
WHERE first_name = 'Ruth' 
	AND last_name = 'Cadbury'
GROUP BY first_name +' '+ last_name, 
					room_type_requested, 
					occupants, nights, amount;
GO

--Q8
SELECT booking.booking_id,
			((booking.nights * rate.amount) + SUM(extra.amount)) AS 'Total Bill'
FROM booking
JOIN rate
ON booking.room_type_requested = rate.room_type
		AND booking.occupants = rate.occupancy
JOIN extra
ON booking.booking_id = extra.booking_id
WHERE booking.booking_id = 5346
GROUP BY booking.booking_id, booking.nights, rate.amount;
GO

--Q9
SELECT last_name AS 'Last Name', 
			first_name AS 'First Name',
			 address, 
			 ISNULL(nights, 0) AS 'Nights'
FROM guest
FULL OUTER JOIN booking
ON guest.id = booking.guest_id
WHERE address LIKE '%Edinburgh%'
ORDER BY last_name, first_name;
GO

--Q10------------------------------
SELECT booking_date, COUNT(booking_id) AS 'Total Booking'
FROM booking
WHERE booking_date 
			BETWEEN '2016-11-25' 
			AND '2016-12-01'
GROUP BY booking_date;
GO

--Q11
SELECT SUM(occupants) AS 'Total People'
FROM booking
WHERE booking_date <= '2016-11-21' 
			AND DATEADD(day, nights, booking_date) > '2016-11-21'
GO

--Q11--Version 2
SELECT booking_date, 
			DATEADD(day, nights, booking_date) AS 'Check Out',
			SUM(occupants) AS 'Total People'
FROM booking
WHERE booking_date <= '2016-11-21' 
			AND DATEADD(day, nights, booking_date) > '2016-11-21'
GROUP BY booking_date, nights;
GO

--Q12
SELECT id AS 'Room Available'
FROM room 
WHERE id NOT IN
    (SELECT room_no FROM booking
     WHERE DATEADD(day, nights, booking_date) > '2016-11-25'
				AND booking_date <= '2016-11-25');
GO