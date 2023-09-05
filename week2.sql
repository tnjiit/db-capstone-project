SHOW DATABASES;
USE LittleLemonDB;

# Exercise 1 - Task 1
START TRANSACTION;

DROP VIEW IF EXISTS ordersview;

CREATE OR REPLACE VIEW OrdersView AS
SELECT OrderID, Quantity, TotalCost AS Cost
FROM Orders
WHERE Quantity > 2;

SELECT * FROM OrdersView;

COMMIT;

# Exercise 1 - Task 2

START TRANSACTION;

SELECT CustomerID, CustomerName AS FullName, OrderID, TotalCost AS Cost, MenuID AS MenuName, Cuisine AS CourseName
FROM Orders
INNER JOIN Customers
USING (CustomerID)
INNER JOIN MenuMenuItems
USING (MenuMenuItemsID)
INNER JOIN Menus
USING (MenuID)
WHERE TotalCost > 150
ORDER BY TotalCost ASC;

COMMIT;

# Exercise 1 - Task 3

START TRANSACTION;

SELECT MenuID, Cuisine
FROM Menus
WHERE MenuID = ANY (
	SELECT MenuID
    FROM MenuMenuItems
    INNER JOIN Orders
    USING (MenuMenuItemsID)
    WHERE Quantity > 2
);

COMMIT;

# Exercise 2 - Task 1

DROP PROCEDURE IF EXISTS GetMaxQuantity;

DELIMITER //

CREATE PROCEDURE /* IF NOT EXISTS */ GetMaxQuantity()
BEGIN
	SELECT MAX(Quantity)
    FROM Orders;
END //
DELIMITER ;

START TRANSACTION;

CALL GetMaxQuantity();

ROLLBACK;

# Exercise 2 - Task 2

PREPARE GetOrderDetail FROM
'SELECT OrderID, Quantity, TotalCost AS Cost FROM Orders WHERE CustomerID = ?';

START TRANSACTION;

SET @id = 1;
EXECUTE GetOrderDetail USING @id;

COMMIT;

# Exercise 2 - Task 3

SELECT * FROM Orders
WHERE OrderID = 1;

DROP PROCEDURE IF EXISTS CancelOrder;

DELIMITER //

CREATE PROCEDURE /* IF NOT EXISTS */ CancelOrder(IN inOrderID INT)
BEGIN
	DELETE FROM Orders WHERE OrderID=inOrderID;
END //

DELIMITER ;

START TRANSACTION;

CALL CancelOrder(1);

SELECT * FROM Orders
WHERE OrderID = 1;

ROLLBACK;

SELECT * FROM Orders
WHERE OrderID = 1;

# Exercise 3 - Task 1

DROP TABLE IF EXISTS Bookings;

CREATE TABLE /* IF NOT EXISTS */ Bookings (
	BookingID INT PRIMARY KEY AUTO_INCREMENT,
    BookingDate DATE,
    TableNumber INT,
    CustomerID INT
);

START TRANSACTION;

INSERT INTO Bookings VALUES
(1, '2022-10-10', 5, 1),
(2, '2022-11-12', 3, 3),
(3, '2022-10-11', 2, 2),
(4, '2022-10-13', 2, 2);

SELECT * FROM Bookings;

COMMIT;

# Exercise 3 - Task 2

DROP PROCEDURE IF EXISTS CheckBooking;

DELIMITER //

CREATE PROCEDURE /* IF NOT EXISTS */ CheckBooking(IN inBookingDate DATE, IN inTableNumber INT)
BEGIN
	SELECT CONCAT("Table ", inTableNumber, " is already booked") AS "Booking Status"
    FROM Bookings
    WHERE BookingDate = inBookingDate AND TableNumber = inTableNumber;
END //

DELIMITER ;

START TRANSACTION;

CALL CheckBooking('2022-11-12', 3);

COMMIT;

# Exercise 3 - Task 3

DROP PROCEDURE IF EXISTS AddValidBooking;

DELIMITER //

CREATE PROCEDURE /* IF NOT EXISTS */ AddValidBooking(IN inBookingDate DATE, IN inTableNumber INT)
BEGIN
	START TRANSACTION;
    INSERT INTO Bookings (BookingDate, TableNumber, CustomerID)
    VALUES (inBookingDate, inTableNumber, 4);
    SELECT COUNT(*) INTO @number_of_bookings
    FROM Bookings
    WHERE BookingDate=inBookingDATE AND TableNumber = inTableNumber;
    IF @number_of_bookings > 1 THEN
		ROLLBACK;
	ELSE
		COMMIT;
	END IF;
	SELECT CASE 
		WHEN @number_of_bookings > 1 THEN CONCAT("Table ", inTableNumber, " is already booked - booking cancelled")
        ELSE CONCAT("Table ", inTableNumber, " is now booked")
	END AS "Booking Status";
END //

DELIMITER ;

CALL AddValidBooking('2022-12-17', 6);

SELECT * FROM Bookings;

# Exercise 4 - Task 1

DROP PROCEDURE IF EXISTS AddBooking;

DELIMITER //
CREATE PROCEDURE /* IF NOT EXISTS */ AddBooking(IN inBookingID INT, IN inCustomerID INT, IN inTableNumber INT, IN inBookingDate DATE)
BEGIN
	INSERT INTO Bookings (BookingID, BookingDate, TableNumber, CustomerID) VALUES
    (inBookingID, inBookingDate, inTableNumber, inCustomerID);
    SELECT "New booking added" AS Confirmation;
END // 
DELIMITER ;

START TRANSACTION;

CALL AddBooking(9, 3, 4, "2022-12-30");

SELECT * FROM Bookings;

COMMIT;

SELECT * FROM Bookings;

# Exercise 4 - Task 2

DROP PROCEDURE IF EXISTS UpdateBooking;

DELIMITER //
CREATE PROCEDURE /* IF NOT EXISTS */ UpdateBooking(IN inBookingID INT, IN inBookingDate DATE)
BEGIN
	UPDATE Bookings
    SET BookingDate = inBookingDate
    WHERE BookingID = inBookingID;
    SELECT CONCAT("Booking ",inBookingID," updated");
END //
DELIMITER ;

START TRANSACTION;
CALL UpdateBooking(9, '2022-12-17');
SELECT * FROM Bookings;
COMMIT;

# Exercise 4 - Task 3

DROP PROCEDURE IF EXISTS CancelBooking;

DELIMITER //
CREATE PROCEDURE /* IF NOT EXISTS */ CancelBooking(IN inBookingID INT)
BEGIN
	DELETE FROM Bookings
    WHERE BookingID = inBookingID;
    SELECT CONCAT("Booking ", inBookingID, " cancelled");
END //
DELIMITER ;

START TRANSACTION;
SELECT * FROM Bookings;
CALL CancelBooking(9);
SELECT * FROM Bookings;
COMMIT;
SELECT * FROM Bookings;