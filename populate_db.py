import pandas as pd
from mysql.connector import MySQLConnection
from contextlib import closing
import os

df = pd.read_excel(
                    'LittleLemon.xlsx', 
                ).rename(
                    columns = {
                        'Order ID': 'OrderID',
                        'Order Date': 'OrderDate',
                        ' Cost': 'TotalCost',
                        'Delivery Date': 'DeliveryDate',
                        'Customer ID': 'CustomerID',
                        'Customer Name': 'CustomerName',
                        'Cuisine Name': 'Cuisine',
                        'Course Name': 'MainCourse',
                        'Starter Name': 'Starter',
                        'Desert Name': 'Dessert',
                        'Drink': 'Drinks',
                        'Sides': 'SideDish',
                    }
                )
print(df.columns)

MenuKeys = ['Starter Name', 'Desert Name', 'Drink', 'Sides']

dbconfig = {
    'user': 'tusharjain',
    'password': os.getenv(key='MYSQL_USER_PASSWORD'),
    'host': 'localhost',
    'port': '3306'
}


def execute_dmc(query, debug=False):
    if debug:
        print(query)
    with closing(
        MySQLConnection(
            **dbconfig    
        )
    ) as connection:
        with closing(
            connection.cursor()
        ) as cursor:
            cursor.execute(query)
            connection.commit()
            
def execute_dql(query, debug=False):
    if debug:
        print(query)
    with closing(
        MySQLConnection(
            **dbconfig
        )
    ) as connection:
        with closing(
            connection.cursor()
        ) as cursor:
            cursor.execute(query)
            return pd.DataFrame(
                data=cursor.fetchall(),
                columns=cursor.column_names
            )


# Create Schema

execute_dmc(
    '''
    DROP DATABASE IF EXISTS LittleLemonDB;
    '''
)

execute_dmc(
    '''
    CREATE DATABASE LittleLemonDB;
    '''
)

dbconfig['database'] = 'LittleLemonDB'

execute_dmc(
    '''
    DROP TABLE IF EXISTS Orders;
    '''
)

execute_dmc(
    '''
    CREATE TABLE Orders (
        OrderID VARCHAR(45) PRIMARY KEY,
        OrderDate DATE,
        Quantity INT,
        TotalCost DECIMAL,
        CustomerID VARCHAR(45),
        MenuID INT
    );
    '''
)

execute_dmc(
    '''
    DROP TABLE IF EXISTS Customers;
    '''
)

execute_dmc(
    '''
    CREATE TABLE Customers (
        CustomerID VARCHAR(45) PRIMARY KEY,
        CustomerName VARCHAR(255)
    );
    '''
)

execute_dmc(
    '''
    DROP TABLE IF EXISTS Menus;
    '''
)

execute_dmc(
    '''
    CREATE TABLE Menus(
        MenuID INT AUTO_INCREMENT PRIMARY KEY,
        Cuisine VARCHAR(45)
    );
    '''
)

execute_dmc(
    '''
    DROP TABLE IF EXISTS MenuItems;
    '''
)

execute_dmc(
    '''
    CREATE TABLE MenuItems (
        MenuItemsID INT AUTO_INCREMENT PRIMARY KEY,
        MainCourse VARCHAR(45),
        Starter VARCHAR(45),
        Dessert VARCHAR(45),
        Drinks VARCHAR(45),
        SideDish VARCHAR(45)
    );
    '''
)

execute_dmc(
    '''
    DROP TABLE IF EXISTS MenuMenuItems;
    '''
)

execute_dmc(
    '''
    CREATE TABLE MenuMenuItems (
        MenuID INT,
        MenuItemsID INT,
        CONSTRAINT c_pk PRIMARY KEY(MenuID, MenuItemsID)
    );
    '''
)

print(
    execute_dql(
        '''
        SHOW TABLES;
        '''
    )
)

# Customers
df.drop_duplicates(
    subset=['CustomerID', 'CustomerName']
).apply(
    lambda x: execute_dmc(
        f"""
                INSERT INTO Customers (CustomerID, CustomerName) VALUES 
                ("{x['CustomerID']}", "{x['CustomerName']}");
                """
    ),
    axis=1
)

# MenuItems
df.drop_duplicates(
    subset=['MainCourse', 'Starter', 'Dessert', 'Drinks', 'SideDish']
).apply(
    lambda x: execute_dmc(
        f'''
        INSERT INTO MenuItems (MainCourse, Starter, Dessert, Drinks, SideDish) VALUES
        ("{x['MainCourse']}", "{x['Starter']}", "{x['Dessert']}", "{x['Drinks']}", "{x['SideDish']}")
        '''
    ),
    axis=1
)

# Menus
df.drop_duplicates(
    subset=['Cuisine']
).apply(
    lambda x: execute_dmc(
        f'''
        INSERT INTO Menus (Cuisine) VALUES
        ("{x['Cuisine']}");
        '''
    ),
    axis=1
)

df = pd.merge(
    left = df,
    right=execute_dql(
        '''
        SELECT *
        FROM MenuItems;
        '''
    ),
    on=['MainCourse', 'Starter', 'Dessert', 'Drinks', 'SideDish'],
    how='inner',   
).sort_values(
    by=['Row Number'],
    ascending=True
)

pd.merge(
    left=df,
    right=execute_dql(
        '''
        SELECT *
        FROM Menus;
        '''
    ),
    on=['Cuisine'],
    how='inner'
).drop_duplicates(
    subset=['MenuID', 'MenuItemsID']
).apply(
    lambda x: [
        execute_dmc(
            f'''
            INSERT INTO MenuMenuItems (MenuID, MenuItemsID) VALUES
            ("{x['MenuID']}", "{x['MenuItemsID']}");
            '''
        ),
        execute_dmc(
            f'''
            INSERT INTO Orders (OrderID, OrderDate, Quantity, TotalCost, CustomerID, MenuID) VALUES
            ("{x['OrderID']}", "{x['OrderDate']}", "{x['Quantity']}", "{x['TotalCost']}", "{x['CustomerID']}", "{x['MenuID']}");
            '''
        )
    ],
    axis=1
)