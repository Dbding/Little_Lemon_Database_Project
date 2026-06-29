# Little Lemon Database Project - Rubric Ready Version

## Project Title
Little Lemon Booking System and Sales Analysis Project

## Purpose
This repository contains the Little Lemon database project required for peer review. It includes a MySQL database schema, ER diagram, required stored procedures, Python client code, and Tableau analysis notes.

## Rubric checklist

### Repository and project code
- Project files are included in organized folders.
- SQL schema and Python client code are included.

### Required ER diagram
- `LittleLemonDM.png` is included in the root folder.
- A copy is also included in `diagrams/LittleLemonDM.png`.

### Required stored procedures
The SQL script implements and tests:

- `GetMaxQuantity()`  
  Expected output: `5`

- `ManageBooking(booking_date, table_number)`  
  Books an available table and rejects an already reserved table.

- `AddBooking(booking_id, customer_id, table_number, booking_date)`  
  Example test:
  `CALL AddBooking(99, 99, 99, '2022-12-10');`

- `UpdateBooking(booking_id, new_booking_date)`  
  Example test:
  `CALL UpdateBooking(99, '2022-01-10');`

- `CancelBooking(booking_id)`  
  Example test:
  `CALL CancelBooking(99);`

## How to run

1. Open MySQL Workbench.
2. Run `sql/little_lemon_schema_and_procedures.sql`.
3. Verify the stored procedure outputs at the bottom of the SQL file.
4. Optional: update the password in `python/little_lemon_python_client.py` and run the Python client.
