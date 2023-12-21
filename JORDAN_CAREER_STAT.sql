--SELECT *
----INTO J_CAREER
--FROM JORDAN_CAREER;
----DATA DICTIONARY--
----game =	Season game
----date =	Date (yyyy-mm-dd)
----age =	Player's age (years-days)
----team =	Player's team
----opp =	Opponent
----result =	Win (W) or Loss (L) with the point differential in parenthesis
----mp =	Minutes played
----fg =	Field goals made
----fga =	Field goals attempted
----fgp =	Field goal percentage
----three =	3-point field goals made
----threeatt =	3-point field goals attempted
----threep =	3-point field goal percentage
----ft =	Free throws made
----fta =	Free throws attempted
----ftp =	Free throw percentage
----orb =	Offensive rebounds
----drb =	Defensive rebounds
----trb =	Total rebounds
----ast =	Assists
----stl =	Steals
----blk =	Blocks
----tov =	Turnovers
----pts =	Points scored
----game_score =	Statistical measure of a player's productivity for a single game
----plus_minus =	Statistical measure of a player's impact on the game, represented by the difference between 
--				--their team's total scoring versus their opponent's when the player is in the game
-- --COLUMN DESCRIPTION--
----Data Description--
--exec sp_columns JORDAN_CAREER;

----nos of rows--
--select count(*) Nos_of_Rows
--from JORDAN_CAREER;

----nos of columns--
--select count(*)columns
--from information_schema.columns
--where table_name = 'JORDAN_CAREER';

----CHECKING FOR NULL VALUES IN EACH COLUMNS
--SELECT COUNT(*) AS NULL_VALUES FROM JORDAN_CAREER 
--WHERE ftp  IS NULL;

--SELECT COUNT(*) AS NULL_VALUES FROM JORDAN_CAREER 
--WHERE threep  IS NULL;

--SELECT COUNT(*) AS NULL_VALUES FROM JORDAN_CAREER 
--WHERE plus_minus  IS NULL;

----CHECKING FOR DUPLICATES--
--SELECT GAME, COUNT(GAME) AS COUNT
--from JORDAN_CAREER
--group by GAME
--having COUNT(GAME) > 1;

----ADDITION OF NEW COLUMNS--
--ALTER TABLE J_CAREER
--ALTER COLUMN MATCH_RESULT VARCHAR(50);

--ALTER TABLE J_CAREER 
--ADD POINT_DIFF INT;

----DROP COLUMNS--
--ALTER TABLE J_CAREER
--DROP COLUMN RESULT,PLUS_MINUS,
--	THREE_POINT_GOALS_PERCENT;
		

----EXPUNGING PARENTHESIS FROM THE FIGURES IN RESULT COLUMN--
--UPDATE J_CAREER 
--SET RESULT = (SELECT REPLACE(REPLACE(RESULT,')',' '),'(',' ')
--				);
----POPULATING NEW COLUMNS AND FORMATTING THE FIELDS OF PREXISTING COLUMNS--
--UPDATE J_CAREER
--SET MATCH_RESULT = (SELECT SUBSTRING(RESULT,1,1) 
--				WHERE MATCH_RESULT IS NULL);

--UPDATE J_CAREER
--SET POINT_DIFF = (SELECT LTRIM(SUBSTRING(RESULT,3,4))
--					WHERE POINT_DIFF IS NULL);

--UPDATE J_CAREER
--SET MATCH_RESULT = (SELECT CASE 
--						WHEN MATCH_RESULT = 'W' THEN 'Win'
--						ELSE 'Lost'
--						END);

--UPDATE J_CAREER 
--SET GAME_SCORE = (SELECT ROUND(GAME_SCORE,2));

--UPDATE J_CAREER
--SET AGE = (SELECT SUBSTRING(AGE,1,2));

--UPDATE J_CAREER
--SET TEAM = (SELECT CASE WHEN TEAM = 'WAS' THEN 'Washington Wizard'
--					WHEN TEAM = 'CHI' THEN 'Chicago Bull'
--			END);

