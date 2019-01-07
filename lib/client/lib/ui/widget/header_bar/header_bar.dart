part of HeaderBar;

class HeaderBar extends ui.Div {
  var x = new html.DivElement();

  var _menu = new ui.Icon(ui.Icons.MENU, 16);
  var _logo = new ui.KeyIcon(46);
  var _title = new html.DivElement();

  var _menuEnabled = false;
  var _menuHidden = false;

  html.ElementStream<html.MouseEvent> get onMenuClick => this._menu.onClick;

  HeaderBar() : super() {
    this.x.classes = ["header-bar"];
    this._logo.x.classes = ["logo"];
    this._menu.x.classes = ["menu"];
    this._title.classes = ["title"];

    this.x.children..add(this._menu.x)..add(this._logo.x)..add(this._title);

    html.window.onResize.listen(this.handleResize);
  }

  String get text => this._title.text;
  void set text(String text) {
    this._title.text = text;
  }

  bool get menuEnabled => this._menuEnabled;
  void set menuEnabled(bool enabled) {
    this._menuEnabled = enabled;
    this.handleResize();
  }

  void handleResize([_]) {
    if (html.window.innerWidth > 650 ||
        !this._menuEnabled) {
      this.hideMenu();
    } else {
      this.showMenu();
    }
  }

  void hideMenu([_]) {
    if (!this._menuHidden) {
      this._menuHidden = true;
      this._menu.x.style
        ..opacity = "0.0"
        ..left = "-12px";
      this._logo.x.style.marginLeft = "6px";
    }
  }

  void showMenu([_]) {
    if (this._menuHidden) {
      this._menuHidden = false;
      this._logo.x.style.marginLeft = "42px";
      new async.Timer(
        new Duration(milliseconds: 20),
        () {
          this._menu.x.style
            ..opacity = "1.0"
            ..left = "6px";
        },
      );
    }
  }
}
