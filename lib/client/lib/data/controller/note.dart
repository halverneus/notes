part of Controller;

class Note {
  final model.Model _model;

  Note(model.Model this._model) {
    request.get("api/note").then(this._handleUpdate).send();
  }

  void add(String title, String content) {
    Map value = {
      "title": title,
      "content": content,
    };
    request.post("api/note").json(value).then(this._handleUpdate).send();
  }

  void update(items.Note note, String title, String content) {
    Map value = {
      "id": note.id,
      "title": title,
      "content": content,
    };
    request.put("api/note").json(value).then(this._handleUpdate).send();
  }

  void delete(items.Note note) {
    Map value = {
      "id": note.id,
    };
    request.delete("api/note").json(value).then(this._handleDelete).send();
  }

  void _handleDelete(request.Response response) {
    if (response.logIfNotOK()) return;

    var reply = response.decode();
    List notes = reply["notes"] ?? new List<Map>();
    for (Map rawNote in notes) {
      this._delete(rawNote);
    }
  }

  void _handleUpdate(request.Response response) {
    if (response.logIfNotOK()) return;

    var reply = response.decode();
    List notes = reply["notes"] ?? new List<Map>();
    for (Map rawNote in notes) {
      this._update(rawNote);
    }
  }

  void _delete(Map msg) {
    String id = msg["id"] ?? "";

    if (id.isEmpty) return;

    this._model.note.delete(id);
  }

  void _update(Map msg) {
    String id = msg["id"] ?? "";
    String title = msg["title"] ?? "";
    String content = msg["content"] ?? "";

    if (id.isEmpty || title.isEmpty) return;

    this._model.note.update(
      id,
      title: title,
      content: content,
    );
  }
}