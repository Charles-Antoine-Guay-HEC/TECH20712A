--Creating the database and tables for LiveListing application--

USE master;
-- Create Database 
CREATE DATABASE LiveListing; 
GO

USE LiveListing; 


-- Create Tables 
CREATE TABLE Country 
( 
CountryID INT IDENTITY(1,1) PRIMARY KEY, 
Country NVARCHAR(100) NOT NULL, 
TaxRate DECIMAL(5,2) NOT NULL 
); 

CREATE TABLE Province 
( 
ProvinceID INT IDENTITY(1,1) PRIMARY KEY, 
Province NVARCHAR(100) NOT NULL, 
TaxRate DECIMAL(5,2) NOT NULL 
); 

CREATE TABLE Address 
( 
AddressID INT IDENTITY(1,1) PRIMARY KEY, 
Street NVARCHAR(150) NOT NULL, 
City NVARCHAR(100) NOT NULL, 
PostalCode NVARCHAR(14) NOT NULL, 
ProvinceID INT NOT NULL FOREIGN KEY REFERENCES Province(ProvinceID), 
CountryID INT NOT NULL FOREIGN KEY REFERENCES Country(CountryID) 
); 

CREATE TABLE PropertyType 
( 
PropertyTypeID INT IDENTITY(1,1) PRIMARY KEY, 
TypeOfProperty NVARCHAR(50) NOT NULL 
);

CREATE TABLE ViewType
(
ViewTypeID INT IDENTITY(1,1) PRIMARY KEY,
ViewDescription NVARCHAR(25) NOT NULL
);

CREATE TABLE Items
(
ItemID INT IDENTITY(1,1) PRIMARY KEY,
ItemDescription NVARCHAR(100) NOT NULL
)

create table IncludedItems
(
    InclusionID INT IDENTITY(1,1) PRIMARY KEY,
    PropertySaleID INT NOT NULL FOREIGN KEY REFERENCES PropertySale(PropertySaleID),
    ItemID INT NOT NULL FOREIGN KEY REFERENCES Items(ItemID),
    Quantity INT NOT NULL CHECK (Quantity > 0)
)

CREATE TABLE ExcludedItems
(
    ExclusionID INT IDENTITY(1,1) PRIMARY KEY,
    PropertySaleID INT NOT NULL FOREIGN KEY REFERENCES PropertySale(PropertySaleID),
    ItemID INT NOT NULL FOREIGN KEY REFERENCES Items(ItemID),
    Quantity INT NOT NULL CHECK (Quantity > 0)
)

CREATE TABLE Property 
( 
PropertyID INT IDENTITY(1,1) PRIMARY KEY, 
Bedrooms INT NOT NULL, 
Bathrooms INT NOT NULL, 
ViewTypeID INT NOT NULL FOREIGN KEY REFERENCES ViewType(ViewTypeID),
HasPool BIT NOT NULL, 
HasFireplace BIT NOT NULL, 
HasFinishedBasement BIT NOT NULL, 
HasGarage BIT NOT NULL, 
HasAirConditioning BIT NOT NULL, 
AddressID INT NOT NULL FOREIGN KEY REFERENCES Address(AddressID), 
PropertyTypeID INT NOT NULL FOREIGN KEY REFERENCES PropertyType(PropertyTypeID) 
); 

CREATE TABLE PropertySale  
( 
PropertySaleID INT IDENTITY(1,1) PRIMARY KEY, 
SalePrice DECIMAL(12,2) NOT NULL, 
ListingDate DATE NOT NULL, 
ItemsIncluded NVARCHAR(255), 
ItemsExcluded NVARCHAR(255), 
OpenHouseDateTime DATETIME, 
PropertyID INT NOT NULL FOREIGN KEY REFERENCES Property(PropertyID), 
CONSTRAINT chk_openhouse CHECK (OpenHouseDateTime IS NULL OR 
OpenHouseDateTime > ListingDate) 
); 

CREATE TABLE ClientType  
( 
ClientTypeID INT IDENTITY(1,1) PRIMARY KEY, 
TypeOfClient NVARCHAR(50) NOT NULL 
); 

CREATE TABLE Client 
( 
ClientID INT IDENTITY(1,1) PRIMARY KEY, 
ClientName NVARCHAR(100) NOT NULL, 
DateOfBirth DATE NOT NULL, 
TaxResidency NVARCHAR(100), 
Email NVARCHAR(100) NOT NULL UNIQUE, 
CellPhone NVARCHAR(20), 
AccountCreationDate DATE NOT NULL, 
AddressID INT NOT NULL FOREIGN KEY REFERENCES Address(AddressID), 
ClientTypeID INT NOT NULL FOREIGN KEY REFERENCES ClientType(ClientTypeID) 
); 

