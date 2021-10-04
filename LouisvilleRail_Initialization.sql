USE master;

DROP DATABASE IF EXISTS LouisvilleRailNetwork;

CREATE DATABASE LouisvilleRailNetwork;

USE LouisvilleRailNetwork;


---------------------
------ TABLES -------
---------------------

CREATE TABLE Line (
	Id int IDENTITY PRIMARY KEY,
	[Name] nvarchar(255));
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
	@LineName varchar(255)
AS
BEGIN
	INSERT INTO Line VALUES (@LineName);
END
GO

CREATE OR ALTER PROCEDURE ReadLineById
	@LineName varchar(255)
AS
BEGIN
	SELECT * FROM Line WHERE Id = @LineId;
END
GO

CREATE OR ALTER PROCEDURE UpdateLineById
	@LineId int,
	@LineName varchar(255)
AS
BEGIN
	UPDATE Line
		SET [Name] = @LineName
	WHERE Id = @LineId;
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
	UPDATE [STOP]
		SET 
			[Name] = COALESCE(@StopName, [Name]),
			[Address] = COALESCE(@StopAddress, [Address]),
			Latitude = COALESCE(@Latitude, Latitude),
			Longitude = COALESCE(@Longitude, Longitude)
	WHERE Id = @StopId;
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


-- Trip and TripSegment:
CREATE TYPE TripSegmentType AS TABLE(
	FirstLineStopId int NOT NULL,
	SecondLineStopId int NOT NULL,
	DurationInSeconds int NOT NULL,
	TripSegmentOrder int NOT NULL);
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