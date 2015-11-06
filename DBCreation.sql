USE [OrderDYnamics]
GO

-- DELETE Stuff
DROP DATABASE [DroneShipper]
GO

-- Recreate Stuff
CREATE DATABASE [DroneShipper]
GO

USE [DroneShipper]
GO

CREATE TABLE [Drones]  (
 [Id] INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
 [Name] NVARCHAR(MAX) NOT NULL,
 [Status] INT NOT NULL,
 [Longitude] DECIMAL(18, 8),
 [Latitude] DECIMAL(18, 8),
 [MaxWeight] DECIMAL
)
GO

CREATE TABLE [Shipments] (
 [Id] INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
 [SourceAddressId] INT NOT NULL,
 [DestinationAddressId] INT NOT NULL,
 [Weight] DECIMAL NOT NULL,
 [Status] INT NOT NULL,
 [DroneId] INT NULL
)
GO

CREATE TABLE [Addresses] (
  [Id] INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
  [AddressLine1] NVARCHAR(MAX),
  [AddressLine2] NVARCHAR(MAX),
  [AddressLine3] NVARCHAR(MAX),
  [City] NVARCHAR(MAX),
  [ProvinceState] NVARCHAR(MAX),
  [Country] NVARCHAR(MAX),
  [PostalZipCode] NVARCHAR(MAX),
  [Longitude] DECIMAL(18, 8) NOT NULL,
  [Latitude] DECIMAL(18, 8) NOT NULL
)
GO

CREATE TABLE [DroneShipmentActivityLog] (
  [Id] INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
  [DroneId] INT NOT NULL,
  [ShipmentId] INT NOT NULL,
  [DateTimeUTC] DATETIME NOT NULL,
  [Message] NVARCHAR(MAX)
)
GO


CREATE PROCEDURE [dbo].[GetShipment] 
	@ID INT
AS

SELECT 
 [Id],
 [SourceAddressId],
 [DestinationAddressId],
 [Weight],
 [Status],
 [DroneId]
FROM
	[dbo].[Shipments]
WHERE
	[Id] = @ID
GO

CREATE PROCEDURE [dbo].[GetShipments] 
	@Statuses varchar(max)
AS

	DECLARE @Sql NVARCHAR(MAX) = '
		SELECT 
		 [Id],
		 [SourceAddressId],
		 [DestinationAddressId],
		 [Weight],
		 [Status],
		 [DroneId]
		FROM
			[dbo].[Shipments]
		WHERE
			[Status] in (' +  @Statuses + ')	
	'

	EXEC(@Sql)

GO


CREATE PROCEDURE [dbo].[InsertShipment]
 @SourceAddressId INT,
 @DestinationAddressId INT,
 @Weight DECIMAL,
 @Status INT
AS

INSERT INTO [dbo].[Shipments] (
 [SourceAddressId],
 [DestinationAddressId],
 [Weight],
 [Status]
)
VALUES(
 @SourceAddressId,
 @DestinationAddressId,
 @Weight,
 @Status 
)

SELECT @@IDENTITY

GO

CREATE PROCEDURE [dbo].[UpdateShipment]
 @ID INT,
 @SourceAddressId INT,
 @DestinationAddressId INT,
 @Weight DECIMAL,
 @Status INT
AS

UPDATE [dbo].[Shipments]
SET
 [SourceAddressId] = @SourceAddressId,
 [DestinationAddressId] = @DestinationAddressId ,
 [Weight] = @Weight,
 [Status] = @Status
WHERE
	[Id] = @ID

GO

CREATE PROCEDURE [dbo].[GetAddress]
	@ID int
AS

SELECT
  [Id],
  [AddressLine1],
  [AddressLine2],
  [AddressLine3],
  [City],
  [ProvinceState],
  [Country],
  [PostalZipCode],
  [Longitude],
  [Latitude]
FROM
	[dbo].[Addresses]
WHERE
	[ID] = @ID
RETURN
GO

