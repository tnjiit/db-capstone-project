import pandas as pd
from mysql.connector import MySQLConnection
from contextlib import closing
import os
import pdb
from dotenv import load_dotenv

load_dotenv()
pd.set_option('display.max_rows', 100)
# pd.set_option('display.max_columns', 20)

df = pd.read_excel(
                    'LittleLemon.xlsx', 
                ).rename(
                    columns = {
                        'Order ID': 'OrderID_Not_Key',
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
                        'Row Number': 'RowNumber',
                    }
                )
print(df.columns)

dbconfig = {
    'user': os.getenv('MYSQL_USER'),
    'password': os.getenv('MYSQL_PASSWORD'),
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
        OrderID INT PRIMARY KEY AUTO_INCREMENT,
        OrderID_Not_Key VARCHAR(45),
        RowNumber INT,
        OrderDate DATE,
        Quantity INT,
        TotalCost DECIMAL,
        CustomerID VARCHAR(45),
        MenuMenuItemsID INT
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
        MenuMenuItemsID INT PRIMARY KEY AUTO_INCREMENT,
        MenuID INT,
        MenuItemsID INT
    );
    '''
)

# Foreign Keys
execute_dmc(
    '''
    ALTER TABLE MenuMenuItems
    ADD CONSTRAINT c_fk_mmitems_menus FOREIGN KEY(MenuID) REFERENCES Menus(MenuID) ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT c_fk_mmitems_menuitems FOREIGN KEY(MenuItemsID) REFERENCES MenuItems(MenuItemsID) ON UPDATE CASCADE ON DELETE CASCADE;
    '''
)

execute_dmc(
    '''
    ALTER TABLE Orders
    ADD CONSTRAINT c_fk_orders_mmitems FOREIGN KEY(MenuMenuItemsID) REFERENCES MenuMenuItems(MenuMenuItemsID) ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT c_fk_orders_customers FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID) ON UPDATE CASCADE ON DELETE CASCADE;
    '''
)

# Views
execute_dmc(
    '''
    CREATE OR REPLACE VIEW OrdersView AS
    SELECT OrderID, OrderID_Not_Key, RowNumber, OrderDate, CustomerID, CustomerName, Quantity, TotalCost, Cuisine, MenuID /*, Starter, Dessert, Drinks, SideDish */
    FROM Orders
    INNER JOIN Customers
    USING(CustomerID)
    INNER JOIN MenuMenuItems
    USING (MenuMenuItemsID)
    INNER JOIN Menus
    USING(MenuID) 
    INNER JOIN MenuItems
    USING (MenuItemsID)
    ORDER BY RowNumber ASC;
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
    by=['RowNumber'],
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
        )
    ],
    axis=1
)

data = tuple(
        pd.merge(
            left=df,
            right=execute_dql(
                '''
                SELECT *
                FROM MenuMenuItems
                INNER JOIN Menus
                USING (MenuID)
                INNER JOIN MenuItems
                USING (MenuItemsID);
                '''
            ),
            on=['Cuisine', 'MainCourse', 'Starter', 'Dessert', 'Drinks', 'SideDish'],
            how='inner'
            )[['OrderID_Not_Key', 'RowNumber', 'OrderDate', 'Quantity', 'TotalCost', 'CustomerID', 'MenuMenuItemsID']].astype(
                str
            ).to_numpy()
    )

with closing(MySQLConnection(**dbconfig)) as connection:
    with closing(connection.cursor()) as cursor:
        cursor.executemany(
            '''
            INSERT INTO Orders (OrderID_Not_Key, RowNumber, OrderDate, Quantity, TotalCost, CustomerID, MenuMenuItemsID)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            ''',
            data
        )
        connection.commit()

# df.assign(
#     stringify = lambda df: df[['OrderID_Not_Key', 'RowNumber', 'OrderDate', 'Quantity', 'TotalCost', 'CustomerID', 'MenuID']]).astype(str).agg(','.join, axis=1)
# )['stringify'].transform(
#         lambda x: "(" + ','.join([f'"{y}"' for y in x.split(',')]) + ")"
# )


print(
    execute_dql(
        '''
        SELECT *
        FROM OrdersView;
        '''
    )
)