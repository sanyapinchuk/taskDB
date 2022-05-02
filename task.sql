CREATE DATABASE taskDB;
USE taskDB;
GO

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
('4488982361643285',320,4),
('4488456798233476',580,3),
('4488456798233474',50,2),
('4488456798233412',150,5),
('4488456798233412',400,4),
('4488456798233412',280,8)

INSERT INTO Account VALUES
(1,1,500),
(1,2,280),
(2,1,580),
(3,3,730),
(4,4,400),
(5,2,440),
(5,5,800),
(4,1,300);

--tasks
--1

SELECT nameBank
FROM Banks
JOIN Branch ON Banks.idBank = Branch.idBank
JOIN TOWER ON Branch.idTower = Tower.idTower
WHERE nameTower = 'Bobruisk';

--2
SELECT Client.firstNameClient,
       Client.secondNameClient,
       Cards.cash,
       Banks.nameBank
FROM Cards
JOIN Account ON Cards.idAccount = Account.idAccount
JOIN Banks ON Account.idBank = Banks.idBank
JOIN Client ON Client.idClient = Account.idClient;


--3

SELECT  DISTINCT  Account.idAccount,
       idClient,
       idBank,
       Account.cash AS 'Баланс акк',
	   "сумма на картах",
	   Account.cash - "сумма на картах" AS Разница,
	   "кол-во карт в банке"
FROM Account
JOIN Cards ON Cards.idAccount = Account.idAccount
JOIN(SELECT DISTINCT Cards.idAccount AS AccountID, SUM(Cards.cash) AS 'сумма на картах', COUNT(Cards.cash) AS 'кол-во карт в банке' FROM Account 
	JOIN Cards ON Account.idAccount = Cards.idAccount
	GROUP BY Cards.idAccount) AS Dp ON AccountID = Account.idAccount
	WHERE (Account.cash != "сумма на картах")

--4
SELECT nameStatus, COUNT(*) AS 'Кол-во карт' FROM SocStatus
JOIN Client ON SocStatus.idStatus = Client.idStatus
JOIN Account ON Account.idClient = Client.idClient
JOIN Cards ON Account.idAccount = Cards.idAccount
GROUP BY nameStatus;
/*
SELECT DISTINCT Sn.nameStatus,COUNT(Sn.nameStatus) FROM SocStatus
JOIN Client ON SocStatus.idStatus = Client.idStatus
JOIN Account ON Account.idClient = Client.idClient
JOIN Cards ON Account.idAccount = Cards.idAccount
JOIN (SELECT DISTINCT SocStatus.nameStatus FROM SocStatus) AS Sn ON Sn.nameStatus= SocStatus.nameStatus;*/

--5
GO
CREATE PROCEDURE AddMoneyForStatus @idStatus INT
AS
BEGIN
	UPDATE Account 
	SET cash = cash+10
	WHERE (Account.idAccount IN (SELECT Account.idAccount FROM Account JOIN Client ON Account.idClient = Client.idClient JOIN SocStatus ON Client.idStatus = SocStatus.idStatus WHERE SocStatus.idStatus = @idStatus))

END;
GO


SELECT * FROM Account JOIN Client ON Client.idClient = Account.idClient;
EXEC AddMoneyForStatus @idStatus = 4;
SELECT * FROM Account JOIN Client ON Client.idClient = Account.idClient;


--6 
GO
CREATE FUNCTION GetTableOfAccounts  ()
    RETURNS TABLE
	AS
 RETURN(
	SELECT DISTINCT Client.idClient, Account.idAccount, Client.firstNameClient, Client.secondNameClient, Account.cash AS 'Сумма на счете', "сумма на картах", "кол-во карт в банке", Account.cash-"сумма на картах" AS 'доступные средства'  FROM Account 
	JOIN Cards ON Account.idAccount = Cards.idAccount
	JOIN Client ON Account.idClient = Client.idClient
	JOIN(
	SELECT Cards.idAccount AS AccountID, SUM(Cards.cash) AS 'сумма на картах', COUNT(Cards.cash) AS 'кол-во карт в банке' FROM Account 
	JOIN Cards ON Account.idAccount = Cards.idAccount
	GROUP BY Cards.idAccount) AS F ON Cards.idAccount = AccountID)


GO

  SELECT * FROM GetTableOfAccounts();


--7

	GO
