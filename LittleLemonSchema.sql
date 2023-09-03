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

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonDB` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema littlelemondb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema littlelemondb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `littlelemondb` ;
USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- Table `Customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Customers` ;

CREATE TABLE IF NOT EXISTS `Customers` (
  `CustomerID` VARCHAR(45) NOT NULL,
  `CustomerName` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`CustomerID`))
ENGINE = InnoDB
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
  `CustomerID` VARCHAR(45) NULL DEFAULT NULL,
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
USE `littlelemondb` ;

-- -----------------------------------------------------
-- View `ordersview`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ordersview` ;
USE `littlelemondb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`tusharjain`@`localhost` SQL SECURITY DEFINER VIEW `ordersview` AS select `orders`.`OrderID` AS `OrderID`,`orders`.`OrderID_Not_Key` AS `OrderID_Not_Key`,`orders`.`RowNumber` AS `RowNumber`,`orders`.`OrderDate` AS `OrderDate`,`orders`.`CustomerID` AS `CustomerID`,`customers`.`CustomerName` AS `CustomerName`,`orders`.`Quantity` AS `Quantity`,`orders`.`TotalCost` AS `TotalCost`,`menus`.`Cuisine` AS `Cuisine`,`menumenuitems`.`MenuID` AS `MenuID` from ((((`orders` join `customers` on((`orders`.`CustomerID` = `customers`.`CustomerID`))) join `menumenuitems` on((`orders`.`MenuMenuItemsID` = `menumenuitems`.`MenuMenuItemsID`))) join `menus` on((`menumenuitems`.`MenuID` = `menus`.`MenuID`))) join `menuitems` on((`menumenuitems`.`MenuItemsID` = `menuitems`.`MenuItemsID`))) order by `orders`.`RowNumber`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
