DROP VIEW IF EXISTS overview_vw;

CREATE OR REPLACE VIEW overview_vw
AS
    SELECT  s.total AS "series"
          , d_avg_rnk.total AS "series_dan_rating"
          , n_avg_rnk.total AS "series_nick_rating"
          , ROUND(rnk.total / s.total, 3) AS "series_average_rating"
          , m.total AS "movies"
          , ROUND(d.total / m.total * 100, 3) AS "movies_dan_likes_(%)"
          , ROUND(n.total / m.total * 100, 3) AS "movies_nick_likes_(%)"
          , ROUND((d.total + n.total) / (m.total * 2) * 100, 3) AS "movie_average_rating"
      --     , ROUND(mis_vw.total / s.total, 3) AS "average_series_length"
    FROM    ( SELECT COUNT(1) AS "total" FROM series ) s
          , ( SELECT COUNT(1) AS "total" FROM movies ) m
          , ( SELECT SUM(dan_liked) AS "total" FROM dn_ranking_vw ) d
          , ( SELECT SUM(nick_liked) AS "total" FROM dn_ranking_vw ) n
          , ( SELECT SUM(rnk) AS "total" FROM dn_ranking_vw ) rnk
          , ( SELECT ROUND(SUM(rnk) / COUNT(1), 3) AS "total" FROM dn_ranking_vw WHERE pick = 'dan' ) d_avg_rnk
          , ( SELECT ROUND(SUM(rnk) / COUNT(1), 3) AS "total" FROM dn_ranking_vw WHERE pick = 'nick' ) n_avg_rnk
          , ( SELECT SUM(movies_in_series) AS "total" FROM movies_in_series_vw ) mis_vw
;