CREATE PROCEDURE SendMoney @idAccount INT, @count MONEY, @idCard INT
AS
BEGIN
	BEGIN TRANSACTION 
		IF(@count <= (SELECT Account.cash FROM Account WHERE Account.idAccount = @idAccount) - (SELECT	"сумма на картах" FROM GetTableOfAccounts() WHERE idAccount = @idAccount) ) 
		BEGIN
			/*UPDATE Account        --if need send to other account's card
			SET Account.cash = Account.cash - @count
			WHERE ( Account.idAccount = @idAccount);

			DECLARE @currIDAcc INT;
			SET @currIDAcc = (SELECT Account.idAccount FROM Account JOIN Cards ON Account.idAccount = Cards.idAccount WHERE Cards.idCard= @idCard);
			PRINT(@currIDAcc);
			UPDATE Account
			SET Account.cash = Account.cash + @count
			WHERE (Account.idAccount = @currIDAcc);*/

			UPDATE Cards
			SET Cards.cash = Cards.cash + @count
			WHERE (Cards.idCard = @idCard);
		END;
		
		
	COMMIT TRANSACTION

END;


SELECT * FROM GetTableOfAccounts();
EXEC SendMoney @idAccount = 4, @count = 5, @idCard=2; --yes
SELECT * FROM GetTableOfAccounts();


--8
GO
CREATE TRIGGER Account_Insert
ON Account
AFTER INSERT
AS
BEGIN

	IF((SELECT cash
	FROM INSERTED) <  (SELECT "сумма на картах" FROM GetTableOfAccounts() WHERE idAccount = (SELECT idAccount FROM INSERTED)) )
	BEGIN
		DELETE Account
		WHERE (Account.idAccount = (SELECT idAccount FROM INSERTED));
	END;
END;


GO
CREATE TRIGGER Account_Update
ON Account
AFTER UPDATE
AS
BEGIN
	IF((SELECT cash	FROM INSERTED) <  (SELECT "сумма на картах" FROM GetTableOfAccounts() WHERE idAccount = (SELECT idAccount FROM INSERTED)) )
	BEGIN
		UPDATE Account
		SET
			Account.cash = (SELECT cash FROM DELETED)
		WHERE Account.idAccount = (SELECT idAccount FROM DELETED)
	END;
END;

GO
CREATE TRIGGER Cards_Insert
ON Cards
AFTER INSERT
AS
BEGIN
	IF((SELECT Account.cash	FROM Account WHERE Account.idAccount = (SELECT INSERTED.idAccount FROM INSERTED ) ) 
	<  (SELECT "сумма на картах" FROM GetTableOfAccounts() WHERE idAccount = (SELECT idAccount FROM INSERTED)) )
	BEGIN
		DELETE Cards
		WHERE (Cards.idCard = (SELECT idCard FROM INSERTED));
	END;
END;


GO
CREATE TRIGGER Cards_Update
ON Cards
AFTER UPDATE
AS
BEGIN
IF((SELECT Account.cash	FROM Account WHERE Account.idAccount = (SELECT INSERTED.idAccount FROM INSERTED ) ) 
	<  (SELECT "сумма на картах" FROM GetTableOfAccounts() WHERE idAccount = (SELECT idAccount FROM INSERTED)) )
	BEGIN
		UPDATE Cards
		SET
			Cards.cash = (SELECT cash FROM DELETED)
		WHERE Cards.idCard = (SELECT idCard FROM DELETED)
	END;
END;
-----------------check Account's triggers
-----
SELECT * FROM GetTableOfAccounts();

UPDATE Account 
SET cash = 740  -- YES
WHERE (idAccount = 4);

SELECT * FROM GetTableOfAccounts();
SELECT idCard,Cards.cash AS 'на карте',Cards.idAccount,idClient,idBank,Account.cash AS 'счёт аккаунта' FROM Cards JOIN Account ON Cards.idAccount = Account.idAccount;
------
SELECT * FROM GetTableOfAccounts();

UPDATE Account 
SET cash = 690  -- NO
WHERE (idAccount = 4);

SELECT * FROM GetTableOfAccounts();
SELECT idCard,Cards.cash AS 'на карте',Cards.idAccount,idClient,idBank,Account.cash AS 'счёт аккаунта' FROM Cards JOIN Account ON Cards.idAccount = Account.idAccount;





--------------check cards

SELECT * FROM GetTableOfAccounts();

EXEC SendMoney @idAccount = 4, @count = 100, @idCard = 2;  --YES

SELECT * FROM GetTableOfAccounts();
SELECT idCard,Cards.cash AS 'на карте',Cards.idAccount,idClient,idBank,Account.cash AS 'счёт аккаунта' FROM Cards JOIN Account ON Cards.idAccount = Account.idAccount;
-----
SELECT * FROM GetTableOfAccounts();

EXEC SendMoney @idAccount = 4, @count = 150, @idCard = 2;  --NO

SELECT * FROM GetTableOfAccounts();
SELECT idCard,Cards.cash AS 'на карте',Cards.idAccount,idClient,idBank,Account.cash AS 'счёт аккаунта' FROM Cards JOIN Account ON Cards.idAccount = Account.idAccount;