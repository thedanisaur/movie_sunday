<?php
try {
    $dbuser = 'thedanisaur';
    $dbpass = '';
    $host = 'localhost';
    $dbname='movie_sunday';
    $connection = new PDO("mysql:host=$dbhost;dbname=$dbname", $dbuser, $dbpass);
}
catch (PDOException $e) {
    echo "Error : " . $e->getMessage() . "<br/>";
    die();
}

$sql = 'SELECT series_name, pick, rnk FROM ranking_vw';
foreach ($connection->query($sql) as $row) 
{
    print $row['series_name'] . " ";
    print $row['pick'] . "-->";
    print $row['rnk'] . "<br>";
}
?>