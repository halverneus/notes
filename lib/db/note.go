package db

import (
	bolt "github.com/coreos/bbolt"
	"github.com/halverneus/notes/lib/db/item"
)

// NoteItems contains a list of notes. This is used outside of this package.
type NoteItems struct {
	Notes []*NoteItem `json:"notes,omitempty"`
}

// NoteItem object for interfacing with the database.
type NoteItem struct {
	ID      string `json:"id,omitempty"`
	Title   string `json:"title,omitempty"`
	Content string `json:"content,omitempty"`
}

type noteNS struct{}

// Add a note.
func (*noteNS) Add(title, content string) (note *NoteItem, err error) {
	// Get a unique ID.
	var rawID []byte
	if rawID, err = NewID(); nil != err {
		return
	}

	rawNote := &item.Note{
		Id:      rawID,
		Title:   title,
		Content: content,
	}

	var tx *bolt.Tx
	if tx, err = db.Begin(true); nil != err {
		return
	}
	defer tx.Rollback()

	if err = Note.set(tx, rawNote); nil != err {
		return
	}

	if err = tx.Commit(); nil != err {
		return
	}

	note = &NoteItem{
		ID:      ToString(rawID),
		Title:   rawNote.Title,
		Content: rawNote.Content,
	}
	return
}

// List all notes.
func (*noteNS) List() (notes []*NoteItem, err error) {
	var rawNotes []*item.Note

	err = db.View(func(tx *bolt.Tx) (err error) {
		rawNotes, err = Note.list(tx)
		return
	})
	if nil != err {
		return
	}

	for _, rawNote := range rawNotes {
		note := &NoteItem{
			ID:      ToString(rawNote.Id),
			Title:   rawNote.Title,
			Content: rawNote.Content,
		}
		notes = append(notes, note)
	}
	return
}

// Remove a note.
func (*noteNS) Remove(id string) (err error) {
	var rawID []byte
	if rawID, err = ToBytes(id); nil != err {
		return
	}

	var tx *bolt.Tx
	if tx, err = db.Begin(true); nil != err {
		return
	}
	defer tx.Rollback()

	if err = Note.remove(tx, rawID); nil != err {
		return
	}

	err = tx.Commit()
	return
}

// Update a note.
func (*noteNS) Update(note *NoteItem) (err error) {
	var rawID []byte
	if rawID, err = ToBytes(note.ID); nil != err {
		return
	}

	rawNote := &item.Note{
		Id:      rawID,
		Title:   note.Title,
		Content: note.Content,
	}

	var tx *bolt.Tx
	if tx, err = db.Begin(true); nil != err {
		return
	}
	defer tx.Rollback()

	if !Note.exists(tx, rawID) {
		err = ErrNotFound
		return
	}

	if err = Note.set(tx, rawNote); nil != err {
		return
	}

	if err = tx.Commit(); nil != err {
		return
	}
	return
}

func (*noteNS) exists(tx *bolt.Tx, id []byte) bool {
	noteBkt := tx.Bucket(get.notes.bucket)
	return 0 < len(noteBkt.Get(id))
}

func (*noteNS) list(tx *bolt.Tx) (notes []*item.Note, err error) {
	noteBkt := tx.Bucket(get.notes.bucket)
	err = noteBkt.ForEach(func(_, raw []byte) (err error) {
		note := &item.Note{}
		if err = note.Unmarshal(raw); nil != err {
			return
		}
		notes = append(notes, note)
		return
	})
	return
}

func (*noteNS) remove(tx *bolt.Tx, id []byte) (err error) {
	noteBkt := tx.Bucket(get.notes.bucket)
	return noteBkt.Delete(id)
}

func (*noteNS) set(tx *bolt.Tx, note *item.Note) (err error) {
	noteBkt := tx.Bucket(get.notes.bucket)

	var raw []byte
	if raw, err = note.Marshal(); nil != err {
		return
	}
	return noteBkt.Put(note.Id, raw)
}
