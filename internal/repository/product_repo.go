package repository

import (
	"database/sql"
	"selling/internal/models"
)

// Интерфейс для работы с товарами
type ProductRepository interface {
	GetAll() ([]models.Product, error)
	SellProduct(productName string, quantity, discount int) error
}

// Реализация интерфейса
type productRepo struct {
	db *sql.DB
}

func NewProductRepository(db *sql.DB) ProductRepository {
	return &productRepo{db: db}
}

// Получить все товары
func (r *productRepo) GetAll() ([]models.Product, error) {
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
func (r *productRepo) SellProduct(productName string, quantity, discount int) error {
	_, err := r.db.Exec("SELECT public.sale_parts($1,$2,$3)", productName, quantity, discount)
	return err
}
