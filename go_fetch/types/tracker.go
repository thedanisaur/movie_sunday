package types

type Tracker struct {
	ID []byte `json:"tracker_id"`
	Text string `json:"tracker_text"`
	Count int `json:"tracker_count"`
	CreatedOn string `json:"tracker_created_on"`
	UpdatedOn string `json:"tracker_updated_on"`
	CreatedBy string `json:"tracker_created_by"`
}