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