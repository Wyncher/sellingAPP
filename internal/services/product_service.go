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
