/** Creating Tables and copy data*/

CREATE TABLE Results (
Match_date Date NOT NULL,
home_team VARCHAR (50) NOT NULL,
away_team VARCHAR (50) NOT NULL,
home_score INT NOT NULL,
away_score INT NOT NULL,
tournament VARCHAR (100) NOT NULL,
city VARCHAR (100) NOT NULL,
country VARCHAR (100) NOT NULL,
Draw VARCHAR (50) NOT NULL,
winner VARCHAR (100) NOT NULL,
loser VARCHAR (100) NOT NUll,
Unbiased_country VARCHAR (100) NOT NUll)

Copy results (Match_date,home_team,away_team,home_score,away_score,tournament,city,country,
			  Draw,Winner,loser,Unbiased_country
)
FROM 'E:\Home pc\All\Studying\Knowledge\DATA TRACK\Projects\Sherif\Football\archive\results.csv'
DELIMITER ';'
CSV HEADER;

CREATE TABLE shootouts (
    Match_date DATE NOT NULL,
	home_team VARCHAR (100) NOT NULL,
	away_team VARCHAR (100) NOT NULL,
	winner VARCHAR (100) NOT NULL,
	Loser VARCHAR (100) NOT NULL
)

Copy shootouts (Match_date,home_team,away_team,Winner,loser)
FROM 'E:\Home pc\All\Studying\Knowledge\DATA TRACK\Projects\Sherif\Football\archive\shootouts.csv'
DELIMITER ';'
CSV HEADER;


/**     Q: Which team has the most winning matches ?*/

SELECT winner, Count(winner)
FROM results
Group BY 1
Having winner != 'Draw'
ORDER BY 2 DESC
Limit 1

/**     Q: Which team has the most lost matches ?*/

SELECT Loser, Count(Loser)
FROM results
Group BY 1
Having loser != 'Draw'
ORDER BY 2 DESC
Limit 1

/**     Q: Which team has the most draw matches ?*/
/** First Solution*/
SELECT home_team AS Team, (T1.number_of_draws_as_home+T2.number_of_draws_as_away) AS Total_number_of_draws
FROM
(SELECT home_team, Count (*) AS number_of_draws_as_home
FROM results
Where Draw = 'TRUE'
GROUP BY 1
ORDER BY 2 DESC) AS T1
JOIN
(SELECT away_team, Count (*) number_of_draws_as_away
FROM results
Where Draw = 'TRUE'
GROUP BY 1
ORDER BY 2 DESC) AS T2
ON T1.home_team = T2.away_team
GROUP BY 1,2
ORDER BY 2 DESC
LIMIT 1

/** Second Solution*/
/** Step 1*/
CREATE VIEW home_draw AS
SELECT home_team, Count (*) AS number_of_draws_as_home
FROM results
Where Draw = 'TRUE'
GROUP BY 1
ORDER BY 2 DESC
/** Step 2*/
CREATE VIEW away_draw AS
SELECT away_team, Count (*) number_of_draws_as_away
FROM results
Where Draw = 'TRUE'
GROUP BY 1
ORDER BY 2 DESC
/** Step 3*/
SELECT home_team AS Team, (home_draw.number_of_draws_as_home+away_draw.number_of_draws_as_away) AS Total_number_of_draws
FROM home_draw
JOIN away_draw
ON home_draw.home_team = away_draw.away_team
GROUP BY 1,2
ORDER BY 2 DESC
LIMIT 1

/**     Q: Which team has most winning matches with shootouts?*/

SELECT winner, Count(winner)
FROM shootouts
Group BY 1
Having winner != 'Draw'
ORDER BY 2 DESC
Limit 1

/**     Q: Which team has most lost matches with shootouts?*/

SELECT Loser, Count(Loser)
FROM shootouts
Group BY 1
Having loser != 'Draw'
ORDER BY 2 DESC
Limit 1


/**     Q: Which team has the most scoring goals?*/

SELECT T6.Team_as_a_home_team AS Team, (T6.Total_goals_As_A_Home_Team+T6.Total_goals_As_An_Away_Team)
FROM
(SELECT *
FROM
(Select T3.Home_Team_Neutral_Land AS Team_as_a_home_team,T3.Total_goals_As_A_Home_Team
FROM
(Select T1.Home_Team_Neutral_Land, T2.Home_Team_Home_Land, (home_goals_outside+home_goals_inside) AS Total_goals_As_A_Home_Team
From
(Select home_team AS Home_Team_Neutral_Land, SUM(home_score) AS home_goals_outside,Unbiased_country AS Neutarl_Land
FROM results
GROUP BY 1,3
HAVING Unbiased_country = 'TRUE'
ORDER BY 2 DESC) AS T1
Join
(Select home_team AS Home_Team_Home_Land, SUM(home_score) AS home_goals_inside,Unbiased_country AS Home_Land
FROM results
GROUP BY 1,3
HAVING Unbiased_country = 'FALSE'
ORDER BY 2 DESC) AS T2
ON T1.Home_Team_Neutral_Land = T2.Home_Team_Home_Land
GROUP BY 1,2,3
ORDER BY 3 DESC) AS T3) T4
Join
(Select T3.Away_Team_Neutral_Land AS Team_as_an_away_team,T3.Total_goals_As_An_Away_Team
FROM
(Select T1.Away_Team_Neutral_Land, T2.Away_Team_Away_Land, (away_goals_neutral_land+away_goals_away_land) AS Total_goals_As_An_Away_Team
From
(Select away_team AS Away_Team_Neutral_Land, SUM(away_score) AS away_goals_neutral_land,Unbiased_country AS Neutarl_Land
FROM results
GROUP BY 1,3
HAVING Unbiased_country = 'TRUE'
ORDER BY 2 DESC) AS T1
Join
(Select away_team AS Away_Team_Away_Land, SUM(away_score) AS away_goals_away_land,Unbiased_country AS Away_Land
FROM results
GROUP BY 1,3
HAVING Unbiased_country = 'FALSE'
ORDER BY 2 DESC) AS T2
ON T1.Away_Team_Neutral_Land = T2.Away_Team_Away_Land
GROUP BY 1,2,3
ORDER BY 3 DESC) AS T3) AS T5
ON T4.Team_as_a_home_team = T5.Team_as_an_away_team) AS T6
GROUP BY 1,2
ORDER BY 2 DESC
LIMIT 1

