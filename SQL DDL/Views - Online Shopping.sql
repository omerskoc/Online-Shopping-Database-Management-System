USE OnlineShopping;

CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `cancelledorders` AS
SELECT
    `O`.`OrderID` AS `OrderID`,
    CONCAT(`C`.`FirstName`, ' ', `C`.`LastName`) AS `CustomerName`,
    `O`.`OrderDate` AS `OrderDate`
FROM
    `order` `O`
    JOIN `customer` `C` ON (`O`.`CustomerID` = `C`.`CustomerID`)
WHERE
    `O`.`StatusID` = (SELECT `status`.`StatusID` FROM `status` WHERE `status`.`StatusName` = 'Cancelled');



CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `deliveredorders` AS
SELECT
    `O`.`OrderID` AS `OrderID`,
    CONCAT(`C`.`FirstName`, ' ', `C`.`LastName`) AS `CustomerName`,
    `O`.`OrderDate` AS `OrderDate`
FROM
    `order` `O`
    JOIN `customer` `C` ON (`O`.`CustomerID` = `C`.`CustomerID`)
WHERE
    `O`.`StatusID` = (SELECT `status`.`StatusID` FROM `status` WHERE `status`.`StatusName` = 'Delivered');


CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `out_for_deliveryorders` AS
SELECT
    `O`.`OrderID` AS `OrderID`,
    CONCAT(`C`.`FirstName`, ' ', `C`.`LastName`) AS `CustomerName`,
    `O`.`OrderDate` AS `OrderDate`
FROM
    `order` `O`
    JOIN `customer` `C` ON (`O`.`CustomerID` = `C`.`CustomerID`)
WHERE
    `O`.`StatusID` = (SELECT `status`.`StatusID` FROM `status` WHERE `status`.`StatusName` = 'Out for Delivery');


CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `processingorders` AS
SELECT
    `O`.`OrderID` AS `OrderID`,
    CONCAT(`C`.`FirstName`, ' ', `C`.`LastName`) AS `CustomerName`,
    `O`.`OrderDate` AS `OrderDate`
FROM
    `order` `O`
    JOIN `customer` `C` ON (`O`.`CustomerID` = `C`.`CustomerID`)
WHERE
    `O`.`StatusID` = (SELECT `status`.`StatusID` FROM `status` WHERE `status`.`StatusName` = 'Processing');



CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `shippedorders` AS
SELECT
    `O`.`OrderID` AS `OrderID`,
    CONCAT(`C`.`FirstName`, ' ', `C`.`LastName`) AS `CustomerName`,
    `O`.`OrderDate` AS `OrderDate`
FROM
    `order` `O`
    JOIN `customer` `C` ON (`O`.`CustomerID` = `C`.`CustomerID`)
WHERE
    `O`.`StatusID` = (SELECT `status`.`StatusID` FROM `status` WHERE `status`.`StatusName` = 'Shipped');
