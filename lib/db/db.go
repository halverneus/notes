package db

import (
	"errors"
	"time"

	bolt "github.com/coreos/bbolt"
)

var (
	// Note is a null-struct namespace for note-based operations.
	Note *noteNS

	// ErrNotFound is return when anything cannot be found in the database.
	ErrNotFound = errors.New("not found")
)

var (
	db *bolt.DB

	get struct {
		notes struct {
			bucket []byte
		}
	}
)

func init() {
	get.notes.bucket = []byte("notes")
}

// Open the database.
func Open(filename string) (err error) {
	options := &bolt.Options{
		Timeout: time.Second,
	}
	if db, err = bolt.Open(filename, 0600, options); nil != err {
		return
	}
	return upgrade()
}

// Close the database.
func Close() {
	db.Close()
}

// upgrade the database to the latest schema.
func upgrade() (err error) {
	return db.Update(func(tx *bolt.Tx) (err error) {

		mk := func(name []byte) (err error) {
			_, err = tx.CreateBucketIfNotExists(name)
			return
		}

		// Create all buckets.
		if err = mk(get.notes.bucket); nil != err {
			return
		}

		return
	})
}
