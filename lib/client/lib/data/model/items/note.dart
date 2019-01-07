part of ModelItems;

class Note {
  final String id;
  String title = "";
  String content = "";

  var _updatedStream =
      new async.StreamController<Note>.broadcast(sync: true);
  var _deletedStream =
      new async.StreamController<Note>.broadcast(sync: true);
  
  async.Stream<Note> get onUpdate => this._updatedStream.stream;
  async.Stream<Note> get onDelete => this._deletedStream.stream;

  Note(String this.id) {}

  void update({String title = null, String content = null}) {
    bool updated = false;

    if (null != title && title != this.title && 0 < title.length) {
      this.title = title;
      updated = true;
    }

    if (null != content && content != this.content) {
      this.content = content;
      updated = true;
    }

    if (updated) {
      this._updatedStream.add(this);
    }
  }

  void delete() {
    this._deletedStream.add(this);
  }
}