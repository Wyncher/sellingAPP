package services

import (
	"selling/internal/models"
	"selling/internal/repository"
)

type PCService struct {
	repo repository.PCRepository
}

func NewPCService(repo repository.PCRepository) *PCService {
	return &PCService{repo: repo}
}

// Продажа компьютера
func (s *PCService) SellPC(pcid string, discount int) error {
	return s.repo.SellPC(pcid, discount)
}

// Добавление компьютера
func (s *PCService) AddPC(newPC models.PC) error {
	return s.repo.AddPC(newPC)
}
