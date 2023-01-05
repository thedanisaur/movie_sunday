package handlers

import (
    _ "github.com/go-sql-driver/mysql"
	"encoding/json"
	"net/http"
	"fmt"
	"go_fetch/types"
	"go_fetch/db"
)

func RankingRoute() string {
	return "/ranking"
}

func RankingHandler(writer http.ResponseWriter, request *http.Request) {
	// txid := uuid.New()
	txid := types.UUID{ID: "1234567"}
	fmt.Printf("RankingHandler | %s\n", txid.String())
	switch request.Method {
	case "GET":
		result := rankingGet()
		if result == nil {
			msg := fmt.Sprintf("%s %s failed: %s", request.Method, RankingRoute(), txid.String())
			err := types.Error{Msg: msg}
			json.NewEncoder(writer).Encode(err)
		} else {
			json.NewEncoder(writer).Encode(result)
		}
	default:
		msg := fmt.Sprintf("%s %s unavailable: %s", request.Method, RankingRoute(), txid.String())
		result := types.Error{Msg: msg}
		json.NewEncoder(writer).Encode(result)
	}
}

func rankingGet() []types.Ranking {
	fmt.Println("rankingGet")
	database := db.GetInstance()
	// Execute the query
	rows, err := database.Query("SELECT * FROM ranking_vw")
	if err != nil {
		fmt.Printf("Failed to query databse\n%s\n", err.Error())
		return nil
	}

	var ranking []types.Ranking
	for rows.Next() {
		var rank types.Ranking
		err = rows.Scan(&rank.Series,
			&rank.ChosenBy,
			&rank.MoviesInSeries,
			&rank.Good,
			&rank.Bad,
			&rank.Total,
			&rank.Rating)
		if err != nil {
			fmt.Printf("Failed to scan row\n%s\n", err.Error())
			return nil
		}
		ranking = append(ranking, rank)
	}

	err = rows.Err()
	if err != nil {
		fmt.Printf("Failed after row scan\n%s\n", err.Error())
		return nil
	}

	return ranking
}