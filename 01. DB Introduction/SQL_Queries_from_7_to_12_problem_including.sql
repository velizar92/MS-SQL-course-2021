CREATE DATABASE Test

USE Test
/******************Handling of table People*********************/

CREATE TABLE People(
	Id INT  NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Name VARCHAR(200) NOT NULL,
	Picture VARBINARY(2000),
	Height FLOAT(2),
	Weight FLOAT(2),
	Gender CHAR(1) NOT NULL,
	Birthdate DATETIME NOT NULL,
	Biography VARCHAR(MAX)
)

INSERT INTO People(Name, Picture, Height, Weight, Gender, Birthdate, Biography)
VALUES 
('Velizar', NULL, 180.32, 95.0, 'm', 19/09/1992, NULL),
('Nikolai', NULL, 182.32, 95.0, 'm', 23/09/1995, NULL),
('Zdravka', NULL, 180.32, 95.0, 'f', 19/11/1993, NULL),
('Emo', NULL, 180.32, 95.0, 'm', 19/09/1992, NULL),
('Cvetanka', NULL, 180.32, 95.0, 'f', 01/02/2000, NULL)


/*******************Handling of table Users*********************/

CREATE TABLE Users(
	Id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Username NVARCHAR(30) UNIQUE CHECK (LEN(Username) >= 3) NOT NULL,	/*Added in Problem 12 from word document*/
	Password NVARCHAR(26) NOT NULL,
	ProfilePicture VARBINARY(900),
	LastLoginTime DATETIME DEFAULT(CURRENT_TIMESTAMP),					/*CURRENT_TIMESTAMP default value is added in Problem 11*/
	IsDeleted BIT,
	/*CHECK (Password>=5)*/												/*Added in Problem 10 from word document*/
)

INSERT INTO Users(Username, Password, ProfilePicture, LastLoginTime, IsDeleted)
VALUES 
('Zaro', 'za123', NULL, 01/02/2000, 1),
('Zaro123', 'za12322', NULL, 01/02/2000, 0),
('Zaro22', 'za123R4534', NULL, 01/02/2000, 0),
('Zaro3', 'za12365656', NULL, 01/02/2000, 0),
('Zaro55', 'za12367767', NULL, 01/02/2000, 1)


/*--------------------------------Modifications in Users table------------------------*/
/*Before setting of complex primary key must be dropped the previous primary key (Id) with Management studio for now*/

ALTER TABLE Users
ADD CONSTRAINT PK_User PRIMARY KEY(Id, Username)

/*Problem 12 -> the UNIQUE CHECK for username min length is added above in the creating of Users table*/

ALTER TABLE Users
DROP CONSTRAINT PK_User; 

ALTER TABLE Users
ADD PRIMARY KEY (Id);






