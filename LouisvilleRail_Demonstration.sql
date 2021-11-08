USE LouisvilleRailNetwork;

---------------------
-- CRUD OPERATIONS --
---------------------

EXEC CreateLine @LineName = 'Jeffersonville Streetcar', @LineColor = 'Orange';
GO

EXEC ReadLineById @LineId = 3;
GO

EXEC UpdateLineById @LineId = 6, @LineName = 'City Parks Streetcar';
GO

EXEC DeleteLineById @LineId = 1;
GO