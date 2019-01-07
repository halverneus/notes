part of Model;

class Note {
  var notes = new Map<String, items.Note>();

  var _createdStream =
      new async.StreamController<items.Note>.broadcast(sync: true);
  var _updatedStream =
      new async.StreamController<items.Note>.broadcast(sync: true);
  var _deletedStream =
      new async.StreamController<items.Note>.broadcast(sync: true);

  async.Stream<items.Note> get onCreate => this._createdStream.stream;
  async.Stream<items.Note> get onUpdate => this._updatedStream.stream;
  async.Stream<items.Note> get onDelete => this._deletedStream.stream;
  
  Note() {}

  void update(String id, {String title = null, String content = null}) {
    var item = this.notes[id];
    var exists = (null != item);

    if (!exists) {
      item = new items.Note(id);
    }

    item.update(
      title: title,
      content: content,
    );

    if (!exists) {
      this.notes[id] = item;
      item.onUpdate.listen(this._updatedStream.add);
      item.onDelete.listen(this._deletedStream.add);
      this._createdStream.add(item);
    }
  }

  void delete(String id) {
    var item = this.notes[id];
    if (null != item) {
      this.notes.remove(id);
      item.delete();
    }
  }
}
