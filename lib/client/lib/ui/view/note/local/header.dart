part of NotePageLocal;

class CreateControl extends ui.Overlay {
  final info.Data _data;

  final ui.TextInput _title = new ui.TextInput();
  ui.IconTextButton _saveBtn;

  CreateControl(info.Data this._data) : super() {
    this.style.top = "100px";
    this.style.right = "5px";

    var message = new html.DivElement();
    message.text = "Create a New Note";

    this._saveBtn = new ui.IconTextButton(
      icon: ui.Icons.ADD,
      text: "Create Note",
    );
    this._saveBtn.style.float = "right";

    this._title.text = "Title";

    this.children = [message, this._title.x, this._saveBtn.x];

    this._saveBtn.onClick.listen(this._submit);
    this._title.onKeyUp.listen(this._onKeyUp);

    this.reset();
  }

  void reset([_]) {
    this._title.value = "";
    this._saveBtn.enabled = false;
  }

  void _onKeyUp([_]) {
    this._saveBtn.enabled = (0 < this._title.value.length);
  }

  void _submit([_]) {
    String title = this._title.value;
    this._data.controller.note.add(title, "");
    this.close();
    this.reset();
  }
}

class HeaderControls extends ui.Div {
  info.Data _data;

  ui.IconTextButton _createBtn;
  CreateControl _createCtrl;

  HeaderControls(info.Data this._data) : super() {
    this._createCtrl = new CreateControl(this._data);

    this._createBtn = new ui.IconTextButton(
      icon: ui.Icons.NOTE_ADD,
      text: "New Note",
    );

    var layoutParent = new html.TableElement();
    layoutParent.style.float = "right";
    var layout = layoutParent.createTBody().addRow();
    layout.addCell().children = [this._createBtn.x];

    this.children = [layoutParent];

    this._createBtn.onClick.listen(this._createCtrl.open);
  }
}