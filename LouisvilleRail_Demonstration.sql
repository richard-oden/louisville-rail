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


-- LineStop:
EXEC CreateLineStop
	@LineId = 3,
	@StopId = 11,
	@LineStopOrder = 23;
GO

EXEC ReadLineStopById
	@LineStopId = 109;
GO

EXEC UpdateLineStopById
	@LineStopId = 49,
	@LineId = 4,
	@LineStopOrder = 21;
GO

EXEC DeleteLineStopById
	@LineStopId = 21;
GO


-- Trip:
EXEC CreateTrip
	@StartDateTime = '2021/11/09 5:59:30',
	@EndDateTime = '2021/11/09 8:00:00'
GO

EXEC ReadTripById
	@TripId = 1;
GO

EXEC UpdateTripById
	@TripId = 2,
	@StartDateTime = '2021/11/03 19:01:00'
GO

EXEC DeleteTripById
	@TripId = 3;
GO

-- TripSegment:
EXEC CreateTripSegment
	@TripId = 3,
	@FirstStopId = 84,
	@SecondStopId = 43,
	@StartDateTime = '2021-11-04 7:31:20',
	@EndDateTime = '2021-11-04 7:32:22';
GO

EXEC ReadTripSegmentById
	@TripSegmentId = 7;
GO

EXEC UpdateTripSegmentById
	@TripSegmentId = 10,
	@StartDateTime = '2021/11/03 19:01:00';
GO

EXEC DeleteTripSegmentById
	@TripSegmentId = 35;
GO