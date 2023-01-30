DROP DATABASE IF EXISTS SPOTIFY;

CREATE DATABASE IF NOT EXISTS SPOTIFY;

USE SPOTIFY;

DROP TABLE IF EXISTS 
USER, SONG, ARTIST, ALBUM, PLAYLIST, GENRE,
FOLLOWER,
PLAYLIST_SONG, ALBUM_SONG,
SONG_LIKED, ALBUM_LIKED, PLAYLIST_LIKED,
SONG_GENRE;

CREATE TABLE
USER
(
    ULogin         INT PRIMARY KEY AUTO_INCREMENT,
    Name           VARCHAR(64) NOT NULL,
    Joined         DATE NOT NULL,
    BirthDate      DATE NOT NULL,
    Sex            ENUM('M','F','O') NOT NULL,
    Email          VARCHAR(64) NOT NULL,
    Phone          INT DEFAULT NULL
);

INSERT INTO USER(Name, Joined, BirthDate, Sex, Email, Phone)
VALUES  
('Tomás Ferreira', '2021-11-15', '2002-11-15', 'M', 'up202004447@edu.fc.up.pt', 913683606), 
('André Gomes', '2021-10-10', '2002-10-10', 'M', '1201108@isep.ipp.pt', 915816621), 
('Diogo Ribeiro', '2021-02-23', '1999-04-05', 'M', 'up201707434@edu.fc.up.pt', 960411551), 
('Daniela Coelho', '2021-02-23', '2001-09-01', 'F', 'up201707434@edu.fc.up.pt', 960411551), 
('João Azevedo', '2021-02-23', '2003-03-28', 'M', 'up202008367@edu.fc.up.pt', 910858797), 
('Manuela Santos', '2021-03-02', '1974-05-05', 'F', 'mariamanuela@email.com', NULL), 
('Rui Malheiro', '2021-09-02', '1980-05-22', 'M', 'ruimalheiro123@email.come', NULL), 
('Antonio Ribeiro', '2020-06-21', '2005-04-03', 'O', 'tonyrib@email.com', 910010011), 
('Linda Rocha', '2021-01-01', '1994-11-14', 'F', 'lindarocha@email.com', 911222333), 
('Abundio Só', '2020-02-21', '2001-02-20', 'O', 'tonelambo@email.com', 915015105);

CREATE TABLE
ARTIST
(
    ALogin         INT PRIMARY KEY AUTO_INCREMENT,
    Name           VARCHAR(64) NOT NULL,      
    Verified       TINYINT NOT NULL
);

INSERT INTO ARTIST(Name, Verified) 
VALUES 
('Hugo Silva', 0), ('Joao Malheiro', 0), ('Rodrigo Devesa', 0), ('Glacier', 1), 
('Virtual Riot', 1), ('Kupla', 1), ('Linkin Park', 1), ('Kendrick Lamar', 1),
('Rosinha', 1), ('Quim Barreiros', 1); 

CREATE TABLE
SONG
(
    SId            INT PRIMARY KEY AUTO_INCREMENT,
    Name           VARCHAR(64) NOT NULL,
    Creator        INT NOT NULL,
    PostDate       DATE NOT NULL,
    FOREIGN KEY(Creator) REFERENCES ARTIST(ALogin) ON DELETE CASCADE 
);

INSERT INTO SONG(Name, Creator, PostDate)
VALUES
('Birch View', 4, '2020-02-14'), ('Still', 4, '2020-02-14'), ('Hang Limb', 4, '2020-02-14'), ('Satori', 4, '2020-02-14'), ('Ubi', 4, '2020-02-14'),

('Everyday', 5, '2017-08-10'), ('Still Kids', 5, '2017-08-10'), ('Lost It', 5, '2017-08-10'), ('Kingdoms & Castles', 5, '2017-08-10'),

('Owls of the Night', 6, '2019-12-18'), ('Serenity', 6, '2019-12-18'), ('Valentine', 6, '2019-12-18'), ('Dew', 6, '2019-12-18'),
('Sunray', 6, '2019-12-18'), ('Sleepy Little One', 6, '2019-12-18'), ('In Your Eyes', 6, '2019-12-18'), ('Roots', 6, '2019-12-18'),
('Kingdom in Blue', 6, '2019-12-18'),

('LOST IN THE ECHO', 7, '2012-06-26'), ('IN MY REMAINS', 7, '2012-06-26'), ('BURN IT DOWN', 7, '2012-06-26'), ('LIES GREED MISERY', 7, '2012-06-26'),
('I`LL BE GONE', 7, '2012-06-26'), ('CASTLE OF GLASS', 7, '2012-06-26'), ('VICTIMIZED', 7, '2012-06-26'), ('ROADS UNTRAVELED', 7, '2012-06-26'),
('SKIN TO BONE', 7, '2012-06-26'), ('UNTIL IT BREAKS', 7, '2012-06-26'), ('TINFOIL', 7, '2012-06-26'), ('POWERLESS', 7, '2012-06-26'),

