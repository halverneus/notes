package note

import (
	"net/http"

	"github.com/halverneus/notes/lib/db"
	"github.com/halverneus/notes/lib/web"
)

// Get a note.
func Get(ctx *web.Context) {
	notes, err := db.Note.List()
	if nil != err {
		ctx.Reply().Status(http.StatusInternalServerError).With(err).Do()
		return
	}

	response := &db.NoteItems{
		Notes: notes,
	}
	ctx.Reply().With(response).Do()
}
