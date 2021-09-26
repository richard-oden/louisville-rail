USE master;
GO

IF DATABASEPROPERTYEX ('LouisvilleRailNetwork','Version') IS NOT NULL
BEGIN
	ALTER DATABASE LouisvilleRailNetwork SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
	DROP DATABASE LouisvilleRailNetwork;
END
GO

CREATE DATABASE LouisvilleRailNetwork;
GO

ALTER DATABASE LouisvilleRailNetwork SET RECOVERY SIMPLE;
GO

USE LouisvilleRailNetwork;
GO

CREATE TABLE Line (
	Id int identity(1,1) NOT NULL,
	LineName nvarchar(255),
	CONSTRAINT PK_Line PRIMARY KEY LineId,
	CONSTRAINT FK_LineStop FOREIGN KEY (LineId) REFERENCES Line (Id)
);
GO

CREATE TABLE LineStop (
	LineId int NOT NULL,
	StopId int NOT NULL,
	LineStopOrder int NOT NULL,
	CONSTRAINT PK_RailLine PRIMARY KEY RouteId,
	CONSTRAINT FK_RailLineStops FOREIGN KEY (RouteId) REFERENCES RailLine (LineId)
);
GO