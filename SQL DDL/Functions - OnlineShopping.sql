USE OnlineShopping;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `GetCategoryCountForProduct`(product_name VARCHAR(255)) RETURNS int
BEGIN
    DECLARE category_count INT;

    -- Ürün adına ait kategori sayısını hesapla
    SELECT COUNT(DISTINCT PC.CategoryID)
    INTO category_count
    FROM Product P
    LEFT JOIN ProductCategory PC ON P.ProductID = PC.ProductID
    WHERE P.Name = product_name;

    RETURN category_count;
END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `GetReviewCountForProduct`(productName VARCHAR(255)) RETURNS int
BEGIN
    DECLARE reviewCount INT;
    
    -- Ürün adına göre inceleme sayısını hesapla
    SELECT COUNT(*) INTO reviewCount
    FROM Product P
    JOIN ProductReview PR ON P.ProductID = PR.ProductID
    WHERE P.Name = productName;
    
    RETURN reviewCount;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `resetDiscountsOnAllProducts`() RETURNS int
BEGIN
    DECLARE updated_count INT;
    
    -- Reset the discount on all products and update the price
    UPDATE Product
    SET Price = Price / (1 - Discount / 100), Discount = 0;
    
    -- Get the number of products updated
    SELECT COUNT(*) INTO updated_count FROM Product;
    
    -- Return the number of products updated
    RETURN updated_count;
END$$
DELIMITER ;
