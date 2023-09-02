-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `LittleLemonDB` ;

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonDB` DEFAULT CHARACTER SET utf8 ;
USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`Customers` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Customers` (
  `id` INT NOT NULL,
  `fullName` VARCHAR(255) NULL,
  `contactNumber` VARCHAR(10) NULL,
  `email` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Delivery`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`Delivery` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Delivery` (
  `id` INT NOT NULL,
  `status` VARCHAR(45) NULL,
  `date` DATE NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`Orders` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Orders` (
  `id` INT NOT NULL,
  `quantity` INT NULL,
  `totalCost` DECIMAL NULL,
  `deliveryId` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_Orders_Delivery1`
    FOREIGN KEY (`deliveryId`)
    REFERENCES `LittleLemonDB`.`Delivery` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Staff`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`Staff` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Staff` (
  `id` INT NOT NULL,
  `fullName` VARCHAR(255) NULL,
  `role` VARCHAR(45) NULL,
  `salary` DECIMAL NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Bookings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`Bookings` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Bookings` (
  `id` INT NOT NULL,
  `date` DATE NULL,
  `tableNumber` INT NULL,
  `customerId` INT NULL,
  `orderId` INT NULL,
  `staffId` INT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_Bookings_Customers`
    FOREIGN KEY (`customerId`)
    REFERENCES `LittleLemonDB`.`Customers` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Bookings_Orders1`
    FOREIGN KEY (`orderId`)
    REFERENCES `LittleLemonDB`.`Orders` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Bookings_Staff1`
    FOREIGN KEY (`staffId`)
    REFERENCES `LittleLemonDB`.`Staff` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`MenuItems`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`MenuItems` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`MenuItems` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `cuisine` VARCHAR(45) NULL,
  `category` ENUM('Starter', 'Drink', 'Dessert', 'Main') NOT NULL,
  `price` DECIMAL NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`OrdersMenu`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`OrdersMenu` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`OrdersMenu` (
  `orderId` INT NOT NULL,
  `menuId` INT NOT NULL,
  PRIMARY KEY (`menuId`, `orderId`),
  CONSTRAINT `fk_OrdersMenu_Orders1`
    FOREIGN KEY (`orderId`)
    REFERENCES `LittleLemonDB`.`Orders` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_OrdersMenu_MenuItems1`
    FOREIGN KEY (`menuId`)
    REFERENCES `LittleLemonDB`.`MenuItems` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
