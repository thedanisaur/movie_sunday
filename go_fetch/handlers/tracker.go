package handlers

import (
    _ "github.com/go-sql-driver/mysql"
	"encoding/json"
	"net/http"
	"fmt"
	"go_fetch/types"
	"go_fetch/db"
)

func TrackerRoute() string {
	return "/trackers"
}

func TrackerHandler(writer http.ResponseWriter, request *http.Request) {
	writer.Header().Set("Access-Control-Allow-Origin", "*")
	writer.Header().Set("Access-Control-Allow-Headers", "Content-Type")
	// txid := uuid.New()
	txid := types.UUID{ID: "1234567"}
	fmt.Printf("TrackerHandler | %s\n", txid.String())
	switch request.Method {
	case "GET":
		result := trackerGet()
		if result == nil {
			msg := fmt.Sprintf("%s %s failed: %s", request.Method, TrackerRoute(), txid.String())
			err := types.Error{Msg: msg}
			json.NewEncoder(writer).Encode(err)
		} else {
			json.NewEncoder(writer).Encode(result)
		}
	default:
		msg := fmt.Sprintf("%s %s unavailable: %s", request.Method, TrackerRoute(), txid.String())
		result := types.Error{Msg: msg}
		json.NewEncoder(writer).Encode(result)
	}
}

func trackerGet() []types.Tracker {
	fmt.Println("trackerGet")
	database := db.GetInstance()
	// Execute the query
	rows, err := database.Query("SELECT tracker_id, tracker_text, tracker_count, tracker_created_on, tracker_updated_on, tracker_created_by FROM trackers_vw")
	if err != nil {
		fmt.Printf("Failed to query databse\n%s\n", err.Error())
		return nil
	}

	var trackers []types.Tracker
	for rows.Next() {
		var tracker types.Tracker
		err = rows.Scan(&tracker.ID,
			&tracker.Text,
			&tracker.Count,
			&tracker.CreatedOn,
			&tracker.UpdatedOn,
			&tracker.CreatedBy)
		if err != nil {
			fmt.Printf("Failed to scan row\n%s\n", err.Error())
			return nil
		}
		trackers = append(trackers, tracker)
	}

	err = rows.Err()
	if err != nil {
		fmt.Printf("Failed after row scan\n%s\n", err.Error())
		return nil
	}

	return trackers
}