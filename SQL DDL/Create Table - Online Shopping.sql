USE OnlineShopping;

-- Address Table
CREATE TABLE IF NOT EXISTS Address (
    AddressID INT AUTO_INCREMENT PRIMARY KEY,
    Number VARCHAR(255),
    Street VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(255),
    Zipcode VARCHAR(20)
);

-- Customer Table
CREATE TABLE IF NOT EXISTS Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Email VARCHAR(255),
    Phone VARCHAR(20),
    AddressID INT,
    ClubPoints FLOAT,
    Password VARCHAR(255),
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);

-- Status Table
CREATE TABLE IF NOT EXISTS Status (
    StatusID INT AUTO_INCREMENT PRIMARY KEY,
    StatusName VARCHAR(255)
);

-- Seller Table
CREATE TABLE IF NOT EXISTS Seller (
    SellerID INT AUTO_INCREMENT PRIMARY KEY,
    SellerName VARCHAR(255)
);

-- PaymentStatus Table
CREATE TABLE IF NOT EXISTS PaymentStatus (
	PaymentStatusID INT PRIMARY KEY,
	StatusName VARCHAR(255)
);

-- Product Table
CREATE TABLE IF NOT EXISTS Product (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255),
    Description TEXT,
    Price DECIMAL(10, 2),
    SellerID INT,
    Discount INT,
    FOREIGN KEY (SellerID) REFERENCES Seller(SellerID)
);

-- Category Table
CREATE TABLE IF NOT EXISTS Category (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(255)
);

-- ProductCategory Table
CREATE TABLE IF NOT EXISTS ProductCategory (
    ProductCategoryID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    CategoryID INT,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

-- ProductReview Table
CREATE TABLE IF NOT EXISTS ProductReview (
    ProductReviewID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255),
    Rating INT,
    Content TEXT,
    ProductID INT,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- ShoppingCart Table
CREATE TABLE IF NOT EXISTS ShoppingCart (
    ShoppingSessionID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- CartProduct Table
CREATE TABLE IF NOT EXISTS CartProduct (
    CartProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    ShoppingSessionID INT,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (ShoppingSessionID) REFERENCES ShoppingCart(ShoppingSessionID)
);

-- PaymentType Table
CREATE TABLE IF NOT EXISTS PaymentType (
    TypeID INT AUTO_INCREMENT PRIMARY KEY,
    TypeName VARCHAR(255)
);

-- Payment Table
CREATE TABLE IF NOT EXISTS Payment (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    TypeID INT,
    CardholderName VARCHAR(255),
    CardNumber VARCHAR(255),
    SecurityNumber VARCHAR(255),
    Zipcode VARCHAR(20),
    PaymentStatusID INT,
    FOREIGN KEY (TypeID) REFERENCES PaymentType(TypeID),
    FOREIGN KEY (PaymentStatusID) REFERENCES PaymentStatus(PaymentStatusID)
);

-- Shipment Table
CREATE TABLE IF NOT EXISTS Shipment (
    ShipmentID INT AUTO_INCREMENT PRIMARY KEY,
    ShipmentDate DATETIME,
    TrackingNumber VARCHAR(255),
    AddressID INT,
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);

-- Order Table
CREATE TABLE IF NOT EXISTS `Order` (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME,
    StatusID INT,
    PaymentID INT,
    ShipmentID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (StatusID) REFERENCES Status(StatusID),
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID),
    FOREIGN KEY (ShipmentID) REFERENCES Shipment(ShipmentID)
);

-- OrderItem Table
CREATE TABLE IF NOT EXISTS OrderItem (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    OperationType VARCHAR(255),
    OperationDate DATETIME,
    Details VARCHAR(255),
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer( CustomerID)
);

-- OperationLog Table
CREATE TABLE IF NOT EXISTS OperationLog (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ShoppingSessionID INT,
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID),
    FOREIGN KEY (ShoppingSessionID) REFERENCES ShoppingSession(ShoppingSessionID)
);