('Nobody Can Save Me', 7, '2017-05-19'), ('Good Goodbye', 7, '2017-05-19'), ('Talking to Myself', 7, '2017-05-19'), ('Battle Symphony', 7, '2017-05-19'),
('Invisible', 7, '2017-05-19'), ('Heavy', 7, '2017-05-19'), ('Sorry for Now', 7, '2017-05-19'), ('Halfway Right', 7, '2017-05-19'),
('One More Light', 7, '2017-05-19'), ('Sharp Edges', 7, '2017-05-19'),

('BLOOD', 8, '2017-04-14'), ('DNA', 8, '2017-04-14'), ('YAH', 8, '2017-04-14'), ('ELEMENT', 8, '2017-04-14'), ('FEEL', 8, '2017-04-14'),
('LOYALTY', 8, '2017-04-14'), ('PRIDE', 8, '2017-04-14'), ('HUMBLE', 8, '2017-04-14'), ('LUST', 8, '2017-04-14'), ('LOVE', 8, '2017-04-14'),
('XXX', 8, '2017-04-14'), ('FEAR', 8, '2017-04-14'), ('GOD', 8, '2017-04-14'), ('DUCKWORTH', 8, '2017-04-14'),

('Eu Descasco-lhe a Banana', 9, '2019-03-22'), ('Eu Levo No Pacote', 9, '2019-03-22'), ('Eu Faço de Coentrada', 9, '2019-03-22'), 
('Na Minha Panela Não Entra', 9, '2019-03-22'), ('Eu Seguro No Pincel', 9, '2019-03-22'),

('A Cabritinha', 10, '2004-03-15'), ('A Garagem Da Vizinha', 10, '2000-11-20'), ('Bacalhau À Portuguesa', 10, '1986-04-14'),
('Mestre Da Culinária', 10, '1994-01-10'), ('O Sorveteiro (Chupa Teresa)', 10, '1992-05-11'), 
('Os Bichos Da Fazenda', 10, '2008-04-7'), ('O Melhor Dia Para Casar', 10, '1996-02-19'),
('O pito mau', 10, '2011-03-28'), ('Fui Acudir', 10, '2008-04-7'), ('Comer Comer', 10, '2001-05-14'), ('Marcha da Expo 98', 10, '1998-09-30');

CREATE TABLE 
ALBUM
(
    AId            INT PRIMARY KEY AUTO_INCREMENT,
    Name           VARCHAR(64) NOT NULL,
    Creator        INT NOT NULL,
    CreationDate   DATE NOT NULL,
    FOREIGN KEY(Creator) REFERENCES ARTIST(ALogin) ON DELETE CASCADE 
);
INSERT INTO ALBUM(Name, Creator, CreationDate)
VALUES
('Temple Inward', 4, '2020-02-14'), ('Still Kids', 5, '2017-08-10'), ('Kingdom in Blue', 6, '2019-12-18'),
('LIVING THINGS', 7, '2012-06-26'), ('One More Light', 7, '2017-05-19'), ('DAMN', 8, '2017-04-14'); 

CREATE TABLE 
PLAYLIST
(
    PId            INT PRIMARY KEY AUTO_INCREMENT,
    Name           VARCHAR(64) NOT NULL,
    Creator        INT NOT NULL,
    CreationDate   DATE NOT NULL,
    FOREIGN KEY(Creator) REFERENCES USER(ULogin) ON DELETE CASCADE
);
INSERT INTO PLAYLIST(Name, Creator, CreationDate)
VALUES
('Quim Quim', 10, '2018-04-30'), ('Rosinha: Greatest Hits', 2, '2019-09-14'),
('Chill', 8, '2020-06-29'),('MyPlaylist', 1, '2020-11-23');

CREATE TABLE
GENRE
(
    GId            INT PRIMARY KEY AUTO_INCREMENT,
    Label          VARCHAR(64) NOT NULL,
    UNIQUE KEY (Label)
);

INSERT INTO GENRE(Label)
VALUES
('EDM'), ('LO-FI'), ('ROCK'), ('RAP'), ('PIMBA');

-- user is followed by users
CREATE TABLE 
USER_FOLLOWER
(
    User           INT NOT NULL,
    Follower       INT NOT NULL,
    PRIMARY KEY(User, Follower),
    FOREIGN KEY(User) REFERENCES USER(ULogin) ON DELETE CASCADE,
    FOREIGN KEY(Follower) REFERENCES USER(ULogin) ON DELETE CASCADE
);
INSERT INTO USER_FOLLOWER(User, Follower)
VALUES
(1,2), (1,10), (1,5),
(2,1), (2,10),
(6,7), (7,6),
(10,1), (10,2);

-- artist is followed by users
CREATE TABLE
ARTIST_FOLLOWER
(
    Artist         INT NOT NULL,
    Follower       INT NOT NULL,
    FOREIGN KEY(Artist) REFERENCES ARTIST(ALogin) ON DELETE CASCADE,
    FOREIGN KEY(Follower) REFERENCES USER(ULogin) ON DELETE CASCADE
);
INSERT INTO ARTIST_FOLLOWER(Artist, Follower)
VALUES
(4,8), (5,3), 
(6,3), (6,4), (6,5), (6,7),
(7,6), (7,7), (7,9),
(8,1), (9,2), (9,10),
(10,1), (10,2), (10,10);