CREATE PROCEDURE [dbo].[InsertAddress]
	@AddressLine1 NVARCHAR(MAX),
  @AddressLine2 NVARCHAR(MAX),
  @AddressLine3 NVARCHAR(MAX),
  @City NVARCHAR(MAX),
  @ProvinceState NVARCHAR(MAX),
  @Country NVARCHAR(MAX),
  @PostalZipCode NVARCHAR(MAX),
  @Longitude DECIMAL(18, 8),
  @Latitude DECIMAL(18, 8)
AS 

INSERT INTO [dbo].[Addresses] (
  [AddressLine1],
  [AddressLine2],
  [AddressLine3],
  [City],
  [ProvinceState],
  [Country],
  [PostalZipCode],
  [Longitude],
  [Latitude]
 )
VALUES (
	@AddressLine1,
  @AddressLine2,
  @AddressLine3,
  @City,
  @ProvinceState,
  @Country,
  @PostalZipCode,
  @Longitude,
  @Latitude
)

SELECT @@IDENTITY

GO

CREATE PROCEDURE [dbo].[UpdateAddress] 
  @ID INT,
  @AddressLine1 NVARCHAR(MAX),
  @AddressLine2 NVARCHAR(MAX),
  @AddressLine3 NVARCHAR(MAX),
  @City NVARCHAR(MAX),
  @ProvinceState NVARCHAR(MAX),
  @Country NVARCHAR(MAX),
  @PostalZipCode NVARCHAR(MAX),
  @Longitude DECIMAL(18, 8),
  @Latitude DECIMAL(18, 8)
AS

UPDATE [dbo].[Addresses]
SET
  [AddressLine1] = @AddressLine1,
  [AddressLine2] = @AddressLine2,
  [AddressLine3] = @AddressLine3,
  [City] = @City,
  [ProvinceState] = @ProvinceState,
  [Country] = @Country,
  [PostalZipCode] = @PostalZipCode,
  [Longitude] = @Longitude,
  [Latitude] = @Latitude
WHERE	
	[Id] = @Id
GO


CREATE PROCEDURE [dbo].[GetDrone]
	@ID int
AS

SELECT
	[Id],
	[Name],
	[Status],
	[Longitude],
	[Latitude],
	[MaxWeight]
FROM
	dbo.Drones
WHERE
	Id = @ID

GO

CREATE PROCEDURE [dbo].[GetDrones]
AS

SELECT
	[Id],
	[Name],
	[Status],
	[Longitude],
	[Latitude],
	[MaxWeight]
FROM
	dbo.Drones
GO

CREATE PROCEDURE [dbo].[InsertDrone]
	@Name NVARCHAR(MAX),
	@Status INT,
	@Longitude DECIMAL(18, 8),
	@Latitude DECIMAL(18, 8),
	@MaxWeight DECIMAL
AS
	
INSERT INTO dbo.[Drones] (

	[Name],
	[Status],
	[Longitude],
	[Latitude],
	[MaxWeight]
)
VALUES (
	@Name,
	@Status,
	@Longitude,
	@Latitude,
	@MaxWeight
)

SELECT @@IDENTITY

GO

CREATE PROCEDURE [dbo].[UpdateDrone] 
	@ID INT,
	@Name NVARCHAR(MAX),
	@Status INT,
	@Longitude DECIMAL(18, 8),
	@Latitude DECIMAL(18, 8),
	@MaxWeight DECIMAL
AS

UPDATE [dbo].[Drones]
SET 
	[Name] = @Name,
	[Status] = @Status,
	[Longitude] = @Longitude,
	[Latitude] = @Latitude,
	[MaxWeight] = @MaxWeight
WHERE
	[Id] = @ID

GO

CREATE PROCEDURE [InsertDroneShipmentActivityLog]
	@DroneId INT,
	@ShipmentId INT,
	@Message NVARCHAR(MAX)
AS
	INSERT INTO [dbo].[DroneShipmentActivityLog]
			   ([DroneId]
			   ,[ShipmentId]
			   ,[DateTimeUTC]
			   ,[Message])
		 VALUES
			   (@DroneId
			   ,@ShipmentId
			   ,GETUTCDATE()
			   ,@Message)

	RETURN @@IDENTITY;

GO