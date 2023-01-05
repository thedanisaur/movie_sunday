package types

type Ranking struct {
	Series string `json:"series"`
	ChosenBy string `json:"chosen_by"`
	MoviesInSeries int `json:"movies_in_series"`
	Good string `json:"good_votes"`
	Bad string `json:"bad_votes"`
	Total string `json:"total_votes"`
	Rating float64 `json:"rating"`
}