CREATE TABLE
PLAYLIST_SONG
(
    PId           INT NOT NULL,
    SId           INT NOT NULL,
    PRIMARY KEY(PId, SId),
    FOREIGN KEY(PId) REFERENCES PLAYLIST(PId) ON DELETE CASCADE,
    FOREIGN KEY(SId) REFERENCES SONG(SId) ON DELETE CASCADE
);
INSERT INTO PLAYLIST_SONG(PId, SId)
VALUES
(1,60), (1,61), (1,62), (1,63), (1,64), (1,65), (1,66), (1,67), (1,68), (1,69),
(2,55), (2,56), (2,57), (2,58), (2,59),
(3,10), (3,11), (3,14), (3,16), (3,18),
(4,19), (4,21), (4,24), (4,31), (4,33), (4,34);


CREATE TABLE
ALBUM_SONG
(
    AId          INT NOT NULL,
    SId          INT NOT NULL,
    PRIMARY KEY(AId, SId),
    FOREIGN KEY(AId) REFERENCES ALBUM(AId) ON DELETE CASCADE,
    FOREIGN KEY(SId) REFERENCES SONG(SId) ON DELETE CASCADE
);
INSERT INTO ALBUM_SONG(AId, SId)
VALUES
(1,1), (1,2), (1,3), (1,4), (1,5),
(2,6), (2,7), (2,8), (2,9),
(3,11), (3,12), (3,13), (3,14), (3,15), (3,16), (3,17), (3,18),
(4,19), (4,20), (4,21), (4,22), (4,23), (4,24), (4,25), (4,26), (4,27), (4,28), (4,29), (4,30),
(5,31), (5,32), (5,33), (5,34), (5,35), (5,36), (5,37), (5,38), (5,39), (5,40),
(6,41), (6,42), (6,43), (6,44), (6,45), (6,46), (6,47), (6,48), (6,49), (6,50), (6,51), (6,52), (6,53), (6,54);


CREATE TABLE
SONG_LIKED
(
    ULogin           INT NOT NULL,
    SId              INT NOT NULL,
    PRIMARY KEY(ULogin, SId),
    FOREIGN KEY(ULogin) REFERENCES USER(ULogin) ON DELETE CASCADE,
    FOREIGN KEY(SId) REFERENCES SONG(SId) ON DELETE CASCADE
);
INSERT INTO SONG_LIKED(ULogin, SId)
VALUES
(10,60), (10,61), (10,62), (10,63), (10,64), (10,65), (10,66), (10,67), (10,68), (10,69),
(2,55), (2,56), (2,57), (2,58), (2,59);


CREATE TABLE
ALBUM_LIKED
(
    ULogin         INT NOT NULL,
    AId            INT NOT NULL,
    PRIMARY KEY(ULogin, AId),
    FOREIGN KEY(ULogin) REFERENCES USER(ULogin) ON DELETE CASCADE,
    FOREIGN KEY(AId) REFERENCES ALBUM(AId) ON DELETE CASCADE
);
INSERT INTO ALBUM_LIKED(ULogin, AId)
VALUES
(1,4), (2,4), (3,3), (4,2), (6,4), (6,5);



CREATE TABLE
PLAYLIST_LIKED
(
    ULogin           INT NOT NULL,
    PId              INT NOT NULL,
    PRIMARY KEY(ULogin, PId),
    FOREIGN KEY(ULogin) REFERENCES USER(ULogin) ON DELETE CASCADE,
    FOREIGN KEY(PId) REFERENCES PLAYLIST(PId) ON DELETE CASCADE
);
INSERT INTO PLAYLIST_LIKED(ULogin, PId)
VALUES
(1,4), (2,2), (3,3), (4,2), (6,4);


CREATE TABLE
SONG_GENRE
(
    SId           INT NOT NULL,
    GId           INT NOT NULL,
    PRIMARY KEY(GId, SId),
    FOREIGN KEY(SId) REFERENCES SONG(SId) ON DELETE CASCADE,
    FOREIGN KEY(GId) REFERENCES GENRE(GId) ON DELETE CASCADE
);
INSERT INTO SONG_GENRE(GId, SId)
VALUES
(1,1), (1,2), (1,3), (1,4), (1,5), (1,6), (1,7), (1,8), (1,9),
(2,10), (2,11), (2,12), (2,13), (2,14), (2,15), (2,16), (2,17), (2,18),
(3,19), (3,20), (3,21), (3,22), (3,23), (3,24), (3,25), (3,26), (3,27), (3,28), (3,29), (3,30),
(3,31), (3,32), (3,33), (3,34), (3,35), (3,36), (3,37), (3,38), (3,39), (3,40),
(4,41), (4,42), (4,43), (4,44), (4,45), (4,46), (4,47), (4,48), (4,49), (4,50), (4,51), (4,52), (4,53), (4,54),
(5,55), (5,56), (5,57), (5,58), (5,59),
(5,60), (5,61), (5,62), (5,63), (5,64), (5,65), (5,66), (5,67), (5,68), (5,69);