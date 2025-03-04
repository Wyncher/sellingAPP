package database

import (
	"database/sql"
	"fmt"
	_ "github.com/lib/pq"
)

// Функция подключения к БД
func ConnectDB() (*sql.DB, error) {
	dbUser := "postgres"
	dbPassword := "postgres"
	dbName := "selling"
	dbHost := "localhost"

	connStr := fmt.Sprintf("host=%s user=%s password=%s dbname=%s sslmode=disable", dbHost, dbUser, dbPassword, dbName)

	db, err := sql.Open("postgres", connStr)
	if err != nil {
		return nil, err
	}

	return db, nil
}
