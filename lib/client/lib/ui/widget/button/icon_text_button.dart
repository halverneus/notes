part of Button;

class IconTextButton {
  var x = new html.ButtonElement();
  ui.Icon _icon;
  html.DivElement _text = new html.DivElement();
  bool _enabled = true;
  bool _hidden = false;

  IconTextButton({String icon = ui.Icons.REMOVE, String text = ""}) {
    this.classes = ["base"];

    this._icon = new ui.Icon(icon, 16);
    this.text = text;

    var table = new html.TableElement();
    table.classes = ["fill-space"];
    var layout = table.createTBody().addRow();

    this._icon.style.pointerEvents = "none";
    this._text.style.pointerEvents = "none";

    layout.addCell()
      ..children = [this._icon.x];
    layout.addCell()
      ..children = [this._text];

    this.x.children = [table];
  }

  void get enabled => this._enabled;
  void set enabled(bool enabled) {
    this._enabled = enabled;
    if (this._enabled) {
      this.classes = ["base"];
    } else {
      this.classes = ["base", "disabled"];
    }
  }

  void set icon(String icon) {
    this._icon.icon = icon;
  }

  String get text => this._text.text;
  void set text(String text) {
    this._text.text = text;
  }

  html.CssClassSet get classes => this.x.classes;
  void set classes(Iterable<String> classes) {
    var updated = ["base"];
    for (String c in classes) updated.add(c);
    this.x.classes = updated;
  }

  html.CssStyleDeclaration get style => this.x.style;

  html.ElementStream<html.MouseEvent> get onClick => this.x.onClick;

  void click([_]) {
    this.x.click();
  }

  void hide([_]) {
    if (this._hidden) return;

    this._hidden = true;
    this.style.visibility = "hidden";
  }

  void show([_]) {
    if (!this._hidden) return;

    this._hidden = false;
    this.style.visibility = "visible";
  }
}