-- ============================================================
--  SUPERMARKET MANAGEMENT SYSTEM
--  COM 2129 – Database Fundamentals
--  University of Venda
--  MySQL Implementation
-- ============================================================

-- ─────────────────────────────────────────────
--  1. CREATE DATABASE
-- ─────────────────────────────────────────────
DROP DATABASE IF EXISTS supermarket_db;
CREATE DATABASE supermarket_db;


USE supermarket_db;

-- ─────────────────────────────────────────────
--  2. CREATE TABLES (3NF Schema)
-- ─────────────────────────────────────────────

-- 2.1 CUSTOMER
CREATE TABLE Customer (
    CustomerID     INT            NOT NULL AUTO_INCREMENT,
    FirstName      VARCHAR(50)    NOT NULL,
    LastName       VARCHAR(50)    NOT NULL,
    Email          VARCHAR(100)   UNIQUE,
    Phone          VARCHAR(15),
    Address        VARCHAR(255),
    LoyaltyPoints  INT            NOT NULL DEFAULT 0,
    CONSTRAINT pk_customer PRIMARY KEY (CustomerID)
);

-- 2.2 EMPLOYEE
CREATE TABLE Employee (
    EmployeeID  INT            NOT NULL AUTO_INCREMENT,
    FirstName   VARCHAR(50)    NOT NULL,
    LastName    VARCHAR(50)    NOT NULL,
    Role        VARCHAR(50)    NOT NULL,
    Phone       VARCHAR(15),
    HireDate    DATE           NOT NULL,
    Salary      DECIMAL(10,2),
    CONSTRAINT pk_employee PRIMARY KEY (EmployeeID)
);

-- 2.3 SUPPLIER
CREATE TABLE Supplier (
    SupplierID     INT            NOT NULL AUTO_INCREMENT,
    SupplierName   VARCHAR(100)   NOT NULL,
    ContactPerson  VARCHAR(100),
    Phone          VARCHAR(15),
    Email          VARCHAR(100),
    Address        VARCHAR(255),
    CONSTRAINT pk_supplier PRIMARY KEY (SupplierID)
);

-- 2.4 PRODUCT
CREATE TABLE Product (
    ProductID      INT            NOT NULL AUTO_INCREMENT,
    ProductName    VARCHAR(100)   NOT NULL,
    Category       VARCHAR(50),
    Price          DECIMAL(10,2)  NOT NULL,
    StockQuantity  INT            NOT NULL DEFAULT 0,
    ReorderLevel   INT            NOT NULL DEFAULT 10,
    CONSTRAINT pk_product PRIMARY KEY (ProductID),
    CONSTRAINT chk_price  CHECK (Price >= 0),
    CONSTRAINT chk_stock  CHECK (StockQuantity >= 0)
);

-- 2.5 TRANSACTION
CREATE TABLE Transaction (
    TransactionID    INT            NOT NULL AUTO_INCREMENT,
    CustomerID       INT            NOT NULL,
    EmployeeID       INT            NOT NULL,
    TransactionDate  DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    TotalAmount      DECIMAL(10,2)  NOT NULL,
    PaymentMethod    VARCHAR(30)    NOT NULL,
    CONSTRAINT pk_transaction   PRIMARY KEY (TransactionID),
    CONSTRAINT fk_trans_cust    FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_trans_emp     FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_payment      CHECK (PaymentMethod IN ('Cash','Card','Mobile Payment'))
);

