# Louisville Rail Network

This is a database that is meant to represent a hypothetical rail network for the Louisville metro area, based on [this map](https://www.leoweekly.com/2019/06/65327/) created by Luis Huber-Calvo and published in Leo Weekly. This was completed as part of the Code Louisville Sept. 2021 SQL class.

## Installation
If using Windows, place the `LouisvilleRail` folder in your C drive root directory.

If not using Windows, or if you wish to move the project to a different folder, you will need to find and replace all instances of `C:\` with your desired location, including the ending backslash (e.g., `D:\Databases\` or `C:\users\Me\Desktop\`). In SQL Server Management Studio, the find and replace menu can be brought up by pressing CTRL+H.

Execute `LouisvilleRail_Initialization.sql` to initialize the database.

See `LouisvilleRail_Demonstration.sql` for demos.


## Database structure
```
            ┌───────────┐
┌──────┐    │LineStop   │
│Line  │    │           │    ┌────────┐
│      │    │PK: Id     │    │Stop    │
│PK: Id├───<│FK: LineId │    │        │
└──────┘    │FK: StopId │>───┤PK: Id  ├───┐
            └───────────┘    └────────┘   │
                                          │
                      ┌────────────────┐  │
                      │TripSegment     │  │
                      │                │  │
          ┌──────┐    │PK: Id          │  │
          │Trip  │    │FK: FirstStopId │>─┤
          │      │    │FK: SecondStopId│>─┘
          │PK: Id├───<│FK: TripId      │
          └──────┘    └────────────────┘
```
(Created using [asciiflow.com](https://asciiflow.com/).)

## Feature list requirements
- Group 1:
	- Write a SELECT query that uses a WHERE clause. (See any of the stored procedures that start with `Read`).
	- Write a  SELECT query that utilizes a JOIN with 3 or more tables. (See the Bonus Queries section of LouisvilleRail_Demonstration).
	- Write a  SELECT query that utilizes a LEFT JOIN. (See the Bonus Queries section of LouisvilleRail_Demonstration).
	- Write a  SELECT query that utilizes a variable in the WHERE clause. (See the Stored Procedures section of LouisvilleRail_Initialization).
	- Write a  SELECT query that utilizes an ORDER BY clause. (See the Bonus Queries section of LouisvilleRail_Demonstration).
	- Write a  SELECT query that utilizes a GROUP BY clause along with an aggregate function. (See the Bonus Queries section of LouisvilleRail_Demonstration).
	- Write a SELECT query that utilizes a CALCULATED FIELD. (See the Bonus Queries section of LouisvilleRail_Demonstration).
	- Write a SELECT query that utilizes a SUBQUERY. (See the Bonus Queries section of LouisvilleRail_Demonstration).

- Group 2: 
	- Write a DML statement that UPDATEs a set of rows with a WHERE clause. The values used in the WHERE clause should be a variable. (See any of the stored procedures that start with `Update`).
	- Write a DML statement that DELETEs a set of rows with a WHERE clause. The values used in the WHERE clause should be a variable. (See any of the stored procedures that start with `Delete`).

- Group 3: 
	- Design a NONCLUSTERED INDEX with ONE KEY COLUMN that improves the performance of one of the above queries. (See `IX_Stop_Latitude`, `IX_Stop_Longitude`, `IX_LineStop_LineId`, `IX_LineStop_StopId` and `IX_TripSegment_TripId`).