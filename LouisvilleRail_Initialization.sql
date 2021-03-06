USE master;

DROP DATABASE IF EXISTS LouisvilleRailNetwork;

CREATE DATABASE LouisvilleRailNetwork;

USE LouisvilleRailNetwork;


---------------------
------ TABLES -------
---------------------

CREATE TABLE Line (
	Id int IDENTITY PRIMARY KEY,
	[Name] varchar(255),
	Color varchar(255));
GO

CREATE TABLE [Stop] (
	Id int IDENTITY PRIMARY KEY,
	[Name] varchar(255),
	[Address] varchar(255),
	Latitude decimal(8,6) NOT NULL,
	Longitude decimal(9,6) NOT NULL);
GO

CREATE NONCLUSTERED INDEX IX_Stop_Latitude
	ON [Stop](Latitude ASC);
GO

CREATE NONCLUSTERED INDEX IX_Stop_Longitude
	ON [Stop](Longitude ASC);
GO

CREATE TABLE LineStop (
	Id int IDENTITY PRIMARY KEY,
	LineId int NOT NULL FOREIGN KEY REFERENCES Line(Id),
	StopId int NOT NULL FOREIGN KEY REFERENCES [Stop](Id),
	LineStopOrder int NOT NULL,
	
	CHECK (LineStopOrder > 0));
GO

CREATE NONCLUSTERED INDEX IX_LineStop_LineId
	ON LineStop(LineId ASC);
GO

CREATE NONCLUSTERED INDEX IX_LineStop_StopId
	ON LineStop(StopId ASC);
GO

CREATE TABLE Trip (
	Id int IDENTITY PRIMARY KEY,
	StartDateTime datetime,
	EndDateTime datetime,
	
	CONSTRAINT CK_Trip_ValidDateTimes CHECK(StartDateTime < EndDateTime));
GO

CREATE TABLE TripSegment (
	Id int IDENTITY PRIMARY KEY,
	TripId int NOT NULL FOREIGN KEY REFERENCES Trip(Id),
	FirstStopId int NOT NULL FOREIGN KEY REFERENCES [Stop](Id),
	SecondStopId int NOT NULL FOREIGN KEY REFERENCES [Stop](Id),
	StartDateTime datetime,
	EndDateTime datetime,
	
	CONSTRAINT CK_TripSegment_ValidDateTimes CHECK(StartDateTime < EndDateTime));
GO

CREATE NONCLUSTERED INDEX IX_TripSegment_TripId
	ON TripSegment(TripId ASC);
GO

----------------------
-- HELPER FUNCTIONS --
----------------------

CREATE FUNCTION GetDistanceInFeet
(   
    @Lat1 decimal(8,6), 
	@Lon1 decimal(9,6), 
	@Lat2 decimal(8,6), 
	@Lon2 decimal(9,6)
)
RETURNS int 
AS
BEGIN 
	DECLARE @DistanceInFeet float
    SET @DistanceInFeet = GEOGRAPHY::Point(@Lat1, @Lon1, 4738).STDistance(GEOGRAPHY::Point(@Lat2, @Lon2, 4738))
	
	RETURN @DistanceInFeet
END;
GO

CREATE FUNCTION FormatDistance
(
	@DistanceInFeet float
)
RETURNS varchar(255)
AS
BEGIN
	DECLARE @FormattedDistance varchar(255)
	SET @FormattedDistance = (SELECT IIF(@DistanceInFeet >= 5280, 
		CAST(ROUND(@DistanceInFeet / 5280, 2) AS varchar(255)) + ' miles', 
		CAST(@DistanceInFeet AS varchar(255)) + ' feet'))
	
	RETURN @FormattedDistance
END;
GO

CREATE FUNCTION GetFormattedDistanceInFeet
(
	@Lat1 decimal(8,6), 
	@Lon1 decimal(9,6), 
	@Lat2 decimal(8,6), 
	@Lon2 decimal(9,6)
)
RETURNS varchar(255)
AS
BEGIN
	DECLARE @DistanceInFeet float
	DECLARE @FormattedDistanceInFeet varchar(255)
	SET @DistanceInFeet = (SELECT [dbo].[GetDistanceInFeet](@Lat1, @Lon1, @Lat2, @Lon2))
	SET @FormattedDistanceInFeet = (SELECT [dbo].[FormatDistance](@DistanceInFeet))

	RETURN @FormattedDistanceInFeet
END;
GO

---------------------
-- CRUD OPERATIONS --
---------------------

-- Line:
CREATE OR ALTER PROCEDURE CreateLine
	@LineName varchar(255),
	@LineColor varchar(255)
AS
BEGIN
	INSERT INTO Line VALUES (@LineName, @LineColor);
END
GO

CREATE OR ALTER PROCEDURE ReadLineById
	@LineId int 
AS
BEGIN
	SELECT * FROM Line WHERE Id = @LineId;
END
GO

CREATE OR ALTER PROCEDURE UpdateLineById
	@LineId int,
	@LineName varchar(255) = NULL,
	@LineColor varchar(255) = NULL
AS
BEGIN
	UPDATE Line
		SET 
			[Name] = COALESCE(@LineName, [Name]),
			Color = COALESCE(@LineColor, Color)
		WHERE Id = @LineId;
END
GO

CREATE OR ALTER PROCEDURE DeleteLineById
	@LineId int 
AS
BEGIN
	DELETE FROM LineStop WHERE LineId = @LineId;
	DELETE FROM Line WHERE Id = @LineId;
END
GO


-- Stop:
CREATE OR ALTER PROCEDURE CreateStop
	@StopName varchar(255),
	@StopAddress varchar(255),
	@Latitude decimal(8,6),
	@Longitude decimal(9,6)
