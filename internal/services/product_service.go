package services

import (
	"selling/internal/repository"
)

type ProductService struct {
	repo repository.ProductRepository
}

func NewProductService(repo repository.ProductRepository) *ProductService {
	return &ProductService{repo: repo}
}

// Продажа товара
func (s *ProductService) SellProduct(productName string, quantity, discount int) error {
	return s.repo.SellProduct(productName, quantity, discount)
}

// Продажа товара
func (s *ProductService) AddProduct(procurement int, price int, name string, additional string, new string, category string, quantity int) error {
	return s.repo.AddProduct(procurement, price, name, additional, new, category, quantity)
}
