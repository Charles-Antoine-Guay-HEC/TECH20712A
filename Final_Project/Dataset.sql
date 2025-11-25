--Generating the data for the Data base--

-- Create DML dataset 

--Inserting into country--
INSERT INTO Country (Country, TaxRate) VALUES ('Canada', 5.00); 

--Inserting into Province--
INSERT INTO Province (Province, TaxRate) VALUES ('Quebec', 9.975); 
INSERT INTO Province (Province, TaxRate) VALUES ('Ontario', 8.00); 

--Inserting into PropertyType--
INSERT INTO PropertyType(TypeOfProperty) VALUES ('Single-Family Home'); 
INSERT INTO PropertyType (TypeOfProperty) VALUES ('Condominium'); 
INSERT INTO PropertyType (TypeOfProperty) VALUES ('Multiplex'); 

--inserting into ViewType--
INSERT INTO ViewType (ViewTypeID, ViewDescription) VALUES (0,'Waterfront');
INSERT INTO ViewType (ViewTypeID, ViewDescription) VALUES (1, 'Water View');
INSERT INTO ViewType (ViewTypeID, ViewDescription) VALUES (2, 'No water view');

-- Inserting into ClientType--
INSERT INTO ClientType (TypeOfClient) VALUES ('Seller'); 
INSERT INTO ClientType (TypeOfClient) VALUES ('PaidUser'); 
INSERT INTO ClientType (TypeOfClient) VALUES ('FreeUser'); 

-- Inserting into Feature--
INSERT INTO Feature (Feature) VALUES ('Fireplace'); 
INSERT INTO Feature (Feature) VALUES ('Pool'); 
INSERT INTO Feature (Feature) VALUES ('Garage'); 
INSERT INTO Feature (Feature) VALUES ('Waterfront');  
INSERT INTO Feature (Feature) VALUES ('Water View'); 
INSERT INTO Feature (Feature) VALUES ('Air Conditioning'); 

-- Inserting into Address--
INSERT INTO Address (Street, City, PostalCode, ProvinceID, CountryID)  
VALUES ('283 Rue Sainte-Catherine', 'Montreal', 'H281E2', 1, 1); 
INSERT INTO Address (Street, City, PostalCode, ProvinceID, CountryID)  
VALUES ('937 Queen Street', 'Toronto', 'M5V3B7', 2, 1); 
INSERT INTO Address (Street, City, PostalCode, ProvinceID, CountryID)  
VALUES ('49 Sherbrooke Street', 'Montreal', 'H2X3B9', 1, 1);  
INSERT INTO Address (Street, City, PostalCode, ProvinceID, CountryID) 
VALUES ('128 King Street', 'Toronto', 'M5H1J7', 2, 1); 
INSERT INTO Address (Street, City, PostalCode, ProvinceID, CountryID) 
VALUES ('78 Sherbrooke Street', 'Montreal', 'H2X3B7', 1, 1); 
INSERT INTO Address (Street, City, PostalCode, ProvinceID, CountryID) 
VALUES ('937 Queen Street', 'Toronto', 'M5H1J5', 2, 1); 
INSERT INTO Address (Street, City, PostalCode, ProvinceID, CountryID) 
VALUES ('12 Crescent Street', 'Montreal', 'H3G2B1', 1, 1); 

-- Inserting into Property--
INSERT INTO Property (Bedrooms, Bathrooms, ViewTypeID,  
HasPool, HasFireplace, HasFinishedBasement, HasGarage,  
HasAirConditioning, AddressID, PropertyTypeID) 
VALUES (3, 2, 0, 1, 1, 1, 1, 1, 1, 1); 
INSERT INTO Property (Bedrooms, Bathrooms, IsWaterfront,  
HasWaterView, HasPool, HasFireplace, HasFinishedBasement, HasGarage,  
HasAirConditioning, AddressID, PropertyTypeID) 
VALUES (2, 1, 1, 0, 0, 0, 1, 1, 2, 2); 
INSERT INTO Property (Bedrooms, Bathrooms, IsWaterfront,  
HasWaterView, HasPool, HasFireplace, HasFinishedBasement, HasGarage,  
HasAirConditioning, AddressID, PropertyTypeID) 
VALUES (4, 3, 2, 1, 1, 1, 1, 1, 3, 3); 
INSERT INTO Property (Bedrooms, Bathrooms, IsWaterfront,  
HasWaterView, HasPool, HasFireplace, HasFinishedBasement, HasGarage,  
HasAirConditioning, AddressID, PropertyTypeID) 
VALUES (1, 1, 1, 0, 0, 0, 0, 1, 4, 2);  

