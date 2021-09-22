CREATE DATABASE Movies

/*On this step must be selected the Movies database from the dropdown menu is SQL Management studio*/

CREATE TABLE Directors(
	Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	DirectorName VARCHAR(100) NOT NULL,
	Notes VARCHAR(MAX)
)

INSERT INTO Directors(DirectorName, Notes)
VALUES
('Alexander', NULL),
('Georgi', 'Some note 1'),
('Velizar', NULL),
('Yanko', NULL),
('Dimitar', 'Some note 2')


CREATE TABLE Genres(
	Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	GenreName VARCHAR(100) NOT NULL,
	Notes VARCHAR(MAX)
)

INSERT INTO Genres(GenreName, Notes)
VALUES
('Fantastic', NULL),
('Thriller', 'Some note 1'),
('Comedy', NULL),
('Mystery', NULL),
('Historic', 'Some other note')



CREATE TABLE Categories(
	Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	CategoryName VARCHAR(100) NOT NULL,
	Notes VARCHAR(MAX)
)

INSERT INTO Categories(CategoryName, Notes)
VALUES
('Romance', NULL),
('Horror', 'Some note 1'),
('Drama', NULL),
('Psychological Thriller', NULL),
('Techno Thriller', 'Some other note')


CREATE TABLE Movies(
	Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	Title VARCHAR(250) NOT NULL,
	DirectorId INT,
	CopyrightYear SMALLINT,
	Length FLOAT(2),
	GenreId INT,
	CategoryId INT,
	Rating FLOAT(1),
	Notes VARCHAR(MAX)
)

INSERT INTO Movies(Title, DirectorId, CopyrightYear, Length, GenreId, CategoryId, Rating, Notes)
VALUES
('Ironman', 1, 2008, 120.2, 1, 2, 100.00, 'Some note for Ironman' ),
('The Lord Of Rings', 1, 2002, 180.2, 1, 3, 100.00, 'Some note for The Lord Of Rings' ),
('Spiderman', 2, 2005, 99.2, 1, 4, 95.00, 'Some note for Spiderman' ),
('The Guilty', 3, 2021, 120.2, 2, 3, 100.00, NULL),
('Superman', 5, 2008, 80.1, 1, 5, 60.00, NULL)

