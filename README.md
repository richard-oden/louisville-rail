# Louisville Rail Network

This is a database that is meant to represent a hypothetical rail network for the Louisville metro area, based on [this map](https://www.leoweekly.com/2019/06/65327/) created by Luis Huber-Calvo and published in Leo Weekly. This was completed as part of the Code Louisville Sept. 2021 SQL class.

# Requirements met from Feature List:
- Group 1:
	- Write a SELECT query that uses a WHERE clause. (See any of the stored procedures that start with `Read`).

- Group 2: 
	- Write a DML statement that UPDATEs a set of rows with a WHERE clause. The values used in the WHERE clause should be a variable. (See any of the stored procedures that start with `Update`).
	- Write a DML statement that DELETEs a set of rows with a WHERE clause. The values used in the WHERE clause should be a variable. (See any of the stored procedures that start with `Delete`).

- Group 3: 
	- Design a NONCLUSTERED INDEX with ONE KEY COLUMN that improves the performance of one of the above queries. (See `IX_Stop_Latitude`, `IX_Stop_Longitude`, and `IX_TripSegment_TripId`).