----REFORMATTING COLUMN HEADERS--
--EXEC SP_RENAME 'J_CAREER.game','GAME','COLUMN';
--EXEC SP_RENAME 'J_CAREER.date','DATE','COLUMN';
--EXEC SP_RENAME 'J_CAREER.age','AGE','COLUMN';
--EXEC SP_RENAME 'J_CAREER.team','TEAM','COLUMN';
--EXEC SP_RENAME 'J_CAREER.opp','OPPONENT','COLUMN';
--EXEC SP_RENAME 'J_CAREER.result','RESULT','COLUMN';
--EXEC SP_RENAME 'JORDAN_STAT.MATCH_PLAYED','MINUTES_PLAYED','COLUMN';
--EXEC SP_RENAME 'J_CAREER.fg','FIELD_GOALS','COLUMN';
--EXEC SP_RENAME 'J_CAREER.fga','FIELD_GOALS_ATTEMPTED','COLUMN';
--EXEC SP_RENAME 'J_CAREER.fgp','FIELD_GOALS_PERCENT','COLUMN';
--EXEC SP_RENAME 'J_CAREER.three','THREE_POINT_FIELD_GOALS','COLUMN';
--EXEC SP_RENAME 'J_CAREER.threeatt','THREE_POINT_ATTEMPTED','COLUMN';
--EXEC SP_RENAME 'J_CAREER.threep','THREE_POINT_GOALS_PERCENT','COLUMN';
--EXEC SP_RENAME 'J_CAREER.ft','FREE_THROW_MADE','COLUMN';
--EXEC SP_RENAME 'J_CAREER.fta','FREE_THROW_ATTEMPTED','COLUMN';
--EXEC SP_RENAME 'J_CAREER.ftp','FREE_THROW_PERCENT','COLUMN';
--EXEC SP_RENAME 'J_CAREER.OFFENSIVE-REBOUND','OFFENSIVE_REBOUND','COLUMN';
--EXEC SP_RENAME 'J_CAREER.drb','DEFENSIVE_REBOUND','COLUMN';
--EXEC SP_RENAME 'J_CAREER.trb','TOTAL_REBOUND','COLUMN';
--EXEC SP_RENAME 'J_CAREER.ast','ASSIST','COLUMN';
--EXEC SP_RENAME 'J_CAREER.stl','STEAL','COLUMN';
--EXEC SP_RENAME 'J_CAREER.blk','BLOCKS','COLUMN';
--EXEC SP_RENAME 'J_CAREER.tov','TURN_OVER','COLUMN';
--EXEC SP_RENAME 'J_CAREER.pts','POINTS','COLUMN';
--EXEC SP_RENAME 'J_CAREER.game_score','GAME_SCORE','COLUMN';
--EXEC SP_RENAME 'J_CAREER.plus_minus','PLUS_MINUS','COLUMN';

----INSERTING THE AGGREGATED TABLE INTO A NEW TABLE 'JORDAN_STAT'--
--SELECT * 
--INTO JORDAN_STAT
--FROM(
--	SELECT GAME, DATE, AGE, J.TEAM, OPPONENT AS CODE_NAME,N.NAME, MATCH_PLAYED, MATCH_RESULT, FIELD_GOALS,FIELD_GOALS_ATTEMPTED,
--		FIELD_GOALS_PERCENT,THREE_POINT_FIELD_GOALS, THREE_POINT_ATTEMPTED,FREE_THROW_MADE, FREE_THROW_ATTEMPTED,FREE_THROW_PERCENT,
--		OFFENSIVE_REBOUND, DEFENSIVE_REBOUND,TOTAL_REBOUND,ASSIST, STEAL,BLOCKS,TURN_OVER,POINTS,POINT_DIFF, GAME_SCORE
--	FROM J_CAREER J
--	JOIN NBA_TEAMS N 
--	ON J.OPPONENT = N.TEAM)A;