-- 2.6 TRANSACTION_ITEM
CREATE TABLE Transaction_Item (
    ItemID         INT            NOT NULL AUTO_INCREMENT,
    TransactionID  INT            NOT NULL,
    ProductID      INT            NOT NULL,
    Quantity       INT            NOT NULL,
    UnitPrice      DECIMAL(10,2)  NOT NULL,
    Subtotal       DECIMAL(10,2)  NOT NULL,
    CONSTRAINT pk_txitem        PRIMARY KEY (ItemID),
    CONSTRAINT fk_item_trans    FOREIGN KEY (TransactionID)
        REFERENCES Transaction(TransactionID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_item_prod     FOREIGN KEY (ProductID)
        REFERENCES Product(ProductID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_qty          CHECK (Quantity > 0)
);

-- 2.7 SUPPLY
CREATE TABLE Supply (
    SupplyID          INT            NOT NULL AUTO_INCREMENT,
    SupplierID        INT            NOT NULL,
    ProductID         INT            NOT NULL,
    SupplyDate        DATE           NOT NULL,
    QuantitySupplied  INT            NOT NULL,
    UnitCost          DECIMAL(10,2)  NOT NULL,
    CONSTRAINT pk_supply        PRIMARY KEY (SupplyID),
    CONSTRAINT fk_supply_supp   FOREIGN KEY (SupplierID)
        REFERENCES Supplier(SupplierID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_supply_prod   FOREIGN KEY (ProductID)
        REFERENCES Product(ProductID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_qty_supplied CHECK (QuantitySupplied > 0)
);


-- ─────────────────────────────────────────────
--  3. INSERT SAMPLE DATA
-- ─────────────────────────────────────────────

-- 3.1 Customers (10 records)
INSERT INTO Customer (FirstName, LastName, Email, Phone, Address, LoyaltyPoints) VALUES
('Mpho', 'Tshidino', 'mpho.tshidino@gmail.com', '0712345678', 'Thohoyandou', 120),
('Tshepo', 'Sepatake', 'tshepo173@gmail.com', '0723456789', 'Polokwane', 85),
('Sekhwama', 'Mushoni', 'moshonisekhwama@gmail.com', '0734567890', 'Giyani', 200),
('Maphaha', 'Mulisa', 'mulisamaphaha83@gmail.com', '0745678901', 'Louis Trichardt', 50),
('Muthelo', 'Zwovhonala', 'muthelozwovhonala6@gmail.com', '0756789012', 'Sibasa', 310),
('Mabushe', 'Ngelekanyo', 'ngelemabushe@gmail.com', '0767890123', 'Makhado', 0),
('Raphunga', 'Tshianeo', 'raphungachia@gmail.com', '0778901234', 'Musina', 175),
('Ndou', 'Malakia', 'ndoumalakia14@gmail.com', '0789012345', 'Thohoyandou', 90),
('Lerato', 'Mabaso', 'lerato.mabaso@email.com', '0791122334', 'Pretoria', 60),
('Kabelo', 'Ndlovu', 'kabelo.ndlovu@email.com', '0812233445', 'Johannesburg', 140);

-- 3.2 Employees (6 records)
INSERT INTO Employee (FirstName, LastName, Role, Phone, HireDate, Salary) VALUES
('Brian', 'Mulaudzi', 'Store Manager',     '0711111111', '2020-02-10', 36000.00),
('Lindani', 'Nkuna',  'Cashier',           '0722222222', '2021-07-15', 12500.00),
('Ayanda',  'Khumalo','Cashier',           '0733333333', '2022-04-12', 12500.00),
('Tendani', 'Netshifhefhe','Stock Controller','0744444444', '2021-10-05', 14500.00),
('Zinhle',  'Mokoena','Cashier',           '0755555555', '2023-02-01', 13000.00),
('Collins', 'Mudau',  'Inventory Manager', '0766666666', '2019-08-20', 19000.00);

-- 3.3 Suppliers (4 records)
INSERT INTO Supplier (SupplierName, ContactPerson, Phone, Email, Address) VALUES
('Green Valley Farms',     'Samuel Ndlovu',  '0112233001', 'contact@greenvalley.co.za',   'Johannesburg'),
('BlueSky Beverages',      'Aisha Patel',    '0112233002', 'orders@blueskybev.co.za',     'Pretoria'),
('Golden Dairy Suppliers', 'Maria Mokoena',  '0112233003', 'sales@goldendairy.co.za',     'Polokwane'),
('PrimePack Distributors', 'David Naidoo',   '0112233004', 'info@primepack.co.za',        'Durban');

-- 3.4 Products (12 records)
INSERT INTO Product (ProductName, Category, Price, StockQuantity, ReorderLevel) VALUES
('Brown Bread 700g',        'Bakery',     15.99,  70,  20),
('Low Fat Milk 2L',         'Dairy',      30.50,  55,  15),
('Mozzarella Cheese 400g',  'Dairy',      59.99,  35,  10),
('Pepsi 2L',                'Beverages',  24.00,  95,  25),
('Apple Juice 1L',          'Beverages',  23.99,  65,  20),
('Maize Meal 5kg',          'Dry Goods',  70.00,  45,  10),
('Cooking Oil 2L',          'Dry Goods',  52.99,  40,  10),
('Beef Steak 1kg',          'Meat',       95.99,  30,   8),
('Bananas 1kg',             'Produce',    18.99,  85,  20),
('Corn Chips 150g',         'Snacks',     17.49, 105,  30),
('Laundry Detergent 1L',    'Household',  34.99,  60,  15),
('Paper Towels 6-Roll',     'Household',  49.99,  50,  12);

-- 3.5 Transactions (8 records)
INSERT INTO Transaction (CustomerID, EmployeeID, TransactionDate, TotalAmount, PaymentMethod) VALUES
(1,  2, '2026-03-01 09:15:00', 142.47, 'Card'),
(3,  3, '2026-03-01 10:30:00', 230.96, 'Cash'),
(5,  2, '2026-03-02 11:00:00', 89.99,  'Mobile Payment'),
(2,  5, '2026-03-02 14:45:00', 317.44, 'Card'),
(9,  3, '2026-03-03 08:20:00', 157.46, 'Cash'),
(7,  2, '2026-03-04 16:10:00', 204.95, 'Card'),
(4,  5, '2026-03-05 13:00:00', 111.97, 'Mobile Payment'),
(10, 3, '2026-03-06 10:05:00', 273.93, 'Card');

-- 3.6 Transaction Items (18 records)
INSERT INTO Transaction_Item (TransactionID, ProductID, Quantity, UnitPrice, Subtotal) VALUES
(1, 1,  2, 14.99,  29.98),
(1, 2,  1, 32.50,  32.50),
(1, 4,  2, 25.00,  50.00),
(1, 9,  1, 19.99,  19.99),
(2, 6,  1, 65.00,  65.00),
(2, 7,  1, 48.99,  48.99),
(2, 8,  1, 89.99,  89.99),
(2, 10, 1, 18.49,  18.49),
(3, 8,  1, 89.99,  89.99),
(4, 3,  2, 55.99, 111.98),
(4, 5,  3, 22.99,  68.97),
(4, 11, 2, 29.99,  59.98),
(4, 12, 1, 59.99,  59.99),
(5, 1,  3, 14.99,  44.97),
(5, 2,  2, 32.50,  65.00),
(5, 4,  1, 25.00,  25.00),
(6, 6,  2, 65.00, 130.00),
(6, 9,  3, 19.99,  59.97);

-- 3.7 Supply Records (8 records)
INSERT INTO Supply (SupplierID, ProductID, SupplyDate, QuantitySupplied, UnitCost) VALUES
(1, 1,  '2026-02-20', 200, 8.50),
(1, 9,  '2026-02-20', 150, 10.00),
(2, 4,  '2026-02-22', 300, 14.00),
(2, 5,  '2026-02-22', 200, 12.50),
(3, 2,  '2026-02-23', 100, 20.00),
(3, 3,  '2026-02-23',  80, 35.00),
(4, 11, '2026-02-25', 150, 16.00),
(4, 12, '2026-02-25', 100, 38.00);


-- ─────────────────────────────────────────────
--  4. SQL OPERATIONS
-- ─────────────────────────────────────────────

-- ── 4.1 SELECT Queries ──────────────────────

-- Q1: List all customers with their full names and loyalty points
SELECT
    CustomerID,
    CONCAT(FirstName, ' ', LastName) AS FullName,
    Email,
    Phone,
    LoyaltyPoints
FROM Customer
ORDER BY LoyaltyPoints DESC;

-- Q2: List all products that are below or at their reorder level (need restocking)
SELECT
    ProductID,
    ProductName,
    Category,
    StockQuantity,
    ReorderLevel
FROM Product
WHERE StockQuantity <= ReorderLevel
ORDER BY StockQuantity ASC;

-- Q3: Show all transactions with customer name and employee name
SELECT
    t.TransactionID,
    CONCAT(c.FirstName, ' ', c.LastName)  AS CustomerName,
    CONCAT(e.FirstName, ' ', e.LastName)  AS ProcessedBy,
    t.TransactionDate,
    t.TotalAmount,
    t.PaymentMethod
FROM Transaction t
JOIN Customer  c ON t.CustomerID  = c.CustomerID
JOIN Employee  e ON t.EmployeeID  = e.EmployeeID
ORDER BY t.TransactionDate DESC;

-- Q4: Show full receipt detail for Transaction #4
SELECT
    ti.ItemID,
    p.ProductName,
    p.Category,
    ti.Quantity,
    ti.UnitPrice,
    ti.Subtotal
FROM Transaction_Item ti
JOIN Product p ON ti.ProductID = p.ProductID
WHERE ti.TransactionID = 4;

-- Q5: Show each supplier and the products they supply
SELECT
    s.SupplierName,
    p.ProductName,
    p.Category,
    sp.QuantitySupplied,
    sp.UnitCost,
    sp.SupplyDate
FROM Supply sp
JOIN Supplier s ON sp.SupplierID = s.SupplierID
JOIN Product  p ON sp.ProductID  = p.ProductID
ORDER BY s.SupplierName, sp.SupplyDate;


-- ── 4.2 INSERT ──────────────────────────────

-- Add a new customer
INSERT INTO Customer (FirstName, LastName, Email, Phone, Address, LoyaltyPoints)
VALUES ('Azwi', 'Nevhutalu', 'azwi.nevhutalu@email.com', '0812345999', '10 Tshivhase Rd, Thohoyandou', 0);

-- Add a new product
INSERT INTO Product (ProductName, Category, Price, StockQuantity, ReorderLevel)
VALUES ('Maize Meal 5kg', 'Dry Goods', 55.99, 120, 25);

-- Add a new supply record
INSERT INTO Supply (SupplierID, ProductID, SupplyDate, QuantitySupplied, UnitCost)
VALUES (1, 13, '2026-03-10', 150, 30.00);


-- ── 4.3 UPDATE ──────────────────────────────

-- Update a customer's phone number
UPDATE Customer
SET Phone = '0899999999'
WHERE CustomerID = 1;

-- Increase loyalty points after a purchase (add 10 points per R100 spent)
UPDATE Customer
SET LoyaltyPoints = LoyaltyPoints + 14
WHERE CustomerID = 1;

-- Update stock quantity after receiving a new supply delivery
UPDATE Product
SET StockQuantity = StockQuantity + 150
WHERE ProductID = 1;

-- Adjust product price due to cost increase
UPDATE Product
SET Price = 16.99
WHERE ProductID = 1;


-- ── 4.4 DELETE ──────────────────────────────

-- Remove a customer who requested account deletion
-- (Transaction records remain; FK is RESTRICT so customer must have no transactions first)
-- Safe example: delete a customer with no transactions
DELETE FROM Customer
WHERE CustomerID = 6;

-- Remove a supply record that was entered in error
DELETE FROM Supply
WHERE SupplyID = 8;


-- ─────────────────────────────────────────────
--  5. REPORTS (Query-based)
-- ─────────────────────────────────────────────

-- ── REPORT 1: Monthly Sales Summary ─────────
-- Shows total revenue, number of transactions, and average sale
-- per month, ordered from most recent
SELECT
    DATE_FORMAT(TransactionDate, '%Y-%m')   AS SalesMonth,
    COUNT(TransactionID)                     AS TotalTransactions,
    SUM(TotalAmount)                         AS TotalRevenue,
    ROUND(AVG(TotalAmount), 2)               AS AverageSaleValue,
    MAX(TotalAmount)                         AS HighestSale,
    MIN(TotalAmount)                         AS LowestSale
FROM Transaction
GROUP BY DATE_FORMAT(TransactionDate, '%Y-%m')
ORDER BY SalesMonth DESC;


-- ── REPORT 2: Top-Selling Products ──────────
-- Shows products ranked by total units sold and revenue generated
SELECT
    p.ProductID,
    p.ProductName,
    p.Category,
    SUM(ti.Quantity)                          AS TotalUnitsSold,
    SUM(ti.Subtotal)                          AS TotalRevenue,
    p.StockQuantity                           AS CurrentStock
FROM Transaction_Item ti
JOIN Product p ON ti.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category, p.StockQuantity
ORDER BY TotalUnitsSold DESC;


-- ── REPORT 3: Customer Purchase History ─────
-- Full purchase history per customer with total spend
SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName)      AS CustomerName,
    COUNT(DISTINCT t.TransactionID)            AS TotalVisits,
    SUM(t.TotalAmount)                         AS TotalSpent,
    ROUND(AVG(t.TotalAmount), 2)               AS AvgBasketSize,
    MAX(t.TransactionDate)                     AS LastVisit,
    c.LoyaltyPoints
FROM Customer c
LEFT JOIN Transaction t ON c.CustomerID = t.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.LoyaltyPoints
ORDER BY TotalSpent DESC;


-- ── REPORT 4: Supplier Performance Report ───
-- Shows total cost of stock supplied per supplier
SELECT
    s.SupplierID,
    s.SupplierName,
    s.ContactPerson,
    COUNT(sp.SupplyID)                         AS TotalDeliveries,
    SUM(sp.QuantitySupplied)                   AS TotalUnitsSupplied,
    SUM(sp.QuantitySupplied * sp.UnitCost)     AS TotalStockCost,
    MAX(sp.SupplyDate)                         AS LastDelivery
FROM Suppliers
LEFT JOIN Supply sp ON s.SupplierID = sp.SupplierID
GROUP BY s.SupplierID, s.SupplierName, s.ContactPerson
ORDER BY TotalStockCost DESC;


-- ── REPORT 5: Profit Margin per Product ─────
-- Compares selling price vs cost price per unit
SELECT
    p.ProductID,
    p.ProductName,
    p.Category,
    p.Price                                        AS SellingPrice,
    ROUND(AVG(sp.UnitCost), 2)                     AS AvgCostPrice,
    ROUND(p.Price - AVG(sp.UnitCost), 2)           AS GrossMargin,
    ROUND(((p.Price - AVG(sp.UnitCost)) / p.Price) * 100, 1) AS MarginPercent
FROM Product p
JOIN Supply sp ON p.ProductID = sp.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category, p.Price
ORDER BY MarginPercent DESC;

-- ─────────────────────────────────────────────
--  END OF SCRIPT
-- ─────────────────────────────────────────────