CREATE TABLE ClientPropertySale 
( 
ClientPropertySaleID INT IDENTITY(1,1) PRIMARY KEY, 
ClientID INT NOT NULL FOREIGN KEY REFERENCES Client(ClientID), 
PropertySaleID INT NOT NULL FOREIGN KEY REFERENCES 
PropertySale(PropertySaleID) 
); 

CREATE TABLE Comments 
( 
CommentsID INT IDENTITY(1,1) PRIMARY KEY, 
CommentsText NVARCHAR(500) NOT NULL, 
Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5), 
CommentDateTime DATETIME NOT NULL, 
ClientID INT NOT NULL FOREIGN KEY REFERENCES Client(ClientID), 
PropertyID INT NOT NULL FOREIGN KEY REFERENCES Property(PropertyID) 
); 

CREATE TABLE Wishlist 
( 
WishlistID INT IDENTITY(1,1) Primary KEY, 
ClientID INT NOT NULL UNIQUE FOREIGN KEY REFERENCES Client(ClientID) 
); 

CREATE TABLE Feature 
( 
FeatureID INT IDENTITY(1,1) PRIMARY KEY, 
Feature NVARCHAR(100) NOT NULL 
); 

CREATE TABLE WishListFeature  
( 
WishlistFeatureID INT IDENTITY(1,1) PRIMARY KEY, 
WishlistID INT NOT NULL FOREIGN KEY REFERENCES Wishlist(WishlistID), 
FeatureID INT NOT NULL FOREIGN KEY REFERENCES Feature(FeatureID), 
Weighting INT NOT NULL CHECK (Weighting BETWEEN 1 AND 10) 
); 

CREATE TABLE PaymentAccount 
( 
PaymentAccountID INT IDENTITY(1,1) PRIMARY KEY, 
FirstName NVARCHAR(50) NOT NULL, 
LastName NVARCHAR(50) NOT NULL, 
ClientID INT NOT NULL FOREIGN KEY REFERENCES Client(ClientID) 
); 

CREATE TABLE PaymentMethod 
( 
PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY, 
Method NVARCHAR(20) NOT NULL, 
PaymentAccountID INT NOT NULL FOREIGN KEY REFERENCES 
PaymentAccount(PaymentAccountID) 
); 

CREATE TABLE CreditCard 
( 
PaymentMethodID INT PRIMARY KEY FOREIGN KEY REFERENCES 
PaymentMethod(PaymentMethodID), 
CardNumber CHAR(16) NOT NULL CHECK (CardNumber LIKE 
'[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'), 
ExpMonth TINYINT NOT NULL CHECK (ExpMonth BETWEEN 1 AND 12), 
ExpYear SMALLINT NOT NULL, 
SecurityCode CHAR(4) NOT NULL CHECK (SecurityCode LIKE '[0-9][0-9][0-9]' OR 
SecurityCode LIKE '[0-9][0-9][0-9][0-9]'), 
CONSTRAINT chk_expiration CHECK  
( 
(ExpYear > YEAR(GETDATE())) OR 
(ExpYear = YEAR(GETDATE()) AND ExpMonth > Month(GETDATE())) 
) 
); 

CREATE TABLE BankTransfer  
( 
PaymentMethodID INT PRIMARY KEY FOREIGN KEY REFERENCES 
PaymentMethod(PaymentMethodID), 
SWIFTCode NVARCHAR(11) NOT NULL, 
BranchCode NVARCHAR(20) NOT NULL, 
AccountNumber NVARCHAR(20) NOT NULL 
); 

CREATE TABLE PayPal 
( 
PaymentMethodID INT PRIMARY KEY FOREIGN KEY REFERENCES 
PaymentMethod(PaymentMethodID), 
PayPalCode NVARCHAR(50) NOT NULL 
); 

CREATE TABLE Invoice 
( 
InvoiceID INT IDENTITY(1,1) PRIMARY KEY, 
Subtotal DECIMAL(12,2) NOT NULL, 
ProvinceTax DECIMAL(12,2) NOT NULL, 
FedTax DECIMAL(12,2) NOT NULL, 
TotalAmount DECIMAL(12,2) NOT NULL, 
InvoiceDate DATE NOT NULL, 
Deadline DATE NOT NULL, 
Comments NVARCHAR(255), 
PaymentAccountID INT NOT NULL FOREIGN KEY REFERENCES 
PaymentAccount(PaymentAccountID), 
CONSTRAINT chk_dl CHECK(Deadline > InvoiceDate) 
); 

CREATE TABLE PaymentTransaction 
( 
PaymentTransactionID INT IDENTITY(1,1) PRIMARY KEY, 
ConfirmationCode NVARCHAR(50) NOT NULL, 
TransactionDateTime DATETIME NOT NULL, 
InvoiceID INT NOT NULL FOREIGN KEY REFERENCES Invoice(InvoiceID), 
PaymentMethodID INT NOT NULL FOREIGN KEY REFERENCES 
PaymentMethod(PaymentMethodID) 
); 
