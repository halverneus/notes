part of Page;

class Page extends ui.Div {
  var heading = new html.DivElement();
  var content = new html.DivElement();

  html.Element _iconDiv;
  html.Element _text;
  html.Element _controlsDiv;

  ui.Icon _icon;
  ui.Div _controls;

  Page({ui.Icon icon, String text}) : super() {
    var layout = new ui.HorizontalLayout();
    layout.classes.add("fill-space");

    this._iconDiv = layout.add();
    this._text = layout.add();
    this._controlsDiv = layout.add();

    this._iconDiv.classes = ["page-heading-icon"];
    this._text.classes = ["large-font"];

    this.classes = ["page"];
    this.heading.classes = ["heading"];
    this.content.classes = ["content"];

    icon = icon ?? ui.Icon(ui.Icons.HELP, 32);
    this.setHeadingIcon(icon);

    text = text ?? "Unset";
    this.setHeadingText(text);

    this.heading.children = [layout.x];
    this.children = [this.heading, this.content];
  }

  void setHeadingIcon(ui.Icon icon) {
    this._icon = icon;
    this._iconDiv.children = [this._icon.x];
  }

  void setHeadingText(String text) {
    this._text.text = text;
  }

  void setHeadingControls(ui.Div layout) {
    this._controls = layout;
    this._controlsDiv.children = [this._controls.x];
  }
}
