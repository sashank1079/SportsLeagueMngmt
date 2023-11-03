

------------------------------------------CREATE DATABASE------------------------------------------

CREATE DATABASE "Team1Projectnew"

USE Team1Projectnew;


------------------------------------------CREATE TABLES------------------------------------------

CREATE TABLE dbo.Coach
(
CoachID INT IDENTITY NOT NULL PRIMARY KEY,
CoachFName VARCHAR(30) NOT NULL,
CoachLName VARCHAR(30) NOT NULL,
ContactPhone VARCHAR(10) NOT NULL,
ContactEmail VARCHAR(50) NOT NULL,
ExperienceLevel INT DEFAULT 1
);

CREATE TABLE dbo.Team
(
TeamID INT IDENTITY NOT NULL PRIMARY KEY,
TeamName VARCHAR(50) NOT NULL,
TeamLocation VARCHAR(30) NOT NULL
);

CREATE TABLE dbo.TeamCoaching
(
CoachID INT NOT NULL
REFERENCES Coach(CoachID),
TeamID INT NOT NULL
REFERENCES Team(TeamID)
CONSTRAINT c_PKTeamCoaching PRIMARY KEY CLUSTERED (CoachID, TeamID)
);


CREATE TABLE dbo.Player
(
PlayerID INT IDENTITY NOT NULL PRIMARY KEY,
PlayerFName VARCHAR(30) NOT NULL,
PlayerLName VARCHAR(30) NOT NULL,
DateOfBirth Date NOT NULL,
PlayerHeight INT NOT NULL,
PlayerWeight INT NOT NULL,
PlayerAge INT NOT NULL,
PlayerPosition VARCHAR(20) NOT NULL,
PlayerJerseyNum INT NOT NULL,
PlayerExperience INT NOT NULL,
InjuryStatus VARCHAR(3) NOT NULL DEFAULT 'no';
);


CREATE TABLE dbo.PlayerTeam
(
PlayerID INT NOT NULL
REFERENCES Player(PlayerID),
TeamID INT NOT NULL
REFERENCES Team(TeamID)
CONSTRAINT c_PKPlayerTeam PRIMARY KEY CLUSTERED (PlayerID, TeamID)
);


CREATE TABLE dbo.PlayerContract
(
ContractID INT IDENTITY NOT NULL PRIMARY KEY,
ContractStartDate Date NOT NULL,
ContractEndDate Date NOT NULL,
PlayerSalary MONEY NOT NULL,
PlayerID INT NOT NULL
REFERENCES Player(PlayerID),
TeamID INT NOT NULL
REFERENCES Team(TeamID),
CONSTRAINT c_CheckEndDate CHECK(ContractEndDate > ContractStartDate),
);


CREATE TABLE dbo.InjuryHistory
( 
InjuryID INT IDENTITY NOT NULL PRIMARY KEY,
InjuryType Varchar(20) NOT NULL,
InjuryDate Date NOT NULL,
InjuryDesc VARCHAR(50),
PlayerID INT NOT NULL
REFERENCES Player(PlayerID)
);

CREATE TABLE dbo.Game
(
GameID INT IDENTITY NOT NULL PRIMARY KEY,
GameDate DATE NOT NULL,
GameTime TIME NOT NULL,
GameLocation VARCHAR(30) NOT NULL,
HomeTeamScore INT DEFAULT NULL,
AwayTeamScore INT DEFAULT NULL,
HomeTeamID INT NOT NULL
REFERENCES Team(TeamID),
AwayTeamID INT NOT NULL
REFERENCES Team(TeamID),
WinTeamID INT
REFERENCES Team(TeamID) DEFAULT NULL
);

CREATE TABLE dbo.W_L_TABLE
(
TEAMID INT NOT NULL REFERENCES Team(TeamID) PRIMARY KEY,
WinCount INT DEFAULT 0,
LoseCount INT DEFAULT 0
);

CREATE TABLE dbo.GameStats
(
GameStatsID INT IDENTITY NOT NULL PRIMARY KEY,
GamePoints INT DEFAULT 0,
GameRebounds INT DEFAULT 0,
GameAssists INT DEFAULT 0,
GameBlocks INT DEFAULT 0,
GameSteals INT DEFAULT 0,
GameID INT NOT NULL
REFERENCES Game(GameID),
PlayerID INT NOT NULL
REFERENCES Player(PlayerID)
);

CREATE TABLE dbo.TeamRoster
(
RosterID INT IDENTITY NOT NULL PRIMARY KEY,
TeamID INT NOT NULL
REFERENCES Team(TeamID),
PlayerID INT NOT NULL
REFERENCES Player(PlayerID),
GameID INT NOT NULL
REFERENCES Game(GameID)
);


CREATE TABLE dbo.SeasonStats
(
SeasonStatsID INT IDENTITY NOT NULL PRIMARY KEY,
PlayerID INT NOT NULL
REFERENCES Player(PlayerID),
PointsPerGame INT DEFAULT 0,
AssistsPerGame INT DEFAULT 0,
StealsPerGame INT DEFAULT 0,
BlocksPerGame INT DEFAULT 0,
ReboundsPerGame INT DEFAULT 0,
)

--------------------------------------------------------------------------------------TABLE LEVEL CONSTRAINTS--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Function to check PointsPerGame
CREATE FUNCTION dbo.CheckPointsPerGame(@PointsPerGame INT)
RETURNS BIT
AS
BEGIN
    RETURN CASE WHEN @PointsPerGame >= 0 THEN 1 ELSE 0 END;
END;
GO

-- Function to check AssistsPerGame
CREATE FUNCTION dbo.CheckAssistsPerGame(@AssistsPerGame INT)
RETURNS BIT
AS
BEGIN
    RETURN CASE WHEN @AssistsPerGame >= 0 THEN 1 ELSE 0 END;
