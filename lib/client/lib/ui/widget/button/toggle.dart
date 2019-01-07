part of Button;

class Toggle {
  var x = new html.ButtonElement();
  var _state = false;
  var _selected = ["base", "selected"];
  var _unselected = ["base", "unselected"];

  Toggle([String text = ""]) {
    this.x.text = text;
    this.x.classes = this._unselected;
    this._state = false;

    this.x.onClick.listen(this.toggle);
  }

  String get text => this.x.text;
  void set text(String text) {
    this.x.text = text;
  }

  bool get selected => this._state;

  void select(bool selected) {
    this._state = selected;
    this._updateStyle();
  }

  void toggle([_]) {
    this._state = !this._state;
    this._updateStyle();
  }

  void _updateStyle() {
    if (this._state) {
      this.x.classes = this._selected;
    } else {
      this.x.classes = this._unselected;
    }
  }
}
