package main

import (
	"log"
	"os"

	"github.com/dilly3/apply-track/handlers"
	"github.com/gin-gonic/gin"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	router := gin.Default()

	if err := router.SetTrustedProxies(nil); err != nil {
		log.Fatal(err)
	}

	router.GET("/health", handlers.Health)

	router.GET("/applications", handlers.Applications)

	log.Printf("ApplyTrack listening on port %s", port)

	if err := router.Run(":" + port); err != nil {
		log.Fatalf("server failed: %v", err)
	}
}