END;
GO

-- Function to check StealsPerGame
CREATE FUNCTION dbo.CheckStealsPerGame(@StealsPerGame INT)
RETURNS BIT
AS
BEGIN
    RETURN CASE WHEN @StealsPerGame >= 0 THEN 1 ELSE 0 END;
END;
GO

-- Function to check BlocksPerGame
CREATE FUNCTION dbo.CheckBlocksPerGame(@BlocksPerGame INT)
RETURNS BIT
AS
BEGIN
    RETURN CASE WHEN @BlocksPerGame >= 0 THEN 1 ELSE 0 END;
END;
GO

-- Function to check ReboundsPerGame
CREATE FUNCTION dbo.CheckReboundsPerGame(@ReboundsPerGame INT)
RETURNS BIT
AS
BEGIN
    RETURN CASE WHEN @ReboundsPerGame >= 0 THEN 1 ELSE 0 END;
END;
GO

-- Function to check player exists in team
CREATE FUNCTION dbo.CheckPlayerOnTeam(@PlayerID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT;
    SET @Result = (
        SELECT CASE WHEN EXISTS (SELECT 1 FROM dbo.PlayerTeam WHERE PlayerID = @PlayerID) THEN 1 ELSE 0 END
    );
    RETURN @Result;
END;
GO

   
ALTER TABLE dbo.Coach
ADD CONSTRAINT chk_ExperienceLevel CHECK (ExperienceLevel BETWEEN 1 AND 10);

ALTER TABLE dbo.Player
ADD CONSTRAINT chk_PlayerAge CHECK (PlayerAge >= 0);

ALTER TABLE dbo.Player
ADD CONSTRAINT chk_PlayerHeight CHECK (PlayerHeight >= 0);

ALTER TABLE dbo.Player
ADD CONSTRAINT chk_PlayerWeight CHECK (PlayerWeight >= 0);


ALTER TABLE dbo.PlayerContract
ADD CONSTRAINT chk_ContractDates CHECK (ContractStartDate < ContractEndDate);

ALTER TABLE dbo.Game
ADD CONSTRAINT chk_HomeAwayTeams CHECK (HomeTeamID <> AwayTeamID);

ALTER TABLE dbo.SeasonStats
ADD CONSTRAINT chk_PointsPerGame CHECK (PointsPerGame >= 0);

ALTER TABLE dbo.SeasonStats
ADD CONSTRAINT chk_AssistsPerGame CHECK (AssistsPerGame >= 0);

ALTER TABLE dbo.SeasonStats
ADD CONSTRAINT chk_StealsPerGame CHECK (StealsPerGame >= 0);

ALTER TABLE dbo.SeasonStats
ADD CONSTRAINT chk_BlocksPerGame CHECK (BlocksPerGame >= 0);

ALTER TABLE dbo.Team
ADD CONSTRAINT chk_TeamNameNotNull CHECK (TeamName IS NOT NULL);

ALTER TABLE dbo.Team
ADD CONSTRAINT chk_TeamLocationNotNull CHECK (TeamLocation IS NOT NULL);

ALTER TABLE dbo.InjuryHistory
ADD CONSTRAINT chk_InjuryDate CHECK (InjuryDate <= GETDATE());

ALTER TABLE dbo.GameStats
ADD CONSTRAINT chk_GamePoints CHECK (GamePoints >= 0);

ALTER TABLE dbo.GameStats
ADD CONSTRAINT chk_GameRebounds CHECK (GameRebounds >= 0);

ALTER TABLE dbo.GameStats
ADD CONSTRAINT chk_GameAssists CHECK (GameAssists >= 0);

ALTER TABLE dbo.GameStats
ADD CONSTRAINT chk_GameBlocks CHECK (GameBlocks >= 0);

ALTER TABLE dbo.GameStats
ADD CONSTRAINT chk_GameSteals CHECK (GameSteals >= 0);

ALTER TABLE dbo.TeamRoster
ADD CONSTRAINT chk_PlayerTeamUnique UNIQUE (PlayerID, TeamID);

ALTER TABLE dbo.PlayerTeam
ADD CONSTRAINT chk_PlayerTeamUnique UNIQUE (PlayerID, TeamID);

ALTER TABLE dbo.TeamCoaching
ADD CONSTRAINT chk_CoachTeamUnique UNIQUE (CoachID, TeamID);

-- Add CHECK Constraints to SeasonStats table
ALTER TABLE dbo.SeasonStats
ADD CONSTRAINT CHK_PointsPerGame CHECK (dbo.CheckPointsPerGame(PointsPerGame) = 1);

ALTER TABLE dbo.SeasonStats
ADD CONSTRAINT CHK_AssistsPerGame CHECK (dbo.CheckAssistsPerGame(AssistsPerGame) = 1);

ALTER TABLE dbo.SeasonStats
ADD CONSTRAINT CHK_StealsPerGame CHECK (dbo.CheckStealsPerGame(StealsPerGame) = 1);

ALTER TABLE dbo.SeasonStats
ADD CONSTRAINT CHK_BlocksPerGame CHECK (dbo.CheckBlocksPerGame(BlocksPerGame) = 1);

ALTER TABLE dbo.SeasonStats
ADD CONSTRAINT CHK_ReboundsPerGame CHECK (dbo.CheckReboundsPerGame(ReboundsPerGame) = 1);

ALTER TABLE dbo.TeamRoster
ADD CONSTRAINT CHK_PlayerOnTeam CHECK (dbo.CheckPlayerOnTeam(PlayerID) = 1);



---------------------------------------------------------------------------------------------------------DML------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---- COACH TABLE RECORDS ---
INSERT INTO dbo.Coach (CoachFName, CoachLName, ContactPhone, ContactEmail, ExperienceLevel) VALUES ('John', 'Doe', '1234567890', 'john.doe@gmail.com', 3);
INSERT INTO dbo.Coach (CoachFName, CoachLName, ContactPhone, ContactEmail, ExperienceLevel) VALUES ('Jane', 'Smith', '9876543210', 'jane.smith@gmail.com', 2);
INSERT INTO dbo.Coach (CoachFName, CoachLName, ContactPhone, ContactEmail, ExperienceLevel) VALUES ('Michael', 'Johnson', '5555555555', 'michael.johnson@gmail.com', 1);
INSERT INTO dbo.Coach (CoachFName, CoachLName, ContactPhone, ContactEmail, ExperienceLevel) VALUES ('Emily', 'Brown', '2223334444', 'emily.brown@gmail.com', 2);
INSERT INTO dbo.Coach (CoachFName, CoachLName, ContactPhone, ContactEmail, ExperienceLevel) VALUES ('Robert', 'Lee', '7778889999', 'robert.lee@gmail.com', 3);
INSERT INTO dbo.Coach (CoachFName, CoachLName, ContactPhone, ContactEmail, ExperienceLevel) VALUES ('Sarah', 'Wilson', '4445556666', 'sarah.wilson@gmail.com', 1);
INSERT INTO dbo.Coach (CoachFName, CoachLName, ContactPhone, ContactEmail, ExperienceLevel) VALUES ('David', 'Martinez', '9990001111', 'david.martinez@gmail.com', 2);
INSERT INTO dbo.Coach (CoachFName, CoachLName, ContactPhone, ContactEmail, ExperienceLevel) VALUES ('Jessica', 'Anderson', '6667778888', 'jessica.anderson@gmail.com', 1);
INSERT INTO dbo.Coach (CoachFName, CoachLName, ContactPhone, ContactEmail, ExperienceLevel) VALUES ('William', 'Taylor', '8889990000', 'william.taylor@gmail.com', 3);
INSERT INTO dbo.Coach (CoachFName, CoachLName, ContactPhone, ContactEmail, ExperienceLevel) VALUES ('Linda', 'Miller', '3334445555', 'linda.miller@gmail.com', 2);
INSERT INTO dbo.Coach (CoachFName, CoachLName, ContactPhone, ContactEmail, ExperienceLevel) VALUES ('James', 'Jackson', '1112223333', 'james.jackson@gmail.com', 1);
INSERT INTO dbo.Coach (CoachFName, CoachLName, ContactPhone, ContactEmail, ExperienceLevel) VALUES ('Amanda', 'White', '5556667777', 'amanda.white@gmail.com', 3);


---- TEAM TABLE RECORDS ---
INSERT INTO dbo.Team (TeamName, TeamLocation) VALUES ('Team A', 'City A');
INSERT INTO dbo.Team (TeamName, TeamLocation) VALUES ('Team B', 'City B');
INSERT INTO dbo.Team (TeamName, TeamLocation) VALUES ('Team C', 'City C');
INSERT INTO dbo.Team (TeamName, TeamLocation) VALUES ('Team D', 'City D');
INSERT INTO dbo.Team (TeamName, TeamLocation) VALUES ('Team E', 'City E');
INSERT INTO dbo.Team (TeamName, TeamLocation) VALUES ('Team F', 'City F');
INSERT INTO dbo.Team (TeamName, TeamLocation) VALUES ('Team G', 'City G');
INSERT INTO dbo.Team (TeamName, TeamLocation) VALUES ('Team H', 'City H');
INSERT INTO dbo.Team (TeamName, TeamLocation) VALUES ('Team I', 'City I');
INSERT INTO dbo.Team (TeamName, TeamLocation) VALUES ('Team J', 'City J');
INSERT INTO dbo.Team (TeamName, TeamLocation) VALUES ('Team K', 'City K');
INSERT INTO dbo.Team (TeamName, TeamLocation) VALUES ('Team L', 'City L');

---- COACH TEAMCOACHING TABLE RECORDS ---
INSERT INTO dbo.TeamCoaching (CoachID, TeamID) VALUES (1, 1);
INSERT INTO dbo.TeamCoaching (CoachID, TeamID) VALUES (1, 2);
INSERT INTO dbo.TeamCoaching (CoachID, TeamID) VALUES (2, 1);
INSERT INTO dbo.TeamCoaching (CoachID, TeamID) VALUES (2, 3);
INSERT INTO dbo.TeamCoaching (CoachID, TeamID) VALUES (3, 2);
INSERT INTO dbo.TeamCoaching (CoachID, TeamID) VALUES (3, 3);
INSERT INTO dbo.TeamCoaching (CoachID, TeamID) VALUES (4, 1);
INSERT INTO dbo.TeamCoaching (CoachID, TeamID) VALUES (4, 4);
INSERT INTO dbo.TeamCoaching (CoachID, TeamID) VALUES (5, 2);
INSERT INTO dbo.TeamCoaching (CoachID, TeamID) VALUES (5, 5);
INSERT INTO dbo.TeamCoaching (CoachID, TeamID) VALUES (6, 3);
INSERT INTO dbo.TeamCoaching (CoachID, TeamID) VALUES (6, 6);

---- PLAYER TABLE RECORDS ---
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('John', 'Doe', '1990-05-15', 185, 80, 33, 'Forward', 10, 7);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Jane', 'Smith', '1995-09-25', 170, 65, 28, 'Guard', 22, 5);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Michael', 'Johnson', '1992-11-10', 192, 90, 30, 'Center', 15, 9);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Emily', 'Brown', '1997-03-18', 178, 75, 26, 'Forward', 5, 4);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Robert', 'Lee', '1988-07-05', 190, 88, 35, 'Guard', 12, 11);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Sarah', 'Wilson', '1993-01-29', 175, 68, 28, 'Guard', 30, 6);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('David', 'Martinez', '1998-06-12', 185, 82, 23, 'Forward', 8, 2);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Jessica', 'Anderson', '1994-04-02', 172, 70, 27, 'Guard', 11, 5);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('William', 'Taylor', '1985-12-20', 195, 95, 37, 'Center', 25, 14);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Linda', 'Miller', '1991-08-08', 180, 74, 32, 'Forward', 9, 8);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('James', 'Jackson', '1996-02-14', 188, 85, 27, 'Center', 18, 3);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Amanda', 'White', '1999-10-01', 173, 67, 24, 'Guard', 7, 1);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Daniel', 'Thomas', '1990-09-08', 190, 88, 33, 'Forward', 14, 7);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Nicole', 'Harris', '1995-07-21', 172, 68, 28, 'Guard', 21, 5);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Matthew', 'Garcia', '1992-04-15', 195, 92, 30, 'Center', 16, 9);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Olivia', 'Rodriguez', '1997-06-23', 177, 74, 26, 'Forward', 6, 4);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Andrew', 'Lee', '1988-03-05', 185, 83, 35, 'Guard', 13, 11);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Sophia', 'Martinez', '1993-10-18', 175, 67, 28, 'Guard', 29, 6);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Ethan', 'Wilson', '1998-07-12', 183, 79, 23, 'Forward', 11, 2);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Isabella', 'Johnson', '1994-12-02', 168, 65, 27, 'Guard', 10, 5);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Alexander', 'Anderson', '1985-11-20', 193, 94, 37, 'Center', 24, 14);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Grace', 'Miller', '1991-04-18', 178, 71, 32, 'Forward', 12, 8);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Jackson', 'Smith', '1996-01-02', 190, 87, 27, 'Center', 20, 3);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Chloe', 'Brown', '1999-11-15', 172, 66, 24, 'Guard', 6, 1);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Samuel', 'Taylor', '1992-08-21', 188, 82, 30, 'Forward', 13, 7);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Hannah', 'Johnson', '1997-02-28', 175, 68, 26, 'Guard', 28, 5);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Benjamin', 'Lee', '1994-06-10', 192, 89, 27, 'Center', 17, 9);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Avery', 'Smith', '1999-03-08', 177, 73, 24, 'Forward', 4, 4);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Mason', 'Garcia', '1988-12-03', 185, 84, 35, 'Guard', 17, 11);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Elizabeth', 'Martinez', '1993-09-20', 176, 69, 28, 'Guard', 27, 6);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Elijah', 'Wilson', '1998-08-17', 183, 81, 23, 'Forward', 10, 2);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Sofia', 'Anderson', '1994-01-02', 170, 66, 27, 'Guard', 9, 5);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Daniel', 'Johnson', '1985-10-30', 193, 96, 37, 'Center', 23, 14);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Avery', 'Miller', '1991-06-25', 180, 75, 32, 'Forward', 11, 8);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Elijah', 'Smith', '1996-03-19', 188, 86, 27, 'Center', 19, 3);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Chloe', 'Brown', '1999-09-14', 172, 67, 24, 'Guard', 5, 1);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Daniel', 'Taylor', '1992-08-21', 188, 82, 30, 'Forward', 13, 7);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Hannah', 'Wilson', '1997-02-28', 175, 68, 26, 'Guard', 28, 5);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Benjamin', 'Anderson', '1994-06-10', 192, 89, 27, 'Center', 17, 9);
INSERT INTO dbo.Player (PlayerFName, PlayerLName, DateOfBirth, PlayerHeight, PlayerWeight, PlayerAge, PlayerPosition, PlayerJerseyNum, PlayerExperience) VALUES ('Avery', 'Miller', '1999-03-08', 177, 73, 24, 'Forward', 4, 4);

