/* Business Problem 2: 
When a house is sold or rented, we do not want to sell it twice or to rent it out to two different clients.
To avoid that, when a house is sold or rented, we want to move the listings to an archive table.
this table is called ArchiveListing.
From there, we will be able to have a trace of what has ben sold or rented in the past.
*/ 

USE LiveListing
GO

-- Create ArchiveListing table

DROP TABLE IF EXISTS ArchiveListing;
GO

CREATE TABLE ArchiveListing
(
    ArchiveID INT IDENTITY(1,1) PRIMARY KEY, 
    PropertySaleID INT,
    SalePrice DECIMAL(12,2) NOT NULL, 
    ListingDate DATE NOT NULL, 
    ItemsIncluded NVARCHAR(255), 
    ItemsExcluded NVARCHAR(255), 
    OpenHouseDateTime DATETIME, 
    ArchivePropertyID INT NOT NULL, 
    CONSTRAINT chk_openhouse CHECK (OpenHouseDateTime IS NULL OR 
    OpenHouseDateTime > ListingDate) 
)
GO

-- Create the trigger --
DROP TRIGGER IF EXISTS trg_ArchivePropertySale;
GO

CREATE TRIGGER trg_ArchivePropertySale ON PropertySale
After Delete
AS
BEGIN
    DECLARE @SaleID INT;
    DECLARE @SalePrice DECIMAL(12,2);
    DECLARE @ListingDate DATE;
    DECLARE @ItemsIncluded NVARCHAR(255);
    DECLARE @ItemsExcluded NVARCHAR(255);
    DECLARE @OpenHouseDateTime DATETIME;
    DECLARE @PropertyID INT;

    SET @SaleID = (SELECT DELETED.PropertySaleID FROM DELETED);
    SET @SalePrice = (SELECT DELETED.SalePrice FROM DELETED);
    SET @ListingDate = (SELECT DELETED.ListingDate FROM DELETED);
    SET @ItemsIncluded = (SELECT DELETED.ItemsIncluded FROM DELETED);
    SET @ItemsExcluded = (SELECT DELETED.ItemsExcluded FROM DELETED);
    SET @OpenHouseDateTime = (SELECT DELETED.OpenHouseDateTime FROM DELETED);
    SET @PropertyID = (SELECT DELETED.PropertyID FROM DELETED);

    INSERT INTO ArchiveListing (PropertySaleID, SalePrice, ListingDate, ItemsIncluded, ItemsExcluded, OpenHouseDateTime, ArchivePropertyID)
    VALUES (@SaleID, @SalePrice, @ListingDate, @ItemsIncluded, @ItemsExcluded, @OpenHouseDateTime, @PropertyID);
END
GO

/* Interpretation:  
When a listing is deleted from the PropertySale table, the trigger trg_ArchivePropertySale is activated.
This trigger captures the details of the deleted listing and inserts them into the ArchiveListing table.
This ensures that we maintain a record of all sold or rented properties, preventing duplicate sales or rentals.
While the listing is removed, the property details remain intact in the Property table for future reference.
*/