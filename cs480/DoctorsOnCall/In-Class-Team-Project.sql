--1.
SELECT COUNT(DocID) as TotalDoctors FROM Doctors;

--2.
SELECT FirstName, LastName, ISNULL(numDays, 0) AS NumberDaysWorking FROM Doctors
	LEFT JOIN(
	SELECT DocID, COUNT(DocID) as numDays FROM Working
	GROUP BY DocID
	) T
ON Doctors.DocID = T.DocID
ORDER BY LastName, FirstName ASC;

--3.
SELECT FirstName, LastName FROM Doctors
	INNER JOIN(
	SELECT DocID FROM Working WHERE Night = '20151225'
	) T
ON Doctors.DocID = T.DocID;

--4.
SELECT FirstName, LastName FROM Doctors
	INNER JOIN(
	SELECT DocID FROM Vacation WHERE DayOff = '20150704'
	) T
ON Doctors.DocID = T.DocID;

--5.
--option 1
--??

--option 2
SELECT Distinct FirstName, LastName FROM Doctors
	LEFT JOIN(
	SELECT DocID FROM Vacation WHERE DayOff = '20150704'
	) T
ON Doctors.DocID = T.DocID
WHERE T.DocID IS NULL
ORDER BY LastName ASC, FirstName ASC;