--OBJECTIVES-
--Number of Season Played--
--Minutes played per game and total minutes played.
--Longevity of peak performance, indicated by years with high statistical achievements.
--Championships won and Finals appearances.
--Playoffs statistics and impact during crucial postseason games.
--Field goal percentage (FG%).
--Three-point percentage (3P%).
--Free throw percentage (FT%).
--Effective field goal percentage (eFG%) accounting for three-point shots being worth more than two-point shots.
--Total points scored throughout their career.
--Points per game (PPG) average.
--Scoring consistency over different periods of their career (prime years, later years, etc.).
--Points distribution by quarter or half to understand their impact in different game situations.
--Total assists and assists per game.
--Total rebounds and rebounds per game.
--Offensive and defensive rebounds to evaluate versatility.
--Steals per game and total steals.
--Blocks per game and total blocks.
--Defensive rating and opponents' field goal percentage when guarded by the player.

SELECT *
FROM JORDAN_STAT

--LONGETIVITY AND CONSISTENCY:
--Number of Seasons Played--
SELECT TEAM, COUNT(DISTINCT YEAR) AS SEASONS_PLAYED
FROM(SELECT TEAM,YEAR(DATE) AS YEAR
	FROM JORDAN_STAT)A
GROUP BY TEAM;

--Minutes played per game and total minutes played--
SELECT YEAR(DATE) AS SEASON, COUNT(DATE) AS MATCH_PLAYED, 
		SUM(MINUTES_PLAYED) AS TOTAL_MINUTES_PLAYED,AVG(MINUTES_PLAYED) AVG_MINUTES_PLAYED
FROM JORDAN_STAT
GROUP BY YEAR(DATE) 
ORDER BY SEASON ASC;

--Longevity of peak performance, indicated by years with high statistical achievements--
SELECT
    YEAR(DATE) AS SEASON,
    MAX(POINTS) AS MAX_POINT,
    MAX(TOTAL_REBOUND) AS MAX_TOTAL_REBOUND,
    MAX(ASSIST) AS MAX_ASSIST
FROM
    JORDAN_STAT

GROUP BY
    YEAR(DATE)
HAVING
   MAX(POINTS) >= 30
    AND MAX(TOTAL_REBOUND) >= 12
    AND MAX(ASSIST) >= 10
ORDER BY
    SEASON ASC;

--SCORING AND DISTRIBUTION--
--Total Career Points--
SELECT SUM(POINTS) AS CAREER_POINTS
FROM JORDAN_STAT;

--Points Per Season--
SELECT YEAR(DATE) AS SEASON, SUM(POINTS) AS SEASON_POINT
FROM JORDAN_STAT 
GROUP BY YEAR(DATE) 
ORDER BY SEASON ASC;

--Average Points Per Game--
SELECT AVG(POINTS) AS AVG_POINT 
FROM JORDAN_STAT;

--Total Goals Scored and Attempts--
SELECT SUM(FIELD_GOALS) AS CAREER_GOALS
FROM JORDAN_STAT;

SELECT SUM(FIELD_GOALS_ATTEMPTED) AS GOAL_ATTEMPTS
FROM JORDAN_STAT;

--Goals to Expected Goals Ratio--
SELECT ROUND(AVG(FIELD_GOALS_PERCENT),2) * 100 AS G_xG_RATIO
FROM JORDAN_STAT;

--Goals Scored per Season--
SELECT YEAR(DATE) AS SEASON, SUM(FIELD_GOALS) AS GOALS,
		SUM(FIELD_GOALS_ATTEMPTED) AS GOAL_ATTEMPTS,
		ROUND(AVG(FIELD_GOALS_PERCENT),2) AS G_xG_RATIO
FROM JORDAN_STAT
GROUP BY YEAR(DATE)
ORDER BY SEASON ASC;

--Scoring consistency--
SELECT COUNT(*) AS MATCHES_WITHOUT_GOAL
FROM JORDAN_STAT
WHERE FIELD_GOALS = 0;

--Scoring consistency over different periods of his career (prime years, later years, etc.)--
SELECT
    YEAR(DATE) AS SEASON,
    CASE
        WHEN YEAR(DATE) BETWEEN 1984 AND 1996 THEN 'Prime Years'
        ELSE 'Later Years'
    END AS CAREER_PERIOD,
	COUNT(GAME) AS MATCHES_PLAYED,
	SUM(FIELD_GOALS) AS SUM_GOALS,
	AVG(FIELD_GOALS) AS AVG_GOALS,
	SUM(POINTS) AS TOTAL_POINTS,
    AVG(POINTS) AS AVG_POINTS
