import psycopg2
from psycopg2 import sql

def create_tables():
    commands = [
        """
        CREATE TABLE Users (
            user_id SERIAL PRIMARY KEY,
            username VARCHAR(50),
            password VARCHAR(50),
            email VARCHAR(100),
            phone_number VARCHAR(20)
        )
        """,
        """
        CREATE TABLE UserVerification (
            verification_id SERIAL PRIMARY KEY,
            user_id INTEGER,
            verification_code VARCHAR(50),
            expiration_time TIMESTAMP,
            is_verified BOOLEAN,
            FOREIGN KEY (user_id) REFERENCES Users (user_id)
        )
        """,
        """
        CREATE TABLE Categories (
            category_id SERIAL PRIMARY KEY,
            category_name VARCHAR(100)
        )
        """,
        """
        CREATE TABLE Items (
            item_id SERIAL PRIMARY KEY,
            item_name VARCHAR(100),
            category_id INTEGER,
            quantity INTEGER,
            created_at TIMESTAMP,
            FOREIGN KEY (category_id) REFERENCES Categories (category_id)
        )
        """,
        """
        CREATE TABLE ItemEntries (
            entry_id SERIAL PRIMARY KEY,
            item_id INTEGER,
            entry_date TIMESTAMP,
            shelf_life_days INTEGER,
            expiry_date TIMESTAMP,
            quantity INTEGER,
            FOREIGN KEY (item_id) REFERENCES Items (item_id)
        )
        """,
        """
        CREATE TABLE Purchases (
            purchase_id SERIAL PRIMARY KEY,
            item_id INTEGER,
            purchase_date TIMESTAMP,
            purchase_cost DECIMAL(10, 2),
            quantity INTEGER,
            FOREIGN KEY (item_id) REFERENCES Items (item_id)
        )
        """,
        """
        CREATE TABLE Losses (
            loss_id SERIAL PRIMARY KEY,
            item_id INTEGER,
            loss_date TIMESTAMP,
            FOREIGN KEY (item_id) REFERENCES Items (item_id)
        )
        """,
        """
        CREATE TABLE SyncLogs (
            sync_id SERIAL PRIMARY KEY,
            sync_time TIMESTAMP,
            sync_status VARCHAR(50),
            user_id INTEGER,
            FOREIGN KEY (user_id) REFERENCES Users (user_id)
        )
        """,
        """
        CREATE TABLE ConflictLogs (
            conflict_id SERIAL PRIMARY KEY,
            data_id INTEGER,
            user_id INTEGER,
            conflict_time TIMESTAMP,
            resolution_strategy VARCHAR(100),
            resolved_data TEXT,
            FOREIGN KEY (user_id) REFERENCES Users (user_id),
            FOREIGN KEY (data_id) REFERENCES Items (item_id)
        )
        """
    ]

    conn = None

    conn = psycopg2.connect(
        dbname="AppTest",
        user="postgres",
        password="123456",
        host="localhost",
        port="5432"
    )
    cur = conn.cursor()
    for command in commands:
        cur.execute(command)
    cur.close()
    conn.commit()
    conn.close()

if __name__ == '__main__':
    create_tables()
