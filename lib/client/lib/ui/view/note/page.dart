part of NotePage;

class Note extends ui.CardPage {
  final info.Data _data;

  var _notes = new Map<items.Note, local.NoteCard>();

  Note(info.Data this._data) : super(
    icon: ui.Icon(ui.Icons.INSERT_DRIVE_FILE, 32),
    text: "Notes",
  ) {
    var controls = new local.HeaderControls(this._data);
    this.setHeadingControls(controls);

    this._data.model.note.onCreate.listen(this._add);
    this._data.model.note.onDelete.listen(this._delete);

    this._populate();
  }

  void _add(items.Note note) {
    var card = new local.NoteCard(this._data, note);
    this._notes[note] = card;
    this.addCard(card);
  }

  void _delete(items.Note note) {
    var card = this._notes[note];
    if (null == card) return;

    this.removeCard(card);
    this._notes.remove(note);
  }

  void _populate() {
    for (items.Note note in this._data.model.note.notes.values) {
      this._add(note);
    }
  }
}