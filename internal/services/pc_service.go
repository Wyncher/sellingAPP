package services

import (
	"selling/internal/repository"
)

type PCService struct {
	repo repository.PCRepository
}

func NewPCService(repo repository.PCRepository) *PCService {
	return &PCService{repo: repo}
}

// Продажа товара
func (s *PCService) SellPC(productName string, quantity, discount int) error {
	return s.repo.SellPC(productName, quantity, discount)
}
