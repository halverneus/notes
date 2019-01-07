package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/julienschmidt/httprouter"

	"github.com/halverneus/notes/lib/api"
	"github.com/halverneus/notes/lib/client/serve"
	"github.com/halverneus/notes/lib/db"
	"github.com/halverneus/notes/lib/web"
)

func main() {

	if err := db.Open("notes.db"); nil != err {
		log.Fatalf("While loading database got: %v\n", err)
	}
	defer db.Close()

	router := httprouter.New()

	// Serve static content.
	fileServer := http.FileServer(serve.File)
	router.Handler("GET", "/", fileServer)
	router.Handler("GET", "/css/*filepath", fileServer)
	router.Handler("GET", "/script/*filepath", fileServer)

	// Serve API.
	router.DELETE("/api/note", web.Wrap(api.Note.Delete))
	router.GET("/api/note", web.Wrap(api.Note.Get))
	router.POST("/api/note", web.Wrap(api.Note.Post))
	router.PUT("/api/note", web.Wrap(api.Note.Put))

	// Run server.
	fmt.Println("Display available at http://localhost:8080")
	http.ListenAndServe(":8080", router)
}