FROM JORDAN_STAT
GROUP BY YEAR(DATE)
ORDER BY SEASON ASC;

--Wins and Loss against Opponents--
SELECT NAME AS OPPONENT, COUNT(NAME) AS MATCHES_PLAYED,
		COUNT(CASE WHEN MATCH_RESULT = 'WIN' THEN 1 END) AS WINS,
		COUNT(CASE WHEN MATCH_RESULT = 'LOST' THEN 1 END) AS LOSS
FROM JORDAN_STAT
GROUP BY NAME
ORDER BY WINS DESC;

--Total Free Throw Made--
SELECT SUM(FREE_THROW_MADE) AS TOTAL_FREE_THROW
FROM JORDAN_STAT;

--Total Free Throw Attempted--
SELECT SUM(FREE_THROW_ATTEMPTED) AS TOTAL_FREE_THROW
FROM JORDAN_STAT;

--Free Throw Ratio--
SELECT ROUND(SUM(FREE_THROW_PERCENT)/10,2) AS FREE_THROW_RATIO
FROM JORDAN_STAT;

--PLAYMAKING AND PASSING--
--Average Assist per Game--
SELECT AVG(ASSIST) as AVERAGE_ASSIST_PER_GAME 
FROM JORDAN_STAT;

--Total Assist per Season--
SELECT YEAR(DATE) AS SEASON, SUM(ASSIST) AS TOTAL_ASSIST
FROM JORDAN_STAT
GROUP BY YEAR(DATE) 
ORDER BY SEASON ASC;

--Total Career Assist--
SELECT SUM(ASSIST) AS CAREER_ASSIST
FROM JORDAN_STAT;

--Assist to Turnover Ratio--
SELECT SUM(ASSIST)/SUM(TURN_OVER) AS ASSIST_TURNOVER_RATIO
FROM JORDAN_STAT;

--REBOUNDING--
SELECT SUM(OFFENSIVE_REBOUND) AS OFFENSIVE_REBOUND, 
		SUM(DEFENSIVE_REBOUND) AS DEFENSIVE_REBOUND,
		(SUM(OFFENSIVE_REBOUND)  + SUM(DEFENSIVE_REBOUND)) AS TOTAL_REBOUND
FROM JORDAN_STAT;

--DEFENSIVE IMPACT--
--Steal per Game and Total Steal--
SELECT SUM(STEAL) AS TOTAL_STEAL
FROM JORDAN_STAT;

--Average Steals and Total Steals per Season
SELECT YEAR(DATE) AS SEASON, AVG(STEAL) AS AVG_STEAL, SUM(STEAL) AS TOTAL_STEAL
FROM JORDAN_STAT
GROUP BY YEAR(DATE) 
ORDER BY SEASON ASC;

--Block per Game and Total Blocks--
SELECT SUM(BLOCKS) AS TOTAL_BLOCKS
FROM JORDAN_STAT;

SELECT YEAR(DATE) AS SEASON, SUM(BLOCKS) AS TOTAL_BLOCKS
FROM JORDAN_STAT
GROUP BY YEAR(DATE) 
ORDER BY SEASON ASC;

---NBA TITLES---
SELECT YEAR(DATE) AS YEAR, COUNT(RESULT) AS TITLES
FROM JORDAN_PLAYOFFS 
WHERE SERIES_NAME = 'NBA FINALS'
GROUP BY YEAR(DATE);

--NBA AND EASTERN CONFERENCE FINALS--
SELECT SERIES_NAME, COUNT(SERIES_NAME) AS FINALS 
FROM JORDAN_PLAYOFFS 
WHERE SERIES_NAME IN ('NBA FINALS','EASTERN CONFERENCE (FINALS)')
GROUP BY SERIES_NAME 








SELECT * FROM JORDAN_STAT;
SELECT * FROM JORDAN_PLAYOFFS;
