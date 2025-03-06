package main

import (
	"github.com/gin-gonic/gin"
	"log"
	"selling/internal/database"
	"selling/internal/handlers"
)

func main() {
	// Подключение к БД
	db, err := database.ConnectDB()
	if err != nil {
		log.Fatal("Ошибка подключения к базе:", err)
	}
	defer db.Close()

	// Создаем роутер
	r := gin.Default()

	// Подключаем статику и шаблоны
	r.Static("/static", "./web/static")
	r.LoadHTMLGlob("web/templates/*")

	// Регистрируем обработчики
	handlers.SetupProductRoutes(r, db)
	handlers.SetupPCRoutes(r, db)
	// Запускаем сервер
	log.Println("Сервер запущен на порту 8080")
	r.Run(":8080")
}
