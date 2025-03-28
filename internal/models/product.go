package models

// Структура товара
type Product struct {
	ID          int    `json:"id"`
	Name        string `json:"name"`
	Procurement string `json:"procurement"`
	Profit      string `json:"profit"`
	Price       string `json:"price"`
	Additional  string `json:"additional"`
	Category    string `json:"category"`
	New         bool   `json:"new"`
	Quantity    int    `json:"quantity"`
}

// Структура записи для отображения продаж комплектующих
type SoldParts struct {
	ID       int    `json:"id"`
	SaleDate string `json:"saledate"`
	PartName string `json:"partid"`
	SaleSum  int    `json:"salesum"`
	Quantity int    `json:"quantity"`
	Discount int    `json:"discount"`
}

// Структура категорий
type Category struct {
	CategoryVal string `json:"categoryval"`
}
