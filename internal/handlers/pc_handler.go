package handlers

import (
	"database/sql"
	"net/http"
	"selling/internal/repository"
	"selling/internal/services"
	"strconv"

	"github.com/gin-gonic/gin"
)

// Регистрация маршрутов
func SetupPCRoutes(r *gin.Engine, db *sql.DB) {
	repo := repository.NewPCRepository(db)
	service := services.NewPCService(repo)

	// Главная страница с товарами
	r.GET("/", func(c *gin.Context) {
		products, err := repo.GetAll()
		if err != nil {
			c.HTML(http.StatusInternalServerError, "index.html", gin.H{"error": "Ошибка получения данных"})
			return
		}
		c.HTML(http.StatusOK, "index.html", gin.H{"products": products})
	})

	// Страница продажи
	r.GET("/sell", func(c *gin.Context) {
		products, _ := repo.GetAll()
		c.HTML(http.StatusOK, "sell.html", gin.H{"products": products})
	})

	// API для продажи товара
	r.POST("/sell", func(c *gin.Context) {
		productName := c.PostForm("product_id")
		quantity := c.PostForm("quantity")
		discount := c.PostForm("discount")
		quantityInt, _ := strconv.Atoi(quantity)
		discountInt, _ := strconv.Atoi(discount)
		err := service.SellPC(productName, quantityInt, discountInt)
		if err != nil {
			c.HTML(http.StatusBadRequest, "sell.html", gin.H{"error": err.Error()})
			return
		}
		c.Redirect(http.StatusSeeOther, "/")
	})
}
