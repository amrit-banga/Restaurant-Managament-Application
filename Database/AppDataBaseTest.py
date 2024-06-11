import psycopg2
from psycopg2 import sql

def create_tables():
    commands = [
        """
        CREATE TABLE Users (
            user_id SERIAL PRIMARY KEY,
            username VARCHAR(50) NOT NULL,
            password VARCHAR(50) NOT NULL,
            email VARCHAR(100) NOT NULL,
            phone_number VARCHAR(20) NOT NULL
        )
        """,
        """
        CREATE TABLE UserVerification (
            verification_id SERIAL PRIMARY KEY,
            user_id INTEGER NOT NULL,
            verification_code VARCHAR(50) NOT NULL,
            expiration_time TIMESTAMP NOT NULL,
            is_verified BOOLEAN NOT NULL,
            FOREIGN KEY (user_id) REFERENCES Users (user_id)
        )
        """,
        """
        CREATE TABLE Categories (
            category_id SERIAL PRIMARY KEY,
            category_name VARCHAR(100) NOT NULL
        )
        """,
        """
        CREATE TABLE Items (
            item_id SERIAL PRIMARY KEY,
            item_name VARCHAR(100) NOT NULL,
            category_id INTEGER NOT NULL,
            quantity INTEGER NOT NULL,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (category_id) REFERENCES Categories (category_id)
        )
        """,
        """
        CREATE TABLE ItemEntries (
            entry_id SERIAL PRIMARY KEY,
            item_id INTEGER NOT NULL,
            entry_date TIMESTAMP NOT NULL,
            shelf_life_days INTEGER NOT NULL,
            expiry_date TIMESTAMP NOT NULL,
            quantity INTEGER NOT NULL,
            FOREIGN KEY (item_id) REFERENCES Items (item_id)
        )
        """,
        """
        CREATE TABLE Purchases (
            purchase_id SERIAL PRIMARY KEY,
            item_id INTEGER NOT NULL,
            purchase_date TIMESTAMP NOT NULL,
            purchase_cost DECIMAL(10, 2) NOT NULL,
            quantity INTEGER NOT NULL,
            FOREIGN KEY (item_id) REFERENCES Items (item_id)
        )
        """,
        """
        CREATE TABLE Losses (
            loss_id SERIAL PRIMARY KEY,
            item_id INTEGER NOT NULL,
            loss_date TIMESTAMP NOT NULL,
            FOREIGN KEY (item_id) REFERENCES Items (item_id)
        )
        """,
        """
        CREATE TABLE SyncLogs (
            sync_id SERIAL PRIMARY KEY,
            sync_time TIMESTAMP NOT NULL,
            sync_status VARCHAR(50) NOT NULL,
            user_id INTEGER NOT NULL,
            FOREIGN KEY (user_id) REFERENCES Users (user_id)
        )
        """,
        """
        CREATE TABLE ConflictLogs (
            conflict_id SERIAL PRIMARY KEY,
            data_id INTEGER NOT NULL,
            user_id INTEGER NOT NULL,
            conflict_time TIMESTAMP NOT NULL,
            resolution_strategy VARCHAR(100) NOT NULL,
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
