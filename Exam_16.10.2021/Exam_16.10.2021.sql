-- 1 --

CREATE TABLE [Sizes]
(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[Length] INT CHECK ([Length] BETWEEN 10 AND 25) NOT NULL,
	[RingRange] DECIMAL(3,2) CHECK ([RingRange] BETWEEN 1.5 AND 7.5) NOT NULL
)

CREATE TABLE [Tastes]
(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[TasteType] VARCHAR(20) NOT NULL,
	[TasteStrength] VARCHAR(15) NOT NULL,
	[ImageURL] NVARCHAR(100) NOT NULL
)

CREATE TABLE [Brands]
(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[BrandName] VARCHAR(30) UNIQUE NOT NULL,
	[BrandDescription] VARCHAR(MAX)
)

CREATE TABLE [Cigars]
(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[CigarName] VARCHAR(80) NOT NULL,
	[BrandId] INT FOREIGN KEY REFERENCES [Brands]([Id]) NOT NULL,
	[TastId] INT FOREIGN KEY REFERENCES [Tastes]([Id]) NOT NULL,
	[SizeId] INT FOREIGN KEY REFERENCES [Sizes]([Id]) NOT NULL,
	[PriceForSingleCigar] MONEY NOT NULL,
	[ImageURL] NVARCHAR(100) NOT NULL
)

CREATE TABLE [Addresses]
(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[Town] VARCHAR(30) NOT NULL,
	[Country] NVARCHAR(30) NOT NULL,
	[Streat] NVARCHAR(100) NOT NULL,
	[ZIP] VARCHAR(20) NOT NULL
)

CREATE TABLE [Clients]
(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[FirstName] NVARCHAR(30) NOT NULL,
	[LastName] NVARCHAR(30) NOT NULL,
	[Email] NVARCHAR(50) NOT NULL,
	[AddressId] INT FOREIGN KEY REFERENCES [Addresses]([Id]) NOT NULL
)

CREATE TABLE [ClientsCigars]
(
	[ClientId] INT FOREIGN KEY REFERENCES [Clients]([Id]) NOT NULL,
	[CigarId] INT FOREIGN KEY REFERENCES [Cigars]([Id]) NOT NULL
	PRIMARY KEY([ClientId], [CigarId])
)


-- 2 --
INSERT INTO Cigars(CigarName, BrandId, TastId, SizeId, PriceForSingleCigar, ImageURL)
VALUES
('COHIBA ROBUSTO', 9, 1, 5, 15.50, 'cohiba-robusto-stick_18.jpg'),
('COHIBA SIGLO I', 9, 1, 10, 410.00, 'cohiba-siglo-i-stick_12.jpg'),
('HOYO DE MONTERREY LE HOYO DU MAIRE', 14, 5, 11, 7.50, 'hoyo-du-maire-stick_17.jpg'),
('HOYO DE MONTERREY LE HOYO DE SAN JUAN', 14, 4, 15, 32.00, 'hoyo-de-san-juan-stick_20.jpg'),
('TRINIDAD COLONIALES', 2, 3, 8, 85.21, 'trinidad-coloniales-stick_30.jpg')


INSERT INTO Addresses(Town, Country, Streat, ZIP)
VALUES
('Sofia', 'Bulgaria', '18 Bul. Vasil levski', 1000),
('Athens', 'Greece', '4342 McDonald Avenue', 10435),
('Zagreb', 'Croatia', '4333 Lauren Drive', 10000)


-- 3 --

UPDATE Cigars
SET [PriceForSingleCigar] *= 1.20
WHERE [TastId]
	IN (SELECT [Id] FROM Tastes WHERE [TasteType] = 'Spicy')

UPDATE Brands
SET [BrandDescription] = 'New description'
WHERE [BrandDescription] IS NULL


-- 4 --

DELETE FROM Clients WHERE [AddressId] IN 
	(SELECT [Id] FROM Addresses WHERE [Country] LIKE 'C%')

DELETE FROM Addresses WHERE [Country] LIKE 'c%'


