CREATE OR REPLACE VIEW OrdersView AS
    SELECT OrderID,
        FullName, ContactNumber, Email,
        MenuName, Cuisine,
        CourserName, StartName, DessertName
    FROM Orders
    INNER JOIN Customers
    USING (CustomerID)
    INNER JOIN Menus
    USING (MenuID)
    INNER JOIN MenusMenuItems
    USING (MenuID)
    INNER JOIN MenuItems
    USING (MenuItemsID);
