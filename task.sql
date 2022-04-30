--CREATE DATABASE taskDB;
USE task1DB;

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
    