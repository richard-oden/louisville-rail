USE master;

DROP DATABASE IF EXISTS LouisvilleRailNetwork;

CREATE DATABASE LouisvilleRailNetwork;

USE LouisvilleRailNetwork;

CREATE TABLE Line (
	Id int NOT NULL PRIMARY KEY,
	[Name] nvarchar(255));

CREATE TABLE [Stop] (
	Id int NOT NULL PRIMARY KEY,
	[Name] varchar(255),
	[Address] varchar(255),
	Latitude decimal(8,6) NOT NULL,
	Longitude decimal(9,6) NOT NULL);

CREATE TABLE LineStop (
	Id int NOT NULL PRIMARY KEY,
	LineId int NOT NULL FOREIGN KEY REFERENCES Line(Id),
	StopId int NOT NULL FOREIGN KEY REFERENCES [Stop](Id),
	LineStopOrder int NOT NULL);

CREATE TABLE Trip (
	Id int NOT NULL PRIMARY KEY,
	StartDateTime DateTime,
	EndDateTime DateTime);

CREATE TABLE TripSegment (
	Id int NOT NULL PRIMARY KEY,
	TripId int NOT NULL FOREIGN KEY REFERENCES Trip(Id),
	FirstLineStopId int NOT NULL FOREIGN KEY REFERENCES LineStop(Id),
	SecondLineStopId int NOT NULL FOREIGN KEY REFERENCES LineStop(Id),
	DurationInSeconds int NOT NULL,
	TripSegmentOrder int NOT NULL);