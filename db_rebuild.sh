mysql -u root movie_sunday < ./sql/db_destroy.sql
mysql -u root -e "CREATE SCHEMA movie_sunday CHARACTER SET utf8 COLLATE utf8_bin ;"
mysql -u root movie_sunday < ./sql/db_build.sql
mysql -u root movie_sunday < ./sql/db_populate.sql