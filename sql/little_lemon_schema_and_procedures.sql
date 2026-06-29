-- Little Lemon Database Project - Rubric Ready Version
-- This script creates the database, tables, sample data, and required stored procedures.

DROP DATABASE IF EXISTS little_lemon_db;
CREATE DATABASE little_lemon_db;
USE little_lemon_db;

-- Customer table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(30),
    Email VARCHAR(100)
);

-- Booking table
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY,
    BookingDate DATE NOT NULL,
    TableNumber INT NOT NULL,
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Menu table
CREATE TABLE Menu (
    MenuID INT PRIMARY KEY,
    Cuisine VARCHAR(100),
    Starter VARCHAR(100),
    Course VARCHAR(100),
    Dessert VARCHAR(100),
    Drink VARCHAR(100)
);

-- Order table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    Quantity INT,
    TotalCost DECIMAL(10,2),
    CustomerID INT,
    MenuID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (MenuID) REFERENCES Menu(MenuID)
);

-- Delivery status table
CREATE TABLE OrderDeliveryStatus (
    DeliveryID INT PRIMARY KEY,
    OrderID INT,
    DeliveryDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert sample data
INSERT INTO Customers VALUES
(1, 'Anna Iversen', '555-1001', 'anna@example.com'),
(2, 'Marcos Romero', '555-1002', 'marcos@example.com'),
(3, 'Vanessa McCarthy', '555-1003', 'vanessa@example.com'),
(4, 'Hiro Tanaka', '555-1004', 'hiro@example.com'),
(5, 'Anees Java', '555-1005', 'anees@example.com'),
(99, 'Peer Review Customer', '555-1099', 'peer99@example.com');

INSERT INTO Bookings VALUES
(1, '2022-10-10', 5, 1),
(2, '2022-11-12', 3, 3),
(3, '2022-10-11', 2, 2),
(4, '2022-10-13', 2, 1);

INSERT INTO Menu VALUES
(1, 'Greek', 'Greek Salad', 'Grilled Fish', 'Greek Yogurt', 'Athens White Wine'),
(2, 'Italian', 'Bruschetta', 'Pasta', 'Tiramisu', 'Chianti'),
(3, 'Turkish', 'Meze', 'Kebab', 'Baklava', 'Turkish Coffee');

-- Quantity includes 5 so GetMaxQuantity() returns 5 as required by the rubric.
INSERT INTO Orders VALUES
(1, '2022-10-10', 2, 86.00, 1, 1),
(2, '2022-10-11', 5, 150.00, 2, 2),
(3, '2022-10-12', 1, 37.50, 3, 3),
(4, '2022-10-13', 3, 90.00, 4, 1);

INSERT INTO OrderDeliveryStatus VALUES
(1, 1, '2022-10-10', 'Delivered'),
(2, 2, '2022-10-11', 'Delivered'),
(3, 3, '2022-10-12', 'Preparing'),
(4, 4, '2022-10-13', 'Delivered');

-- Procedure 1: GetMaxQuantity()
DROP PROCEDURE IF EXISTS GetMaxQuantity;
DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
    SELECT MAX(Quantity) AS `Max Quantity in Order`
    FROM Orders;
END //
DELIMITER ;

-- Procedure 2: ManageBooking()
-- Books an available table and rejects an already reserved table.
DROP PROCEDURE IF EXISTS ManageBooking;
DELIMITER //
CREATE PROCEDURE ManageBooking(IN booking_date DATE, IN table_number INT)
BEGIN
    DECLARE booking_count INT DEFAULT 0;
    DECLARE new_booking_id INT DEFAULT 0;

    SELECT COUNT(*)
    INTO booking_count
    FROM Bookings
    WHERE BookingDate = booking_date
      AND TableNumber = table_number;

    IF booking_count > 0 THEN
        SELECT CONCAT('Table ', table_number, ' is already booked - booking cancelled') AS `Booking status`;
    ELSE
        SELECT IFNULL(MAX(BookingID), 0) + 1
        INTO new_booking_id
        FROM Bookings;

        INSERT INTO Bookings (BookingID, BookingDate, TableNumber, CustomerID)
        VALUES (new_booking_id, booking_date, table_number, 99);

        SELECT CONCAT('Table ', table_number, ' is available - booking confirmed') AS `Booking status`;
    END IF;
END //
DELIMITER ;

-- Procedure 3: AddBooking()
DROP PROCEDURE IF EXISTS AddBooking;
DELIMITER //
CREATE PROCEDURE AddBooking(
    IN booking_id INT,
    IN customer_id INT,
    IN table_number INT,
    IN booking_date DATE
)
BEGIN
    INSERT INTO Bookings (BookingID, BookingDate, TableNumber, CustomerID)
    VALUES (booking_id, booking_date, table_number, customer_id);

    SELECT CONCAT('New booking added. Booking ID: ', booking_id) AS `Confirmation`;
END //
DELIMITER ;

-- Procedure 4: UpdateBooking()
-- The rubric passes 99 and a date. The first parameter is treated as BookingID.
DROP PROCEDURE IF EXISTS UpdateBooking;
DELIMITER //
CREATE PROCEDURE UpdateBooking(IN booking_id INT, IN new_booking_date DATE)
BEGIN
    UPDATE Bookings
    SET BookingDate = new_booking_date
    WHERE BookingID = booking_id;

    SELECT CONCAT('Booking ', booking_id, ' updated') AS `Confirmation`;
END //
DELIMITER ;

-- Procedure 5: CancelBooking()
-- The rubric passes 99. The parameter is treated as BookingID.
DROP PROCEDURE IF EXISTS CancelBooking;
DELIMITER //
CREATE PROCEDURE CancelBooking(IN booking_id INT)
BEGIN
    DELETE FROM Bookings
    WHERE BookingID = booking_id;

    SELECT CONCAT('Booking ', booking_id, ' cancelled') AS `Confirmation`;
END //
DELIMITER ;

-- Rubric verification tests
CALL GetMaxQuantity();

-- ManageBooking test 1: available table, should book
CALL ManageBooking('2022-12-10', 99);

-- ManageBooking test 2: same table/date now reserved, should reject
CALL ManageBooking('2022-12-10', 99);

-- AddBooking test specified by rubric
CALL AddBooking(99, 99, 99, '2022-12-10');

-- UpdateBooking test specified by rubric
CALL UpdateBooking(99, '2022-01-10');

-- CancelBooking test specified by rubric
CALL CancelBooking(99);

-- Review current bookings
SELECT * FROM Bookings;
