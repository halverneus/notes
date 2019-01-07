package web

import (
	"net/http"
	"sync"

	"github.com/julienschmidt/httprouter"
)

var (
	wg *sync.WaitGroup
)

func init() {
	wg = &sync.WaitGroup{}
}

// Wrap a context handler with a HTTP handler.
func Wrap(handler func(*Context)) httprouter.Handle {
	return func(w http.ResponseWriter, r *http.Request, params httprouter.Params) {
		wg.Add(1)
		defer wg.Done()
		defer r.Body.Close()
		ctx := NewContext(w, r, params)

		handler(ctx)
	}
}

// Wait for all connections to finish.
func Wait() {
	wg.Wait()
}