-- 5 --

SELECT 
	[CigarName],
	[PriceForSingleCigar],
	[ImageURL]
FROM Cigars
ORDER BY [PriceForSingleCigar] ASC, [CigarName] DESC


-- 6 --

SELECT  c.[Id], 
		c.[CigarName],
		c.[PriceForSingleCigar],
		t.[TasteType],
		t.[TasteStrength]
	FROM Cigars AS c
	LEFT JOIN Tastes AS t
	ON C.[TastId] = t.Id
	WHERE t.[TasteType] = 'Earthy' OR t.[TasteType] = 'Woody'
	ORDER BY [PriceForSingleCigar] DESC


-- 7 --

SELECT 
	c.[Id],
	CONCAT(c.[FirstName], ' ', c.[LastName]) AS [ClientName],
	[Email]
FROM 
	Clients AS c
	LEFT JOIN ClientsCigars as cc
	ON c.[Id] = cc.[ClientId]
	WHERE [CigarId] IS NULL
	ORDER BY [ClientName]

-- 8 --

SELECT TOP(5)
  		[CigarName],
		[PriceForSingleCigar],
		[ImageURL]
	FROM Cigars AS c
	JOIN Sizes AS s
	ON s.[Id] = c.[SizeId]
WHERE s.[Length] >= 12 AND (c.[CigarName] LIKE '%ci%' OR c.[PriceForSingleCigar] > 50) AND s.[RingRange] > 2.55
ORDER BY [CigarName], [PriceForSingleCigar] DESC


-- 9 --

SELECT 
	CONCAT([FirstName], ' ', [LastName]) AS [FullName],
	[Country],
	[ZIP],
	CONCAT('$', MAX([PriceForSingleCigar])) AS [CigarPrice]
FROM Clients AS c
JOIN Addresses AS a
ON c.[AddressId] = a.[Id]
JOIN ClientsCigars cc
ON cc.[ClientId] = c.[Id]
JOIN Cigars AS cg
ON cc.[CigarId] = cg.[Id]
WHERE ZIP NOT LIKE '%[^0-9]%'
GROUP BY c.[Id], c.[FirstName], c.[LastName], a.[Country], a.[ZIP]
ORDER BY [FullName]


-- 10 --

SELECT 
	[LastName],
	AVG([Length]) AS [CiagrLength],
	CEILING(AVG([RingRange])) AS [CiagrRingRange]
FROM Clients AS c
 JOIN ClientsCigars cc
ON c.Id = cc.ClientId
 JOIN Cigars AS cgr
ON cc.CigarId = cgr.Id
 JOIN Sizes AS s
ON cgr.SizeId = s.Id
GROUP BY [LastName]
ORDER BY [CiagrLength] DESC


-- 11 --
GO

CREATE FUNCTION udf_ClientWithCigars(@name NVARCHAR(30))
RETURNS INT AS
BEGIN
	
	RETURN 
		(SELECT COUNT(cc.CigarId) FROM Clients AS c
		LEFT JOIN ClientsCigars AS cc
		ON c.Id = cc.ClientId
		WHERE c.FirstName = @name)
		
	   
END

GO

-- 12 --

CREATE PROC usp_SearchByTaste(@taste VARCHAR(20))
AS
BEGIN
	SELECT 
		[CigarName],	
		CONCAT('$', [PriceForSingleCigar]) AS [Price],
		[TasteType],
		[BrandName],
		CONCAT(s.[Length], ' ', 'cm') AS [CigarLength],
		CONCAT(s.[RingRange], ' ', 'cm') AS [CigarRingRange]
 	FROM Cigars AS c
	LEFT JOIN Tastes AS t
	ON c.TastId = t.Id
	LEFT JOIN Brands AS b
	ON c.BrandId = b.Id
	LEFT JOIN Sizes AS s
	ON c.SizeId = s.Id
	WHERE TasteType = @taste
	ORDER BY CigarLength, CigarRingRange DESC

END
