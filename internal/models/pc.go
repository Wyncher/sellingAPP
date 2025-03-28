package models

// Структура компьютера
type PC struct {
	ID           int    `json:"id"`
	Cpu          string `json:"cpu"`
	Mb           string `json:"mb"`
	Ram1         string `json:"ram1"`
	Ram2         string `json:"ram2"`
	Ram3         string `json:"ram3"`
	Ram4         string `json:"ram4"`
	Gpu          string `json:"gpu"`
	Case         string `json:"case"`
	CaseFan      string `json:"casefan"`
	CpuFan       string `json:"cpufan"`
	CaseFanCount int    `json:"casefancount"`
	Ssd1         string `json:"ssd1"`
	Ssd2         string `json:"ssd2"`
	Hdd          string `json:"hdd"`
	Power        string `json:"power"`
	Procurement  string `json:"procurement"`
	Profit       string `json:"profit"`
	Price        string `json:"price"`
	Sold         bool   `json:"sold"`
	Network      string `json:"network"`
	Volodya      bool   `json:"volodya"`
}

// Структура записи для отображения продаж компьютеров
type SoldPcs struct {
	ID       int    `json:"id"`
	SaleDate string `json:"saledate"`
	PcID     int    `json:"pcid"`
	SaleSum  int    `json:"salesum"`
	Total    int    `json:"total"`
}

// Структура комплектующих в выпадающем списке при создании компьютера
type Parts struct {
	Name     string `json:"name"`
	Quantity string `json:"quantity"`
}