---- PLAYERTEAM TABLE RECORDS ---
INSERT INTO dbo.PlayerTeam (PlayerID, TeamID) VALUES (1, 1);
INSERT INTO dbo.PlayerTeam (PlayerID, TeamID) VALUES (2, 2);
INSERT INTO dbo.PlayerTeam (PlayerID, TeamID) VALUES (3, 3);
INSERT INTO dbo.PlayerTeam (PlayerID, TeamID) VALUES (4, 1);
INSERT INTO dbo.PlayerTeam (PlayerID, TeamID) VALUES (5, 2);
INSERT INTO dbo.PlayerTeam (PlayerID, TeamID) VALUES (6, 3);
INSERT INTO dbo.PlayerTeam (PlayerID, TeamID) VALUES (7, 1);
INSERT INTO dbo.PlayerTeam (PlayerID, TeamID) VALUES (8, 2);
INSERT INTO dbo.PlayerTeam (PlayerID, TeamID) VALUES (9, 3);
INSERT INTO dbo.PlayerTeam (PlayerID, TeamID) VALUES (10, 1);
INSERT INTO dbo.PlayerTeam (PlayerID, TeamID) VALUES (11, 2);
INSERT INTO dbo.PlayerTeam (PlayerID, TeamID) VALUES (12, 3);


