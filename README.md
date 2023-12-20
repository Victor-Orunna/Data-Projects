# NBA CAREER ANALYSIS OF MICHAEL JORDAN
## PROFILE
Michael Jeffrey Jordan (born February 17, 1963), also known by his initial MJ, is an American former professional basketball player. He played fifteen seasons in the National Basketball Association (NBA) from 1984 to 2003, winning six NBA championship titles with the Chicago Bulls. His profile on the official NBA website states that "by acclamation, Michael Jordan is the greatest basketball player of all time." ~ Wikipaedia

## PROJECT OVERVIEW
This project aims to explore Jordan's NBA career statistics, by analyzing his match statistics to gain deeper understanding of his performance.

## DATA SOURCE 

Maven Analytics Data Playground 
- [Download Here](mavenanalytics.io/challenges)

## TOOLS

- SQL (Data Cleaning and Analysis)
- Power BI (Visualization)

## DATA CLEANING AND PREPARATION

- Handling Null Values:
  - Identified and addressed null values in specific columns.
    - Nulls in 'ftp', 'threep', and 'plus_minus' columns were counted and potentially handled based on the analysis requirements.
      
```sql
    SELECT COUNT(*) AS NULL_VALUES
    FROM JORDAN_CAREER 
    WHERE ftp  IS NULL;

    SELECT COUNT(*) AS NULL_VALUES
    FROM JORDAN_CAREER 
    WHERE threep  IS NULL;

    SELECT COUNT(*) AS NULL_VALUES
    FROM JORDAN_CAREER 
    WHERE plus_minus  IS NULL;
```
  
- Duplicate Detection and Resolution:
  - Detected and examined duplicate values in the 'GAME' column.
     - Potential actions could include removing duplicates or incorporating additional information to distinguish them.
```sql
SELECT GAME, COUNT(GAME) AS COUNT
FROM JORDAN_CAREER
GROUP BY GAME
HAVING COUNT(GAME) > 1;
```

- Column Addition and Deletion:
  - Added new columns:
    - 'MATCH_RESULT' (VARCHAR(50)) was added to store match outcomes.
    - 'POINT_DIFF' (INT) was added to store point differentials.
``` sql
ALTER TABLE J_CAREER
ALTER COLUMN MATCH_RESULT VARCHAR(50);

ALTER TABLE J_CAREER 
ADD POINT_DIFF INT;
```

- Dropped columns:
  - Removed 'RESULT', 'PLUS_MINUS', and 'THREE_POINT_GOALS_PERCENT' columns from the table.
```sql
ALTER TABLE J_CAREER
DROP COLUMN RESULT,PLUS_MINUS,
	THREE_POINT_GOALS_PERCENT;
```

- Text and Formatting Corrections:
  - Expunged parentheses from the 'RESULT' column:
    - Removed extraneous characters, making the data more consistent.
``` sql
UPDATE J_CAREER 
SET RESULT = (SELECT REPLACE(REPLACE(RESULT,')',' '),'(',' ')
```

- Data Transformation and Standardization:
  - Populated and formatted new columns:
    - 'MATCH_RESULT' was populated based on the first character of the 'RESULT' column.
    - 'POINT_DIFF' was populated by extracting a substring from the 'RESULT' column.
    - 'MATCH_RESULT' values were standardized to 'Win' or 'Lost'.
    - 'GAME_SCORE' values were rounded to two decimal places.
    - 'AGE' column values were standardized by extracting the first two characters.
    - 'TEAM' column values were standardized based on specified mappings.
```sql
UPDATE J_CAREER
SET MATCH_RESULT = (SELECT SUBSTRING(RESULT,1,1) 
				WHERE MATCH_RESULT IS NULL);

UPDATE J_CAREER
SET POINT_DIFF = (SELECT LTRIM(SUBSTRING(RESULT,3,4))
					WHERE POINT_DIFF IS NULL);

UPDATE J_CAREER
SET MATCH_RESULT = (SELECT CASE 
						WHEN MATCH_RESULT = 'W' THEN 'Win'
						ELSE 'Lost'
						END);

UPDATE J_CAREER 
SET GAME_SCORE = (SELECT ROUND(GAME_SCORE,2));

UPDATE J_CAREER
SET AGE = (SELECT SUBSTRING(AGE,1,2));

UPDATE J_CAREER
SET TEAM = (SELECT CASE WHEN TEAM = 'WAS' THEN 'Washington Wizard'
					WHEN TEAM = 'CHI' THEN 'Chicago Bull'
			END);
```

- Reformatting Existing Column Headers:

  - Executed stored procedures to rename columns for consistency and clarity in naming conventions.
    - Renamed 'J_CAREER.game' to 'GAME'.
    - Renamed 'J_CAREER.date' to 'DATE'.
    - Renamed 'J_CAREER.age' to 'AGE'.
    - Renamed 'J_CAREER.team' to 'TEAM'.
    - Renamed 'J_CAREER.opp' to 'OPPONENT'.
    - Renamed 'J_CAREER.result' to 'RESULT'.
    - Renamed 'JORDAN_STAT.MATCH_PLAYED' to 'MINUTES_PLAYED'.
    - Renamed other columns for consistency and improved readability
      
