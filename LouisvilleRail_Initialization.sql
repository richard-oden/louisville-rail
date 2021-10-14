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

CREATE TABLE LineStop (
	Id int IDENTITY PRIMARY KEY,
	LineId int NOT NULL FOREIGN KEY REFERENCES Line(Id),
	StopId int NOT NULL FOREIGN KEY REFERENCES [Stop](Id),
	LineStopOrder int NOT NULL);
GO

CREATE TABLE Trip (
	Id int IDENTITY PRIMARY KEY,
	StartDateTime datetime,
	EndDateTime datetime);
GO

CREATE TABLE TripSegment (
	Id int IDENTITY PRIMARY KEY,
	TripId int NOT NULL FOREIGN KEY REFERENCES Trip(Id),
	FirstLineStopId int NOT NULL FOREIGN KEY REFERENCES LineStop(Id),
	SecondLineStopId int NOT NULL FOREIGN KEY REFERENCES LineStop(Id),
	DurationInSeconds int NOT NULL,
	TripSegmentOrder int NOT NULL);
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
	INSERT INTO Line VALUES (@LineName);
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
	DELETE FROM [Stop] WHERE Id = @StopId;
END
GO


-- LineStop:
CREATE OR ALTER PROCEDURE CreateLineStop
	@LineId int,
	@StopId int,
	@StopOrder int
AS
BEGIN
	INSERT INTO LineStop VALUES (@LineId, @StopId, @StopOrder);
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


-- Trip and TripSegment:
CREATE TYPE TripSegmentType AS TABLE(
	FirstLineStopId int NOT NULL,
	SecondLineStopId int NOT NULL,
	DurationInSeconds int NOT NULL,
	TripSegmentOrder int NOT NULL);
GO

CREATE TYPE TripSegmentTypeWithId AS TABLE(
	Id int NOT NULL,
	FirstLineStopId int,
	SecondLineStopId int,
	DurationInSeconds int,
	TripSegmentOrder int);
GO

CREATE OR ALTER PROCEDURE CreateTrip
	@StartDateTime datetime,
	@TripSegments TripSegmentType READONLY
AS
BEGIN
	DECLARE @TripId AS int;
	DECLARE @EndDateTime AS datetime;

	SELECT @TripId = MAX(Id) + 1 FROM Trip;
	SELECT @EndDateTime = DATEADD(ss, SUM(DurationInSeconds), @StartDateTime) FROM @TripSegments;

	INSERT INTO Trip VALUES (@StartDateTime, @EndDateTime);
	INSERT INTO TripSegment 
		SELECT @TripId, FirstLineStopId, SecondLineStopId, DurationInSeconds, TripSegmentOrder
		FROM @TripSegments;
END
GO

CREATE OR ALTER PROCEDURE ReadTripById
	@TripId int
AS
BEGIN
	SELECT * FROM Trip WHERE Id = @TripId;
END
GO

CREATE OR ALTER PROCEDURE ReadTripSegmentById
	@TripSegmentId int
AS
BEGIN
	SELECT * FROM TripSegment WHERE Id = @TripSegmentId;
END
GO

CREATE OR ALTER PROCEDURE UpdateTripById
	@TripId int,
	@StartDateTime datetime = NULL,
	@TripSegmentsWithId TripSegmentTypeWithId READONLY
AS
BEGIN
	DECLARE @DefaultStartDateTime AS datetime;
	DECLARE @EndDateTime AS datetime;

	SELECT @DefaultStartDateTime = StartDateTime FROM Trip WHERE Id = @TripId;
	SELECT @EndDateTime = DATEADD(ss, SUM(DurationInSeconds), COALESCE(@StartDateTime, @DefaultStartDateTime)) FROM @TripSegmentsWithId;

	UPDATE Trip
		SET 
			StartDateTime = COALESCE(@StartDateTime, StartDateTime),
			EndDateTime = @EndDateTime
		WHERE Id = @TripId;

	UPDATE TS1
		SET
			TS1.FirstLineStopId = COALESCE(TS2.FirstLineStopId, TS1.FirstLineStopId),
			TS1.SecondLineStopId = COALESCE(TS2.SecondLineStopId, TS1.SecondLineStopId),
			TS1.DurationInSeconds = COALESCE(TS2.DurationInSeconds, TS1.DurationInSeconds),
			TS1.TripSegmentOrder = COALESCE(TS2.TripSegmentOrder, TS1.TripSegmentOrder)
		FROM TripSegment TS1, @TripSegmentsWithId TS2
		WHERE TS1.Id = TS2.Id
END
GO

CREATE OR ALTER PROCEDURE DeleteTripById
	@TripId int
AS
BEGIN
	DELETE FROM Trip WHERE Id = @TripId;
	DELETE FROM TripSegment WHERE TripId = @TripId;
END
GO

BULK INSERT [Stop]
FROM 'C:\Users\richa\Desktop\sql-projects\LouisvilleRail\Stops.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',  --CSV field delimiter
	ROWTERMINATOR = '\n',   --Use to shift the control to next row
	TABLOCK
);
GO

SELECT * FROM [Stop];