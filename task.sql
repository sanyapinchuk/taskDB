--CREATE DATABASE taskDB;
USE taskDB;

CREATE TABLE Banks (
	idBank INT PRIMARY KEY NOT NULL IDENTITY,
    nameBank nvarchar(20)
);

CREATE TABLE Branch (
	idBranch INT PRIMARY KEY NOT NULL IDENTITY,
    idBank INT,
	idTower INT, 
	idStreet INT,
	idHouse INT,
);

CREATE TABLE Street (
	idStreet INT PRIMARY KEY NOT NULL IDENTITY,
	nameStreet nvarchar(20)
);

CREATE TABLE House (
	idHouse INT PRIMARY KEY NOT NULL IDENTITY,
	number INT
);

CREATE TABLE Tower (
	idTower INT PRIMARY KEY NOT NULL IDENTITY,
    nameTower nvarchar(20)
    );

CREATE TABLE Account (
	idAccount INT PRIMARY KEY NOT NULL IDENTITY,
    idClient INT,
    idBank INT,
    cash money
    );
    
CREATE TABLE Client (
	idClient INT PRIMARY KEY IDENTITY,
    firstNameClient nvarchar(20),
    secondNameClient nvarchar(20),
    idStatus INT
);

CREATE TABLE SocStatus (
	idStatus INT PRIMARY KEY IDENTITY,
    nameStatus nvarchar(15)
);

CREATE TABLE Cards (
	idCard INT PRIMARY KEY IDENTITY,
    serialNumber nvarchar(16),
    cash money,
    idAccount INT
);
    
INSERT INTO Banks VALUES
('BelarusBank'), ('Belinvest'), ('BelAgroPromBank'), ('BelGasProvBank'), ('AlfaBank' );

INSERT INTO Street VALUES
('Пушкинская'),('Советская'),('Центральная'),('Батова');

INSERT INTO House VALUES
(14),(1),(42),(64),(4);

INSERT INTO Tower VALUES
('Minsk'), ('Brest'), ('Gomel'), ('Bobruisk'), ('Grodno');

INSERT INTO Branch VALUES
(1,1,1,1),
(2,2,2,2),
(3,3,3,3),
(4,4,4,4),
(5,5,1,5),
(1,4,1,3),
(3,4,1,2)

INSERT INTO SocStatus VALUES
('pensioner'),
('invalid'),
('default'),
('business'), 
('foreigner');

INSERT INTO Client VALUES
('Александр','Пушкин',1),
('Олег','Трофимов',2),
('Анна','Ярмолик',3),
('Михаил', 'Кавзов',2),
('Дарья','Малашенко',4);

INSERT INTO Cards VALUES
('4488456798233476',400,1),
('4488982361643285',220,4),
('4488456798233476',580,2),
('4488456798233474',0,2),
('4488456798233412',150,5);

INSERT INTO Account VALUES
(1,1,400),
(1,2,100),
(2,1,500),
(3,3,120),
(4,4,400),
(5,2,440),
(5,5,100)


--tasks
--1

SELECT nameBank FROM Banks
JOIN Branch ON Banks.idBank = Branch.idBank
JOIN TOWER ON Branch.idTower = Tower.idTower
WHERE nameTower = 'Bobruisk';