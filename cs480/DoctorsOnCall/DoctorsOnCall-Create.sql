DROP TABLE Vacation;
DROP TABLE Working;
DROP TABLE Doctors;

CREATE TABLE Doctors (
   DocID      INT IDENTITY(1,1) PRIMARY KEY,  
   FirstName  NVARCHAR(64) NOT NULL,         
   LastName   NVARCHAR(64) NOT NULL,
   Beeper     INT NOT NULL
);

CREATE TABLE Working (
   DocID        INT NOT NULL FOREIGN KEY REFERENCES Doctors(DocID),
   Night        DATE NOT NULL,
   PRIMARY KEY  (DocID, Night)
);

CREATE TABLE Vacation (
   DocID        INT NOT NULL FOREIGN KEY REFERENCES Doctors(DocID),
   DayOff       DATE NOT NULL,
   PRIMARY KEY  (DocID, DayOff)
);
