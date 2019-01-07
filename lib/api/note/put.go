package note

import (
	"net/http"

	"github.com/halverneus/notes/lib/db"
	"github.com/halverneus/notes/lib/web"
)

// Put updates to a note.
func Put(ctx *web.Context) {
	request := &db.NoteItem{}

	if err := ctx.Decode(request); nil != err {
		ctx.Reply().Status(http.StatusBadRequest).With(err).Do()
		return
	}

	if 0 == len(request.ID) {
		msg := "'id' cannot be empty"
		ctx.Reply().Status(http.StatusBadRequest).With(msg).Do()
		return
	}

	if 0 == len(request.Title) {
		msg := "'title' cannot be empty"
		ctx.Reply().Status(http.StatusBadRequest).With(msg).Do()
		return
	}

	if err := db.Note.Update(request); nil != err {
		ctx.Reply().Status(http.StatusInternalServerError).With(err).Do()
		return
	}

	response := &db.NoteItems{
		Notes: []*db.NoteItem{request},
	}
	ctx.Reply().With(response).Do()
}