---- PLAYERCONTRACT TABLE RECORDS ---
INSERT INTO dbo.PlayerContract (ContractStartDate, ContractEndDate, PlayerSalary, PlayerID, TeamID) VALUES ('2023-01-01', '2023-12-31', 100000, 1, 1);
INSERT INTO dbo.PlayerContract (ContractStartDate, ContractEndDate, PlayerSalary, PlayerID, TeamID) VALUES ('2023-03-15', '2024-03-14', 80000, 2, 1);
INSERT INTO dbo.PlayerContract (ContractStartDate, ContractEndDate, PlayerSalary, PlayerID, TeamID) VALUES ('2023-07-01', '2024-06-30', 120000, 3, 1);
INSERT INTO dbo.PlayerContract (ContractStartDate, ContractEndDate, PlayerSalary, PlayerID, TeamID) VALUES ('2023-02-20', '2024-02-19', 85000, 4, 2);
INSERT INTO dbo.PlayerContract (ContractStartDate, ContractEndDate, PlayerSalary, PlayerID, TeamID) VALUES ('2023-06-10', '2024-06-09', 90000, 5, 2);
INSERT INTO dbo.PlayerContract (ContractStartDate, ContractEndDate, PlayerSalary, PlayerID, TeamID) VALUES ('2023-04-05', '2024-04-04', 75000, 6, 2);
INSERT INTO dbo.PlayerContract (ContractStartDate, ContractEndDate, PlayerSalary, PlayerID, TeamID) VALUES ('2023-01-01', '2023-12-31', 95000, 7, 3);
INSERT INTO dbo.PlayerContract (ContractStartDate, ContractEndDate, PlayerSalary, PlayerID, TeamID) VALUES ('2023-02-10', '2024-02-09', 110000, 8, 3);
INSERT INTO dbo.PlayerContract (ContractStartDate, ContractEndDate, PlayerSalary, PlayerID, TeamID) VALUES ('2023-05-20', '2024-05-19', 105000, 9, 3);
INSERT INTO dbo.PlayerContract (ContractStartDate, ContractEndDate, PlayerSalary, PlayerID, TeamID) VALUES ('2023-04-01', '2024-03-31', 70000, 10, 4);
INSERT INTO dbo.PlayerContract (ContractStartDate, ContractEndDate, PlayerSalary, PlayerID, TeamID) VALUES ('2023-07-15', '2024-07-14', 85000, 11, 4);
INSERT INTO dbo.PlayerContract (ContractStartDate, ContractEndDate, PlayerSalary, PlayerID, TeamID) VALUES ('2023-03-10', '2024-03-09', 80000, 12, 4);

