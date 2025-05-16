SELECT
    m.[Date]
    ,m.HomeTeam
    ,m.AwayTeam
    ,m.FTHG
    ,m.FTAG
    ,FTR
FROM
    FootballMatch m;


--Calculate 
--Played


--Temp tables, case when for points




SELECT TOP 5
    m.[Date]
    ,m.HomeTeam
    ,m.AwayTeam
    ,m.FTHG
    ,m.FTAG
    ,FTR
FROM
    FootballMatch m
ORDER BY
    m.[Date] DESC;



    --which dates had more than one match?
    SELECT
        [Date],
        COUNT(*) AS MatchCount
    FROM
        FootballMatch
    GROUP BY
        [Date]
    HAVING
        COUNT(*) > 1
    ORDER BY
        MatchCount DESC, [Date];

----------------------------------------------------------------------------------------------------------------------------
-----------POPULATE LEAGUE TABLE FROM MATCHES DATA

DROP TABLE if exists #EPLResults;

---Results from HOME team perspective
SELECT
    m.HomeTeam AS Team
    ,m.FTHG AS GoalsFor
    ,m.FTAG AS GoalsAgainst
    ,CASE WHEN m.FTR = 'H' THEN 'W'
    WHEN m.FTR = 'A' THEN 'L'
    WHEN m.FTR = 'D' THEN 'D'
    END AS Result
INTO #EPLResults
FROM
    FootballMatch m

    ----SIMPLE CASE STATEMENT------CASE m.FTR WHEN 'H' THEN 'W' WHEN 'D' THEN 'D' WHEN 'A' THEN 'L' END AS Result
    ----ALTERNATIVE SIMPLE CASE STATEMENT------CASE m.FTR WHEN 'H' THEN 'W' WHEN 'D' THEN 'D' ELSE 'L' END AS Result

UNION ALL

    ---Results from AWAY team perspective
SELECT
    m.AwayTeam AS Team
    ,m.FTAG AS GoalsFor
    ,m.FTHG AS GoalsAgainst
    ,CASE WHEN m.FTR = 'A' THEN 'W'
    WHEN m.FTR = 'H' THEN 'L'
    WHEN m.FTR = 'D' THEN 'D'
    END AS Result
FROM
    FootballMatch m


SELECT * FROM #EPLResults


SELECT
    r.Team
    , COUNT(*) as Played
    , sum(CASE WHEN r.Result = 'W' THEN 1 ELSE 0 END) AS Won
    , sum(CASE WHEN r.Result = 'D' THEN 1 ELSE 0 END) AS Drawn
    , sum(CASE WHEN r.Result = 'L' THEN 1 ELSE 0 END) AS Lost
    , sum(r.GoalsFor) as GoalsFor
    , sum(r.GoalsAgainst) as GoalsAgainst
    , sum(r.GoalsFor) - sum(r.GoalsAgainst) as GD

    , SUM(CASE r.Result WHEN 'W' THEN 3 WHEN 'D' THEN 1 ELSE 0 END ) as Points
from #EPLResults r
GROUP BY r.Team
ORDER BY Points DESC, GD DESC;