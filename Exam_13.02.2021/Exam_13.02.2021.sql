-- 1 --

CREATE TABLE Users(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[Username] VARCHAR(30) NOT NULL,
	[Password] VARCHAR(30) NOT NULL,
	[Email] VARCHAR(50) NOT NULL
)

CREATE TABLE Repositories(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE RepositoriesContributors(
	RepositoryId INT NOT NULL,
	ContributorId INT  NOT NULL,

	PRIMARY KEY (RepositoryId, ContributorId),

	FOREIGN KEY (RepositoryId) REFERENCES Repositories([Id]) ,
	FOREIGN KEY (ContributorId) REFERENCES Users([Id])
)

CREATE TABLE Issues(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[Title] VARCHAR(255) NOT NULL,
	[IssueStatus] CHAR(6) NOT NULL,
	[RepositoryId] INT FOREIGN KEY REFERENCES Repositories([Id]) NOT NULL,
	[AssigneeId] INT FOREIGN KEY REFERENCES Users([Id]) NOT NULL
)

CREATE TABLE Commits(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[Message] VARCHAR(255) NOT NULL,
	[IssueId] INT FOREIGN KEY REFERENCES Issues([Id]),
	[RepositoryId] INT FOREIGN KEY REFERENCES Repositories([Id]) NOT NULL,
	[ContributorId] INT FOREIGN KEY REFERENCES Users([Id]) NOT NULL
)

CREATE TABLE Files(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	[Size] DECIMAL(18,2) NOT NULL,
	[ParentId] INT FOREIGN KEY REFERENCES Files([Id]),
	[CommitId] INT FOREIGN KEY REFERENCES Commits([Id])
)


-- 2 --
INSERT INTO Files(Name, Size, ParentId, CommitId)
VALUES
('Trade.idk', 2598.0, 1, 1),
('menu.net', 9238.31, 2, 2),
('Administrate.soshy', 1246.93, 3, 3),
('Controller.php', 7353.15, 4, 4),
('Find.java', 9957.86, 5, 5),
('Controller.json', 14034.87, 3, 6),
('Operate.xix', 7662.92, 7, 7)


INSERT INTO Issues(Title, IssueStatus, RepositoryId, AssigneeId)
VALUES
('Critical Problem with HomeController.cs file', 'open', 1, 4),
('Typo fix in Judge.html', 'open', 4, 3),
('Implement documentation for UsersService.cs', 'closed', 8, 2),
('Unreachable code in Index.cs', 'open', 9, 8)


-- 3 --
UPDATE Issues
SET IssueStatus = 'closed' 
WHERE AssigneeId = 6

-- 4 --
DELETE FROM [RepositoriesContributors] WHERE [RepositoryId] IN (SELECT [Id] FROM [Repositories] WHERE [Name] = 'Softuni-Teamwork')
DELETE FROM [Issues] WHERE [RepositoryId] IN (SELECT [Id] FROM [Repositories] WHERE [Name] = 'Softuni-Teamwork')
  
  
-- 5 --
SELECT Id,
	Message, RepositoryId, ContributorId
FROM
Commits
ORDER BY Id ASC, Message ASC, RepositoryId ASC, ContributorId ASC

-- 6 --
SELECT 
	Id, Name, Size
FROM Files
WHERE Size > 1000 AND Name LIKE '%html%'
ORDER BY Size DESC, Id ASC, Name ASC


-- 7 --
SELECT i.Id,
	CONCAT(Username, ' : ', I.Title) AS [IssueAssignee]
FROM Issues AS i
LEFT JOIN Users AS u
ON i.AssigneeId = u.Id
ORDER BY I.Id DESC, IssueAssignee ASC


-- 8 --
SELECT 
	Id, [Name], CONCAT(Size, 'KB') AS Size
FROM Files 
WHERE ParentId IS NOT NULL
ORDER BY Id, [Name], Size DESC


-- 9 --

SELECT  TOP(5)
r.Id, r.Name, count(c.ContributorId) AS Commits
FROM Repositories as r
LEFT JOIN Commits as c
ON r.Id = c.RepositoryId
LEFT JOIN RepositoriesContributors AS rc
ON r.Id = rc.RepositoryId
LEFT JOIN Users AS u
ON rc.ContributorId = u.Id
GROUP BY r.Id, r.Name
ORDER BY Commits DESC, r.Id ASC, r.Name ASC


-- 10 --

SELECT u.Username,
	AVG(f.Size) AS Size
FROM Users AS u
JOIN Commits AS c
ON u.Id = c.ContributorId
JOIN Files AS f
ON c.Id = f.CommitId
GROUP BY u.Username
ORDER BY Size DESC, u.Username ASC


-- 11 --
GO

CREATE FUNCTION udf_AllUserCommits(@username VARCHAR(30))
RETURNS INT AS
BEGIN
	
	RETURN 
	    (SELECT COUNT(u.Id)
		FROM Commits as c
		LEFT JOIN Users as u
		ON c.ContributorId = u.Id
		WHERE u.Username = @username)
END


GO

-- 12 --
CREATE PROC usp_SearchForFiles(@fileExtension VARCHAR(10))
AS
BEGIN

	SELECT Id, [Name], CONCAT(Size, 'KB') as Size
	FROM Files
	WHERE [Name] LIKE '%.%' + @fileExtension
	ORDER BY Id, [Name], Size DESC

END







