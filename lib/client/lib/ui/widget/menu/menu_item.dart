part of Menu;

class MenuItem extends ui.Div {
  int height;

  async.Stream<MenuItem> get onResize => this._resizeStream.stream;
  var _resizeStream =
      new async.StreamController<MenuItem>.broadcast(sync: true);

  MenuItem(int this.height) : super() {}

  void iconify([_]) {}
  void expand([_]) {}
  void deselect([_]) {}
  void select([_]) {}
  void showLabel([_]) {}
  void hideLabel([_]) {}
  void click([_]) {}
}

class IconMenuItem extends MenuItem {
  ui.Icon _icon;
  var _title = new html.DivElement();
  var _toolTipTitle = new html.DivElement();
  var _toolTipArrow = new html.DivElement();

  var _useToolTip = false;
  var _toolTipVisible = false;
  async.Timer _timer;

  IconMenuItem(String icon, String text) : super(40) {
    this.deselect();

    this._icon = new ui.Icon(icon, 24);
    this._icon.classes = ["icon-menu-button-icon"];

    this._title.classes = ["icon-menu-button-text"];

    this._toolTipTitle.classes = ["menu-button-tooltip-text"];
    this._toolTipArrow.classes = ["menu-button-tooltip-arrow"];

    this.children..add(this._icon.x)..add(this._title);

    this.text = text;

    this.onClick.listen(this.hideLabel);
    this.x.onMouseOver.listen(this.showLabel);
    this.x.onMouseOut.listen(this.hideLabel);
  }

  String get text => this._title.text;
  void set text(String text) {
    this._title.text = text;
    this._toolTipTitle.text = text;
  }

  void iconify([_]) {
    this._title.style.opacity = "0.0";
    this._useToolTip = true;
  }

  void expand([_]) {
    this._title.style.opacity = "1.0";
    this._useToolTip = false;
  }

  void deselect([_]) {
    this.classes = ["icon-menu-button", "menu-button-unselected"];
  }

  void select([_]) {
    this.classes = ["icon-menu-button", "menu-button-selected"];
  }

  void showLabel([_]) {
    if (!this._useToolTip || this._toolTipVisible) {
      return;
    }
    this._toolTipVisible = true;

    if (this._timer != null) {
      this._timer.cancel();
      this._timer = null;
    }

    html.document.body.children.add(this._toolTipTitle);
    html.document.body.children.add(this._toolTipArrow);

    html.Rectangle boundingRect = this.x.getBoundingClientRect();
    String top =
        ((boundingRect.top + (this.x.clientHeight ~/ 2)) - 10).toString() +
            "px";

    this._toolTipTitle.style.top = top;
    this._toolTipArrow.style.top = top;

    this._toolTipTitle.style.left = "22px";
    this._toolTipArrow.style.left = "32px";

    this._timer = new async.Timer(new Duration(milliseconds: 20), () {
      this._toolTipArrow.style.opacity = "1";
      this._toolTipTitle.style.opacity = "1";

      this._toolTipTitle.style.left = "52px";
      this._toolTipArrow.style.left = "42px";
      this._timer = null;
    });
  }

  void hideLabel([_]) {
    if (!this._toolTipVisible) {
      return;
    }
    this._toolTipVisible = false;

    if (this._timer != null) {
      this._timer.cancel();
      this._timer = null;
    }

    this._toolTipTitle.style.opacity = "0";
    this._toolTipArrow.style.opacity = "0";

    this._toolTipTitle.style.left = "22px";
    this._toolTipArrow.style.left = "32px";

    this._timer = new async.Timer(new Duration(milliseconds: 250), () {
      html.document.body.children.remove(this._toolTipArrow);
      html.document.body.children.remove(this._toolTipTitle);
      this._timer = null;
    });
  }
}
