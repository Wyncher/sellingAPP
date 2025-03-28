package repository

import (
	"database/sql"
	"selling/internal/models"
)

// Интерфейс для работы с товарами
type PCRepository interface {
	ListPC(volodya bool) ([]models.PC, error)
	SoldPC() ([]models.SoldPcs, error)
	SellPC(pcid string, discount int) error
	GetParts(category string) ([]models.Parts, error)
	AddPC(newPC models.PC) error
}

// Реализация интерфейса
type pcRepo struct {
	db *sql.DB
}

func NewPCRepository(db *sql.DB) PCRepository {
	return &pcRepo{db: db}
}

// Добавить компьютер
func (r *pcRepo) AddPC(newPC models.PC) error {
	_, err := r.db.Query("select * from add_pc(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", newPC.Gpu, newPC.Cpu, newPC.Mb, newPC.Ram1, newPC.Ram2, newPC.Ram3, newPC.Ram4, newPC.Power, newPC.Case, newPC.CpuFan, newPC.CaseFan, newPC.Ssd1, newPC.Ssd2, newPC.Hdd, newPC.CaseFanCount, newPC.Volodya)
	return err
}

// Получить комплектующие

func (r *pcRepo) GetParts(category string) ([]models.Parts, error) {

	rows, err := r.db.Query("select * from get_parts($1)", category)

	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var parts []models.Parts
	for rows.Next() {
		var p models.Parts
		if err := rows.Scan(&p.Name, &p.Quantity); err != nil {
			return nil, err
		}
		parts = append(parts, p)
	}
	return parts, nil
}

// Получить все проданные компьютеры
func (r *pcRepo) SoldPC() ([]models.SoldPcs, error) {
	rows, err := r.db.Query("select * from soldPcs()")

	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var soldPcs []models.SoldPcs
	for rows.Next() {
		var p models.SoldPcs
		if err := rows.Scan(&p.ID, &p.PcID, &p.SaleSum, &p.SaleDate, &p.Total); err != nil {
			return nil, err
		}
		p.SaleDate = p.SaleDate[0:10] //убираем всё кроме ГГГГ-ММ-ДД
		soldPcs = append(soldPcs, p)
	}
	return soldPcs, nil
}

// Получить все компьютеры
func (r *pcRepo) ListPC(volodya bool) ([]models.PC, error) {
	var rows *sql.Rows
	var err error
	if volodya {
		rows, err = r.db.Query("select * from get_volodya_pcs()")
	} else {
		rows, err = r.db.Query("select * from get_pcs()")
	}

	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var products []models.PC
	for rows.Next() {
		var p models.PC
		if err := rows.Scan(&p.ID, &p.Gpu, &p.Cpu, &p.CpuFan, &p.Mb, &p.Ram1, &p.Ram2, &p.Ram3, &p.Ram4, &p.Power, &p.Case, &p.CaseFan, &p.CaseFanCount, &p.Ssd1, &p.Ssd2, &p.Hdd, &p.Procurement, &p.Profit, &p.Sold); err != nil {
			return nil, err
		}
		products = append(products, p)
	}
	return products, nil
}

// Продать товар
func (r *pcRepo) SellPC(pcid string, discount int) error {
	_, err := r.db.Exec("SELECT * from sale_pc($1,$2)", pcid, discount)
	return err
}