AS
BEGIN
	INSERT INTO [Stop] VALUES (@StopName, @StopAddress, @Latitude, @Longitude);
END
GO

CREATE OR ALTER PROCEDURE ReadStopById
	@StopId int
AS
BEGIN
	SELECT * FROM [Stop] WHERE Id = @StopId;
END
GO

CREATE OR ALTER PROCEDURE UpdateStopById
	@StopId int,
	@StopName varchar(255) = NULL,
	@StopAddress varchar(255) = NULL,
	@Latitude decimal(8,6) = NULL,
	@Longitude decimal(9,6) = NULL
AS
BEGIN
	UPDATE [Stop]
		SET 
			[Name] = COALESCE(@StopName, [Name]),
			[Address] = COALESCE(@StopAddress, [Address]),
			Latitude = COALESCE(@Latitude, Latitude),
			Longitude = COALESCE(@Longitude, Longitude)
		WHERE Id = @StopId;
END
GO

CREATE OR ALTER PROCEDURE DeleteStopById
	@StopId int
AS
BEGIN
	DELETE FROM TripSegment WHERE FirstStopId = @StopId OR SecondStopId = @StopId;
	DELETE FROM LineStop WHERE StopId = @StopId;
	DELETE FROM [Stop] WHERE Id = @StopId;
END
GO


-- LineStop:
CREATE OR ALTER PROCEDURE CreateLineStop
	@LineId int,
	@StopId int,
	@LineStopOrder int
AS
BEGIN
	INSERT INTO LineStop VALUES (@LineId, @StopId, @LineStopOrder);
END
GO

CREATE OR ALTER PROCEDURE ReadLineStopById
	@LineStopId int
AS
BEGIN
	SELECT * FROM LineStop WHERE Id = @LineStopId;
END
GO

CREATE OR ALTER PROCEDURE UpdateLineStopById
	@LineStopId int,
	@LineId int = NULL,
	@StopId int = NULL,
	@LineStopOrder int = NULL
AS
BEGIN
	UPDATE [LineStop]
		SET 
			LineId = COALESCE(@LineId, LineId),
			StopId = COALESCE(@StopId, StopId),
			LineStopOrder = COALESCE(@LineStopOrder, LineStopOrder)
		WHERE Id = @LineStopId;
END
GO

CREATE OR ALTER PROCEDURE DeleteLineStopById
	@LineStopId int
AS
BEGIN
	DELETE FROM LineStop WHERE Id = @LineStopId;
END
GO


-- Trip:
CREATE OR ALTER PROCEDURE CreateTrip
	@StartDateTime datetime,
	@EndDateTime datetime
AS
BEGIN
	INSERT INTO Trip VALUES (@StartDateTime, @EndDateTime);
END
GO

CREATE OR ALTER PROCEDURE ReadTripById
	@TripId int
AS
BEGIN
	SELECT * FROM Trip WHERE Id = @TripId;
END
GO

CREATE OR ALTER PROCEDURE UpdateTripById
	@TripId int,
	@StartDateTime datetime = NULL,
	@EndDateTime datetime = NULL
AS
BEGIN
	UPDATE [Trip]
		SET 
			StartDateTime = COALESCE(@StartDateTime, StartDateTime),
			EndDateTime = COALESCE(@EndDateTime, EndDateTime)
		WHERE Id = @TripId;
END
GO

CREATE OR ALTER PROCEDURE DeleteTripById
	@TripId int
AS
BEGIN
	DELETE FROM TripSegment WHERE TripId = @TripId;
	DELETE FROM Trip WHERE Id = @TripId;
END
GO


-- TripSegment:
CREATE OR ALTER PROCEDURE CreateTripSegment
	@TripId int,
	@FirstStopId int,
	@SecondStopId int,
	@StartDateTime datetime,
	@EndDateTime datetime
AS
BEGIN
	INSERT INTO TripSegment VALUES (@TripId, @FirstStopId, @SecondStopId, @StartDateTime, @EndDateTime);
END
GO

CREATE OR ALTER PROCEDURE ReadTripSegmentById
	@TripSegmentId int
AS
BEGIN
	SELECT * FROM TripSegment WHERE Id = @TripSegmentId;
END
GO

CREATE OR ALTER PROCEDURE UpdateTripSegmentById
	@TripSegmentId int,
	@TripId int = NULL,
	@FirstStopId int = NULL,
	@SecondStopId int = NULL,
	@StartDateTime datetime = NULL,
	@EndDateTime datetime = NULL
AS
BEGIN
	UPDATE [TripSegment]
		SET 
			TripId = COALESCE(@TripId, TripId),
			FirstStopId = COALESCE(@FirstStopId, FirstStopId),
			SecondStopId = COALESCE(@SecondStopId, SecondStopId),
			StartDateTime = COALESCE(@StartDateTime, StartDateTime),
			EndDateTime = COALESCE(@EndDateTime, EndDateTime)
		WHERE Id = @TripSegmentId;
END
GO

CREATE OR ALTER PROCEDURE DeleteTripSegmentById
	@TripSegmentId int
AS
BEGIN
	DELETE FROM TripSegment WHERE Id = @TripSegmentId;
END
GO

---------------------
-------- ETL --------
---------------------

BULK INSERT Line
FROM 'C:\louisville-rail\Lines.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);
GO

BULK INSERT [Stop]
FROM 'C:\louisville-rail\Stops.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);
GO

BULK INSERT LineStop
FROM 'C:\louisville-rail\LineStops.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);
GO

BULK INSERT Trip
FROM 'C:\louisville-rail\Trips.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);
GO

BULK INSERT TripSegment
FROM 'C:\louisville-rail\TripSegments.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);
GO