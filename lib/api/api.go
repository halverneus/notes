package api

import (
	"github.com/halverneus/notes/lib/api/note"
)

var (
	// Note handlers.
	Note note.Struct
)

func init() {
	Note = note.API
}
