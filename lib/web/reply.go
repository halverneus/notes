package web

import (
	"encoding/gob"
	"encoding/json"
	"io"
)

// Reply to the client with a provided message.
type Reply struct {
	ctx      *Context
	status   int
	obj      interface{}
	streamer io.Reader
}

// Status code to be returned for the request.
func (reply *Reply) Status(status int) *Reply {
	reply.status = status
	return reply
}

// With the supplied message, reply to the client.
func (reply *Reply) With(obj interface{}) *Reply {
	if errObj, ok := obj.(error); ok {
		reply.obj = errObj.Error()
	} else {
		reply.obj = obj
	}
	return reply
}

//Stream to be copied over to client
func (reply *Reply) Stream(reader io.Reader) *Reply {
	reply.streamer = reader
	return reply
}

// Do performs the actual reply.
func (reply *Reply) Do() (err error) {
	reply.ctx.W.WriteHeader(reply.status)
	if nil != reply.streamer {
		reply.ctx.W.Header().Add("Content-type", "application/octet-stream")
		_, err = io.Copy(reply.ctx.W, reply.streamer)
		return
	}

	if nil != reply.obj {
		switch reply.ctx.encoding {
		case jsonP:
			reply.ctx.W.Header().Add("Content-type", "application/json")
			encoder := json.NewEncoder(reply.ctx.W)
			return encoder.Encode(reply.obj)
		case gobP:
			reply.ctx.W.Header().Add("Content-type", "application/gob")
			encoder := gob.NewEncoder(reply.ctx.W)
			return encoder.Encode(reply.obj)
		default: // Unknown. Try JSON.
			reply.ctx.W.Header().Add("Content-type", "application/json")
			encoder := json.NewEncoder(reply.ctx.W)
			return encoder.Encode(reply.obj)
		}
	}
	return
}
