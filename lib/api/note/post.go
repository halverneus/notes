package note

import (
	"net/http"

	"github.com/halverneus/notes/lib/db"
	"github.com/halverneus/notes/lib/web"
)

// Post a new note.
func Post(ctx *web.Context) {
	request := &db.NoteItem{}

	if err := ctx.Decode(request); nil != err {
		ctx.Reply().Status(http.StatusBadRequest).With(err).Do()
		return
	}

	if 0 == len(request.Title) {
		msg := "'title' cannot be empty"
		ctx.Reply().Status(http.StatusBadRequest).With(msg).Do()
		return
	}

	note, err := db.Note.Add(request.Title, request.Content)
	if nil != err {
		ctx.Reply().Status(http.StatusInternalServerError).With(err).Do()
		return
	}

	response := &db.NoteItems{
		Notes: []*db.NoteItem{note},
	}
	ctx.Reply().With(response).Do()
}
