CREATE DATABASE taskDB;
USE taskDB;

CREATE TABLE Banks (
	idBank INT PRIMARY KEY NOT NULL IDENTITY,
    nameBank INT
);

CREATE TABLE Branch (
	idBranch INT PRIMARY KEY NOT NULL IDENTITY,
    nameBank INT
);

CREATE TABLE Tower (
	idTower INT PRIMARY KEY NOT NULL IDENTITY,
    nameTower nvarchar(20)
    );

CREATE TABLE Account (
	idAccount INT PRIMARY KEY NOT NULL IDENTITY,
    idClient INT,
    idBank INT,
    cash decimal(19,4)
    );
    
CREATE TABLE Client (
	idClient INT PRIMARY KEY IDENTITY,
    firstNameClient nvarchar(20),
    secondNameClient nvarchar(20),
    idStatus INT
);

CREATE TABLE Status (
	idStatus INT PRIMARY KEY IDENTITY,
    nameStatus nvarchar(15)
);

CREATE TABLE Card (
	idCard INT PRIMARY KEY IDENTITY,
    serialNumber nvarchar(16),
    cash decimal(19,4),
    idAccount INT
);
    