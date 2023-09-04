-- Active: 1693790973428@@127.0.0.1@3306@LittleLemonDB
USE LittleLemonDB;

PREPARE GetOrderDetail FROM
'SELECT * FROM Orders WHERE OrderID=?;'


SET @var := 1;
EXECUTE GetOrderDetail USING @var;