package services

import (
	"errors"
	"selling/internal/repository"
)

type ProductService struct {
	repo repository.ProductRepository
}

func NewProductService(repo repository.ProductRepository) *ProductService {
	return &ProductService{repo: repo}
}

// Продажа товара
func (s *ProductService) SellProduct(productID, quantity int) error {
	// Проверяем, есть ли товар в наличии
	products, err := s.repo.GetAll()
	if err != nil {
		return err
	}

	for _, p := range products {
		if p.ID == productID {
			//if p.Quantity < quantity {
			//	return errors.New("недостаточно товара на складе")
			//}
			return s.repo.SellProduct(productID, quantity)
		}
	}

	return errors.New("товар не найден")
}
