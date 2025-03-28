package handlers

import (
	"database/sql"
	"net/http"
	"selling/internal/models"
	"selling/internal/repository"
	"selling/internal/services"
	"strconv"

	"github.com/gin-gonic/gin"
)

// Регистрация маршрутов
func SetupPCRoutes(r *gin.Engine, db *sql.DB) {
	repo := repository.NewPCRepository(db)
	service := services.NewPCService(repo)
	// Страница с компьютерами
	r.GET("/listPc", func(c *gin.Context) {
		pc, err := repo.ListPC(false)
		if err != nil {
			c.HTML(http.StatusInternalServerError, "pc_list.html", gin.H{"error": "Ошибка получения данных"})
			return
		}
		c.HTML(http.StatusOK, "pc_list.html", gin.H{"pc": pc})
	})
	// Страница с проданными компьютерами
	r.GET("/soldPc", func(c *gin.Context) {
		pc, err := repo.SoldPC()
		if err != nil {
			c.HTML(http.StatusInternalServerError, "sold_pcs.html", gin.H{"error": "Ошибка получения данных"})
			return
		}
		c.HTML(http.StatusOK, "sold_pcs.html", gin.H{"pc": pc})
	})

	// Страница с компьютерами Володи
	r.GET("/volodyaListPc", func(c *gin.Context) {
		pc, err := repo.ListPC(true)
		if err != nil {
			c.HTML(http.StatusInternalServerError, "pc_list.html", gin.H{"error": "Ошибка получения данных"})
			return
		}
		c.HTML(http.StatusOK, "pc_list.html", gin.H{"pc": pc})
	})

	// Страница добавления компьютера
	r.GET("/addPC", func(c *gin.Context) {
		gpu, err := repo.GetParts("Видеокарта")
		cpu, err := repo.GetParts("Процессор")
		mb, err := repo.GetParts("Материнская плата")
		power, err := repo.GetParts("Блок питания")
		PCcase, err := repo.GetParts("Корпус")
		cpu_fan, err := repo.GetParts("Охлаждение процессора")
		case_fan, err := repo.GetParts("Корпусный вентилятор")
		ssd, err := repo.GetParts("SSD")
		hdd, err := repo.GetParts("HDD")
		network, err := repo.GetParts("Сетевые модули")
		if err != nil {
			c.HTML(http.StatusBadRequest, "addpc.html", gin.H{"error": err.Error()})
			return
		}
		c.HTML(http.StatusOK, "addpc.html", gin.H{"gpu": gpu, "cpu": cpu, "mb": mb, "power": power, "PCcase": PCcase, "cpu_fan": cpu_fan, "case_fan": case_fan, "ssd": ssd, "hdd": hdd, "network": network})
	})
	r.POST("/addPC", func(c *gin.Context) {
		var newPC models.PC
		newPC.Gpu = c.PostForm("gpu_name")
		newPC.Cpu = c.PostForm("сpu_name")
		newPC.Mb = c.PostForm("mb_name")
		newPC.Ram1 = c.PostForm("ram1_name")
		newPC.Ram2 = c.PostForm("ram2_name")
		newPC.Ram3 = c.PostForm("ram3_name")
		newPC.Ram4 = c.PostForm("ram4_name")
		newPC.Power = c.PostForm("power_name")
		newPC.CpuFan = c.PostForm("cpu_fan_name")
		newPC.Case = c.PostForm("case_name")
		newPC.CaseFan = c.PostForm("case_fan_name")
		newPC.CaseFanCount, _ = strconv.Atoi(c.PostForm("case_fan_count"))
		newPC.Ssd1 = c.PostForm("ssd1_name")
		newPC.Ssd2 = c.PostForm("ssd2_name")
		newPC.Hdd = c.PostForm("hdd_name")
		newPC.Network = c.PostForm("network_name")
		newPC.Volodya, _ = strconv.ParseBool(c.PostForm("volodya"))
		err := service.AddPC(newPC)
		if err != nil {
			c.HTML(http.StatusBadRequest, "addpc.html", gin.H{"error": err.Error()})
			return
		}
		c.Redirect(http.StatusSeeOther, "/list_pc")
	})
	// API для продажи компьютера
	r.POST("/listPc", func(c *gin.Context) {
		pcid := c.PostForm("pcid")
		discount, _ := strconv.Atoi(c.PostForm("discount"))
		err := service.SellPC(pcid, discount)
		if err != nil {
			c.HTML(http.StatusBadRequest, "pc_list.html", gin.H{"error": err.Error()})
			return
		}
		c.Redirect(http.StatusSeeOther, "/listPc")
	})
}
