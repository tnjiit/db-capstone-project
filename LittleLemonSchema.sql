-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `LittleLemonDB` ;

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonDB` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema littlelemondb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `littlelemondb` ;

-- -----------------------------------------------------
-- Schema littlelemondb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `littlelemondb` ;
USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- Table `Bookings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Bookings` ;

CREATE TABLE IF NOT EXISTS `Bookings` (
  `BookingID` INT(11) NOT NULL AUTO_INCREMENT,
  `BookingDate` DATE NULL DEFAULT NULL,
  `TableNumber` INT(11) NULL DEFAULT NULL,
  `CustomerID` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`BookingID`))
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Customers` ;

CREATE TABLE IF NOT EXISTS `Customers` (
  `CustomerID` INT(11) NOT NULL AUTO_INCREMENT,
  `CustomerName` VARCHAR(255) NULL DEFAULT NULL,
  `ContactNumber` VARCHAR(11) NULL DEFAULT NULL,
  PRIMARY KEY (`CustomerID`))
ENGINE = InnoDB
AUTO_INCREMENT = 1001
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `MenuItems`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MenuItems` ;

CREATE TABLE IF NOT EXISTS `MenuItems` (
  `MenuItemsID` INT(11) NOT NULL AUTO_INCREMENT,
  `MainCourse` VARCHAR(45) NULL DEFAULT NULL,
  `Starter` VARCHAR(45) NULL DEFAULT NULL,
  `Dessert` VARCHAR(45) NULL DEFAULT NULL,
  `Drinks` VARCHAR(45) NULL DEFAULT NULL,
  `SideDish` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`MenuItemsID`))
ENGINE = InnoDB
AUTO_INCREMENT = 37
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Menus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Menus` ;

CREATE TABLE IF NOT EXISTS `Menus` (
  `MenuID` INT(11) NOT NULL AUTO_INCREMENT,
  `Cuisine` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`MenuID`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `MenuMenuItems`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MenuMenuItems` ;

CREATE TABLE IF NOT EXISTS `MenuMenuItems` (
  `MenuMenuItemsID` INT(11) NOT NULL AUTO_INCREMENT,
  `MenuID` INT(11) NULL DEFAULT NULL,
  `MenuItemsID` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`MenuMenuItemsID`),
  CONSTRAINT `c_fk_mmitems_menuitems`
    FOREIGN KEY (`MenuItemsID`)
    REFERENCES `MenuItems` (`MenuItemsID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `c_fk_mmitems_menus`
    FOREIGN KEY (`MenuID`)
    REFERENCES `Menus` (`MenuID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 73
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Orders` ;

CREATE TABLE IF NOT EXISTS `Orders` (
  `OrderID` INT(11) NOT NULL AUTO_INCREMENT,
  `OrderID_Not_Key` VARCHAR(45) NULL DEFAULT NULL,
  `RowNumber` INT(11) NULL DEFAULT NULL,
  `OrderDate` DATE NULL DEFAULT NULL,
  `Quantity` INT(11) NULL DEFAULT NULL,
  `TotalCost` DECIMAL(10,0) NULL DEFAULT NULL,
  `CustomerID` INT(11) NULL DEFAULT NULL,
  `MenuMenuItemsID` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`OrderID`),
  CONSTRAINT `c_fk_orders_customers`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `Customers` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `c_fk_orders_mmitems`
    FOREIGN KEY (`MenuMenuItemsID`)
    REFERENCES `MenuMenuItems` (`MenuMenuItemsID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 21001
DEFAULT CHARACTER SET = utf8;

USE `littlelemondb` ;
USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- procedure AddBooking
-- -----------------------------------------------------

USE `LittleLemonDB`;
DROP procedure IF EXISTS `AddBooking`;

DELIMITER $$
USE `LittleLemonDB`$$
CREATE DEFINER=`tusharjain`@`localhost` PROCEDURE `AddBooking`(IN inBookingID INT, IN inCustomerID INT, IN inTableNumber INT, IN inBookingDate DATE)
BEGIN
	INSERT INTO Bookings (BookingID, BookingDate, TableNumber, CustomerID) VALUES
    (inBookingID, inBookingDate, inTableNumber, inCustomerID);
    SELECT "New booking added" AS Confirmation;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure AddValidBooking
-- -----------------------------------------------------

USE `LittleLemonDB`;
DROP procedure IF EXISTS `AddValidBooking`;

DELIMITER $$
USE `LittleLemonDB`$$
CREATE DEFINER=`tusharjain`@`localhost` PROCEDURE `AddValidBooking`(IN inBookingDate DATE, IN inTableNumber INT)
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CancelBooking
-- -----------------------------------------------------

USE `LittleLemonDB`;
DROP procedure IF EXISTS `CancelBooking`;

DELIMITER $$
USE `LittleLemonDB`$$
CREATE DEFINER=`tusharjain`@`localhost` PROCEDURE `CancelBooking`(IN inBookingID INT)
BEGIN
	DELETE FROM Bookings
    WHERE BookingID = inBookingID;
    SELECT CONCAT("Booking ", inBookingID, " cancelled");
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CancelOrder
-- -----------------------------------------------------

USE `LittleLemonDB`;
DROP procedure IF EXISTS `CancelOrder`;

DELIMITER $$
USE `LittleLemonDB`$$
CREATE DEFINER=`tusharjain`@`localhost` PROCEDURE `CancelOrder`(IN inOrderID INT)
BEGIN
	DELETE FROM Orders WHERE OrderID=inOrderID;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CheckBooking
-- -----------------------------------------------------

USE `LittleLemonDB`;
DROP procedure IF EXISTS `CheckBooking`;

DELIMITER $$
USE `LittleLemonDB`$$
CREATE DEFINER=`tusharjain`@`localhost` PROCEDURE `CheckBooking`(IN inBookingDate DATE, IN inTableNumber INT)
BEGIN
	SELECT CONCAT("Table ", inTableNumber, " is already booked") AS "Booking Status"
    FROM Bookings
    WHERE BookingDate = inBookingDate AND TableNumber = inTableNumber;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetMaxQuantity
-- -----------------------------------------------------

USE `LittleLemonDB`;
DROP procedure IF EXISTS `GetMaxQuantity`;

DELIMITER $$
USE `LittleLemonDB`$$
CREATE DEFINER=`tusharjain`@`localhost` PROCEDURE `GetMaxQuantity`()
BEGIN
	SELECT MAX(Quantity)
    FROM Orders;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UpdateBooking
-- -----------------------------------------------------

USE `LittleLemonDB`;
DROP procedure IF EXISTS `UpdateBooking`;

DELIMITER $$
USE `LittleLemonDB`$$
CREATE DEFINER=`tusharjain`@`localhost` PROCEDURE `UpdateBooking`(IN inBookingID INT, IN inBookingDate DATE)
BEGIN
	UPDATE Bookings
    SET BookingDate = inBookingDate
    WHERE BookingID = inBookingID;
    SELECT CONCAT("Booking ",inBookingID," updated");
END$$

DELIMITER ;
USE `littlelemondb` ;

-- -----------------------------------------------------
-- View `ordersview`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ordersview` ;
USE `littlelemondb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`tusharjain`@`localhost` SQL SECURITY DEFINER VIEW `ordersview` AS select `orders`.`OrderID` AS `OrderID`,`orders`.`Quantity` AS `Quantity`,`orders`.`TotalCost` AS `Cost` from `orders` where (`orders`.`Quantity` > 2);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
