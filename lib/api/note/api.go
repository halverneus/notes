package note

import "github.com/halverneus/notes/lib/web"

// Struct containing the node's handlers.
type Struct struct {
	Delete web.Handler
	Get    web.Handler
	Post   web.Handler
	Put    web.Handler
}

var (
	// API that directly points to the HTTP handlers.
	API Struct
)

func init() {
	API.Delete = Delete
	API.Get = Get
	API.Post = Post
	API.Put = Put
}
