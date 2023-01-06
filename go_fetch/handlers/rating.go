package handlers

import (
    _ "github.com/go-sql-driver/mysql"
	"encoding/json"
	"net/http"
	"fmt"
	"go_fetch/types"
	"go_fetch/db"
)

func RatingRoute() string {
	return "/rating"
}

func RatingHandler(writer http.ResponseWriter, request *http.Request) {
	// txid := uuid.New()
	txid := types.UUID{ID: "1234567"}
	fmt.Printf("RatingHandler | %s\n", txid.String())
	switch request.Method {
	case "GET":
		result := ratingGet()
		if result == nil {
			msg := fmt.Sprintf("%s %s failed: %s", request.Method, RatingRoute(), txid.String())
			err := types.Error{Msg: msg}
			json.NewEncoder(writer).Encode(err)
		} else {
			json.NewEncoder(writer).Encode(result)
		}
	default:
		msg := fmt.Sprintf("%s %s unavailable: %s", request.Method, RatingRoute(), txid.String())
		result := types.Error{Msg: msg}
		json.NewEncoder(writer).Encode(result)
	}
}

func ratingGet() []types.Rating {
	fmt.Println("ratingGet")
	database := db.GetInstance()
	// Execute the query
	rows, err := database.Query("SELECT series_title, chosen_by, movies_in_series, good_votes, bad_votes, total_votes, rating FROM rating_vw")
	if err != nil {
		fmt.Printf("Failed to query databse\n%s\n", err.Error())
		return nil
	}

	var ratings []types.Rating
	for rows.Next() {
		var rating types.Rating
		err = rows.Scan(&rating.Series,
			&rating.ChosenBy,
			&rating.MoviesInSeries,
			&rating.Good,
			&rating.Bad,
			&rating.Total,
			&rating.Rating)
		if err != nil {
			fmt.Printf("Failed to scan row\n%s\n", err.Error())
			return nil
		}
		ratings = append(ratings, rating)
	}

	err = rows.Err()
	if err != nil {
		fmt.Printf("Failed after row scan\n%s\n", err.Error())
		return nil
	}

	return ratings
}