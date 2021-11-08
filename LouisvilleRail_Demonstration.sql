USE LouisvilleRailNetwork;

---------------------
-- CRUD OPERATIONS --
---------------------


-- Line:
EXEC CreateLine 
	@LineName = 'Jeffersonville Streetcar', 
	@LineColor = 'Orange';
GO

EXEC ReadLineById 
	@LineId = 3;
GO

EXEC UpdateLineById 
	@LineId = 6, 
	@LineName = 'City Parks Streetcar';
GO

EXEC DeleteLineById 
	@LineId = 1;
GO


--Stop:
EXEC CreateStop 
	@StopName = 'Big Four Bridge', 
	@StopAddress = '1101 River Rd Louisville KY 40202',
	@Latitude = 38.260639,
	@Longitude = -85.741371;
GO

EXEC ReadStopById 
	@StopId = 6;
GO

EXEC UpdateStopById 
	@StopId = 32,
	@StopName = 'Trinity Highschool'
GO

EXEC DeleteStopById
	@StopId = 85;
GO