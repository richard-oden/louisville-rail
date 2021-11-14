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
--(I recommend executing LouisvilleRail_Initialization again before running these.)
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
--(I recommend executing LouisvilleRail_Initialization again before running these.)
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
--(I recommend executing LouisvilleRail_Initialization again before running these.)
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

---------------------
--- BONUS QUERIES ---
---------------------
--(I recommend executing LouisvilleRail_Initialization again before running these.)

-- Get all stops on the Olmsted Streetcar line
SELECT
	s.[Name],
	s.[Address]
FROM [Stop] s
	LEFT JOIN LineStop ls ON s.Id = ls.StopId
	LEFT JOIN Line l ON ls.LineId = l.Id
WHERE l.Id = 6
ORDER BY ls.LineStopOrder;
GO

-- Get all stops with connections to other lines
SELECT
	s.[Name],
	s.[Address],
	COUNT(DISTINCT ls.LineId) as [Number of Connections]
FROM [Stop] s
	LEFT JOIN LineStop ls ON s.Id = ls.StopId
	LEFT JOIN Line l ON ls.LineId = l.Id
GROUP BY ls.StopId, s.[Name], s.[Address]
HAVING COUNT(DISTINCT ls.LineId) > 1
ORDER BY s.[Name];
GO

-- Get the 5 closest stops to Van Dyke Park, in Jeffersonville
DECLARE @myLat decimal(8,6)
DECLARE @myLon decimal(9,6)
SET @myLat = 38.267969591380144
SET @myLon = -85.74217083299392

SELECT TOP 5
	[Name],
	[Address],
	(SELECT [dbo].GetFormattedDistanceInFeet(@myLat, @myLon, Latitude, Longitude)) as Distance
FROM [Stop]
ORDER BY (SELECT [dbo].GetDistanceInFeet(@myLat, @myLon, Latitude, Longitude));
GO

-- Get average duration of trips
SELECT
	AVG(DATEDIFF(minute, StartDateTime, EndDateTime)) as [Average Trip Duration in Minutes]
FROM Trip;
GO
