-- CS186 Project 1 (SQL) — student skeleton.
-- Replace each stub SELECT with your own query so the view matches the spec.
-- Run `python3 test.py` to check. Reference answers: reference/solution.sql.
--
-- Useful column notes for this dataset:
--   People:        playerID, nameFirst, nameLast, birthYear, weight, height
--   Pitching:      playerID, yearID, ERA
--   Batting:       playerID, yearID, AB, H, "2B", "3B", HR   (quote "2B"/"3B")
--   HallOfFame:    playerID, yearid, inducted ('Y'/'N')
--   CollegePlaying:playerID, schoolID
--   Schools:       schoolID, state          (e.g. state = 'CA')
--   Salaries:      yearID, teamID, playerID, salary
--   AllstarFull:   playerID, yearID, teamID
-- Slugging (SLG) = (H + "2B" + 2*"3B" + 3*HR) / AB   (use *1.0 for real division)

-- q0: the maximum ERA in the Pitching table.
DROP VIEW IF EXISTS q0;
CREATE VIEW q0(era) AS
  SELECT 1; -- TODO

-- q1i: players who weigh more than 300 pounds.
DROP VIEW IF EXISTS q1i;
CREATE VIEW q1i(namefirst, namelast, birthyear) AS
  SELECT NULL, NULL, NULL; -- TODO

-- q1ii: players whose first name contains a space, ordered by namefirst, namelast.
DROP VIEW IF EXISTS q1ii;
CREATE VIEW q1ii(namefirst, namelast, birthyear) AS
  SELECT NULL, NULL, NULL; -- TODO

-- q1iii: per birth year, the average height and player count, ordered by birthyear.
DROP VIEW IF EXISTS q1iii;
CREATE VIEW q1iii(birthyear, avgheight, count) AS
  SELECT NULL, NULL, NULL; -- TODO

-- q1iv: like q1iii but only birth years whose average height > 70.
DROP VIEW IF EXISTS q1iv;
CREATE VIEW q1iv(birthyear, avgheight, count) AS
  SELECT NULL, NULL, NULL; -- TODO

-- q2i: Hall of Fame inductees, ordered by yearid DESC, playerid ASC.
DROP VIEW IF EXISTS q2i;
CREATE VIEW q2i(namefirst, namelast, playerid, yearid) AS
  SELECT NULL, NULL, NULL, NULL; -- TODO

-- q2ii: HoF inductees who attended a school in California (state = 'CA').
DROP VIEW IF EXISTS q2ii;
CREATE VIEW q2ii(namefirst, namelast, playerid, schoolid, yearid) AS
  SELECT NULL, NULL, NULL, NULL, NULL; -- TODO

-- q2iii: HoF inductees with their schoolid (NULL if none), ordered playerid DESC, schoolid ASC.
DROP VIEW IF EXISTS q2iii;
CREATE VIEW q2iii(playerid, namefirst, namelast, schoolid) AS
  SELECT NULL, NULL, NULL, NULL; -- TODO

-- q3i: top 10 single-season slugging percentages (AB > 50).
DROP VIEW IF EXISTS q3i;
CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg) AS
  SELECT NULL, NULL, NULL, NULL, NULL; -- TODO

-- q3ii: top 10 lifetime slugging percentages (career AB > 50).
DROP VIEW IF EXISTS q3ii;
CREATE VIEW q3ii(playerid, namefirst, namelast, lslg) AS
  SELECT NULL, NULL, NULL, NULL; -- TODO

-- q3iii: players whose lifetime slugging exceeds Willie Mays' (mayswi01).
DROP VIEW IF EXISTS q3iii;
CREATE VIEW q3iii(namefirst, namelast, lslg) AS
  SELECT NULL, NULL, NULL; -- TODO

-- q4i: per year, the min, max and average salary, ordered by yearid.
DROP VIEW IF EXISTS q4i;
CREATE VIEW q4i(yearid, min, max, avg) AS
  SELECT NULL, NULL, NULL, NULL; -- TODO

-- q4ii: histogram of 2016 salaries in 10 equal-width bins (use the binids table).
DROP VIEW IF EXISTS q4ii;
CREATE VIEW q4ii(binid, low, high, count) AS
  SELECT NULL, NULL, NULL, NULL; -- TODO

-- q4iii: year-over-year change in min/max/avg salary (omit the first year).
DROP VIEW IF EXISTS q4iii;
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff) AS
  SELECT NULL, NULL, NULL, NULL; -- TODO

-- q4iv: the max-salary player(s) in 2000 and in 2001.
DROP VIEW IF EXISTS q4iv;
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid) AS
  SELECT NULL, NULL, NULL, NULL, NULL; -- TODO

-- q4v: per team, the salary spread (max - min) among its 2016 All-Stars.
DROP VIEW IF EXISTS q4v;
CREATE VIEW q4v(teamid, diffAvg) AS
  SELECT NULL, NULL; -- TODO
