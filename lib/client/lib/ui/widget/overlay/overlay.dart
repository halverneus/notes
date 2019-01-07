part of Overlay;

class Overlay {
  html.DivElement x = new html.DivElement();
  html.DivElement _veil = new html.DivElement();

  Overlay() {
    this._veil.classes = ["overlay-veil"];
    this.classes = [];
    this.style.opacity = "0.0";

    this._veil.onClick.listen(this.close);
  }

  html.CssClassSet get classes => this.x.classes;
  void set classes(Iterable<String> classes) {
    this.x.classes = ["overlay-contents"];
    for (var className in classes) {
      this.x.classes.add(className);
    }
  }

  html.CssStyleDeclaration get style => this.x.style;

  List<html.Element> get children => this.x.children;
  void set children(List<html.Element> children) {
    this.x.children = children;
  }

  void open([_]) {
    html.document.body.children.add(this._veil);
    html.document.body.children.add(this.x);

    new async.Timer(new Duration(milliseconds: 20), () {
      this.style.opacity = "1.0";
    });
  }

  void close([_]) {
    this.style.opacity = "0.0";
    html.document.body.children.remove(this._veil);

    new async.Timer(new Duration(milliseconds: 250), () {
      html.document.body.children.remove(this.x);
    });
  }
}