---- INJURYHISTORY TABLE RECORDS ---
INSERT INTO dbo.InjuryHistory (InjuryType, InjuryDate, InjuryDesc, PlayerID) VALUES ('Sprain', '2023-02-05', 'Ankle sprain', 1);
INSERT INTO dbo.InjuryHistory (InjuryType, InjuryDate, InjuryDesc, PlayerID) VALUES ('Fracture', '2023-03-10', 'Arm fracture', 2);
INSERT INTO dbo.InjuryHistory (InjuryType, InjuryDate, InjuryDesc, PlayerID) VALUES ('Strain', '2023-04-15', 'Hamstring strain', 3);
INSERT INTO dbo.InjuryHistory (InjuryType, InjuryDate, InjuryDesc, PlayerID) VALUES ('Bruise', '2023-05-20', 'Knee bruise', 4);
INSERT INTO dbo.InjuryHistory (InjuryType, InjuryDate, InjuryDesc, PlayerID) VALUES ('Sprain', '2023-06-25', 'Wrist sprain', 5);
INSERT INTO dbo.InjuryHistory (InjuryType, InjuryDate, InjuryDesc, PlayerID) VALUES ('Fracture', '2023-07-30', 'Leg fracture', 6);
INSERT INTO dbo.InjuryHistory (InjuryType, InjuryDate, InjuryDesc, PlayerID) VALUES ('Strain', '2023-07-05', 'Back strain', 7);
INSERT INTO dbo.InjuryHistory (InjuryType, InjuryDate, InjuryDesc, PlayerID) VALUES ('Bruise', '2023-04-10', 'Elbow bruise', 8);
INSERT INTO dbo.InjuryHistory (InjuryType, InjuryDate, InjuryDesc, PlayerID) VALUES ('Sprain', '2022-10-15', 'Ankle sprain', 9);
INSERT INTO dbo.InjuryHistory (InjuryType, InjuryDate, InjuryDesc, PlayerID) VALUES ('Fracture', '2022-11-20', 'Hand fracture', 10);
INSERT INTO dbo.InjuryHistory (InjuryType, InjuryDate, InjuryDesc, PlayerID) VALUES ('Strain', '2022-12-25', 'Groin strain', 11);
INSERT INTO dbo.InjuryHistory (InjuryType, InjuryDate, InjuryDesc, PlayerID) VALUES ('Bruise', '2022-01-30', 'Shoulder bruise', 12);

