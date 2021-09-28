USE master;

DROP DATABASE IF EXISTS LouisvilleRailNetwork;

CREATE DATABASE LouisvilleRailNetwork;

USE LouisvilleRailNetwork;

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
	StartDateTime DateTime,
	EndDateTime DateTime);
GO

CREATE TABLE TripSegment (
	Id int IDENTITY PRIMARY KEY,
	TripId int NOT NULL FOREIGN KEY REFERENCES Trip(Id),
	FirstLineStopId int NOT NULL FOREIGN KEY REFERENCES LineStop(Id),
	SecondLineStopId int NOT NULL FOREIGN KEY REFERENCES LineStop(Id),
	DurationInSeconds int NOT NULL,
	TripSegmentOrder int NOT NULL);
GO

CREATE OR ALTER PROCEDURE CreateLine
	@LineName varchar(255)
AS
BEGIN
	INSERT INTO Line VALUES (@LineName);
END