```sql
EXEC SP_RENAME 'J_CAREER.game','GAME','COLUMN';
EXEC SP_RENAME 'J_CAREER.date','DATE','COLUMN';
EXEC SP_RENAME 'J_CAREER.age','AGE','COLUMN';
EXEC SP_RENAME 'J_CAREER.team','TEAM','COLUMN';
EXEC SP_RENAME 'J_CAREER.opp','OPPONENT','COLUMN';
EXEC SP_RENAME 'J_CAREER.result','RESULT','COLUMN';
EXEC SP_RENAME 'JORDAN_STAT.MATCH_PLAYED','MINUTES_PLAYED','COLUMN';
EXEC SP_RENAME 'J_CAREER.fg','FIELD_GOALS','COLUMN';
EXEC SP_RENAME 'J_CAREER.fga','FIELD_GOALS_ATTEMPTED','COLUMN';
EXEC SP_RENAME 'J_CAREER.fgp','FIELD_GOALS_PERCENT','COLUMN';
EXEC SP_RENAME 'J_CAREER.three','THREE_POINT_FIELD_GOALS','COLUMN';
EXEC SP_RENAME 'J_CAREER.threeatt','THREE_POINT_ATTEMPTED','COLUMN';
EXEC SP_RENAME 'J_CAREER.threep','THREE_POINT_GOALS_PERCENT','COLUMN';
EXEC SP_RENAME 'J_CAREER.ft','FREE_THROW_MADE','COLUMN';
EXEC SP_RENAME 'J_CAREER.fta','FREE_THROW_ATTEMPTED','COLUMN';
EXEC SP_RENAME 'J_CAREER.ftp','FREE_THROW_PERCENT','COLUMN';
EXEC SP_RENAME 'J_CAREER.OFFENSIVE-REBOUND','OFFENSIVE_REBOUND','COLUMN';
EXEC SP_RENAME 'J_CAREER.drb','DEFENSIVE_REBOUND','COLUMN';
EXEC SP_RENAME 'J_CAREER.trb','TOTAL_REBOUND','COLUMN';
EXEC SP_RENAME 'J_CAREER.ast','ASSIST','COLUMN';
EXEC SP_RENAME 'J_CAREER.stl','STEAL','COLUMN';
EXEC SP_RENAME 'J_CAREER.blk','BLOCKS','COLUMN';
EXEC SP_RENAME 'J_CAREER.tov','TURN_OVER','COLUMN';
EXEC SP_RENAME 'J_CAREER.pts','POINTS','COLUMN';
EXEC SP_RENAME 'J_CAREER.game_score','GAME_SCORE','COLUMN';
EXEC SP_RENAME 'J_CAREER.plus_minus','PLUS_MINUS','COLUMN';
```

- Inserting Aggregated Data into a New Table: 'JORDAN_STAT':
  - Created a new table 'JORDAN_STAT' and populated it with aggregated data from the existing 'J_CAREER' table.
    - Aggregated data included selected columns from 'J_CAREER' and additional information joined from the 'NBA_TEAMS' table.
```sql
SELECT * 
INTO JORDAN_STAT
FROM(
	SELECT GAME, DATE, AGE, J.TEAM, OPPONENT AS CODE_NAME,N.NAME, MATCH_PLAYED, MATCH_RESULT, FIELD_GOALS,FIELD_GOALS_ATTEMPTED,
		FIELD_GOALS_PERCENT,THREE_POINT_FIELD_GOALS, THREE_POINT_ATTEMPTED,FREE_THROW_MADE, FREE_THROW_ATTEMPTED,FREE_THROW_PERCENT,
		OFFENSIVE_REBOUND, DEFENSIVE_REBOUND,TOTAL_REBOUND,ASSIST, STEAL,BLOCKS,TURN_OVER,POINTS,POINT_DIFF, GAME_SCORE
	FROM J_CAREER J
	JOIN NBA_TEAMS N 
	ON J.OPPONENT = N.TEAM)A;
```
   
- The primary goal was to standardize column headers, ensuring a consistent naming convention across the dataset. Improved readability and clarity in column names facilitate easier interpretation and analysis.
- These data cleaning processes aimed to enhance data quality, resolve missing or inconsistent values, and introduce new columns for additional insights.
- The 'J_CAREER' table underwent a transformation with redefined column headers.
- A new table, 'JORDAN_STAT,' was created, incorporating aggregated data for further exploration of Michael Jordan's NBA career statistics.

## EXPLORATORY DATA ANALYSIS
- This involves analyzing the data to answer the following questions:
  - Longevity and Consistency
  - Scoring and Contribution
  - Playmaking
  - Defensive Impact

### Longevity and Consistency
Longevity and consistency are essential qualities that contribute to a player's overall success, legacy, and impact on the sport of basketball. 
Players who can maintain a high level of performance over an extended period often leave a lasting mark on the history of the NBA.

- Number of Seasons Played:
```sql
SELECT TEAM, COUNT(DISTINCT YEAR) AS SEASONS_PLAYED
FROM(SELECT TEAM,YEAR(DATE) AS YEAR
	FROM JORDAN_STAT)A
GROUP BY TEAM;
```

- Minutes played per game and total minutes played:
```sql
SELECT YEAR(DATE) AS SEASON, COUNT(DATE) AS MATCH_PLAYED, 
		SUM(MINUTES_PLAYED) AS TOTAL_MINUTES_PLAYED,AVG(MINUTES_PLAYED) AVG_MINUTES_PLAYED
FROM JORDAN_STAT
GROUP BY YEAR(DATE) 
ORDER BY SEASON ASC;
```

- Longevity of peak performance, indicated by years with high statistical achievements:
```sql
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
```
