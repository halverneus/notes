part of Display;

enum Transition {
  NONE,
  FADE,
}

class Display extends ui.Div {
  var _headerBar = new ui.HeaderBar();
  var _content = new html.DivElement();
  var _menuContent = new html.DivElement();
  var _pageContent = new html.DivElement();
  var _menuCloseShield = new html.DivElement();

  async.Timer _menuCloseShieldTimer;

  var _currentPage = new ui.Page();
  ui.Menu _currentMenu;

  bool _menuOpen = false;

  Display() : super() {
    this.classes = ["display"];
    this._content.classes = ["content"];
    this._menuContent.classes = ["menu-content"];
    this._pageContent.classes = ["page-content"];
    this._menuCloseShield.classes = ["menu-close-shield"];

    this._menuCloseShield.style.opacity = "0";

    this.children..add(this._content)..add(this._headerBar.x);
    this._content.children..add(this._pageContent)..add(this._menuContent);

    this.setPage(this._currentPage);

    html.window.onResize.listen(this.handleResize);
    this._headerBar.onMenuClick.listen(this.toggleMenu);
    this._menuCloseShield.onClick.listen(this.closeMenu);
  }

  bool get menuEnabled => this._headerBar.menuEnabled;
  void set menuEnabled(bool enabled) {
    this._headerBar.menuEnabled = enabled;
    this.handleResize();
  }

  String get headerText => this._headerBar.text;
  void set headerText(String text) {
    this._headerBar.text = text;
  }

  ui.Menu get menu => this._currentMenu;
  void set menu(ui.Menu menu) {
    this._currentMenu = menu;
    this._menuContent.children = [this._currentMenu.x];
    this._currentMenu.onClick.listen(this.closeMenu);
  }

  void setPage(ui.Page page, [Transition transition = Transition.NONE]) {
    switch (transition) {
      case Transition.NONE:
        page.style.opacity = "1.0";
        this._currentPage = page;
        this._pageContent.children = [this._currentPage.x];
        break;

      case Transition.FADE:
        page.style.opacity = "0.0";
        this._currentPage.style.opacity = "1.0";
        this._pageContent.children.insert(0, page.x);
        new async.Timer(new Duration(milliseconds: 20), () {
          this._currentPage.style.opacity = "0.0";
          new async.Timer(new Duration(milliseconds: 250), () {
            this._pageContent.children.remove(this._currentPage.x);
            this._currentPage = page;
          });
        });
        break;
    }
  }

  void closeMenu([_]) {
    this._menuOpen = false;
    this.handleResize();
  }

  void openMenu([_]) {
    this._menuOpen = true;
    this.handleResize();
  }

  void toggleMenu([_]) {
    this._menuOpen = !this._menuOpen;
    this.handleResize();
  }

  void handleResize([_]) {
    if (this._menuCloseShieldTimer != null) {
      this._menuCloseShieldTimer.cancel();
      this._menuCloseShieldTimer = null;
    }

    if (html.window.innerWidth < 650 ||
        !this.menuEnabled) {
      if (this._menuOpen) {
        this._menuContent.style.left = "0px";
        this._menuContent.style.width = "42px";
        this._pageContent.style.left = "0px";
        this._pageContent.style.width = "100%";
        this._content.children.insert(1, this._menuCloseShield);
        new async.Timer(new Duration(milliseconds: 20), () {
          this._menuCloseShield.style.opacity = "1";
        });
      } else {
        if (this._currentMenu != null) {
          this._currentMenu.close();
        }
        this._menuContent.style.left = "-42px";
        this._menuContent.style.width = "42px";
        this._pageContent.style.left = "0px";
        this._pageContent.style.width = "100%";
        this._removeMenuCloseShield();
      }
    } else if (html.window.innerWidth < 900) {
      this._menuOpen = false;
      this._menuContent.style.left = "0px";
      this._menuContent.style.width = "42px";
      this._pageContent.style.left = "42px";
      this._pageContent.style.width = "calc(100% - 42px)";
      this._removeMenuCloseShield();
    } else {
      this._menuOpen = false;
      this._menuContent.style.left = "0px";
      this._menuContent.style.width = "150px";
      this._pageContent.style.left = "150px";
      this._pageContent.style.width = "calc(100% - 150px)";
      this._removeMenuCloseShield();
    }
  }

  void _removeMenuCloseShield([_]) {
    this._menuCloseShield.style.opacity = "0";
    this._menuCloseShieldTimer = new async.Timer(
      new Duration(milliseconds: 20),
      () {
        this._content.children.remove(this._menuCloseShield);
      },
    );
  }
}
