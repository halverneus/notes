part of NotePageLocal;

class NoteCard extends ui.Card {
  final info.Data _data;
  final items.Note _item;

  final ui.TextInput _title = new ui.TextInput();
  final html.TextAreaElement _contents = new html.TextAreaElement();

  ui.IconTextButton _deleteBtn;
  ui.IconTextButton _saveBtn;

  NoteCard(info.Data this._data, items.Note this._item) : super() {
    this._title.text = "Title";

    this._saveBtn = new ui.IconTextButton(
      icon: ui.Icons.SAVE,
      text: "Save",
    );
    this._saveBtn.style.float = "right";
    this._saveBtn.enabled = false;

    this._deleteBtn = new ui.IconTextButton(
      icon: ui.Icons.DELETE,
      text: "Delete",
    );

    this._contents.style
      ..width = "100%"
      ..height = "260px";

    // Layouts
    var layoutParent = new html.TableElement();
    layoutParent.classes = ["fill-space"];
    var layout = layoutParent.createTBody();

    var row = layout.addRow();
    row.addCell()
      ..children = [this._title.x]
      ..colSpan = 2;
    
    row = layout.addRow();
    row.addCell()
      ..children = [this._contents]
      ..colSpan = 2;
    
    row = layout.addRow();
    row.addCell().children = [this._deleteBtn.x];
    row.addCell().children = [this._saveBtn.x];

    this.children = [layoutParent];

    // Setup events
    this._deleteBtn.onClick.listen(this._delete);
    this._saveBtn.onClick.listen(this._save);

    this._title.onKeyUp.listen(this._onKeyUp);
    this._contents.onKeyUp.listen(this._onKeyUp);

    this._item.onUpdate.listen(this._update);

    // Populate with data.
    this._update();
  }

  void _delete([_]) {
    this._data.controller.note.delete(this._item);
  }

  void _onKeyUp([_]) {
    var title = this._title.value;
    var contents = this._contents.value;

    if (0 == this._title.value.length) {
      this._saveBtn.enabled = false;
      return;
    }

    if (title == this._item.title && contents == this._item.content) {
      this._saveBtn.enabled = false;
      return;
    }

    this._saveBtn.enabled = true;
  }

  void _save([_]) {
    this._data.controller.note.update(
      this._item, 
      this._title.value,
      this._contents.value,
    );
  }

  void _update([_]) {
    this._title.value = this._item.title;
    this._contents.value = this._item.content;
    this._saveBtn.enabled = false;
  }
}