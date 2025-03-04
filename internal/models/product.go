package models

// Структура товара
type Product struct {
	ID         int    `json:"id"`
	Name       string `json:"name"`
	Price      string `json:"price"`
	Additional string `json:"additional"`
	Category   string `json:"category"`
	New        bool   `json:"new"`
	Quantity   int    `json:"quantity"`
}
