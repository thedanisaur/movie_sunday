DROP VIEW IF EXISTS movies_in_series_vw;

CREATE OR REPLACE VIEW movies_in_series_vw
AS
    SELECT  s.series_name
          , COUNT(*) AS "movies_in_series"
    FROM    series s
          , movies m
    WHERE   s.series_name = m.series_name
    GROUP BY  s.series_name
;
