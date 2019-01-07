part of Menu;

class Menu extends ui.Div {
  int _lastY = -1;

  var _topButtons = new List<MenuItem>();
  var _bottomButtons = new List<MenuItem>();

  Menu() : super() {
    this.classes = ["menu-layout"];

    this.x.onTouchStart.listen(this._touchMove);
    this.x.onTouchMove.listen(this._touchMove);
    this.x.onTouchEnd.listen(this._touchEnd);
    html.window.onResize.listen(this.handleResize);

    new async.Timer(new Duration(milliseconds: 20), this.handleResize);
  }

  void addToTop(MenuItem button) {
    this._topButtons.add(button);
    this._setupButton(button);
    this.refresh();
  }

  void addToBottom(MenuItem button) {
    this._bottomButtons.add(button);
    this._setupButton(button);
    this.refresh();
  }

  void _setupButton(MenuItem button) {
    button.style.position = "absolute";
    button.style.left = "0px";
    button.style.width = "100%";
    button.onResize.listen(this.refresh);
    button.onClick.listen((_) {
      for (var otherButton in this._topButtons) {
        if (otherButton != button) {
          otherButton.deselect();
        }
      }
      button.select();
    });
  }

  void refresh([_]) {
    this.children.clear();

    int fromBottom = 0;
    for (var button in this._bottomButtons) {
      fromBottom += button.height;
      button.style.top = "calc(100% - " + fromBottom.toString() + "px)";
      this.children.add(button.x);
    }

    int fromTop = 0;
    for (var button in this._topButtons) {
      button.style.top = fromTop.toString() + "px";
      fromTop += button.height;
      this.children.add(button.x);
    }
  }

  void handleResize([_]) {
    if (html.window.innerWidth < 900) {
      for (var button in this._topButtons) {
        button.iconify();
      }
      for (var button in this._bottomButtons) {
        button.iconify();
      }
    } else {
      for (var button in this._topButtons) {
        button.expand();
      }
      for (var button in this._bottomButtons) {
        button.expand();
      }
    }
  }

  void _touchMove(html.TouchEvent e) {
    e.preventDefault();
    this._lastY = e.touches[0].client.y;

    for (var button in this._topButtons) {
      html.Rectangle rect = button.x.getBoundingClientRect();
      if (rect.containsPoint(new html.Point(10, this._lastY))) {
        button.showLabel();
      } else {
        button.hideLabel();
      }
    }
    for (var button in this._bottomButtons) {
      html.Rectangle rect = button.x.getBoundingClientRect();
      if (rect.containsPoint(new html.Point(10, this._lastY))) {
        button.showLabel();
      } else {
        button.hideLabel();
      }
    }
  }

  void _touchEnd(html.TouchEvent e) {
    e.preventDefault();

    for (var button in this._topButtons) {
      html.Rectangle rect = button.x.getBoundingClientRect();
      if (rect.containsPoint(new html.Point(10, this._lastY))) {
        button.click();
        return;
      }
    }
    for (var button in this._bottomButtons) {
      html.Rectangle rect = button.x.getBoundingClientRect();
      if (rect.containsPoint(new html.Point(10, this._lastY))) {
        button.click();
        return;
      }
    }
  }

  void close([_]) {
    for (var button in this._topButtons) {
      button.hideLabel();
    }
    for (var button in this._bottomButtons) {
      button.hideLabel();
    }
  }
}
