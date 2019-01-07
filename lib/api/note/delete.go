package note

import (
	"net/http"

	"github.com/halverneus/notes/lib/db"
	"github.com/halverneus/notes/lib/web"
)

// Delete a note.
func Delete(ctx *web.Context) {
	request := &db.NoteItem{}
	if err := ctx.Decode(request); nil != err {
		ctx.Reply().Status(http.StatusBadRequest).With(err).Do()
		return
	}

	if err := db.Note.Remove(request.ID); nil != err {
		if err == db.ErrNotFound {
			ctx.Reply().Status(http.StatusNotFound).With(err).Do()
		} else {
			ctx.Reply().Status(http.StatusInternalServerError).With(err).Do()
		}
		return
	}

	response := &db.NoteItems{
		Notes: []*db.NoteItem{request},
	}
	ctx.Reply().With(response).Do()
}
