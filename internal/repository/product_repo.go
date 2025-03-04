package repository

import (
	"database/sql"
	"selling/internal/models"
)

// Интерфейс для работы с товарами
type ProductRepository interface {
	GetAll() ([]models.Product, error)
	SellProduct(productID, quantity int) error
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
		if err := rows.Scan(&p.ID, &p.Price, &p.Name, &p.Additional, &p.New, &p.Category, &p.Quantity); err != nil {
			return nil, err
		}
		products = append(products, p)
	}
	return products, nil
}

// Продать товар
func (r *productRepo) SellProduct(productID, quantity int) error {
	_, err := r.db.Exec("UPDATE products SET quantity = quantity - $1 WHERE id = $2", quantity, productID)
	return err
}