-- Inserting into PropertySale--
INSERT INTO PropertySale (SalePrice, ListingDate, ItemsIncluded, ItemsExcluded,  
OpenHouseDateTime, PropertyID) 
VALUES (600000.00, '2025-10-01', 'Fridge, Stove', 'Washer, Dryer',  
'2025-11-01 14:00:00', 1); 
INSERT INTO PropertySale (SalePrice, ListingDate, ItemsIncluded, ItemsExcluded,  
OpenHouseDateTime, PropertyID) 
VALUES (350000.00, '2025-06-07', 'Dishwasher', NULL, '2025-11-20 15:30:00', 2); 
INSERT INTO PropertySale (SalePrice, ListingDate, ItemsIncluded, ItemsExcluded,  
OpenHouseDateTime, PropertyID) 
VALUES (1000000.00, '2025-07-15', 'Furniture', NULL, '2025-11-29 13:00:00', 3); 
INSERT INTO Client (ClientName, DateOfBirth, TaxResidency, Email, CellPhone,  
AccountCreationDate, AddressID, ClientTypeID) 
VALUES ('Anas El Alami', '2004-05-01', 'Canada', 'anas.el-alami@hec.ca', '4389192126',  
'2025-07-06', 5, 1); 
INSERT INTO Client (ClientName, DateOfBirth, TaxResidency, Email, CellPhone,  
AccountCreationDate, AddressID, ClientTypeID) 
VALUES ('Mark Carney', '1985-03-12', 'Canada', 'mark.carney@gmail.com', '6459274535',  
'2025-09-14', 6, 2); 
INSERT INTO Client (ClientName, DateOfBirth, TaxResidency, Email, CellPhone,  
AccountCreationDate, AddressID, ClientTypeID) 
VALUES ('Dwayne Johnson', '1992-07-14', 'Canada', 'dwayne.johnson@gmail.com', 
'5528826439', 5, 3); 
INSERT INTO Client (ClientName, DateOfBirth, TaxResidency, Email, CellPhone,  
AccountCreationDate, AddressID, ClientTypeID) 
VALUES ('David Lee', '1973-09-14', 'Canada', 'david.09.lee@outlook.com', '4387269026', 7, 
1); 

-- Inserting into ClientPropertySale--
INSERT INTO ClientPropertySale (ClientID, PropertySaleID) VALUES (1, 1); 
INSERT INTO ClientPropertySale (ClientID, PropertySaleID) VALUES (1, 3); 
INSERT INTO ClientPropertySale (ClientID, PropertySaleID) VALUES (4, 3); 
INSERT INTO ClientPropertySale (ClientID, PropertySaleID) VALUES (2, 3); 

-- Inserting into Comments--
INSERT INTO Comments (CommentsText, Rating, CommentDateTime, ClientID, 
PropertyID) 
VALUES ('Beautiful view', 5, '2025-11-21 9:00:00', 1, 1); 
INSERT INTO Comments (CommentsText, Rating, CommentDateTime, ClientID, 
PropertyID) 
VALUES ('Very Nice', 4, '2025-12-01 12:30:00', 1, 2); 
INSERT INTO Comments (CommentsText, Rating, CommentDateTime, ClientID, 
PropertyID) 
VALUES ('Too Expensive', 2, '2025-11-25 10:00:00', 3, 3); 
INSERT INTO Comments (CommentsText, Rating, CommentDateTime, ClientID, 
PropertyID) 
VALUES ('Love the pool', 5, '2025-11-28 14:50:00', 4, 3);  

-- Inserting into Wishlist --
INSERT INTO Wishlist (ClientID) VALUES (1);  

-- Inserting into WishlistFeature --
INSERT INTO WishlistFeature (WishlistID, FeatureID, Weighting) VALUES (1, 1, 10); 
INSERT INTO WishListFeature (WishlistID, FeatureID, Weighting) VALUES (1, 3, 7); 

-- Inserting into PaymentAccount --
INSERT INTO PaymentAccount (FirstName, LastName, ClientID)  
VALUES ('Anas', 'El Alami', 1); 
INSERT INTO PaymentAccount (FirstName, LastName, ClientID) 
VALUES ('Mark', 'Carney', 2); 

-- Inserting into PaymentMethod --
INSERT INTO PaymentMethod (Method, PaymentAccountID) VALUES ('CreditCard', 1); 
INSERT INTO PaymentMethod (Method, PaymentAccountID) VALUES ('PayPal', 2); 

-- Inserting into CreditCard --
INSERT INTO CreditCard (PaymentMethodID, CardNumber, ExpMonth, ExpYear, 
SecurityCode) 
VALUES (1, '1234567891234567', 12, 2029, '8217'); 

-- Inserting into PayPal --
INSERT INTO PayPal (PaymentMethodID, PayPalCode) VALUES (2, 'RICH_CARNEY'); 

-- Inserting into Invoice --
INSERT INTO Invoice (Subtotal, ProvinceTax, FedTax, TotalAmount, InvoiceDate,  
Deadline, Comments, PaymentAccountID) 
VALUES (250.00, 24.94, 12.50, 287.44, '2025-11-10', '2025-11-25', 'Listing fee for property', 
1); 
INSERT INTO Invoice (Subtotal, ProvinceTax, FedTax, TotalAmount, InvoiceDate,  
Deadline, Comments, PaymentAccountID) 
VALUES (15.00, 1.20, 0.75, 16.95, '2025-11-12', '2025-11-27', 'Monthly Subscription', 2); 
INSERT INTO Invoice (Subtotal, ProvinceTax, FedTax, TotalAmount, InvoiceDate,  
Deadline, Comments, PaymentAccountID) 
VALUES (500.00, 49.88, 25.00, 574.88, '2025-10-01', '2025-10-15', 'Marketing Fee', 1); 

-- Inserting into PaymentTransaction --
INSERT INTO PaymentTransaction (ConfirmationCode, TransactionDateTime,  
InvoiceID, PaymentMethodID) 
VALUES ('CONF12345', '2025-11-11 15:00:00', 1, 1); 
INSERT INTO PaymentTransaction (ConfirmationCode, TransactionDateTime,  
InvoiceID, PaymentMethodID) 
VALUES ('CONF67892', '2025-11-13 16:30:00', 2, 2); 
