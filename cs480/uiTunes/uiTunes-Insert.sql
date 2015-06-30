DELETE FROM AlbumDetails
DELETE FROM Albums
DELETE FROM Artists
DELETE FROM Genres
DELETE FROM PlaylistDetails
DELETE FROM Playlists
DELETE FROM PurchaseDetails
DELETE FROM Purchases
DELETE FROM PurchaseTypes
DELETE FROM ReviewDetails
DELETE FROM Reviews
DELETE FROM SongDetails
DELETE FROM Songs
DELETE FROM Users

Insert into Users(FirstName, LastName, Email, Passwd, AccountBal) Values ('John', 'Doe', 'jdoe@gmail.com', '12345', 99.99);
Insert into Users(FirstName, LastName, Email, Passwd, AccountBal) Values ('Jane', 'Doe', 'janed@hotmail.com', '54321', 40.00);

Insert into Albums(AlbumName, AlbumYearRel, AlbumPrice) Values ('One', 2013, 9.99);
Insert into Albums(AlbumName, AlbumYearRel, AlbumPrice) Values ('Two', 2013, 9.99);
Insert into Albums(AlbumName, AlbumYearRel, AlbumPrice) Values ('Three', 2014, 9.99);
Insert into Albums(AlbumName, AlbumYearRel, AlbumPrice) Values ('Four', 1971, 9.99);
Insert into Albums(AlbumName, AlbumYearRel, AlbumPrice) Values ('Five', 2013, 9.99);
Insert into Albums(AlbumName, AlbumYearRel, AlbumPrice) Values ('Stix', 2012, 9.99);

Insert into Artists(ArtistName, YearBorn) Values('Katy Perry', 0);
Insert into Artists(ArtistName, YearBorn) Values('Pitbull', 0);
Insert into Artists(ArtistName, YearBorn) Values('Ke$ha', 0);
Insert into Artists(ArtistName, YearBorn) Values('Kenny Chesney', 0);
Insert into Artists(ArtistName, YearBorn) Values('Grace Potter', 0);
Insert into Artists(ArtistName, YearBorn) Values('Led Zeppelin', 0);
Insert into Artists(ArtistName, YearBorn) Values('Joss Stone', 0);
Insert into Artists(ArtistName, YearBorn) Values('Melissa Etheridge', 0);

Insert into Genres(Genre) Values('Pop');
Insert into Genres(Genre) Values('Rock');
Insert into Genres(Genre) Values('Country');

--Insert into Playlists(UserID, PlaylistName) Values (1, 'Rockin Robin');
--Insert into Playlists(PlaylistName) Values ('Wishing Bone');
--Insert into Playlists(PlaylistName) Values ('Yes and Yes');
--Insert into Playlists(PlaylistName) Values ('George Bush vs. The World');
--Insert into Playlists(PlaylistName) Values ('Humming Bird Blues');

Insert into PurchaseTypes(PurchaseType) Values (1);
Insert into PurchaseTypes(PurchaseType) Values (2);

--Insert into Purchases(UserID, AmountPaid, PurchaseDate) Values (1, 49.99, '20020101');
--Insert into Purchases(UserID, AmountPaid, PurchaseDate) Values (2, 0.99, '20140307');

--Insert into PurchaseDetails(UserID, PurchaseID) Values (1, 1);
--Insert into PurchaseDetails(UserID, PurchaseID) Values (1, 1);

Insert into Reviews(Rating, Comment) Values (5, 'Excellent!'); --TODO add userID
Insert into Reviews(Rating, Comment) Values (2, 'Meh..'); --TODO add userID

Insert into Songs(SongName, SongYearRel, Duration, SongPrice) 
 Values('Roar', 2013, '00:04:30', 0.99);
Insert into Songs(SongName, SongYearRel, Duration, SongPrice)
 Values('Timber', 2013, '00:03:34', 0.99);
Insert into Songs(SongName, SongYearRel, Duration, SongPrice) 
 Values('Wild Child', 2014, '00:03:39', 0.99);
Insert into Songs(SongName, SongYearRel, Duration, SongPrice) 
 Values('Stairway To Heaven', 1971, '00:07:59', 1.99);
Insert into Songs(SongName, SongYearRel, Duration, SongPrice) 
 Values('Cry Baby and Piece Of My Heart Janis Joplin Tribute', 2013, '00:05:40', 0.99);
Insert into Songs(SongName, SongYearRel, Duration, SongPrice)
 Values('Back In Time', 2012, '00:03:26', 0.99);

--Insert into AlbumDetails(AlbumID, SongID) Values(1,1);
--Insert into AlbumDetails(AlbumID, SongID) Values(2,2);
--Insert into AlbumDetails(AlbumID, SongID) Values(3,3);
--Insert into AlbumDetails(AlbumID, SongID) Values(4,4);
--Insert into AlbumDetails(AlbumID, SongID) Values(5,5);
--Insert into AlbumDetails(AlbumID, SongID) Values(6,6);

--Insert into SongDetails(SongID, ArtistID, ArtistRole) Values (1, 1, 1);
--Insert into SongDetails(SongID, ArtistID, ArtistRole) Values (2, 2, 2);
--Insert into SongDetails(SongID, ArtistID, ArtistRole) Values (3, 3, 2);
--Insert into SongDetails(SongID, ArtistID, ArtistRole) Values (4, 4, 1);
--Insert into SongDetails(SongID, ArtistID, ArtistRole) Values (5, 5, 1);
--Insert into SongDetails(SongID, ArtistID, ArtistRole) Values (6, 6, 1);

--Insert into PlaylistDetails(PlaylistID, UserID, SongID) Values (1, 1, 3);
--Insert into PlaylistDetails(PlaylistID, UserID, SongID) Values (1, 1, 2);
--Insert into PlaylistDetails(PlaylistID, UserID, SongID) Values (1, 1, 6);
--Insert into PlaylistDetails(PlaylistID, UserID, SongID) Values (2, 2, 4);
--Insert into PlaylistDetails(PlaylistID, UserID, SongID) Values (2, 2, 6);
--Insert into PlaylistDetails(PlaylistID, UserID, SongID) Values (2, 2, 1);
--Insert into PlaylistDetails(PlaylistID, UserID, SongID) Values (2, 2, 2);