---- GAME TABLE RECORDS ---
INSERT INTO dbo.Game (GameDate, GameTime, GameLocation, HomeTeamScore, AwayTeamScore, HomeTeamID, AwayTeamID, WinTeamID) VALUES ('2023-01-10', '18:00', 'Stadium A', 85, 78, 1, 2, 1);
INSERT INTO dbo.Game (GameDate, GameTime, GameLocation, HomeTeamScore, AwayTeamScore, HomeTeamID, AwayTeamID, WinTeamID) VALUES ('2023-02-15', '19:30', 'Stadium B', 92, 88, 2, 3, 2);
INSERT INTO dbo.Game (GameDate, GameTime, GameLocation, HomeTeamScore, AwayTeamScore, HomeTeamID, AwayTeamID, WinTeamID) VALUES ('2023-03-20', '17:45', 'Stadium C', 80, 95, 3, 1, 3);
INSERT INTO dbo.Game (GameDate, GameTime, GameLocation, HomeTeamScore, AwayTeamScore, HomeTeamID, AwayTeamID, WinTeamID) VALUES ('2023-04-12', '20:00', 'Stadium D', 75, 72, 4, 5, 4);
INSERT INTO dbo.Game (GameDate, GameTime, GameLocation, HomeTeamScore, AwayTeamScore, HomeTeamID, AwayTeamID, WinTeamID) VALUES ('2023-05-18', '18:15', 'Stadium E', 98, 94, 5, 6, 5);
INSERT INTO dbo.Game (GameDate, GameTime, GameLocation, HomeTeamScore, AwayTeamScore, HomeTeamID, AwayTeamID, WinTeamID) VALUES ('2023-06-22', '19:45', 'Stadium F', 82, 87, 6, 4, 6);
INSERT INTO dbo.Game (GameDate, GameTime, GameLocation, HomeTeamScore, AwayTeamScore, HomeTeamID, AwayTeamID, WinTeamID) VALUES ('2023-07-08', '18:30', 'Stadium G', 90, 85, 1, 3, 1);
INSERT INTO dbo.Game (GameDate, GameTime, GameLocation, HomeTeamScore, AwayTeamScore, HomeTeamID, AwayTeamID, WinTeamID) VALUES ('2023-08-13', '19:00', 'Stadium H', 75, 79, 4, 2, 2);
INSERT INTO dbo.Game (GameDate, GameTime, GameLocation, HomeTeamScore, AwayTeamScore, HomeTeamID, AwayTeamID, WinTeamID) VALUES ('2023-09-17', '20:15', 'Stadium I', 88, 90, 6, 1, 1);
INSERT INTO dbo.Game (GameDate, GameTime, GameLocation, HomeTeamScore, AwayTeamScore, HomeTeamID, AwayTeamID, WinTeamID) VALUES ('2023-10-11', '17:30', 'Stadium J', 82, 80, 3, 5, 3);
INSERT INTO dbo.Game (GameDate, GameTime, GameLocation, HomeTeamScore, AwayTeamScore, HomeTeamID, AwayTeamID, WinTeamID) VALUES ('2023-11-27', '19:45', 'Stadium K', 79, 85, 2, 6, 6);
INSERT INTO dbo.Game (GameDate, GameTime, GameLocation, HomeTeamScore, AwayTeamScore, HomeTeamID, AwayTeamID, WinTeamID) VALUES ('2023-12-20', '18:00', 'Stadium L', 91, 89, 5, 4, 5);

---- W_L_TABLE RECORDS ---
INSERT INTO dbo.W_L_TABLE (TEAMID, WinCount, LoseCount) VALUES (1, 1, 0);
INSERT INTO dbo.W_L_TABLE (TEAMID, WinCount, LoseCount) VALUES (2, 1, 0);
INSERT INTO dbo.W_L_TABLE (TEAMID, WinCount, LoseCount) VALUES (3, 0, 1);
INSERT INTO dbo.W_L_TABLE (TEAMID, WinCount, LoseCount) VALUES (4, 1, 0);
INSERT INTO dbo.W_L_TABLE (TEAMID, WinCount, LoseCount) VALUES (5, 0, 1);
INSERT INTO dbo.W_L_TABLE (TEAMID, WinCount, LoseCount) VALUES (6, 0, 0);
INSERT INTO dbo.W_L_TABLE (TEAMID, WinCount, LoseCount) VALUES (7, 1, 0);
INSERT INTO dbo.W_L_TABLE (TEAMID, WinCount, LoseCount) VALUES (8, 0, 1);
INSERT INTO dbo.W_L_TABLE (TEAMID, WinCount, LoseCount) VALUES (9, 1, 0);
INSERT INTO dbo.W_L_TABLE (TEAMID, WinCount, LoseCount) VALUES (10, 0, 0);
INSERT INTO dbo.W_L_TABLE (TEAMID, WinCount, LoseCount) VALUES (11, 1, 0);
INSERT INTO dbo.W_L_TABLE (TEAMID, WinCount, LoseCount) VALUES (12, 0, 1);

---- GAMESTATS TABLE RECORDS ---
INSERT INTO dbo.GameStats (GamePoints, GameRebounds, GameAssists, GameBlocks, GameSteals, GameID, PlayerID) VALUES (25, 10, 5, 2, 3, 1, 1);
INSERT INTO dbo.GameStats (GamePoints, GameRebounds, GameAssists, GameBlocks, GameSteals, GameID, PlayerID) VALUES (18, 6, 8, 1, 2, 1, 2);
INSERT INTO dbo.GameStats (GamePoints, GameRebounds, GameAssists, GameBlocks, GameSteals, GameID, PlayerID) VALUES (22, 12, 3, 4, 1, 1, 3);
INSERT INTO dbo.GameStats (GamePoints, GameRebounds, GameAssists, GameBlocks, GameSteals, GameID, PlayerID) VALUES (30, 8, 4, 3, 2, 1, 4);
INSERT INTO dbo.GameStats (GamePoints, GameRebounds, GameAssists, GameBlocks, GameSteals, GameID, PlayerID) VALUES (16, 5, 10, 1, 4, 1, 5);
INSERT INTO dbo.GameStats (GamePoints, GameRebounds, GameAssists, GameBlocks, GameSteals, GameID, PlayerID) VALUES (12, 9, 6, 2, 1, 2, 1);
INSERT INTO dbo.GameStats (GamePoints, GameRebounds, GameAssists, GameBlocks, GameSteals, GameID, PlayerID) VALUES (14, 7, 5, 1, 3, 2, 2);
INSERT INTO dbo.GameStats (GamePoints, GameRebounds, GameAssists, GameBlocks, GameSteals, GameID, PlayerID) VALUES (20, 3, 7, 1, 2, 2, 3);
INSERT INTO dbo.GameStats (GamePoints, GameRebounds, GameAssists, GameBlocks, GameSteals, GameID, PlayerID) VALUES (28, 4, 5, 2, 1, 2, 4);
INSERT INTO dbo.GameStats (GamePoints, GameRebounds, GameAssists, GameBlocks, GameSteals, GameID, PlayerID) VALUES (15, 6, 9, 3, 2, 2, 5);
INSERT INTO dbo.GameStats (GamePoints, GameRebounds, GameAssists, GameBlocks, GameSteals, GameID, PlayerID) VALUES (10, 8, 2, 1, 3, 3, 1);
INSERT INTO dbo.GameStats (GamePoints, GameRebounds, GameAssists, GameBlocks, GameSteals, GameID, PlayerID) VALUES (24, 3, 6, 2, 2, 3, 2);

