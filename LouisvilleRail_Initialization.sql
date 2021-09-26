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

CREATE TABLE RailLine (
	LineId int identity(1,1) NOT NULL,
	RouteName nvarchar(255),
	CONSTRAINT PK_RailLine PRIMARY KEY RouteId,
	CONSTRAINT FK_RailLineStops FOREIGN KEY (RouteId) REFERENCES RailLine (LineId)
);
GO