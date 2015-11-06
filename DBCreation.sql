USE [master]
GO

CREATE DATABASE [DroneShipper]
GO

USE [DroneShipper]
GO

CREATE TABLE [Drones]  (
 [Id] INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
 [Name] NVARCHAR(MAX) NOT NULL,
 [Status] INT NOT NULL,
 [Latitude] DECIMAL(18, 6),
 [Longitude] DECIMAL(18, 6),
 [MaxWeight] DECIMAL(18, 6)
)
GO

CREATE TABLE [Shipments] (
 [Id] INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
 [SourceAddressId] INT NOT NULL,
 [DestinationAddressId] INT NOT NULL,
 [Weight] DECIMAL(18, 6) NOT NULL,
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
  [Latitude] DECIMAL(18, 6),
  [Longitude] DECIMAL(18, 6),
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

CREATE TABLE [dbo].[Bases] (
  [Id] INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
  [Name] NVARCHAR(100) NOT NULL,
  [AddressId] INT NOT NULL
)

CREATE TABLE [dbo].[PostalCodes](
	[PostalCode] [varchar](6) NOT NULL PRIMARY KEY,
	[Latitude] [decimal](18, 6) NULL,
	[Longitude] [decimal](18, 6) NULL,
	[City] [varchar](100) NULL,
	[Province] [varchar](2) NULL
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX IX_PostalCodes_Lat_Long ON dbo.PostalCodes (Latitude, Longitude) ON [PRIMARY]
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
 @Weight DECIMAL(18, 6),
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
 @Weight DECIMAL(18, 6),
 @Status INT,
 @DroneId INT
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
  @Longitude DECIMAL(18, 6),
  @Latitude DECIMAL(18, 6)
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
  @Longitude DECIMAL(18, 6),
  @Latitude DECIMAL(18, 6)
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
	@Longitude DECIMAL(18, 6),
	@Latitude DECIMAL(18, 6),
	@MaxWeight DECIMAL(18, 6)
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
	@Longitude DECIMAL(18, 6),
	@Latitude DECIMAL(18, 6),
	@MaxWeight DECIMAL(18, 6)
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

CREATE PROCEDURE [GetActivityLogsByShipment]
	@ShipmentID INT
AS

SELECT
	[ID],
	[DroneId],
	[ShipmentId],
	[DateTimeUTC],
	[MEssage]
FROM
	[dbo].[DroneShipmentActivityLog]
WHERE
	[ShipmentId] = @ShipmentID
GO

CREATE PROCEDURE InsertBase
	@Name NVARCHAR(100),
	@AddressId INT
AS
	INSERT INTO Bases (Name, AddressId)
	VALUES (@Name, @AddressId)
GO

CREATE PROCEDURE GetBase 
	@Id INT
AS
	SELECT Id, Name, AddressId
	FROM Bases
	WHERE Id = @Id
GO

CREATE PROCEDURE GetBases
AS
	SELECT Id, Name, AddressId
	FROM Bases
GO

CREATE PROCEDURE GetPostalCode
	@PostalCode VARCHAR(6)
AS
	SELECT [PostalCode], [Latitude], [Longitude], [City], [Province]
	FROM [dbo].[PostalCodes]
	WHERE [PostalCode] = @PostalCode
GO

INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'K4C4Z3', CAST(43.872118 AS Decimal(18, 6)), CAST(-79.450231 AS Decimal(18, 6)), N'RICHMOND HILL', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L0C0V1', CAST(43.886069 AS Decimal(18, 6)), CAST(-79.445718 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L2C0N1', CAST(43.885536 AS Decimal(18, 6)), CAST(-79.444301 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L2C5G2', CAST(43.854428 AS Decimal(18, 6)), CAST(-79.433524 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L3C9M3', CAST(43.866154 AS Decimal(18, 6)), CAST(-79.439210 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L3E0P9', CAST(43.915505 AS Decimal(18, 6)), CAST(-79.466628 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L3E3Z2', CAST(43.955604 AS Decimal(18, 6)), CAST(-79.481909 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L3E4N2', CAST(43.956570 AS Decimal(18, 6)), CAST(-79.440530 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0A1', CAST(43.843529 AS Decimal(18, 6)), CAST(-79.424558 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0A2', CAST(43.842924 AS Decimal(18, 6)), CAST(-79.424716 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0A3', CAST(43.842491 AS Decimal(18, 6)), CAST(-79.420928 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0A4', CAST(43.843638 AS Decimal(18, 6)), CAST(-79.386520 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0A5', CAST(43.849693 AS Decimal(18, 6)), CAST(-79.425301 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0A6', CAST(43.842409 AS Decimal(18, 6)), CAST(-79.416362 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0A7', CAST(43.848918 AS Decimal(18, 6)), CAST(-79.381634 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0A8', CAST(43.848394 AS Decimal(18, 6)), CAST(-79.383845 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0A9', CAST(44.017898 AS Decimal(18, 6)), CAST(-79.423149 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0B1', CAST(43.844993 AS Decimal(18, 6)), CAST(-79.425770 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0B2', CAST(43.847973 AS Decimal(18, 6)), CAST(-79.383132 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0B3', CAST(43.858408 AS Decimal(18, 6)), CAST(-79.391605 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0B4', CAST(43.869224 AS Decimal(18, 6)), CAST(-79.382210 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0B5', CAST(43.873880 AS Decimal(18, 6)), CAST(-79.387770 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0B6', CAST(43.763174 AS Decimal(18, 6)), CAST(-79.420999 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0B7', CAST(43.852001 AS Decimal(18, 6)), CAST(-79.390523 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0B9', CAST(43.854514 AS Decimal(18, 6)), CAST(-79.384874 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0C1', CAST(43.846342 AS Decimal(18, 6)), CAST(-79.427124 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0C2', CAST(43.846331 AS Decimal(18, 6)), CAST(-79.426794 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0C3', CAST(43.848970 AS Decimal(18, 6)), CAST(-79.377527 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0C4', CAST(43.840612 AS Decimal(18, 6)), CAST(-79.397921 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0C5', CAST(43.860621 AS Decimal(18, 6)), CAST(-79.396019 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0C6', CAST(43.842073 AS Decimal(18, 6)), CAST(-79.392724 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0C7', CAST(43.705278 AS Decimal(18, 6)), CAST(-79.579178 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0C8', CAST(43.867337 AS Decimal(18, 6)), CAST(-79.385119 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0E2', CAST(43.866075 AS Decimal(18, 6)), CAST(-79.400964 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0E5', CAST(43.849854 AS Decimal(18, 6)), CAST(-79.406450 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0E6', CAST(43.855402 AS Decimal(18, 6)), CAST(-79.410445 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0G3', CAST(43.824083 AS Decimal(18, 6)), CAST(-79.305491 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0G4', CAST(43.841442 AS Decimal(18, 6)), CAST(-79.395774 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0H8', CAST(43.893656 AS Decimal(18, 6)), CAST(-79.419603 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0N4', CAST(43.858408 AS Decimal(18, 6)), CAST(-79.391605 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0P5', CAST(43.851685 AS Decimal(18, 6)), CAST(-79.427351 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0S6', CAST(43.858408 AS Decimal(18, 6)), CAST(-79.391605 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0S8', CAST(43.858408 AS Decimal(18, 6)), CAST(-79.391605 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B0Z7', CAST(43.861157 AS Decimal(18, 6)), CAST(-79.404316 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1A0', CAST(43.841926 AS Decimal(18, 6)), CAST(-79.417925 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1A1', CAST(43.841130 AS Decimal(18, 6)), CAST(-79.400669 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1A2', CAST(43.842063 AS Decimal(18, 6)), CAST(-79.401358 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1A3', CAST(43.852961 AS Decimal(18, 6)), CAST(-79.381632 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1A4', CAST(43.852501 AS Decimal(18, 6)), CAST(-79.386234 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1A5', CAST(43.840256 AS Decimal(18, 6)), CAST(-79.403268 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1A6', CAST(43.840292 AS Decimal(18, 6)), CAST(-79.400638 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1A7', CAST(43.832628 AS Decimal(18, 6)), CAST(-79.437084 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1A8', CAST(43.848585 AS Decimal(18, 6)), CAST(-79.389060 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1A9', CAST(43.842843 AS Decimal(18, 6)), CAST(-79.396279 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1B1', CAST(43.842726 AS Decimal(18, 6)), CAST(-79.397213 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1B2', CAST(43.844432 AS Decimal(18, 6)), CAST(-79.382256 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1B3', CAST(43.857229 AS Decimal(18, 6)), CAST(-79.384261 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1B4', CAST(43.845255 AS Decimal(18, 6)), CAST(-79.387000 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1B5', CAST(43.859573 AS Decimal(18, 6)), CAST(-79.385157 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1B6', CAST(43.847610 AS Decimal(18, 6)), CAST(-79.387492 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1B7', CAST(43.671803 AS Decimal(18, 6)), CAST(-79.715332 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1B8', CAST(43.854435 AS Decimal(18, 6)), CAST(-79.393325 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1B9', CAST(43.853595 AS Decimal(18, 6)), CAST(-79.398806 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1C0', CAST(43.844567 AS Decimal(18, 6)), CAST(-79.386959 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1C1', CAST(43.849477 AS Decimal(18, 6)), CAST(-79.388091 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1C2', CAST(43.799512 AS Decimal(18, 6)), CAST(-79.410246 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1C3', CAST(43.848134 AS Decimal(18, 6)), CAST(-79.390601 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1C4', CAST(43.849771 AS Decimal(18, 6)), CAST(-79.387488 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1C5', CAST(43.848341 AS Decimal(18, 6)), CAST(-79.384492 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1C6', CAST(43.850439 AS Decimal(18, 6)), CAST(-79.390673 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1C7', CAST(43.845363 AS Decimal(18, 6)), CAST(-79.387186 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1C8', CAST(43.853307 AS Decimal(18, 6)), CAST(-79.382436 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1C9', CAST(43.852512 AS Decimal(18, 6)), CAST(-79.406239 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1E1', CAST(43.849029 AS Decimal(18, 6)), CAST(-79.388543 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1E2', CAST(43.851027 AS Decimal(18, 6)), CAST(-79.377615 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1E3', CAST(43.848484 AS Decimal(18, 6)), CAST(-79.384300 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1E4', CAST(43.862448 AS Decimal(18, 6)), CAST(-79.382914 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1E5', CAST(43.857577 AS Decimal(18, 6)), CAST(-79.380032 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1E6', CAST(43.851500 AS Decimal(18, 6)), CAST(-79.382982 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1E7', CAST(43.852727 AS Decimal(18, 6)), CAST(-79.393196 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1E8', CAST(43.855548 AS Decimal(18, 6)), CAST(-79.391311 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1E9', CAST(43.850010 AS Decimal(18, 6)), CAST(-79.386383 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1G1', CAST(43.849734 AS Decimal(18, 6)), CAST(-79.387339 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1G2', CAST(43.849312 AS Decimal(18, 6)), CAST(-79.383713 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1G3', CAST(43.854043 AS Decimal(18, 6)), CAST(-79.384929 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1G4', CAST(43.849221 AS Decimal(18, 6)), CAST(-79.387408 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1G5', CAST(43.853653 AS Decimal(18, 6)), CAST(-79.391108 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1G6', CAST(43.856266 AS Decimal(18, 6)), CAST(-79.379565 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1G7', CAST(43.845320 AS Decimal(18, 6)), CAST(-79.382419 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1G8', CAST(43.857141 AS Decimal(18, 6)), CAST(-79.380043 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1G9', CAST(43.852880 AS Decimal(18, 6)), CAST(-79.383977 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1H1', CAST(43.860726 AS Decimal(18, 6)), CAST(-79.377608 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1H2', CAST(43.852388 AS Decimal(18, 6)), CAST(-79.392850 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1H3', CAST(43.852523 AS Decimal(18, 6)), CAST(-79.392058 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1H4', CAST(43.851600 AS Decimal(18, 6)), CAST(-79.392905 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1H5', CAST(43.841238 AS Decimal(18, 6)), CAST(-79.406753 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1H6', CAST(43.848263 AS Decimal(18, 6)), CAST(-79.384065 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1H7', CAST(43.858789 AS Decimal(18, 6)), CAST(-79.388986 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1H8', CAST(43.852610 AS Decimal(18, 6)), CAST(-79.387782 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1H9', CAST(43.852574 AS Decimal(18, 6)), CAST(-79.387141 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1J1', CAST(43.844454 AS Decimal(18, 6)), CAST(-79.382193 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1J2', CAST(43.856133 AS Decimal(18, 6)), CAST(-79.379557 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1J3', CAST(43.861206 AS Decimal(18, 6)), CAST(-79.391093 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1J4', CAST(43.857480 AS Decimal(18, 6)), CAST(-79.383239 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1J5', CAST(43.850568 AS Decimal(18, 6)), CAST(-79.380691 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1J6', CAST(43.854298 AS Decimal(18, 6)), CAST(-79.378171 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1J7', CAST(43.860931 AS Decimal(18, 6)), CAST(-79.380361 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1J8', CAST(43.847835 AS Decimal(18, 6)), CAST(-79.377595 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1J9', CAST(43.846404 AS Decimal(18, 6)), CAST(-79.387840 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1K1', CAST(43.852312 AS Decimal(18, 6)), CAST(-79.389258 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1K2', CAST(43.856353 AS Decimal(18, 6)), CAST(-79.387726 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1K3', CAST(43.861686 AS Decimal(18, 6)), CAST(-79.383400 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1K4', CAST(43.855035 AS Decimal(18, 6)), CAST(-79.389744 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1K5', CAST(43.856124 AS Decimal(18, 6)), CAST(-79.388618 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1K6', CAST(43.855452 AS Decimal(18, 6)), CAST(-79.389989 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1K7', CAST(43.852541 AS Decimal(18, 6)), CAST(-79.387198 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1K8', CAST(43.854017 AS Decimal(18, 6)), CAST(-79.387555 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1K9', CAST(43.854981 AS Decimal(18, 6)), CAST(-79.382692 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1L1', CAST(43.845586 AS Decimal(18, 6)), CAST(-79.386985 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1L2', CAST(44.171977 AS Decimal(18, 6)), CAST(-80.212180 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1L3', CAST(43.857503 AS Decimal(18, 6)), CAST(-79.379479 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1L4', CAST(43.857264 AS Decimal(18, 6)), CAST(-79.384706 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1L5', CAST(43.857540 AS Decimal(18, 6)), CAST(-79.388080 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1L6', CAST(43.848606 AS Decimal(18, 6)), CAST(-79.388158 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1L7', CAST(43.851699 AS Decimal(18, 6)), CAST(-79.392751 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1L8', CAST(43.856108 AS Decimal(18, 6)), CAST(-79.388728 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1L9', CAST(43.855859 AS Decimal(18, 6)), CAST(-79.391146 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1M1', CAST(43.855352 AS Decimal(18, 6)), CAST(-79.392791 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1M2', CAST(43.856766 AS Decimal(18, 6)), CAST(-79.391555 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1M3', CAST(43.846389 AS Decimal(18, 6)), CAST(-79.382823 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1M4', CAST(43.862915 AS Decimal(18, 6)), CAST(-79.381465 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1M5', CAST(43.853098 AS Decimal(18, 6)), CAST(-79.388992 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1M6', CAST(43.852551 AS Decimal(18, 6)), CAST(-79.389771 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1M7', CAST(43.846339 AS Decimal(18, 6)), CAST(-79.378535 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1M8', CAST(43.856269 AS Decimal(18, 6)), CAST(-79.388081 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1M9', CAST(43.848087 AS Decimal(18, 6)), CAST(-79.406774 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1N1', CAST(43.847522 AS Decimal(18, 6)), CAST(-79.406700 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1N2', CAST(43.847153 AS Decimal(18, 6)), CAST(-79.406962 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1N3', CAST(43.847064 AS Decimal(18, 6)), CAST(-79.407117 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1N4', CAST(43.847492 AS Decimal(18, 6)), CAST(-79.407447 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1N5', CAST(43.847679 AS Decimal(18, 6)), CAST(-79.407534 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1N6', CAST(43.847848 AS Decimal(18, 6)), CAST(-79.405721 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1N7', CAST(43.847865 AS Decimal(18, 6)), CAST(-79.405652 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1N8', CAST(43.848063 AS Decimal(18, 6)), CAST(-79.405917 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1N9', CAST(43.846695 AS Decimal(18, 6)), CAST(-79.405899 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1P0', CAST(43.859453 AS Decimal(18, 6)), CAST(-79.402858 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1P1', CAST(43.846877 AS Decimal(18, 6)), CAST(-79.405717 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1P2', CAST(43.846925 AS Decimal(18, 6)), CAST(-79.404318 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1P3', CAST(43.846927 AS Decimal(18, 6)), CAST(-79.404393 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1P4', CAST(43.846567 AS Decimal(18, 6)), CAST(-79.404836 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1P5', CAST(43.846374 AS Decimal(18, 6)), CAST(-79.402926 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1P6', CAST(43.845769 AS Decimal(18, 6)), CAST(-79.403061 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1P7', CAST(43.850339 AS Decimal(18, 6)), CAST(-79.402904 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1P8', CAST(43.846274 AS Decimal(18, 6)), CAST(-79.405763 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1P9', CAST(43.846544 AS Decimal(18, 6)), CAST(-79.406000 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1R1', CAST(43.845157 AS Decimal(18, 6)), CAST(-79.404718 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1R2', CAST(43.843991 AS Decimal(18, 6)), CAST(-79.402806 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1R3', CAST(43.844120 AS Decimal(18, 6)), CAST(-79.403836 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1R4', CAST(43.844708 AS Decimal(18, 6)), CAST(-79.402981 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1R5', CAST(43.844760 AS Decimal(18, 6)), CAST(-79.401543 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1R6', CAST(43.844783 AS Decimal(18, 6)), CAST(-79.402208 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1R7', CAST(43.844300 AS Decimal(18, 6)), CAST(-79.401237 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1R8', CAST(43.844136 AS Decimal(18, 6)), CAST(-79.402022 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1R9', CAST(43.843202 AS Decimal(18, 6)), CAST(-79.400102 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1S1', CAST(43.842931 AS Decimal(18, 6)), CAST(-79.400378 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1S2', CAST(43.843158 AS Decimal(18, 6)), CAST(-79.399279 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1S3', CAST(43.842952 AS Decimal(18, 6)), CAST(-79.399202 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1S4', CAST(43.842697 AS Decimal(18, 6)), CAST(-79.398716 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1S5', CAST(43.843072 AS Decimal(18, 6)), CAST(-79.398434 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1S6', CAST(43.842727 AS Decimal(18, 6)), CAST(-79.398571 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1S7', CAST(43.843935 AS Decimal(18, 6)), CAST(-79.399569 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1S8', CAST(43.844032 AS Decimal(18, 6)), CAST(-79.398840 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1S9', CAST(43.843698 AS Decimal(18, 6)), CAST(-79.399481 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1T1', CAST(43.844575 AS Decimal(18, 6)), CAST(-79.399915 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1T2', CAST(43.845476 AS Decimal(18, 6)), CAST(-79.398522 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1T3', CAST(43.845797 AS Decimal(18, 6)), CAST(-79.398755 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1T4', CAST(43.845149 AS Decimal(18, 6)), CAST(-79.397281 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1T5', CAST(43.845061 AS Decimal(18, 6)), CAST(-79.396787 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1T6', CAST(43.845367 AS Decimal(18, 6)), CAST(-79.396665 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1T7', CAST(43.845798 AS Decimal(18, 6)), CAST(-79.394422 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1T8', CAST(43.845642 AS Decimal(18, 6)), CAST(-79.393622 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1T9', CAST(43.846534 AS Decimal(18, 6)), CAST(-79.396149 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1V1', CAST(43.846787 AS Decimal(18, 6)), CAST(-79.395418 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1V2', CAST(43.846384 AS Decimal(18, 6)), CAST(-79.395137 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1V3', CAST(43.846931 AS Decimal(18, 6)), CAST(-79.393531 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1V4', CAST(43.847191 AS Decimal(18, 6)), CAST(-79.393078 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1V5', CAST(43.847200 AS Decimal(18, 6)), CAST(-79.393114 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1V6', CAST(43.847461 AS Decimal(18, 6)), CAST(-79.394891 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1V7', CAST(43.847588 AS Decimal(18, 6)), CAST(-79.394329 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1V8', CAST(43.847753 AS Decimal(18, 6)), CAST(-79.395442 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1V9', CAST(43.847983 AS Decimal(18, 6)), CAST(-79.394453 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1W1', CAST(43.848579 AS Decimal(18, 6)), CAST(-79.393646 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1W2', CAST(43.848510 AS Decimal(18, 6)), CAST(-79.394802 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1W3', CAST(43.848580 AS Decimal(18, 6)), CAST(-79.396763 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1W4', CAST(43.847760 AS Decimal(18, 6)), CAST(-79.396945 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1W5', CAST(43.848170 AS Decimal(18, 6)), CAST(-79.396719 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1W6', CAST(43.847974 AS Decimal(18, 6)), CAST(-79.398571 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1W7', CAST(43.847553 AS Decimal(18, 6)), CAST(-79.397293 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1W8', CAST(43.847818 AS Decimal(18, 6)), CAST(-79.398006 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1W9', CAST(43.847905 AS Decimal(18, 6)), CAST(-79.398897 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1X1', CAST(43.845946 AS Decimal(18, 6)), CAST(-79.397892 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1X2', CAST(43.846612 AS Decimal(18, 6)), CAST(-79.398694 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1X3', CAST(43.848026 AS Decimal(18, 6)), CAST(-79.399352 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1X4', CAST(43.847668 AS Decimal(18, 6)), CAST(-79.400000 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1X5', CAST(43.847396 AS Decimal(18, 6)), CAST(-79.399531 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1X6', CAST(43.850285 AS Decimal(18, 6)), CAST(-79.398473 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1X7', CAST(43.850239 AS Decimal(18, 6)), CAST(-79.397548 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1X8', CAST(43.849687 AS Decimal(18, 6)), CAST(-79.396947 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1X9', CAST(43.849449 AS Decimal(18, 6)), CAST(-79.402679 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1Y1', CAST(43.852291 AS Decimal(18, 6)), CAST(-79.406544 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1Y2', CAST(43.851817 AS Decimal(18, 6)), CAST(-79.407039 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1Y3', CAST(43.851063 AS Decimal(18, 6)), CAST(-79.406958 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1Y4', CAST(43.853115 AS Decimal(18, 6)), CAST(-79.406080 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1Y5', CAST(43.852807 AS Decimal(18, 6)), CAST(-79.406137 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1Y6', CAST(43.853708 AS Decimal(18, 6)), CAST(-79.405530 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1Y7', CAST(43.853326 AS Decimal(18, 6)), CAST(-79.405056 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1Y8', CAST(43.853503 AS Decimal(18, 6)), CAST(-79.404240 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1Y9', CAST(43.853860 AS Decimal(18, 6)), CAST(-79.404845 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1Z1', CAST(43.852382 AS Decimal(18, 6)), CAST(-79.405744 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1Z2', CAST(43.851347 AS Decimal(18, 6)), CAST(-79.405682 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1Z3', CAST(43.852217 AS Decimal(18, 6)), CAST(-79.405444 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1Z4', CAST(43.851614 AS Decimal(18, 6)), CAST(-79.404057 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1Z5', CAST(43.852098 AS Decimal(18, 6)), CAST(-79.404177 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1Z6', CAST(43.851991 AS Decimal(18, 6)), CAST(-79.404593 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1Z7', CAST(43.852466 AS Decimal(18, 6)), CAST(-79.402673 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1Z8', CAST(43.851718 AS Decimal(18, 6)), CAST(-79.403070 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B1Z9', CAST(43.852743 AS Decimal(18, 6)), CAST(-79.402715 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2A1', CAST(43.853291 AS Decimal(18, 6)), CAST(-79.402579 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2A2', CAST(43.853312 AS Decimal(18, 6)), CAST(-79.401061 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2A3', CAST(43.852966 AS Decimal(18, 6)), CAST(-79.401478 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2A4', CAST(43.852329 AS Decimal(18, 6)), CAST(-79.400334 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2A5', CAST(43.852399 AS Decimal(18, 6)), CAST(-79.400748 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2A6', CAST(43.852445 AS Decimal(18, 6)), CAST(-79.401508 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2A7', CAST(43.853434 AS Decimal(18, 6)), CAST(-79.398872 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2A8', CAST(43.853234 AS Decimal(18, 6)), CAST(-79.399835 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2A9', CAST(43.852943 AS Decimal(18, 6)), CAST(-79.399061 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2B1', CAST(43.853703 AS Decimal(18, 6)), CAST(-79.398589 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2B2', CAST(43.854747 AS Decimal(18, 6)), CAST(-79.401977 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2B3', CAST(43.853886 AS Decimal(18, 6)), CAST(-79.402513 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2B4', CAST(43.854214 AS Decimal(18, 6)), CAST(-79.403037 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2B5', CAST(43.856302 AS Decimal(18, 6)), CAST(-79.404352 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2B6', CAST(43.855523 AS Decimal(18, 6)), CAST(-79.404906 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2B7', CAST(43.855281 AS Decimal(18, 6)), CAST(-79.403888 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2B8', CAST(43.856451 AS Decimal(18, 6)), CAST(-79.403686 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2B9', CAST(43.856005 AS Decimal(18, 6)), CAST(-79.403204 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2C0', CAST(43.859453 AS Decimal(18, 6)), CAST(-79.402858 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2C1', CAST(43.855811 AS Decimal(18, 6)), CAST(-79.402602 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2C2', CAST(43.856029 AS Decimal(18, 6)), CAST(-79.400174 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2C3', CAST(43.855820 AS Decimal(18, 6)), CAST(-79.400832 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2C4', CAST(43.856319 AS Decimal(18, 6)), CAST(-79.401163 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2C5', CAST(43.857429 AS Decimal(18, 6)), CAST(-79.399313 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2C6', CAST(43.857604 AS Decimal(18, 6)), CAST(-79.397350 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2C7', CAST(43.856880 AS Decimal(18, 6)), CAST(-79.399327 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2C8', CAST(43.858572 AS Decimal(18, 6)), CAST(-79.394106 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2C9', CAST(43.858084 AS Decimal(18, 6)), CAST(-79.395990 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2E1', CAST(43.858044 AS Decimal(18, 6)), CAST(-79.395958 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2E2', CAST(43.857943 AS Decimal(18, 6)), CAST(-79.394370 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2E3', CAST(43.858082 AS Decimal(18, 6)), CAST(-79.391080 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2E4', CAST(43.858152 AS Decimal(18, 6)), CAST(-79.391027 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2E5', CAST(43.858100 AS Decimal(18, 6)), CAST(-79.391947 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2E6', CAST(43.858375 AS Decimal(18, 6)), CAST(-79.390985 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2E7', CAST(43.858545 AS Decimal(18, 6)), CAST(-79.390977 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2E8', CAST(43.858738 AS Decimal(18, 6)), CAST(-79.391710 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2E9', CAST(43.858648 AS Decimal(18, 6)), CAST(-79.392385 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2G1', CAST(43.859044 AS Decimal(18, 6)), CAST(-79.391318 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2G2', CAST(43.860442 AS Decimal(18, 6)), CAST(-79.404680 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2G3', CAST(43.860139 AS Decimal(18, 6)), CAST(-79.404325 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2G4', CAST(43.860348 AS Decimal(18, 6)), CAST(-79.403738 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2G5', CAST(43.858824 AS Decimal(18, 6)), CAST(-79.407541 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2G6', CAST(43.860014 AS Decimal(18, 6)), CAST(-79.406544 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2G7', CAST(43.858795 AS Decimal(18, 6)), CAST(-79.408952 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2G8', CAST(43.859666 AS Decimal(18, 6)), CAST(-79.408636 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2G9', CAST(43.860395 AS Decimal(18, 6)), CAST(-79.408668 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2H1', CAST(43.862899 AS Decimal(18, 6)), CAST(-79.402043 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2H2', CAST(43.861897 AS Decimal(18, 6)), CAST(-79.403935 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2H3', CAST(43.862469 AS Decimal(18, 6)), CAST(-79.402597 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2H4', CAST(43.861013 AS Decimal(18, 6)), CAST(-79.407506 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2H5', CAST(43.861359 AS Decimal(18, 6)), CAST(-79.406301 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2H6', CAST(43.861576 AS Decimal(18, 6)), CAST(-79.406830 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2H7', CAST(43.860905 AS Decimal(18, 6)), CAST(-79.410468 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2H8', CAST(43.859707 AS Decimal(18, 6)), CAST(-79.410730 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2H9', CAST(43.861360 AS Decimal(18, 6)), CAST(-79.410784 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2J1', CAST(43.861619 AS Decimal(18, 6)), CAST(-79.408633 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2J2', CAST(43.862118 AS Decimal(18, 6)), CAST(-79.409000 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2J3', CAST(43.862397 AS Decimal(18, 6)), CAST(-79.408859 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2J4', CAST(43.863733 AS Decimal(18, 6)), CAST(-79.406209 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2J5', CAST(43.862546 AS Decimal(18, 6)), CAST(-79.406341 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2J6', CAST(43.864099 AS Decimal(18, 6)), CAST(-79.407914 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2J7', CAST(43.864339 AS Decimal(18, 6)), CAST(-79.407853 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2J8', CAST(43.862887 AS Decimal(18, 6)), CAST(-79.409395 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2J9', CAST(43.863058 AS Decimal(18, 6)), CAST(-79.410539 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2K1', CAST(43.864962 AS Decimal(18, 6)), CAST(-79.409634 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2K2', CAST(43.863914 AS Decimal(18, 6)), CAST(-79.409013 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2K3', CAST(43.865180 AS Decimal(18, 6)), CAST(-79.411192 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2K4', CAST(43.864584 AS Decimal(18, 6)), CAST(-79.410516 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2K5', CAST(43.865903 AS Decimal(18, 6)), CAST(-79.411237 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2K6', CAST(43.866445 AS Decimal(18, 6)), CAST(-79.411182 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2K7', CAST(43.866354 AS Decimal(18, 6)), CAST(-79.411320 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2K8', CAST(43.865601 AS Decimal(18, 6)), CAST(-79.411781 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2K9', CAST(43.866335 AS Decimal(18, 6)), CAST(-79.410153 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2L1', CAST(43.866050 AS Decimal(18, 6)), CAST(-79.409435 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2L2', CAST(43.866259 AS Decimal(18, 6)), CAST(-79.408760 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2L3', CAST(43.867464 AS Decimal(18, 6)), CAST(-79.407548 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2L4', CAST(43.867717 AS Decimal(18, 6)), CAST(-79.407450 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2L5', CAST(43.867190 AS Decimal(18, 6)), CAST(-79.410479 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2L6', CAST(43.867413 AS Decimal(18, 6)), CAST(-79.410831 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2L7', CAST(43.868373 AS Decimal(18, 6)), CAST(-79.409433 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2L8', CAST(43.868506 AS Decimal(18, 6)), CAST(-79.408090 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2L9', CAST(43.868893 AS Decimal(18, 6)), CAST(-79.408294 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2M1', CAST(43.869830 AS Decimal(18, 6)), CAST(-79.405457 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2M2', CAST(43.868602 AS Decimal(18, 6)), CAST(-79.405045 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2M3', CAST(43.869972 AS Decimal(18, 6)), CAST(-79.405998 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2M4', CAST(43.870096 AS Decimal(18, 6)), CAST(-79.408001 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2M5', CAST(43.869622 AS Decimal(18, 6)), CAST(-79.407858 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2M6', CAST(43.870309 AS Decimal(18, 6)), CAST(-79.410738 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2M7', CAST(43.870862 AS Decimal(18, 6)), CAST(-79.410354 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2M8', CAST(43.869413 AS Decimal(18, 6)), CAST(-79.410035 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2M9', CAST(43.848918 AS Decimal(18, 6)), CAST(-79.381634 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2N0', CAST(43.855789 AS Decimal(18, 6)), CAST(-79.385355 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2N1', CAST(43.849655 AS Decimal(18, 6)), CAST(-79.377374 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2N2', CAST(43.852171 AS Decimal(18, 6)), CAST(-79.379362 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2N3', CAST(43.856967 AS Decimal(18, 6)), CAST(-79.385450 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2N4', CAST(43.851101 AS Decimal(18, 6)), CAST(-79.381853 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2N5', CAST(43.857406 AS Decimal(18, 6)), CAST(-79.388333 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2N6', CAST(43.857016 AS Decimal(18, 6)), CAST(-79.388197 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2N7', CAST(43.843896 AS Decimal(18, 6)), CAST(-79.385068 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2N8', CAST(43.859486 AS Decimal(18, 6)), CAST(-79.386219 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2N9', CAST(43.855251 AS Decimal(18, 6)), CAST(-79.382682 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2P1', CAST(43.854647 AS Decimal(18, 6)), CAST(-79.381918 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2P2', CAST(43.852505 AS Decimal(18, 6)), CAST(-79.388555 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2P3', CAST(43.852655 AS Decimal(18, 6)), CAST(-79.384677 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2P4', CAST(43.853981 AS Decimal(18, 6)), CAST(-79.407833 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2P5', CAST(43.854227 AS Decimal(18, 6)), CAST(-79.407963 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2P6', CAST(43.855050 AS Decimal(18, 6)), CAST(-79.409010 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2P7', CAST(43.854006 AS Decimal(18, 6)), CAST(-79.408938 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2P8', CAST(43.855050 AS Decimal(18, 6)), CAST(-79.409010 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2P9', CAST(43.855953 AS Decimal(18, 6)), CAST(-79.406032 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2R1', CAST(43.855426 AS Decimal(18, 6)), CAST(-79.406873 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2R2', CAST(43.855843 AS Decimal(18, 6)), CAST(-79.405938 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2R3', CAST(43.844192 AS Decimal(18, 6)), CAST(-79.391962 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2R4', CAST(43.844244 AS Decimal(18, 6)), CAST(-79.391710 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2R5', CAST(43.843981 AS Decimal(18, 6)), CAST(-79.392853 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2R6', CAST(43.845198 AS Decimal(18, 6)), CAST(-79.390402 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2R7', CAST(43.844416 AS Decimal(18, 6)), CAST(-79.390438 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2R8', CAST(43.845838 AS Decimal(18, 6)), CAST(-79.390013 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2R9', CAST(43.845854 AS Decimal(18, 6)), CAST(-79.390293 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2S1', CAST(43.845561 AS Decimal(18, 6)), CAST(-79.392012 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2S2', CAST(43.845137 AS Decimal(18, 6)), CAST(-79.392577 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2S3', CAST(43.849708 AS Decimal(18, 6)), CAST(-79.404269 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2S4', CAST(43.850370 AS Decimal(18, 6)), CAST(-79.403417 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2S5', CAST(43.870051 AS Decimal(18, 6)), CAST(-79.407998 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2S6', CAST(43.871110 AS Decimal(18, 6)), CAST(-79.411372 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2S7', CAST(43.871811 AS Decimal(18, 6)), CAST(-79.410006 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2S8', CAST(43.871304 AS Decimal(18, 6)), CAST(-79.405644 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2S9', CAST(43.870870 AS Decimal(18, 6)), CAST(-79.408083 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2T1', CAST(43.870821 AS Decimal(18, 6)), CAST(-79.408081 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2T2', CAST(43.872648 AS Decimal(18, 6)), CAST(-79.407208 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2T3', CAST(43.872208 AS Decimal(18, 6)), CAST(-79.406881 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2T4', CAST(43.871565 AS Decimal(18, 6)), CAST(-79.406048 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2T5', CAST(43.871691 AS Decimal(18, 6)), CAST(-79.405097 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2T6', CAST(43.870468 AS Decimal(18, 6)), CAST(-79.403921 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2T7', CAST(43.872640 AS Decimal(18, 6)), CAST(-79.405816 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2T8', CAST(43.872286 AS Decimal(18, 6)), CAST(-79.404753 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2T9', CAST(43.872708 AS Decimal(18, 6)), CAST(-79.407028 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2V1', CAST(43.872799 AS Decimal(18, 6)), CAST(-79.402253 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2V2', CAST(43.872278 AS Decimal(18, 6)), CAST(-79.402810 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2V3', CAST(43.875902 AS Decimal(18, 6)), CAST(-79.409193 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2V4', CAST(43.864680 AS Decimal(18, 6)), CAST(-79.406779 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2V5', CAST(43.864906 AS Decimal(18, 6)), CAST(-79.406336 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2V6', CAST(43.865409 AS Decimal(18, 6)), CAST(-79.406845 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2V7', CAST(43.865561 AS Decimal(18, 6)), CAST(-79.404754 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2V8', CAST(43.866693 AS Decimal(18, 6)), CAST(-79.403937 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2V9', CAST(43.867299 AS Decimal(18, 6)), CAST(-79.401547 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2W1', CAST(43.866726 AS Decimal(18, 6)), CAST(-79.402257 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2W2', CAST(43.864929 AS Decimal(18, 6)), CAST(-79.404375 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2W3', CAST(43.864406 AS Decimal(18, 6)), CAST(-79.404865 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2W4', CAST(43.865230 AS Decimal(18, 6)), CAST(-79.403547 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2W5', CAST(43.865858 AS Decimal(18, 6)), CAST(-79.403090 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2W6', CAST(43.865057 AS Decimal(18, 6)), CAST(-79.402347 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2W7', CAST(43.866231 AS Decimal(18, 6)), CAST(-79.401960 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2W8', CAST(43.861991 AS Decimal(18, 6)), CAST(-79.402116 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2W9', CAST(43.861440 AS Decimal(18, 6)), CAST(-79.401363 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2X1', CAST(43.861295 AS Decimal(18, 6)), CAST(-79.402244 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2X2', CAST(43.860558 AS Decimal(18, 6)), CAST(-79.401739 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2X3', CAST(43.860135 AS Decimal(18, 6)), CAST(-79.400471 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2X4', CAST(43.861230 AS Decimal(18, 6)), CAST(-79.399624 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2X5', CAST(43.860820 AS Decimal(18, 6)), CAST(-79.399885 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2X6', CAST(43.861580 AS Decimal(18, 6)), CAST(-79.400024 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2X7', CAST(43.862489 AS Decimal(18, 6)), CAST(-79.400247 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2X8', CAST(43.862027 AS Decimal(18, 6)), CAST(-79.397811 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2X9', CAST(43.862324 AS Decimal(18, 6)), CAST(-79.397855 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2Y1', CAST(43.861073 AS Decimal(18, 6)), CAST(-79.396503 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2Y2', CAST(43.862170 AS Decimal(18, 6)), CAST(-79.396538 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2Y3', CAST(43.863689 AS Decimal(18, 6)), CAST(-79.398636 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2Y4', CAST(43.863740 AS Decimal(18, 6)), CAST(-79.398693 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2Y5', CAST(43.864649 AS Decimal(18, 6)), CAST(-79.398492 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2Y6', CAST(43.866352 AS Decimal(18, 6)), CAST(-79.400687 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2Y7', CAST(43.865777 AS Decimal(18, 6)), CAST(-79.400237 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2Y8', CAST(43.867945 AS Decimal(18, 6)), CAST(-79.400735 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2Y9', CAST(43.868759 AS Decimal(18, 6)), CAST(-79.400261 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2Z1', CAST(43.874282 AS Decimal(18, 6)), CAST(-79.404001 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2Z2', CAST(43.874800 AS Decimal(18, 6)), CAST(-79.402865 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2Z3', CAST(43.873347 AS Decimal(18, 6)), CAST(-79.402144 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2Z4', CAST(43.873494 AS Decimal(18, 6)), CAST(-79.402724 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2Z5', CAST(43.876452 AS Decimal(18, 6)), CAST(-79.405843 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2Z6', CAST(43.853929 AS Decimal(18, 6)), CAST(-79.401425 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2Z7', CAST(43.854782 AS Decimal(18, 6)), CAST(-79.400791 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2Z8', CAST(43.855003 AS Decimal(18, 6)), CAST(-79.400947 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B2Z9', CAST(43.854185 AS Decimal(18, 6)), CAST(-79.400226 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3A1', CAST(43.855090 AS Decimal(18, 6)), CAST(-79.398666 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3A2', CAST(43.855111 AS Decimal(18, 6)), CAST(-79.400499 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3A3', CAST(43.849158 AS Decimal(18, 6)), CAST(-79.403371 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3A4', CAST(43.848490 AS Decimal(18, 6)), CAST(-79.403073 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3A5', CAST(43.847916 AS Decimal(18, 6)), CAST(-79.403212 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3A6', CAST(43.849113 AS Decimal(18, 6)), CAST(-79.399374 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3A7', CAST(43.854196 AS Decimal(18, 6)), CAST(-79.393295 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3A8', CAST(43.845491 AS Decimal(18, 6)), CAST(-79.385978 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3A9', CAST(43.848009 AS Decimal(18, 6)), CAST(-79.385560 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3B1', CAST(43.844387 AS Decimal(18, 6)), CAST(-79.385695 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3B2', CAST(43.814242 AS Decimal(18, 6)), CAST(-79.355135 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3B3', CAST(43.860931 AS Decimal(18, 6)), CAST(-79.380361 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3B4', CAST(43.847275 AS Decimal(18, 6)), CAST(-79.377382 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3B5', CAST(43.860688 AS Decimal(18, 6)), CAST(-79.379889 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3B6', CAST(43.900084 AS Decimal(18, 6)), CAST(-79.395428 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3B7', CAST(43.873895 AS Decimal(18, 6)), CAST(-79.409639 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3B8', CAST(43.874887 AS Decimal(18, 6)), CAST(-79.411772 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3B9', CAST(43.873270 AS Decimal(18, 6)), CAST(-79.411159 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3C1', CAST(43.874530 AS Decimal(18, 6)), CAST(-79.413462 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3C2', CAST(43.872346 AS Decimal(18, 6)), CAST(-79.413366 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3C3', CAST(43.873831 AS Decimal(18, 6)), CAST(-79.407627 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3C4', CAST(43.865519 AS Decimal(18, 6)), CAST(-79.402384 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3C5', CAST(43.875057 AS Decimal(18, 6)), CAST(-79.404664 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3C6', CAST(43.857637 AS Decimal(18, 6)), CAST(-79.402508 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3C7', CAST(43.856958 AS Decimal(18, 6)), CAST(-79.404538 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3C8', CAST(43.857722 AS Decimal(18, 6)), CAST(-79.405327 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3C9', CAST(43.857827 AS Decimal(18, 6)), CAST(-79.404737 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3E1', CAST(43.856581 AS Decimal(18, 6)), CAST(-79.406805 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3E2', CAST(43.859870 AS Decimal(18, 6)), CAST(-79.391970 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3E3', CAST(43.860192 AS Decimal(18, 6)), CAST(-79.391732 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3E4', CAST(43.860081 AS Decimal(18, 6)), CAST(-79.393809 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3E5', CAST(43.857964 AS Decimal(18, 6)), CAST(-79.406755 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3E6', CAST(43.866179 AS Decimal(18, 6)), CAST(-79.402219 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3E7', CAST(43.859813 AS Decimal(18, 6)), CAST(-79.394860 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3E8', CAST(43.858641 AS Decimal(18, 6)), CAST(-79.396843 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3E9', CAST(43.774428 AS Decimal(18, 6)), CAST(-79.459437 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3G1', CAST(43.858591 AS Decimal(18, 6)), CAST(-79.398086 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3G2', CAST(43.862295 AS Decimal(18, 6)), CAST(-79.381814 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3G3', CAST(43.862195 AS Decimal(18, 6)), CAST(-79.381612 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3G4', CAST(43.862177 AS Decimal(18, 6)), CAST(-79.393791 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3G5', CAST(43.863599 AS Decimal(18, 6)), CAST(-79.392001 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3G6', CAST(43.862493 AS Decimal(18, 6)), CAST(-79.389137 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3G7', CAST(43.862317 AS Decimal(18, 6)), CAST(-79.391331 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3G8', CAST(43.863387 AS Decimal(18, 6)), CAST(-79.394982 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3G9', CAST(43.864157 AS Decimal(18, 6)), CAST(-79.395730 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3H1', CAST(43.865398 AS Decimal(18, 6)), CAST(-79.395033 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3H2', CAST(43.864648 AS Decimal(18, 6)), CAST(-79.397350 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3H3', CAST(43.865955 AS Decimal(18, 6)), CAST(-79.396073 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3H4', CAST(43.867307 AS Decimal(18, 6)), CAST(-79.396840 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3H5', CAST(43.867307 AS Decimal(18, 6)), CAST(-79.399807 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3H6', CAST(43.861123 AS Decimal(18, 6)), CAST(-79.386443 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3H7', CAST(43.853136 AS Decimal(18, 6)), CAST(-79.399079 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3H8', CAST(43.849089 AS Decimal(18, 6)), CAST(-79.397633 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3H9', CAST(43.848796 AS Decimal(18, 6)), CAST(-79.399384 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3J1', CAST(43.870466 AS Decimal(18, 6)), CAST(-79.400753 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3J2', CAST(43.870429 AS Decimal(18, 6)), CAST(-79.399110 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3J3', CAST(43.869109 AS Decimal(18, 6)), CAST(-79.397366 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3J4', CAST(43.848576 AS Decimal(18, 6)), CAST(-79.400890 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3J5', CAST(43.849851 AS Decimal(18, 6)), CAST(-79.400330 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3J6', CAST(43.847188 AS Decimal(18, 6)), CAST(-79.376490 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3J7', CAST(43.847965 AS Decimal(18, 6)), CAST(-79.408063 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3J8', CAST(43.848887 AS Decimal(18, 6)), CAST(-79.402148 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3J9', CAST(43.856981 AS Decimal(18, 6)), CAST(-79.385517 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3K0', CAST(43.850156 AS Decimal(18, 6)), CAST(-79.377283 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3K1', CAST(43.855295 AS Decimal(18, 6)), CAST(-79.390965 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3K2', CAST(43.844781 AS Decimal(18, 6)), CAST(-79.394508 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3K3', CAST(43.848397 AS Decimal(18, 6)), CAST(-79.383496 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3K4', CAST(43.865681 AS Decimal(18, 6)), CAST(-79.381238 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3K5', CAST(43.865972 AS Decimal(18, 6)), CAST(-79.380651 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3K6', CAST(43.866651 AS Decimal(18, 6)), CAST(-79.381217 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3K7', CAST(43.865301 AS Decimal(18, 6)), CAST(-79.383575 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3K8', CAST(43.865273 AS Decimal(18, 6)), CAST(-79.383722 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3K9', CAST(43.862916 AS Decimal(18, 6)), CAST(-79.385620 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3L1', CAST(43.865933 AS Decimal(18, 6)), CAST(-79.380863 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3L2', CAST(43.854381 AS Decimal(18, 6)), CAST(-79.378482 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3L3', CAST(43.851659 AS Decimal(18, 6)), CAST(-79.377964 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3L4', CAST(43.784383 AS Decimal(18, 6)), CAST(-79.335683 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3L5', CAST(43.854199 AS Decimal(18, 6)), CAST(-79.407575 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3L6', CAST(43.856403 AS Decimal(18, 6)), CAST(-79.387870 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3L7', CAST(43.850130 AS Decimal(18, 6)), CAST(-79.402845 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3L8', CAST(43.852946 AS Decimal(18, 6)), CAST(-79.384630 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3L9', CAST(43.854137 AS Decimal(18, 6)), CAST(-79.385396 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3M1', CAST(43.846334 AS Decimal(18, 6)), CAST(-79.387245 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3M2', CAST(43.863279 AS Decimal(18, 6)), CAST(-79.397350 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3M3', CAST(43.857002 AS Decimal(18, 6)), CAST(-79.385059 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3M4', CAST(43.852726 AS Decimal(18, 6)), CAST(-79.384537 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3M5', CAST(43.853502 AS Decimal(18, 6)), CAST(-79.409852 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3M6', CAST(43.851212 AS Decimal(18, 6)), CAST(-79.409335 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3M7', CAST(43.842870 AS Decimal(18, 6)), CAST(-79.407177 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3M8', CAST(43.849245 AS Decimal(18, 6)), CAST(-79.407863 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3M9', CAST(43.854953 AS Decimal(18, 6)), CAST(-79.410334 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3N1', CAST(43.856855 AS Decimal(18, 6)), CAST(-79.413612 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3N2', CAST(43.840922 AS Decimal(18, 6)), CAST(-79.397882 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3N3', CAST(43.841428 AS Decimal(18, 6)), CAST(-79.398441 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3N4', CAST(43.857627 AS Decimal(18, 6)), CAST(-79.388104 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3N5', CAST(43.852784 AS Decimal(18, 6)), CAST(-79.407446 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3N6', CAST(43.870707 AS Decimal(18, 6)), CAST(-79.381348 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3N7', CAST(43.866055 AS Decimal(18, 6)), CAST(-79.387911 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3N8', CAST(43.847784 AS Decimal(18, 6)), CAST(-79.404383 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3N9', CAST(43.862896 AS Decimal(18, 6)), CAST(-79.384468 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3P1', CAST(43.864338 AS Decimal(18, 6)), CAST(-79.378414 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3P2', CAST(43.844839 AS Decimal(18, 6)), CAST(-79.380290 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3P3', CAST(43.847569 AS Decimal(18, 6)), CAST(-79.378625 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3P4', CAST(43.845838 AS Decimal(18, 6)), CAST(-79.387081 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3P5', CAST(43.846747 AS Decimal(18, 6)), CAST(-79.387316 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3P6', CAST(43.865851 AS Decimal(18, 6)), CAST(-79.381174 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3P7', CAST(43.840485 AS Decimal(18, 6)), CAST(-79.399787 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3P8', CAST(43.846040 AS Decimal(18, 6)), CAST(-79.408604 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3P9', CAST(43.851650 AS Decimal(18, 6)), CAST(-79.420927 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3R1', CAST(43.851270 AS Decimal(18, 6)), CAST(-79.419824 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3R2', CAST(43.851869 AS Decimal(18, 6)), CAST(-79.417986 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3R3', CAST(43.850477 AS Decimal(18, 6)), CAST(-79.417103 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3R4', CAST(43.852147 AS Decimal(18, 6)), CAST(-79.417050 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3R5', CAST(43.852853 AS Decimal(18, 6)), CAST(-79.415358 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3R6', CAST(43.850956 AS Decimal(18, 6)), CAST(-79.414439 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3R7', CAST(43.849658 AS Decimal(18, 6)), CAST(-79.415007 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3R8', CAST(43.852849 AS Decimal(18, 6)), CAST(-79.412656 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3R9', CAST(43.851560 AS Decimal(18, 6)), CAST(-79.411470 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3S1', CAST(43.850202 AS Decimal(18, 6)), CAST(-79.411194 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3S2', CAST(43.850500 AS Decimal(18, 6)), CAST(-79.411154 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3S3', CAST(43.852978 AS Decimal(18, 6)), CAST(-79.411113 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3S4', CAST(43.850867 AS Decimal(18, 6)), CAST(-79.401029 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3S5', CAST(43.855410 AS Decimal(18, 6)), CAST(-79.421132 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3S6', CAST(43.849291 AS Decimal(18, 6)), CAST(-79.424643 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3S7', CAST(43.849029 AS Decimal(18, 6)), CAST(-79.422103 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3S8', CAST(43.848931 AS Decimal(18, 6)), CAST(-79.425435 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3S9', CAST(43.848307 AS Decimal(18, 6)), CAST(-79.422664 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3T1', CAST(43.848345 AS Decimal(18, 6)), CAST(-79.415157 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3T2', CAST(43.848402 AS Decimal(18, 6)), CAST(-79.416490 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3T3', CAST(43.846336 AS Decimal(18, 6)), CAST(-79.424472 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3T4', CAST(43.846012 AS Decimal(18, 6)), CAST(-79.421341 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3T5', CAST(43.846013 AS Decimal(18, 6)), CAST(-79.421341 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3T6', CAST(43.845257 AS Decimal(18, 6)), CAST(-79.411855 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3T7', CAST(43.846614 AS Decimal(18, 6)), CAST(-79.413348 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3T8', CAST(43.846727 AS Decimal(18, 6)), CAST(-79.411033 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3T9', CAST(43.845943 AS Decimal(18, 6)), CAST(-79.411408 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3V1', CAST(43.845013 AS Decimal(18, 6)), CAST(-79.407728 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3V2', CAST(43.849886 AS Decimal(18, 6)), CAST(-79.377283 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3V3', CAST(43.862587 AS Decimal(18, 6)), CAST(-79.385305 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3V4', CAST(43.844409 AS Decimal(18, 6)), CAST(-79.393683 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3V5', CAST(43.844831 AS Decimal(18, 6)), CAST(-79.394352 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3V6', CAST(43.844313 AS Decimal(18, 6)), CAST(-79.395778 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3V7', CAST(43.869113 AS Decimal(18, 6)), CAST(-79.390395 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3V8', CAST(43.869420 AS Decimal(18, 6)), CAST(-79.393300 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3V9', CAST(43.870226 AS Decimal(18, 6)), CAST(-79.390794 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3W1', CAST(43.871082 AS Decimal(18, 6)), CAST(-79.392376 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3W2', CAST(43.872227 AS Decimal(18, 6)), CAST(-79.393647 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3W3', CAST(43.872917 AS Decimal(18, 6)), CAST(-79.392396 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3W4', CAST(43.872760 AS Decimal(18, 6)), CAST(-79.394557 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3W5', CAST(43.873567 AS Decimal(18, 6)), CAST(-79.392563 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3W6', CAST(43.874340 AS Decimal(18, 6)), CAST(-79.390751 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3W7', CAST(43.870493 AS Decimal(18, 6)), CAST(-79.392727 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3W8', CAST(43.870712 AS Decimal(18, 6)), CAST(-79.395163 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3W9', CAST(43.872248 AS Decimal(18, 6)), CAST(-79.397045 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3X1', CAST(43.854904 AS Decimal(18, 6)), CAST(-79.380956 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3X2', CAST(43.849131 AS Decimal(18, 6)), CAST(-79.398860 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3X3', CAST(43.870901 AS Decimal(18, 6)), CAST(-79.411873 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3X4', CAST(43.875512 AS Decimal(18, 6)), CAST(-79.391524 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3X5', CAST(43.875141 AS Decimal(18, 6)), CAST(-79.394529 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3X6', CAST(43.874875 AS Decimal(18, 6)), CAST(-79.396025 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3X7', CAST(43.873813 AS Decimal(18, 6)), CAST(-79.395567 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3X8', CAST(43.840221 AS Decimal(18, 6)), CAST(-79.403082 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3X9', CAST(43.919364 AS Decimal(18, 6)), CAST(-79.388645 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3Y1', CAST(43.877620 AS Decimal(18, 6)), CAST(-79.390806 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3Y2', CAST(43.862632 AS Decimal(18, 6)), CAST(-79.381469 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3Y3', CAST(43.877026 AS Decimal(18, 6)), CAST(-79.390641 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3Y4', CAST(43.873424 AS Decimal(18, 6)), CAST(-79.389680 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3Y5', CAST(43.867161 AS Decimal(18, 6)), CAST(-79.387890 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3Y6', CAST(43.874352 AS Decimal(18, 6)), CAST(-79.383682 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3Y7', CAST(43.841214 AS Decimal(18, 6)), CAST(-79.396624 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3Y8', CAST(43.851651 AS Decimal(18, 6)), CAST(-79.398494 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3Y9', CAST(43.844839 AS Decimal(18, 6)), CAST(-79.387040 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3Z1', CAST(43.780958 AS Decimal(18, 6)), CAST(-79.413060 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3Z2', CAST(43.850880 AS Decimal(18, 6)), CAST(-79.398146 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3Z3', CAST(43.854140 AS Decimal(18, 6)), CAST(-79.378242 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3Z4', CAST(43.842036 AS Decimal(18, 6)), CAST(-79.394177 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3Z5', CAST(43.873072 AS Decimal(18, 6)), CAST(-79.399549 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3Z6', CAST(43.873157 AS Decimal(18, 6)), CAST(-79.398727 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3Z7', CAST(43.875907 AS Decimal(18, 6)), CAST(-79.399291 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3Z8', CAST(43.876318 AS Decimal(18, 6)), CAST(-79.394577 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B3Z9', CAST(43.877107 AS Decimal(18, 6)), CAST(-79.395878 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4A1', CAST(43.877188 AS Decimal(18, 6)), CAST(-79.391717 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4A2', CAST(43.861944 AS Decimal(18, 6)), CAST(-79.379407 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4A3', CAST(43.847668 AS Decimal(18, 6)), CAST(-79.383029 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4A4', CAST(43.862660 AS Decimal(18, 6)), CAST(-79.427625 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4A5', CAST(43.854065 AS Decimal(18, 6)), CAST(-79.414341 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4A6', CAST(43.854512 AS Decimal(18, 6)), CAST(-79.410770 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4A7', CAST(43.848175 AS Decimal(18, 6)), CAST(-79.376810 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4A8', CAST(43.855142 AS Decimal(18, 6)), CAST(-79.378441 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4A9', CAST(43.864341 AS Decimal(18, 6)), CAST(-79.378414 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4B1', CAST(43.862674 AS Decimal(18, 6)), CAST(-79.385466 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4B3', CAST(43.862632 AS Decimal(18, 6)), CAST(-79.381469 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4B4', CAST(43.877292 AS Decimal(18, 6)), CAST(-79.400135 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4B5', CAST(43.871750 AS Decimal(18, 6)), CAST(-79.402791 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4B6', CAST(43.876855 AS Decimal(18, 6)), CAST(-79.402150 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4B7', CAST(43.867377 AS Decimal(18, 6)), CAST(-79.392760 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4B8', CAST(43.865324 AS Decimal(18, 6)), CAST(-79.390530 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4B9', CAST(43.865972 AS Decimal(18, 6)), CAST(-79.389043 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4C2', CAST(43.863672 AS Decimal(18, 6)), CAST(-79.385822 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4C3', CAST(43.843035 AS Decimal(18, 6)), CAST(-79.402612 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4C4', CAST(43.872627 AS Decimal(18, 6)), CAST(-79.389527 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4C5', CAST(43.848915 AS Decimal(18, 6)), CAST(-79.408775 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4C6', CAST(43.863649 AS Decimal(18, 6)), CAST(-79.381761 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4C7', CAST(43.853087 AS Decimal(18, 6)), CAST(-79.418010 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4C8', CAST(43.852710 AS Decimal(18, 6)), CAST(-79.384839 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4C9', CAST(43.850804 AS Decimal(18, 6)), CAST(-79.430809 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4E1', CAST(43.847483 AS Decimal(18, 6)), CAST(-79.429716 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4E2', CAST(43.848092 AS Decimal(18, 6)), CAST(-79.430234 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4E3', CAST(43.849217 AS Decimal(18, 6)), CAST(-79.430611 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4E4', CAST(43.849106 AS Decimal(18, 6)), CAST(-79.429763 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4E5', CAST(43.851140 AS Decimal(18, 6)), CAST(-79.431337 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4E6', CAST(43.850403 AS Decimal(18, 6)), CAST(-79.431739 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4E7', CAST(43.877883 AS Decimal(18, 6)), CAST(-79.395141 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4E8', CAST(43.878061 AS Decimal(18, 6)), CAST(-79.396162 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4E9', CAST(43.847225 AS Decimal(18, 6)), CAST(-79.414894 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4G1', CAST(43.846403 AS Decimal(18, 6)), CAST(-79.415657 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4G2', CAST(43.846120 AS Decimal(18, 6)), CAST(-79.408950 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4G3', CAST(43.846457 AS Decimal(18, 6)), CAST(-79.409709 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4G4', CAST(43.845325 AS Decimal(18, 6)), CAST(-79.410264 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4G5', CAST(43.848464 AS Decimal(18, 6)), CAST(-79.418645 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4G6', CAST(43.844068 AS Decimal(18, 6)), CAST(-79.415214 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4G7', CAST(43.848271 AS Decimal(18, 6)), CAST(-79.417702 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4G8', CAST(43.846707 AS Decimal(18, 6)), CAST(-79.412378 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4G9', CAST(43.848550 AS Decimal(18, 6)), CAST(-79.419404 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4H1', CAST(43.844641 AS Decimal(18, 6)), CAST(-79.412642 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4H2', CAST(43.844600 AS Decimal(18, 6)), CAST(-79.413744 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4H3', CAST(43.844776 AS Decimal(18, 6)), CAST(-79.414543 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4H4', CAST(43.844407 AS Decimal(18, 6)), CAST(-79.414406 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4H5', CAST(43.845737 AS Decimal(18, 6)), CAST(-79.415807 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4H6', CAST(43.846831 AS Decimal(18, 6)), CAST(-79.417076 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4H7', CAST(43.847211 AS Decimal(18, 6)), CAST(-79.418140 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4H8', CAST(43.846995 AS Decimal(18, 6)), CAST(-79.418953 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4H9', CAST(43.846234 AS Decimal(18, 6)), CAST(-79.422792 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4J1', CAST(43.847567 AS Decimal(18, 6)), CAST(-79.420739 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4J2', CAST(43.848527 AS Decimal(18, 6)), CAST(-79.421125 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4J3', CAST(43.861769 AS Decimal(18, 6)), CAST(-79.377145 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4J4', CAST(43.846779 AS Decimal(18, 6)), CAST(-79.430847 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4J5', CAST(43.845143 AS Decimal(18, 6)), CAST(-79.429397 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4J6', CAST(43.844995 AS Decimal(18, 6)), CAST(-79.428816 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4J7', CAST(43.845347 AS Decimal(18, 6)), CAST(-79.430081 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4J8', CAST(43.847700 AS Decimal(18, 6)), CAST(-79.383087 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4J9', CAST(43.845855 AS Decimal(18, 6)), CAST(-79.417456 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4K1', CAST(43.840678 AS Decimal(18, 6)), CAST(-79.421994 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4K2', CAST(43.863707 AS Decimal(18, 6)), CAST(-79.381739 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4K3', CAST(43.849800 AS Decimal(18, 6)), CAST(-79.383748 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4K4', CAST(43.843244 AS Decimal(18, 6)), CAST(-79.415774 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4K5', CAST(43.844328 AS Decimal(18, 6)), CAST(-79.416070 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4K6', CAST(43.843091 AS Decimal(18, 6)), CAST(-79.416282 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4K7', CAST(43.844480 AS Decimal(18, 6)), CAST(-79.417030 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4K8', CAST(43.843280 AS Decimal(18, 6)), CAST(-79.417476 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4K9', CAST(43.843916 AS Decimal(18, 6)), CAST(-79.417723 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4L1', CAST(43.844352 AS Decimal(18, 6)), CAST(-79.419519 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4L2', CAST(43.843539 AS Decimal(18, 6)), CAST(-79.418667 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4L3', CAST(43.844010 AS Decimal(18, 6)), CAST(-79.419609 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4L4', CAST(43.844516 AS Decimal(18, 6)), CAST(-79.420023 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4L5', CAST(43.845092 AS Decimal(18, 6)), CAST(-79.417808 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4L6', CAST(43.845190 AS Decimal(18, 6)), CAST(-79.415996 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4L7', CAST(43.843131 AS Decimal(18, 6)), CAST(-79.419290 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4L8', CAST(43.851030 AS Decimal(18, 6)), CAST(-79.430609 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4L9', CAST(43.841741 AS Decimal(18, 6)), CAST(-79.428971 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4M1', CAST(43.845352 AS Decimal(18, 6)), CAST(-79.416437 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4M2', CAST(43.844923 AS Decimal(18, 6)), CAST(-79.407965 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4M3', CAST(43.844646 AS Decimal(18, 6)), CAST(-79.428462 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4M4', CAST(43.851789 AS Decimal(18, 6)), CAST(-79.430218 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4M5', CAST(43.850342 AS Decimal(18, 6)), CAST(-79.431670 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4M6', CAST(43.846878 AS Decimal(18, 6)), CAST(-79.426678 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4M7', CAST(43.846338 AS Decimal(18, 6)), CAST(-79.418044 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4M8', CAST(43.845863 AS Decimal(18, 6)), CAST(-79.419270 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4M9', CAST(43.858625 AS Decimal(18, 6)), CAST(-79.401875 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4N1', CAST(43.855416 AS Decimal(18, 6)), CAST(-79.385051 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4N2', CAST(43.847366 AS Decimal(18, 6)), CAST(-79.430417 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4N3', CAST(43.864308 AS Decimal(18, 6)), CAST(-79.400733 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4N4', CAST(43.862632 AS Decimal(18, 6)), CAST(-79.381469 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4N5', CAST(43.842570 AS Decimal(18, 6)), CAST(-79.419916 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4N6', CAST(43.862916 AS Decimal(18, 6)), CAST(-79.385620 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4N7', CAST(43.842193 AS Decimal(18, 6)), CAST(-79.427989 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4N8', CAST(43.862965 AS Decimal(18, 6)), CAST(-79.377766 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4N9', CAST(43.847315 AS Decimal(18, 6)), CAST(-79.421389 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4P1', CAST(43.847309 AS Decimal(18, 6)), CAST(-79.422963 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4P2', CAST(43.847258 AS Decimal(18, 6)), CAST(-79.421795 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4P3', CAST(43.848354 AS Decimal(18, 6)), CAST(-79.424295 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4P4', CAST(43.848252 AS Decimal(18, 6)), CAST(-79.426954 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4P5', CAST(43.847338 AS Decimal(18, 6)), CAST(-79.424954 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4P6', CAST(43.845082 AS Decimal(18, 6)), CAST(-79.429896 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4P7', CAST(43.857577 AS Decimal(18, 6)), CAST(-79.380032 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4P8', CAST(43.876052 AS Decimal(18, 6)), CAST(-79.396197 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4P9', CAST(43.853865 AS Decimal(18, 6)), CAST(-79.428091 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4R1', CAST(43.852347 AS Decimal(18, 6)), CAST(-79.421115 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4R2', CAST(43.844061 AS Decimal(18, 6)), CAST(-79.409651 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4R3', CAST(43.848829 AS Decimal(18, 6)), CAST(-79.377565 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4R4', CAST(43.849829 AS Decimal(18, 6)), CAST(-79.389995 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4R5', CAST(43.849029 AS Decimal(18, 6)), CAST(-79.388543 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4R6', CAST(43.849132 AS Decimal(18, 6)), CAST(-79.398860 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4R7', CAST(43.849133 AS Decimal(18, 6)), CAST(-79.398860 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4R8', CAST(43.920126 AS Decimal(18, 6)), CAST(-79.399481 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4R9', CAST(43.843638 AS Decimal(18, 6)), CAST(-79.386520 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4S1', CAST(43.846932 AS Decimal(18, 6)), CAST(-79.421030 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4S2', CAST(43.848240 AS Decimal(18, 6)), CAST(-79.420505 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4S3', CAST(43.849136 AS Decimal(18, 6)), CAST(-79.398860 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4S4', CAST(43.846435 AS Decimal(18, 6)), CAST(-79.423038 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4S5', CAST(43.847029 AS Decimal(18, 6)), CAST(-79.424569 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4S6', CAST(43.846454 AS Decimal(18, 6)), CAST(-79.424876 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4S7', CAST(43.846413 AS Decimal(18, 6)), CAST(-79.426188 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4S8', CAST(43.846744 AS Decimal(18, 6)), CAST(-79.425592 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4S9', CAST(43.847009 AS Decimal(18, 6)), CAST(-79.427407 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4T1', CAST(43.847576 AS Decimal(18, 6)), CAST(-79.427175 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4T2', CAST(43.848699 AS Decimal(18, 6)), CAST(-79.427971 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4T3', CAST(43.849015 AS Decimal(18, 6)), CAST(-79.427805 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4T4', CAST(43.849738 AS Decimal(18, 6)), CAST(-79.427650 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4T5', CAST(43.849671 AS Decimal(18, 6)), CAST(-79.426939 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4T6', CAST(43.846056 AS Decimal(18, 6)), CAST(-79.422520 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4T7', CAST(43.846657 AS Decimal(18, 6)), CAST(-79.422227 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4T8', CAST(43.845228 AS Decimal(18, 6)), CAST(-79.424759 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4T9', CAST(43.843638 AS Decimal(18, 6)), CAST(-79.424814 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4V1', CAST(43.854140 AS Decimal(18, 6)), CAST(-79.378242 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4V2', CAST(43.868372 AS Decimal(18, 6)), CAST(-79.389044 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4V3', CAST(43.866933 AS Decimal(18, 6)), CAST(-79.388868 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4V4', CAST(43.866950 AS Decimal(18, 6)), CAST(-79.392461 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4V5', CAST(43.841171 AS Decimal(18, 6)), CAST(-79.414530 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4V6', CAST(43.853872 AS Decimal(18, 6)), CAST(-79.409599 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4V7', CAST(43.855781 AS Decimal(18, 6)), CAST(-79.409618 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4V8', CAST(43.851600 AS Decimal(18, 6)), CAST(-79.392905 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4V9', CAST(43.844163 AS Decimal(18, 6)), CAST(-79.408027 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4W1', CAST(43.875887 AS Decimal(18, 6)), CAST(-79.438860 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4W2', CAST(43.855304 AS Decimal(18, 6)), CAST(-79.378591 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4W3', CAST(43.874301 AS Decimal(18, 6)), CAST(-79.385530 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4W4', CAST(43.848126 AS Decimal(18, 6)), CAST(-79.408530 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4W5', CAST(43.862064 AS Decimal(18, 6)), CAST(-79.388036 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4W6', CAST(43.874049 AS Decimal(18, 6)), CAST(-79.385029 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4W7', CAST(43.841440 AS Decimal(18, 6)), CAST(-79.414274 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4X7', CAST(43.876195 AS Decimal(18, 6)), CAST(-79.412273 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4Y1', CAST(43.859453 AS Decimal(18, 6)), CAST(-79.402858 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B4Y5', CAST(43.859453 AS Decimal(18, 6)), CAST(-79.402858 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'l4b5b7', CAST(43.941024 AS Decimal(18, 6)), CAST(-79.426606 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B5B8', CAST(43.939369 AS Decimal(18, 6)), CAST(-79.440903 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B5E3', CAST(43.939988 AS Decimal(18, 6)), CAST(-79.429495 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B5E6', CAST(43.859453 AS Decimal(18, 6)), CAST(-79.402858 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B5J3', CAST(43.858408 AS Decimal(18, 6)), CAST(-79.391605 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B5Y8', CAST(43.859453 AS Decimal(18, 6)), CAST(-79.402858 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B5Y9', CAST(43.873880 AS Decimal(18, 6)), CAST(-79.387770 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B6W5', CAST(43.865004 AS Decimal(18, 6)), CAST(-79.402090 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B7H3', CAST(43.859453 AS Decimal(18, 6)), CAST(-79.402858 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B7H4', CAST(43.859453 AS Decimal(18, 6)), CAST(-79.402858 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B7H5', CAST(43.859453 AS Decimal(18, 6)), CAST(-79.402858 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B7H6', CAST(43.859453 AS Decimal(18, 6)), CAST(-79.402858 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B7H8', CAST(43.859453 AS Decimal(18, 6)), CAST(-79.402858 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B7P6', CAST(43.845568 AS Decimal(18, 6)), CAST(-79.429779 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B8A3', CAST(43.859453 AS Decimal(18, 6)), CAST(-79.402858 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B8C2', CAST(43.794287 AS Decimal(18, 6)), CAST(-79.437764 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4B9P7', CAST(43.859453 AS Decimal(18, 6)), CAST(-79.402858 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0A1', CAST(43.894145 AS Decimal(18, 6)), CAST(-79.436629 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0A2', CAST(43.868316 AS Decimal(18, 6)), CAST(-79.412571 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0A3', CAST(43.859302 AS Decimal(18, 6)), CAST(-79.430611 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0A4', CAST(43.878056 AS Decimal(18, 6)), CAST(-79.440783 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0A5', CAST(43.860797 AS Decimal(18, 6)), CAST(-79.431903 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0A6', CAST(43.866619 AS Decimal(18, 6)), CAST(-79.421784 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0A7', CAST(43.867041 AS Decimal(18, 6)), CAST(-79.419145 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0A8', CAST(43.856610 AS Decimal(18, 6)), CAST(-79.429298 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0A9', CAST(43.889297 AS Decimal(18, 6)), CAST(-79.432168 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0B1', CAST(43.880281 AS Decimal(18, 6)), CAST(-79.438655 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0B2', CAST(43.880238 AS Decimal(18, 6)), CAST(-79.438857 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0B3', CAST(43.859260 AS Decimal(18, 6)), CAST(-79.455450 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0B4', CAST(43.856606 AS Decimal(18, 6)), CAST(-79.423694 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0B5', CAST(43.857725 AS Decimal(18, 6)), CAST(-79.423638 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0B6', CAST(43.857312 AS Decimal(18, 6)), CAST(-79.424941 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0B7', CAST(43.857512 AS Decimal(18, 6)), CAST(-79.426446 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0B8', CAST(43.856694 AS Decimal(18, 6)), CAST(-79.425861 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0B9', CAST(43.856634 AS Decimal(18, 6)), CAST(-79.425128 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0C0', CAST(43.865013 AS Decimal(18, 6)), CAST(-79.437284 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0C1', CAST(43.868836 AS Decimal(18, 6)), CAST(-79.440161 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0C2', CAST(43.848620 AS Decimal(18, 6)), CAST(-79.447715 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0C3', CAST(43.856256 AS Decimal(18, 6)), CAST(-79.426306 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0C4', CAST(43.874290 AS Decimal(18, 6)), CAST(-79.430185 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0C5', CAST(43.847597 AS Decimal(18, 6)), CAST(-79.486158 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0C6', CAST(43.881891 AS Decimal(18, 6)), CAST(-79.461185 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0C7', CAST(43.902689 AS Decimal(18, 6)), CAST(-79.371314 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0C8', CAST(43.856320 AS Decimal(18, 6)), CAST(-79.416020 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0C9', CAST(43.855359 AS Decimal(18, 6)), CAST(-79.436199 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0E1', CAST(43.890501 AS Decimal(18, 6)), CAST(-79.458820 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0E2', CAST(43.891439 AS Decimal(18, 6)), CAST(-79.459070 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0E3', CAST(43.892249 AS Decimal(18, 6)), CAST(-79.461126 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0E4', CAST(43.894268 AS Decimal(18, 6)), CAST(-79.460323 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0E5', CAST(43.892459 AS Decimal(18, 6)), CAST(-79.457769 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0E6', CAST(43.893592 AS Decimal(18, 6)), CAST(-79.462449 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0E7', CAST(43.894693 AS Decimal(18, 6)), CAST(-79.463389 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0E8', CAST(43.895900 AS Decimal(18, 6)), CAST(-79.464499 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0E9', CAST(43.895237 AS Decimal(18, 6)), CAST(-79.461791 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0G1', CAST(43.894747 AS Decimal(18, 6)), CAST(-79.460135 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0G2', CAST(43.895991 AS Decimal(18, 6)), CAST(-79.459393 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0G3', CAST(43.895353 AS Decimal(18, 6)), CAST(-79.460033 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0G4', CAST(43.892934 AS Decimal(18, 6)), CAST(-79.456374 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0G5', CAST(43.893842 AS Decimal(18, 6)), CAST(-79.456225 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0G6', CAST(43.896040 AS Decimal(18, 6)), CAST(-79.455904 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0G7', CAST(43.895433 AS Decimal(18, 6)), CAST(-79.455872 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0G8', CAST(43.895160 AS Decimal(18, 6)), CAST(-79.454155 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0G9', CAST(43.893406 AS Decimal(18, 6)), CAST(-79.454220 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0H1', CAST(43.884245 AS Decimal(18, 6)), CAST(-79.450026 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0H2', CAST(43.872570 AS Decimal(18, 6)), CAST(-79.442234 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0H3', CAST(43.858293 AS Decimal(18, 6)), CAST(-79.448106 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0H4', CAST(43.857326 AS Decimal(18, 6)), CAST(-79.460624 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0H5', CAST(43.870421 AS Decimal(18, 6)), CAST(-79.440727 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0H6', CAST(43.864637 AS Decimal(18, 6)), CAST(-79.430204 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0H7', CAST(43.866307 AS Decimal(18, 6)), CAST(-79.437844 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0H8', CAST(43.893705 AS Decimal(18, 6)), CAST(-79.420674 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0H9', CAST(43.865934 AS Decimal(18, 6)), CAST(-79.423981 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0J1', CAST(43.875960 AS Decimal(18, 6)), CAST(-79.438097 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0J2', CAST(43.854234 AS Decimal(18, 6)), CAST(-79.414432 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0J3', CAST(43.854065 AS Decimal(18, 6)), CAST(-79.414365 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0J4', CAST(43.865428 AS Decimal(18, 6)), CAST(-79.437456 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0J5', CAST(43.852359 AS Decimal(18, 6)), CAST(-79.454691 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0J6', CAST(43.896975 AS Decimal(18, 6)), CAST(-79.445886 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0J7', CAST(43.878985 AS Decimal(18, 6)), CAST(-79.440527 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0J8', CAST(43.859599 AS Decimal(18, 6)), CAST(-79.443414 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0J9', CAST(43.866920 AS Decimal(18, 6)), CAST(-79.444226 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0K1', CAST(43.895967 AS Decimal(18, 6)), CAST(-79.452690 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0K2', CAST(43.895025 AS Decimal(18, 6)), CAST(-79.452388 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0K3', CAST(43.891455 AS Decimal(18, 6)), CAST(-79.458661 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0K4', CAST(43.891865 AS Decimal(18, 6)), CAST(-79.457123 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0K5', CAST(43.891123 AS Decimal(18, 6)), CAST(-79.456790 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0K6', CAST(43.837681 AS Decimal(18, 6)), CAST(-79.429279 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0K7', CAST(43.895347 AS Decimal(18, 6)), CAST(-79.442709 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0K8', CAST(43.895951 AS Decimal(18, 6)), CAST(-79.454426 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0K9', CAST(43.891073 AS Decimal(18, 6)), CAST(-79.419168 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0L1', CAST(43.884811 AS Decimal(18, 6)), CAST(-79.457479 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0L2', CAST(43.848388 AS Decimal(18, 6)), CAST(-79.431348 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0L3', CAST(43.889613 AS Decimal(18, 6)), CAST(-79.441480 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0L4', CAST(43.847080 AS Decimal(18, 6)), CAST(-79.431522 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0L5', CAST(43.845512 AS Decimal(18, 6)), CAST(-79.430753 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0L6', CAST(43.889945 AS Decimal(18, 6)), CAST(-79.442656 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0L7', CAST(43.865616 AS Decimal(18, 6)), CAST(-79.435102 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0L8', CAST(43.892720 AS Decimal(18, 6)), CAST(-79.427094 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0L9', CAST(43.892359 AS Decimal(18, 6)), CAST(-79.458650 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0M1', CAST(43.896037 AS Decimal(18, 6)), CAST(-79.448263 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0M2', CAST(43.848561 AS Decimal(18, 6)), CAST(-79.433890 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0M3', CAST(43.884052 AS Decimal(18, 6)), CAST(-79.460716 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0M4', CAST(43.846867 AS Decimal(18, 6)), CAST(-79.444176 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0M5', CAST(43.873853 AS Decimal(18, 6)), CAST(-79.442619 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0M6', CAST(43.898184 AS Decimal(18, 6)), CAST(-79.443477 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0M7', CAST(43.857299 AS Decimal(18, 6)), CAST(-79.429618 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0M8', CAST(43.889383 AS Decimal(18, 6)), CAST(-79.418301 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0M9', CAST(43.890068 AS Decimal(18, 6)), CAST(-79.418469 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0N1', CAST(43.885503 AS Decimal(18, 6)), CAST(-79.444671 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0N2', CAST(43.886540 AS Decimal(18, 6)), CAST(-79.467952 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0N3', CAST(43.883808 AS Decimal(18, 6)), CAST(-79.467020 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0N4', CAST(43.865343 AS Decimal(18, 6)), CAST(-79.450684 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0N7', CAST(43.864168 AS Decimal(18, 6)), CAST(-79.436626 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0N8', CAST(43.871886 AS Decimal(18, 6)), CAST(-79.440781 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0N9', CAST(43.871887 AS Decimal(18, 6)), CAST(-79.440781 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0P1', CAST(43.871888 AS Decimal(18, 6)), CAST(-79.440781 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0P2', CAST(43.856689 AS Decimal(18, 6)), CAST(-79.411880 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0P3', CAST(43.862127 AS Decimal(18, 6)), CAST(-79.452412 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0P4', CAST(43.890127 AS Decimal(18, 6)), CAST(-79.441680 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0P5', CAST(43.866629 AS Decimal(18, 6)), CAST(-79.436188 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0P6', CAST(43.878344 AS Decimal(18, 6)), CAST(-79.443102 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0P7', CAST(43.870664 AS Decimal(18, 6)), CAST(-79.442618 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0P8', CAST(43.893548 AS Decimal(18, 6)), CAST(-79.449786 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0P9', CAST(43.892566 AS Decimal(18, 6)), CAST(-79.452270 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0R1', CAST(43.893179 AS Decimal(18, 6)), CAST(-79.449669 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0R2', CAST(43.893891 AS Decimal(18, 6)), CAST(-79.446398 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0R3', CAST(43.892076 AS Decimal(18, 6)), CAST(-79.452986 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0R4', CAST(43.892398 AS Decimal(18, 6)), CAST(-79.450080 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0R5', CAST(43.889721 AS Decimal(18, 6)), CAST(-79.441015 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0R6', CAST(43.889612 AS Decimal(18, 6)), CAST(-79.441490 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0R7', CAST(43.867395 AS Decimal(18, 6)), CAST(-79.420394 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0R8', CAST(43.889639 AS Decimal(18, 6)), CAST(-79.441537 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0R9', CAST(43.884053 AS Decimal(18, 6)), CAST(-79.417412 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0S1', CAST(43.899055 AS Decimal(18, 6)), CAST(-79.430469 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0S2', CAST(43.858852 AS Decimal(18, 6)), CAST(-79.455705 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0S3', CAST(43.890055 AS Decimal(18, 6)), CAST(-79.464039 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0S4', CAST(43.889282 AS Decimal(18, 6)), CAST(-79.465678 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0S5', CAST(43.890159 AS Decimal(18, 6)), CAST(-79.466171 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0S6', CAST(43.890476 AS Decimal(18, 6)), CAST(-79.466517 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0S7', CAST(43.896918 AS Decimal(18, 6)), CAST(-79.443169 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0S8', CAST(43.891171 AS Decimal(18, 6)), CAST(-79.452757 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0S9', CAST(43.890567 AS Decimal(18, 6)), CAST(-79.459736 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0T1', CAST(43.890627 AS Decimal(18, 6)), CAST(-79.457195 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0T2', CAST(43.859216 AS Decimal(18, 6)), CAST(-79.455652 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0T3', CAST(43.867319 AS Decimal(18, 6)), CAST(-79.436490 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0T4', CAST(43.843167 AS Decimal(18, 6)), CAST(-79.430641 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0T5', CAST(43.848208 AS Decimal(18, 6)), CAST(-79.425882 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0T6', CAST(43.848796 AS Decimal(18, 6)), CAST(-79.426044 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0T7', CAST(43.850555 AS Decimal(18, 6)), CAST(-79.426606 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0T8', CAST(43.854015 AS Decimal(18, 6)), CAST(-79.427188 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0T9', CAST(43.886767 AS Decimal(18, 6)), CAST(-79.445542 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0V1', CAST(43.886477 AS Decimal(18, 6)), CAST(-79.446194 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0V2', CAST(43.866337 AS Decimal(18, 6)), CAST(-79.421587 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0V3', CAST(43.882249 AS Decimal(18, 6)), CAST(-79.434084 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0V4', CAST(43.898230 AS Decimal(18, 6)), CAST(-79.429606 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0V6', CAST(43.994132 AS Decimal(18, 6)), CAST(-79.466726 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0V8', CAST(43.885156 AS Decimal(18, 6)), CAST(-79.447112 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0V9', CAST(43.847023 AS Decimal(18, 6)), CAST(-79.457947 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0W1', CAST(43.839429 AS Decimal(18, 6)), CAST(-79.446295 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0W2', CAST(43.848219 AS Decimal(18, 6)), CAST(-79.431826 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0W3', CAST(43.845111 AS Decimal(18, 6)), CAST(-79.455097 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0W4', CAST(43.844785 AS Decimal(18, 6)), CAST(-79.455488 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0W5', CAST(43.877583 AS Decimal(18, 6)), CAST(-79.415965 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0W6', CAST(43.855214 AS Decimal(18, 6)), CAST(-79.421557 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0W7', CAST(43.895569 AS Decimal(18, 6)), CAST(-79.438055 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0W8', CAST(43.874600 AS Decimal(18, 6)), CAST(-79.434932 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0W9', CAST(43.876586 AS Decimal(18, 6)), CAST(-79.439574 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0X1', CAST(43.878583 AS Decimal(18, 6)), CAST(-79.434165 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0X2', CAST(43.878964 AS Decimal(18, 6)), CAST(-79.434230 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0X6', CAST(43.887047 AS Decimal(18, 6)), CAST(-79.446730 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0Y3', CAST(43.891347 AS Decimal(18, 6)), CAST(-79.450452 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0Y4', CAST(43.891216 AS Decimal(18, 6)), CAST(-79.451069 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0Y5', CAST(43.891088 AS Decimal(18, 6)), CAST(-79.451687 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0Y7', CAST(43.848934 AS Decimal(18, 6)), CAST(-79.431997 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0Y8', CAST(43.885788 AS Decimal(18, 6)), CAST(-79.453890 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C0Y9', CAST(43.885090 AS Decimal(18, 6)), CAST(-79.457161 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1A0', CAST(43.867739 AS Decimal(18, 6)), CAST(-79.413298 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1A1', CAST(43.875855 AS Decimal(18, 6)), CAST(-79.437760 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1A2', CAST(43.876071 AS Decimal(18, 6)), CAST(-79.437553 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1A3', CAST(43.876784 AS Decimal(18, 6)), CAST(-79.434345 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1A4', CAST(43.876182 AS Decimal(18, 6)), CAST(-79.436679 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1A5', CAST(43.840566 AS Decimal(18, 6)), CAST(-79.504076 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1A6', CAST(43.877802 AS Decimal(18, 6)), CAST(-79.429779 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1A7', CAST(43.877612 AS Decimal(18, 6)), CAST(-79.428594 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1A8', CAST(43.877750 AS Decimal(18, 6)), CAST(-79.425984 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1A9', CAST(43.875997 AS Decimal(18, 6)), CAST(-79.425129 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1B1', CAST(43.879547 AS Decimal(18, 6)), CAST(-79.426646 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1B2', CAST(43.878144 AS Decimal(18, 6)), CAST(-79.424207 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1B3', CAST(43.878485 AS Decimal(18, 6)), CAST(-79.422456 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1B4', CAST(43.878564 AS Decimal(18, 6)), CAST(-79.421976 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1B5', CAST(43.878921 AS Decimal(18, 6)), CAST(-79.420319 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1B6', CAST(43.878737 AS Decimal(18, 6)), CAST(-79.421115 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1B7', CAST(43.879140 AS Decimal(18, 6)), CAST(-79.419278 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1B8', CAST(43.879460 AS Decimal(18, 6)), CAST(-79.418264 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1B9', CAST(43.879675 AS Decimal(18, 6)), CAST(-79.416856 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1C1', CAST(43.912646 AS Decimal(18, 6)), CAST(-79.377793 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1C3', CAST(43.878136 AS Decimal(18, 6)), CAST(-79.420711 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1C4', CAST(43.878551 AS Decimal(18, 6)), CAST(-79.419121 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1C5', CAST(43.878545 AS Decimal(18, 6)), CAST(-79.417844 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1C6', CAST(43.874525 AS Decimal(18, 6)), CAST(-79.434241 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1C7', CAST(43.873313 AS Decimal(18, 6)), CAST(-79.434331 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1C8', CAST(43.874324 AS Decimal(18, 6)), CAST(-79.434338 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1C9', CAST(43.874672 AS Decimal(18, 6)), CAST(-79.432771 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1E1', CAST(43.874820 AS Decimal(18, 6)), CAST(-79.432102 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1E3', CAST(43.877581 AS Decimal(18, 6)), CAST(-79.418205 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1E4', CAST(43.877430 AS Decimal(18, 6)), CAST(-79.419321 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1E5', CAST(43.877648 AS Decimal(18, 6)), CAST(-79.418628 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1E6', CAST(43.877287 AS Decimal(18, 6)), CAST(-79.417685 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1E7', CAST(43.876840 AS Decimal(18, 6)), CAST(-79.419545 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1E8', CAST(43.877833 AS Decimal(18, 6)), CAST(-79.416182 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1E9', CAST(43.876741 AS Decimal(18, 6)), CAST(-79.420731 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1G1', CAST(43.876459 AS Decimal(18, 6)), CAST(-79.421846 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1G2', CAST(43.876741 AS Decimal(18, 6)), CAST(-79.420731 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1G3', CAST(43.876741 AS Decimal(18, 6)), CAST(-79.420731 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1G4', CAST(43.875791 AS Decimal(18, 6)), CAST(-79.419381 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1G5', CAST(43.875614 AS Decimal(18, 6)), CAST(-79.419085 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1G6', CAST(43.871820 AS Decimal(18, 6)), CAST(-79.434740 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1G7', CAST(43.871554 AS Decimal(18, 6)), CAST(-79.435941 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1G8', CAST(43.871887 AS Decimal(18, 6)), CAST(-79.434433 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1G9', CAST(43.871757 AS Decimal(18, 6)), CAST(-79.435023 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1H1', CAST(43.872086 AS Decimal(18, 6)), CAST(-79.433532 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1H2', CAST(43.872139 AS Decimal(18, 6)), CAST(-79.433293 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1H3', CAST(43.872368 AS Decimal(18, 6)), CAST(-79.432263 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1H4', CAST(43.872441 AS Decimal(18, 6)), CAST(-79.431915 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1H5', CAST(43.872645 AS Decimal(18, 6)), CAST(-79.430992 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1H6', CAST(43.872841 AS Decimal(18, 6)), CAST(-79.430152 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1H7', CAST(43.903022 AS Decimal(18, 6)), CAST(-79.376584 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1H8', CAST(43.874111 AS Decimal(18, 6)), CAST(-79.424634 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1H9', CAST(43.875180 AS Decimal(18, 6)), CAST(-79.402837 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1J0', CAST(43.883983 AS Decimal(18, 6)), CAST(-79.419992 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1J1', CAST(43.874016 AS Decimal(18, 6)), CAST(-79.424296 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1J2', CAST(43.874400 AS Decimal(18, 6)), CAST(-79.423009 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1J3', CAST(43.874946 AS Decimal(18, 6)), CAST(-79.420058 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1J4', CAST(43.875154 AS Decimal(18, 6)), CAST(-79.419630 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1J5', CAST(43.875098 AS Decimal(18, 6)), CAST(-79.419875 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1J6', CAST(43.875403 AS Decimal(18, 6)), CAST(-79.418433 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1J7', CAST(43.875574 AS Decimal(18, 6)), CAST(-79.416884 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1J8', CAST(43.875784 AS Decimal(18, 6)), CAST(-79.416917 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1J9', CAST(43.875740 AS Decimal(18, 6)), CAST(-79.417170 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1K1', CAST(43.869491 AS Decimal(18, 6)), CAST(-79.435644 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1K2', CAST(43.870081 AS Decimal(18, 6)), CAST(-79.433560 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1K3', CAST(43.869920 AS Decimal(18, 6)), CAST(-79.434304 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1K4', CAST(43.870232 AS Decimal(18, 6)), CAST(-79.432868 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1K5', CAST(43.870223 AS Decimal(18, 6)), CAST(-79.432912 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1K6', CAST(43.870220 AS Decimal(18, 6)), CAST(-79.431817 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1K7', CAST(43.870527 AS Decimal(18, 6)), CAST(-79.431535 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1K8', CAST(43.870863 AS Decimal(18, 6)), CAST(-79.430045 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1K9', CAST(43.870642 AS Decimal(18, 6)), CAST(-79.430405 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1L1', CAST(43.871215 AS Decimal(18, 6)), CAST(-79.428490 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1L2', CAST(43.871156 AS Decimal(18, 6)), CAST(-79.428748 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1L3', CAST(43.872015 AS Decimal(18, 6)), CAST(-79.424875 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1L4', CAST(43.871783 AS Decimal(18, 6)), CAST(-79.424578 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1L5', CAST(43.872394 AS Decimal(18, 6)), CAST(-79.423059 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1L6', CAST(43.872397 AS Decimal(18, 6)), CAST(-79.422873 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1L7', CAST(43.872776 AS Decimal(18, 6)), CAST(-79.421290 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1L8', CAST(43.872768 AS Decimal(18, 6)), CAST(-79.421328 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1L9', CAST(43.873184 AS Decimal(18, 6)), CAST(-79.419425 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1M1', CAST(43.873081 AS Decimal(18, 6)), CAST(-79.419197 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1M2', CAST(43.873679 AS Decimal(18, 6)), CAST(-79.418245 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1M3', CAST(43.873555 AS Decimal(18, 6)), CAST(-79.417776 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1M4', CAST(43.873974 AS Decimal(18, 6)), CAST(-79.415904 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1M5', CAST(43.873828 AS Decimal(18, 6)), CAST(-79.416561 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1M6', CAST(43.871613 AS Decimal(18, 6)), CAST(-79.421688 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1M7', CAST(43.871517 AS Decimal(18, 6)), CAST(-79.422073 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1M8', CAST(43.871684 AS Decimal(18, 6)), CAST(-79.421804 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1M9', CAST(43.871650 AS Decimal(18, 6)), CAST(-79.421069 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1N1', CAST(43.871993 AS Decimal(18, 6)), CAST(-79.419885 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1N2', CAST(43.872369 AS Decimal(18, 6)), CAST(-79.430542 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1N3', CAST(43.872550 AS Decimal(18, 6)), CAST(-79.417361 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1N4', CAST(43.872550 AS Decimal(18, 6)), CAST(-79.417361 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1N5', CAST(43.867923 AS Decimal(18, 6)), CAST(-79.434852 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1N6', CAST(43.868431 AS Decimal(18, 6)), CAST(-79.433654 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1N7', CAST(43.868387 AS Decimal(18, 6)), CAST(-79.432637 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1N8', CAST(43.868964 AS Decimal(18, 6)), CAST(-79.430016 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1N9', CAST(43.869271 AS Decimal(18, 6)), CAST(-79.428601 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1P1', CAST(43.870165 AS Decimal(18, 6)), CAST(-79.424487 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1P2', CAST(43.870297 AS Decimal(18, 6)), CAST(-79.423807 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1P3', CAST(43.870547 AS Decimal(18, 6)), CAST(-79.421896 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1P4', CAST(43.870780 AS Decimal(18, 6)), CAST(-79.422342 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1P5', CAST(43.871064 AS Decimal(18, 6)), CAST(-79.420461 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1P6', CAST(43.871148 AS Decimal(18, 6)), CAST(-79.419634 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1P7', CAST(43.871472 AS Decimal(18, 6)), CAST(-79.418606 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1P8', CAST(43.871274 AS Decimal(18, 6)), CAST(-79.418260 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1P9', CAST(43.871756 AS Decimal(18, 6)), CAST(-79.417054 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1R1', CAST(43.871976 AS Decimal(18, 6)), CAST(-79.416015 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1R2', CAST(43.872423 AS Decimal(18, 6)), CAST(-79.415306 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1R3', CAST(43.870017 AS Decimal(18, 6)), CAST(-79.420517 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1R4', CAST(43.870361 AS Decimal(18, 6)), CAST(-79.421122 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1R5', CAST(43.870689 AS Decimal(18, 6)), CAST(-79.418607 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1R6', CAST(43.871002 AS Decimal(18, 6)), CAST(-79.417173 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1R7', CAST(43.871144 AS Decimal(18, 6)), CAST(-79.416553 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1R8', CAST(43.869398 AS Decimal(18, 6)), CAST(-79.420657 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1R9', CAST(43.869346 AS Decimal(18, 6)), CAST(-79.421485 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1S1', CAST(43.869760 AS Decimal(18, 6)), CAST(-79.419317 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1S2', CAST(43.870331 AS Decimal(18, 6)), CAST(-79.416682 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1S3', CAST(43.870282 AS Decimal(18, 6)), CAST(-79.416921 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1S4', CAST(43.870891 AS Decimal(18, 6)), CAST(-79.415715 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1S5', CAST(43.866966 AS Decimal(18, 6)), CAST(-79.434755 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1S6', CAST(43.866257 AS Decimal(18, 6)), CAST(-79.438051 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1S7', CAST(43.867565 AS Decimal(18, 6)), CAST(-79.433379 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1S8', CAST(43.867007 AS Decimal(18, 6)), CAST(-79.432752 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1S9', CAST(43.868545 AS Decimal(18, 6)), CAST(-79.429054 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1T1', CAST(43.867587 AS Decimal(18, 6)), CAST(-79.430073 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1T2', CAST(43.865828 AS Decimal(18, 6)), CAST(-79.419492 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1T3', CAST(43.864846 AS Decimal(18, 6)), CAST(-79.422901 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1T4', CAST(43.852658 AS Decimal(18, 6)), CAST(-79.424047 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1T5', CAST(43.883019 AS Decimal(18, 6)), CAST(-79.439384 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1T6', CAST(43.876324 AS Decimal(18, 6)), CAST(-79.438412 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1T7', CAST(43.876187 AS Decimal(18, 6)), CAST(-79.438105 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1T8', CAST(43.875812 AS Decimal(18, 6)), CAST(-79.437774 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1T9', CAST(43.871041 AS Decimal(18, 6)), CAST(-79.437138 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1V1', CAST(43.868149 AS Decimal(18, 6)), CAST(-79.436408 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1V2', CAST(43.867121 AS Decimal(18, 6)), CAST(-79.436221 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1V3', CAST(43.865335 AS Decimal(18, 6)), CAST(-79.435759 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1V4', CAST(43.853484 AS Decimal(18, 6)), CAST(-79.433041 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1V5', CAST(43.851812 AS Decimal(18, 6)), CAST(-79.432644 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1V6', CAST(43.875997 AS Decimal(18, 6)), CAST(-79.437982 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1V7', CAST(43.868781 AS Decimal(18, 6)), CAST(-79.436297 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1V8', CAST(43.870220 AS Decimal(18, 6)), CAST(-79.436748 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1V9', CAST(43.864316 AS Decimal(18, 6)), CAST(-79.435654 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1W1', CAST(43.875152 AS Decimal(18, 6)), CAST(-79.436570 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1W2', CAST(43.875118 AS Decimal(18, 6)), CAST(-79.436562 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1W3', CAST(43.872761 AS Decimal(18, 6)), CAST(-79.436031 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1W4', CAST(43.873623 AS Decimal(18, 6)), CAST(-79.436216 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1W5', CAST(43.870784 AS Decimal(18, 6)), CAST(-79.435636 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1W6', CAST(43.870469 AS Decimal(18, 6)), CAST(-79.435553 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1W7', CAST(43.868804 AS Decimal(18, 6)), CAST(-79.435122 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1W8', CAST(43.868197 AS Decimal(18, 6)), CAST(-79.434953 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1W9', CAST(43.867923 AS Decimal(18, 6)), CAST(-79.434852 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1X1', CAST(43.867564 AS Decimal(18, 6)), CAST(-79.434702 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1X2', CAST(43.866596 AS Decimal(18, 6)), CAST(-79.434320 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1X3', CAST(43.867092 AS Decimal(18, 6)), CAST(-79.434514 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1X4', CAST(43.872906 AS Decimal(18, 6)), CAST(-79.434730 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1X5', CAST(43.873050 AS Decimal(18, 6)), CAST(-79.434223 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1X6', CAST(43.870255 AS Decimal(18, 6)), CAST(-79.433459 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1X7', CAST(43.870259 AS Decimal(18, 6)), CAST(-79.433461 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1X8', CAST(43.869266 AS Decimal(18, 6)), CAST(-79.433027 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1X9', CAST(43.869594 AS Decimal(18, 6)), CAST(-79.433600 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1Y1', CAST(43.873127 AS Decimal(18, 6)), CAST(-79.433044 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1Y2', CAST(43.872365 AS Decimal(18, 6)), CAST(-79.432966 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1Y3', CAST(43.870518 AS Decimal(18, 6)), CAST(-79.432213 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1Y4', CAST(43.870921 AS Decimal(18, 6)), CAST(-79.432377 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1Y5', CAST(43.869607 AS Decimal(18, 6)), CAST(-79.432245 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1Y6', CAST(43.869601 AS Decimal(18, 6)), CAST(-79.431838 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1Y7', CAST(43.868229 AS Decimal(18, 6)), CAST(-79.431258 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1Y8', CAST(43.868650 AS Decimal(18, 6)), CAST(-79.431448 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1Y9', CAST(43.867261 AS Decimal(18, 6)), CAST(-79.430838 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1Z1', CAST(43.867364 AS Decimal(18, 6)), CAST(-79.430881 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1Z2', CAST(43.873912 AS Decimal(18, 6)), CAST(-79.432043 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1Z3', CAST(43.873974 AS Decimal(18, 6)), CAST(-79.432635 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1Z4', CAST(43.871626 AS Decimal(18, 6)), CAST(-79.431340 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1Z5', CAST(43.871620 AS Decimal(18, 6)), CAST(-79.431338 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1Z6', CAST(43.870660 AS Decimal(18, 6)), CAST(-79.430947 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1Z7', CAST(43.869913 AS Decimal(18, 6)), CAST(-79.430274 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1Z8', CAST(43.879161 AS Decimal(18, 6)), CAST(-79.433421 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C1Z9', CAST(43.873695 AS Decimal(18, 6)), CAST(-79.431294 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2A1', CAST(43.881511 AS Decimal(18, 6)), CAST(-79.436632 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2A2', CAST(43.871982 AS Decimal(18, 6)), CAST(-79.429530 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2A3', CAST(43.871578 AS Decimal(18, 6)), CAST(-79.429057 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2A4', CAST(43.869422 AS Decimal(18, 6)), CAST(-79.428171 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2A5', CAST(43.869658 AS Decimal(18, 6)), CAST(-79.428958 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2A6', CAST(43.869141 AS Decimal(18, 6)), CAST(-79.428339 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2A7', CAST(43.868073 AS Decimal(18, 6)), CAST(-79.428268 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2A8', CAST(43.871774 AS Decimal(18, 6)), CAST(-79.427548 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2A9', CAST(43.873186 AS Decimal(18, 6)), CAST(-79.428156 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2B1', CAST(43.869930 AS Decimal(18, 6)), CAST(-79.426755 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2B2', CAST(43.870457 AS Decimal(18, 6)), CAST(-79.427205 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2B3', CAST(43.868792 AS Decimal(18, 6)), CAST(-79.426295 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2B4', CAST(43.869360 AS Decimal(18, 6)), CAST(-79.426564 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2B5', CAST(43.873264 AS Decimal(18, 6)), CAST(-79.424299 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2B6', CAST(43.872358 AS Decimal(18, 6)), CAST(-79.423894 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2B7', CAST(43.868108 AS Decimal(18, 6)), CAST(-79.422868 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2B8', CAST(43.870674 AS Decimal(18, 6)), CAST(-79.423475 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2B9', CAST(43.871061 AS Decimal(18, 6)), CAST(-79.424440 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2C1', CAST(43.871809 AS Decimal(18, 6)), CAST(-79.423133 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2C2', CAST(43.869586 AS Decimal(18, 6)), CAST(-79.423423 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2C3', CAST(43.869985 AS Decimal(18, 6)), CAST(-79.423507 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2C4', CAST(43.869646 AS Decimal(18, 6)), CAST(-79.423357 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2C5', CAST(43.875198 AS Decimal(18, 6)), CAST(-79.425002 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2C6', CAST(43.877301 AS Decimal(18, 6)), CAST(-79.425523 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2C7', CAST(43.872736 AS Decimal(18, 6)), CAST(-79.422126 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2C8', CAST(43.873032 AS Decimal(18, 6)), CAST(-79.422370 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2C9', CAST(43.872322 AS Decimal(18, 6)), CAST(-79.422199 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2E1', CAST(43.872105 AS Decimal(18, 6)), CAST(-79.421430 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2E2', CAST(43.871239 AS Decimal(18, 6)), CAST(-79.421516 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2E3', CAST(43.871613 AS Decimal(18, 6)), CAST(-79.421688 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2E4', CAST(43.877882 AS Decimal(18, 6)), CAST(-79.422440 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2E5', CAST(43.879650 AS Decimal(18, 6)), CAST(-79.422869 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2E6', CAST(43.876925 AS Decimal(18, 6)), CAST(-79.422047 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2E7', CAST(43.876552 AS Decimal(18, 6)), CAST(-79.421886 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2E8', CAST(43.880041 AS Decimal(18, 6)), CAST(-79.412965 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2E9', CAST(43.874293 AS Decimal(18, 6)), CAST(-79.420524 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2G1', CAST(43.873961 AS Decimal(18, 6)), CAST(-79.420722 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2G2', CAST(43.872451 AS Decimal(18, 6)), CAST(-79.420072 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2G3', CAST(43.872492 AS Decimal(18, 6)), CAST(-79.420089 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2G4', CAST(43.871870 AS Decimal(18, 6)), CAST(-79.419831 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2G5', CAST(43.870783 AS Decimal(18, 6)), CAST(-79.419956 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2G6', CAST(43.870425 AS Decimal(18, 6)), CAST(-79.419794 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2G7', CAST(43.869601 AS Decimal(18, 6)), CAST(-79.419451 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2G8', CAST(43.876745 AS Decimal(18, 6)), CAST(-79.422153 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2G9', CAST(43.877448 AS Decimal(18, 6)), CAST(-79.423469 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2H1', CAST(43.870995 AS Decimal(18, 6)), CAST(-79.418991 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2H2', CAST(43.870643 AS Decimal(18, 6)), CAST(-79.418844 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2H3', CAST(43.870213 AS Decimal(18, 6)), CAST(-79.418662 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2H4', CAST(43.869960 AS Decimal(18, 6)), CAST(-79.417958 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2H5', CAST(43.877537 AS Decimal(18, 6)), CAST(-79.421066 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2H6', CAST(43.877059 AS Decimal(18, 6)), CAST(-79.420952 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2H7', CAST(43.875848 AS Decimal(18, 6)), CAST(-79.420613 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2H8', CAST(43.875811 AS Decimal(18, 6)), CAST(-79.420216 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2H9', CAST(43.875361 AS Decimal(18, 6)), CAST(-79.419994 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2J1', CAST(43.873503 AS Decimal(18, 6)), CAST(-79.418606 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2J2', CAST(43.874577 AS Decimal(18, 6)), CAST(-79.418687 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2J3', CAST(43.872605 AS Decimal(18, 6)), CAST(-79.418235 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2J4', CAST(43.873379 AS Decimal(18, 6)), CAST(-79.418554 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2J5', CAST(43.871857 AS Decimal(18, 6)), CAST(-79.417749 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2J6', CAST(43.871243 AS Decimal(18, 6)), CAST(-79.416793 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2J7', CAST(43.869468 AS Decimal(18, 6)), CAST(-79.416056 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2J8', CAST(43.877779 AS Decimal(18, 6)), CAST(-79.418681 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2J9', CAST(43.877779 AS Decimal(18, 6)), CAST(-79.418681 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2K1', CAST(43.874173 AS Decimal(18, 6)), CAST(-79.417118 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2K2', CAST(43.875616 AS Decimal(18, 6)), CAST(-79.417512 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2K3', CAST(43.873655 AS Decimal(18, 6)), CAST(-79.416736 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2K4', CAST(43.873553 AS Decimal(18, 6)), CAST(-79.416693 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2K5', CAST(43.872456 AS Decimal(18, 6)), CAST(-79.416364 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2K6', CAST(43.878064 AS Decimal(18, 6)), CAST(-79.416800 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2K7', CAST(43.879216 AS Decimal(18, 6)), CAST(-79.417094 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2K8', CAST(43.877702 AS Decimal(18, 6)), CAST(-79.416685 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2K9', CAST(43.876252 AS Decimal(18, 6)), CAST(-79.416012 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2L1', CAST(43.874528 AS Decimal(18, 6)), CAST(-79.415527 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2L2', CAST(43.875177 AS Decimal(18, 6)), CAST(-79.415263 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2L3', CAST(43.873348 AS Decimal(18, 6)), CAST(-79.415023 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2L4', CAST(43.878515 AS Decimal(18, 6)), CAST(-79.416512 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2L5', CAST(43.881049 AS Decimal(18, 6)), CAST(-79.418676 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2L6', CAST(43.880395 AS Decimal(18, 6)), CAST(-79.420135 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2L7', CAST(43.880112 AS Decimal(18, 6)), CAST(-79.421910 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2L8', CAST(43.880377 AS Decimal(18, 6)), CAST(-79.417411 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2L9', CAST(43.879670 AS Decimal(18, 6)), CAST(-79.419677 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2M1', CAST(43.880153 AS Decimal(18, 6)), CAST(-79.418001 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2M2', CAST(43.880430 AS Decimal(18, 6)), CAST(-79.416992 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2M3', CAST(43.878071 AS Decimal(18, 6)), CAST(-79.437527 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2M4', CAST(43.878333 AS Decimal(18, 6)), CAST(-79.436977 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2M5', CAST(43.878851 AS Decimal(18, 6)), CAST(-79.434718 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2M6', CAST(43.878984 AS Decimal(18, 6)), CAST(-79.434147 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2M7', CAST(43.878839 AS Decimal(18, 6)), CAST(-79.434772 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2M8', CAST(43.877095 AS Decimal(18, 6)), CAST(-79.438561 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2M9', CAST(43.881494 AS Decimal(18, 6)), CAST(-79.421298 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2N1', CAST(43.881466 AS Decimal(18, 6)), CAST(-79.419271 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2N2', CAST(43.880713 AS Decimal(18, 6)), CAST(-79.423594 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2N3', CAST(43.882045 AS Decimal(18, 6)), CAST(-79.420537 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2N4', CAST(43.881164 AS Decimal(18, 6)), CAST(-79.423527 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2N5', CAST(43.879512 AS Decimal(18, 6)), CAST(-79.423684 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2N6', CAST(43.882569 AS Decimal(18, 6)), CAST(-79.418836 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2N7', CAST(43.882703 AS Decimal(18, 6)), CAST(-79.417895 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2N8', CAST(43.879474 AS Decimal(18, 6)), CAST(-79.436823 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2N9', CAST(43.879485 AS Decimal(18, 6)), CAST(-79.437923 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2P1', CAST(43.883249 AS Decimal(18, 6)), CAST(-79.421396 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2P2', CAST(43.883779 AS Decimal(18, 6)), CAST(-79.420262 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2P3', CAST(43.883405 AS Decimal(18, 6)), CAST(-79.418882 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2P4', CAST(43.884566 AS Decimal(18, 6)), CAST(-79.418461 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2P5', CAST(43.882960 AS Decimal(18, 6)), CAST(-79.424348 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2P6', CAST(43.883481 AS Decimal(18, 6)), CAST(-79.423305 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2P7', CAST(43.883262 AS Decimal(18, 6)), CAST(-79.422961 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2P8', CAST(43.883521 AS Decimal(18, 6)), CAST(-79.421998 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2P9', CAST(43.883653 AS Decimal(18, 6)), CAST(-79.420047 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2R1', CAST(43.884117 AS Decimal(18, 6)), CAST(-79.419272 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2R2', CAST(43.880381 AS Decimal(18, 6)), CAST(-79.436502 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2R3', CAST(43.881235 AS Decimal(18, 6)), CAST(-79.435042 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2R4', CAST(43.883900 AS Decimal(18, 6)), CAST(-79.422071 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2R5', CAST(43.883865 AS Decimal(18, 6)), CAST(-79.424022 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2R6', CAST(43.883475 AS Decimal(18, 6)), CAST(-79.425786 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2R7', CAST(43.883691 AS Decimal(18, 6)), CAST(-79.424821 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2R8', CAST(43.884437 AS Decimal(18, 6)), CAST(-79.422112 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2R9', CAST(43.884812 AS Decimal(18, 6)), CAST(-79.419705 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2S1', CAST(43.884836 AS Decimal(18, 6)), CAST(-79.419603 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2S2', CAST(43.885750 AS Decimal(18, 6)), CAST(-79.422234 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2S3', CAST(43.885817 AS Decimal(18, 6)), CAST(-79.421938 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2S4', CAST(43.886146 AS Decimal(18, 6)), CAST(-79.420482 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2S5', CAST(43.886645 AS Decimal(18, 6)), CAST(-79.419258 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2S6', CAST(43.884697 AS Decimal(18, 6)), CAST(-79.429484 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2S7', CAST(43.885332 AS Decimal(18, 6)), CAST(-79.427790 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2S8', CAST(43.885812 AS Decimal(18, 6)), CAST(-79.425590 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2S9', CAST(43.886144 AS Decimal(18, 6)), CAST(-79.424059 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2T1', CAST(43.886636 AS Decimal(18, 6)), CAST(-79.421817 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2T2', CAST(43.886611 AS Decimal(18, 6)), CAST(-79.421928 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2T3', CAST(43.887119 AS Decimal(18, 6)), CAST(-79.419584 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2T4', CAST(43.886995 AS Decimal(18, 6)), CAST(-79.420169 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2T5', CAST(43.886968 AS Decimal(18, 6)), CAST(-79.427312 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2T6', CAST(43.886935 AS Decimal(18, 6)), CAST(-79.427299 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2T7', CAST(43.888686 AS Decimal(18, 6)), CAST(-79.427901 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2T8', CAST(43.889353 AS Decimal(18, 6)), CAST(-79.427322 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2T9', CAST(43.889703 AS Decimal(18, 6)), CAST(-79.424580 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2V1', CAST(43.891119 AS Decimal(18, 6)), CAST(-79.422897 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2V2', CAST(43.891075 AS Decimal(18, 6)), CAST(-79.421484 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2V3', CAST(43.888269 AS Decimal(18, 6)), CAST(-79.419457 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2V4', CAST(43.888269 AS Decimal(18, 6)), CAST(-79.419457 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2V5', CAST(43.887292 AS Decimal(18, 6)), CAST(-79.422232 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2V6', CAST(43.887717 AS Decimal(18, 6)), CAST(-79.421318 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2V7', CAST(43.888002 AS Decimal(18, 6)), CAST(-79.419595 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2V8', CAST(43.888606 AS Decimal(18, 6)), CAST(-79.420452 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2V9', CAST(43.888101 AS Decimal(18, 6)), CAST(-79.421443 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2W1', CAST(43.886160 AS Decimal(18, 6)), CAST(-79.429972 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2W2', CAST(43.885666 AS Decimal(18, 6)), CAST(-79.429824 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2W3', CAST(43.886902 AS Decimal(18, 6)), CAST(-79.428988 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2W4', CAST(43.887785 AS Decimal(18, 6)), CAST(-79.429760 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2W5', CAST(43.888007 AS Decimal(18, 6)), CAST(-79.430583 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2W6', CAST(43.887902 AS Decimal(18, 6)), CAST(-79.430306 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2W7', CAST(43.888270 AS Decimal(18, 6)), CAST(-79.430091 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2W8', CAST(43.888667 AS Decimal(18, 6)), CAST(-79.430292 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2W9', CAST(43.888875 AS Decimal(18, 6)), CAST(-79.429338 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2X1', CAST(43.890200 AS Decimal(18, 6)), CAST(-79.425494 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2X2', CAST(43.889773 AS Decimal(18, 6)), CAST(-79.427166 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2X3', CAST(43.889918 AS Decimal(18, 6)), CAST(-79.424746 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2X4', CAST(43.890793 AS Decimal(18, 6)), CAST(-79.422312 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2X5', CAST(43.890834 AS Decimal(18, 6)), CAST(-79.422520 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2X6', CAST(43.890117 AS Decimal(18, 6)), CAST(-79.429371 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2X7', CAST(43.889649 AS Decimal(18, 6)), CAST(-79.429720 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2X8', CAST(43.891856 AS Decimal(18, 6)), CAST(-79.420208 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2X9', CAST(43.891523 AS Decimal(18, 6)), CAST(-79.420442 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2Y1', CAST(43.886146 AS Decimal(18, 6)), CAST(-79.439162 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2Y2', CAST(43.887437 AS Decimal(18, 6)), CAST(-79.437419 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2Y3', CAST(43.887784 AS Decimal(18, 6)), CAST(-79.435846 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2Y4', CAST(43.887750 AS Decimal(18, 6)), CAST(-79.436000 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2Y5', CAST(43.890281 AS Decimal(18, 6)), CAST(-79.429963 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2Y6', CAST(43.890306 AS Decimal(18, 6)), CAST(-79.431226 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2Y7', CAST(43.890806 AS Decimal(18, 6)), CAST(-79.429820 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2Y8', CAST(43.891146 AS Decimal(18, 6)), CAST(-79.426730 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2Y9', CAST(43.891727 AS Decimal(18, 6)), CAST(-79.426683 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2Z1', CAST(43.892309 AS Decimal(18, 6)), CAST(-79.423047 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2Z2', CAST(43.892236 AS Decimal(18, 6)), CAST(-79.422742 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2Z3', CAST(43.893047 AS Decimal(18, 6)), CAST(-79.423963 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2Z4', CAST(43.892600 AS Decimal(18, 6)), CAST(-79.423613 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2Z5', CAST(43.892550 AS Decimal(18, 6)), CAST(-79.421981 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2Z6', CAST(43.892135 AS Decimal(18, 6)), CAST(-79.421549 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2Z7', CAST(43.893243 AS Decimal(18, 6)), CAST(-79.422016 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2Z8', CAST(43.893114 AS Decimal(18, 6)), CAST(-79.422061 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C2Z9', CAST(43.890664 AS Decimal(18, 6)), CAST(-79.436685 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3A1', CAST(43.890133 AS Decimal(18, 6)), CAST(-79.435959 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3A2', CAST(43.891040 AS Decimal(18, 6)), CAST(-79.429907 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3A3', CAST(43.891177 AS Decimal(18, 6)), CAST(-79.430073 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3A4', CAST(43.891741 AS Decimal(18, 6)), CAST(-79.427912 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3A5', CAST(43.892496 AS Decimal(18, 6)), CAST(-79.426988 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3A6', CAST(43.892031 AS Decimal(18, 6)), CAST(-79.426094 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3A7', CAST(43.889731 AS Decimal(18, 6)), CAST(-79.440201 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3A8', CAST(43.890536 AS Decimal(18, 6)), CAST(-79.437254 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3A9', CAST(43.893118 AS Decimal(18, 6)), CAST(-79.425147 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3B1', CAST(43.893525 AS Decimal(18, 6)), CAST(-79.423381 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3B2', CAST(43.880878 AS Decimal(18, 6)), CAST(-79.439098 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3B3', CAST(43.983419 AS Decimal(18, 6)), CAST(-79.463942 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3B4', CAST(43.877095 AS Decimal(18, 6)), CAST(-79.438561 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3B5', CAST(43.880608 AS Decimal(18, 6)), CAST(-79.438871 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3B6', CAST(43.957020 AS Decimal(18, 6)), CAST(-79.457829 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3B7', CAST(43.877784 AS Decimal(18, 6)), CAST(-79.438890 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3B8', CAST(43.950380 AS Decimal(18, 6)), CAST(-79.456224 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3B9', CAST(43.878755 AS Decimal(18, 6)), CAST(-79.438535 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3C1', CAST(43.881485 AS Decimal(18, 6)), CAST(-79.439039 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3C2', CAST(43.885307 AS Decimal(18, 6)), CAST(-79.439812 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3C3', CAST(43.881162 AS Decimal(18, 6)), CAST(-79.439516 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3C4', CAST(43.881998 AS Decimal(18, 6)), CAST(-79.439709 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3C5', CAST(43.885884 AS Decimal(18, 6)), CAST(-79.440496 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3C6', CAST(43.883012 AS Decimal(18, 6)), CAST(-79.439938 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3C7', CAST(43.887575 AS Decimal(18, 6)), CAST(-79.441044 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3C8', CAST(43.885983 AS Decimal(18, 6)), CAST(-79.440778 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3C9', CAST(43.888250 AS Decimal(18, 6)), CAST(-79.441402 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3E1', CAST(43.882938 AS Decimal(18, 6)), CAST(-79.445203 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3E3', CAST(43.982933 AS Decimal(18, 6)), CAST(-79.463807 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3E4', CAST(43.890819 AS Decimal(18, 6)), CAST(-79.442175 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3E5', CAST(43.896031 AS Decimal(18, 6)), CAST(-79.443187 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3E6', CAST(43.877372 AS Decimal(18, 6)), CAST(-79.437132 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3E7', CAST(43.878115 AS Decimal(18, 6)), CAST(-79.437320 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3E8', CAST(43.886254 AS Decimal(18, 6)), CAST(-79.437499 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3E9', CAST(43.887040 AS Decimal(18, 6)), CAST(-79.437031 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3G1', CAST(43.889557 AS Decimal(18, 6)), CAST(-79.438412 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3G2', CAST(43.888810 AS Decimal(18, 6)), CAST(-79.437798 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3G3', CAST(43.880106 AS Decimal(18, 6)), CAST(-79.428812 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3G4', CAST(43.880054 AS Decimal(18, 6)), CAST(-79.427686 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3G5', CAST(43.882179 AS Decimal(18, 6)), CAST(-79.429012 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3G6', CAST(43.882431 AS Decimal(18, 6)), CAST(-79.429518 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3G7', CAST(43.885776 AS Decimal(18, 6)), CAST(-79.432731 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3G8', CAST(43.885676 AS Decimal(18, 6)), CAST(-79.429502 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3G9', CAST(43.886273 AS Decimal(18, 6)), CAST(-79.429102 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3H1', CAST(43.886696 AS Decimal(18, 6)), CAST(-79.427970 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3H2', CAST(43.886286 AS Decimal(18, 6)), CAST(-79.428207 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3H3', CAST(43.890831 AS Decimal(18, 6)), CAST(-79.428451 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3H4', CAST(43.891300 AS Decimal(18, 6)), CAST(-79.428952 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3H5', CAST(43.891942 AS Decimal(18, 6)), CAST(-79.428793 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3H6', CAST(43.891942 AS Decimal(18, 6)), CAST(-79.428793 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3H7', CAST(43.882653 AS Decimal(18, 6)), CAST(-79.424042 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3H8', CAST(43.882739 AS Decimal(18, 6)), CAST(-79.424085 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3H9', CAST(43.887706 AS Decimal(18, 6)), CAST(-79.425884 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3J1', CAST(43.883733 AS Decimal(18, 6)), CAST(-79.429796 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3J2', CAST(43.888821 AS Decimal(18, 6)), CAST(-79.426780 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3J3', CAST(43.889046 AS Decimal(18, 6)), CAST(-79.425502 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3J4', CAST(43.887393 AS Decimal(18, 6)), CAST(-79.424921 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3J5', CAST(43.886154 AS Decimal(18, 6)), CAST(-79.425052 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3J6', CAST(43.878981 AS Decimal(18, 6)), CAST(-79.421567 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3J7', CAST(43.879020 AS Decimal(18, 6)), CAST(-79.422768 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3J8', CAST(43.882802 AS Decimal(18, 6)), CAST(-79.423044 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3J9', CAST(43.882619 AS Decimal(18, 6)), CAST(-79.422847 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3K1', CAST(43.888670 AS Decimal(18, 6)), CAST(-79.423819 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3K2', CAST(43.888120 AS Decimal(18, 6)), CAST(-79.424388 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3K3', CAST(43.889056 AS Decimal(18, 6)), CAST(-79.424788 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3K4', CAST(43.896927 AS Decimal(18, 6)), CAST(-79.429555 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3K5', CAST(43.881072 AS Decimal(18, 6)), CAST(-79.420796 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3K6', CAST(43.881077 AS Decimal(18, 6)), CAST(-79.420798 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3K7', CAST(43.885776 AS Decimal(18, 6)), CAST(-79.423374 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3K8', CAST(43.885062 AS Decimal(18, 6)), CAST(-79.423088 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3K9', CAST(43.885621 AS Decimal(18, 6)), CAST(-79.423314 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3L1', CAST(43.887441 AS Decimal(18, 6)), CAST(-79.423768 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3L2', CAST(43.887013 AS Decimal(18, 6)), CAST(-79.423359 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3L3', CAST(43.889371 AS Decimal(18, 6)), CAST(-79.423243 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3L4', CAST(43.888565 AS Decimal(18, 6)), CAST(-79.423860 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3L5', CAST(43.890528 AS Decimal(18, 6)), CAST(-79.423931 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3L6', CAST(43.891838 AS Decimal(18, 6)), CAST(-79.424465 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3L7', CAST(43.891381 AS Decimal(18, 6)), CAST(-79.424277 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3L8', CAST(43.892580 AS Decimal(18, 6)), CAST(-79.424778 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3L9', CAST(43.892854 AS Decimal(18, 6)), CAST(-79.424891 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3M1', CAST(43.879225 AS Decimal(18, 6)), CAST(-79.419238 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3M2', CAST(43.879378 AS Decimal(18, 6)), CAST(-79.419026 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3M3', CAST(43.882506 AS Decimal(18, 6)), CAST(-79.420115 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3M4', CAST(43.884473 AS Decimal(18, 6)), CAST(-79.420247 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3M5', CAST(43.886146 AS Decimal(18, 6)), CAST(-79.420482 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3M6', CAST(43.886146 AS Decimal(18, 6)), CAST(-79.420482 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3M7', CAST(43.886879 AS Decimal(18, 6)), CAST(-79.420712 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3M8', CAST(43.885226 AS Decimal(18, 6)), CAST(-79.420825 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3M9', CAST(43.885301 AS Decimal(18, 6)), CAST(-79.420879 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3N0', CAST(43.857047 AS Decimal(18, 6)), CAST(-79.443301 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3N1', CAST(43.885748 AS Decimal(18, 6)), CAST(-79.419882 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3N2', CAST(43.881154 AS Decimal(18, 6)), CAST(-79.417614 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3N3', CAST(43.881643 AS Decimal(18, 6)), CAST(-79.417732 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3N4', CAST(43.881736 AS Decimal(18, 6)), CAST(-79.417754 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3N5', CAST(43.882174 AS Decimal(18, 6)), CAST(-79.418086 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3N6', CAST(43.886858 AS Decimal(18, 6)), CAST(-79.418137 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3N7', CAST(43.887624 AS Decimal(18, 6)), CAST(-79.418319 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3N8', CAST(43.877110 AS Decimal(18, 6)), CAST(-79.417238 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3N9', CAST(43.891650 AS Decimal(18, 6)), CAST(-79.419700 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3P1', CAST(43.892055 AS Decimal(18, 6)), CAST(-79.419392 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3P2', CAST(43.885572 AS Decimal(18, 6)), CAST(-79.417658 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3P3', CAST(43.875758 AS Decimal(18, 6)), CAST(-79.438915 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3P4', CAST(43.875779 AS Decimal(18, 6)), CAST(-79.438851 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3P5', CAST(43.875471 AS Decimal(18, 6)), CAST(-79.440235 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3P6', CAST(43.874974 AS Decimal(18, 6)), CAST(-79.442563 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3P7', CAST(43.875427 AS Decimal(18, 6)), CAST(-79.440431 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3P8', CAST(43.875265 AS Decimal(18, 6)), CAST(-79.441322 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3P9', CAST(43.873730 AS Decimal(18, 6)), CAST(-79.448722 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3R0', CAST(43.809868 AS Decimal(18, 6)), CAST(-79.427021 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3R1', CAST(43.871734 AS Decimal(18, 6)), CAST(-79.454592 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3R2', CAST(43.872530 AS Decimal(18, 6)), CAST(-79.451778 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3R3', CAST(43.872045 AS Decimal(18, 6)), CAST(-79.453656 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3R4', CAST(43.871872 AS Decimal(18, 6)), CAST(-79.454438 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3R5', CAST(43.873792 AS Decimal(18, 6)), CAST(-79.439877 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3R6', CAST(43.873891 AS Decimal(18, 6)), CAST(-79.440048 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3R7', CAST(43.872348 AS Decimal(18, 6)), CAST(-79.443843 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3R8', CAST(43.872616 AS Decimal(18, 6)), CAST(-79.443710 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3R9', CAST(43.872186 AS Decimal(18, 6)), CAST(-79.441773 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3S1', CAST(43.872186 AS Decimal(18, 6)), CAST(-79.441773 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3S2', CAST(43.869507 AS Decimal(18, 6)), CAST(-79.445609 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3S3', CAST(43.869927 AS Decimal(18, 6)), CAST(-79.443598 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3S4', CAST(43.875181 AS Decimal(18, 6)), CAST(-79.402837 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3S5', CAST(43.885545 AS Decimal(18, 6)), CAST(-79.432762 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3S6', CAST(43.862844 AS Decimal(18, 6)), CAST(-79.445102 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3S7', CAST(43.862946 AS Decimal(18, 6)), CAST(-79.440545 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3S8', CAST(43.861523 AS Decimal(18, 6)), CAST(-79.450084 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3S9', CAST(43.859251 AS Decimal(18, 6)), CAST(-79.458402 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3T1', CAST(43.859315 AS Decimal(18, 6)), CAST(-79.457127 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3T2', CAST(43.862228 AS Decimal(18, 6)), CAST(-79.439222 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3T3', CAST(43.861202 AS Decimal(18, 6)), CAST(-79.440310 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3T4', CAST(43.859633 AS Decimal(18, 6)), CAST(-79.450009 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3T5', CAST(43.859104 AS Decimal(18, 6)), CAST(-79.450660 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3T6', CAST(43.857987 AS Decimal(18, 6)), CAST(-79.455083 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3T7', CAST(43.858285 AS Decimal(18, 6)), CAST(-79.456256 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3T8', CAST(43.859258 AS Decimal(18, 6)), CAST(-79.439425 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3T9', CAST(43.858632 AS Decimal(18, 6)), CAST(-79.442387 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3V1', CAST(43.857964 AS Decimal(18, 6)), CAST(-79.445561 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3V2', CAST(43.858085 AS Decimal(18, 6)), CAST(-79.445002 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3V3', CAST(43.855703 AS Decimal(18, 6)), CAST(-79.457044 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3V4', CAST(43.874471 AS Decimal(18, 6)), CAST(-79.440193 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3V5', CAST(43.875255 AS Decimal(18, 6)), CAST(-79.440388 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3V6', CAST(43.872443 AS Decimal(18, 6)), CAST(-79.444804 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3V7', CAST(43.873726 AS Decimal(18, 6)), CAST(-79.446034 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3V8', CAST(43.897441 AS Decimal(18, 6)), CAST(-79.446771 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3V9', CAST(43.875538 AS Decimal(18, 6)), CAST(-79.447610 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3W1', CAST(43.876178 AS Decimal(18, 6)), CAST(-79.448093 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3W2', CAST(43.859579 AS Decimal(18, 6)), CAST(-79.445339 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3W3', CAST(43.862281 AS Decimal(18, 6)), CAST(-79.446261 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3W4', CAST(43.870273 AS Decimal(18, 6)), CAST(-79.449512 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3W5', CAST(43.874977 AS Decimal(18, 6)), CAST(-79.451405 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3W6', CAST(43.875439 AS Decimal(18, 6)), CAST(-79.451286 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3W7', CAST(43.857329 AS Decimal(18, 6)), CAST(-79.452626 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3W8', CAST(43.858481 AS Decimal(18, 6)), CAST(-79.452740 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3W9', CAST(43.860995 AS Decimal(18, 6)), CAST(-79.453724 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3X1', CAST(43.859976 AS Decimal(18, 6)), CAST(-79.453379 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3X2', CAST(43.861230 AS Decimal(18, 6)), CAST(-79.453971 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3X3', CAST(43.856924 AS Decimal(18, 6)), CAST(-79.460693 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3X4', CAST(43.857828 AS Decimal(18, 6)), CAST(-79.460990 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3X5', CAST(43.859811 AS Decimal(18, 6)), CAST(-79.460885 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3X6', CAST(43.872442 AS Decimal(18, 6)), CAST(-79.455453 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3X7', CAST(43.872220 AS Decimal(18, 6)), CAST(-79.455758 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3X8', CAST(43.872354 AS Decimal(18, 6)), CAST(-79.456284 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3X9', CAST(43.876357 AS Decimal(18, 6)), CAST(-79.440656 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3Y1', CAST(43.876586 AS Decimal(18, 6)), CAST(-79.439574 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3Y2', CAST(43.876438 AS Decimal(18, 6)), CAST(-79.440270 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3Y3', CAST(43.876137 AS Decimal(18, 6)), CAST(-79.443474 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3Y4', CAST(43.875600 AS Decimal(18, 6)), CAST(-79.436985 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3Y5', CAST(43.875926 AS Decimal(18, 6)), CAST(-79.442683 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3Y6', CAST(43.875943 AS Decimal(18, 6)), CAST(-79.443557 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3Y7', CAST(43.875105 AS Decimal(18, 6)), CAST(-79.446652 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3Y8', CAST(43.874562 AS Decimal(18, 6)), CAST(-79.449069 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3Y9', CAST(43.874659 AS Decimal(18, 6)), CAST(-79.449226 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3Z1', CAST(43.873944 AS Decimal(18, 6)), CAST(-79.451920 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3Z2', CAST(43.873846 AS Decimal(18, 6)), CAST(-79.452490 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3Z3', CAST(43.874200 AS Decimal(18, 6)), CAST(-79.453155 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3Z4', CAST(43.873655 AS Decimal(18, 6)), CAST(-79.453579 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3Z5', CAST(43.872341 AS Decimal(18, 6)), CAST(-79.457880 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3Z6', CAST(43.874259 AS Decimal(18, 6)), CAST(-79.456163 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3Z7', CAST(43.874187 AS Decimal(18, 6)), CAST(-79.456180 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3Z8', CAST(43.875457 AS Decimal(18, 6)), CAST(-79.449163 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C3Z9', CAST(43.875502 AS Decimal(18, 6)), CAST(-79.448936 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4A1', CAST(43.877655 AS Decimal(18, 6)), CAST(-79.440731 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4A2', CAST(43.877940 AS Decimal(18, 6)), CAST(-79.440663 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4A3', CAST(43.877098 AS Decimal(18, 6)), CAST(-79.443312 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4A4', CAST(43.877206 AS Decimal(18, 6)), CAST(-79.442822 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4A5', CAST(43.877164 AS Decimal(18, 6)), CAST(-79.443025 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4A6', CAST(43.877234 AS Decimal(18, 6)), CAST(-79.443874 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4A7', CAST(43.877526 AS Decimal(18, 6)), CAST(-79.443601 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4A8', CAST(43.877203 AS Decimal(18, 6)), CAST(-79.445673 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4A9', CAST(43.877236 AS Decimal(18, 6)), CAST(-79.445504 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4B1', CAST(43.876909 AS Decimal(18, 6)), CAST(-79.447860 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4B2', CAST(43.876820 AS Decimal(18, 6)), CAST(-79.447478 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4B3', CAST(43.875976 AS Decimal(18, 6)), CAST(-79.450554 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4B4', CAST(43.876339 AS Decimal(18, 6)), CAST(-79.449666 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4B5', CAST(43.875506 AS Decimal(18, 6)), CAST(-79.453577 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4B6', CAST(43.875447 AS Decimal(18, 6)), CAST(-79.453855 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4B7', CAST(43.875248 AS Decimal(18, 6)), CAST(-79.454811 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4B8', CAST(43.875117 AS Decimal(18, 6)), CAST(-79.455427 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4B9', CAST(43.874955 AS Decimal(18, 6)), CAST(-79.456178 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4C1', CAST(43.874634 AS Decimal(18, 6)), CAST(-79.457654 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4C2', CAST(43.875858 AS Decimal(18, 6)), CAST(-79.454931 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4C3', CAST(43.876305 AS Decimal(18, 6)), CAST(-79.454468 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4C4', CAST(43.875547 AS Decimal(18, 6)), CAST(-79.456299 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4C5', CAST(43.875925 AS Decimal(18, 6)), CAST(-79.455654 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4C6', CAST(43.877848 AS Decimal(18, 6)), CAST(-79.448530 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4C7', CAST(43.878160 AS Decimal(18, 6)), CAST(-79.447224 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4C8', CAST(43.877996 AS Decimal(18, 6)), CAST(-79.447948 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4C9', CAST(43.877647 AS Decimal(18, 6)), CAST(-79.450714 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4E1', CAST(43.877213 AS Decimal(18, 6)), CAST(-79.450435 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4E2', CAST(43.878097 AS Decimal(18, 6)), CAST(-79.447407 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4E3', CAST(43.877871 AS Decimal(18, 6)), CAST(-79.452809 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4E4', CAST(43.877845 AS Decimal(18, 6)), CAST(-79.452599 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4E5', CAST(43.880181 AS Decimal(18, 6)), CAST(-79.442988 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4E6', CAST(43.880078 AS Decimal(18, 6)), CAST(-79.442799 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4E7', CAST(43.879644 AS Decimal(18, 6)), CAST(-79.443891 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4E8', CAST(43.878219 AS Decimal(18, 6)), CAST(-79.450267 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4E9', CAST(43.878754 AS Decimal(18, 6)), CAST(-79.450429 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4G1', CAST(43.879917 AS Decimal(18, 6)), CAST(-79.445939 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4G2', CAST(43.879648 AS Decimal(18, 6)), CAST(-79.447138 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4G3', CAST(43.879575 AS Decimal(18, 6)), CAST(-79.447462 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4G4', CAST(43.879402 AS Decimal(18, 6)), CAST(-79.448244 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4G5', CAST(43.879403 AS Decimal(18, 6)), CAST(-79.449383 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4G6', CAST(43.879077 AS Decimal(18, 6)), CAST(-79.449737 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4G7', CAST(43.878602 AS Decimal(18, 6)), CAST(-79.450823 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4G8', CAST(43.878550 AS Decimal(18, 6)), CAST(-79.452143 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4G9', CAST(43.880837 AS Decimal(18, 6)), CAST(-79.442600 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4H0', CAST(43.881733 AS Decimal(18, 6)), CAST(-79.447972 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4H1', CAST(43.881147 AS Decimal(18, 6)), CAST(-79.443626 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4H2', CAST(43.882118 AS Decimal(18, 6)), CAST(-79.441653 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4H3', CAST(43.882171 AS Decimal(18, 6)), CAST(-79.442198 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4H4', CAST(43.881880 AS Decimal(18, 6)), CAST(-79.443423 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4H5', CAST(43.881688 AS Decimal(18, 6)), CAST(-79.444359 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4H6', CAST(43.882227 AS Decimal(18, 6)), CAST(-79.446216 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4H7', CAST(43.881617 AS Decimal(18, 6)), CAST(-79.447194 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4H8', CAST(43.881937 AS Decimal(18, 6)), CAST(-79.447000 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4H9', CAST(43.881598 AS Decimal(18, 6)), CAST(-79.448597 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4J1', CAST(43.882703 AS Decimal(18, 6)), CAST(-79.443493 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4J2', CAST(43.883189 AS Decimal(18, 6)), CAST(-79.443544 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4J3', CAST(43.883824 AS Decimal(18, 6)), CAST(-79.443761 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4J4', CAST(43.883565 AS Decimal(18, 6)), CAST(-79.444496 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4J5', CAST(43.884615 AS Decimal(18, 6)), CAST(-79.443847 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4J6', CAST(43.883794 AS Decimal(18, 6)), CAST(-79.443739 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4J7', CAST(43.883490 AS Decimal(18, 6)), CAST(-79.444765 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4J8', CAST(43.883242 AS Decimal(18, 6)), CAST(-79.445862 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4J9', CAST(43.883111 AS Decimal(18, 6)), CAST(-79.446462 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4K1', CAST(43.883057 AS Decimal(18, 6)), CAST(-79.446718 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4K2', CAST(43.882762 AS Decimal(18, 6)), CAST(-79.448068 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4K3', CAST(43.882576 AS Decimal(18, 6)), CAST(-79.448923 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4K4', CAST(43.882535 AS Decimal(18, 6)), CAST(-79.449108 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4K5', CAST(43.885186 AS Decimal(18, 6)), CAST(-79.442452 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4K6', CAST(43.884727 AS Decimal(18, 6)), CAST(-79.444892 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4K7', CAST(43.884522 AS Decimal(18, 6)), CAST(-79.445031 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4K8', CAST(43.884110 AS Decimal(18, 6)), CAST(-79.446963 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4K9', CAST(43.883835 AS Decimal(18, 6)), CAST(-79.448216 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4L1', CAST(43.883953 AS Decimal(18, 6)), CAST(-79.447669 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4L2', CAST(43.883648 AS Decimal(18, 6)), CAST(-79.449111 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4L3', CAST(43.883547 AS Decimal(18, 6)), CAST(-79.449611 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4L4', CAST(43.881631 AS Decimal(18, 6)), CAST(-79.448444 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4L5', CAST(43.885378 AS Decimal(18, 6)), CAST(-79.449521 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4L6', CAST(43.884677 AS Decimal(18, 6)), CAST(-79.450859 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4L7', CAST(43.884606 AS Decimal(18, 6)), CAST(-79.453881 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4L8', CAST(43.881503 AS Decimal(18, 6)), CAST(-79.462596 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4L9', CAST(43.882202 AS Decimal(18, 6)), CAST(-79.463944 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4M1', CAST(43.888397 AS Decimal(18, 6)), CAST(-79.446907 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4M2', CAST(43.887974 AS Decimal(18, 6)), CAST(-79.449190 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4M3', CAST(43.886580 AS Decimal(18, 6)), CAST(-79.455697 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4M4', CAST(43.889938 AS Decimal(18, 6)), CAST(-79.444223 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4M5', CAST(43.890455 AS Decimal(18, 6)), CAST(-79.441873 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4M6', CAST(43.895590 AS Decimal(18, 6)), CAST(-79.445863 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4M7', CAST(43.894826 AS Decimal(18, 6)), CAST(-79.446651 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4M8', CAST(43.894736 AS Decimal(18, 6)), CAST(-79.446115 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4M9', CAST(43.894455 AS Decimal(18, 6)), CAST(-79.446911 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4N1', CAST(43.895677 AS Decimal(18, 6)), CAST(-79.447653 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4N2', CAST(43.895070 AS Decimal(18, 6)), CAST(-79.447503 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4N3', CAST(43.882446 AS Decimal(18, 6)), CAST(-79.441976 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4N4', CAST(43.875892 AS Decimal(18, 6)), CAST(-79.440543 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4N5', CAST(43.882757 AS Decimal(18, 6)), CAST(-79.442520 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4N6', CAST(43.876743 AS Decimal(18, 6)), CAST(-79.441956 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4N7', CAST(43.876877 AS Decimal(18, 6)), CAST(-79.441652 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4N8', CAST(43.879194 AS Decimal(18, 6)), CAST(-79.442990 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4N9', CAST(43.878617 AS Decimal(18, 6)), CAST(-79.442460 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4P1', CAST(43.876345 AS Decimal(18, 6)), CAST(-79.442799 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4P2', CAST(43.876987 AS Decimal(18, 6)), CAST(-79.442968 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4P3', CAST(43.883682 AS Decimal(18, 6)), CAST(-79.444673 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4P4', CAST(43.878559 AS Decimal(18, 6)), CAST(-79.444501 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4P5', CAST(43.878532 AS Decimal(18, 6)), CAST(-79.444732 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4P6', CAST(43.880352 AS Decimal(18, 6)), CAST(-79.445053 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4P7', CAST(43.881042 AS Decimal(18, 6)), CAST(-79.445209 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4P8', CAST(43.880820 AS Decimal(18, 6)), CAST(-79.445166 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4P9', CAST(43.882231 AS Decimal(18, 6)), CAST(-79.445544 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4R1', CAST(43.882817 AS Decimal(18, 6)), CAST(-79.445622 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4R2', CAST(43.883835 AS Decimal(18, 6)), CAST(-79.445968 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4R3', CAST(43.883269 AS Decimal(18, 6)), CAST(-79.445741 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4R4', CAST(43.883606 AS Decimal(18, 6)), CAST(-79.446943 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4R5', CAST(43.883036 AS Decimal(18, 6)), CAST(-79.446737 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4R6', CAST(43.884197 AS Decimal(18, 6)), CAST(-79.447166 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4R7', CAST(43.882411 AS Decimal(18, 6)), CAST(-79.446993 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4R8', CAST(43.882666 AS Decimal(18, 6)), CAST(-79.446845 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4R9', CAST(43.879371 AS Decimal(18, 6)), CAST(-79.446127 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4S1', CAST(43.879416 AS Decimal(18, 6)), CAST(-79.446120 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4S2', CAST(43.880327 AS Decimal(18, 6)), CAST(-79.446251 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4S3', CAST(43.880400 AS Decimal(18, 6)), CAST(-79.446271 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4S4', CAST(43.876979 AS Decimal(18, 6)), CAST(-79.445212 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4S5', CAST(43.875958 AS Decimal(18, 6)), CAST(-79.445077 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4S6', CAST(43.876085 AS Decimal(18, 6)), CAST(-79.445447 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4S7', CAST(43.878214 AS Decimal(18, 6)), CAST(-79.446182 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4S8', CAST(43.878301 AS Decimal(18, 6)), CAST(-79.446160 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4S9', CAST(43.883604 AS Decimal(18, 6)), CAST(-79.448099 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4T1', CAST(43.876792 AS Decimal(18, 6)), CAST(-79.446161 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4T2', CAST(43.876939 AS Decimal(18, 6)), CAST(-79.446305 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4T3', CAST(43.880245 AS Decimal(18, 6)), CAST(-79.447762 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4T4', CAST(43.880245 AS Decimal(18, 6)), CAST(-79.447762 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4T5', CAST(43.882266 AS Decimal(18, 6)), CAST(-79.448179 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4T6', CAST(43.882102 AS Decimal(18, 6)), CAST(-79.448116 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4T7', CAST(43.883055 AS Decimal(18, 6)), CAST(-79.449050 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4T8', CAST(43.883102 AS Decimal(18, 6)), CAST(-79.449070 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4T9', CAST(43.883798 AS Decimal(18, 6)), CAST(-79.449328 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4V1', CAST(43.883798 AS Decimal(18, 6)), CAST(-79.449328 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4V2', CAST(43.874812 AS Decimal(18, 6)), CAST(-79.446534 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4V3', CAST(43.877728 AS Decimal(18, 6)), CAST(-79.448487 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4V4', CAST(43.877694 AS Decimal(18, 6)), CAST(-79.448479 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4V5', CAST(43.879100 AS Decimal(18, 6)), CAST(-79.448982 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4V6', CAST(43.878259 AS Decimal(18, 6)), CAST(-79.449090 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4V7', CAST(43.878780 AS Decimal(18, 6)), CAST(-79.467510 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4V8', CAST(43.878217 AS Decimal(18, 6)), CAST(-79.465971 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4V9', CAST(43.876833 AS Decimal(18, 6)), CAST(-79.451120 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4W1', CAST(43.876935 AS Decimal(18, 6)), CAST(-79.451836 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4W2', CAST(43.877100 AS Decimal(18, 6)), CAST(-79.451590 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4W3', CAST(43.878284 AS Decimal(18, 6)), CAST(-79.451923 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4W4', CAST(43.878883 AS Decimal(18, 6)), CAST(-79.452765 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4W5', CAST(43.878749 AS Decimal(18, 6)), CAST(-79.452774 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4W6', CAST(43.873045 AS Decimal(18, 6)), CAST(-79.453336 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4W7', CAST(43.873574 AS Decimal(18, 6)), CAST(-79.452839 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4W8', CAST(43.872491 AS Decimal(18, 6)), CAST(-79.454588 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4W9', CAST(43.873356 AS Decimal(18, 6)), CAST(-79.454898 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4X1', CAST(43.874759 AS Decimal(18, 6)), CAST(-79.454477 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4X2', CAST(43.874801 AS Decimal(18, 6)), CAST(-79.453669 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4X3', CAST(43.873652 AS Decimal(18, 6)), CAST(-79.455610 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4X4', CAST(43.873268 AS Decimal(18, 6)), CAST(-79.455955 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4X5', CAST(43.874013 AS Decimal(18, 6)), CAST(-79.455527 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4X6', CAST(43.874685 AS Decimal(18, 6)), CAST(-79.455157 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4X7', CAST(43.904398 AS Decimal(18, 6)), CAST(-79.458701 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4X8', CAST(43.946747 AS Decimal(18, 6)), CAST(-79.453875 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4X9', CAST(43.874270 AS Decimal(18, 6)), CAST(-79.477617 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4Y1', CAST(43.809860 AS Decimal(18, 6)), CAST(-79.427491 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4Y2', CAST(43.879032 AS Decimal(18, 6)), CAST(-79.413106 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4Y3', CAST(43.881208 AS Decimal(18, 6)), CAST(-79.427982 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4Y4', CAST(43.864900 AS Decimal(18, 6)), CAST(-79.430509 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4Y5', CAST(43.868921 AS Decimal(18, 6)), CAST(-79.419871 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4Y6', CAST(43.848394 AS Decimal(18, 6)), CAST(-79.431091 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4Y7', CAST(43.877743 AS Decimal(18, 6)), CAST(-79.438301 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4Y8', CAST(43.872980 AS Decimal(18, 6)), CAST(-79.447425 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4Y9', CAST(43.895276 AS Decimal(18, 6)), CAST(-79.429805 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4Z3', CAST(43.871325 AS Decimal(18, 6)), CAST(-79.449988 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4Z4', CAST(43.869801 AS Decimal(18, 6)), CAST(-79.426190 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4Z5', CAST(43.869676 AS Decimal(18, 6)), CAST(-79.426668 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4Z6', CAST(43.853295 AS Decimal(18, 6)), CAST(-79.444399 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4Z7', CAST(43.855274 AS Decimal(18, 6)), CAST(-79.442339 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4Z8', CAST(43.856847 AS Decimal(18, 6)), CAST(-79.443302 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C4Z9', CAST(43.856915 AS Decimal(18, 6)), CAST(-79.440226 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5A1', CAST(43.857405 AS Decimal(18, 6)), CAST(-79.440724 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5A2', CAST(43.852499 AS Decimal(18, 6)), CAST(-79.446277 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5A3', CAST(43.852136 AS Decimal(18, 6)), CAST(-79.448229 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5A4', CAST(43.851546 AS Decimal(18, 6)), CAST(-79.448089 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5A5', CAST(43.852070 AS Decimal(18, 6)), CAST(-79.448132 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5A6', CAST(43.851405 AS Decimal(18, 6)), CAST(-79.443095 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5A7', CAST(43.852169 AS Decimal(18, 6)), CAST(-79.442437 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5A8', CAST(43.857799 AS Decimal(18, 6)), CAST(-79.441280 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5A9', CAST(43.856547 AS Decimal(18, 6)), CAST(-79.443189 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5B1', CAST(43.857030 AS Decimal(18, 6)), CAST(-79.441724 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5B2', CAST(43.856579 AS Decimal(18, 6)), CAST(-79.443122 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5B3', CAST(43.855686 AS Decimal(18, 6)), CAST(-79.441398 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5B4', CAST(43.854961 AS Decimal(18, 6)), CAST(-79.441864 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5B5', CAST(43.852344 AS Decimal(18, 6)), CAST(-79.440471 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5B6', CAST(43.854174 AS Decimal(18, 6)), CAST(-79.440088 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5B7', CAST(43.853519 AS Decimal(18, 6)), CAST(-79.440630 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5B8', CAST(43.852381 AS Decimal(18, 6)), CAST(-79.445283 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5B9', CAST(43.852820 AS Decimal(18, 6)), CAST(-79.441727 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5C1', CAST(43.852556 AS Decimal(18, 6)), CAST(-79.442955 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5C2', CAST(43.852912 AS Decimal(18, 6)), CAST(-79.441185 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5C3', CAST(43.854495 AS Decimal(18, 6)), CAST(-79.439404 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5C4', CAST(43.854657 AS Decimal(18, 6)), CAST(-79.439070 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5C5', CAST(43.856120 AS Decimal(18, 6)), CAST(-79.439003 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5C6', CAST(43.857524 AS Decimal(18, 6)), CAST(-79.439815 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5C7', CAST(43.857166 AS Decimal(18, 6)), CAST(-79.439495 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5C8', CAST(43.858483 AS Decimal(18, 6)), CAST(-79.440519 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5C9', CAST(43.878896 AS Decimal(18, 6)), CAST(-79.447212 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5E1', CAST(43.879158 AS Decimal(18, 6)), CAST(-79.447199 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5E2', CAST(43.857576 AS Decimal(18, 6)), CAST(-79.437802 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5E3', CAST(43.854833 AS Decimal(18, 6)), CAST(-79.438076 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5E4', CAST(43.855036 AS Decimal(18, 6)), CAST(-79.438832 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5E5', CAST(43.895387 AS Decimal(18, 6)), CAST(-79.427260 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5E6', CAST(43.852096 AS Decimal(18, 6)), CAST(-79.445814 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5E7', CAST(43.892313 AS Decimal(18, 6)), CAST(-79.428935 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5E8', CAST(43.879930 AS Decimal(18, 6)), CAST(-79.445876 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5E9', CAST(43.874184 AS Decimal(18, 6)), CAST(-79.423187 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5G1', CAST(43.892760 AS Decimal(18, 6)), CAST(-79.426906 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5G2', CAST(43.871199 AS Decimal(18, 6)), CAST(-79.437554 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5G3', CAST(43.880147 AS Decimal(18, 6)), CAST(-79.426365 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5G4', CAST(43.878759 AS Decimal(18, 6)), CAST(-79.430950 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5G5', CAST(43.878851 AS Decimal(18, 6)), CAST(-79.434718 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5G6', CAST(43.858085 AS Decimal(18, 6)), CAST(-79.445002 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5G7', CAST(43.885018 AS Decimal(18, 6)), CAST(-79.440400 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5G8', CAST(43.882858 AS Decimal(18, 6)), CAST(-79.467025 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5H1', CAST(43.864566 AS Decimal(18, 6)), CAST(-79.439451 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5H2', CAST(43.891806 AS Decimal(18, 6)), CAST(-79.431351 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5H4', CAST(43.861934 AS Decimal(18, 6)), CAST(-79.446131 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5H5', CAST(43.852206 AS Decimal(18, 6)), CAST(-79.447883 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5H6', CAST(43.853394 AS Decimal(18, 6)), CAST(-79.455939 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5H7', CAST(43.855146 AS Decimal(18, 6)), CAST(-79.456122 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5H8', CAST(43.854979 AS Decimal(18, 6)), CAST(-79.453136 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5H9', CAST(43.855030 AS Decimal(18, 6)), CAST(-79.453365 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5J1', CAST(43.869448 AS Decimal(18, 6)), CAST(-79.443330 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5J2', CAST(43.856128 AS Decimal(18, 6)), CAST(-79.454223 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5J3', CAST(43.851252 AS Decimal(18, 6)), CAST(-79.455362 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5J4', CAST(43.851812 AS Decimal(18, 6)), CAST(-79.453921 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5J5', CAST(43.852636 AS Decimal(18, 6)), CAST(-79.452608 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5J6', CAST(43.854234 AS Decimal(18, 6)), CAST(-79.453648 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5J7', CAST(43.854285 AS Decimal(18, 6)), CAST(-79.454662 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5J8', CAST(43.854095 AS Decimal(18, 6)), CAST(-79.455849 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5J9', CAST(43.854095 AS Decimal(18, 6)), CAST(-79.455849 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5K1', CAST(43.873607 AS Decimal(18, 6)), CAST(-79.449531 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5K2', CAST(43.873176 AS Decimal(18, 6)), CAST(-79.448680 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5K3', CAST(43.873316 AS Decimal(18, 6)), CAST(-79.449685 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5K4', CAST(43.850492 AS Decimal(18, 6)), CAST(-79.453155 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5K5', CAST(43.851719 AS Decimal(18, 6)), CAST(-79.455556 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5K6', CAST(43.897417 AS Decimal(18, 6)), CAST(-79.428504 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5K7', CAST(43.853370 AS Decimal(18, 6)), CAST(-79.454345 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5K8', CAST(43.853652 AS Decimal(18, 6)), CAST(-79.454701 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5K9', CAST(43.880027 AS Decimal(18, 6)), CAST(-79.439251 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5L1', CAST(43.857657 AS Decimal(18, 6)), CAST(-79.438079 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5L2', CAST(43.857657 AS Decimal(18, 6)), CAST(-79.438079 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5L3', CAST(43.851656 AS Decimal(18, 6)), CAST(-79.451789 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5L4', CAST(43.852283 AS Decimal(18, 6)), CAST(-79.451685 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5L5', CAST(43.853487 AS Decimal(18, 6)), CAST(-79.451150 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5L6', CAST(43.872422 AS Decimal(18, 6)), CAST(-79.460088 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5L7', CAST(43.871527 AS Decimal(18, 6)), CAST(-79.459764 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5L8', CAST(43.853634 AS Decimal(18, 6)), CAST(-79.444285 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5L9', CAST(43.851590 AS Decimal(18, 6)), CAST(-79.451490 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5M1', CAST(43.851729 AS Decimal(18, 6)), CAST(-79.451674 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5M2', CAST(43.855157 AS Decimal(18, 6)), CAST(-79.456696 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5M3', CAST(43.858214 AS Decimal(18, 6)), CAST(-79.435363 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5M4', CAST(43.871118 AS Decimal(18, 6)), CAST(-79.458803 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5M5', CAST(43.871157 AS Decimal(18, 6)), CAST(-79.457848 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5M6', CAST(43.871677 AS Decimal(18, 6)), CAST(-79.457982 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5M7', CAST(43.871100 AS Decimal(18, 6)), CAST(-79.441363 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5M8', CAST(43.870587 AS Decimal(18, 6)), CAST(-79.458583 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5M9', CAST(43.858076 AS Decimal(18, 6)), CAST(-79.437165 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5N1', CAST(43.879363 AS Decimal(18, 6)), CAST(-79.439851 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5N2', CAST(43.850566 AS Decimal(18, 6)), CAST(-79.455033 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5N3', CAST(43.886375 AS Decimal(18, 6)), CAST(-79.419046 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5N4', CAST(43.875402 AS Decimal(18, 6)), CAST(-79.457498 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5N5', CAST(43.874103 AS Decimal(18, 6)), CAST(-79.446390 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5N6', CAST(43.876237 AS Decimal(18, 6)), CAST(-79.462319 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5N7', CAST(43.858011 AS Decimal(18, 6)), CAST(-79.436356 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5N8', CAST(43.858011 AS Decimal(18, 6)), CAST(-79.436356 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5N9', CAST(43.854288 AS Decimal(18, 6)), CAST(-79.459175 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5P1', CAST(43.853739 AS Decimal(18, 6)), CAST(-79.458550 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5P2', CAST(43.858841 AS Decimal(18, 6)), CAST(-79.447425 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5P3', CAST(43.856458 AS Decimal(18, 6)), CAST(-79.457120 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5P4', CAST(43.856475 AS Decimal(18, 6)), CAST(-79.456586 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5P5', CAST(43.857057 AS Decimal(18, 6)), CAST(-79.456823 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5P6', CAST(43.878248 AS Decimal(18, 6)), CAST(-79.437358 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5P7', CAST(43.852851 AS Decimal(18, 6)), CAST(-79.458794 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5P8', CAST(43.856403 AS Decimal(18, 6)), CAST(-79.458542 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5P9', CAST(43.852473 AS Decimal(18, 6)), CAST(-79.457926 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5R1', CAST(43.852696 AS Decimal(18, 6)), CAST(-79.458011 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5R2', CAST(43.859874 AS Decimal(18, 6)), CAST(-79.447941 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5R3', CAST(43.861146 AS Decimal(18, 6)), CAST(-79.448225 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5R4', CAST(43.859210 AS Decimal(18, 6)), CAST(-79.450061 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5R5', CAST(43.859364 AS Decimal(18, 6)), CAST(-79.449898 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5R6', CAST(43.870984 AS Decimal(18, 6)), CAST(-79.449915 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5R7', CAST(43.856833 AS Decimal(18, 6)), CAST(-79.450883 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5R8', CAST(43.855977 AS Decimal(18, 6)), CAST(-79.448566 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5R9', CAST(43.855677 AS Decimal(18, 6)), CAST(-79.449221 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5S1', CAST(43.855836 AS Decimal(18, 6)), CAST(-79.447910 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5S2', CAST(43.855944 AS Decimal(18, 6)), CAST(-79.448293 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5S3', CAST(43.875997 AS Decimal(18, 6)), CAST(-79.425129 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5S4', CAST(43.883633 AS Decimal(18, 6)), CAST(-79.461303 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5S5', CAST(43.857539 AS Decimal(18, 6)), CAST(-79.419048 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5S6', CAST(43.856701 AS Decimal(18, 6)), CAST(-79.418893 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5S7', CAST(43.856870 AS Decimal(18, 6)), CAST(-79.418959 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5S8', CAST(43.860926 AS Decimal(18, 6)), CAST(-79.449884 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5S9', CAST(43.858864 AS Decimal(18, 6)), CAST(-79.418684 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5T0', CAST(43.863550 AS Decimal(18, 6)), CAST(-79.431587 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5T1', CAST(43.864116 AS Decimal(18, 6)), CAST(-79.440480 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5T2', CAST(43.869531 AS Decimal(18, 6)), CAST(-79.436821 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5T3', CAST(43.882327 AS Decimal(18, 6)), CAST(-79.434780 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5T4', CAST(43.859126 AS Decimal(18, 6)), CAST(-79.417293 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5T5', CAST(43.864198 AS Decimal(18, 6)), CAST(-79.439511 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5T6', CAST(43.864670 AS Decimal(18, 6)), CAST(-79.437763 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5T7', CAST(43.865219 AS Decimal(18, 6)), CAST(-79.437966 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5T8', CAST(43.865191 AS Decimal(18, 6)), CAST(-79.439162 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5T9', CAST(43.851903 AS Decimal(18, 6)), CAST(-79.458598 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5V1', CAST(43.881709 AS Decimal(18, 6)), CAST(-79.433863 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5V2', CAST(43.881573 AS Decimal(18, 6)), CAST(-79.433924 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5V3', CAST(43.863291 AS Decimal(18, 6)), CAST(-79.452293 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5V4', CAST(43.863521 AS Decimal(18, 6)), CAST(-79.449474 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5V5', CAST(43.863766 AS Decimal(18, 6)), CAST(-79.450314 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5V6', CAST(43.864980 AS Decimal(18, 6)), CAST(-79.446444 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5V7', CAST(43.863015 AS Decimal(18, 6)), CAST(-79.449749 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5V8', CAST(43.864157 AS Decimal(18, 6)), CAST(-79.446878 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5V9', CAST(43.863139 AS Decimal(18, 6)), CAST(-79.452704 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5W1', CAST(43.882116 AS Decimal(18, 6)), CAST(-79.435230 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5W2', CAST(43.859109 AS Decimal(18, 6)), CAST(-79.417835 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5W3', CAST(43.850722 AS Decimal(18, 6)), CAST(-79.450874 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5W4', CAST(43.849941 AS Decimal(18, 6)), CAST(-79.452496 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5W5', CAST(43.849692 AS Decimal(18, 6)), CAST(-79.453136 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5W6', CAST(43.850056 AS Decimal(18, 6)), CAST(-79.451144 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5W7', CAST(43.850051 AS Decimal(18, 6)), CAST(-79.451598 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5W8', CAST(43.881511 AS Decimal(18, 6)), CAST(-79.436632 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5W9', CAST(43.865614 AS Decimal(18, 6)), CAST(-79.449204 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5X1', CAST(43.852913 AS Decimal(18, 6)), CAST(-79.456698 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5X2', CAST(43.862930 AS Decimal(18, 6)), CAST(-79.458006 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5X3', CAST(43.862759 AS Decimal(18, 6)), CAST(-79.456264 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5X4', CAST(43.863813 AS Decimal(18, 6)), CAST(-79.446386 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5X5', CAST(43.852121 AS Decimal(18, 6)), CAST(-79.457179 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5X6', CAST(43.859003 AS Decimal(18, 6)), CAST(-79.418546 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5X7', CAST(43.859187 AS Decimal(18, 6)), CAST(-79.418895 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5X8', CAST(43.863479 AS Decimal(18, 6)), CAST(-79.447191 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5X9', CAST(43.864499 AS Decimal(18, 6)), CAST(-79.450534 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5Y1', CAST(43.865382 AS Decimal(18, 6)), CAST(-79.446261 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5Y2', CAST(43.858132 AS Decimal(18, 6)), CAST(-79.415838 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5Y3', CAST(43.858046 AS Decimal(18, 6)), CAST(-79.413460 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5Y4', CAST(43.857756 AS Decimal(18, 6)), CAST(-79.414814 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5Y5', CAST(43.868277 AS Decimal(18, 6)), CAST(-79.461188 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5Y6', CAST(43.868298 AS Decimal(18, 6)), CAST(-79.459755 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5Y7', CAST(43.870181 AS Decimal(18, 6)), CAST(-79.458388 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5Y8', CAST(43.869658 AS Decimal(18, 6)), CAST(-79.456513 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5Y9', CAST(43.869736 AS Decimal(18, 6)), CAST(-79.457670 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5Z1', CAST(43.871203 AS Decimal(18, 6)), CAST(-79.461636 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5Z2', CAST(43.867850 AS Decimal(18, 6)), CAST(-79.456578 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5Z3', CAST(43.851368 AS Decimal(18, 6)), CAST(-79.452289 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5Z4', CAST(43.868418 AS Decimal(18, 6)), CAST(-79.458877 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5Z5', CAST(43.868459 AS Decimal(18, 6)), CAST(-79.456785 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5Z6', CAST(43.868417 AS Decimal(18, 6)), CAST(-79.456771 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5Z7', CAST(43.868122 AS Decimal(18, 6)), CAST(-79.454196 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5Z8', CAST(43.872981 AS Decimal(18, 6)), CAST(-79.447425 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C5Z9', CAST(43.850503 AS Decimal(18, 6)), CAST(-79.454489 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6A1', CAST(43.850173 AS Decimal(18, 6)), CAST(-79.453906 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6A2', CAST(43.877466 AS Decimal(18, 6)), CAST(-79.435004 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6A3', CAST(43.842512 AS Decimal(18, 6)), CAST(-79.430840 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6A4', CAST(43.879069 AS Decimal(18, 6)), CAST(-79.433923 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6A5', CAST(43.879129 AS Decimal(18, 6)), CAST(-79.435883 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6A6', CAST(43.858096 AS Decimal(18, 6)), CAST(-79.413328 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6A7', CAST(43.869812 AS Decimal(18, 6)), CAST(-79.415989 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6A8', CAST(43.869456 AS Decimal(18, 6)), CAST(-79.416057 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6A9', CAST(43.868043 AS Decimal(18, 6)), CAST(-79.417442 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6B1', CAST(43.868185 AS Decimal(18, 6)), CAST(-79.416828 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6B2', CAST(43.868770 AS Decimal(18, 6)), CAST(-79.420472 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6B3', CAST(43.868758 AS Decimal(18, 6)), CAST(-79.420158 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6B4', CAST(43.868109 AS Decimal(18, 6)), CAST(-79.418938 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6B5', CAST(43.869040 AS Decimal(18, 6)), CAST(-79.412702 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6B6', CAST(43.847130 AS Decimal(18, 6)), CAST(-79.443806 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6B7', CAST(43.849830 AS Decimal(18, 6)), CAST(-79.444719 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6B8', CAST(43.846766 AS Decimal(18, 6)), CAST(-79.444165 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6B9', CAST(43.849144 AS Decimal(18, 6)), CAST(-79.445006 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6C1', CAST(43.844120 AS Decimal(18, 6)), CAST(-79.456891 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6C2', CAST(43.846289 AS Decimal(18, 6)), CAST(-79.457685 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6C3', CAST(43.839852 AS Decimal(18, 6)), CAST(-79.407148 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6C4', CAST(43.846720 AS Decimal(18, 6)), CAST(-79.448614 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6C5', CAST(43.845345 AS Decimal(18, 6)), CAST(-79.455786 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6C6', CAST(43.847716 AS Decimal(18, 6)), CAST(-79.447723 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6C7', CAST(43.845811 AS Decimal(18, 6)), CAST(-79.456021 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6C8', CAST(43.837150 AS Decimal(18, 6)), CAST(-79.432211 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6C9', CAST(43.836633 AS Decimal(18, 6)), CAST(-79.433734 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6E1', CAST(43.834242 AS Decimal(18, 6)), CAST(-79.444432 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6E2', CAST(43.842815 AS Decimal(18, 6)), CAST(-79.447715 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6E3', CAST(43.843349 AS Decimal(18, 6)), CAST(-79.445698 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6E4', CAST(43.851188 AS Decimal(18, 6)), CAST(-79.439566 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6E5', CAST(43.849230 AS Decimal(18, 6)), CAST(-79.449966 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6E6', CAST(43.849904 AS Decimal(18, 6)), CAST(-79.448408 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6E7', CAST(43.834283 AS Decimal(18, 6)), CAST(-79.446363 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6E8', CAST(43.838498 AS Decimal(18, 6)), CAST(-79.444761 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6E9', CAST(43.837569 AS Decimal(18, 6)), CAST(-79.446575 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6G1', CAST(43.835585 AS Decimal(18, 6)), CAST(-79.446673 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6G2', CAST(43.838337 AS Decimal(18, 6)), CAST(-79.444569 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6G3', CAST(43.837254 AS Decimal(18, 6)), CAST(-79.447147 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6G4', CAST(43.835448 AS Decimal(18, 6)), CAST(-79.446846 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6G5', CAST(43.838199 AS Decimal(18, 6)), CAST(-79.445059 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6G6', CAST(43.845948 AS Decimal(18, 6)), CAST(-79.450263 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6G7', CAST(43.845852 AS Decimal(18, 6)), CAST(-79.450275 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6G8', CAST(43.843871 AS Decimal(18, 6)), CAST(-79.439869 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6G9', CAST(43.843714 AS Decimal(18, 6)), CAST(-79.441102 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6H1', CAST(43.844510 AS Decimal(18, 6)), CAST(-79.441504 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6H2', CAST(43.844676 AS Decimal(18, 6)), CAST(-79.440822 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6H3', CAST(43.846098 AS Decimal(18, 6)), CAST(-79.438792 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6H4', CAST(43.843730 AS Decimal(18, 6)), CAST(-79.442420 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6H5', CAST(43.843883 AS Decimal(18, 6)), CAST(-79.441991 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6H6', CAST(43.839390 AS Decimal(18, 6)), CAST(-79.445762 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6H7', CAST(43.841025 AS Decimal(18, 6)), CAST(-79.443248 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6H8', CAST(43.843118 AS Decimal(18, 6)), CAST(-79.444161 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6H9', CAST(43.845004 AS Decimal(18, 6)), CAST(-79.444274 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6J1', CAST(43.840058 AS Decimal(18, 6)), CAST(-79.445388 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6J2', CAST(43.842340 AS Decimal(18, 6)), CAST(-79.443851 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6J3', CAST(43.844547 AS Decimal(18, 6)), CAST(-79.444706 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6J4', CAST(43.853102 AS Decimal(18, 6)), CAST(-79.422912 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6J5', CAST(43.854064 AS Decimal(18, 6)), CAST(-79.417231 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6J6', CAST(43.854646 AS Decimal(18, 6)), CAST(-79.414394 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6J7', CAST(43.853155 AS Decimal(18, 6)), CAST(-79.422682 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6J8', CAST(43.854327 AS Decimal(18, 6)), CAST(-79.419821 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6J9', CAST(43.855658 AS Decimal(18, 6)), CAST(-79.412621 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6K1', CAST(43.834700 AS Decimal(18, 6)), CAST(-79.437546 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6K2', CAST(43.847286 AS Decimal(18, 6)), CAST(-79.434606 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6K3', CAST(43.845641 AS Decimal(18, 6)), CAST(-79.441267 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6K4', CAST(43.847438 AS Decimal(18, 6)), CAST(-79.436646 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6K5', CAST(43.846701 AS Decimal(18, 6)), CAST(-79.441724 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6K6', CAST(43.840264 AS Decimal(18, 6)), CAST(-79.432903 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6K7', CAST(43.840063 AS Decimal(18, 6)), CAST(-79.433308 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6K8', CAST(43.854236 AS Decimal(18, 6)), CAST(-79.420772 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6K9', CAST(43.836027 AS Decimal(18, 6)), CAST(-79.436317 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6L1', CAST(43.836640 AS Decimal(18, 6)), CAST(-79.435950 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6L2', CAST(43.836198 AS Decimal(18, 6)), CAST(-79.436194 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6L3', CAST(43.837023 AS Decimal(18, 6)), CAST(-79.436197 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6L4', CAST(43.854860 AS Decimal(18, 6)), CAST(-79.415543 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6L5', CAST(43.837801 AS Decimal(18, 6)), CAST(-79.434071 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6L6', CAST(43.837441 AS Decimal(18, 6)), CAST(-79.438228 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6L7', CAST(43.836080 AS Decimal(18, 6)), CAST(-79.443361 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6L8', CAST(43.835547 AS Decimal(18, 6)), CAST(-79.447544 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6L9', CAST(43.838979 AS Decimal(18, 6)), CAST(-79.432956 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6M1', CAST(43.837441 AS Decimal(18, 6)), CAST(-79.437250 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6M2', CAST(43.836549 AS Decimal(18, 6)), CAST(-79.444065 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6M3', CAST(43.835712 AS Decimal(18, 6)), CAST(-79.447914 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6M4', CAST(43.834210 AS Decimal(18, 6)), CAST(-79.440499 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6M5', CAST(43.835038 AS Decimal(18, 6)), CAST(-79.440505 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6M6', CAST(43.842881 AS Decimal(18, 6)), CAST(-79.452978 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6M7', CAST(43.843691 AS Decimal(18, 6)), CAST(-79.453167 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6M8', CAST(43.833617 AS Decimal(18, 6)), CAST(-79.438525 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6M9', CAST(43.834954 AS Decimal(18, 6)), CAST(-79.432490 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6N1', CAST(43.833181 AS Decimal(18, 6)), CAST(-79.438462 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6N2', CAST(43.835438 AS Decimal(18, 6)), CAST(-79.431842 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6N3', CAST(43.834045 AS Decimal(18, 6)), CAST(-79.433194 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6N4', CAST(43.833247 AS Decimal(18, 6)), CAST(-79.435471 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6N5', CAST(43.833942 AS Decimal(18, 6)), CAST(-79.436403 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6N6', CAST(43.833150 AS Decimal(18, 6)), CAST(-79.438212 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6N7', CAST(43.833293 AS Decimal(18, 6)), CAST(-79.439416 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6N8', CAST(43.833332 AS Decimal(18, 6)), CAST(-79.440132 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6N9', CAST(43.844360 AS Decimal(18, 6)), CAST(-79.434386 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6P1', CAST(43.844651 AS Decimal(18, 6)), CAST(-79.434500 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6P2', CAST(43.850890 AS Decimal(18, 6)), CAST(-79.426751 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6P3', CAST(43.852927 AS Decimal(18, 6)), CAST(-79.427708 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6P4', CAST(43.850174 AS Decimal(18, 6)), CAST(-79.426452 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6P5', CAST(43.852437 AS Decimal(18, 6)), CAST(-79.427479 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6P6', CAST(43.841562 AS Decimal(18, 6)), CAST(-79.448164 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6P7', CAST(43.845243 AS Decimal(18, 6)), CAST(-79.445744 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6P8', CAST(43.843945 AS Decimal(18, 6)), CAST(-79.448802 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6P9', CAST(43.834761 AS Decimal(18, 6)), CAST(-79.441357 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6R1', CAST(43.833657 AS Decimal(18, 6)), CAST(-79.442421 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6R2', CAST(43.841273 AS Decimal(18, 6)), CAST(-79.453431 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6R3', CAST(43.842626 AS Decimal(18, 6)), CAST(-79.455135 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6R4', CAST(43.841368 AS Decimal(18, 6)), CAST(-79.453696 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6R5', CAST(43.849028 AS Decimal(18, 6)), CAST(-79.435174 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6R6', CAST(43.847732 AS Decimal(18, 6)), CAST(-79.441038 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6R7', CAST(43.848954 AS Decimal(18, 6)), CAST(-79.439035 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6R8', CAST(43.835844 AS Decimal(18, 6)), CAST(-79.441014 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6R9', CAST(43.835441 AS Decimal(18, 6)), CAST(-79.442929 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6S1', CAST(43.835010 AS Decimal(18, 6)), CAST(-79.444980 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6S2', CAST(43.842897 AS Decimal(18, 6)), CAST(-79.442656 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6S3', CAST(43.845163 AS Decimal(18, 6)), CAST(-79.442741 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6S4', CAST(43.845005 AS Decimal(18, 6)), CAST(-79.441053 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6S5', CAST(43.844174 AS Decimal(18, 6)), CAST(-79.442706 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6S6', CAST(43.844676 AS Decimal(18, 6)), CAST(-79.440822 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6S7', CAST(43.837029 AS Decimal(18, 6)), CAST(-79.446035 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6S8', CAST(43.834912 AS Decimal(18, 6)), CAST(-79.438875 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6S9', CAST(43.842064 AS Decimal(18, 6)), CAST(-79.437202 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6T1', CAST(43.843969 AS Decimal(18, 6)), CAST(-79.437855 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6T2', CAST(43.844627 AS Decimal(18, 6)), CAST(-79.438109 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6T3', CAST(43.846120 AS Decimal(18, 6)), CAST(-79.437969 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6T4', CAST(43.846838 AS Decimal(18, 6)), CAST(-79.438949 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6T5', CAST(43.839470 AS Decimal(18, 6)), CAST(-79.437036 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6T6', CAST(43.842161 AS Decimal(18, 6)), CAST(-79.438004 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6T7', CAST(43.845887 AS Decimal(18, 6)), CAST(-79.437948 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6T8', CAST(43.847992 AS Decimal(18, 6)), CAST(-79.438772 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6T9', CAST(43.859073 AS Decimal(18, 6)), CAST(-79.417427 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6V1', CAST(43.841397 AS Decimal(18, 6)), CAST(-79.434862 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6V2', CAST(43.840367 AS Decimal(18, 6)), CAST(-79.439513 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6V3', CAST(43.842249 AS Decimal(18, 6)), CAST(-79.433001 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6V4', CAST(43.840910 AS Decimal(18, 6)), CAST(-79.438960 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6V5', CAST(43.845893 AS Decimal(18, 6)), CAST(-79.433919 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6V6', CAST(43.845886 AS Decimal(18, 6)), CAST(-79.435487 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6V7', CAST(43.843770 AS Decimal(18, 6)), CAST(-79.443584 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6V8', CAST(43.841697 AS Decimal(18, 6)), CAST(-79.433621 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6V9', CAST(43.849608 AS Decimal(18, 6)), CAST(-79.439387 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6W1', CAST(43.850497 AS Decimal(18, 6)), CAST(-79.439085 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6W2', CAST(43.842726 AS Decimal(18, 6)), CAST(-79.434913 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6W3', CAST(43.842865 AS Decimal(18, 6)), CAST(-79.433693 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6W4', CAST(43.844276 AS Decimal(18, 6)), CAST(-79.453517 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6W6', CAST(43.843110 AS Decimal(18, 6)), CAST(-79.454284 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6W7', CAST(43.834349 AS Decimal(18, 6)), CAST(-79.440433 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6W8', CAST(43.834435 AS Decimal(18, 6)), CAST(-79.440444 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6W9', CAST(43.845508 AS Decimal(18, 6)), CAST(-79.439928 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6X1', CAST(43.845503 AS Decimal(18, 6)), CAST(-79.439925 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6X2', CAST(43.840826 AS Decimal(18, 6)), CAST(-79.448634 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6X3', CAST(43.840858 AS Decimal(18, 6)), CAST(-79.447415 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6X4', CAST(43.843314 AS Decimal(18, 6)), CAST(-79.434235 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6X5', CAST(43.843101 AS Decimal(18, 6)), CAST(-79.437065 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6X6', CAST(43.842063 AS Decimal(18, 6)), CAST(-79.440165 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6X7', CAST(43.840659 AS Decimal(18, 6)), CAST(-79.446276 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6X8', CAST(43.838701 AS Decimal(18, 6)), CAST(-79.448321 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6X9', CAST(43.844107 AS Decimal(18, 6)), CAST(-79.433532 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6Y1', CAST(43.842225 AS Decimal(18, 6)), CAST(-79.441288 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6Y2', CAST(43.841531 AS Decimal(18, 6)), CAST(-79.446213 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6Y3', CAST(43.838264 AS Decimal(18, 6)), CAST(-79.448344 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6Y4', CAST(43.837611 AS Decimal(18, 6)), CAST(-79.442642 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6Y5', CAST(43.837487 AS Decimal(18, 6)), CAST(-79.443219 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6Y6', CAST(43.837547 AS Decimal(18, 6)), CAST(-79.444136 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6Y7', CAST(43.836736 AS Decimal(18, 6)), CAST(-79.445416 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6Y8', CAST(43.838822 AS Decimal(18, 6)), CAST(-79.441838 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6Y9', CAST(43.838809 AS Decimal(18, 6)), CAST(-79.441616 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6Z0', CAST(43.843738 AS Decimal(18, 6)), CAST(-79.430727 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6Z1', CAST(43.846439 AS Decimal(18, 6)), CAST(-79.430493 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6Z2', CAST(43.851552 AS Decimal(18, 6)), CAST(-79.432582 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6Z3', CAST(43.849178 AS Decimal(18, 6)), CAST(-79.431933 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6Z4', CAST(43.838676 AS Decimal(18, 6)), CAST(-79.430344 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6Z5', CAST(43.841494 AS Decimal(18, 6)), CAST(-79.430256 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6Z6', CAST(43.842977 AS Decimal(18, 6)), CAST(-79.430652 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6Z7', CAST(43.845603 AS Decimal(18, 6)), CAST(-79.431421 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6Z8', CAST(43.847360 AS Decimal(18, 6)), CAST(-79.431861 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C6Z9', CAST(43.937139 AS Decimal(18, 6)), CAST(-79.452913 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7A1', CAST(43.866800 AS Decimal(18, 6)), CAST(-79.435876 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7A2', CAST(43.868750 AS Decimal(18, 6)), CAST(-79.436884 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7A3', CAST(43.834734 AS Decimal(18, 6)), CAST(-79.433445 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7A4', CAST(43.835510 AS Decimal(18, 6)), CAST(-79.434659 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7A5', CAST(43.853346 AS Decimal(18, 6)), CAST(-79.429828 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7A6', CAST(43.854312 AS Decimal(18, 6)), CAST(-79.425899 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7A7', CAST(43.855814 AS Decimal(18, 6)), CAST(-79.418856 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7A8', CAST(43.856685 AS Decimal(18, 6)), CAST(-79.413435 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7A9', CAST(43.855091 AS Decimal(18, 6)), CAST(-79.423303 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7B1', CAST(43.864354 AS Decimal(18, 6)), CAST(-79.453088 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7B2', CAST(43.859297 AS Decimal(18, 6)), CAST(-79.412537 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7B3', CAST(43.858842 AS Decimal(18, 6)), CAST(-79.414010 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7B4', CAST(43.859337 AS Decimal(18, 6)), CAST(-79.412316 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7B5', CAST(43.904464 AS Decimal(18, 6)), CAST(-79.399712 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7B6', CAST(43.867027 AS Decimal(18, 6)), CAST(-79.457703 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7B7', CAST(43.865037 AS Decimal(18, 6)), CAST(-79.459902 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7B8', CAST(43.864372 AS Decimal(18, 6)), CAST(-79.457454 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7B9', CAST(43.863597 AS Decimal(18, 6)), CAST(-79.459488 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7C1', CAST(43.861989 AS Decimal(18, 6)), CAST(-79.442331 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7C2', CAST(43.863829 AS Decimal(18, 6)), CAST(-79.449864 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7C3', CAST(43.860814 AS Decimal(18, 6)), CAST(-79.412882 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7C4', CAST(43.841648 AS Decimal(18, 6)), CAST(-79.452541 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7C5', CAST(43.841649 AS Decimal(18, 6)), CAST(-79.452541 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7C6', CAST(43.841650 AS Decimal(18, 6)), CAST(-79.452541 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7C7', CAST(43.841651 AS Decimal(18, 6)), CAST(-79.452541 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7C8', CAST(43.864496 AS Decimal(18, 6)), CAST(-79.458955 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7C9', CAST(43.856122 AS Decimal(18, 6)), CAST(-79.456985 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7E1', CAST(43.864618 AS Decimal(18, 6)), CAST(-79.455063 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7E2', CAST(43.863881 AS Decimal(18, 6)), CAST(-79.455983 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7E3', CAST(43.863144 AS Decimal(18, 6)), CAST(-79.457987 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7E4', CAST(43.864217 AS Decimal(18, 6)), CAST(-79.454667 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7E5', CAST(43.835457 AS Decimal(18, 6)), CAST(-79.444233 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7E6', CAST(43.859471 AS Decimal(18, 6)), CAST(-79.412347 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7E7', CAST(43.871501 AS Decimal(18, 6)), CAST(-79.427249 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7E8', CAST(43.871159 AS Decimal(18, 6)), CAST(-79.426291 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7E9', CAST(43.864619 AS Decimal(18, 6)), CAST(-79.458261 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7G1', CAST(43.862585 AS Decimal(18, 6)), CAST(-79.442734 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7G2', CAST(43.859194 AS Decimal(18, 6)), CAST(-79.459318 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7G3', CAST(43.863830 AS Decimal(18, 6)), CAST(-79.449864 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7G4', CAST(43.856090 AS Decimal(18, 6)), CAST(-79.444381 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7G5', CAST(43.856302 AS Decimal(18, 6)), CAST(-79.443348 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7G6', CAST(43.843921 AS Decimal(18, 6)), CAST(-79.454750 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7G7', CAST(43.842525 AS Decimal(18, 6)), CAST(-79.453371 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7G8', CAST(43.881511 AS Decimal(18, 6)), CAST(-79.436632 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7G9', CAST(43.864986 AS Decimal(18, 6)), CAST(-79.459959 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7H1', CAST(43.857957 AS Decimal(18, 6)), CAST(-79.416120 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7H2', CAST(43.846066 AS Decimal(18, 6)), CAST(-79.433327 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7H3', CAST(43.846242 AS Decimal(18, 6)), CAST(-79.433309 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7H4', CAST(43.874692 AS Decimal(18, 6)), CAST(-79.458774 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7H5', CAST(43.867700 AS Decimal(18, 6)), CAST(-79.422215 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7H6', CAST(43.867545 AS Decimal(18, 6)), CAST(-79.422128 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7H7', CAST(43.875282 AS Decimal(18, 6)), CAST(-79.459441 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7H8', CAST(43.867452 AS Decimal(18, 6)), CAST(-79.422544 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7H9', CAST(43.866986 AS Decimal(18, 6)), CAST(-79.424385 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7J1', CAST(43.876281 AS Decimal(18, 6)), CAST(-79.462988 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7J2', CAST(43.876242 AS Decimal(18, 6)), CAST(-79.459576 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7J3', CAST(43.876240 AS Decimal(18, 6)), CAST(-79.459913 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7J4', CAST(43.881511 AS Decimal(18, 6)), CAST(-79.436632 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7J5', CAST(43.881511 AS Decimal(18, 6)), CAST(-79.436632 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7J6', CAST(43.865376 AS Decimal(18, 6)), CAST(-79.454550 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7J7', CAST(43.865557 AS Decimal(18, 6)), CAST(-79.455704 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7J8', CAST(43.865267 AS Decimal(18, 6)), CAST(-79.454065 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7J9', CAST(43.868350 AS Decimal(18, 6)), CAST(-79.450696 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7K1', CAST(43.867160 AS Decimal(18, 6)), CAST(-79.452066 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7K2', CAST(43.859622 AS Decimal(18, 6)), CAST(-79.416537 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7K3', CAST(43.859502 AS Decimal(18, 6)), CAST(-79.419097 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7K4', CAST(43.859592 AS Decimal(18, 6)), CAST(-79.418694 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7K5', CAST(43.866536 AS Decimal(18, 6)), CAST(-79.431596 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7K6', CAST(43.866729 AS Decimal(18, 6)), CAST(-79.431485 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7K7', CAST(43.867291 AS Decimal(18, 6)), CAST(-79.428516 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7K8', CAST(43.865922 AS Decimal(18, 6)), CAST(-79.430171 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7K9', CAST(43.865272 AS Decimal(18, 6)), CAST(-79.431598 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7L1', CAST(43.865744 AS Decimal(18, 6)), CAST(-79.432075 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7L2', CAST(43.865914 AS Decimal(18, 6)), CAST(-79.432139 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7L3', CAST(43.866468 AS Decimal(18, 6)), CAST(-79.430317 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7L4', CAST(43.865948 AS Decimal(18, 6)), CAST(-79.430083 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7L5', CAST(43.864372 AS Decimal(18, 6)), CAST(-79.453220 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7L6', CAST(43.841112 AS Decimal(18, 6)), CAST(-79.436947 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7L7', CAST(43.841244 AS Decimal(18, 6)), CAST(-79.449572 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7L8', CAST(43.865067 AS Decimal(18, 6)), CAST(-79.437307 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7L9', CAST(43.864999 AS Decimal(18, 6)), CAST(-79.439362 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7M1', CAST(43.864780 AS Decimal(18, 6)), CAST(-79.437658 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7M2', CAST(43.864801 AS Decimal(18, 6)), CAST(-79.439982 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7M3', CAST(43.864894 AS Decimal(18, 6)), CAST(-79.448052 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7M4', CAST(43.866015 AS Decimal(18, 6)), CAST(-79.448829 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7M5', CAST(43.865773 AS Decimal(18, 6)), CAST(-79.448616 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7M6', CAST(43.864800 AS Decimal(18, 6)), CAST(-79.449023 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7M7', CAST(43.864614 AS Decimal(18, 6)), CAST(-79.450122 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7M8', CAST(43.864535 AS Decimal(18, 6)), CAST(-79.451511 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7M9', CAST(43.864296 AS Decimal(18, 6)), CAST(-79.450842 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7N1', CAST(43.863926 AS Decimal(18, 6)), CAST(-79.451598 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7N2', CAST(43.856669 AS Decimal(18, 6)), CAST(-79.445457 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7N3', CAST(43.856463 AS Decimal(18, 6)), CAST(-79.444570 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7N4', CAST(43.855845 AS Decimal(18, 6)), CAST(-79.445780 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7N5', CAST(43.856556 AS Decimal(18, 6)), CAST(-79.443831 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7N6', CAST(43.856483 AS Decimal(18, 6)), CAST(-79.443910 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7N7', CAST(43.867231 AS Decimal(18, 6)), CAST(-79.451946 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7N8', CAST(43.867069 AS Decimal(18, 6)), CAST(-79.451873 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7N9', CAST(43.867184 AS Decimal(18, 6)), CAST(-79.451931 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7P1', CAST(43.865468 AS Decimal(18, 6)), CAST(-79.455290 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7P2', CAST(43.865692 AS Decimal(18, 6)), CAST(-79.454340 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7P3', CAST(43.866174 AS Decimal(18, 6)), CAST(-79.454693 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7P4', CAST(43.864790 AS Decimal(18, 6)), CAST(-79.454768 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7P5', CAST(43.864748 AS Decimal(18, 6)), CAST(-79.454085 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7P6', CAST(43.866563 AS Decimal(18, 6)), CAST(-79.452840 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7P7', CAST(43.866203 AS Decimal(18, 6)), CAST(-79.453024 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7P8', CAST(43.867455 AS Decimal(18, 6)), CAST(-79.451590 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7P9', CAST(43.864881 AS Decimal(18, 6)), CAST(-79.456222 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7R1', CAST(43.864925 AS Decimal(18, 6)), CAST(-79.455721 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7R2', CAST(43.864458 AS Decimal(18, 6)), CAST(-79.456692 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7R3', CAST(43.865556 AS Decimal(18, 6)), CAST(-79.454976 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7R4', CAST(43.866180 AS Decimal(18, 6)), CAST(-79.457355 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7R5', CAST(43.865750 AS Decimal(18, 6)), CAST(-79.457168 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7R6', CAST(43.865726 AS Decimal(18, 6)), CAST(-79.456420 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7R7', CAST(43.866733 AS Decimal(18, 6)), CAST(-79.456163 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7R8', CAST(43.865775 AS Decimal(18, 6)), CAST(-79.459397 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7R9', CAST(43.865680 AS Decimal(18, 6)), CAST(-79.459883 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7S1', CAST(43.864886 AS Decimal(18, 6)), CAST(-79.459821 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7S2', CAST(43.864473 AS Decimal(18, 6)), CAST(-79.458524 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7S3', CAST(43.864332 AS Decimal(18, 6)), CAST(-79.458029 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7S4', CAST(43.863854 AS Decimal(18, 6)), CAST(-79.459221 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7S5', CAST(43.865059 AS Decimal(18, 6)), CAST(-79.457474 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7S6', CAST(43.865049 AS Decimal(18, 6)), CAST(-79.458905 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7S7', CAST(43.865325 AS Decimal(18, 6)), CAST(-79.458067 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7S8', CAST(43.863403 AS Decimal(18, 6)), CAST(-79.458164 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7S9', CAST(43.863748 AS Decimal(18, 6)), CAST(-79.456897 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7T1', CAST(43.862867 AS Decimal(18, 6)), CAST(-79.457305 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7T2', CAST(43.863734 AS Decimal(18, 6)), CAST(-79.455868 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7T3', CAST(43.863881 AS Decimal(18, 6)), CAST(-79.455983 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7T4', CAST(43.862349 AS Decimal(18, 6)), CAST(-79.455487 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7T5', CAST(43.862106 AS Decimal(18, 6)), CAST(-79.459938 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7T6', CAST(43.861550 AS Decimal(18, 6)), CAST(-79.461157 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7T7', CAST(43.860512 AS Decimal(18, 6)), CAST(-79.458673 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7T8', CAST(43.860842 AS Decimal(18, 6)), CAST(-79.458512 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7T9', CAST(43.849324 AS Decimal(18, 6)), CAST(-79.454598 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7V1', CAST(43.850008 AS Decimal(18, 6)), CAST(-79.455220 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7V2', CAST(43.876814 AS Decimal(18, 6)), CAST(-79.438491 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7V3', CAST(43.882852 AS Decimal(18, 6)), CAST(-79.466101 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7V4', CAST(43.884067 AS Decimal(18, 6)), CAST(-79.462090 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7V5', CAST(43.884105 AS Decimal(18, 6)), CAST(-79.461937 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7V6', CAST(43.882454 AS Decimal(18, 6)), CAST(-79.462376 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7V7', CAST(43.881331 AS Decimal(18, 6)), CAST(-79.464332 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7V8', CAST(43.881292 AS Decimal(18, 6)), CAST(-79.465328 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7V9', CAST(43.877110 AS Decimal(18, 6)), CAST(-79.459017 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7W1', CAST(43.876740 AS Decimal(18, 6)), CAST(-79.457879 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7W2', CAST(43.877139 AS Decimal(18, 6)), CAST(-79.458533 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7W3', CAST(43.876477 AS Decimal(18, 6)), CAST(-79.459341 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7W4', CAST(43.876205 AS Decimal(18, 6)), CAST(-79.459384 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7W5', CAST(43.876159 AS Decimal(18, 6)), CAST(-79.458910 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7W6', CAST(43.875553 AS Decimal(18, 6)), CAST(-79.461061 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7W7', CAST(43.875450 AS Decimal(18, 6)), CAST(-79.462084 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7W8', CAST(43.875181 AS Decimal(18, 6)), CAST(-79.462621 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7W9', CAST(43.874840 AS Decimal(18, 6)), CAST(-79.461788 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7X1', CAST(43.875204 AS Decimal(18, 6)), CAST(-79.460202 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7X2', CAST(43.874691 AS Decimal(18, 6)), CAST(-79.461133 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7X3', CAST(43.875161 AS Decimal(18, 6)), CAST(-79.459766 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7X4', CAST(43.874164 AS Decimal(18, 6)), CAST(-79.459846 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7X5', CAST(43.874081 AS Decimal(18, 6)), CAST(-79.461646 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7X6', CAST(43.869931 AS Decimal(18, 6)), CAST(-79.459588 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7X7', CAST(43.870079 AS Decimal(18, 6)), CAST(-79.458929 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7X8', CAST(43.870238 AS Decimal(18, 6)), CAST(-79.459131 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7X9', CAST(43.870333 AS Decimal(18, 6)), CAST(-79.456532 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7Y1', CAST(43.869469 AS Decimal(18, 6)), CAST(-79.456355 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7Y2', CAST(43.870798 AS Decimal(18, 6)), CAST(-79.456599 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7Y3', CAST(43.869148 AS Decimal(18, 6)), CAST(-79.459355 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7Y4', CAST(43.869428 AS Decimal(18, 6)), CAST(-79.458039 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7Y5', CAST(43.869276 AS Decimal(18, 6)), CAST(-79.458781 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7Y6', CAST(43.868056 AS Decimal(18, 6)), CAST(-79.461135 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7Y7', CAST(43.868745 AS Decimal(18, 6)), CAST(-79.459953 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7Y8', CAST(43.867824 AS Decimal(18, 6)), CAST(-79.462049 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7Y9', CAST(43.869551 AS Decimal(18, 6)), CAST(-79.461186 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7Z1', CAST(43.868565 AS Decimal(18, 6)), CAST(-79.462497 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7Z2', CAST(43.868274 AS Decimal(18, 6)), CAST(-79.459436 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7Z3', CAST(43.868373 AS Decimal(18, 6)), CAST(-79.459048 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7Z4', CAST(43.871008 AS Decimal(18, 6)), CAST(-79.457530 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7Z5', CAST(43.868004 AS Decimal(18, 6)), CAST(-79.460455 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7Z6', CAST(43.867677 AS Decimal(18, 6)), CAST(-79.460421 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7Z7', CAST(43.867494 AS Decimal(18, 6)), CAST(-79.459796 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7Z8', CAST(43.867120 AS Decimal(18, 6)), CAST(-79.461095 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C7Z9', CAST(43.867362 AS Decimal(18, 6)), CAST(-79.459517 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8A1', CAST(43.867805 AS Decimal(18, 6)), CAST(-79.457991 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8A2', CAST(43.867886 AS Decimal(18, 6)), CAST(-79.457157 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8A3', CAST(43.867840 AS Decimal(18, 6)), CAST(-79.456430 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8A4', CAST(43.868493 AS Decimal(18, 6)), CAST(-79.455564 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8A5', CAST(43.868307 AS Decimal(18, 6)), CAST(-79.455851 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8A6', CAST(43.868182 AS Decimal(18, 6)), CAST(-79.454880 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8A7', CAST(43.870641 AS Decimal(18, 6)), CAST(-79.426303 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8A8', CAST(43.871364 AS Decimal(18, 6)), CAST(-79.426976 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8A9', CAST(43.870541 AS Decimal(18, 6)), CAST(-79.426509 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8B1', CAST(43.870795 AS Decimal(18, 6)), CAST(-79.426242 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8B2', CAST(43.894293 AS Decimal(18, 6)), CAST(-79.450892 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8B3', CAST(43.894103 AS Decimal(18, 6)), CAST(-79.448453 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8B4', CAST(43.878359 AS Decimal(18, 6)), CAST(-79.433999 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8B5', CAST(43.877962 AS Decimal(18, 6)), CAST(-79.433544 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8B6', CAST(43.879519 AS Decimal(18, 6)), CAST(-79.433797 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8B7', CAST(43.877630 AS Decimal(18, 6)), CAST(-79.434951 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8B8', CAST(43.877671 AS Decimal(18, 6)), CAST(-79.433870 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8B9', CAST(43.877600 AS Decimal(18, 6)), CAST(-79.434562 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8C1', CAST(43.846739 AS Decimal(18, 6)), CAST(-79.453674 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8C2', CAST(43.847564 AS Decimal(18, 6)), CAST(-79.454207 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8C3', CAST(43.847227 AS Decimal(18, 6)), CAST(-79.453611 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8C4', CAST(43.843465 AS Decimal(18, 6)), CAST(-79.456171 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8C5', CAST(43.843575 AS Decimal(18, 6)), CAST(-79.453569 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8C6', CAST(43.842384 AS Decimal(18, 6)), CAST(-79.450037 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8C7', CAST(43.842422 AS Decimal(18, 6)), CAST(-79.454224 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8C8', CAST(43.843110 AS Decimal(18, 6)), CAST(-79.454284 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8C9', CAST(43.841712 AS Decimal(18, 6)), CAST(-79.453924 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8E1', CAST(43.846259 AS Decimal(18, 6)), CAST(-79.433316 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8E2', CAST(43.846608 AS Decimal(18, 6)), CAST(-79.433665 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8E3', CAST(43.865979 AS Decimal(18, 6)), CAST(-79.433488 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8E4', CAST(43.866600 AS Decimal(18, 6)), CAST(-79.432083 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8E5', CAST(43.866205 AS Decimal(18, 6)), CAST(-79.431908 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8E6', CAST(43.866960 AS Decimal(18, 6)), CAST(-79.430485 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8E7', CAST(43.867202 AS Decimal(18, 6)), CAST(-79.429355 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8E8', CAST(43.867085 AS Decimal(18, 6)), CAST(-79.429445 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8E9', CAST(43.865905 AS Decimal(18, 6)), CAST(-79.430201 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8G1', CAST(43.865813 AS Decimal(18, 6)), CAST(-79.430902 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8G2', CAST(43.865917 AS Decimal(18, 6)), CAST(-79.429614 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8G3', CAST(43.864745 AS Decimal(18, 6)), CAST(-79.433154 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8G4', CAST(43.865231 AS Decimal(18, 6)), CAST(-79.432229 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8G5', CAST(43.865328 AS Decimal(18, 6)), CAST(-79.431695 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8G6', CAST(43.864588 AS Decimal(18, 6)), CAST(-79.432614 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8G7', CAST(43.864403 AS Decimal(18, 6)), CAST(-79.431607 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8G8', CAST(43.865787 AS Decimal(18, 6)), CAST(-79.433076 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8G9', CAST(43.865763 AS Decimal(18, 6)), CAST(-79.432439 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8H1', CAST(43.863005 AS Decimal(18, 6)), CAST(-79.427574 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8H2', CAST(43.863198 AS Decimal(18, 6)), CAST(-79.427175 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8H3', CAST(43.862963 AS Decimal(18, 6)), CAST(-79.428752 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8H4', CAST(43.862732 AS Decimal(18, 6)), CAST(-79.429098 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8H5', CAST(43.862647 AS Decimal(18, 6)), CAST(-79.429427 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8H6', CAST(43.861788 AS Decimal(18, 6)), CAST(-79.429799 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8H7', CAST(43.862035 AS Decimal(18, 6)), CAST(-79.430980 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8H8', CAST(43.861531 AS Decimal(18, 6)), CAST(-79.430831 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8H9', CAST(43.862413 AS Decimal(18, 6)), CAST(-79.428475 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8J1', CAST(43.861672 AS Decimal(18, 6)), CAST(-79.428939 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8J2', CAST(43.862359 AS Decimal(18, 6)), CAST(-79.428488 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8J3', CAST(43.861304 AS Decimal(18, 6)), CAST(-79.428254 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8J4', CAST(43.862387 AS Decimal(18, 6)), CAST(-79.427105 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8J5', CAST(43.861563 AS Decimal(18, 6)), CAST(-79.427346 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8J6', CAST(43.861199 AS Decimal(18, 6)), CAST(-79.429897 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8J7', CAST(43.860826 AS Decimal(18, 6)), CAST(-79.429776 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8J8', CAST(43.860829 AS Decimal(18, 6)), CAST(-79.429217 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8J9', CAST(43.860099 AS Decimal(18, 6)), CAST(-79.430424 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8K1', CAST(43.860250 AS Decimal(18, 6)), CAST(-79.429715 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8K2', CAST(43.859990 AS Decimal(18, 6)), CAST(-79.430817 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8K3', CAST(43.860208 AS Decimal(18, 6)), CAST(-79.428437 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8K4', CAST(43.860077 AS Decimal(18, 6)), CAST(-79.429049 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8K5', CAST(43.860367 AS Decimal(18, 6)), CAST(-79.428226 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8K6', CAST(43.859925 AS Decimal(18, 6)), CAST(-79.428427 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8K7', CAST(43.859635 AS Decimal(18, 6)), CAST(-79.429059 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8K8', CAST(43.859522 AS Decimal(18, 6)), CAST(-79.429560 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8K9', CAST(43.859041 AS Decimal(18, 6)), CAST(-79.428774 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8L1', CAST(43.868692 AS Decimal(18, 6)), CAST(-79.414677 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8L2', CAST(43.868482 AS Decimal(18, 6)), CAST(-79.415586 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8L3', CAST(43.869493 AS Decimal(18, 6)), CAST(-79.414969 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8L4', CAST(43.869726 AS Decimal(18, 6)), CAST(-79.415466 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8L5', CAST(43.868245 AS Decimal(18, 6)), CAST(-79.418168 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8L6', CAST(43.868114 AS Decimal(18, 6)), CAST(-79.417135 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8L7', CAST(43.867677 AS Decimal(18, 6)), CAST(-79.419947 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8L8', CAST(43.868567 AS Decimal(18, 6)), CAST(-79.420449 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8L9', CAST(43.868765 AS Decimal(18, 6)), CAST(-79.420505 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8M1', CAST(43.868581 AS Decimal(18, 6)), CAST(-79.422346 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8M2', CAST(43.868729 AS Decimal(18, 6)), CAST(-79.420710 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8M3', CAST(43.867266 AS Decimal(18, 6)), CAST(-79.421681 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8M4', CAST(43.867122 AS Decimal(18, 6)), CAST(-79.423356 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8M5', CAST(43.867508 AS Decimal(18, 6)), CAST(-79.423182 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8M6', CAST(43.867772 AS Decimal(18, 6)), CAST(-79.423088 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8M7', CAST(43.867697 AS Decimal(18, 6)), CAST(-79.424132 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8M8', CAST(43.867957 AS Decimal(18, 6)), CAST(-79.423608 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8M9', CAST(43.858657 AS Decimal(18, 6)), CAST(-79.414637 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8N1', CAST(43.858113 AS Decimal(18, 6)), CAST(-79.415998 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8N2', CAST(43.858356 AS Decimal(18, 6)), CAST(-79.415304 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8N3', CAST(43.858405 AS Decimal(18, 6)), CAST(-79.413750 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8N4', CAST(43.857952 AS Decimal(18, 6)), CAST(-79.413700 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8N5', CAST(43.858194 AS Decimal(18, 6)), CAST(-79.413063 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8N6', CAST(43.859179 AS Decimal(18, 6)), CAST(-79.413078 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8N7', CAST(43.859020 AS Decimal(18, 6)), CAST(-79.413604 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8N8', CAST(43.859471 AS Decimal(18, 6)), CAST(-79.412347 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8N9', CAST(43.859678 AS Decimal(18, 6)), CAST(-79.414277 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8P1', CAST(43.859815 AS Decimal(18, 6)), CAST(-79.413572 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8P2', CAST(43.859539 AS Decimal(18, 6)), CAST(-79.415365 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8P3', CAST(43.858854 AS Decimal(18, 6)), CAST(-79.416329 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8P4', CAST(43.859270 AS Decimal(18, 6)), CAST(-79.417000 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8P5', CAST(43.860490 AS Decimal(18, 6)), CAST(-79.414292 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8P6', CAST(43.860407 AS Decimal(18, 6)), CAST(-79.414619 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8P7', CAST(43.860067 AS Decimal(18, 6)), CAST(-79.416229 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8P8', CAST(43.859977 AS Decimal(18, 6)), CAST(-79.418004 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8P9', CAST(43.860199 AS Decimal(18, 6)), CAST(-79.416994 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8R1', CAST(43.858870 AS Decimal(18, 6)), CAST(-79.418596 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8R2', CAST(43.859146 AS Decimal(18, 6)), CAST(-79.419392 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8R3', CAST(43.859421 AS Decimal(18, 6)), CAST(-79.419452 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8R4', CAST(43.858392 AS Decimal(18, 6)), CAST(-79.419581 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8R5', CAST(43.858768 AS Decimal(18, 6)), CAST(-79.419116 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8R6', CAST(43.857845 AS Decimal(18, 6)), CAST(-79.418890 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8R7', CAST(43.857593 AS Decimal(18, 6)), CAST(-79.418796 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8R8', CAST(43.856952 AS Decimal(18, 6)), CAST(-79.419873 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8R9', CAST(43.857097 AS Decimal(18, 6)), CAST(-79.418241 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8S1', CAST(43.857004 AS Decimal(18, 6)), CAST(-79.420229 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8S2', CAST(43.857218 AS Decimal(18, 6)), CAST(-79.417747 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8S3', CAST(43.856641 AS Decimal(18, 6)), CAST(-79.420222 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8S6', CAST(43.836361 AS Decimal(18, 6)), CAST(-79.439898 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8S7', CAST(43.912318 AS Decimal(18, 6)), CAST(-79.447547 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8S8', CAST(43.863116 AS Decimal(18, 6)), CAST(-79.448051 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8S9', CAST(43.858915 AS Decimal(18, 6)), CAST(-79.440919 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8T1', CAST(43.857836 AS Decimal(18, 6)), CAST(-79.437232 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8T2', CAST(43.870516 AS Decimal(18, 6)), CAST(-79.426694 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8T3', CAST(43.872897 AS Decimal(18, 6)), CAST(-79.429918 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8T4', CAST(43.874938 AS Decimal(18, 6)), CAST(-79.420095 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8T5', CAST(43.863677 AS Decimal(18, 6)), CAST(-79.427946 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8T6', CAST(43.863939 AS Decimal(18, 6)), CAST(-79.427565 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8T7', CAST(43.866333 AS Decimal(18, 6)), CAST(-79.425252 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8T8', CAST(43.864270 AS Decimal(18, 6)), CAST(-79.431103 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8T9', CAST(43.858128 AS Decimal(18, 6)), CAST(-79.437834 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8V1', CAST(43.879094 AS Decimal(18, 6)), CAST(-79.430528 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8V2', CAST(43.878725 AS Decimal(18, 6)), CAST(-79.432014 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8V3', CAST(43.879024 AS Decimal(18, 6)), CAST(-79.430897 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8V4', CAST(43.879629 AS Decimal(18, 6)), CAST(-79.431767 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8V5', CAST(43.880008 AS Decimal(18, 6)), CAST(-79.432456 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8V6', CAST(43.879835 AS Decimal(18, 6)), CAST(-79.432725 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8V7', CAST(43.880011 AS Decimal(18, 6)), CAST(-79.431971 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8V8', CAST(43.880660 AS Decimal(18, 6)), CAST(-79.431649 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8V9', CAST(43.880736 AS Decimal(18, 6)), CAST(-79.432930 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8W1', CAST(43.880443 AS Decimal(18, 6)), CAST(-79.432962 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8W2', CAST(43.880478 AS Decimal(18, 6)), CAST(-79.433749 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8W3', CAST(43.879673 AS Decimal(18, 6)), CAST(-79.433623 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8W4', CAST(43.865524 AS Decimal(18, 6)), CAST(-79.421011 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8W5', CAST(43.873164 AS Decimal(18, 6)), CAST(-79.430775 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8W6', CAST(43.873858 AS Decimal(18, 6)), CAST(-79.431598 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8W7', CAST(43.875923 AS Decimal(18, 6)), CAST(-79.415297 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8W8', CAST(43.873707 AS Decimal(18, 6)), CAST(-79.461166 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8W9', CAST(43.860824 AS Decimal(18, 6)), CAST(-79.459892 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8X1', CAST(43.860631 AS Decimal(18, 6)), CAST(-79.460354 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8X2', CAST(43.861337 AS Decimal(18, 6)), CAST(-79.459537 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8X3', CAST(43.867979 AS Decimal(18, 6)), CAST(-79.448405 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8X4', CAST(43.867707 AS Decimal(18, 6)), CAST(-79.449104 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8X5', CAST(43.867079 AS Decimal(18, 6)), CAST(-79.449878 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8X6', CAST(43.867269 AS Decimal(18, 6)), CAST(-79.447071 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8X7', CAST(43.866030 AS Decimal(18, 6)), CAST(-79.445415 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8X8', CAST(43.865726 AS Decimal(18, 6)), CAST(-79.445462 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8X9', CAST(43.866091 AS Decimal(18, 6)), CAST(-79.445489 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8Y1', CAST(43.864942 AS Decimal(18, 6)), CAST(-79.443289 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8Y2', CAST(43.864786 AS Decimal(18, 6)), CAST(-79.444398 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8Y3', CAST(43.864493 AS Decimal(18, 6)), CAST(-79.445069 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8Y4', CAST(43.864549 AS Decimal(18, 6)), CAST(-79.443144 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8Y5', CAST(43.864262 AS Decimal(18, 6)), CAST(-79.442534 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8Y6', CAST(43.865762 AS Decimal(18, 6)), CAST(-79.441612 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8Y7', CAST(43.865426 AS Decimal(18, 6)), CAST(-79.443061 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8Y8', CAST(43.865571 AS Decimal(18, 6)), CAST(-79.440434 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8Y9', CAST(43.871713 AS Decimal(18, 6)), CAST(-79.462493 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8Z1', CAST(43.870547 AS Decimal(18, 6)), CAST(-79.461440 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8Z2', CAST(43.872066 AS Decimal(18, 6)), CAST(-79.462529 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8Z3', CAST(43.872596 AS Decimal(18, 6)), CAST(-79.462106 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8Z4', CAST(43.873074 AS Decimal(18, 6)), CAST(-79.461761 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8Z5', CAST(43.872712 AS Decimal(18, 6)), CAST(-79.461778 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8Z6', CAST(43.876402 AS Decimal(18, 6)), CAST(-79.460970 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8Z7', CAST(43.876100 AS Decimal(18, 6)), CAST(-79.462964 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8Z8', CAST(43.876015 AS Decimal(18, 6)), CAST(-79.463359 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C8Z9', CAST(43.876292 AS Decimal(18, 6)), CAST(-79.464374 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9A1', CAST(43.875914 AS Decimal(18, 6)), CAST(-79.463854 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9A2', CAST(43.867674 AS Decimal(18, 6)), CAST(-79.462470 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9A3', CAST(43.877562 AS Decimal(18, 6)), CAST(-79.461738 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9A4', CAST(43.876664 AS Decimal(18, 6)), CAST(-79.464619 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9A5', CAST(43.877515 AS Decimal(18, 6)), CAST(-79.464807 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9A6', CAST(43.877383 AS Decimal(18, 6)), CAST(-79.463851 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9A7', CAST(43.877757 AS Decimal(18, 6)), CAST(-79.463672 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9A8', CAST(43.877740 AS Decimal(18, 6)), CAST(-79.463049 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9A9', CAST(43.878331 AS Decimal(18, 6)), CAST(-79.464599 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9B1', CAST(43.879341 AS Decimal(18, 6)), CAST(-79.463493 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9B2', CAST(43.879364 AS Decimal(18, 6)), CAST(-79.462847 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9B3', CAST(43.878712 AS Decimal(18, 6)), CAST(-79.464511 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9B4', CAST(43.880422 AS Decimal(18, 6)), CAST(-79.464865 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9B5', CAST(43.879266 AS Decimal(18, 6)), CAST(-79.464489 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9B6', CAST(43.879965 AS Decimal(18, 6)), CAST(-79.464568 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9B7', CAST(43.880090 AS Decimal(18, 6)), CAST(-79.461999 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9B8', CAST(43.880822 AS Decimal(18, 6)), CAST(-79.462975 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9B9', CAST(43.880021 AS Decimal(18, 6)), CAST(-79.462882 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9C1', CAST(43.880499 AS Decimal(18, 6)), CAST(-79.461253 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9C2', CAST(43.881210 AS Decimal(18, 6)), CAST(-79.461357 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9C3', CAST(43.880181 AS Decimal(18, 6)), CAST(-79.461073 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9C4', CAST(43.881288 AS Decimal(18, 6)), CAST(-79.459839 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9C5', CAST(43.880936 AS Decimal(18, 6)), CAST(-79.459629 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9C6', CAST(43.877655 AS Decimal(18, 6)), CAST(-79.460082 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9C7', CAST(43.878122 AS Decimal(18, 6)), CAST(-79.460292 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9C8', CAST(43.878547 AS Decimal(18, 6)), CAST(-79.459901 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9C9', CAST(43.878560 AS Decimal(18, 6)), CAST(-79.460759 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9E1', CAST(43.878734 AS Decimal(18, 6)), CAST(-79.459023 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9E2', CAST(43.879445 AS Decimal(18, 6)), CAST(-79.461562 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9E3', CAST(43.878348 AS Decimal(18, 6)), CAST(-79.461331 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9E4', CAST(43.889366 AS Decimal(18, 6)), CAST(-79.456225 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9E5', CAST(43.886691 AS Decimal(18, 6)), CAST(-79.465005 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9E6', CAST(43.886542 AS Decimal(18, 6)), CAST(-79.464389 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9E7', CAST(43.887371 AS Decimal(18, 6)), CAST(-79.465453 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9E8', CAST(43.887822 AS Decimal(18, 6)), CAST(-79.462985 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9E9', CAST(43.888080 AS Decimal(18, 6)), CAST(-79.464265 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9G1', CAST(43.885481 AS Decimal(18, 6)), CAST(-79.464298 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9G2', CAST(43.885634 AS Decimal(18, 6)), CAST(-79.463919 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9G3', CAST(43.886681 AS Decimal(18, 6)), CAST(-79.463591 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9G4', CAST(43.886620 AS Decimal(18, 6)), CAST(-79.463146 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9G5', CAST(43.886246 AS Decimal(18, 6)), CAST(-79.462867 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9G6', CAST(43.887460 AS Decimal(18, 6)), CAST(-79.462176 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9G7', CAST(43.887096 AS Decimal(18, 6)), CAST(-79.462374 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9G8', CAST(43.886472 AS Decimal(18, 6)), CAST(-79.461861 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9G9', CAST(43.887744 AS Decimal(18, 6)), CAST(-79.461339 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9H1', CAST(43.886877 AS Decimal(18, 6)), CAST(-79.461288 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9H2', CAST(43.887685 AS Decimal(18, 6)), CAST(-79.460638 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9H3', CAST(43.886738 AS Decimal(18, 6)), CAST(-79.459399 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9H4', CAST(43.886706 AS Decimal(18, 6)), CAST(-79.459364 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9H5', CAST(43.887539 AS Decimal(18, 6)), CAST(-79.459384 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9H6', CAST(43.887991 AS Decimal(18, 6)), CAST(-79.458647 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9H7', CAST(43.888692 AS Decimal(18, 6)), CAST(-79.460106 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9H8', CAST(43.888542 AS Decimal(18, 6)), CAST(-79.459624 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9H9', CAST(43.887794 AS Decimal(18, 6)), CAST(-79.458391 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9J1', CAST(43.887668 AS Decimal(18, 6)), CAST(-79.458037 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9J2', CAST(43.888761 AS Decimal(18, 6)), CAST(-79.457540 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9J3', CAST(43.888405 AS Decimal(18, 6)), CAST(-79.456424 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9J4', CAST(43.887961 AS Decimal(18, 6)), CAST(-79.456176 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9J5', CAST(43.887570 AS Decimal(18, 6)), CAST(-79.456784 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9J6', CAST(43.887559 AS Decimal(18, 6)), CAST(-79.455606 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9J7', CAST(43.887633 AS Decimal(18, 6)), CAST(-79.456736 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9J8', CAST(43.887695 AS Decimal(18, 6)), CAST(-79.455000 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9J9', CAST(43.888423 AS Decimal(18, 6)), CAST(-79.454308 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9K1', CAST(43.888177 AS Decimal(18, 6)), CAST(-79.454453 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9K2', CAST(43.889218 AS Decimal(18, 6)), CAST(-79.453500 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9K3', CAST(43.890246 AS Decimal(18, 6)), CAST(-79.453384 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9K4', CAST(43.889745 AS Decimal(18, 6)), CAST(-79.454038 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9K5', CAST(43.888931 AS Decimal(18, 6)), CAST(-79.451328 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9K6', CAST(43.887995 AS Decimal(18, 6)), CAST(-79.452016 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9K7', CAST(43.888550 AS Decimal(18, 6)), CAST(-79.452756 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9K8', CAST(43.889598 AS Decimal(18, 6)), CAST(-79.451092 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9K9', CAST(43.889473 AS Decimal(18, 6)), CAST(-79.451674 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9L1', CAST(43.890486 AS Decimal(18, 6)), CAST(-79.452075 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9L2', CAST(43.890512 AS Decimal(18, 6)), CAST(-79.451278 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9L3', CAST(43.890932 AS Decimal(18, 6)), CAST(-79.450023 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9L4', CAST(43.890630 AS Decimal(18, 6)), CAST(-79.449742 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9L5', CAST(43.889874 AS Decimal(18, 6)), CAST(-79.446965 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9L6', CAST(43.889525 AS Decimal(18, 6)), CAST(-79.448575 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9L7', CAST(43.890010 AS Decimal(18, 6)), CAST(-79.449989 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9L8', CAST(43.889763 AS Decimal(18, 6)), CAST(-79.448868 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9L9', CAST(43.890490 AS Decimal(18, 6)), CAST(-79.449241 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9M1', CAST(43.881819 AS Decimal(18, 6)), CAST(-79.444063 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9M2', CAST(43.889566 AS Decimal(18, 6)), CAST(-79.447442 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9M3', CAST(43.866677 AS Decimal(18, 6)), CAST(-79.440132 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9M4', CAST(43.853748 AS Decimal(18, 6)), CAST(-79.422402 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9M5', CAST(43.871106 AS Decimal(18, 6)), CAST(-79.437165 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9M6', CAST(43.870196 AS Decimal(18, 6)), CAST(-79.436987 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9M7', CAST(43.867559 AS Decimal(18, 6)), CAST(-79.447323 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9M8', CAST(43.872897 AS Decimal(18, 6)), CAST(-79.429918 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9M9', CAST(43.890052 AS Decimal(18, 6)), CAST(-79.441134 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9N1', CAST(43.864117 AS Decimal(18, 6)), CAST(-79.438945 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9N2', CAST(43.851827 AS Decimal(18, 6)), CAST(-79.445738 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9N3', CAST(43.866637 AS Decimal(18, 6)), CAST(-79.432725 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9N4', CAST(43.866303 AS Decimal(18, 6)), CAST(-79.433780 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9N5', CAST(43.881178 AS Decimal(18, 6)), CAST(-79.434589 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9N6', CAST(43.851052 AS Decimal(18, 6)), CAST(-79.445345 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9N7', CAST(43.881790 AS Decimal(18, 6)), CAST(-79.455575 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9N8', CAST(43.882674 AS Decimal(18, 6)), CAST(-79.455839 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9N9', CAST(43.882769 AS Decimal(18, 6)), CAST(-79.452031 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9P1', CAST(43.880976 AS Decimal(18, 6)), CAST(-79.451092 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9P2', CAST(43.880561 AS Decimal(18, 6)), CAST(-79.451497 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9P3', CAST(43.879654 AS Decimal(18, 6)), CAST(-79.453488 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9P4', CAST(43.881118 AS Decimal(18, 6)), CAST(-79.454533 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9P5', CAST(43.881978 AS Decimal(18, 6)), CAST(-79.452472 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9P6', CAST(43.848467 AS Decimal(18, 6)), CAST(-79.444170 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9P7', CAST(43.867830 AS Decimal(18, 6)), CAST(-79.413473 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9P8', CAST(43.835190 AS Decimal(18, 6)), CAST(-79.437291 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9P9', CAST(43.860254 AS Decimal(18, 6)), CAST(-79.451283 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9R0', CAST(43.866587 AS Decimal(18, 6)), CAST(-79.438873 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9R1', CAST(43.865736 AS Decimal(18, 6)), CAST(-79.442144 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9R2', CAST(43.865841 AS Decimal(18, 6)), CAST(-79.443015 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9R3', CAST(43.866623 AS Decimal(18, 6)), CAST(-79.443280 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9R4', CAST(43.865772 AS Decimal(18, 6)), CAST(-79.444331 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9R5', CAST(43.867024 AS Decimal(18, 6)), CAST(-79.444707 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9R6', CAST(43.862943 AS Decimal(18, 6)), CAST(-79.433889 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9R7', CAST(43.863332 AS Decimal(18, 6)), CAST(-79.432867 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9R8', CAST(43.849006 AS Decimal(18, 6)), CAST(-79.456543 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9R9', CAST(43.849951 AS Decimal(18, 6)), CAST(-79.457704 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9S1', CAST(43.851415 AS Decimal(18, 6)), CAST(-79.458135 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9S2', CAST(43.858267 AS Decimal(18, 6)), CAST(-79.452057 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9S3', CAST(43.868367 AS Decimal(18, 6)), CAST(-79.428382 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9S4', CAST(43.866307 AS Decimal(18, 6)), CAST(-79.437844 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9S5', CAST(43.866778 AS Decimal(18, 6)), CAST(-79.442872 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9S6', CAST(43.848300 AS Decimal(18, 6)), CAST(-79.431860 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9S7', CAST(43.881357 AS Decimal(18, 6)), CAST(-79.428471 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9S8', CAST(43.886773 AS Decimal(18, 6)), CAST(-79.451954 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9S9', CAST(43.886082 AS Decimal(18, 6)), CAST(-79.451914 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9T1', CAST(43.860516 AS Decimal(18, 6)), CAST(-79.451347 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9T2', CAST(43.860548 AS Decimal(18, 6)), CAST(-79.451241 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9T3', CAST(43.867709 AS Decimal(18, 6)), CAST(-79.436058 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9T4', CAST(43.888509 AS Decimal(18, 6)), CAST(-79.464892 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9T5', CAST(43.888899 AS Decimal(18, 6)), CAST(-79.463008 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9T6', CAST(43.891684 AS Decimal(18, 6)), CAST(-79.438040 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9T7', CAST(43.891836 AS Decimal(18, 6)), CAST(-79.436226 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9T8', CAST(43.891147 AS Decimal(18, 6)), CAST(-79.437408 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9T9', CAST(43.891286 AS Decimal(18, 6)), CAST(-79.436275 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9V1', CAST(43.892215 AS Decimal(18, 6)), CAST(-79.434200 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9V2', CAST(43.892662 AS Decimal(18, 6)), CAST(-79.434400 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9V3', CAST(43.871481 AS Decimal(18, 6)), CAST(-79.427436 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9V4', CAST(43.867326 AS Decimal(18, 6)), CAST(-79.413274 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9V5', CAST(43.874130 AS Decimal(18, 6)), CAST(-79.423097 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9V6', CAST(43.847084 AS Decimal(18, 6)), CAST(-79.455590 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9V7', CAST(43.862561 AS Decimal(18, 6)), CAST(-79.451396 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9V8', CAST(43.863401 AS Decimal(18, 6)), CAST(-79.431424 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9V9', CAST(43.852104 AS Decimal(18, 6)), CAST(-79.456806 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9W1', CAST(43.851878 AS Decimal(18, 6)), CAST(-79.458823 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9W2', CAST(43.848444 AS Decimal(18, 6)), CAST(-79.455012 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9W3', CAST(43.848205 AS Decimal(18, 6)), CAST(-79.456293 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9W4', CAST(43.875783 AS Decimal(18, 6)), CAST(-79.415330 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9W5', CAST(43.897291 AS Decimal(18, 6)), CAST(-79.448435 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9W6', CAST(43.897682 AS Decimal(18, 6)), CAST(-79.429175 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9W7', CAST(43.896258 AS Decimal(18, 6)), CAST(-79.428159 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9W8', CAST(43.897342 AS Decimal(18, 6)), CAST(-79.428997 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9W9', CAST(43.871862 AS Decimal(18, 6)), CAST(-79.448380 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9X0', CAST(43.857623 AS Decimal(18, 6)), CAST(-79.410857 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9X1', CAST(43.888697 AS Decimal(18, 6)), CAST(-79.443652 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9X2', CAST(43.876020 AS Decimal(18, 6)), CAST(-79.415214 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9X3', CAST(43.866371 AS Decimal(18, 6)), CAST(-79.441220 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9X4', CAST(43.857082 AS Decimal(18, 6)), CAST(-79.410930 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9X5', CAST(43.862105 AS Decimal(18, 6)), CAST(-79.459942 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9X6', CAST(43.857668 AS Decimal(18, 6)), CAST(-79.410869 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9X7', CAST(43.870108 AS Decimal(18, 6)), CAST(-79.413872 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9X8', CAST(43.856000 AS Decimal(18, 6)), CAST(-79.410593 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9X9', CAST(43.868015 AS Decimal(18, 6)), CAST(-79.416821 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9Y1', CAST(43.880183 AS Decimal(18, 6)), CAST(-79.459798 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9Y2', CAST(43.885444 AS Decimal(18, 6)), CAST(-79.467839 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9Y3', CAST(43.886563 AS Decimal(18, 6)), CAST(-79.450139 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9Y4', CAST(43.832219 AS Decimal(18, 6)), CAST(-79.439918 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9Y5', CAST(43.897051 AS Decimal(18, 6)), CAST(-79.430532 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9Y6', CAST(43.897708 AS Decimal(18, 6)), CAST(-79.430011 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9Y7', CAST(43.897342 AS Decimal(18, 6)), CAST(-79.428997 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9Y8', CAST(43.864756 AS Decimal(18, 6)), CAST(-79.429850 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9Y9', CAST(43.864786 AS Decimal(18, 6)), CAST(-79.429761 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9Z1', CAST(43.893911 AS Decimal(18, 6)), CAST(-79.434403 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9Z2', CAST(43.852805 AS Decimal(18, 6)), CAST(-79.426441 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9Z3', CAST(43.852372 AS Decimal(18, 6)), CAST(-79.426184 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9Z4', CAST(43.893217 AS Decimal(18, 6)), CAST(-79.438077 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9Z5', CAST(43.894619 AS Decimal(18, 6)), CAST(-79.438357 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9Z6', CAST(43.894866 AS Decimal(18, 6)), CAST(-79.435397 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9Z7', CAST(43.894188 AS Decimal(18, 6)), CAST(-79.433627 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4C9Z8', CAST(43.893174 AS Decimal(18, 6)), CAST(-79.436400 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0A1', CAST(43.913571 AS Decimal(18, 6)), CAST(-79.470502 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0A2', CAST(43.912601 AS Decimal(18, 6)), CAST(-79.471173 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0A3', CAST(43.912828 AS Decimal(18, 6)), CAST(-79.472108 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0A4', CAST(43.912698 AS Decimal(18, 6)), CAST(-79.473443 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0A5', CAST(43.913520 AS Decimal(18, 6)), CAST(-79.472756 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0A6', CAST(43.914183 AS Decimal(18, 6)), CAST(-79.469394 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0A7', CAST(43.913880 AS Decimal(18, 6)), CAST(-79.465810 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0A8', CAST(43.921185 AS Decimal(18, 6)), CAST(-79.461020 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0A9', CAST(43.921272 AS Decimal(18, 6)), CAST(-79.459979 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0B1', CAST(43.922561 AS Decimal(18, 6)), CAST(-79.460026 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0B2', CAST(43.921760 AS Decimal(18, 6)), CAST(-79.458982 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0B3', CAST(43.921785 AS Decimal(18, 6)), CAST(-79.457314 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0B4', CAST(43.923235 AS Decimal(18, 6)), CAST(-79.457986 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0B5', CAST(43.922790 AS Decimal(18, 6)), CAST(-79.457130 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0B6', CAST(43.924312 AS Decimal(18, 6)), CAST(-79.452683 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0B7', CAST(43.923981 AS Decimal(18, 6)), CAST(-79.451190 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0B8', CAST(43.921280 AS Decimal(18, 6)), CAST(-79.449871 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0B9', CAST(43.925349 AS Decimal(18, 6)), CAST(-79.451719 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0C1', CAST(43.924742 AS Decimal(18, 6)), CAST(-79.452399 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0C2', CAST(43.929136 AS Decimal(18, 6)), CAST(-79.474860 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0C3', CAST(43.930232 AS Decimal(18, 6)), CAST(-79.474386 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0C4', CAST(43.931373 AS Decimal(18, 6)), CAST(-79.474047 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0C5', CAST(43.927646 AS Decimal(18, 6)), CAST(-79.455242 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0C6', CAST(43.923752 AS Decimal(18, 6)), CAST(-79.452381 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0C7', CAST(43.929318 AS Decimal(18, 6)), CAST(-79.454955 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0C8', CAST(43.928057 AS Decimal(18, 6)), CAST(-79.456690 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0C9', CAST(43.963850 AS Decimal(18, 6)), CAST(-79.444480 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0E1', CAST(43.964190 AS Decimal(18, 6)), CAST(-79.445535 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0E2', CAST(43.964993 AS Decimal(18, 6)), CAST(-79.442552 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0E3', CAST(43.964994 AS Decimal(18, 6)), CAST(-79.442552 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0E4', CAST(43.963850 AS Decimal(18, 6)), CAST(-79.444480 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0E5', CAST(43.847834 AS Decimal(18, 6)), CAST(-79.411119 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0E6', CAST(43.910455 AS Decimal(18, 6)), CAST(-79.466614 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0E7', CAST(43.913557 AS Decimal(18, 6)), CAST(-79.468540 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0E8', CAST(43.911549 AS Decimal(18, 6)), CAST(-79.466033 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0E9', CAST(43.912142 AS Decimal(18, 6)), CAST(-79.467300 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0G1', CAST(43.911873 AS Decimal(18, 6)), CAST(-79.465181 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0G2', CAST(43.913733 AS Decimal(18, 6)), CAST(-79.467044 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0G3', CAST(43.944638 AS Decimal(18, 6)), CAST(-79.472560 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0G4', CAST(43.949387 AS Decimal(18, 6)), CAST(-79.465039 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0G5', CAST(43.946580 AS Decimal(18, 6)), CAST(-79.455143 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0G6', CAST(43.947220 AS Decimal(18, 6)), CAST(-79.461211 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0G7', CAST(43.943122 AS Decimal(18, 6)), CAST(-79.454217 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0G8', CAST(43.952010 AS Decimal(18, 6)), CAST(-79.395981 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0G9', CAST(43.938608 AS Decimal(18, 6)), CAST(-79.475836 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0H2', CAST(43.929030 AS Decimal(18, 6)), CAST(-79.409918 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0H3', CAST(43.914591 AS Decimal(18, 6)), CAST(-79.409093 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0H7', CAST(43.948958 AS Decimal(18, 6)), CAST(-79.447006 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0H9', CAST(43.937613 AS Decimal(18, 6)), CAST(-79.436615 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0J1', CAST(43.917839 AS Decimal(18, 6)), CAST(-79.474383 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0J2', CAST(43.918554 AS Decimal(18, 6)), CAST(-79.474364 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0J3', CAST(43.918715 AS Decimal(18, 6)), CAST(-79.472527 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0J4', CAST(43.918365 AS Decimal(18, 6)), CAST(-79.472516 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0J5', CAST(43.918707 AS Decimal(18, 6)), CAST(-79.471228 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0J6', CAST(43.919631 AS Decimal(18, 6)), CAST(-79.470246 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0J7', CAST(43.918921 AS Decimal(18, 6)), CAST(-79.469310 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0J8', CAST(43.918644 AS Decimal(18, 6)), CAST(-79.464077 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0J9', CAST(43.920091 AS Decimal(18, 6)), CAST(-79.467507 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0K0', CAST(43.875666 AS Decimal(18, 6)), CAST(-79.443908 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0K1', CAST(43.920064 AS Decimal(18, 6)), CAST(-79.466104 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0K2', CAST(43.922505 AS Decimal(18, 6)), CAST(-79.449355 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0K3', CAST(43.939321 AS Decimal(18, 6)), CAST(-79.398113 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0K4', CAST(43.903880 AS Decimal(18, 6)), CAST(-79.445226 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0K5', CAST(43.952393 AS Decimal(18, 6)), CAST(-79.456498 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0K6', CAST(43.914442 AS Decimal(18, 6)), CAST(-79.450020 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0K7', CAST(43.989547 AS Decimal(18, 6)), CAST(-79.465506 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0K8', CAST(43.932167 AS Decimal(18, 6)), CAST(-79.451761 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0K9', CAST(43.940259 AS Decimal(18, 6)), CAST(-79.436984 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0L2', CAST(43.956291 AS Decimal(18, 6)), CAST(-79.457331 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0L3', CAST(43.935726 AS Decimal(18, 6)), CAST(-79.478770 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0L4', CAST(43.921149 AS Decimal(18, 6)), CAST(-79.471854 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0L5', CAST(43.921530 AS Decimal(18, 6)), CAST(-79.473280 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0L6', CAST(43.921099 AS Decimal(18, 6)), CAST(-79.474476 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0L7', CAST(43.920494 AS Decimal(18, 6)), CAST(-79.469598 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0L8', CAST(43.920111 AS Decimal(18, 6)), CAST(-79.472021 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0L9', CAST(43.921162 AS Decimal(18, 6)), CAST(-79.470485 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0M1', CAST(43.922041 AS Decimal(18, 6)), CAST(-79.467560 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0M2', CAST(43.922710 AS Decimal(18, 6)), CAST(-79.470319 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0M3', CAST(43.922332 AS Decimal(18, 6)), CAST(-79.472028 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0M4', CAST(43.919629 AS Decimal(18, 6)), CAST(-79.474105 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0M5', CAST(43.919427 AS Decimal(18, 6)), CAST(-79.473263 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0M6', CAST(43.920471 AS Decimal(18, 6)), CAST(-79.473567 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0M7', CAST(43.919984 AS Decimal(18, 6)), CAST(-79.475158 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0M8', CAST(43.921155 AS Decimal(18, 6)), CAST(-79.474574 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0M9', CAST(43.920494 AS Decimal(18, 6)), CAST(-79.475498 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0N1', CAST(43.930899 AS Decimal(18, 6)), CAST(-79.478211 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0N2', CAST(43.930601 AS Decimal(18, 6)), CAST(-79.476172 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0N3', CAST(43.929739 AS Decimal(18, 6)), CAST(-79.477775 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0N4', CAST(43.912340 AS Decimal(18, 6)), CAST(-79.437190 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0N5', CAST(43.912446 AS Decimal(18, 6)), CAST(-79.431689 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0N6', CAST(43.917445 AS Decimal(18, 6)), CAST(-79.438659 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0N7', CAST(43.917330 AS Decimal(18, 6)), CAST(-79.431209 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0N9', CAST(43.919601 AS Decimal(18, 6)), CAST(-79.450714 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0P1', CAST(43.916175 AS Decimal(18, 6)), CAST(-79.439896 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0P2', CAST(43.945766 AS Decimal(18, 6)), CAST(-79.480987 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0P3', CAST(43.938728 AS Decimal(18, 6)), CAST(-79.476775 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0P4', CAST(43.940383 AS Decimal(18, 6)), CAST(-79.478837 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0P5', CAST(43.938147 AS Decimal(18, 6)), CAST(-79.478262 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0P6', CAST(43.916136 AS Decimal(18, 6)), CAST(-79.470448 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0P7', CAST(43.916135 AS Decimal(18, 6)), CAST(-79.467715 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0P8', CAST(43.914973 AS Decimal(18, 6)), CAST(-79.468553 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0P9', CAST(43.915694 AS Decimal(18, 6)), CAST(-79.466889 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0R1', CAST(43.915153 AS Decimal(18, 6)), CAST(-79.465781 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0R2', CAST(43.917839 AS Decimal(18, 6)), CAST(-79.467128 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0R3', CAST(43.916474 AS Decimal(18, 6)), CAST(-79.467744 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0R4', CAST(43.915339 AS Decimal(18, 6)), CAST(-79.469852 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0R5', CAST(43.942518 AS Decimal(18, 6)), CAST(-79.478530 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0R6', CAST(43.942213 AS Decimal(18, 6)), CAST(-79.478030 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0R7', CAST(43.917472 AS Decimal(18, 6)), CAST(-79.468443 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0R8', CAST(43.917822 AS Decimal(18, 6)), CAST(-79.468885 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0R9', CAST(43.916463 AS Decimal(18, 6)), CAST(-79.471349 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0S1', CAST(43.913982 AS Decimal(18, 6)), CAST(-79.473248 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0S2', CAST(43.915808 AS Decimal(18, 6)), CAST(-79.474235 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0S3', CAST(43.916774 AS Decimal(18, 6)), CAST(-79.472905 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0S4', CAST(43.918869 AS Decimal(18, 6)), CAST(-79.467849 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0S5', CAST(43.915813 AS Decimal(18, 6)), CAST(-79.473285 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0S6', CAST(43.917124 AS Decimal(18, 6)), CAST(-79.465692 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0S7', CAST(43.920754 AS Decimal(18, 6)), CAST(-79.466299 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0S8', CAST(43.925013 AS Decimal(18, 6)), CAST(-79.470682 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0S9', CAST(43.922925 AS Decimal(18, 6)), CAST(-79.468547 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0T1', CAST(43.912573 AS Decimal(18, 6)), CAST(-79.429397 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0T2', CAST(43.946055 AS Decimal(18, 6)), CAST(-79.445197 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0T3', CAST(43.947420 AS Decimal(18, 6)), CAST(-79.480886 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0T4', CAST(43.947611 AS Decimal(18, 6)), CAST(-79.478821 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0T5', CAST(43.949205 AS Decimal(18, 6)), CAST(-79.473898 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0T6', CAST(43.949899 AS Decimal(18, 6)), CAST(-79.471806 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0T7', CAST(43.942855 AS Decimal(18, 6)), CAST(-79.454155 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0T8', CAST(43.913221 AS Decimal(18, 6)), CAST(-79.473301 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0T9', CAST(43.917317 AS Decimal(18, 6)), CAST(-79.435755 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0V1', CAST(43.917095 AS Decimal(18, 6)), CAST(-79.440182 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0V2', CAST(43.916700 AS Decimal(18, 6)), CAST(-79.440675 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0V3', CAST(43.916262 AS Decimal(18, 6)), CAST(-79.441721 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0V4', CAST(43.916328 AS Decimal(18, 6)), CAST(-79.445448 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0V5', CAST(43.916027 AS Decimal(18, 6)), CAST(-79.445089 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0V6', CAST(43.937453 AS Decimal(18, 6)), CAST(-79.480056 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0V7', CAST(43.937812 AS Decimal(18, 6)), CAST(-79.477556 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0V8', CAST(43.936052 AS Decimal(18, 6)), CAST(-79.479744 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0V9', CAST(43.936787 AS Decimal(18, 6)), CAST(-79.478167 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0W1', CAST(43.936427 AS Decimal(18, 6)), CAST(-79.477234 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0W2', CAST(43.937000 AS Decimal(18, 6)), CAST(-79.476235 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0W3', CAST(43.942462 AS Decimal(18, 6)), CAST(-79.480166 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0W4', CAST(43.911998 AS Decimal(18, 6)), CAST(-79.433596 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0W5', CAST(43.926985 AS Decimal(18, 6)), CAST(-79.450496 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0W6', CAST(43.905969 AS Decimal(18, 6)), CAST(-79.445768 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0W7', CAST(43.966011 AS Decimal(18, 6)), CAST(-79.439273 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0W8', CAST(43.910059 AS Decimal(18, 6)), CAST(-79.472791 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0W9', CAST(43.909251 AS Decimal(18, 6)), CAST(-79.471769 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0X1', CAST(43.909055 AS Decimal(18, 6)), CAST(-79.472741 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0X2', CAST(43.908279 AS Decimal(18, 6)), CAST(-79.471973 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0X3', CAST(43.903899 AS Decimal(18, 6)), CAST(-79.466377 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0X4', CAST(43.907181 AS Decimal(18, 6)), CAST(-79.470375 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0X5', CAST(43.907354 AS Decimal(18, 6)), CAST(-79.471574 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0X6', CAST(43.906194 AS Decimal(18, 6)), CAST(-79.470395 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0X7', CAST(43.905586 AS Decimal(18, 6)), CAST(-79.470824 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0X8', CAST(43.905672 AS Decimal(18, 6)), CAST(-79.471980 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0X9', CAST(43.914522 AS Decimal(18, 6)), CAST(-79.449576 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0Y1', CAST(43.926591 AS Decimal(18, 6)), CAST(-79.453599 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0Y2', CAST(43.927768 AS Decimal(18, 6)), CAST(-79.454094 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0Y8', CAST(43.944457 AS Decimal(18, 6)), CAST(-79.424333 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0Y9', CAST(43.943932 AS Decimal(18, 6)), CAST(-79.425966 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0Z1', CAST(43.944167 AS Decimal(18, 6)), CAST(-79.427218 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0Z2', CAST(43.943228 AS Decimal(18, 6)), CAST(-79.426681 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0Z4', CAST(43.945074 AS Decimal(18, 6)), CAST(-79.424976 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0Z5', CAST(43.957144 AS Decimal(18, 6)), CAST(-79.480151 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0Z6', CAST(43.942969 AS Decimal(18, 6)), CAST(-79.480795 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0Z7', CAST(43.958171 AS Decimal(18, 6)), CAST(-79.465037 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0Z8', CAST(43.943509 AS Decimal(18, 6)), CAST(-79.481532 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E0Z9', CAST(43.916898 AS Decimal(18, 6)), CAST(-79.445794 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1A0', CAST(43.946794 AS Decimal(18, 6)), CAST(-79.455182 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1A1', CAST(43.945245 AS Decimal(18, 6)), CAST(-79.454640 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1A2', CAST(43.954174 AS Decimal(18, 6)), CAST(-79.401826 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1A3', CAST(43.928579 AS Decimal(18, 6)), CAST(-79.450255 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1A4', CAST(43.947059 AS Decimal(18, 6)), CAST(-79.456187 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1A5', CAST(43.945405 AS Decimal(18, 6)), CAST(-79.455679 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1A6', CAST(43.946006 AS Decimal(18, 6)), CAST(-79.456840 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1A7', CAST(43.944126 AS Decimal(18, 6)), CAST(-79.453938 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1A8', CAST(43.946700 AS Decimal(18, 6)), CAST(-79.453820 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1A9', CAST(43.951878 AS Decimal(18, 6)), CAST(-79.460697 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1B0', CAST(43.873692 AS Decimal(18, 6)), CAST(-79.447802 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1B1', CAST(43.961549 AS Decimal(18, 6)), CAST(-79.445610 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1B2', CAST(43.953493 AS Decimal(18, 6)), CAST(-79.459462 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1B3', CAST(43.953542 AS Decimal(18, 6)), CAST(-79.459655 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1B4', CAST(43.917116 AS Decimal(18, 6)), CAST(-79.446458 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1B5', CAST(43.917049 AS Decimal(18, 6)), CAST(-79.446782 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1B6', CAST(43.950025 AS Decimal(18, 6)), CAST(-79.455917 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1B7', CAST(43.939347 AS Decimal(18, 6)), CAST(-79.479263 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1B8', CAST(43.962769 AS Decimal(18, 6)), CAST(-79.449621 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1B9', CAST(43.962685 AS Decimal(18, 6)), CAST(-79.447820 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1C1', CAST(43.943932 AS Decimal(18, 6)), CAST(-79.481570 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1C2', CAST(43.944850 AS Decimal(18, 6)), CAST(-79.482597 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1C3', CAST(43.965354 AS Decimal(18, 6)), CAST(-79.438581 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1C4', CAST(43.953141 AS Decimal(18, 6)), CAST(-79.483647 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1C5', CAST(43.950895 AS Decimal(18, 6)), CAST(-79.422009 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1C6', CAST(43.966065 AS Decimal(18, 6)), CAST(-79.438437 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1C7', CAST(43.965221 AS Decimal(18, 6)), CAST(-79.434881 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1C8', CAST(43.965222 AS Decimal(18, 6)), CAST(-79.434881 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1C9', CAST(43.955256 AS Decimal(18, 6)), CAST(-79.433480 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1E1', CAST(43.965223 AS Decimal(18, 6)), CAST(-79.434881 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1E2', CAST(43.952913 AS Decimal(18, 6)), CAST(-79.466506 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1E3', CAST(43.955637 AS Decimal(18, 6)), CAST(-79.470267 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1E4', CAST(43.952554 AS Decimal(18, 6)), CAST(-79.466231 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1E5', CAST(43.954888 AS Decimal(18, 6)), CAST(-79.470115 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1E6', CAST(43.954788 AS Decimal(18, 6)), CAST(-79.458297 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1E7', CAST(43.953519 AS Decimal(18, 6)), CAST(-79.461003 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1E8', CAST(43.954778 AS Decimal(18, 6)), CAST(-79.458646 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1E9', CAST(43.952764 AS Decimal(18, 6)), CAST(-79.464161 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1G1', CAST(43.952419 AS Decimal(18, 6)), CAST(-79.465894 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1G2', CAST(43.956051 AS Decimal(18, 6)), CAST(-79.465628 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1G3', CAST(43.956054 AS Decimal(18, 6)), CAST(-79.465613 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1G4', CAST(43.955858 AS Decimal(18, 6)), CAST(-79.466928 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1G5', CAST(43.945374 AS Decimal(18, 6)), CAST(-79.468435 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1G6', CAST(43.945571 AS Decimal(18, 6)), CAST(-79.469133 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1G7', CAST(43.923549 AS Decimal(18, 6)), CAST(-79.460002 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1G8', CAST(43.924893 AS Decimal(18, 6)), CAST(-79.463970 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1G9', CAST(43.943457 AS Decimal(18, 6)), CAST(-79.459968 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1H1', CAST(43.943458 AS Decimal(18, 6)), CAST(-79.459968 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1H2', CAST(43.942893 AS Decimal(18, 6)), CAST(-79.455768 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1H3', CAST(43.956890 AS Decimal(18, 6)), CAST(-79.433175 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1H4', CAST(43.956619 AS Decimal(18, 6)), CAST(-79.433099 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1H5', CAST(43.953732 AS Decimal(18, 6)), CAST(-79.466763 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1H6', CAST(43.955901 AS Decimal(18, 6)), CAST(-79.468911 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1H7', CAST(43.949506 AS Decimal(18, 6)), CAST(-79.477337 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1H8', CAST(43.957756 AS Decimal(18, 6)), CAST(-79.464334 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1H9', CAST(43.955007 AS Decimal(18, 6)), CAST(-79.469110 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1J1', CAST(43.951879 AS Decimal(18, 6)), CAST(-79.460697 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1J2', CAST(43.953587 AS Decimal(18, 6)), CAST(-79.465142 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1J3', CAST(43.946963 AS Decimal(18, 6)), CAST(-79.477874 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1J4', CAST(43.948154 AS Decimal(18, 6)), CAST(-79.476645 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1J5', CAST(43.945406 AS Decimal(18, 6)), CAST(-79.448541 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1J6', CAST(43.951330 AS Decimal(18, 6)), CAST(-79.437077 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1J7', CAST(43.944287 AS Decimal(18, 6)), CAST(-79.447903 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1J8', CAST(43.961902 AS Decimal(18, 6)), CAST(-79.437111 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1J9', CAST(43.959573 AS Decimal(18, 6)), CAST(-79.436818 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1K1', CAST(43.961550 AS Decimal(18, 6)), CAST(-79.445610 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1K2', CAST(43.943459 AS Decimal(18, 6)), CAST(-79.459968 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1K3', CAST(43.949126 AS Decimal(18, 6)), CAST(-79.461126 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1K4', CAST(43.949294 AS Decimal(18, 6)), CAST(-79.461194 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1K5', CAST(43.944509 AS Decimal(18, 6)), CAST(-79.482652 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1K6', CAST(43.956065 AS Decimal(18, 6)), CAST(-79.437561 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1K7', CAST(43.946880 AS Decimal(18, 6)), CAST(-79.469039 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1K8', CAST(43.938162 AS Decimal(18, 6)), CAST(-79.436632 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1K9', CAST(43.944422 AS Decimal(18, 6)), CAST(-79.462157 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1L1', CAST(43.943723 AS Decimal(18, 6)), CAST(-79.462277 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1L2', CAST(43.943810 AS Decimal(18, 6)), CAST(-79.462333 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1L3', CAST(43.943536 AS Decimal(18, 6)), CAST(-79.462326 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1L4', CAST(43.943460 AS Decimal(18, 6)), CAST(-79.459968 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1L5', CAST(43.924894 AS Decimal(18, 6)), CAST(-79.463970 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1L6', CAST(43.924895 AS Decimal(18, 6)), CAST(-79.463970 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1L7', CAST(43.943487 AS Decimal(18, 6)), CAST(-79.459916 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1L8', CAST(43.943462 AS Decimal(18, 6)), CAST(-79.459968 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1L9', CAST(43.938162 AS Decimal(18, 6)), CAST(-79.436632 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1M1', CAST(43.924896 AS Decimal(18, 6)), CAST(-79.463970 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1M2', CAST(43.948155 AS Decimal(18, 6)), CAST(-79.476645 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1M3', CAST(43.943464 AS Decimal(18, 6)), CAST(-79.459968 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1M4', CAST(43.943465 AS Decimal(18, 6)), CAST(-79.459968 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1M5', CAST(43.943466 AS Decimal(18, 6)), CAST(-79.459968 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1M6', CAST(43.947031 AS Decimal(18, 6)), CAST(-79.447667 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1M7', CAST(43.950319 AS Decimal(18, 6)), CAST(-79.444845 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1M8', CAST(43.949399 AS Decimal(18, 6)), CAST(-79.442095 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1M9', CAST(43.947761 AS Decimal(18, 6)), CAST(-79.448477 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1N1', CAST(43.948933 AS Decimal(18, 6)), CAST(-79.444672 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1N2', CAST(43.944441 AS Decimal(18, 6)), CAST(-79.482615 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1N3', CAST(43.944496 AS Decimal(18, 6)), CAST(-79.482650 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1N4', CAST(43.946217 AS Decimal(18, 6)), CAST(-79.482055 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1N5', CAST(43.943711 AS Decimal(18, 6)), CAST(-79.467058 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1N6', CAST(43.943054 AS Decimal(18, 6)), CAST(-79.466906 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1N7', CAST(43.946105 AS Decimal(18, 6)), CAST(-79.482051 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1N8', CAST(43.947611 AS Decimal(18, 6)), CAST(-79.458858 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1N9', CAST(43.945818 AS Decimal(18, 6)), CAST(-79.464810 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1P1', CAST(43.946894 AS Decimal(18, 6)), CAST(-79.465828 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1P2', CAST(43.946346 AS Decimal(18, 6)), CAST(-79.465281 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1P3', CAST(43.947780 AS Decimal(18, 6)), CAST(-79.458928 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1P4', CAST(43.947084 AS Decimal(18, 6)), CAST(-79.457633 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1P5', CAST(43.946438 AS Decimal(18, 6)), CAST(-79.466730 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1P6', CAST(43.954198 AS Decimal(18, 6)), CAST(-79.433947 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1P7', CAST(43.956760 AS Decimal(18, 6)), CAST(-79.434371 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1P8', CAST(43.954936 AS Decimal(18, 6)), CAST(-79.434229 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1P9', CAST(43.957925 AS Decimal(18, 6)), CAST(-79.435066 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1R1', CAST(43.957950 AS Decimal(18, 6)), CAST(-79.435131 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1R2', CAST(43.947225 AS Decimal(18, 6)), CAST(-79.452426 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1R3', CAST(43.947764 AS Decimal(18, 6)), CAST(-79.449129 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1R4', CAST(43.951549 AS Decimal(18, 6)), CAST(-79.441095 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1R5', CAST(43.952264 AS Decimal(18, 6)), CAST(-79.438448 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1R6', CAST(43.952105 AS Decimal(18, 6)), CAST(-79.440733 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1R7', CAST(43.947174 AS Decimal(18, 6)), CAST(-79.452862 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1R8', CAST(43.952106 AS Decimal(18, 6)), CAST(-79.440733 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1R9', CAST(43.952121 AS Decimal(18, 6)), CAST(-79.439132 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1S1', CAST(43.954564 AS Decimal(18, 6)), CAST(-79.436897 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1S2', CAST(43.953629 AS Decimal(18, 6)), CAST(-79.435234 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1S3', CAST(43.953581 AS Decimal(18, 6)), CAST(-79.433857 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1S4', CAST(43.946919 AS Decimal(18, 6)), CAST(-79.465712 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1S5', CAST(43.942507 AS Decimal(18, 6)), CAST(-79.464669 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1S6', CAST(43.943598 AS Decimal(18, 6)), CAST(-79.464482 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1S7', CAST(43.945027 AS Decimal(18, 6)), CAST(-79.465059 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1S8', CAST(43.947547 AS Decimal(18, 6)), CAST(-79.466092 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1S9', CAST(43.943293 AS Decimal(18, 6)), CAST(-79.464483 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1T1', CAST(43.946869 AS Decimal(18, 6)), CAST(-79.465946 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1T2', CAST(43.947730 AS Decimal(18, 6)), CAST(-79.466298 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1T3', CAST(43.943467 AS Decimal(18, 6)), CAST(-79.459968 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1T4', CAST(43.943468 AS Decimal(18, 6)), CAST(-79.459968 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1T5', CAST(43.943896 AS Decimal(18, 6)), CAST(-79.467463 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1T6', CAST(43.943634 AS Decimal(18, 6)), CAST(-79.468746 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1T7', CAST(43.944298 AS Decimal(18, 6)), CAST(-79.466052 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1T8', CAST(43.943789 AS Decimal(18, 6)), CAST(-79.481782 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1T9', CAST(43.943961 AS Decimal(18, 6)), CAST(-79.481832 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1V1', CAST(43.943097 AS Decimal(18, 6)), CAST(-79.482017 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1V2', CAST(43.943264 AS Decimal(18, 6)), CAST(-79.481570 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1V3', CAST(43.942048 AS Decimal(18, 6)), CAST(-79.478968 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1V4', CAST(43.943040 AS Decimal(18, 6)), CAST(-79.475300 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1V5', CAST(43.938162 AS Decimal(18, 6)), CAST(-79.436632 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1V6', CAST(43.943719 AS Decimal(18, 6)), CAST(-79.472343 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1V7', CAST(43.942993 AS Decimal(18, 6)), CAST(-79.475678 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1V8', CAST(43.954318 AS Decimal(18, 6)), CAST(-79.452601 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1V9', CAST(43.955624 AS Decimal(18, 6)), CAST(-79.463404 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1W1', CAST(43.954395 AS Decimal(18, 6)), CAST(-79.461896 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1W2', CAST(43.951421 AS Decimal(18, 6)), CAST(-79.438096 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1W3', CAST(43.951844 AS Decimal(18, 6)), CAST(-79.438317 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1W4', CAST(43.938162 AS Decimal(18, 6)), CAST(-79.436632 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1W5', CAST(43.943854 AS Decimal(18, 6)), CAST(-79.461776 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1W6', CAST(43.942817 AS Decimal(18, 6)), CAST(-79.463196 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1W7', CAST(43.943243 AS Decimal(18, 6)), CAST(-79.463224 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1W8', CAST(43.961045 AS Decimal(18, 6)), CAST(-79.440870 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1W9', CAST(43.962152 AS Decimal(18, 6)), CAST(-79.444529 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1X1', CAST(43.957880 AS Decimal(18, 6)), CAST(-79.457689 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1X2', CAST(43.943542 AS Decimal(18, 6)), CAST(-79.453683 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1X3', CAST(43.943937 AS Decimal(18, 6)), CAST(-79.436316 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1X4', CAST(43.945764 AS Decimal(18, 6)), CAST(-79.432664 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1X5', CAST(43.944145 AS Decimal(18, 6)), CAST(-79.452096 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1X6', CAST(43.938162 AS Decimal(18, 6)), CAST(-79.436632 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1X7', CAST(43.944040 AS Decimal(18, 6)), CAST(-79.439797 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1X8', CAST(43.945155 AS Decimal(18, 6)), CAST(-79.435340 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1X9', CAST(43.948221 AS Decimal(18, 6)), CAST(-79.445214 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1Y1', CAST(43.948205 AS Decimal(18, 6)), CAST(-79.446247 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1Y2', CAST(43.941595 AS Decimal(18, 6)), CAST(-79.475247 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1Y3', CAST(43.942609 AS Decimal(18, 6)), CAST(-79.475872 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1Y4', CAST(43.941968 AS Decimal(18, 6)), CAST(-79.479428 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1Y5', CAST(43.945819 AS Decimal(18, 6)), CAST(-79.464810 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1Y6', CAST(43.952491 AS Decimal(18, 6)), CAST(-79.436339 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1Y7', CAST(43.951961 AS Decimal(18, 6)), CAST(-79.437323 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1Y8', CAST(43.952632 AS Decimal(18, 6)), CAST(-79.436249 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1Y9', CAST(43.954695 AS Decimal(18, 6)), CAST(-79.441587 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1Z1', CAST(43.952602 AS Decimal(18, 6)), CAST(-79.436490 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1Z2', CAST(43.955062 AS Decimal(18, 6)), CAST(-79.435558 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1Z3', CAST(43.942044 AS Decimal(18, 6)), CAST(-79.459706 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1Z4', CAST(43.941947 AS Decimal(18, 6)), CAST(-79.453945 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1Z5', CAST(43.945834 AS Decimal(18, 6)), CAST(-79.455319 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1Z6', CAST(43.951880 AS Decimal(18, 6)), CAST(-79.460697 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1Z7', CAST(43.955028 AS Decimal(18, 6)), CAST(-79.455486 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1Z8', CAST(43.941923 AS Decimal(18, 6)), CAST(-79.454165 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E1Z9', CAST(43.942695 AS Decimal(18, 6)), CAST(-79.454118 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2A1', CAST(43.945393 AS Decimal(18, 6)), CAST(-79.460358 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2A2', CAST(43.946926 AS Decimal(18, 6)), CAST(-79.462463 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2A3', CAST(43.949894 AS Decimal(18, 6)), CAST(-79.455180 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2A4', CAST(43.950624 AS Decimal(18, 6)), CAST(-79.458842 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2A5', CAST(43.958342 AS Decimal(18, 6)), CAST(-79.457921 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2A6', CAST(43.943027 AS Decimal(18, 6)), CAST(-79.438530 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2A7', CAST(43.921090 AS Decimal(18, 6)), CAST(-79.476020 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2A8', CAST(43.946945 AS Decimal(18, 6)), CAST(-79.430833 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2A9', CAST(43.957120 AS Decimal(18, 6)), CAST(-79.467110 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2B1', CAST(43.948082 AS Decimal(18, 6)), CAST(-79.459742 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2B2', CAST(43.944636 AS Decimal(18, 6)), CAST(-79.477063 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2B3', CAST(43.942939 AS Decimal(18, 6)), CAST(-79.449207 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2B4', CAST(43.933245 AS Decimal(18, 6)), CAST(-79.476062 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2B5', CAST(43.949030 AS Decimal(18, 6)), CAST(-79.435399 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2B6', CAST(43.943469 AS Decimal(18, 6)), CAST(-79.459968 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2B7', CAST(43.945820 AS Decimal(18, 6)), CAST(-79.464810 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2B8', CAST(43.953264 AS Decimal(18, 6)), CAST(-79.452129 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2B9', CAST(43.958900 AS Decimal(18, 6)), CAST(-79.470760 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2C1', CAST(43.958226 AS Decimal(18, 6)), CAST(-79.470809 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2C2', CAST(43.959548 AS Decimal(18, 6)), CAST(-79.471019 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2C3', CAST(43.957950 AS Decimal(18, 6)), CAST(-79.469635 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2C4', CAST(43.958459 AS Decimal(18, 6)), CAST(-79.467386 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2C5', CAST(43.957926 AS Decimal(18, 6)), CAST(-79.464405 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2C6', CAST(43.955684 AS Decimal(18, 6)), CAST(-79.449619 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2C7', CAST(43.956566 AS Decimal(18, 6)), CAST(-79.451452 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2C8', CAST(43.958795 AS Decimal(18, 6)), CAST(-79.473648 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2C9', CAST(43.958827 AS Decimal(18, 6)), CAST(-79.473409 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2E1', CAST(43.960216 AS Decimal(18, 6)), CAST(-79.469686 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2E2', CAST(43.954809 AS Decimal(18, 6)), CAST(-79.450952 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2E3', CAST(43.954865 AS Decimal(18, 6)), CAST(-79.454921 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2E4', CAST(43.955537 AS Decimal(18, 6)), CAST(-79.450856 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2E5', CAST(43.955036 AS Decimal(18, 6)), CAST(-79.455243 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2E6', CAST(43.955092 AS Decimal(18, 6)), CAST(-79.453467 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2E7', CAST(43.958704 AS Decimal(18, 6)), CAST(-79.461157 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2E8', CAST(43.950929 AS Decimal(18, 6)), CAST(-79.451776 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2E9', CAST(43.950107 AS Decimal(18, 6)), CAST(-79.454305 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2G1', CAST(43.951932 AS Decimal(18, 6)), CAST(-79.451720 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2G2', CAST(43.949691 AS Decimal(18, 6)), CAST(-79.453614 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2G3', CAST(43.951976 AS Decimal(18, 6)), CAST(-79.451087 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2G4', CAST(43.951569 AS Decimal(18, 6)), CAST(-79.450959 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2G5', CAST(43.952147 AS Decimal(18, 6)), CAST(-79.451143 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2G6', CAST(43.951698 AS Decimal(18, 6)), CAST(-79.452738 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2G7', CAST(43.951053 AS Decimal(18, 6)), CAST(-79.452576 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2G8', CAST(43.953422 AS Decimal(18, 6)), CAST(-79.454499 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2G9', CAST(43.953451 AS Decimal(18, 6)), CAST(-79.454259 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2H1', CAST(43.952002 AS Decimal(18, 6)), CAST(-79.450404 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2H2', CAST(43.951024 AS Decimal(18, 6)), CAST(-79.450456 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2H3', CAST(43.948817 AS Decimal(18, 6)), CAST(-79.453879 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2H4', CAST(43.949416 AS Decimal(18, 6)), CAST(-79.454265 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2H5', CAST(43.950160 AS Decimal(18, 6)), CAST(-79.454086 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2H6', CAST(43.950128 AS Decimal(18, 6)), CAST(-79.453302 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2H7', CAST(43.949871 AS Decimal(18, 6)), CAST(-79.454933 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2H8', CAST(43.959439 AS Decimal(18, 6)), CAST(-79.470943 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2H9', CAST(43.959802 AS Decimal(18, 6)), CAST(-79.470611 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2J1', CAST(43.958326 AS Decimal(18, 6)), CAST(-79.473129 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2J2', CAST(43.958877 AS Decimal(18, 6)), CAST(-79.472307 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2J3', CAST(43.958473 AS Decimal(18, 6)), CAST(-79.472928 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2J4', CAST(43.957173 AS Decimal(18, 6)), CAST(-79.470870 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2J5', CAST(43.958333 AS Decimal(18, 6)), CAST(-79.473417 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2J6', CAST(43.957380 AS Decimal(18, 6)), CAST(-79.472272 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2J7', CAST(43.958446 AS Decimal(18, 6)), CAST(-79.471073 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2J8', CAST(43.958270 AS Decimal(18, 6)), CAST(-79.470944 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2J9', CAST(43.958641 AS Decimal(18, 6)), CAST(-79.470712 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2K1', CAST(43.959007 AS Decimal(18, 6)), CAST(-79.469736 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2K2', CAST(43.958020 AS Decimal(18, 6)), CAST(-79.469324 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2K3', CAST(43.956946 AS Decimal(18, 6)), CAST(-79.470023 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2K4', CAST(43.958239 AS Decimal(18, 6)), CAST(-79.468355 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2K5', CAST(43.958223 AS Decimal(18, 6)), CAST(-79.468430 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2K6', CAST(43.957651 AS Decimal(18, 6)), CAST(-79.466247 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2K7', CAST(43.950466 AS Decimal(18, 6)), CAST(-79.452967 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2K8', CAST(43.949844 AS Decimal(18, 6)), CAST(-79.455513 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2K9', CAST(43.951294 AS Decimal(18, 6)), CAST(-79.451927 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2L1', CAST(43.951204 AS Decimal(18, 6)), CAST(-79.451736 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2L2', CAST(43.951228 AS Decimal(18, 6)), CAST(-79.452368 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2L3', CAST(43.952423 AS Decimal(18, 6)), CAST(-79.448952 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2L4', CAST(43.952329 AS Decimal(18, 6)), CAST(-79.450158 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2L5', CAST(43.951083 AS Decimal(18, 6)), CAST(-79.450393 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2L6', CAST(43.952196 AS Decimal(18, 6)), CAST(-79.451814 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2L7', CAST(43.951957 AS Decimal(18, 6)), CAST(-79.451728 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2L8', CAST(43.953033 AS Decimal(18, 6)), CAST(-79.453816 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2L9', CAST(43.953558 AS Decimal(18, 6)), CAST(-79.453784 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2M1', CAST(43.953912 AS Decimal(18, 6)), CAST(-79.452826 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2M2', CAST(43.950376 AS Decimal(18, 6)), CAST(-79.453757 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2M3', CAST(43.953790 AS Decimal(18, 6)), CAST(-79.453479 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2M4', CAST(43.949230 AS Decimal(18, 6)), CAST(-79.453753 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2M5', CAST(43.949388 AS Decimal(18, 6)), CAST(-79.453788 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2M6', CAST(43.956051 AS Decimal(18, 6)), CAST(-79.465628 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2M7', CAST(43.956054 AS Decimal(18, 6)), CAST(-79.465613 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2M8', CAST(43.955527 AS Decimal(18, 6)), CAST(-79.468440 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2M9', CAST(43.956583 AS Decimal(18, 6)), CAST(-79.468205 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2N1', CAST(43.954705 AS Decimal(18, 6)), CAST(-79.467693 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2N2', CAST(43.954067 AS Decimal(18, 6)), CAST(-79.466452 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2N3', CAST(43.954225 AS Decimal(18, 6)), CAST(-79.469285 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2N4', CAST(43.942787 AS Decimal(18, 6)), CAST(-79.445986 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2N5', CAST(43.953062 AS Decimal(18, 6)), CAST(-79.466768 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2N6', CAST(43.952832 AS Decimal(18, 6)), CAST(-79.463827 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2N7', CAST(43.953105 AS Decimal(18, 6)), CAST(-79.464927 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2N8', CAST(43.953027 AS Decimal(18, 6)), CAST(-79.462942 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2N9', CAST(43.954451 AS Decimal(18, 6)), CAST(-79.463394 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2P1', CAST(43.954086 AS Decimal(18, 6)), CAST(-79.462353 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2P2', CAST(43.954623 AS Decimal(18, 6)), CAST(-79.463008 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2P3', CAST(43.955388 AS Decimal(18, 6)), CAST(-79.462248 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2P4', CAST(43.955298 AS Decimal(18, 6)), CAST(-79.462928 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2P5', CAST(43.953895 AS Decimal(18, 6)), CAST(-79.459866 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2P6', CAST(43.954213 AS Decimal(18, 6)), CAST(-79.456869 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2P7', CAST(43.954031 AS Decimal(18, 6)), CAST(-79.468986 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2P8', CAST(43.955600 AS Decimal(18, 6)), CAST(-79.460386 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2P9', CAST(43.956533 AS Decimal(18, 6)), CAST(-79.461356 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2R1', CAST(43.956030 AS Decimal(18, 6)), CAST(-79.460617 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2R2', CAST(43.957679 AS Decimal(18, 6)), CAST(-79.463267 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2R3', CAST(43.958393 AS Decimal(18, 6)), CAST(-79.462525 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2R4', CAST(43.957724 AS Decimal(18, 6)), CAST(-79.460082 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2R5', CAST(43.959475 AS Decimal(18, 6)), CAST(-79.460213 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2R6', CAST(43.959056 AS Decimal(18, 6)), CAST(-79.459606 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2R7', CAST(43.954498 AS Decimal(18, 6)), CAST(-79.451886 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2R8', CAST(43.954560 AS Decimal(18, 6)), CAST(-79.451494 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2R9', CAST(43.955185 AS Decimal(18, 6)), CAST(-79.453018 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2S1', CAST(43.956424 AS Decimal(18, 6)), CAST(-79.451733 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2S2', CAST(43.956159 AS Decimal(18, 6)), CAST(-79.452917 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2S3', CAST(43.956213 AS Decimal(18, 6)), CAST(-79.452678 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2S4', CAST(43.956794 AS Decimal(18, 6)), CAST(-79.450082 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2S5', CAST(43.956630 AS Decimal(18, 6)), CAST(-79.450813 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2S6', CAST(43.955578 AS Decimal(18, 6)), CAST(-79.450569 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2S7', CAST(43.954910 AS Decimal(18, 6)), CAST(-79.454344 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2S8', CAST(43.954950 AS Decimal(18, 6)), CAST(-79.454152 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2S9', CAST(43.962765 AS Decimal(18, 6)), CAST(-79.454672 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2T0', CAST(43.946373 AS Decimal(18, 6)), CAST(-79.455175 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2T1', CAST(43.949917 AS Decimal(18, 6)), CAST(-79.457781 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2T2', CAST(43.948610 AS Decimal(18, 6)), CAST(-79.455621 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2T3', CAST(43.947990 AS Decimal(18, 6)), CAST(-79.456584 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2T4', CAST(43.944274 AS Decimal(18, 6)), CAST(-79.460010 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2T5', CAST(43.943455 AS Decimal(18, 6)), CAST(-79.460079 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2T6', CAST(43.946034 AS Decimal(18, 6)), CAST(-79.458702 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2T7', CAST(43.945290 AS Decimal(18, 6)), CAST(-79.458376 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2T8', CAST(43.947798 AS Decimal(18, 6)), CAST(-79.461079 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2T9', CAST(43.947427 AS Decimal(18, 6)), CAST(-79.458529 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2V1', CAST(43.946847 AS Decimal(18, 6)), CAST(-79.460406 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2V2', CAST(43.949098 AS Decimal(18, 6)), CAST(-79.461668 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2V3', CAST(43.949467 AS Decimal(18, 6)), CAST(-79.461706 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2V4', CAST(43.948981 AS Decimal(18, 6)), CAST(-79.460362 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2V5', CAST(43.946814 AS Decimal(18, 6)), CAST(-79.463524 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2V6', CAST(43.946810 AS Decimal(18, 6)), CAST(-79.463724 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2V7', CAST(43.944466 AS Decimal(18, 6)), CAST(-79.463730 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2V8', CAST(43.944068 AS Decimal(18, 6)), CAST(-79.464247 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2V9', CAST(43.943972 AS Decimal(18, 6)), CAST(-79.462440 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2W1', CAST(43.943421 AS Decimal(18, 6)), CAST(-79.460659 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2W2', CAST(43.942886 AS Decimal(18, 6)), CAST(-79.462247 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2W3', CAST(43.944027 AS Decimal(18, 6)), CAST(-79.464414 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2W4', CAST(43.944481 AS Decimal(18, 6)), CAST(-79.464832 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2W5', CAST(43.944698 AS Decimal(18, 6)), CAST(-79.465545 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2W6', CAST(43.948338 AS Decimal(18, 6)), CAST(-79.468432 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2W7', CAST(43.948225 AS Decimal(18, 6)), CAST(-79.467047 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2W8', CAST(43.948783 AS Decimal(18, 6)), CAST(-79.464410 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2W9', CAST(43.946963 AS Decimal(18, 6)), CAST(-79.466944 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2X1', CAST(43.947074 AS Decimal(18, 6)), CAST(-79.468117 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2X2', CAST(43.946317 AS Decimal(18, 6)), CAST(-79.465572 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2X3', CAST(43.944556 AS Decimal(18, 6)), CAST(-79.460565 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2X4', CAST(43.941779 AS Decimal(18, 6)), CAST(-79.467980 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2X5', CAST(43.942717 AS Decimal(18, 6)), CAST(-79.466640 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2X6', CAST(43.944113 AS Decimal(18, 6)), CAST(-79.466830 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2X7', CAST(43.946433 AS Decimal(18, 6)), CAST(-79.469463 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2X8', CAST(43.945425 AS Decimal(18, 6)), CAST(-79.468070 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2X9', CAST(43.947988 AS Decimal(18, 6)), CAST(-79.469613 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2Y1', CAST(43.947352 AS Decimal(18, 6)), CAST(-79.469667 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2Y2', CAST(43.946749 AS Decimal(18, 6)), CAST(-79.469434 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2Y3', CAST(43.943463 AS Decimal(18, 6)), CAST(-79.468980 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2Y4', CAST(43.943114 AS Decimal(18, 6)), CAST(-79.469773 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2Y5', CAST(43.942878 AS Decimal(18, 6)), CAST(-79.472791 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2Y6', CAST(43.943429 AS Decimal(18, 6)), CAST(-79.474409 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2Y7', CAST(43.942805 AS Decimal(18, 6)), CAST(-79.475976 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2Y8', CAST(43.940835 AS Decimal(18, 6)), CAST(-79.473072 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2Y9', CAST(43.941408 AS Decimal(18, 6)), CAST(-79.475532 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2Z1', CAST(43.942415 AS Decimal(18, 6)), CAST(-79.478555 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2Z2', CAST(43.942453 AS Decimal(18, 6)), CAST(-79.478741 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2Z3', CAST(43.943055 AS Decimal(18, 6)), CAST(-79.481492 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2Z4', CAST(43.944275 AS Decimal(18, 6)), CAST(-79.482033 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2Z5', CAST(43.943805 AS Decimal(18, 6)), CAST(-79.482171 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2Z6', CAST(43.946607 AS Decimal(18, 6)), CAST(-79.482556 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2Z7', CAST(43.945803 AS Decimal(18, 6)), CAST(-79.481992 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2Z8', CAST(43.948947 AS Decimal(18, 6)), CAST(-79.447683 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E2Z9', CAST(43.948423 AS Decimal(18, 6)), CAST(-79.447093 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3A1', CAST(43.948555 AS Decimal(18, 6)), CAST(-79.444941 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3A2', CAST(43.949545 AS Decimal(18, 6)), CAST(-79.445646 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3A3', CAST(43.949997 AS Decimal(18, 6)), CAST(-79.442239 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3A4', CAST(43.950620 AS Decimal(18, 6)), CAST(-79.439270 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3A5', CAST(43.949261 AS Decimal(18, 6)), CAST(-79.442745 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3A6', CAST(43.951525 AS Decimal(18, 6)), CAST(-79.440381 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3A7', CAST(43.951506 AS Decimal(18, 6)), CAST(-79.439765 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3A8', CAST(43.952286 AS Decimal(18, 6)), CAST(-79.438340 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3A9', CAST(43.952467 AS Decimal(18, 6)), CAST(-79.439738 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3B1', CAST(43.952297 AS Decimal(18, 6)), CAST(-79.438297 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3B2', CAST(43.952732 AS Decimal(18, 6)), CAST(-79.437463 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3B3', CAST(43.953127 AS Decimal(18, 6)), CAST(-79.436826 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3B4', CAST(43.952058 AS Decimal(18, 6)), CAST(-79.436939 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3B5', CAST(43.956065 AS Decimal(18, 6)), CAST(-79.437561 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3B6', CAST(43.955015 AS Decimal(18, 6)), CAST(-79.436591 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3B7', CAST(43.953796 AS Decimal(18, 6)), CAST(-79.435699 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3B8', CAST(43.953558 AS Decimal(18, 6)), CAST(-79.435549 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3B9', CAST(43.952494 AS Decimal(18, 6)), CAST(-79.436075 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3C1', CAST(43.955545 AS Decimal(18, 6)), CAST(-79.435934 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3C2', CAST(43.954909 AS Decimal(18, 6)), CAST(-79.435117 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3C3', CAST(43.954948 AS Decimal(18, 6)), CAST(-79.434104 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3C4', CAST(43.954368 AS Decimal(18, 6)), CAST(-79.433983 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3C5', CAST(43.953956 AS Decimal(18, 6)), CAST(-79.433438 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3C6', CAST(43.955016 AS Decimal(18, 6)), CAST(-79.433174 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3C7', CAST(43.953440 AS Decimal(18, 6)), CAST(-79.432665 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3C8', CAST(43.953162 AS Decimal(18, 6)), CAST(-79.433154 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3C9', CAST(43.955960 AS Decimal(18, 6)), CAST(-79.433379 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3E1', CAST(43.956487 AS Decimal(18, 6)), CAST(-79.434277 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3E2', CAST(43.955950 AS Decimal(18, 6)), CAST(-79.434314 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3E3', CAST(43.958842 AS Decimal(18, 6)), CAST(-79.433969 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3E4', CAST(43.957372 AS Decimal(18, 6)), CAST(-79.433679 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3E5', CAST(43.958132 AS Decimal(18, 6)), CAST(-79.433996 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3E6', CAST(43.966018 AS Decimal(18, 6)), CAST(-79.430667 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3E7', CAST(43.962031 AS Decimal(18, 6)), CAST(-79.435284 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3E8', CAST(43.961501 AS Decimal(18, 6)), CAST(-79.438841 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3E9', CAST(43.962308 AS Decimal(18, 6)), CAST(-79.438314 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3G1', CAST(43.945173 AS Decimal(18, 6)), CAST(-79.431240 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3G2', CAST(43.947573 AS Decimal(18, 6)), CAST(-79.430290 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3G3', CAST(43.942232 AS Decimal(18, 6)), CAST(-79.452760 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3G4', CAST(43.942238 AS Decimal(18, 6)), CAST(-79.451644 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3G5', CAST(43.942331 AS Decimal(18, 6)), CAST(-79.450097 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3G6', CAST(43.942927 AS Decimal(18, 6)), CAST(-79.448979 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3G7', CAST(43.942872 AS Decimal(18, 6)), CAST(-79.450243 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3G8', CAST(43.944263 AS Decimal(18, 6)), CAST(-79.446186 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3G9', CAST(43.944520 AS Decimal(18, 6)), CAST(-79.450541 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3H1', CAST(43.944421 AS Decimal(18, 6)), CAST(-79.447244 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3H2', CAST(43.942981 AS Decimal(18, 6)), CAST(-79.444479 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3H3', CAST(43.942834 AS Decimal(18, 6)), CAST(-79.444909 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3H4', CAST(43.945110 AS Decimal(18, 6)), CAST(-79.443823 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3H5', CAST(43.944809 AS Decimal(18, 6)), CAST(-79.446976 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3H6', CAST(43.945767 AS Decimal(18, 6)), CAST(-79.441771 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3H7', CAST(43.945613 AS Decimal(18, 6)), CAST(-79.442379 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3H8', CAST(43.944571 AS Decimal(18, 6)), CAST(-79.443173 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3H9', CAST(43.945039 AS Decimal(18, 6)), CAST(-79.439667 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3J1', CAST(43.944039 AS Decimal(18, 6)), CAST(-79.440715 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3J2', CAST(43.944968 AS Decimal(18, 6)), CAST(-79.437105 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3J3', CAST(43.944748 AS Decimal(18, 6)), CAST(-79.436688 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3J4', CAST(43.944248 AS Decimal(18, 6)), CAST(-79.435211 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3J5', CAST(43.943321 AS Decimal(18, 6)), CAST(-79.434825 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3J6', CAST(43.943503 AS Decimal(18, 6)), CAST(-79.433835 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3J7', CAST(43.945160 AS Decimal(18, 6)), CAST(-79.434874 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3J8', CAST(43.944793 AS Decimal(18, 6)), CAST(-79.433972 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3J9', CAST(43.943855 AS Decimal(18, 6)), CAST(-79.430872 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3K1', CAST(43.941744 AS Decimal(18, 6)), CAST(-79.460162 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3K2', CAST(43.941819 AS Decimal(18, 6)), CAST(-79.455905 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3K3', CAST(43.941088 AS Decimal(18, 6)), CAST(-79.458819 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3K4', CAST(43.940204 AS Decimal(18, 6)), CAST(-79.463227 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3K5', CAST(43.940623 AS Decimal(18, 6)), CAST(-79.462524 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3K6', CAST(43.939906 AS Decimal(18, 6)), CAST(-79.463329 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3K7', CAST(43.939812 AS Decimal(18, 6)), CAST(-79.465542 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3K8', CAST(43.939316 AS Decimal(18, 6)), CAST(-79.467020 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3K9', CAST(43.940433 AS Decimal(18, 6)), CAST(-79.467264 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3L1', CAST(43.940656 AS Decimal(18, 6)), CAST(-79.467260 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3L2', CAST(43.950774 AS Decimal(18, 6)), CAST(-79.456087 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3L3', CAST(43.953006 AS Decimal(18, 6)), CAST(-79.455742 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3L4', CAST(43.960471 AS Decimal(18, 6)), CAST(-79.459735 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3L5', CAST(43.961808 AS Decimal(18, 6)), CAST(-79.460164 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3L6', CAST(43.921047 AS Decimal(18, 6)), CAST(-79.448956 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3L7', CAST(43.942466 AS Decimal(18, 6)), CAST(-79.463961 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3L8', CAST(43.925505 AS Decimal(18, 6)), CAST(-79.422887 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3L9', CAST(43.929862 AS Decimal(18, 6)), CAST(-79.423893 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3M1', CAST(43.932346 AS Decimal(18, 6)), CAST(-79.410739 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3M2', CAST(43.927073 AS Decimal(18, 6)), CAST(-79.452131 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3M3', CAST(43.926098 AS Decimal(18, 6)), CAST(-79.462373 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3M4', CAST(43.922113 AS Decimal(18, 6)), CAST(-79.450865 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3M5', CAST(43.910458 AS Decimal(18, 6)), CAST(-79.441337 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3M6', CAST(43.914208 AS Decimal(18, 6)), CAST(-79.431413 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3M7', CAST(43.927182 AS Decimal(18, 6)), CAST(-79.447794 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3M8', CAST(43.924489 AS Decimal(18, 6)), CAST(-79.418317 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3M9', CAST(43.921386 AS Decimal(18, 6)), CAST(-79.424433 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3N1', CAST(43.961551 AS Decimal(18, 6)), CAST(-79.445610 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3N2', CAST(43.936266 AS Decimal(18, 6)), CAST(-79.479166 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3N3', CAST(43.909113 AS Decimal(18, 6)), CAST(-79.446995 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3N4', CAST(43.928385 AS Decimal(18, 6)), CAST(-79.417394 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3N5', CAST(43.920810 AS Decimal(18, 6)), CAST(-79.456996 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3N6', CAST(43.912306 AS Decimal(18, 6)), CAST(-79.447339 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3N7', CAST(43.914234 AS Decimal(18, 6)), CAST(-79.447360 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3N8', CAST(43.909727 AS Decimal(18, 6)), CAST(-79.445857 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3N9', CAST(43.906611 AS Decimal(18, 6)), CAST(-79.438456 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3P1', CAST(43.904945 AS Decimal(18, 6)), CAST(-79.459255 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3P2', CAST(43.907320 AS Decimal(18, 6)), CAST(-79.448273 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3P3', CAST(43.926742 AS Decimal(18, 6)), CAST(-79.448890 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3P4', CAST(43.928588 AS Decimal(18, 6)), CAST(-79.442069 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3P5', CAST(43.929954 AS Decimal(18, 6)), CAST(-79.435678 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3P6', CAST(43.909474 AS Decimal(18, 6)), CAST(-79.440066 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3P7', CAST(43.910223 AS Decimal(18, 6)), CAST(-79.435067 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3P8', CAST(43.917703 AS Decimal(18, 6)), CAST(-79.425701 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3P9', CAST(43.918402 AS Decimal(18, 6)), CAST(-79.425769 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3R1', CAST(43.914662 AS Decimal(18, 6)), CAST(-79.407926 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3R2', CAST(43.912562 AS Decimal(18, 6)), CAST(-79.417679 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3R3', CAST(43.912852 AS Decimal(18, 6)), CAST(-79.416453 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3R4', CAST(43.918285 AS Decimal(18, 6)), CAST(-79.401121 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3R5', CAST(43.924318 AS Decimal(18, 6)), CAST(-79.401165 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3R6', CAST(43.929188 AS Decimal(18, 6)), CAST(-79.402083 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3R7', CAST(43.921606 AS Decimal(18, 6)), CAST(-79.401078 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3R8', CAST(43.931437 AS Decimal(18, 6)), CAST(-79.404597 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3R9', CAST(43.918061 AS Decimal(18, 6)), CAST(-79.398615 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3S1', CAST(43.928376 AS Decimal(18, 6)), CAST(-79.439975 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3S2', CAST(43.933881 AS Decimal(18, 6)), CAST(-79.414852 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3S3', CAST(43.933185 AS Decimal(18, 6)), CAST(-79.418295 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3S4', CAST(43.933137 AS Decimal(18, 6)), CAST(-79.418344 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3S5', CAST(43.934633 AS Decimal(18, 6)), CAST(-79.409317 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3S6', CAST(43.939067 AS Decimal(18, 6)), CAST(-79.464001 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3S7', CAST(43.918649 AS Decimal(18, 6)), CAST(-79.421448 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3S8', CAST(43.926812 AS Decimal(18, 6)), CAST(-79.449572 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3S9', CAST(43.949698 AS Decimal(18, 6)), CAST(-79.477296 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3T1', CAST(43.950496 AS Decimal(18, 6)), CAST(-79.476570 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3T2', CAST(43.950410 AS Decimal(18, 6)), CAST(-79.478365 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3T3', CAST(43.950221 AS Decimal(18, 6)), CAST(-79.479131 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3T4', CAST(43.949811 AS Decimal(18, 6)), CAST(-79.478129 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3T5', CAST(43.951432 AS Decimal(18, 6)), CAST(-79.481578 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3T6', CAST(43.953280 AS Decimal(18, 6)), CAST(-79.481382 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3T7', CAST(43.952998 AS Decimal(18, 6)), CAST(-79.482541 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3T8', CAST(43.953169 AS Decimal(18, 6)), CAST(-79.483471 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3T9', CAST(43.949844 AS Decimal(18, 6)), CAST(-79.482543 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3V1', CAST(43.939127 AS Decimal(18, 6)), CAST(-79.445910 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3V2', CAST(43.939706 AS Decimal(18, 6)), CAST(-79.451421 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3V3', CAST(43.939502 AS Decimal(18, 6)), CAST(-79.456597 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3V4', CAST(43.945007 AS Decimal(18, 6)), CAST(-79.454820 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3V5', CAST(43.939578 AS Decimal(18, 6)), CAST(-79.458440 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3V6', CAST(43.938935 AS Decimal(18, 6)), CAST(-79.460929 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3V7', CAST(43.938348 AS Decimal(18, 6)), CAST(-79.460560 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3V8', CAST(43.941197 AS Decimal(18, 6)), CAST(-79.446048 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3V9', CAST(43.941581 AS Decimal(18, 6)), CAST(-79.444451 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3W1', CAST(43.940204 AS Decimal(18, 6)), CAST(-79.445151 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3W2', CAST(43.939894 AS Decimal(18, 6)), CAST(-79.442775 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3W3', CAST(43.944265 AS Decimal(18, 6)), CAST(-79.469241 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3W4', CAST(43.954198 AS Decimal(18, 6)), CAST(-79.448105 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3W5', CAST(43.954783 AS Decimal(18, 6)), CAST(-79.448842 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3W6', CAST(43.950862 AS Decimal(18, 6)), CAST(-79.446512 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3W7', CAST(43.952583 AS Decimal(18, 6)), CAST(-79.440247 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3W8', CAST(43.957238 AS Decimal(18, 6)), CAST(-79.446347 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3W9', CAST(43.957114 AS Decimal(18, 6)), CAST(-79.447718 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3X1', CAST(43.956512 AS Decimal(18, 6)), CAST(-79.447406 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3X2', CAST(43.939504 AS Decimal(18, 6)), CAST(-79.449202 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3X3', CAST(43.940592 AS Decimal(18, 6)), CAST(-79.443149 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3X4', CAST(43.941252 AS Decimal(18, 6)), CAST(-79.442391 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3X5', CAST(43.941850 AS Decimal(18, 6)), CAST(-79.445968 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3X6', CAST(43.940570 AS Decimal(18, 6)), CAST(-79.451476 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3X7', CAST(43.940676 AS Decimal(18, 6)), CAST(-79.452369 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3X8', CAST(43.937941 AS Decimal(18, 6)), CAST(-79.462770 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3X9', CAST(43.937580 AS Decimal(18, 6)), CAST(-79.464298 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3Y0', CAST(43.938162 AS Decimal(18, 6)), CAST(-79.436632 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3Y1', CAST(43.947579 AS Decimal(18, 6)), CAST(-79.447436 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3Y2', CAST(43.947149 AS Decimal(18, 6)), CAST(-79.448226 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3Y3', CAST(43.947745 AS Decimal(18, 6)), CAST(-79.447545 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3Y4', CAST(43.954518 AS Decimal(18, 6)), CAST(-79.473397 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3Y5', CAST(43.951544 AS Decimal(18, 6)), CAST(-79.473874 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3Y6', CAST(43.951318 AS Decimal(18, 6)), CAST(-79.471704 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3Y7', CAST(43.950793 AS Decimal(18, 6)), CAST(-79.474470 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3Y8', CAST(43.954794 AS Decimal(18, 6)), CAST(-79.481321 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3Y9', CAST(43.955018 AS Decimal(18, 6)), CAST(-79.477373 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3Z1', CAST(43.956045 AS Decimal(18, 6)), CAST(-79.483950 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3Z2', CAST(43.955638 AS Decimal(18, 6)), CAST(-79.483386 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3Z3', CAST(43.954064 AS Decimal(18, 6)), CAST(-79.483506 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3Z4', CAST(43.954875 AS Decimal(18, 6)), CAST(-79.483755 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3Z5', CAST(43.955952 AS Decimal(18, 6)), CAST(-79.447503 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3Z6', CAST(43.956342 AS Decimal(18, 6)), CAST(-79.445925 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3Z7', CAST(43.957015 AS Decimal(18, 6)), CAST(-79.445175 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3Z8', CAST(43.957847 AS Decimal(18, 6)), CAST(-79.445500 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E3Z9', CAST(43.938254 AS Decimal(18, 6)), CAST(-79.470054 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4A1', CAST(43.934950 AS Decimal(18, 6)), CAST(-79.466741 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4A2', CAST(43.938708 AS Decimal(18, 6)), CAST(-79.469009 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4A3', CAST(43.939613 AS Decimal(18, 6)), CAST(-79.470126 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4A4', CAST(43.936998 AS Decimal(18, 6)), CAST(-79.469296 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4A5', CAST(43.940090 AS Decimal(18, 6)), CAST(-79.472127 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4A6', CAST(43.940574 AS Decimal(18, 6)), CAST(-79.470243 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4A7', CAST(43.939952 AS Decimal(18, 6)), CAST(-79.469180 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4A8', CAST(43.940856 AS Decimal(18, 6)), CAST(-79.469731 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4A9', CAST(43.940278 AS Decimal(18, 6)), CAST(-79.473000 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4B1', CAST(43.939554 AS Decimal(18, 6)), CAST(-79.474007 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4B2', CAST(43.953768 AS Decimal(18, 6)), CAST(-79.479455 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4B3', CAST(43.952620 AS Decimal(18, 6)), CAST(-79.478786 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4B4', CAST(43.951729 AS Decimal(18, 6)), CAST(-79.477958 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4B5', CAST(43.952792 AS Decimal(18, 6)), CAST(-79.478424 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4B6', CAST(43.953020 AS Decimal(18, 6)), CAST(-79.472062 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4B7', CAST(43.955535 AS Decimal(18, 6)), CAST(-79.479756 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4B8', CAST(43.954247 AS Decimal(18, 6)), CAST(-79.477273 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4B9', CAST(43.913820 AS Decimal(18, 6)), CAST(-79.455623 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4C1', CAST(43.908058 AS Decimal(18, 6)), CAST(-79.451464 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4C2', CAST(43.908361 AS Decimal(18, 6)), CAST(-79.450662 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4C3', CAST(43.909464 AS Decimal(18, 6)), CAST(-79.451266 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4C4', CAST(43.909340 AS Decimal(18, 6)), CAST(-79.452023 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4C5', CAST(43.908553 AS Decimal(18, 6)), CAST(-79.452552 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4C6', CAST(43.908070 AS Decimal(18, 6)), CAST(-79.452977 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4C7', CAST(43.907944 AS Decimal(18, 6)), CAST(-79.451346 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4C8', CAST(43.910083 AS Decimal(18, 6)), CAST(-79.456995 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4C9', CAST(43.908075 AS Decimal(18, 6)), CAST(-79.455786 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4E1', CAST(43.912914 AS Decimal(18, 6)), CAST(-79.458949 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4E2', CAST(43.957102 AS Decimal(18, 6)), CAST(-79.483777 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4E3', CAST(43.957314 AS Decimal(18, 6)), CAST(-79.482202 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4E4', CAST(43.949566 AS Decimal(18, 6)), CAST(-79.450469 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4E5', CAST(43.951790 AS Decimal(18, 6)), CAST(-79.448159 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4E6', CAST(43.953170 AS Decimal(18, 6)), CAST(-79.445949 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4E7', CAST(43.953568 AS Decimal(18, 6)), CAST(-79.442992 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4E8', CAST(43.937136 AS Decimal(18, 6)), CAST(-79.472900 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4E9', CAST(43.938959 AS Decimal(18, 6)), CAST(-79.472800 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4G1', CAST(43.944884 AS Decimal(18, 6)), CAST(-79.448641 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4G2', CAST(43.942866 AS Decimal(18, 6)), CAST(-79.442787 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4G3', CAST(43.942278 AS Decimal(18, 6)), CAST(-79.444320 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4G4', CAST(43.942227 AS Decimal(18, 6)), CAST(-79.444589 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4G5', CAST(43.942238 AS Decimal(18, 6)), CAST(-79.441313 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4G6', CAST(43.941139 AS Decimal(18, 6)), CAST(-79.441213 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4G7', CAST(43.940171 AS Decimal(18, 6)), CAST(-79.440447 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4G8', CAST(43.909159 AS Decimal(18, 6)), CAST(-79.444706 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4G9', CAST(43.909460 AS Decimal(18, 6)), CAST(-79.442859 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4H1', CAST(43.940510 AS Decimal(18, 6)), CAST(-79.453694 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4H2', CAST(43.942337 AS Decimal(18, 6)), CAST(-79.439681 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4H3', CAST(43.941262 AS Decimal(18, 6)), CAST(-79.439010 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4H4', CAST(43.941684 AS Decimal(18, 6)), CAST(-79.438584 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4H5', CAST(43.951593 AS Decimal(18, 6)), CAST(-79.482976 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4H6', CAST(43.951526 AS Decimal(18, 6)), CAST(-79.483524 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4H7', CAST(43.909939 AS Decimal(18, 6)), CAST(-79.443922 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4H8', CAST(43.909609 AS Decimal(18, 6)), CAST(-79.444291 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4H9', CAST(43.915236 AS Decimal(18, 6)), CAST(-79.443597 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4J1', CAST(43.915190 AS Decimal(18, 6)), CAST(-79.442280 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4J2', CAST(43.914580 AS Decimal(18, 6)), CAST(-79.441770 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4J3', CAST(43.913850 AS Decimal(18, 6)), CAST(-79.441160 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4J4', CAST(43.915700 AS Decimal(18, 6)), CAST(-79.440327 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4J5', CAST(43.915211 AS Decimal(18, 6)), CAST(-79.439524 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4J6', CAST(43.921008 AS Decimal(18, 6)), CAST(-79.443787 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4J7', CAST(43.914705 AS Decimal(18, 6)), CAST(-79.437626 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4J8', CAST(43.916587 AS Decimal(18, 6)), CAST(-79.436973 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4J9', CAST(43.914169 AS Decimal(18, 6)), CAST(-79.435870 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4K1', CAST(43.913562 AS Decimal(18, 6)), CAST(-79.435219 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4K2', CAST(43.917731 AS Decimal(18, 6)), CAST(-79.437243 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4K3', CAST(43.914492 AS Decimal(18, 6)), CAST(-79.432864 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4K4', CAST(43.916012 AS Decimal(18, 6)), CAST(-79.433298 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4K5', CAST(43.921203 AS Decimal(18, 6)), CAST(-79.440129 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4K6', CAST(43.916693 AS Decimal(18, 6)), CAST(-79.434240 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4K7', CAST(43.942817 AS Decimal(18, 6)), CAST(-79.431469 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4K8', CAST(43.914575 AS Decimal(18, 6)), CAST(-79.464053 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4K9', CAST(43.913094 AS Decimal(18, 6)), CAST(-79.461441 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4L1', CAST(43.912729 AS Decimal(18, 6)), CAST(-79.462260 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4L2', CAST(43.911316 AS Decimal(18, 6)), CAST(-79.461211 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4L3', CAST(43.907412 AS Decimal(18, 6)), CAST(-79.456988 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4L4', CAST(43.939004 AS Decimal(18, 6)), CAST(-79.449329 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4L5', CAST(43.939522 AS Decimal(18, 6)), CAST(-79.447960 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4L6', CAST(43.918792 AS Decimal(18, 6)), CAST(-79.447679 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4L7', CAST(43.915266 AS Decimal(18, 6)), CAST(-79.456191 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4L8', CAST(43.914764 AS Decimal(18, 6)), CAST(-79.454890 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4L9', CAST(43.914228 AS Decimal(18, 6)), CAST(-79.453302 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4M1', CAST(43.919526 AS Decimal(18, 6)), CAST(-79.452940 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4M2', CAST(43.955432 AS Decimal(18, 6)), CAST(-79.477004 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4M3', CAST(43.956310 AS Decimal(18, 6)), CAST(-79.478295 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4M5', CAST(43.955119 AS Decimal(18, 6)), CAST(-79.471869 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4M7', CAST(43.954438 AS Decimal(18, 6)), CAST(-79.441159 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4M8', CAST(43.954898 AS Decimal(18, 6)), CAST(-79.441034 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4M9', CAST(43.955376 AS Decimal(18, 6)), CAST(-79.441835 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4N1', CAST(43.955855 AS Decimal(18, 6)), CAST(-79.439660 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4N2', CAST(43.956583 AS Decimal(18, 6)), CAST(-79.439533 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4N3', CAST(43.957106 AS Decimal(18, 6)), CAST(-79.438493 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4N4', CAST(43.958036 AS Decimal(18, 6)), CAST(-79.439245 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4N5', CAST(43.958677 AS Decimal(18, 6)), CAST(-79.438346 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4N6', CAST(43.959375 AS Decimal(18, 6)), CAST(-79.438841 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4N7', CAST(43.957091 AS Decimal(18, 6)), CAST(-79.441614 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4N8', CAST(43.956178 AS Decimal(18, 6)), CAST(-79.441921 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4N9', CAST(43.961173 AS Decimal(18, 6)), CAST(-79.438212 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4P1', CAST(43.960333 AS Decimal(18, 6)), CAST(-79.439288 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4P2', CAST(43.944509 AS Decimal(18, 6)), CAST(-79.482652 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4P3', CAST(43.946691 AS Decimal(18, 6)), CAST(-79.479933 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4P4', CAST(43.946091 AS Decimal(18, 6)), CAST(-79.479055 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4P5', CAST(43.945666 AS Decimal(18, 6)), CAST(-79.479938 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4P6', CAST(43.946461 AS Decimal(18, 6)), CAST(-79.477636 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4P7', CAST(43.945175 AS Decimal(18, 6)), CAST(-79.477739 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4P8', CAST(43.944432 AS Decimal(18, 6)), CAST(-79.477224 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4P9', CAST(43.944617 AS Decimal(18, 6)), CAST(-79.475051 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4R1', CAST(43.950538 AS Decimal(18, 6)), CAST(-79.461446 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4R2', CAST(43.949997 AS Decimal(18, 6)), CAST(-79.464930 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4R3', CAST(43.950296 AS Decimal(18, 6)), CAST(-79.466533 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4R4', CAST(43.951172 AS Decimal(18, 6)), CAST(-79.467382 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4R5', CAST(43.950695 AS Decimal(18, 6)), CAST(-79.464617 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4R6', CAST(43.965120 AS Decimal(18, 6)), CAST(-79.442409 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4R7', CAST(43.964074 AS Decimal(18, 6)), CAST(-79.441272 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4R8', CAST(43.964872 AS Decimal(18, 6)), CAST(-79.439348 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4R9', CAST(43.965463 AS Decimal(18, 6)), CAST(-79.437194 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4S1', CAST(43.966351 AS Decimal(18, 6)), CAST(-79.437277 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4S2', CAST(43.947324 AS Decimal(18, 6)), CAST(-79.442937 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4S3', CAST(43.961673 AS Decimal(18, 6)), CAST(-79.450341 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4S4', CAST(43.957034 AS Decimal(18, 6)), CAST(-79.474736 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4S5', CAST(43.957180 AS Decimal(18, 6)), CAST(-79.475958 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4S6', CAST(43.958691 AS Decimal(18, 6)), CAST(-79.475013 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4S7', CAST(43.912925 AS Decimal(18, 6)), CAST(-79.454515 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4S8', CAST(43.912997 AS Decimal(18, 6)), CAST(-79.453781 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4S9', CAST(43.916680 AS Decimal(18, 6)), CAST(-79.451191 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4T1', CAST(43.926338 AS Decimal(18, 6)), CAST(-79.449066 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4T2', CAST(43.918297 AS Decimal(18, 6)), CAST(-79.453262 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4T3', CAST(43.915753 AS Decimal(18, 6)), CAST(-79.457326 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4T4', CAST(43.908641 AS Decimal(18, 6)), CAST(-79.455315 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4T5', CAST(43.916475 AS Decimal(18, 6)), CAST(-79.460017 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4T6', CAST(43.916319 AS Decimal(18, 6)), CAST(-79.458172 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4T7', CAST(43.953799 AS Decimal(18, 6)), CAST(-79.442701 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4T8', CAST(43.937921 AS Decimal(18, 6)), CAST(-79.458545 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4T9', CAST(43.949124 AS Decimal(18, 6)), CAST(-79.461025 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4V1', CAST(43.958447 AS Decimal(18, 6)), CAST(-79.441149 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4V2', CAST(43.906056 AS Decimal(18, 6)), CAST(-79.457214 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4V3', CAST(43.905711 AS Decimal(18, 6)), CAST(-79.458815 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4V4', CAST(43.931581 AS Decimal(18, 6)), CAST(-79.478406 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4V5', CAST(43.932157 AS Decimal(18, 6)), CAST(-79.474892 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4V6', CAST(43.932966 AS Decimal(18, 6)), CAST(-79.476300 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4V7', CAST(43.932269 AS Decimal(18, 6)), CAST(-79.477545 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4V8', CAST(43.932521 AS Decimal(18, 6)), CAST(-79.478365 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4V9', CAST(43.932983 AS Decimal(18, 6)), CAST(-79.478616 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4W1', CAST(43.933059 AS Decimal(18, 6)), CAST(-79.477880 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4W2', CAST(43.934419 AS Decimal(18, 6)), CAST(-79.477648 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4W3', CAST(43.934119 AS Decimal(18, 6)), CAST(-79.476238 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4W4', CAST(43.933184 AS Decimal(18, 6)), CAST(-79.474932 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4W5', CAST(43.933593 AS Decimal(18, 6)), CAST(-79.474126 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4W6', CAST(43.934531 AS Decimal(18, 6)), CAST(-79.474710 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4W7', CAST(43.933856 AS Decimal(18, 6)), CAST(-79.473451 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4W8', CAST(43.933886 AS Decimal(18, 6)), CAST(-79.473588 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4W9', CAST(43.932782 AS Decimal(18, 6)), CAST(-79.472865 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4X1', CAST(43.936437 AS Decimal(18, 6)), CAST(-79.471955 AS Decimal(18, 6)), N'RICHMOND HILL', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4X2', CAST(43.934321 AS Decimal(18, 6)), CAST(-79.470386 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4X3', CAST(43.934951 AS Decimal(18, 6)), CAST(-79.470713 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4X4', CAST(43.935744 AS Decimal(18, 6)), CAST(-79.470627 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4X5', CAST(43.936443 AS Decimal(18, 6)), CAST(-79.472281 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4X6', CAST(43.938971 AS Decimal(18, 6)), CAST(-79.474169 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4X7', CAST(43.918956 AS Decimal(18, 6)), CAST(-79.451178 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4X8', CAST(43.942059 AS Decimal(18, 6)), CAST(-79.479137 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4X9', CAST(43.916670 AS Decimal(18, 6)), CAST(-79.451830 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4Y1', CAST(43.916670 AS Decimal(18, 6)), CAST(-79.451830 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4Y2', CAST(43.917050 AS Decimal(18, 6)), CAST(-79.449990 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4Y3', CAST(43.916670 AS Decimal(18, 6)), CAST(-79.451845 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4Y4', CAST(43.925382 AS Decimal(18, 6)), CAST(-79.454067 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4Y5', CAST(43.926646 AS Decimal(18, 6)), CAST(-79.454562 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4Y6', CAST(43.926780 AS Decimal(18, 6)), CAST(-79.455543 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4Y7', CAST(43.926105 AS Decimal(18, 6)), CAST(-79.456073 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4Y8', CAST(43.928134 AS Decimal(18, 6)), CAST(-79.459130 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4Y9', CAST(43.927446 AS Decimal(18, 6)), CAST(-79.458344 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4Z1', CAST(43.924809 AS Decimal(18, 6)), CAST(-79.456127 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4Z2', CAST(43.925401 AS Decimal(18, 6)), CAST(-79.456308 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4Z3', CAST(43.932217 AS Decimal(18, 6)), CAST(-79.460417 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4Z4', CAST(43.922305 AS Decimal(18, 6)), CAST(-79.454394 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4Z5', CAST(43.923265 AS Decimal(18, 6)), CAST(-79.453880 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4Z6', CAST(43.941977 AS Decimal(18, 6)), CAST(-79.458387 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4Z7', CAST(43.940069 AS Decimal(18, 6)), CAST(-79.458930 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4Z8', CAST(43.939307 AS Decimal(18, 6)), CAST(-79.462180 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E4Z9', CAST(43.940133 AS Decimal(18, 6)), CAST(-79.460512 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5A1', CAST(43.938544 AS Decimal(18, 6)), CAST(-79.432512 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5A2', CAST(43.937794 AS Decimal(18, 6)), CAST(-79.432835 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5A3', CAST(43.938533 AS Decimal(18, 6)), CAST(-79.430663 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5A4', CAST(43.939301 AS Decimal(18, 6)), CAST(-79.430871 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5A5', CAST(43.940295 AS Decimal(18, 6)), CAST(-79.431654 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5A6', CAST(43.940862 AS Decimal(18, 6)), CAST(-79.429846 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5A7', CAST(43.941647 AS Decimal(18, 6)), CAST(-79.429945 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5A8', CAST(43.941184 AS Decimal(18, 6)), CAST(-79.430711 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5A9', CAST(43.941518 AS Decimal(18, 6)), CAST(-79.431959 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5B1', CAST(43.940716 AS Decimal(18, 6)), CAST(-79.432095 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5B2', CAST(43.940148 AS Decimal(18, 6)), CAST(-79.433046 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5B3', CAST(43.939655 AS Decimal(18, 6)), CAST(-79.428658 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5B4', CAST(43.939178 AS Decimal(18, 6)), CAST(-79.427972 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5B5', CAST(43.939684 AS Decimal(18, 6)), CAST(-79.426040 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5B6', CAST(43.940373 AS Decimal(18, 6)), CAST(-79.425932 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5B7', CAST(43.940587 AS Decimal(18, 6)), CAST(-79.427029 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5B8', CAST(43.939665 AS Decimal(18, 6)), CAST(-79.439710 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5B9', CAST(43.938992 AS Decimal(18, 6)), CAST(-79.440216 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5C1', CAST(43.939508 AS Decimal(18, 6)), CAST(-79.440906 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5C2', CAST(43.884933 AS Decimal(18, 6)), CAST(-79.430388 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5C3', CAST(43.937798 AS Decimal(18, 6)), CAST(-79.441932 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5C4', CAST(43.937542 AS Decimal(18, 6)), CAST(-79.440630 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5C5', CAST(43.937961 AS Decimal(18, 6)), CAST(-79.443594 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5C6', CAST(43.938864 AS Decimal(18, 6)), CAST(-79.443464 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5C7', CAST(43.938355 AS Decimal(18, 6)), CAST(-79.444522 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5C8', CAST(43.939117 AS Decimal(18, 6)), CAST(-79.442078 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5C9', CAST(43.905414 AS Decimal(18, 6)), CAST(-79.468825 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5E1', CAST(43.906252 AS Decimal(18, 6)), CAST(-79.467164 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5E2', CAST(43.906973 AS Decimal(18, 6)), CAST(-79.466754 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5E3', CAST(43.907223 AS Decimal(18, 6)), CAST(-79.468427 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5E4', CAST(43.908184 AS Decimal(18, 6)), CAST(-79.467515 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5E5', CAST(43.908980 AS Decimal(18, 6)), CAST(-79.468694 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5E6', CAST(43.910549 AS Decimal(18, 6)), CAST(-79.468695 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5E7', CAST(43.910355 AS Decimal(18, 6)), CAST(-79.470404 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5E8', CAST(43.911539 AS Decimal(18, 6)), CAST(-79.471335 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5E9', CAST(43.912032 AS Decimal(18, 6)), CAST(-79.468280 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E5N1', CAST(43.938162 AS Decimal(18, 6)), CAST(-79.436632 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4E8C9', CAST(43.949872 AS Decimal(18, 6)), CAST(-79.476882 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0A1', CAST(43.879629 AS Decimal(18, 6)), CAST(-79.394865 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0A2', CAST(43.895150 AS Decimal(18, 6)), CAST(-79.406027 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0A3', CAST(43.893684 AS Decimal(18, 6)), CAST(-79.398956 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0A4', CAST(43.898071 AS Decimal(18, 6)), CAST(-79.450363 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0A5', CAST(43.899024 AS Decimal(18, 6)), CAST(-79.452797 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0A6', CAST(43.881092 AS Decimal(18, 6)), CAST(-79.416710 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0A7', CAST(43.904836 AS Decimal(18, 6)), CAST(-79.456202 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0A8', CAST(43.904304 AS Decimal(18, 6)), CAST(-79.456133 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0A9', CAST(43.904653 AS Decimal(18, 6)), CAST(-79.454633 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0B1', CAST(43.882144 AS Decimal(18, 6)), CAST(-79.404958 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0B2', CAST(43.895732 AS Decimal(18, 6)), CAST(-79.398126 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0B3', CAST(43.904714 AS Decimal(18, 6)), CAST(-79.453457 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0B4', CAST(43.889943 AS Decimal(18, 6)), CAST(-79.390456 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0B5', CAST(43.896759 AS Decimal(18, 6)), CAST(-79.402515 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0B6', CAST(43.889923 AS Decimal(18, 6)), CAST(-79.393715 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0B7', CAST(43.878170 AS Decimal(18, 6)), CAST(-79.403483 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0B8', CAST(43.888721 AS Decimal(18, 6)), CAST(-79.395817 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0B9', CAST(43.894577 AS Decimal(18, 6)), CAST(-79.394858 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0C1', CAST(43.902387 AS Decimal(18, 6)), CAST(-79.464205 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0C2', CAST(43.904113 AS Decimal(18, 6)), CAST(-79.459719 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0C3', CAST(43.904480 AS Decimal(18, 6)), CAST(-79.458076 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0C4', CAST(43.903881 AS Decimal(18, 6)), CAST(-79.458080 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0C5', CAST(43.903251 AS Decimal(18, 6)), CAST(-79.460882 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0C6', CAST(43.903170 AS Decimal(18, 6)), CAST(-79.462536 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0C7', CAST(43.896402 AS Decimal(18, 6)), CAST(-79.400303 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0C8', CAST(43.676728 AS Decimal(18, 6)), CAST(-79.374388 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0C9', CAST(43.899316 AS Decimal(18, 6)), CAST(-79.442104 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0E1', CAST(43.899700 AS Decimal(18, 6)), CAST(-79.439944 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0E2', CAST(43.901474 AS Decimal(18, 6)), CAST(-79.451715 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0E3', CAST(43.899956 AS Decimal(18, 6)), CAST(-79.451035 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0E4', CAST(43.900177 AS Decimal(18, 6)), CAST(-79.449396 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0E5', CAST(43.902486 AS Decimal(18, 6)), CAST(-79.447206 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0E6', CAST(43.903226 AS Decimal(18, 6)), CAST(-79.447436 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0E7', CAST(43.901702 AS Decimal(18, 6)), CAST(-79.470232 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0E8', CAST(43.905475 AS Decimal(18, 6)), CAST(-79.449440 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0E9', CAST(43.969600 AS Decimal(18, 6)), CAST(-79.460446 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0G2', CAST(43.903254 AS Decimal(18, 6)), CAST(-79.448935 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0G3', CAST(43.899491 AS Decimal(18, 6)), CAST(-79.441753 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0G4', CAST(43.891930 AS Decimal(18, 6)), CAST(-79.417309 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0H2', CAST(43.902498 AS Decimal(18, 6)), CAST(-79.408493 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0R3', CAST(43.902498 AS Decimal(18, 6)), CAST(-79.408493 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0S3', CAST(43.894631 AS Decimal(18, 6)), CAST(-79.467746 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S0S7', CAST(43.897670 AS Decimal(18, 6)), CAST(-79.443281 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1A1', CAST(43.893436 AS Decimal(18, 6)), CAST(-79.422039 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1A2', CAST(43.902424 AS Decimal(18, 6)), CAST(-79.440027 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1A3', CAST(43.901691 AS Decimal(18, 6)), CAST(-79.436282 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1A4', CAST(43.904302 AS Decimal(18, 6)), CAST(-79.433931 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1A5', CAST(43.904078 AS Decimal(18, 6)), CAST(-79.431344 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1A6', CAST(43.904813 AS Decimal(18, 6)), CAST(-79.432218 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1A7', CAST(43.903561 AS Decimal(18, 6)), CAST(-79.432528 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1A8', CAST(43.904107 AS Decimal(18, 6)), CAST(-79.430539 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1A9', CAST(43.906265 AS Decimal(18, 6)), CAST(-79.430233 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1B1', CAST(43.904265 AS Decimal(18, 6)), CAST(-79.424808 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1B2', CAST(43.903158 AS Decimal(18, 6)), CAST(-79.425866 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1B3', CAST(43.902451 AS Decimal(18, 6)), CAST(-79.425015 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1B4', CAST(43.898003 AS Decimal(18, 6)), CAST(-79.414222 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1B5', CAST(43.900811 AS Decimal(18, 6)), CAST(-79.429211 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1B6', CAST(43.899596 AS Decimal(18, 6)), CAST(-79.424367 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1B7', CAST(43.900178 AS Decimal(18, 6)), CAST(-79.426512 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1B8', CAST(43.901951 AS Decimal(18, 6)), CAST(-79.425361 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1B9', CAST(43.901253 AS Decimal(18, 6)), CAST(-79.423881 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1C1', CAST(43.900810 AS Decimal(18, 6)), CAST(-79.425149 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1C2', CAST(43.896709 AS Decimal(18, 6)), CAST(-79.422970 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1C3', CAST(43.896993 AS Decimal(18, 6)), CAST(-79.421604 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1C4', CAST(43.897416 AS Decimal(18, 6)), CAST(-79.438637 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1C5', CAST(43.899316 AS Decimal(18, 6)), CAST(-79.438843 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1C6', CAST(43.898336 AS Decimal(18, 6)), CAST(-79.438122 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1C7', CAST(43.900104 AS Decimal(18, 6)), CAST(-79.438100 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1C8', CAST(43.900813 AS Decimal(18, 6)), CAST(-79.436357 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1C9', CAST(43.899730 AS Decimal(18, 6)), CAST(-79.436902 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1E1', CAST(43.899582 AS Decimal(18, 6)), CAST(-79.435060 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1E2', CAST(43.899433 AS Decimal(18, 6)), CAST(-79.433371 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1E3', CAST(43.897385 AS Decimal(18, 6)), CAST(-79.432636 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1E4', CAST(43.898535 AS Decimal(18, 6)), CAST(-79.434195 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1E5', CAST(43.896704 AS Decimal(18, 6)), CAST(-79.433493 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1E6', CAST(43.897517 AS Decimal(18, 6)), CAST(-79.435401 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1E7', CAST(43.899013 AS Decimal(18, 6)), CAST(-79.435988 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1E8', CAST(43.903711 AS Decimal(18, 6)), CAST(-79.440400 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1E9', CAST(43.904285 AS Decimal(18, 6)), CAST(-79.438292 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1G1', CAST(43.904743 AS Decimal(18, 6)), CAST(-79.437493 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1G2', CAST(43.905170 AS Decimal(18, 6)), CAST(-79.434518 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1G3', CAST(43.906039 AS Decimal(18, 6)), CAST(-79.431960 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1G4', CAST(43.907495 AS Decimal(18, 6)), CAST(-79.431285 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1G5', CAST(43.906983 AS Decimal(18, 6)), CAST(-79.429603 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1G6', CAST(43.908988 AS Decimal(18, 6)), CAST(-79.429979 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1G7', CAST(43.908474 AS Decimal(18, 6)), CAST(-79.431120 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1G8', CAST(43.907927 AS Decimal(18, 6)), CAST(-79.433685 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1G9', CAST(43.907355 AS Decimal(18, 6)), CAST(-79.435191 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1H1', CAST(43.907165 AS Decimal(18, 6)), CAST(-79.437516 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1H2', CAST(43.905346 AS Decimal(18, 6)), CAST(-79.438755 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1H3', CAST(43.906475 AS Decimal(18, 6)), CAST(-79.439869 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1H4', CAST(43.905713 AS Decimal(18, 6)), CAST(-79.442530 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1H5', CAST(43.899610 AS Decimal(18, 6)), CAST(-79.443830 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1H6', CAST(43.899630 AS Decimal(18, 6)), CAST(-79.424859 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1H7', CAST(43.898595 AS Decimal(18, 6)), CAST(-79.426343 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1H8', CAST(43.898651 AS Decimal(18, 6)), CAST(-79.425367 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1H9', CAST(43.898771 AS Decimal(18, 6)), CAST(-79.443619 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1J1', CAST(43.899554 AS Decimal(18, 6)), CAST(-79.439598 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1J2', CAST(43.894431 AS Decimal(18, 6)), CAST(-79.424850 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1J3', CAST(43.895492 AS Decimal(18, 6)), CAST(-79.425657 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1J4', CAST(43.896232 AS Decimal(18, 6)), CAST(-79.425595 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1J5', CAST(43.896850 AS Decimal(18, 6)), CAST(-79.425694 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1J6', CAST(43.895538 AS Decimal(18, 6)), CAST(-79.423806 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1J7', CAST(43.894304 AS Decimal(18, 6)), CAST(-79.423763 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1J8', CAST(43.899833 AS Decimal(18, 6)), CAST(-79.423247 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1J9', CAST(43.897611 AS Decimal(18, 6)), CAST(-79.470601 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1K1', CAST(43.903113 AS Decimal(18, 6)), CAST(-79.467479 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1K2', CAST(43.902768 AS Decimal(18, 6)), CAST(-79.463638 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1K3', CAST(43.903751 AS Decimal(18, 6)), CAST(-79.464033 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1K4', CAST(43.904607 AS Decimal(18, 6)), CAST(-79.460773 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1K5', CAST(43.903832 AS Decimal(18, 6)), CAST(-79.453684 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1K6', CAST(43.904494 AS Decimal(18, 6)), CAST(-79.454028 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1K7', CAST(43.906177 AS Decimal(18, 6)), CAST(-79.451605 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1K8', CAST(43.907746 AS Decimal(18, 6)), CAST(-79.445882 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1K9', CAST(43.905015 AS Decimal(18, 6)), CAST(-79.445090 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1L1', CAST(43.904730 AS Decimal(18, 6)), CAST(-79.445070 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1L2', CAST(43.893385 AS Decimal(18, 6)), CAST(-79.441535 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1L3', CAST(43.910396 AS Decimal(18, 6)), CAST(-79.434195 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1L4', CAST(43.909332 AS Decimal(18, 6)), CAST(-79.423811 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1L5', CAST(43.902626 AS Decimal(18, 6)), CAST(-79.423035 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1L6', CAST(43.898870 AS Decimal(18, 6)), CAST(-79.421127 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1L7', CAST(43.895065 AS Decimal(18, 6)), CAST(-79.420169 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1L8', CAST(43.906445 AS Decimal(18, 6)), CAST(-79.423058 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1L9', CAST(43.900412 AS Decimal(18, 6)), CAST(-79.421508 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1M1', CAST(43.895557 AS Decimal(18, 6)), CAST(-79.420293 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1M2', CAST(43.892503 AS Decimal(18, 6)), CAST(-79.419500 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1M3', CAST(43.879047 AS Decimal(18, 6)), CAST(-79.417044 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1M4', CAST(43.897061 AS Decimal(18, 6)), CAST(-79.402050 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1M5', CAST(43.897135 AS Decimal(18, 6)), CAST(-79.400543 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1M6', CAST(43.899696 AS Decimal(18, 6)), CAST(-79.391871 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1M7', CAST(43.895395 AS Decimal(18, 6)), CAST(-79.409489 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1M8', CAST(43.896190 AS Decimal(18, 6)), CAST(-79.405885 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1M9', CAST(43.899578 AS Decimal(18, 6)), CAST(-79.391453 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1N1', CAST(43.899181 AS Decimal(18, 6)), CAST(-79.395979 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1N2', CAST(43.903003 AS Decimal(18, 6)), CAST(-79.396910 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1N3', CAST(43.904056 AS Decimal(18, 6)), CAST(-79.397166 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1N4', CAST(43.907248 AS Decimal(18, 6)), CAST(-79.397943 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1N5', CAST(43.907215 AS Decimal(18, 6)), CAST(-79.397935 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1N6', CAST(43.903102 AS Decimal(18, 6)), CAST(-79.396934 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1N7', CAST(43.917696 AS Decimal(18, 6)), CAST(-79.397179 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1N8', CAST(43.888876 AS Decimal(18, 6)), CAST(-79.393525 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1N9', CAST(43.883545 AS Decimal(18, 6)), CAST(-79.392354 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1P0', CAST(43.877027 AS Decimal(18, 6)), CAST(-79.406786 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1P1', CAST(43.880744 AS Decimal(18, 6)), CAST(-79.408845 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1P2', CAST(43.884367 AS Decimal(18, 6)), CAST(-79.392495 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1P3', CAST(43.870243 AS Decimal(18, 6)), CAST(-79.396236 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1P4', CAST(43.881533 AS Decimal(18, 6)), CAST(-79.387482 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1P5', CAST(43.880098 AS Decimal(18, 6)), CAST(-79.393061 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1P6', CAST(43.896906 AS Decimal(18, 6)), CAST(-79.462740 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1P7', CAST(43.897984 AS Decimal(18, 6)), CAST(-79.463834 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1P8', CAST(43.898741 AS Decimal(18, 6)), CAST(-79.463450 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1P9', CAST(43.899052 AS Decimal(18, 6)), CAST(-79.465646 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1R1', CAST(43.898571 AS Decimal(18, 6)), CAST(-79.467170 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1R2', CAST(43.898001 AS Decimal(18, 6)), CAST(-79.465564 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1R3', CAST(43.896935 AS Decimal(18, 6)), CAST(-79.466608 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1R4', CAST(43.896565 AS Decimal(18, 6)), CAST(-79.468956 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1R5', CAST(43.895752 AS Decimal(18, 6)), CAST(-79.467604 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1R6', CAST(43.896160 AS Decimal(18, 6)), CAST(-79.465985 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1R7', CAST(43.897655 AS Decimal(18, 6)), CAST(-79.469505 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1R8', CAST(43.897826 AS Decimal(18, 6)), CAST(-79.468220 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1R9', CAST(43.885015 AS Decimal(18, 6)), CAST(-79.415386 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1S1', CAST(43.883690 AS Decimal(18, 6)), CAST(-79.414770 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1S2', CAST(43.883361 AS Decimal(18, 6)), CAST(-79.415501 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1S3', CAST(43.886754 AS Decimal(18, 6)), CAST(-79.412344 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1S4', CAST(43.885413 AS Decimal(18, 6)), CAST(-79.412709 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1S5', CAST(43.885790 AS Decimal(18, 6)), CAST(-79.411922 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1S6', CAST(43.884500 AS Decimal(18, 6)), CAST(-79.411397 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1S7', CAST(43.883857 AS Decimal(18, 6)), CAST(-79.411538 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1S8', CAST(43.884287 AS Decimal(18, 6)), CAST(-79.408481 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1S9', CAST(43.884898 AS Decimal(18, 6)), CAST(-79.409090 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1T1', CAST(43.885145 AS Decimal(18, 6)), CAST(-79.407584 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1T2', CAST(43.885165 AS Decimal(18, 6)), CAST(-79.405916 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1T3', CAST(43.885932 AS Decimal(18, 6)), CAST(-79.406490 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1T4', CAST(43.886815 AS Decimal(18, 6)), CAST(-79.407792 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1T5', CAST(43.886286 AS Decimal(18, 6)), CAST(-79.408386 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1T6', CAST(43.885754 AS Decimal(18, 6)), CAST(-79.408842 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1T7', CAST(43.886887 AS Decimal(18, 6)), CAST(-79.410431 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1T8', CAST(43.887722 AS Decimal(18, 6)), CAST(-79.408535 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1T9', CAST(43.887016 AS Decimal(18, 6)), CAST(-79.406255 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1V1', CAST(43.886433 AS Decimal(18, 6)), CAST(-79.405958 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1V2', CAST(43.883804 AS Decimal(18, 6)), CAST(-79.409906 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1V3', CAST(43.882837 AS Decimal(18, 6)), CAST(-79.420868 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1V4', CAST(43.882892 AS Decimal(18, 6)), CAST(-79.416436 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1V5', CAST(43.883585 AS Decimal(18, 6)), CAST(-79.407478 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1V6', CAST(43.881892 AS Decimal(18, 6)), CAST(-79.415518 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1V7', CAST(43.881195 AS Decimal(18, 6)), CAST(-79.415357 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1V8', CAST(43.880122 AS Decimal(18, 6)), CAST(-79.414638 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1V9', CAST(43.881445 AS Decimal(18, 6)), CAST(-79.414228 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1W1', CAST(43.882784 AS Decimal(18, 6)), CAST(-79.412779 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1W2', CAST(43.882056 AS Decimal(18, 6)), CAST(-79.412786 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1W3', CAST(43.880906 AS Decimal(18, 6)), CAST(-79.412546 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1W4', CAST(43.882042 AS Decimal(18, 6)), CAST(-79.411061 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1W5', CAST(43.880787 AS Decimal(18, 6)), CAST(-79.410658 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1W6', CAST(43.879922 AS Decimal(18, 6)), CAST(-79.410353 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1W7', CAST(43.883065 AS Decimal(18, 6)), CAST(-79.409910 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1W8', CAST(43.881622 AS Decimal(18, 6)), CAST(-79.408850 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1W9', CAST(43.883289 AS Decimal(18, 6)), CAST(-79.408271 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1X1', CAST(43.882338 AS Decimal(18, 6)), CAST(-79.406820 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1X2', CAST(43.881305 AS Decimal(18, 6)), CAST(-79.406625 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1X3', CAST(43.879727 AS Decimal(18, 6)), CAST(-79.409773 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1X4', CAST(43.880831 AS Decimal(18, 6)), CAST(-79.407832 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1X5', CAST(43.880715 AS Decimal(18, 6)), CAST(-79.406328 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1X6', CAST(43.887136 AS Decimal(18, 6)), CAST(-79.404007 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1X7', CAST(43.887655 AS Decimal(18, 6)), CAST(-79.402363 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1X8', CAST(43.886025 AS Decimal(18, 6)), CAST(-79.403064 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1X9', CAST(43.886646 AS Decimal(18, 6)), CAST(-79.401601 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1Y1', CAST(43.887236 AS Decimal(18, 6)), CAST(-79.400114 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1Y2', CAST(43.886689 AS Decimal(18, 6)), CAST(-79.398706 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1Y3', CAST(43.886295 AS Decimal(18, 6)), CAST(-79.399594 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1Y4', CAST(43.885107 AS Decimal(18, 6)), CAST(-79.397880 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1Y5', CAST(43.885362 AS Decimal(18, 6)), CAST(-79.400835 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1Y6', CAST(43.885428 AS Decimal(18, 6)), CAST(-79.402565 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1Y7', CAST(43.884497 AS Decimal(18, 6)), CAST(-79.403767 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1Y8', CAST(43.884586 AS Decimal(18, 6)), CAST(-79.402265 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1Y9', CAST(43.884014 AS Decimal(18, 6)), CAST(-79.399929 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1Z1', CAST(43.882909 AS Decimal(18, 6)), CAST(-79.400374 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1Z2', CAST(43.882906 AS Decimal(18, 6)), CAST(-79.398526 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1Z3', CAST(43.884486 AS Decimal(18, 6)), CAST(-79.397793 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1Z4', CAST(43.883173 AS Decimal(18, 6)), CAST(-79.397024 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1Z5', CAST(43.886003 AS Decimal(18, 6)), CAST(-79.404722 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1Z6', CAST(43.904322 AS Decimal(18, 6)), CAST(-79.446775 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1Z7', CAST(43.905207 AS Decimal(18, 6)), CAST(-79.446941 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1Z8', CAST(43.904550 AS Decimal(18, 6)), CAST(-79.447873 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S1Z9', CAST(43.905739 AS Decimal(18, 6)), CAST(-79.448367 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2A1', CAST(43.904648 AS Decimal(18, 6)), CAST(-79.449629 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2A2', CAST(43.905168 AS Decimal(18, 6)), CAST(-79.449534 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2A3', CAST(43.879460 AS Decimal(18, 6)), CAST(-79.405719 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2A4', CAST(43.878546 AS Decimal(18, 6)), CAST(-79.405498 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2A5', CAST(43.878553 AS Decimal(18, 6)), CAST(-79.404395 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2A6', CAST(43.879100 AS Decimal(18, 6)), CAST(-79.404093 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2A7', CAST(43.906224 AS Decimal(18, 6)), CAST(-79.446978 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2A8', CAST(43.906538 AS Decimal(18, 6)), CAST(-79.448093 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2A9', CAST(43.897188 AS Decimal(18, 6)), CAST(-79.457978 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2B1', CAST(43.897094 AS Decimal(18, 6)), CAST(-79.456999 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2B2', CAST(43.897733 AS Decimal(18, 6)), CAST(-79.460902 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2B3', CAST(43.898399 AS Decimal(18, 6)), CAST(-79.459500 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2B4', CAST(43.897990 AS Decimal(18, 6)), CAST(-79.461258 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2B5', CAST(43.896396 AS Decimal(18, 6)), CAST(-79.461167 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2B6', CAST(43.910331 AS Decimal(18, 6)), CAST(-79.429972 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2B7', CAST(43.910758 AS Decimal(18, 6)), CAST(-79.428319 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2B8', CAST(43.909687 AS Decimal(18, 6)), CAST(-79.433657 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2B9', CAST(43.888669 AS Decimal(18, 6)), CAST(-79.417505 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2C1', CAST(43.887806 AS Decimal(18, 6)), CAST(-79.417087 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2C2', CAST(43.889512 AS Decimal(18, 6)), CAST(-79.416340 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2C3', CAST(43.888617 AS Decimal(18, 6)), CAST(-79.415074 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2C4', CAST(43.888390 AS Decimal(18, 6)), CAST(-79.413823 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2C5', CAST(43.888473 AS Decimal(18, 6)), CAST(-79.412606 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2C6', CAST(43.887282 AS Decimal(18, 6)), CAST(-79.412967 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2C7', CAST(43.888332 AS Decimal(18, 6)), CAST(-79.411115 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2C8', CAST(43.887900 AS Decimal(18, 6)), CAST(-79.409934 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2C9', CAST(43.887851 AS Decimal(18, 6)), CAST(-79.409721 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2E1', CAST(43.890077 AS Decimal(18, 6)), CAST(-79.417044 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2E2', CAST(43.889201 AS Decimal(18, 6)), CAST(-79.399521 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2E3', CAST(43.888558 AS Decimal(18, 6)), CAST(-79.397102 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2E4', CAST(43.887510 AS Decimal(18, 6)), CAST(-79.396191 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2E5', CAST(43.888574 AS Decimal(18, 6)), CAST(-79.394225 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2E6', CAST(43.888858 AS Decimal(18, 6)), CAST(-79.395632 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2E7', CAST(43.889215 AS Decimal(18, 6)), CAST(-79.394769 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2E8', CAST(43.890439 AS Decimal(18, 6)), CAST(-79.396290 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2E9', CAST(43.891014 AS Decimal(18, 6)), CAST(-79.394750 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2G1', CAST(43.880319 AS Decimal(18, 6)), CAST(-79.404423 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2G2', CAST(43.889259 AS Decimal(18, 6)), CAST(-79.417702 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2G3', CAST(43.901328 AS Decimal(18, 6)), CAST(-79.461373 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2G4', CAST(43.901937 AS Decimal(18, 6)), CAST(-79.460014 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2G5', CAST(43.901857 AS Decimal(18, 6)), CAST(-79.462071 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2G6', CAST(43.887100 AS Decimal(18, 6)), CAST(-79.394766 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2G7', CAST(43.890390 AS Decimal(18, 6)), CAST(-79.404516 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2G8', CAST(43.892524 AS Decimal(18, 6)), CAST(-79.406130 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2G9', CAST(43.892751 AS Decimal(18, 6)), CAST(-79.402721 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2H1', CAST(43.892873 AS Decimal(18, 6)), CAST(-79.401095 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2H2', CAST(43.891159 AS Decimal(18, 6)), CAST(-79.395861 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2H3', CAST(43.892360 AS Decimal(18, 6)), CAST(-79.395325 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2H4', CAST(43.893497 AS Decimal(18, 6)), CAST(-79.396137 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2H5', CAST(43.894263 AS Decimal(18, 6)), CAST(-79.396454 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2H6', CAST(43.892505 AS Decimal(18, 6)), CAST(-79.396440 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2H7', CAST(43.890204 AS Decimal(18, 6)), CAST(-79.418022 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2H8', CAST(43.901500 AS Decimal(18, 6)), CAST(-79.463920 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2H9', CAST(43.881046 AS Decimal(18, 6)), CAST(-79.402079 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2J1', CAST(43.879609 AS Decimal(18, 6)), CAST(-79.402697 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2J2', CAST(43.878925 AS Decimal(18, 6)), CAST(-79.402215 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2J3', CAST(43.878329 AS Decimal(18, 6)), CAST(-79.402393 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2J4', CAST(43.879939 AS Decimal(18, 6)), CAST(-79.401274 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2J5', CAST(43.881382 AS Decimal(18, 6)), CAST(-79.402142 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2J6', CAST(43.881192 AS Decimal(18, 6)), CAST(-79.400401 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2J7', CAST(43.880741 AS Decimal(18, 6)), CAST(-79.399725 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2J8', CAST(43.881915 AS Decimal(18, 6)), CAST(-79.399064 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2J9', CAST(43.880555 AS Decimal(18, 6)), CAST(-79.398787 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2K1', CAST(43.880147 AS Decimal(18, 6)), CAST(-79.397336 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2K2', CAST(43.879643 AS Decimal(18, 6)), CAST(-79.397785 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2K3', CAST(43.880735 AS Decimal(18, 6)), CAST(-79.397189 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2K4', CAST(43.881540 AS Decimal(18, 6)), CAST(-79.396566 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2K5', CAST(43.882438 AS Decimal(18, 6)), CAST(-79.397643 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2K6', CAST(43.881973 AS Decimal(18, 6)), CAST(-79.394309 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2K7', CAST(43.882651 AS Decimal(18, 6)), CAST(-79.393579 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2K8', CAST(43.882975 AS Decimal(18, 6)), CAST(-79.392766 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2K9', CAST(43.882538 AS Decimal(18, 6)), CAST(-79.401479 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2L1', CAST(43.899383 AS Decimal(18, 6)), CAST(-79.468286 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2L2', CAST(43.900283 AS Decimal(18, 6)), CAST(-79.467590 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2L3', CAST(43.900020 AS Decimal(18, 6)), CAST(-79.469510 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2M4', CAST(43.886961 AS Decimal(18, 6)), CAST(-79.393850 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2M5', CAST(43.883874 AS Decimal(18, 6)), CAST(-79.402750 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2M6', CAST(43.907314 AS Decimal(18, 6)), CAST(-79.443730 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2M7', CAST(43.906767 AS Decimal(18, 6)), CAST(-79.443898 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2M8', CAST(43.908054 AS Decimal(18, 6)), CAST(-79.440541 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2M9', CAST(43.901391 AS Decimal(18, 6)), CAST(-79.440078 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2N1', CAST(43.905434 AS Decimal(18, 6)), CAST(-79.434805 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2N2', CAST(43.906225 AS Decimal(18, 6)), CAST(-79.433611 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2N3', CAST(43.898811 AS Decimal(18, 6)), CAST(-79.447212 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2N4', CAST(43.894014 AS Decimal(18, 6)), CAST(-79.412794 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2N5', CAST(43.893706 AS Decimal(18, 6)), CAST(-79.411542 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2N6', CAST(43.891759 AS Decimal(18, 6)), CAST(-79.412210 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2N7', CAST(43.892500 AS Decimal(18, 6)), CAST(-79.411274 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2N8', CAST(43.891941 AS Decimal(18, 6)), CAST(-79.410422 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2N9', CAST(43.891452 AS Decimal(18, 6)), CAST(-79.409349 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2P1', CAST(43.890239 AS Decimal(18, 6)), CAST(-79.409684 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2P2', CAST(43.890332 AS Decimal(18, 6)), CAST(-79.408783 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2P3', CAST(43.903070 AS Decimal(18, 6)), CAST(-79.455741 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2P4', CAST(43.903580 AS Decimal(18, 6)), CAST(-79.454654 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2P5', CAST(43.902994 AS Decimal(18, 6)), CAST(-79.453505 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2P6', CAST(43.903613 AS Decimal(18, 6)), CAST(-79.451173 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2P7', CAST(43.903794 AS Decimal(18, 6)), CAST(-79.453025 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2P8', CAST(43.908876 AS Decimal(18, 6)), CAST(-79.435636 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2P9', CAST(43.909197 AS Decimal(18, 6)), CAST(-79.436749 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2R1', CAST(43.908771 AS Decimal(18, 6)), CAST(-79.434788 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2R2', CAST(43.908202 AS Decimal(18, 6)), CAST(-79.438466 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2R3', CAST(43.908588 AS Decimal(18, 6)), CAST(-79.439621 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2R4', CAST(43.890954 AS Decimal(18, 6)), CAST(-79.408130 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2R5', CAST(43.890450 AS Decimal(18, 6)), CAST(-79.407297 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2R6', CAST(43.889848 AS Decimal(18, 6)), CAST(-79.406347 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2R7', CAST(43.892070 AS Decimal(18, 6)), CAST(-79.413597 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2R8', CAST(43.893202 AS Decimal(18, 6)), CAST(-79.413987 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2R9', CAST(43.893706 AS Decimal(18, 6)), CAST(-79.414397 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2S1', CAST(43.893873 AS Decimal(18, 6)), CAST(-79.402731 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2S2', CAST(43.894581 AS Decimal(18, 6)), CAST(-79.403352 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2S3', CAST(43.898365 AS Decimal(18, 6)), CAST(-79.421347 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2S4', CAST(43.891373 AS Decimal(18, 6)), CAST(-79.406857 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2S5', CAST(43.895716 AS Decimal(18, 6)), CAST(-79.404767 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2S6', CAST(43.896026 AS Decimal(18, 6)), CAST(-79.396777 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2S7', CAST(43.895695 AS Decimal(18, 6)), CAST(-79.398662 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2S8', CAST(43.896549 AS Decimal(18, 6)), CAST(-79.399161 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2S9', CAST(43.896961 AS Decimal(18, 6)), CAST(-79.397273 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2T1', CAST(43.897463 AS Decimal(18, 6)), CAST(-79.398112 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2T2', CAST(43.898445 AS Decimal(18, 6)), CAST(-79.449503 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2T3', CAST(43.902404 AS Decimal(18, 6)), CAST(-79.467733 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2T4', CAST(43.902453 AS Decimal(18, 6)), CAST(-79.467033 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2T5', CAST(43.895316 AS Decimal(18, 6)), CAST(-79.403391 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2T6', CAST(43.895823 AS Decimal(18, 6)), CAST(-79.404468 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2T7', CAST(43.894853 AS Decimal(18, 6)), CAST(-79.395665 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2T8', CAST(43.896010 AS Decimal(18, 6)), CAST(-79.396087 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2T9', CAST(43.970587 AS Decimal(18, 6)), CAST(-79.380571 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2V1', CAST(43.893717 AS Decimal(18, 6)), CAST(-79.406276 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2V2', CAST(43.893182 AS Decimal(18, 6)), CAST(-79.406840 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2V3', CAST(43.892658 AS Decimal(18, 6)), CAST(-79.408344 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2V4', CAST(43.894497 AS Decimal(18, 6)), CAST(-79.408324 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2V5', CAST(43.894497 AS Decimal(18, 6)), CAST(-79.400814 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2V6', CAST(43.893546 AS Decimal(18, 6)), CAST(-79.400792 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2V7', CAST(43.895264 AS Decimal(18, 6)), CAST(-79.400357 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2V8', CAST(43.895087 AS Decimal(18, 6)), CAST(-79.401899 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2V9', CAST(43.895833 AS Decimal(18, 6)), CAST(-79.401988 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2W1', CAST(43.900834 AS Decimal(18, 6)), CAST(-79.460340 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2W2', CAST(43.900139 AS Decimal(18, 6)), CAST(-79.458709 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2W3', CAST(43.900543 AS Decimal(18, 6)), CAST(-79.457225 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2W4', CAST(43.900387 AS Decimal(18, 6)), CAST(-79.455882 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2W5', CAST(43.899169 AS Decimal(18, 6)), CAST(-79.456734 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2W6', CAST(43.898740 AS Decimal(18, 6)), CAST(-79.454208 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2W7', CAST(43.899901 AS Decimal(18, 6)), CAST(-79.453314 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2W8', CAST(43.901622 AS Decimal(18, 6)), CAST(-79.453630 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2W9', CAST(43.901079 AS Decimal(18, 6)), CAST(-79.454929 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2X1', CAST(43.898674 AS Decimal(18, 6)), CAST(-79.448625 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2X2', CAST(43.885047 AS Decimal(18, 6)), CAST(-79.423576 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2X3', CAST(43.894920 AS Decimal(18, 6)), CAST(-79.404710 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2X4', CAST(43.895754 AS Decimal(18, 6)), CAST(-79.405543 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2X9', CAST(43.895517 AS Decimal(18, 6)), CAST(-79.405356 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S2Z3', CAST(43.897717 AS Decimal(18, 6)), CAST(-79.429190 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S3B6', CAST(43.897242 AS Decimal(18, 6)), CAST(-79.428176 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S3C9', CAST(43.809656 AS Decimal(18, 6)), CAST(-79.428123 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S3E5', CAST(43.897242 AS Decimal(18, 6)), CAST(-79.428176 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S3M3', CAST(43.880770 AS Decimal(18, 6)), CAST(-79.397133 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S3N8', CAST(43.902498 AS Decimal(18, 6)), CAST(-79.408493 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S3P8', CAST(43.898960 AS Decimal(18, 6)), CAST(-79.426524 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S3R9', CAST(43.893760 AS Decimal(18, 6)), CAST(-79.414410 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S3S1', CAST(43.897242 AS Decimal(18, 6)), CAST(-79.428176 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S3S8', CAST(43.897242 AS Decimal(18, 6)), CAST(-79.428176 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S3T2', CAST(43.902498 AS Decimal(18, 6)), CAST(-79.408493 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S3V6', CAST(43.897242 AS Decimal(18, 6)), CAST(-79.428176 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S4B1', CAST(43.866876 AS Decimal(18, 6)), CAST(-79.234815 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S4C1', CAST(43.902498 AS Decimal(18, 6)), CAST(-79.408493 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S4C8', CAST(43.902498 AS Decimal(18, 6)), CAST(-79.408493 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S4C9', CAST(43.897242 AS Decimal(18, 6)), CAST(-79.428176 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S4E3', CAST(43.897242 AS Decimal(18, 6)), CAST(-79.428176 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S4E6', CAST(43.898384 AS Decimal(18, 6)), CAST(-79.434279 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S4G4', CAST(43.900412 AS Decimal(18, 6)), CAST(-79.421508 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S4H2', CAST(43.848548 AS Decimal(18, 6)), CAST(-79.258154 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S4K6', CAST(43.902498 AS Decimal(18, 6)), CAST(-79.408493 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S4L8', CAST(43.902498 AS Decimal(18, 6)), CAST(-79.408493 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S4N2', CAST(43.902498 AS Decimal(18, 6)), CAST(-79.408493 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S4N7', CAST(43.902498 AS Decimal(18, 6)), CAST(-79.408493 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S4S4', CAST(43.902498 AS Decimal(18, 6)), CAST(-79.408493 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S5C3', CAST(43.897242 AS Decimal(18, 6)), CAST(-79.428176 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S5C5', CAST(43.903370 AS Decimal(18, 6)), CAST(-79.462414 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S7E6', CAST(43.806705 AS Decimal(18, 6)), CAST(-79.466662 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S7G8', CAST(43.908177 AS Decimal(18, 6)), CAST(-79.434370 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S7K5', CAST(43.806241 AS Decimal(18, 6)), CAST(-79.434325 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S7K9', CAST(43.804496 AS Decimal(18, 6)), CAST(-79.448745 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S7L9', CAST(43.865385 AS Decimal(18, 6)), CAST(-79.437736 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S7S1', CAST(43.809783 AS Decimal(18, 6)), CAST(-79.474513 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S7T5', CAST(43.897242 AS Decimal(18, 6)), CAST(-79.428176 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S7T7', CAST(43.897242 AS Decimal(18, 6)), CAST(-79.428176 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S7W1', CAST(43.818591 AS Decimal(18, 6)), CAST(-79.462882 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S7X7', CAST(43.806327 AS Decimal(18, 6)), CAST(-79.454474 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S7Y6', CAST(43.897242 AS Decimal(18, 6)), CAST(-79.428176 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S9A1', CAST(43.897242 AS Decimal(18, 6)), CAST(-79.428176 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S9A4', CAST(43.806327 AS Decimal(18, 6)), CAST(-79.454474 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S9C4', CAST(43.843946 AS Decimal(18, 6)), CAST(-79.467707 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S9C7', CAST(43.844122 AS Decimal(18, 6)), CAST(-79.470619 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S9L1', CAST(43.897242 AS Decimal(18, 6)), CAST(-79.428176 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S9S5', CAST(43.866261 AS Decimal(18, 6)), CAST(-79.440714 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S9V3', CAST(43.873465 AS Decimal(18, 6)), CAST(-79.427409 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4S9V5', CAST(43.873465 AS Decimal(18, 6)), CAST(-79.427409 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4T8T7', CAST(43.864504 AS Decimal(18, 6)), CAST(-79.430602 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4X4X7', CAST(43.904419 AS Decimal(18, 6)), CAST(-79.453297 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4Z7P8', CAST(43.866753 AS Decimal(18, 6)), CAST(-79.451782 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L4Z7W8', CAST(43.973265 AS Decimal(18, 6)), CAST(-79.238479 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L6B4E1', CAST(43.847573 AS Decimal(18, 6)), CAST(-79.429778 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L6B4M2', CAST(43.590650 AS Decimal(18, 6)), CAST(-79.631484 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L6B4P9', CAST(43.902522 AS Decimal(18, 6)), CAST(-79.211266 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L6B4S7', CAST(43.846257 AS Decimal(18, 6)), CAST(-79.425630 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L6B4T3', CAST(43.902522 AS Decimal(18, 6)), CAST(-79.211266 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L6C9R6', CAST(43.862262 AS Decimal(18, 6)), CAST(-79.434788 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L6C9X2', CAST(43.875976 AS Decimal(18, 6)), CAST(-79.414944 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L7A4K7', CAST(43.844532 AS Decimal(18, 6)), CAST(-79.429793 AS Decimal(18, 6)), N'RICHMOND HILL', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L7B7C3', CAST(43.876334 AS Decimal(18, 6)), CAST(-79.440759 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'L9L2L4', CAST(43.952481 AS Decimal(18, 6)), CAST(-79.450167 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'M4S0G1', CAST(43.902091 AS Decimal(18, 6)), CAST(-79.463982 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'N4E0J1', CAST(43.677309 AS Decimal(18, 6)), CAST(-79.388115 AS Decimal(18, 6)), N'RICHMOND HILL', N'ON')
GO
INSERT [dbo].[PostalCodes] ([PostalCode], [Latitude], [Longitude], [City], [Province]) VALUES (N'N8G2X1', CAST(44.951360 AS Decimal(18, 6)), CAST(-81.332444 AS Decimal(18, 6)), N'Richmond Hill', N'ON')
GO
