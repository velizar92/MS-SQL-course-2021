CREATE TABLE Students(
	[StudentID] INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(100)
)

CREATE TABLE Exams(
	[ExamID] INT PRIMARY KEY IDENTITY(101,1) NOT NULL,
	[Name] VARCHAR(100)
)

CREATE TABLE StudentsExams(
	[StudentID] INT,
	[ExamID] INT,
	PRIMARY KEY([StudentID], [ExamID]),
	FOREIGN KEY([StudentID]) REFERENCES Students([StudentID]),
	FOREIGN KEY([ExamID]) REFERENCES Exams([ExamID]),
)

INSERT INTO Students
VALUES
('Mila'),
('Toni'),
('Ron')


INSERT INTO Exams
VALUES
('SpringMVC'),
('Neo4j'),
('Oracle 11g')


INSERT INTO StudentsExams
VALUES
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103)
