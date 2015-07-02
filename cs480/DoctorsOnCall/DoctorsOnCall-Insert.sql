--
-- NOTE: to repopulate the DB, you have to re-create the tables first.
-- Some of the inserts depend on the primary keys restarting at 1.
--

Insert into Doctors(FirstName, LastName, Beeper)
             Values('Beth', 'Smith', 6295);
Insert into Doctors(FirstName, LastName, Beeper)
             Values('Cassing', 'Jones', 5518);
Insert into Doctors(FirstName, LastName, Beeper)
             Values('Cate', 'Johnson', 6298);
Insert into Doctors(FirstName, LastName, Beeper)
             Values('Pooja', 'Sankar', 5215);
Insert into Doctors(FirstName, LastName, Beeper)
             Values('Drago', 'Smith', 6296);
Insert into Doctors(FirstName, LastName, Beeper)
             Values('Jim', 'Bag', 4400);
Insert into Doctors(FirstName, LastName, Beeper)
             Values('Kathie', 'O''Dahl', 9999);
             
Insert into Working(DocID, Night) Values(1, '2015-12-24');
Insert into Working(DocID, Night) Values(1, '2015-12-25');
Insert into Working(DocID, Night) Values(1, '2015-12-26');
Insert into Working(DocID, Night) Values(2, '2015-07-02');
Insert into Working(DocID, Night) Values(3, '2015-07-03');
Insert into Working(DocID, Night) Values(4, '2015-07-05');
Insert into Working(DocID, Night) Values(1, '2015-07-06');
Insert into Working(DocID, Night) Values(2, '2015-07-07');
Insert into Working(DocID, Night) Values(3, '2015-07-08');
Insert into Working(DocID, Night) Values(4, '2015-07-09');
Insert into Working(DocID, Night) Values(1, '2015-07-10');
Insert into Working(DocID, Night) Values(1, '2015-07-11');
Insert into Working(DocID, Night) Values(3, '2015-07-12');
Insert into Working(DocID, Night) Values(4, '2015-07-13');
Insert into Working(DocID, Night) Values(4, '2015-07-14');
Insert into Working(DocID, Night) Values(1, '2015-07-15');

Insert into Vacation(DocID, DayOff) Values(1, '2015-07-04');
Insert into Vacation(DocID, DayOff) Values(3, '2015-07-04');
Insert into Vacation(DocID, DayOff) Values(5, '2015-07-04');
