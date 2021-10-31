-- 1 --
CREATE TABLE Users(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[Username] VARCHAR(30) UNIQUE NOT NULL,
	[Password] VARCHAR(50) NOT NULL,
	[Name] VARCHAR(50),
	[Birthdate] DATETIME,
	[Age] INT,
	[Email] VARCHAR(50) NOT NULL,

	CHECK([Age] > 14 AND [Age] <= 110)
)

CREATE TABLE Departments(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Employees(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[FirstName] VARCHAR(25),
	[LastName] VARCHAR(25),
	[Birthdate] DATETIME,
	[Age] INT,
	[DepartmentId] INT 
	FOREIGN KEY REFERENCES Departments([Id]),

	CHECK([Age] > 18 AND [Age] <= 110)
)

CREATE TABLE Categories(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[DepartmentId] INT FOREIGN KEY
	REFERENCES Departments([Id]) NOT NULL
)


CREATE TABLE Status(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[Label] VARCHAR(30) NOT NULL
)


CREATE TABLE Reports(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[CategoryId] INT FOREIGN KEY 
	REFERENCES Categories([Id]) NOT NULL,
	[StatusId] INT FOREIGN KEY
	REFERENCES Status([Id]) NOT NULL,
	[OpenDate] DATETIME NOT NULL,
	[CloseDate] DATETIME,
	[Description] VARCHAR(200) NOT NULL,
	[UserId] INT FOREIGN KEY 
	REFERENCES Users([Id]) NOT NULL,
	[EmployeeId] INT FOREIGN KEY 
	REFERENCES Employees([Id])
)


-- 2 --
INSERT INTO Employees(FirstName, LastName, Birthdate, DepartmentId)
VALUES
('Marlo', 'O''Malley', '1958-9-21', 1),
('Niki', 'Stanaghan', '1969-11-26', 4),
('Ayrton', 'Senna', '1960-03-21', 9),
('Ronnie', 'Peterson', '1944-02-14', 9),
('Giovanna', 'Amati', '1959-07-20', 5)


INSERT INTO Reports(CategoryId, StatusId, OpenDate, CloseDate, Description, UserId, EmployeeId)
VALUES
(1, 1, '2017-04-13', ' ', 'Stuck Road on Str.133', 6, 2),
(6, 3, '2015-09-05', '2015-12-06', 'Charity trail running', 3, 5),
(14, 2, '2015-09-07', ' ', 'Falling bricks on Str.58', 5, 2),
(4, 3, '2017-07-03', '2017-07-06', 'Cut off streetlight on Str.11', 1, 1)



-- 3 --
UPDATE Reports
SET CloseDate = GETDATE()
WHERE CloseDate IS NULL


-- 4 --
DELETE FROM Reports
WHERE StatusId = 4


-- 5 --
SELECT [Description], 
		CONVERT(varchar, OpenDate, 105)
FROM Reports AS r
LEFT JOIN Employees AS e
ON r.EmployeeId = e.Id
WHERE EmployeeId IS NULL
ORDER BY [OpenDate],[Description] ASC

-- 6 --
SELECT r.Description,
	c.[Name] AS [CategoryName]
FROM Reports AS r
JOIN Categories AS c
ON r.CategoryId = c.Id
ORDER BY r.[Description] ASC, c.[Name] ASC


-- 7 --
SELECT TOP(5) c.[Name] AS [CategoryName],
		COUNT(r.CategoryId) AS [ReportsNumber]
FROM Categories AS c
JOIN Reports AS r
ON r.CategoryId = c.Id
GROUP BY c.Id, c.[Name]
ORDER BY COUNT(r.CategoryId) DESC, c.[Name] ASC

-- 8 --
SELECT Username, c.Name AS [CategoryName]
FROM Reports AS r
JOIN Users AS u
ON r.UserId = u.Id
JOIN Categories AS c
ON r.CategoryId = c.Id
WHERE FORMAT(r.OpenDate,'dd-MM') = FORMAT(u.Birthdate,'dd-MM') 
ORDER BY u.[Username] ASC, c.[Name] ASC


-- 9 --
SELECT 
	CONCAT(e.FirstName, ' ', e.LastName) AS FullName, 
	COUNT(u.Id) AS UsersCount
 FROM
Employees AS e
 LEFT JOIN Reports AS r
ON r.EmployeeId = e.Id
 LEFT JOIN Users AS u
ON r.UserId = u.Id
GROUP BY e.Id, e.FirstName, e.LastName
ORDER BY UsersCount DESC, FullName

-- 10 --
SELECT 
	CASE
		WHEN CONCAT(e.FirstName, ' ', e.LastName) IS NULL THEN 'None'
		WHEN CONCAT(e.FirstName, ' ', e.LastName) = '' THEN 'None'
		WHEN CONCAT(e.FirstName, ' ', e.LastName) = ' ' THEN 'None'
		ELSE CONCAT(e.FirstName, ' ', e.LastName)  
	END AS Employee,
	ISNULL(d.[Name], 'None') AS [Department],
	c.[Name] AS [Category],
	r.[Description],
	FORMAT(r.OpenDate, 'dd.MM.yyyy'),
	s.[Label] AS [Status],
	ISNULL(u.[Name], 'None') AS [User]
FROM Reports AS r
LEFT JOIN Employees AS e ON r.EmployeeId = e.Id
LEFT JOIN Departments AS d ON e.DepartmentId = d.Id
LEFT JOIN Categories AS c ON r.CategoryId = c.Id
LEFT JOIN [Status] AS s ON r.StatusId = s.Id
LEFT JOIN Users AS u ON r.UserId = u.Id
ORDER BY e.FirstName DESC, e.LastName DESC, d.[Name], c.[Name], r.[Description], r.OpenDate, s.[Label], u.[Name]


GO 

-- 11 --
CREATE FUNCTION udf_HoursToComplete(@StartDate DATETIME, @EndDate DATETIME)
RETURNS INT AS
BEGIN
	IF(@StartDate IS NULL) RETURN 0

	ELSE IF(@EndDate IS NULL) RETURN 0

	RETURN DATEDIFF(HOUR, @StartDate, @EndDate)
END

GO


-- 12 --
CREATE PROC usp_AssignEmployeeToReport(@EmployeeId INT, @ReportId INT)
AS
BEGIN

IF(
	(SELECT DepartmentId FROM Employees WHERE Id = @EmployeeId)
	!=
	(SELECT DepartmentId FROM Categories WHERE Id IN (SELECT CategoryId FROM Reports WHERE Id = @ReportId))
)

BEGIN
	THROW 50001, 'Employee doesn''t belong to the appropriate department!', 1;
END

UPDATE [Reports]
SET [EmployeeId] = @EmployeeId
WHERE Id = @ReportId

END
