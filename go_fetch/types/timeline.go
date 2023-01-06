package types

type Timeline struct {
	SeriesOrder int `json:"series_order"`
	SeriesTitle string `json:"series_title"`
	SeriesRank int `json:"series_rank"`
	SeriesRating string `json:"series_rating"`
	SeriesChosenBy string `json:"series_chosen_by"`
	SeriesMovies []Movie `json:"series_movies"`
}

type SeriesRating struct {
	SeriesName string `json:"series_name"`
	SeriesOrder int `json:"series_order"`
	SeriesTitle string `json:"series_title"`
	SeriesRating string `json:"series_rating"`
	SeriesChosenBy string `json:"series_chosen_by"`
}

type Movie struct {
	SeriesName string `json:"series_name"`
	MovieTitle string `json:"movie_title"`
	DanVote string `json:"dan_vote"`
	NickVote string `json:"nick_vote"`
}