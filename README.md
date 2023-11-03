# SportsLeagueMngmt
SQL database designed to run a sports league, storing essential data used in the day-to-day functions

![image](https://github.com/sashank1079/SportsLeagueMngmt/assets/122720872/01cc69b9-524f-4833-88cc-8f3d188605a8)

ERD diagram depicts all the entities and relationships between the entities. 

Business problems being addressed:
The database addresses several business problems related to player management in a sports league. Some of the key problems being addressed are:
1.	Inefficient player registration process: A one-to-one relationship exists between this object and other entities like player profiles, player teams, team rosters, player contracts, per-game statistics, per-season statistics, and injury histories. This entity's primary key serves as a foreign key for each of the mentioned entities.

2.	Disorganized team management: The management of teams may become disjointed and chaotic in the absence of a central database. Keeping track of player assignments, transfers, availability, and communication can be difficult for coaches and team personnel. This issue is resolved by the database, which provides a thorough team administration system that enables team staff to effectively assemble teams, keep track of player availability, promote communication, and maintain current team rosters.



3.	Lack of player performance and statistical insights: It might be difficult to track player performance and league statistics without a dedicated database. It can be challenging for league executives and team personnel to analyze player data, produce reports, and make data-driven choices. This problem is addressed by the database, which records information on individual player performance, team standings, and league-wide statistics. Administrators and club personnel may quickly access and analyze this data in order to get useful insights, spot trends, and make defensible decisions that will raise the caliber of the league.

4.	Communication gaps with players and families: In a sports league, effective communication is essential, but without a centralized system, it can be difficult to have open lines of communication with players and their families. Using the database, league executives and team personnel may effectively share crucial information including game schedules, practice updates, and league announcements. This fills up communication gaps and guarantees that all league participants are informed.


5.	Lack of data-driven decision-making: The league may make decisions based on anecdotal evidence or subjective judgment in the absence of a thorough database. By delivering precise and up-to-date data on player registrations, team administration, and statistics tracking, the database supports data-driven decision-making. In order to choose players, formulate team plans, and enhance the league, administrators and team staff can analyze this data.

The database substantially improves the effectiveness, organization, and decision-making processes inside a sports league by solving these business issues. It simplifies administrative procedures, enhances communication, and offers insightful data that helps the league succeed and expand overall.
Business rules:
1.	Each player has a unique ID and attributes like name, date of birth, height, weight, and age.
2.	Players have relationships with profiles, teams, rosters, contracts, stats, and injuries.
3.	Player profiles store position, jersey number, and experience level.
4.	Player-team relationships link players and teams.
5.	Teams have unique IDs, names, and locations.
6.	Teams have relationships with player-team, coach, contracts, roster, and win/loss tables.
7.	Coach IDs are unique, and they have names, contact info, and email addresses.
8.	Games have unique IDs, dates, times, and locations.
9.	Games have relationships with results and rosters.
10.	Results include scores, winning and losing team IDs.
11.	Rosters link games, teams, and players.
12.	Contracts have unique IDs and include player and team references, start/end dates, and salary.
13.	Injuries have unique IDs, player references, types, dates, and descriptions.
14.	Game stats have unique IDs, player and game references, and statistics like points, rebounds, assists, blocks, and steals.
15.	Season stats have unique IDs, player and game references, season year, and automatically calculated statistics.
Design Requirements (Credit to Professor Simon Wang):
• Use Crow's Foot Notation.
• Specify the primary key fields in each table by specifying PK beside the fields.
• Draw a line between the fields of each table to show the relationships between each table. This line should be pointe directly to the fields in each table that are used to form the relationship.
• Specify which table is on the one side of the relationship by placing a one next to the field where the Iine starts.
• Specify which table is on the many side of the relationship by placing a crow's feet symbol next to the field where the line ends.
Entities in the database:
1.	Player:
Description- This entity will consist of the primary key which is Player ID, and its attributes               include the player’s First Name, Last Name, Date of Birth, Height, Weight, and Age (automatically calculated from the Date of Birth).
Relationship- This entity has a one-to-one relationship with Player Profile, Player-Team, Player Contracts, Per Game Stats, Per Season Stats, and one to many relationship with Team Roster, Injury History. It has a zero or one relationship with season stats. The listed entities all use this entity's primary key as a foreign key.
2.	Player Profile:
Description- The Player ID serves as a foreign key referencing the Player entity, with additional attributes including Position, Jersey Number, and Experience Level.
Relationship- This entity has a one-to-one relationship with the player entity sourcing its primary key.
3.	Player-Team:
Description- It consists of the Player ID and Team ID as primary keys.
Relationship- It has one to one relationship with the player and team entity acting as a mediating entity.
4.	Team: 
Description- A team's primary key is their Team ID, and their attributes include their Team Name and Location.
Relationship- This entity has a one-to-one relationship with Player-Team, Team-coach, W/L table. One to many relationships with Game, Player Contracts, Team Roster.


5.	 Team-Coach:
Description- It consists of the Coach ID and Team ID as primary keys.
Relationship- It has one to one relationship with the coach and team entity acting as a mediating entity.
6.	Coach:
Description- A Coach's primary key is their Coach ID, and their attributes include their First Name, Last Name, Contact Number, and Email Address.
Relationship- It has one to one relationship with the team-coach.
7.	 Game:
Description- A game's primary key is its Game ID, and it is associated with attributes such as Date, Time, and Location.
Relationship- It has one to one relationship with the Game Result, Team Roster, W/L table and GameStats. One to many with Team.
8.	Game Result:
Description- A game's attributes consist of its Game ID (foreign key referencing Game), Home Team Score, Away Team Score, Winning Team ID, and Losing Team ID.

Relationship- It has one to one relationship with the Game.

9.	Team Roster:
Description- A roster entry is uniquely identified by the Roster ID and includes the Game ID, Team ID, and Player ID as foreign keys referencing the Game, Team, and Player respectively.
Relationship- It is linked with Game, Team and Player entities.
10.	Player Contracts:
Description- A contract is uniquely identified by its Contract ID and includes references to the Player ID and Team ID, along with the Start Date, End Date, and Salary.
Relationship- It is linked with Team and Player entities with many to one relationship. 
11.	Injury History:
Description- An injury's primary key is the Injury ID, and its attributes include the Player ID as a foreign key, Injury Type, Date, and Description.
Relationship- It is linked with Player entity with a one-to-many relationship.
12.	Per Game Stats:
Description- A statistics record is uniquely identified by its Statistics ID and includes Player ID and Game ID as foreign keys, along with the attributes of Points, Rebounds, Assists, Blocks, and Steals.
Relationship- It is linked with Game and Player entities with one-to-one relationships.


13.	Per Season Stats:
Description- A Statistics ID serves as the primary key, with attributes including Player ID, Game ID, Season year, Points Per Game, Rebounds Per Game, Assists Per Game, Steals Per Game and Blocks Per Game are auto-calculated.
Relationship- It is linked with Player entity one to one relationship.
14.	W/L Table
Description- The table consists of a primary key, Table ID, a foreign key -Team ID referencing Team, and attributes such as Wins (total count of winning team ID instances), Losses (total count of losing team ID instances), and draws.
Relationship- It is linked with Game result entity having a one-to-one relationship.

