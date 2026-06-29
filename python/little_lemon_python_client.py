"""Little Lemon Python client - rubric-ready procedure tests.

Before running:
1. Run sql/little_lemon_schema_and_procedures.sql in MySQL Workbench.
2. Update the password below.
3. Run: python little_lemon_python_client.py
"""

import mysql.connector
from mysql.connector import Error

config = {
    "host": "localhost",
    "user": "root",
    "password": "password",
    "database": "little_lemon_db"
}

def run_query(cursor, query):
    print("\nRunning:", query)
    cursor.execute(query)
    try:
        rows = cursor.fetchall()
        for row in rows:
            print(row)
    except Exception:
        print("No result set returned.")

def main():
    connection = None
    cursor = None

    try:
        connection = mysql.connector.connect(**config)
        cursor = connection.cursor()
        print("Connected to Little Lemon database.")

        run_query(cursor, "CALL GetMaxQuantity();")
        run_query(cursor, "CALL ManageBooking('2022-12-11', 99);")
        connection.commit()
        run_query(cursor, "CALL ManageBooking('2022-12-11', 99);")
        connection.commit()

        run_query(cursor, "CALL AddBooking(99, 99, 99, '2022-12-10');")
        connection.commit()

        run_query(cursor, "CALL UpdateBooking(99, '2022-01-10');")
        connection.commit()

        run_query(cursor, "CALL CancelBooking(99);")
        connection.commit()

        print("\nAll rubric procedure tests completed.")

    except Error as err:
        print("MySQL error:", err)

    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()
            print("Database connection closed.")

if __name__ == "__main__":
    main()