---- TEAMROSTER TABLE RECORDS ---
-- Game 1
INSERT INTO dbo.TeamRoster (TeamID, PlayerID, GameID) VALUES (1, 1, 1);
INSERT INTO dbo.TeamRoster (TeamID, PlayerID, GameID) VALUES (1, 2, 1);
INSERT INTO dbo.TeamRoster (TeamID, PlayerID, GameID) VALUES (1, 3, 1);
INSERT INTO dbo.TeamRoster (TeamID, PlayerID, GameID) VALUES (2, 4, 1);
INSERT INTO dbo.TeamRoster (TeamID, PlayerID, GameID) VALUES (2, 5, 1);
INSERT INTO dbo.TeamRoster (TeamID, PlayerID, GameID) VALUES (2, 6, 1);
INSERT INTO dbo.TeamRoster (TeamID, PlayerID, GameID) VALUES (3, 7, 1);
INSERT INTO dbo.TeamRoster (TeamID, PlayerID, GameID) VALUES (3, 8, 1);
INSERT INTO dbo.TeamRoster (TeamID, PlayerID, GameID) VALUES (3, 9, 1);
INSERT INTO dbo.TeamRoster (TeamID, PlayerID, GameID) VALUES (1, 10, 1);
INSERT INTO dbo.TeamRoster (TeamID, PlayerID, GameID) VALUES (2, 11, 1);
INSERT INTO dbo.TeamRoster (TeamID, PlayerID, GameID) VALUES (3, 12, 1);

---- SEASONSTATS TABLE RECORDS ---
INSERT INTO dbo.SeasonStats (PlayerID, PointsPerGame, AssistsPerGame, StealsPerGame, BlocksPerGame, ReboundsPerGame)
VALUES
    (1, 20, 5, 2, 1, 8),
    (2, 18, 4, 1, 0, 6),
    (3, 15, 6, 3, 2, 7),
    (4, 22, 3, 2, 1, 10),
    (5, 12, 8, 4, 0, 5),
    (6, 25, 7, 3, 1, 9),
    (7, 17, 4, 2, 1, 7),
    (8, 19, 5, 1, 0, 6),
    (9, 14, 6, 3, 2, 8),
    (10, 21, 3, 2, 1, 11),
    (11, 13, 8, 4, 0, 5),
    (12, 24, 7, 3, 1, 10);

-----------------------------------------Utility Functions, Procedures----------------------------------------------------------------------------------

-- calculate the age of players automatically
update dbo.Player
set PlayerAge = DATEDIFF(hour, DateOfBirth, GETDATE())/8766;


-- function to determin which team wins 
GO
CREATE FUNCTION WhichTeamWin(@HomeTeamScore INT, @AwayTeamScore INT, @HomeTeamID INT, @AwayTeamID INT)
RETURNS INT
AS
BEGIN
      DECLARE @WinTeamID INT 
	  SET @WinTeamID = 
	  CASE 
	     WHEN @HomeTeamScore > @AwayTeamScore THEN @HomeTeamID
	     WHEN @HomeTeamScore < @AwayTeamScore THEN @AwayTeamID
	  END;
      RETURN @WinTeamID;
END
GO

-- Procedure to  compute and update column WinTeamID for given gameid based on WhichTeamWin function
CREATE PROCEDURE updateWinTeam @GameID int
AS
UPDATE  dbo.Game
SET WinTeamID = (dbo.WhichTeamWin(HomeTeamScore, AwayTeamScore, HomeTeamID, AwayTeamID))
WHERE GameID = @GameID;

-- Function to calculate the number of win, can be used to verify W_L_Table 
GO
CREATE FUNCTION WinCountFun(@TID INT)
RETURNS INT
AS
BEGIN
     DECLARE @COUNT INT =
        (SELECT COUNT(WinTeamID)
         FROM dbo.Game
         WHERE WinTeamID = @TID);
     SET @count = ISNULL(@count, 0);
     RETURN @count;
END
GO 

------------------------------------------------------------------------------Triggers---------------------------------------------------------------------------------------


CREATE TRIGGER trgWLUpdate
ON dbo.Game
AFTER INSERT,UPDATE,DELETE
AS	
	IF (EXISTS(SELECT * FROM INSERTED) AND EXISTS(SELECT * FROM DELETED))
	BEGIN
	     -- Updated 
		DECLARE @WinTeamID INT;
		DECLARE @LoseTeamID INT;
		DECLARE @hometeamscore INT;
		DECLARE @awayteamscore INT;
		DECLARE @homeTeamID INT;
		DECLARE @awayTeamID INT;
		SELECT @hometeamscore = INSERTED.HomeTeamScore, @awayteamscore =INSERTED.AwayTeamScore, 
		@homeTeamID = INSERTED.HomeTeamScore, @awayTeamID = INSERTED.AwayTeamID FROM INSERTED;
		SET @WinTeamID = dbo.WhichTeamWin(@hometeamscore, @awayteamscore, 
		@homeTeamID, @awayTeamID);
		IF(@WinTeamID = @homeTeamID)
			SET @LoseTeamID =  @awayTeamID; 
		ELSE
			SET @LoseTeamID = @homeTeamID;	
	
		-- don't do anything in case of insert w/o update as it is for a future game
		-- don't do anything in case of delete
	END
	
	IF ((@WinTeamID IS NOT NULL) AND (@LoseTeamID IS NOT NULL))
	BEGIN
		UPDATE dbo.W_L_Table
		SET WinCount = WinCount+1
		WHERE TeamID = @WinTeamID
		
		UPDATE dbo.W_L_Table
		SET LoseCount = LoseCount+1
		WHERE TEAMID = @LoseTeamID
	END;