/**     Q: Which team has the most scoring As a home team?*/

Select T3.Home_Team_Neutral_Land AS Team_as_a_home_team,T3.Total_goals_As_A_Home_Team
FROM
(Select T1.Home_Team_Neutral_Land, T2.Home_Team_Home_Land, (home_goals_outside+home_goals_inside) AS Total_goals_As_A_Home_Team
From
(Select home_team AS Home_Team_Neutral_Land, SUM(home_score) AS home_goals_outside,Unbiased_country AS Neutarl_Land
FROM results
GROUP BY 1,3
HAVING Unbiased_country = 'TRUE'
ORDER BY 2 DESC) AS T1
Join
(Select home_team AS Home_Team_Home_Land, SUM(home_score) AS home_goals_inside,Unbiased_country AS Home_Land
FROM results
GROUP BY 1,3
HAVING Unbiased_country = 'FALSE'
ORDER BY 2 DESC) AS T2
ON T1.Home_Team_Neutral_Land = T2.Home_Team_Home_Land
GROUP BY 1,2,3
ORDER BY 3 DESC) AS T3
LIMIT 1

/**     Q: Which team has the most scoring As a away team?*/

Select T3.Away_Team_Neutral_Land AS Team_as_an_away_team,T3.Total_goals_As_An_Away_Team
FROM
(Select T1.Away_Team_Neutral_Land, T2.Away_Team_Away_Land, (away_goals_neutral_land+away_goals_away_land) AS Total_goals_As_An_Away_Team
From
(Select away_team AS Away_Team_Neutral_Land, SUM(away_score) AS away_goals_neutral_land,Unbiased_country AS Neutarl_Land
FROM results
GROUP BY 1,3
HAVING Unbiased_country = 'TRUE'
ORDER BY 2 DESC) AS T1
Join
(Select away_team AS Away_Team_Away_Land, SUM(away_score) AS away_goals_away_land,Unbiased_country AS Away_Land
FROM results
GROUP BY 1,3
HAVING Unbiased_country = 'FALSE'
ORDER BY 2 DESC) AS T2
ON T1.Away_Team_Neutral_Land = T2.Away_Team_Away_Land
GROUP BY 1,2,3
ORDER BY 3 DESC) AS T3
LIMIT 1

/** Q: What is the average score in the history?*/
Select T1.Total_goals/T1.Total_matches
FROM
(Select Count(*) AS Total_matches, (Sum(home_score)+Sum(away_score)) AS Total_goals
FROM Results) AS T1
/** Q: What is the team with highest average?*/
Create View T1 AS
Select Home_team, Count(*) AS Total_matches, (Sum(home_score)) AS Total_goals_home
FROM Results
GROUP BY 1
ORDER BY  2 DESC
Create View T2 AS
Select away_team, Count(*) AS Total_matches, (Sum(away_score)) AS Total_goals_away
FROM Results
GROUP BY 1
ORDER BY  2 DESC
Select T1.home_team, T2.away_team,
(T1.total_goals_home+T2.total_goals_away) AS Total_goals,
(T1.total_matches+T2.total_matches) AS total_matches,
((T1.total_goals_home+T2.total_goals_away)/(T1.total_matches+T2.total_matches)) AS Average_Goals
FROM T1
JOIN T2
ON T1.home_team = T2.away_team
GROUP BY 1,2,3,4
ORDER BY  5 DESC
LIMIT 1
/** Q: What is the team with lowest average?*/
Create View T1 AS
Select Home_team, Count(*) AS Total_matches, (Sum(home_score)) AS Total_goals_home
FROM Results
GROUP BY 1
ORDER BY  2 DESC
Create View T2 AS
Select away_team, Count(*) AS Total_matches, (Sum(away_score)) AS Total_goals_away
FROM Results
GROUP BY 1
ORDER BY  2 DESC
Select T1.home_team, T2.away_team,
(T1.total_goals_home+T2.total_goals_away) AS Total_goals,
(T1.total_matches+T2.total_matches) AS total_matches,
((T1.total_goals_home+T2.total_goals_away)/(T1.total_matches+T2.total_matches)) AS Average_Goals
FROM T1
JOIN T2
ON T1.home_team = T2.away_team
GROUP BY 1,2,3,4
ORDER BY  5 
LIMIT 1
/** Q: What is the most team played matches in the history?*/

Create view home_team_matches AS
Select Home_Team, count(home_team) AS Home_play
From Results
GROUP BY 1
ORDER BY 2 DESC

Create view away_team_matches AS
Select away_Team, count(away_team) AS Away_play
From Results
GROUP BY 1
ORDER BY 2 DESC

Select home_team_matches.home_team, away_team_matches.away_team, (home_team_matches.Home_play + away_team_matches.Away_play) AS total_matches
From home_team_matches
JOIN away_team_matches
ON home_team_matches.home_team = away_team_matches.away_Team
GROUP BY 1,2,3
ORDER BY 3 DESC
LIMIT 1
