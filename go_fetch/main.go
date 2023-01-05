package main

import (
	"net/http"
	"log"
	"go_fetch/handlers"
	"go_fetch/db"
)

func main() {
	defer db.GetInstance().Close()
	http.HandleFunc(handlers.UserRoute(), handlers.UserHandler)
	http.HandleFunc(handlers.RankingRoute(), handlers.RankingHandler)
	err := http.ListenAndServe(":1234", nil)
	if err != nil {
		log.Fatal("Error starting http server:", err)
		return
	}
}