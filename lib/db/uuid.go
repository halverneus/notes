package db

import (
	"crypto/rand"
	"encoding/hex"
	"io"
)

// NewID creates a new ID.
func NewID() (id []byte, err error) {
	uuid := make([]byte, 16)
	var n int
	n, err = io.ReadFull(rand.Reader, uuid)
	if n == len(uuid) && err == nil {
		// variant bits; see section 4.1.1
		uuid[8] = uuid[8]&^0xc0 | 0x80
		// version 4 (pseudo-random); see section 4.1.3
		uuid[6] = uuid[6]&^0xf0 | 0x40
		id = uuid[:]
	}
	return
}

// ToString ...
func ToString(id []byte) string {
	return hex.EncodeToString(id)
}

// ToBytes ...
func ToBytes(id string) ([]byte, error) {
	return hex.DecodeString(id)
}