CREATE TRIGGER trg_UpdateInjuryStatus
ON dbo.InjuryHistory
AFTER INSERT
AS
BEGIN
    UPDATE p
    SET p.InjuryStatus = 
        CASE 
            WHEN EXISTS (SELECT 1 FROM inserted i WHERE i.PlayerID = p.PlayerID)
            THEN 'yes'
            ELSE 'no'
        END
    FROM dbo.Player p
    INNER JOIN inserted i ON p.PlayerID = i.PlayerID;
END;


CREATE TRIGGER trg_UpdateInjuryStatusOnDelete
ON dbo.InjuryHistory
AFTER DELETE
AS
BEGIN
    UPDATE p
    SET p.InjuryStatus = 'no'
    FROM dbo.Player p
    INNER JOIN deleted d ON p.PlayerID = d.PlayerID;
END;

CREATE TRIGGER trg_AutoCalculateStats
ON dbo.GameStats
AFTER INSERT
AS
BEGIN
    DECLARE @PlayerID INT;

    -- Get the PlayerID for the newly inserted row
    SELECT @PlayerID = PlayerID FROM inserted;

    -- Update the statistics in the SeasonStats table using the ComputePlayerStats function
    UPDATE ss
    SET 
        ss.PointsPerGame = cs.AvgPoints,
        ss.AssistsPerGame = cs.AvgAssists,
        ss.ReboundsPerGame = cs.AvgRebounds,
        ss.StealsPerGame = cs.AvgSteals,
        ss.BlocksPerGame = cs.AvgBlocks
    FROM dbo.SeasonStats ss
    INNER JOIN dbo.ComputePlayerStats(@PlayerID) cs ON ss.PlayerID = cs.PlayerID
    WHERE ss.PlayerID = @PlayerID;
END;
--------------------------------------------------VIEWS--------------------------------------------------
/* Description: Views to get the details of top 5 performing players based on seasonstats*/ 
    
CREATE VIEW TOP5SEASONSTATS_points
AS
	SELECT TOP 5 p.PlayerFName,p.PlayerLName,p.PlayerPosition,ss.PointsPerGame
	FROM dbo.Player p
	JOIN dbo.SeasonStats ss
	ON p.PlayerID = ss.PlayerID
	ORDER BY ss.PointsPerGame DESC

CREATE VIEW TOP5SEASONSTATS_assists
AS
	SELECT TOP 5 p.PlayerFName,p.PlayerLName,p.PlayerPosition,ss.AssistsPerGame
	FROM dbo.Player p
	JOIN dbo.SeasonStats ss
	ON p.PlayerID = ss.PlayerID
	ORDER BY ss.AssistsPerGame DESC

CREATE VIEW TOP5SEASONSTATS_blocks
AS
	SELECT TOP 5 p.PlayerFName,p.PlayerLName,p.PlayerPosition,ss.BlocksPerGame
	FROM dbo.Player p
	JOIN dbo.SeasonStats ss
	ON p.PlayerID = ss.PlayerID
	ORDER BY ss.BlocksPerGame DESC

CREATE VIEW TOP5SEASONSTATS_steals
AS
	SELECT TOP 5 p.PlayerFName,p.PlayerLName,p.PlayerPosition,ss.StealsPerGame
	FROM dbo.Player p
	JOIN dbo.SeasonStats ss
	ON p.PlayerID = ss.PlayerID
	ORDER BY ss.StealsPerGame DESC
	
CREATE VIEW TOP5SEASONSTATS_rebounds
AS
	SELECT TOP 5 p.PlayerFName,p.PlayerLName,p.PlayerPosition,ss.ReboundsPerGame
	FROM dbo.Player p
	JOIN dbo.SeasonStats ss
	ON p.PlayerID = ss.PlayerID
	ORDER BY ss.ReboundsPerGame DESC
	
	
CREATE VIEW dbo.PlayerStatsView AS
SELECT 
    P.PlayerID,
    P.PlayerFName + ' ' + P.PlayerLName AS PlayerFullName,
    PT.TeamID,
    T.TeamName,
    AVG(GS.GamePoints) AS AvgPointsPerGame,
    AVG(GS.GameRebounds) AS AvgReboundsPerGame,
    AVG(GS.GameAssists) AS AvgAssistsPerGame,
    AVG(GS.GameSteals) AS AvgStealsPerGame,
    AVG(GS.GameBlocks) AS AvgBlocksPerGame,
    PC.ContractID,
    PC.ContractStartDate,
    PC.ContractEndDate,
    PC.PlayerSalary,
    IH.InjuryID,
    IH.InjuryType,
    IH.InjuryDate,
    IH.InjuryDesc
FROM Player AS P
JOIN PlayerTeam AS PT ON P.PlayerID = PT.PlayerID
JOIN Team AS T ON PT.TeamID = T.TeamID
LEFT JOIN GameStats AS GS ON P.PlayerID = GS.PlayerID
LEFT JOIN PlayerContract AS PC ON P.PlayerID = PC.PlayerID AND PT.TeamID = PC.TeamID
LEFT JOIN InjuryHistory AS IH ON P.PlayerID = IH.PlayerID
GROUP BY P.PlayerID, P.PlayerFName, P.PlayerLName, PT.TeamID, T.TeamName, PC.ContractID, 
PC.ContractStartDate, PC.ContractEndDate, PC.PlayerSalary, IH.InjuryID, 
IH.InjuryType, IH.InjuryDate, IH.InjuryDesc;