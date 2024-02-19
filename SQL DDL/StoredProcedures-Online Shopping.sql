USE OnlineShopping;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllProducts`()
BEGIN
    SELECT ProductID, Name, Description, Price
    FROM Product;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllProductsWithReviews`()
BEGIN
    SELECT 
        P.ProductID, 
        P.Name, 
        P.Description, 
        P.Price,
        PR.Title AS ReviewTitle,
        PR.Rating,
        PR.Content AS ReviewContent
    FROM Product P
    LEFT JOIN ProductReview PR ON P.ProductID = PR.ProductID;
END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllProductsWithSellers`()
BEGIN
    SELECT S.SellerName, P.ProductID, P.Name, P.Description, P.Price
    FROM Product P
    JOIN Seller S ON P.SellerID = S.SellerID;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAverageRatingPerProduct`()
BEGIN
    SELECT 
        P.ProductID, 
        P.Name, 
        COALESCE(AVG(PR.Rating), 0) AS AverageRating
    FROM Product P
    LEFT JOIN ProductReview PR ON P.ProductID = PR.ProductID
    GROUP BY P.ProductID, P.Name;
END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCustomerDetailsByEmail`(IN customerEmail VARCHAR(255))
BEGIN
    SELECT 
        C.CustomerID, C.FirstName, C.LastName, C.Email, C.Phone,
        A.Number, A.Street, A.City, A.State, A.Zipcode
    FROM Customer C
    JOIN Address A ON C.AddressID = A.AddressID
    WHERE C.Email = customerEmail;
END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCustomerDetailsByTrackingNumber`(IN trackingNumber VARCHAR(255))
BEGIN
    SELECT 
        C.FirstName, C.LastName, 
        A.Number, A.Street, A.City, A.State, A.Zipcode, 
        S.ShipmentDate
    FROM Shipment S
    JOIN `Order` O ON S.ShipmentID = O.ShipmentID
    JOIN Customer C ON O.CustomerID = C.CustomerID
    JOIN Address A ON C.AddressID = A.AddressID
    WHERE S.TrackingNumber = trackingNumber;
END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCustomerPurchasesByEmail`(IN customerEmail VARCHAR(255))
BEGIN
    SELECT 
        O.OrderID, 
        O.OrderDate, 
        SUM(P.Price * CP.Quantity) as TotalAmount
    FROM Customer C
    JOIN `Order` O ON C.CustomerID = O.CustomerID
    JOIN OrderItem OI ON O.OrderID = OI.OrderID
    JOIN CartProduct CP ON OI.CartProductID = CP.CartProductID
    JOIN Product P ON CP.ProductID = P.ProductID
    WHERE C.Email = customerEmail
    GROUP BY O.OrderID, O.OrderDate;
END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrderCountByPaymentStatus`()
BEGIN
    SELECT PS.StatusName, COUNT(*) AS OrderCount
    FROM `Order` O
    JOIN Payment P ON O.PaymentID = P.PaymentID
    JOIN PaymentStatus PS ON P.PaymentStatusID = PS.PaymentStatusID
    GROUP BY PS.StatusName;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrderCountByPaymentType`()
BEGIN
    SELECT PT.TypeName, COUNT(*) AS OrderCount
    FROM `Order` O
    JOIN Payment P ON O.PaymentID = P.PaymentID
    JOIN PaymentType PT ON P.TypeID = PT.TypeID
    GROUP BY PT.TypeName;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrderCountByStatus`()
BEGIN
    SELECT S.StatusName, COUNT(*) AS OrderCount
    FROM `Order` O
    JOIN Status S ON O.StatusID = S.StatusID
    GROUP BY S.StatusName;
END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrdersDetailByEmail`(IN customerEmail VARCHAR(255))
BEGIN
    SELECT 
        O.OrderID, 
        O.OrderDate, 
        ST.StatusName AS OrderStatus,
        PT.TypeName AS PaymentType,
        PS.StatusName AS PaymentStatus,
        SH.TrackingNumber
    FROM `Order` O
    JOIN Customer C ON O.CustomerID = C.CustomerID
    LEFT JOIN Status ST ON O.StatusID = ST.StatusID
    LEFT JOIN Payment P ON O.PaymentID = P.PaymentID
    LEFT JOIN PaymentType PT ON P.TypeID = PT.TypeID
    LEFT JOIN PaymentStatus PS ON P.PaymentStatusID = PS.PaymentStatusID
    LEFT JOIN Shipment SH ON O.ShipmentID = SH.ShipmentID
    WHERE C.Email = customerEmail;
END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetProductCountByCategory`()
BEGIN
    SELECT C.CategoryName, COUNT(PC.ProductID) as ProductCount
    FROM Category C
    LEFT JOIN ProductCategory PC ON C.CategoryID = PC.CategoryID
    LEFT JOIN Product P ON PC.ProductID = P.ProductID
    GROUP BY C.CategoryName;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetProductCountBySeller`()
BEGIN
    SELECT S.SellerName, COUNT(P.ProductID) AS ProductCount
    FROM Seller S
    LEFT JOIN Product P ON S.SellerID = P.SellerID
    GROUP BY S.SellerName;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetProductsByCategory`(IN categoryName VARCHAR(255))
BEGIN
    SELECT P.ProductID, P.Name, P.Description, P.Price
    FROM Product P
    INNER JOIN ProductCategory PC ON P.ProductID = PC.ProductID
    INNER JOIN Category C ON PC.CategoryID = C.CategoryID
    WHERE C.CategoryName = categoryName;
END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetProductsBySeller`(IN sellerName VARCHAR(255))
BEGIN
    SELECT P.ProductID, P.Name, P.Description, P.Price
    FROM Product P
    JOIN Seller S ON P.SellerID = S.SellerID
    WHERE S.SellerName = sellerName;
END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetSellersBySales`()
BEGIN
    SELECT 
        S.SellerName, 
        IFNULL(SUM(CP.Quantity), 0) as TotalSales
    FROM Seller S
    LEFT JOIN Product P ON S.SellerID = P.SellerID
    LEFT JOIN CARTPRODUCT CP ON P.ProductID = CP.ProductID
    GROUP BY S.SellerID
    ORDER BY TotalSales DESC;
END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTotalSalesByProductName2`(IN productName VARCHAR(255))
BEGIN
    SELECT P.Name, IFNULL(SUM(CP.Quantity), 0) as TotalSales
    FROM Product P
    LEFT JOIN CartProduct CP ON P.ProductID = CP.ProductID
    LEFT JOIN OrderItem OI ON CP.CartProductID = OI.CartProductID
    WHERE P.Name = productName
    GROUP BY P.Name;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `setDiscountOnAllProducts`(IN Amnt DECIMAL(10, 2))
BEGIN
    -- Calculate the discount amount
    DECLARE discount DECIMAL(10, 2);
    SET discount = (Amnt / 100);

    -- Update the price of all products with the discount
    UPDATE Product
    SET Price = Price - (Price * discount),
	    Discount = Amnt;

    -- Commit the transaction
    COMMIT;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalShipmentsByState`(IN stateName VARCHAR(255))
BEGIN
    SELECT COUNT(*) AS TotalShipments
    FROM Shipment S
    JOIN Address A ON S.AddressID = A.AddressID
    WHERE A.State = stateName;
END$$
DELIMITER ;


