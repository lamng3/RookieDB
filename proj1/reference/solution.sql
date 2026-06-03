-- CS186 Project 1 (SQL) — REFERENCE SOLUTION (study key)
-- Generates expected_output/. Try proj1.sql yourself first, then compare here.
-- Slugging (SLG) = total bases / AB = (H + 2B + 2*3B + 3*HR) / AB.
-- Note: columns "2B" and "3B" must be quoted (they start with a digit).

DROP VIEW IF EXISTS q0;
CREATE VIEW q0(era) AS
  SELECT MAX(ERA) FROM Pitching;

DROP VIEW IF EXISTS q1i;
CREATE VIEW q1i(namefirst, namelast, birthyear) AS
  SELECT nameFirst, nameLast, birthYear FROM People WHERE weight > 300;

DROP VIEW IF EXISTS q1ii;
CREATE VIEW q1ii(namefirst, namelast, birthyear) AS
  SELECT nameFirst, nameLast, birthYear FROM People
  WHERE nameFirst LIKE '% %'
  ORDER BY nameFirst, nameLast;

DROP VIEW IF EXISTS q1iii;
CREATE VIEW q1iii(birthyear, avgheight, count) AS
  SELECT birthYear, AVG(height), COUNT(*) FROM People
  GROUP BY birthYear
  ORDER BY birthYear;

DROP VIEW IF EXISTS q1iv;
CREATE VIEW q1iv(birthyear, avgheight, count) AS
  SELECT birthYear, AVG(height), COUNT(*) FROM People
  GROUP BY birthYear
  HAVING AVG(height) > 70
  ORDER BY birthYear;

DROP VIEW IF EXISTS q2i;
CREATE VIEW q2i(namefirst, namelast, playerid, yearid) AS
  SELECT p.nameFirst, p.nameLast, p.playerID, h.yearid
  FROM People p JOIN HallOfFame h ON p.playerID = h.playerID
  WHERE h.inducted = 'Y'
  ORDER BY h.yearid DESC, p.playerID;

DROP VIEW IF EXISTS q2ii;
CREATE VIEW q2ii(namefirst, namelast, playerid, schoolid, yearid) AS
  SELECT p.nameFirst, p.nameLast, p.playerID, s.schoolID, h.yearid
  FROM People p
  JOIN HallOfFame h     ON p.playerID = h.playerID
  JOIN CollegePlaying c ON p.playerID = c.playerID
  JOIN Schools s        ON c.schoolID = s.schoolID
  WHERE h.inducted = 'Y' AND s.state = 'CA'
  GROUP BY p.playerID, s.schoolID, h.yearid
  ORDER BY h.yearid DESC, s.schoolID, p.playerID;

DROP VIEW IF EXISTS q2iii;
CREATE VIEW q2iii(playerid, namefirst, namelast, schoolid) AS
  SELECT p.playerID, p.nameFirst, p.nameLast, c.schoolID
  FROM People p
  JOIN HallOfFame h      ON p.playerID = h.playerID
  LEFT JOIN CollegePlaying c ON p.playerID = c.playerID
  WHERE h.inducted = 'Y'
  GROUP BY p.playerID, c.schoolID
  ORDER BY p.playerID DESC, c.schoolID;

DROP VIEW IF EXISTS q3i;
CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg) AS
  SELECT p.playerID, p.nameFirst, p.nameLast, b.yearID,
         (b.H + b."2B" + 2*b."3B" + 3*b.HR) * 1.0 / b.AB AS slg
  FROM People p JOIN Batting b ON p.playerID = b.playerID
  WHERE b.AB > 50
  ORDER BY slg DESC, b.yearID, p.playerID
  LIMIT 10;

DROP VIEW IF EXISTS q3ii;
CREATE VIEW q3ii(playerid, namefirst, namelast, lslg) AS
  SELECT p.playerID, p.nameFirst, p.nameLast,
         (SUM(b.H) + SUM(b."2B") + 2*SUM(b."3B") + 3*SUM(b.HR)) * 1.0 / SUM(b.AB) AS lslg
  FROM People p JOIN Batting b ON p.playerID = b.playerID
  GROUP BY p.playerID
  HAVING SUM(b.AB) > 50
  ORDER BY lslg DESC, p.playerID
  LIMIT 10;

DROP VIEW IF EXISTS q3iii;
CREATE VIEW q3iii(namefirst, namelast, lslg) AS
  SELECT p.nameFirst, p.nameLast,
         (SUM(b.H) + SUM(b."2B") + 2*SUM(b."3B") + 3*SUM(b.HR)) * 1.0 / SUM(b.AB) AS lslg
  FROM People p JOIN Batting b ON p.playerID = b.playerID
  GROUP BY p.playerID
  HAVING SUM(b.AB) > 50
     AND lslg > (
       SELECT (SUM(H) + SUM("2B") + 2*SUM("3B") + 3*SUM(HR)) * 1.0 / SUM(AB)
       FROM Batting WHERE playerID = 'mayswi01'
     );

DROP VIEW IF EXISTS q4i;
CREATE VIEW q4i(yearid, min, max, avg) AS
  SELECT yearID, MIN(salary), MAX(salary), AVG(salary)
  FROM Salaries
  GROUP BY yearID
  ORDER BY yearID;

DROP VIEW IF EXISTS q4ii;
CREATE VIEW q4ii(binid, low, high, count) AS
  WITH stats(mn, mx, w) AS (
    SELECT MIN(salary), MAX(salary), (MAX(salary) - MIN(salary)) / 10.0
    FROM Salaries WHERE yearID = 2016
  ),
  binned(binid) AS (
    SELECT MIN(9, CAST((s.salary - stats.mn) / stats.w AS INT))
    FROM Salaries s, stats
    WHERE s.yearID = 2016
  )
  SELECT b.binid,
         stats.mn + b.binid * stats.w        AS low,
         stats.mn + (b.binid + 1) * stats.w  AS high,
         COUNT(binned.binid)                 AS count
  FROM binids b
  CROSS JOIN stats
  LEFT JOIN binned ON binned.binid = b.binid
  GROUP BY b.binid, stats.mn, stats.w
  ORDER BY b.binid;

DROP VIEW IF EXISTS q4iii;
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff) AS
  SELECT cur.yearID,
         cur.mn - prev.mn, cur.mx - prev.mx, cur.av - prev.av
  FROM (SELECT yearID, MIN(salary) mn, MAX(salary) mx, AVG(salary) av
        FROM Salaries GROUP BY yearID) cur
  JOIN (SELECT yearID, MIN(salary) mn, MAX(salary) mx, AVG(salary) av
        FROM Salaries GROUP BY yearID) prev
    ON cur.yearID = prev.yearID + 1
  ORDER BY cur.yearID;

DROP VIEW IF EXISTS q4iv;
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid) AS
  SELECT p.playerID, p.nameFirst, p.nameLast, s.salary, s.yearID
  FROM Salaries s JOIN People p ON p.playerID = s.playerID
  WHERE s.yearID IN (2000, 2001)
    AND s.salary = (SELECT MAX(salary) FROM Salaries x WHERE x.yearID = s.yearID)
  ORDER BY s.yearID, p.playerID;

DROP VIEW IF EXISTS q4v;
CREATE VIEW q4v(teamid, diffAvg) AS
  SELECT a.teamID, MAX(s.salary) - MIN(s.salary)
  FROM AllstarFull a JOIN Salaries s
    ON a.playerID = s.playerID AND a.yearID = s.yearID
  WHERE a.yearID = 2016
  GROUP BY a.teamID
  ORDER BY a.teamID;
