USE OnlineShopping;


DELIMITER $$

CREATE TRIGGER calculate_club_points
AFTER INSERT ON CartProduct
FOR EACH ROW
BEGIN
    -- Calculate the product price for the newly inserted row
    SET @product_price = (SELECT Price FROM Product WHERE ProductID = NEW.ProductID);

    -- Calculate the total price for the current CartProduct
    SET @total_price = @product_price * NEW.Quantity;

    -- Get the CustomerID from the ShoppingSession table
    SET @cust_id = (SELECT CustomerID FROM ShoppingCart WHERE ShoppingSessionID = NEW.ShoppingSessionID);

    -- Calculate club points (5% of total price)
    SET @club_points = @total_price * 0.05;

    -- Update the ClubPoints in the corresponding Customer record
    UPDATE Customer
    SET ClubPoints = ClubPoints + @club_points
    WHERE CustomerID = @cust_id;
END$$

DELIMITER ;


DELIMITER $$
CREATE TRIGGER LogOperation
AFTER INSERT ON Customer
FOR EACH ROW
BEGIN
    INSERT INTO OperationLog (OperationType, OperationDate, Details)
    VALUES ('Insert', NOW(), CONCAT('Inserted a new record with ID ', NEW.CustomerID));
END$$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER LogOperationUPDATE
AFTER UPDATE ON Customer
FOR EACH ROW
BEGIN
    INSERT INTO OperationLog (OperationType, OperationDate, Details, CustomerID)
    VALUES ('Update', NOW(), CONCAT('Updated a record with ID ', NEW.CustomerID),NEW.CustomerID);
END$$
DELIMITER ;



