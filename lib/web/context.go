package web

import (
	"encoding/gob"
	"encoding/json"
	"net/http"

	"github.com/julienschmidt/httprouter"
)

type encoding uint8

const (
	unknownP encoding = iota
	jsonP
	gobP
)

// Handler is any functions that accept a context.
type Handler func(*Context)

// Context is used to encapsulate an HTTP session and to simplify interactions.
type Context struct {
	W        http.ResponseWriter
	R        *http.Request
	Params   httprouter.Params
	encoding encoding
}

// NewContext creates a new HTTP connection context.
func NewContext(w http.ResponseWriter, r *http.Request, params httprouter.Params) (ctx *Context) {
	ctx = &Context{
		W:      w,
		R:      r,
		Params: params,
	}

	switch r.Header.Get("Content-type") {
	case "application/json":
		ctx.encoding = jsonP
	case "application/gob":
		ctx.encoding = gobP
	}
	return
}

// Decode encoded request based on content type.
func (ctx *Context) Decode(v interface{}) error {
	switch ctx.encoding {
	case jsonP:
		decoder := json.NewDecoder(ctx.R.Body)
		return decoder.Decode(v)
	case gobP:
		decoder := gob.NewDecoder(ctx.R.Body)
		return decoder.Decode(v)
	default: // Unknown. Try JSON.
		decoder := json.NewDecoder(ctx.R.Body)
		return decoder.Decode(v)
	}
}

// Reply to the client.
func (ctx *Context) Reply() *Reply {
	return &Reply{
		ctx:    ctx,
		status: http.StatusOK,
	}
}
