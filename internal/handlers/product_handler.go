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
func SetupProductRoutes(r *gin.Engine, db *sql.DB) {
	repo := repository.NewProductRepository(db)
	service := services.NewProductService(repo)

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
	// Страница с проданными комплектующими
	r.GET("/soldParts", func(c *gin.Context) {
		parts, err := repo.SoldParts()
		if err != nil {
			c.HTML(http.StatusInternalServerError, "sold_pcs.html", gin.H{"error": "Ошибка получения данных"})
			return
		}
		c.HTML(http.StatusOK, "sold_parts.html", gin.H{"parts": parts})
	})
	// API для продажи товара
	r.POST("/sell", func(c *gin.Context) {
		productName := c.PostForm("product_id")
		quantity := c.PostForm("quantity")
		discount := c.PostForm("discount")
		quantityInt, _ := strconv.Atoi(quantity)
		discountInt, _ := strconv.Atoi(discount)
		err := service.SellProduct(productName, quantityInt, discountInt)
		if err != nil {
			c.HTML(http.StatusBadRequest, "sell.html", gin.H{"error": err.Error()})
			return
		}
		c.Redirect(http.StatusSeeOther, "/")
	})
	// Страница добавления комплектующих
	r.POST("/addParts", func(c *gin.Context) {

		if err != nil {
			c.HTML(http.StatusBadRequest, "addParts.html", gin.H{"error": err.Error()})
			return
		}
		c.HTML(http.StatusOK, "addParts.html", gin.H{})
	})
	// Страница добавления комплектующих
	r.POST("/addParts", func(c *gin.Context) {
		procurement, err := strconv.Atoi(c.PostForm("procurement"))
		price, err := strconv.Atoi(c.PostForm("price"))
		name := c.PostForm("name")
		category := c.PostForm("category")
		additional := ""
		newStatus := c.PostForm("new")
		quantity, err := strconv.Atoi(c.PostForm("quantity"))

		err = service.AddProduct(procurement, price, name, additional, newStatus, category, quantity)
		if err != nil {
			c.HTML(http.StatusBadRequest, "addParts.html", gin.H{"error": err.Error()})
			return
		}
		c.HTML(http.StatusOK, "addParts.html", gin.H{})
	})
}
