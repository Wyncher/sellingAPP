package repository

import (
	"database/sql"
	"selling/internal/models"
)

// Интерфейс для работы с товарами
type PCRepository interface {
	AddPC() ([]models.Product, error)
	SellPC(productName string, quantity, discount int) error
}

// Реализация интерфейса
type pcRepo struct {
	db *sql.DB
}

func NewPCRepository(db *sql.DB) PCRepository {
	return &pcRepo{db: db}
}

// Получить все товары
func (r *pcRepo) AddPC() ([]models.Product, error) {
	rows, err := r.db.Query("select * from get_parts()")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var products []models.Product
	for rows.Next() {
		var p models.Product
		if err := rows.Scan(&p.ID, &p.Name, &p.Quantity, &p.Category, &p.New, &p.Price, &p.Procurement, &p.Profit); err != nil {
			return nil, err
		}
		products = append(products, p)
	}
	return products, nil
}

// Продать товар
func (r *pcRepo) SellPC(productName string, quantity, discount int) error {
	_, err := r.db.Exec("SELECT public.sale_parts($1,$2,$3)", productName, quantity, discount)
	return err
}
